//
//  SLNoticePublishController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/30.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit


class SLNoticePublishController: SLCommonPublishBaseController {
    // MARK: -leftCycle
    init(){
        super.init(nil)
        saveDirectory = "notice"
        sourceDirectory = .notice
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "通知"
        setTeacherUI()
    }
    
    // MARK: -UI
    func setTeacherUI(){
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        // 添加容器视图
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view) // 确定的宽度，因为垂直滚动
        }
        contentView.addSubview(publishView)
        contentView.addSubview(selectClassView)
        contentView.addSubview(needReceiptSwitch)
        contentView.addSubview(topSwitch)

        
        selectClassView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        publishView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(selectClassView.snp_bottom).offset(10)
        }
        
        
        topSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(publishView.snp_bottom).offset(10)
            make.height.equalTo(49)
        }
        needReceiptSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(topSwitch.snp_bottom)
            make.bottom.equalTo(-kSafeBottomHeight - 18.5)
            make.height.equalTo(49)
        }
        
        needReceiptSwitch.swt.isOn = publishModel.needReceipt
        topSwitch.swt.isOn = publishModel.isTop
    }
    
    // MARK: -loadData
    override func sl_loadCommintData(mediaInfos: [[String: Any]]?){
        var classIdList = [Int]()
        let content:String = publishModel.publishText!
        var picture: String = ""
        var video: String = ""
        var audioUrl: String = ""
        var pictures = [String]()
        var bgUrl: String = ""
        if let classs = publishModel.classs{
            for model in classs{
                classIdList.append(model.id ?? 0)
            }
        }
        
        if let mediaInfos = mediaInfos{
            for model in mediaInfos{
                if let type = model[typeKey] as? SourceNameType{
                    if type == .video{
                        video = model[urlKey] as? String ?? ""
                    }else if type == .image{
                        pictures.append(model[urlKey] as? String ?? "")
                    }else if type == .voice{
                        audioUrl = model[urlKey] as? String ?? ""
                    }else if type == .firstVideo{
                        bgUrl = model[urlKey] as? String ?? ""
                    }
                }
            }
            
        }
        if pictures.count > 0{
            picture = pictures.joined(separator: ",")
        }
        MBProgressHUD.sl_showLoading(message: "发布中")
        SLEducationNoticePublishRequest.init(classIdList: classIdList, content: content, audioUrl: audioUrl, teacherName: sl_user.name ?? "", audioDuration: publishModel.audioModels.first?.time ?? 0, videoUrl: video,bgUrl: bgUrl, imageUrl: picture,link: publishModel.publishLink ?? "", onlineCommit: needReceiptSwitch.isSelect ? 1 : 0, isTop: topSwitch.isSelect ? 1 : 0).request({ (json) in
            MBProgressHUD.sl_showMessage(message: "发布成功")
            self.sl_remove()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kTeacherPublishSucessNotification), object: nil)
                self.navigationController?.popViewController()
            }
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: -action
    
    // MARK: -pivate
    override func save(){
        publishModel.needReceipt = needReceiptSwitch.swt.isOn
        publishModel.isTop = topSwitch.swt.isOn
        NSKeyedArchiver.archiveRootObject(publishModel, toFile: NSUtil.sl_cachePath(file: fileName, directory: "archive"))
    }
    
    // MARK: - getter&setter
    
    lazy var needReceiptSwitch: SLPublishSwitchLabel = {
        let onlineSwitch = SLPublishSwitchLabel()
        onlineSwitch.titleLabel.text = "是否需要提交回执"
        return onlineSwitch
    }()
    
    lazy var topSwitch: SLPublishSwitchLabel = {
        let topSwitch = SLPublishSwitchLabel()
        topSwitch.titleLabel.text = "是否置顶"
        return topSwitch
    }()
}




