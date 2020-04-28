//
//  YXSHomeworkPublishController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/25.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
import SwiftyJSON
import ObjectMapper

class YXSHomeworkPublishController: YXSCommonPublishBaseController {
    // MARK: -leftCycle
    
    /// 老师发布的作业model
    var model: YXSHomeListModel?
    
    
    /// 修改作业model
    var mySubmitModel: YXSHomeworkDetailModel?
    
    /// 作业修改成功回调
    var changeSubmitSucess: ((_ newModel:YXSHomeworkDetailModel)->())?
    
    private init(serviceId: Int?) {
        super.init(serviceId)
        saveDirectory = "homework"
        sourceDirectory = .HomeWork
        audioMaxCount = 1
    }
    
    /// 家长提交作业
    /// - Parameter model: 老师发布的作业model
    convenience init(_ model: YXSHomeListModel?) {
        self.init(serviceId:model?.serviceId)
        self.model = model
    }
    
    /// 老师发布
    convenience init() {
        self.init(serviceId: nil)
    }
    
    /// 家长修改作业使用
    /// - Parameter mySubmitModel: 家长提交的作业model
    convenience init(mySubmitModel: YXSHomeworkDetailModel?, model:YXSHomeListModel){
        self.init(serviceId: model.id)
        self.model = model
        self.mySubmitModel = mySubmitModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "作业"
        self.publishType = .homework
        YXSPersonDataModel.sharePerson.personRole == .PARENT ? yxs_setPartentUI() : yxs_setTeacherUI()
        
    }
    
