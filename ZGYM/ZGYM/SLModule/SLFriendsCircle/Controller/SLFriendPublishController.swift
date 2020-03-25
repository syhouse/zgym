//
//  SLFriendPublishController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/16.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import Photos
import TZImagePickerController
import YBImageBrowser


class SLFriendPublishController: SLCommonPublishBaseController {
    // MARK: -leftCycle
    var medias: [SLMediaModel]
    init(_ model: SLHomeListModel? = nil, medias: [SLMediaModel] = [SLMediaModel]()) {
        self.medias = medias
        super.init(nil)
        saveDirectory = "friend"
        sourceDirectory = .friend
        isFriendSelectClass = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if medias.count != 0 {
            var publishMedias = [SLPublishMediaModel]()
            for model in medias{
                let publishMedia = SLPublishMediaModel()
                publishMedia.asset = model.asset
                publishMedias.append(publishMedia)
            }
            self.publishModel.medias = publishMedias
        }
        self.publishModel.isFriendCiclePublish = true
        sl_setUI()
    }
    
    // MARK: -UI
    
    func sl_setUI(){
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
        contentView.addSubview(noCommentSwitch)
        
        selectClassView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        publishView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(selectClassView.snp_bottom).offset(10)
        }
        
        
        noCommentSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(publishView.snp_bottom).offset(10)
            make.bottom.equalTo(-kSafeBottomHeight - 18.5)
            make.height.equalTo(49)
        }
        
        noCommentSwitch.swt.isOn = publishModel.noComment
    }

    // MARK: -loadData
    override func sl_loadCommintData(mediaInfos: [[String: Any]]?){
        var classIdList = [Int]()
        let content:String = publishModel.publishText!
        var picture: String = ""
        var video: String = ""
        var pictures = [String]()
        var childrenId: Int? = nil
        
        if SLPersonDataModel.sharePerson.personRole == .PARENT{
            childrenId = publishModel.classs.first?.childrenId
        }
        
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
                        video += kHMVedioAppendKey
                    }else if type == .image{
                        pictures.append(model[urlKey] as? String ?? "")
                    }
                }
            }
            
        }
        if pictures.count > 0{
            picture = pictures.joined(separator: ",")
        }
        let attachment = video.count > 0 ? video : (picture.count > 0 ? picture : nil)
        MBProgressHUD.sl_showLoading(message: "发布中")
        SLEducationClassCirclePublishRequest.init(gradeIds: classIdList, content: content, noComment: noCommentSwitch.isSelect ? NoComment.YES : .NO, attachment: attachment,childrenId: childrenId).request({ (result) in
            MBProgressHUD.sl_showMessage(message: "发布成功")
            self.sl_remove()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                var isHome = true
                for vc in self.navigationController!.viewControllers{
                    if vc is SLFriendsCircleController{
                        if let SLFriendsCircleController = vc as? SLFriendsCircleController{
                            isHome = false
                            SLFriendsCircleController.sl_refreshData()
                            break
                        }
                    }
                }
                if isHome{
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kTeacherPublishSucessNotification), object: nil)
                }
                self.navigationController?.popViewController()
            }
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: -action
    
    // MARK: -pivate
    override func save(){
        publishModel.noComment = noCommentSwitch.swt.isOn
        NSKeyedArchiver.archiveRootObject(publishModel, toFile: NSUtil.sl_cachePath(file: fileName, directory: "archive"))
    }
    
    // MARK: - getter&setter
    
    lazy var noCommentSwitch: SLPublishSwitchLabel = {
        let noCommentSwitch = SLPublishSwitchLabel()
        noCommentSwitch.titleLabel.text = "禁止评论"
        return noCommentSwitch
    }()
}




