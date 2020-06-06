//
//  YXSSolitaireApplyPublishController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/1.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import NightNight

class YXSSolitaireApplyPublishController: YXSSolitaireNewPublishBaseController {
    init(){
        super.init(nil)
        saveDirectory = "Solitaire_apply"
        sourceDirectory = .solitaire
        isSelectSingleClass = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "报名接龙"
        setApplyUI()
    }
    
    
    // MARK: -UI
    func setApplyUI(){
        touchView.addSubview(scrollView)
        touchView.addSubview(footerSettingView)
        footerSettingView.snp.makeConstraints { (make) in
            make.height.equalTo(60 + kSafeBottomHeight)
            make.bottom.left.right.equalTo(0)
        }
        scrollView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.bottom.equalTo(-60 - kSafeBottomHeight)
        }
        // 添加容器视图
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view) // 确定的宽度，因为垂直滚动
        }
        contentView.addSubview(publishView)
        contentView.addSubview(selectClassView)
        
        let lineView = UIView()
        lineView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "F2F5F9"), night: kNightBackgroundColor)
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(10)
        }
        
        selectClassView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        
        let lineView1 = UIView()
        lineView1.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "F2F5F9"), night: kNightBackgroundColor)
        contentView.addSubview(lineView1)
        lineView1.snp.makeConstraints { (make) in
            make.top.equalTo(selectClassView.snp_bottom)
            make.left.right.equalTo(0) 
            make.height.equalTo(10)
        }
        
        contentView.addSubview(subjectField)
        subjectField.snp.makeConstraints { (make) in
            make.top.equalTo(selectClassView.snp_bottom).offset(10)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        
        publishView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(subjectField.snp_bottom)
            make.bottom.equalTo(0)
        }
        publishView.yxs_addLine()
        
        publishView.setTemplateText(publishModel.publishContent ?? "")
        subjectField.text =  publishModel.subjectText
    }
    
    
    // MARK: -loadData
    override func yxs_loadClassDataSucess(){
        loadClassCountData()
    }
    
    override func yxs_loadCommintData(mediaInfos: [[String: Any]]?){
        var classIdList = [Int]()
        var picture: String = ""
        var video: String = ""
        var audioUrl: String = ""
        var pictures = [String]()
        var bgUrl: String = ""
        var options = [String]()
        
        if let classs = publishModel.classs{
            for model in classs{
                classIdList.append(model.id ?? 0)
            }
        }
        
        for model in selectView.selectModels{
            options.append(model.title ?? "")
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
        MBProgressHUD.yxs_showLoading(message: "发布中", inView: self.navigationController?.view)
        YXSCensusV1TeacherPublishEnterRequest.init(classIdList: classIdList, content: publishView.getTextContent(), title: subjectField.text ?? "", audioUrl: audioUrl, audioDuration: publishModel.audioModels.first?.time ?? 0, videoUrl: video, bgUrl: bgUrl, imageUrl: picture, link: publishModel.publishLink ?? "",commitUpperLimit: publishModel.commitUpperLimit ?? 0, endTime: publishModel.solitaireDate!.toString(format: DateFormatType.custom("yyyy-MM-dd HH:mm:ss")), isTop: publishModel.isTop ? 1 : 0).request({ (result) in
            MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
            MBProgressHUD.yxs_showMessage(message: "发布成功", inView: self.navigationController?.view)
            self.yxs_remove()
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kTeacherPublishSucessNotification), object: nil)
            self.publishSucessPop()
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
}