    override func initPublish() {
        
        if mySubmitModel != nil{
            if let publishModel = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_cachePath(file: fileName, directory: "archive")) as? SLPublishEditModel{
                self.publishModel = publishModel
                if self.yxs_isToDay(compareDate: publishModel.homeworkDate) == .Small{
                    publishModel.homeworkDate = Date.init(timeIntervalSinceNow: 15*24*60*60)
                }
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
            if let publishModel = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_cachePath(file: fileName, directory: "archive")) as? YXSPublishModel{
                self.publishModel = publishModel
            }else{
                self.publishModel = YXSPublishModel()
                publishModel.sourceDirectory = sourceDirectory
                publishModel.isPartentSetUp = true
                publishModel.homeworkCommentAllowLook = true
                publishModel.homeworkAllowLook = true
//                let date1 = Date.init(timeIntervalSinceNow: 15*24*60*60*1000)
//                let date2 = Date.init(timeIntervalSinceNow: 15*24*60*60)
//                let date3 = Date.init(timeIntervalSince1970: 15*24*60*60*1000)
//                let date4 = Date.init(timeIntervalSince1970: 15*24*60*60)
                publishModel.homeworkDate = Date().yxs_dateByAddingMonths(months: 4)
//                publishModel.homeworkDate = Date.init(timeIntervalSinceNow: 15*24*60*60)
//                print("")
            }
        }
    }
    
    // MARK: - UI
    
    func yxs_setTeacherUI(){
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
        contentView.addSubview(commentlookSwitch)
        contentView.addSubview(homeworkLookSwitch)
        contentView.addSubview(dateSection)
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
        
        dateSection.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(publishView.snp_bottom).offset(10)
            make.height.equalTo(49)
        }
        onlineSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(dateSection.snp_bottom)
            make.height.equalTo(49)
        }
        homeworkLookSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(onlineSwitch.snp_bottom)
            make.height.equalTo(49)
        }
        commentlookSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(homeworkLookSwitch.snp_bottom)
            make.height.equalTo(49)
        }
        topSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(commentlookSwitch.snp_bottom)
            make.bottom.equalTo(-kSafeBottomHeight - 18.5)
            make.height.equalTo(49)
        }
        
        onlineSwitch.swt.isOn = publishModel.isPartentSetUp
        topSwitch.swt.isOn = publishModel.isTop
        homeworkLookSwitch.swt.isOn = publishModel.homeworkAllowLook
        commentlookSwitch.swt.isOn = publishModel.homeworkCommentAllowLook
        if publishModel.homeworkDateIsUnlimited {
            dateSection.rightLabel.text = "不限时"
        } else {
            dateSection.rightLabel.text = publishModel.homeworkDate?.toString(format: DateFormatType.custom("MM.dd HH:mm"))
        }
        dateSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
    }
    
    func yxs_setPartentUI(){
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
    override func yxs_loadCommintData(mediaInfos: [[String: Any]]?){
        var fileList = [[String: Any]]()
        var classIdList = [Int]()
        let content:String = publishModel.publishText!
        var picture: String = ""
        var video: String = ""
        var audioUrl: String = ""
        var audioUrlList: String = ""
        var audioDurationList: String = ""
        var bgUrl: String = ""
        var pictures = [String]()
        if let classs = publishModel.classs{
            for model in classs{
                classIdList.append(model.id ?? 0)
            }
        }
        if publishModel.publishFileLists.count > 0 {
            for item in publishModel.publishFileLists {
                let fileRequset = YXSHomeworkFileRequest.init(fileModel:item)
                fileList.append(fileRequset.toJSON())
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
                        let audioModel = model[modelKey] as? SLAudioModel
                        if audioUrlList.count > 0 {
                            audioUrlList += ","
                            audioDurationList += ","
                        }
                        audioUrlList.append(model[urlKey] as? String ?? "")
                        audioDurationList.append(audioModel?.time.description ?? "")
                        
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
        
        if YXSPersonDataModel.sharePerson.personRole == .PARENT{
            if let mySubmitModel = mySubmitModel{
                MBProgressHUD.yxs_showLoading(message: "提交中", inView: self.navigationController?.view)
                YXSEducationHomeworkCustodianUpdateHomeworkRequest.init(childrenId: mySubmitModel.childrenId ?? 0, homeworkId: model?.serviceId ?? 0, content: content, audioUrl: audioUrl, audioDuration: publishModel.audioModels.first?.time ?? 0, videoUrl: video,bgUrl: bgUrl, imageUrl: picture, homeworkCreateTime: model?.createTime ?? "").request({ (result) in
                    MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
                    MBProgressHUD.yxs_showMessage(message: "修改成功")
                    self.yxs_remove()
                    
                    mySubmitModel.audioUrl = audioUrl
                    mySubmitModel.content = self.publishView.textView.text
                    mySubmitModel.audioDuration = self.publishModel.audioModels.first?.time ?? 0
                    mySubmitModel.bgUrl = bgUrl
                    mySubmitModel.videoUrl = video
                    mySubmitModel.imageUrl = picture
                    
                    self.changeSubmitSucess?(mySubmitModel)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                        self.navigationController?.popViewController()
                    }
                }) { (msg, code) in
                    MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
            }else{
                MBProgressHUD.yxs_showLoading(message: "提交中", inView: self.navigationController?.view)
                YXSEducationHomeworkCustodianCommitRequest.init(id: model?.id ?? 0,childrenId: model?.childrenId ?? 0, homeworkId: model?.serviceId ?? 0, content: content, audioUrl: audioUrl, audioDuration: publishModel.audioModels.first?.time ?? 0, videoUrl: video,bgUrl: bgUrl, imageUrl: picture, homeworkCreateTime: model?.createTime ?? "").request({ (result) in
                    MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
                    MBProgressHUD.yxs_showMessage(message: "提交成功", inView: self.navigationController?.view)
                    self.yxs_remove()
                    self.model?.commitState = 2
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationModelKey:self.model])
                    UIUtil.yxs_reduceAgenda(serviceId: self.model?.serviceId ?? 0, info:[kEventKey: YXSHomeType.homework])
                    self.navigationController?.popViewController()
                }) { (msg, code) in
                    MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
            }
            
        }else{
            var shareText: String = content
            if content.count > 40{
                shareText = content.mySubString(to: 40)
            }
            MBProgressHUD.yxs_showLoading(message: "发布中", inView: self.navigationController?.view)
            YXSEducationHomeworkPublishRequest.init(classIdList: classIdList, content: content, audioUrl: audioUrl, teacherName: yxs_user.name ?? "", audioDurationList: audioDurationList, audioDuration: publishModel.audioModels.first?.time ?? 0, videoUrl: video,bgUrl: bgUrl, imageUrl: picture,link: publishModel.publishLink ?? "", onlineCommit: onlineSwitch.isSelect ? 1 : 0, isTop: topSwitch.isSelect ? 1 : 0,endTime: publishModel.homeworkDate?.toString(format: DateFormatType.custom(kCommonDateFormatString)), homeworkVisible: homeworkLookSwitch.isSelect ? 1 : 0, remarkVisible: commentlookSwitch.isSelect ? 1 : 0,fileList:fileList).request({ (result) in
                MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
                MBProgressHUD.yxs_showMessage(message: "发布成功", inView: self.navigationController?.view)
                self.yxs_remove()
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kTeacherPublishSucessNotification), object: nil)
                self.complete?(HMRequestShareModel.init(homeworkId: result["homeworkId"].intValue, homeworkCreateTime: result["createTime"].stringValue), YXSShareModel.init(title: "\(self.yxs_user.name ?? "")布置了作业", descriptionText: "\("\(result["createTime"].stringValue)".yxs_Date().toString(format: DateFormatType.custom("MM月dd日")))作业：\(shareText)", link: ""))
                self.navigationController?.popViewController()
            }) { (msg, code) in
                MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
    }
    
    // MARK: - pivate
    override func save(){
        publishModel.isPartentSetUp = onlineSwitch.swt.isOn
        publishModel.isTop = topSwitch.swt.isOn
        publishModel.homeworkCommentAllowLook = commentlookSwitch.swt.isOn
        publishModel.homeworkAllowLook = homeworkLookSwitch.swt.isOn
        NSKeyedArchiver.archiveRootObject(publishModel, toFile: NSUtil.yxs_cachePath(file: fileName, directory: "archive"))
    }
    
    // MARK: - action
    @objc func dateSectionClick(){
        view.endEditing(true)
        let maxDate = Date().yxs_dateByAddingMonths(months: 3)
        YXSDatePickerView.showDateView(publishModel.homeworkDate, maximumDate: maxDate, dateModel: .dateAndTime, title: "选择截止时间", topRightTitle: "不限时") { [weak self](date) in
            guard let strongSelf = self else { return }
            strongSelf.publishModel.homeworkDate = date
            if strongSelf.publishModel.homeworkDateIsUnlimited {
                strongSelf.dateSection.rightLabel.text = "不限时"
            } else {
                strongSelf.dateSection.rightLabel.text = date.toString(format: DateFormatType.custom("MM.dd HH:mm"))
            }
            
        }
//        YXSDatePickerView.showDateView(publishModel.homeworkDate) {[weak self]  (date) in
//            guard let strongSelf = self else { return }
//            strongSelf.publishModel.homeworkDate = date
//            strongSelf.dateSection.rightLabel.text = date.toString(format: DateFormatType.custom("MM.dd HH:mm"))
//        }
    }
    
    // MARK: - getter&setter
    
    lazy var onlineSwitch: YXSPublishSwitchLabel = {
        let onlineSwitch = YXSPublishSwitchLabel()
        onlineSwitch.titleLabel.text = "需要家长在线提交"
        return onlineSwitch
    }()
    
    lazy var topSwitch: YXSPublishSwitchLabel = {
        let topSwitch = YXSPublishSwitchLabel()
        topSwitch.titleLabel.text = "是否置顶"
        return topSwitch
    }()
    
    lazy var dateSection: SLTipsRightLabelSection = {
        let dateSection = SLTipsRightLabelSection()
        dateSection.leftlabel.text = "提交截止时间"
        dateSection.addTarget(self, action: #selector(dateSectionClick), for: .touchUpInside)
        dateSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return dateSection
    }()
    
    lazy var homeworkLookSwitch: YXSPublishSwitchLabel = {
        let topSwitch = YXSPublishSwitchLabel()
        topSwitch.titleLabel.text = "作业是否相互可见"
        return topSwitch
    }()
    
    lazy var commentlookSwitch: YXSPublishSwitchLabel = {
        let topSwitch = YXSPublishSwitchLabel()
        topSwitch.titleLabel.text = "点评是否相互可见"
        return topSwitch
    }()
}




