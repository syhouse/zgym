//
//  YXSNoticePublishController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/30.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import ObjectMapper


class YXSNoticePublishController: YXSCommonPublishBaseController {
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
        self.publishType = .notice
        
        loadTemplateData()
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
        contentView.addSubview(templateSection)
        contentView.addSubview(publishView)
        contentView.addSubview(selectClassView)
        contentView.addSubview(needReceiptSwitch)
        contentView.addSubview(topSwitch)
        contentView.addSubview(synClassFileSwitch)
        
        selectClassView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        templateSection.snp.makeConstraints { (make) in
            make.top.equalTo(selectClassView.snp_bottom).offset(10)
            make.left.right.equalTo(0)
        }
        publishView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(templateSection.snp_bottom).offset(10)
        }
        
        
        topSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(publishView.snp_bottom).offset(10)
            make.height.equalTo(49)
        }
        needReceiptSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(topSwitch.snp_bottom)
            make.height.equalTo(49)
        }
        synClassFileSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(needReceiptSwitch.snp_bottom)
            make.bottom.equalTo(-kSafeBottomHeight - 18.5)
            make.height.equalTo(49)
        }
        
        needReceiptSwitch.swt.isOn = publishModel.needReceipt
        topSwitch.swt.isOn = publishModel.isTop
        synClassFileSwitch.swt.isOn = publishModel.isSynClassFile
    }
    
    // MARK: -loadData
    ///查询模版列表
    func loadTemplateData(){
        var serviceType = 0
        switch YXSPersonDataModel.sharePerson.personStage {
        case .KINDERGARTEN:
            serviceType = 0
        case .PRIMARY_SCHOOL:
            serviceType = 100
        case .MIDDLE_SCHOOL:
            serviceType = 101
        }
        YXSEducationTemplateQueryRecommendTemplateRequest(serviceType: serviceType).requestCollection({ (templateLists: [YXSTemplateListModel]) in
            self.templateLists = templateLists
            if let templateListModel = self.publishModel.templateListModel{
                for model in self.templateLists{
                    if model.id == templateListModel.id{
                        model.isSelected = true
                        break
                    }
                }
            }
            self.templateSection.setTemplates(items: self.templateLists)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    ///查询模版详情
    func loadTemplateDetialData(id: Int){
        YXSEducationTemplateQueryTemplateByIdRequest(id: id).request({ (detialModel: YXSTemplateDetialModel) in
            self.publishModel.publishText = detialModel.content
            self.publishView.setTemplateText(detialModel.content ?? "")
        }, failureHandler: { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        })
    }
    
    override func yxs_loadCommintData(mediaInfos: [[String: Any]]?){
        var fileList = [[String: Any]]()
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
        YXSEducationNoticePublishRequest.init(classIdList: classIdList, content: content, audioUrl: audioUrl, teacherName: yxs_user.name ?? "", audioDuration: publishModel.audioModels.first?.time ?? 0, videoUrl: video,bgUrl: bgUrl, imageUrl: picture,link: publishModel.publishLink ?? "", onlineCommit: needReceiptSwitch.isSelect ? 1 : 0, isTop: topSwitch.isSelect ? 1 : 0,fileList: fileList,synchClassFile: synClassFileSwitch.isSelect ? 1:0).request({ (json) in
            MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
            MBProgressHUD.yxs_showMessage(message: "发布成功", inView: self.navigationController?.view)
            self.yxs_remove()
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kTeacherPublishSucessNotification), object: nil)
            self.navigationController?.popViewController()
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: -action
    
    // MARK: -pivate
    override func save(){
        publishModel.needReceipt = needReceiptSwitch.swt.isOn
        publishModel.isTop = topSwitch.swt.isOn
        NSKeyedArchiver.archiveRootObject(publishModel, toFile: NSUtil.yxs_cachePath(file: fileName, directory: "archive"))
    }
    
    // MARK: - getter&setter
    
    lazy var needReceiptSwitch: YXSPublishSwitchLabel = {
        let onlineSwitch = YXSPublishSwitchLabel()
        onlineSwitch.titleLabel.text = "是否需要提交回执"
        return onlineSwitch
    }()
    
    lazy var topSwitch: YXSPublishSwitchLabel = {
        let topSwitch = YXSPublishSwitchLabel()
        topSwitch.titleLabel.text = "是否置顶"
        return topSwitch
    }()
    
    lazy var synClassFileSwitch: YXSPublishSwitchLabel = {
        let synClassFileSwitch = YXSPublishSwitchLabel()
        synClassFileSwitch.titleLabel.text = "文件自动同步至班级文件"
        return synClassFileSwitch
    }()
    
    lazy var templateSection: YXSPublishTemplateSection = {
        let templateSection = YXSPublishTemplateSection()
        templateSection.didSelectTemplateBlock = {
            [weak self] (model) in
            guard let strongSelf = self else { return }
            strongSelf.publishModel.templateListModel = model
            strongSelf.loadTemplateDetialData(id: model.id ?? 0)
        }
        templateSection.type = .notice
        templateSection.topControl.leftlabel.text = "通知模板"
        return templateSection
    }()
}




