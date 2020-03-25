//
//  SLHomeworkPublishController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/25.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit


class SLHomeworkPublishController: SLCommonPublishBaseController {
    // MARK: -leftCycle
    
    /// 提交作业详情
    var model: SLHomeListModel?
    
    var mySubmitModel: SLHomeworkDetailModel?
    
    private init(serviceId: Int?) {
        super.init(serviceId)
        saveDirectory = "homework"
        sourceDirectory = .HomeWork
        audioMaxCount = 5
    }
    
    /// 家长提交作业
    /// - Parameter model: 老师发布的作业model
    convenience init(_ model: SLHomeListModel?) {
        self.init(serviceId:model?.serviceId)
        self.model = model
    }
    
    /// 老师发布
    convenience init() {
        self.init(serviceId: nil)
    }
    
    /// 家长修改作业使用
    /// - Parameter mySubmitModel: 家长提交的作业model
    convenience init(mySubmitModel: SLHomeworkDetailModel?){
        self.init(serviceId: mySubmitModel?.id)
        self.mySubmitModel = mySubmitModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "作业"
        
        SLPersonDataModel.sharePerson.personRole == .PARENT ? sl_setPartentUI() : sl_setTeacherUI()
        
    }
    
    override func initPublish() {
        
        if mySubmitModel != nil{
            if let publishModel = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.sl_cachePath(file: fileName, directory: "archive")) as? SLPublishEditModel{
                self.publishModel = publishModel
            }else{
                //初始化资源
                self.publishModel = SLPublishEditModel()
                publishModel.sourceDirectory = sourceDirectory
                var publishMedias = [SLPublishMediaModel]()
                if let videoUrl = mySubmitModel?.videoUrl,videoUrl.count != 0{
                    let mediaModel = SLPublishMediaModel()
                    mediaModel.serviceUrl = videoUrl
                    mediaModel.showImageUrl = mySubmitModel?.bgUrl
                    publishMedias.append(mediaModel)
                }
                
                if let imageUrl = mySubmitModel?.imageUrl,imageUrl.count != 0{
                    let images = imageUrl.split(separator: ",")
                    for imageStr in images{
                        let mediaModel = SLPublishMediaModel()
                        mediaModel.serviceUrl = String(imageStr)
                        publishMedias.append(mediaModel)
                    }
                }
                
                publishModel.medias = publishMedias
                
                //设置音频(当前只设置一个)
                if let audioUrl = mySubmitModel?.audioUrl, audioUrl.count != 0{
                    let audioModel = SLAudioModel()
                    audioModel.servicePath = audioUrl
                    audioModel.time = mySubmitModel?.audioDuration ?? 0
                    publishModel.audioModels = [audioModel]
                }
                
                //                audioUrl  audioDuration
                publishModel.publishText = mySubmitModel?.content
                
                
            }
        }else{
            if let publishModel = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.sl_cachePath(file: fileName, directory: "archive")) as? SLPublishModel{
                self.publishModel = publishModel
            }else{
                self.publishModel = SLPublishModel()
                publishModel.sourceDirectory = sourceDirectory
            }
        }
    }
    
    // MARK: - UI
    
    func sl_setTeacherUI(){
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
        contentView.addSubview(onlineSwitch)
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
        
        
        onlineSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(publishView.snp_bottom).offset(10)
            make.height.equalTo(49)
        }
        topSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(onlineSwitch.snp_bottom)
            make.bottom.equalTo(-kSafeBottomHeight - 18.5)
            make.height.equalTo(49)
        }
        
        onlineSwitch.swt.isOn = publishModel.isPartentSetUp
        topSwitch.swt.isOn = publishModel.isTop
    }
    
    func sl_setPartentUI(){
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
        
        publishView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(10)
            make.bottom.equalTo(-kSafeBottomHeight - 18.5)
        }
    }
    
    // MARK: -loadData
    override func sl_loadCommintData(mediaInfos: [[String: Any]]?){
        var classIdList = [Int]()
        let content:String = publishModel.publishText!
        var picture: String = ""
        var video: String = ""
        var audioUrl: String = ""
        var bgUrl: String = ""
        var pictures = [String]()
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
        if SLPersonDataModel.sharePerson.personRole == .PARENT{
            if let mySubmitModel = mySubmitModel{
                
            }else{
                MBProgressHUD.sl_showLoading(message: "提交中")
                SLEducationHomeworkCustodianCommitRequest.init(id: model?.id ?? 0,childrenId: model?.childrenId ?? 0, homeworkId: model?.serviceId ?? 0, content: content, audioUrl: audioUrl, audioDuration: publishModel.audioModels.first?.time ?? 0, videoUrl: video,bgUrl: bgUrl, imageUrl: picture, homeworkCreateTime: model?.createTime ?? "").request({ (result) in
                    MBProgressHUD.sl_showMessage(message: "提交成功")
                    self.sl_remove()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.model?.commitState = 2
                        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationModelKey:self.model])
                        UIUtil.sl_reduceAgenda(serviceId: self.model?.serviceId ?? 0, info:[kEventKey: HomeType.homework])
                        self.navigationController?.popViewController()
                    }
                }) { (msg, code) in
                    MBProgressHUD.sl_showMessage(message: msg)
                }
            }
            
        }else{
            var shareText: String = content
            if content.count > 40{
                shareText = content.mySubString(to: 40)
            }
            MBProgressHUD.sl_showLoading(message: "发布中")
            SLEducationHomeworkPublishRequest.init(classIdList: classIdList, content: content, audioUrl: audioUrl, teacherName: sl_user.name ?? "", audioDuration: publishModel.audioModels.first?.time ?? 0, videoUrl: video,bgUrl: bgUrl, imageUrl: picture,link: publishModel.publishLink ?? "", onlineCommit: onlineSwitch.isSelect ? 1 : 0, isTop: topSwitch.isSelect ? 1 : 0).request({ (result) in
                MBProgressHUD.sl_showMessage(message: "发布成功")
                self.sl_remove()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kTeacherPublishSucessNotification), object: nil)
                    self.complete?(HMRequestShareModel.init(homeworkId: result["homeworkId"].intValue, homeworkCreateTime: result["createTime"].stringValue), SLShareModel.init(title: "\(self.sl_user.name ?? "")布置了作业", descriptionText: "\("\(result["createTime"].stringValue)".sl_Date().toString(format: DateFormatType.custom("MM月dd日")))作业：\(shareText)", link: ""))
                    self.navigationController?.popViewController()
                }
            }) { (msg, code) in
                MBProgressHUD.sl_showMessage(message: msg)
            }
        }
    }
    
    // MARK: - pivate
    override func save(){
        publishModel.isPartentSetUp = onlineSwitch.swt.isOn
        publishModel.isTop = topSwitch.swt.isOn
        NSKeyedArchiver.archiveRootObject(publishModel, toFile: NSUtil.sl_cachePath(file: fileName, directory: "archive"))
    }
    
    // MARK: - getter&setter
    
    lazy var onlineSwitch: SLPublishSwitchLabel = {
        let onlineSwitch = SLPublishSwitchLabel()
        onlineSwitch.titleLabel.text = "需要家长在线提交"
        return onlineSwitch
    }()
    
    lazy var topSwitch: SLPublishSwitchLabel = {
        let topSwitch = SLPublishSwitchLabel()
        topSwitch.titleLabel.text = "是否置顶"
        return topSwitch
    }()
}




