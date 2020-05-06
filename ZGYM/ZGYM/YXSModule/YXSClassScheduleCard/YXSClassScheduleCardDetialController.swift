//
//  ClassScheduleCardDetialController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/27.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSClassScheduleCardDetialController: YXSBaseViewController{
    var yxs_model: YXSClassScheduleCardModel?
    var yxs_childrenId: Int?
    var yxs_classId: Int?
    var yxs_updateBlock: (() -> ())?
    init(_ model: YXSClassScheduleCardModel?,childrenId:Int? = nil,classId: Int? = nil) {
        self.yxs_model = model
        self.yxs_childrenId = childrenId
        self.yxs_classId = classId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = YXSPersonDataModel.sharePerson.personStage == StageType.KINDERGARTEN ? "食谱" : "课表"
        if yxs_model == nil{
            yxs_loadData()
        }else{
            initUI()
        }
    }
    
    func initUI(){
        if yxs_model?.position == "HEADMASTER"{
            let rightButton = yxs_setRightButton(title: "设置",titleColor: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"))
            rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            rightButton.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        }
        
        view.addSubview(yxs_scheduleImage)
        view.addSubview(yxs_scheduleLabel)
        
        view.addSubview(yxs_addScheduleButton)
        view.addSubview(yxs_imageView)
        yxs_scheduleImage.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        yxs_imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.right.equalTo(view).offset(-100)
            make.size.equalTo(CGSize.init(width: 271, height: 188.5))
        }
        yxs_scheduleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(yxs_imageView.snp_bottom).offset(15.5)
        }
        yxs_addScheduleButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(yxs_scheduleLabel.snp_bottom).offset(23)
            make.size.equalTo(CGSize.init(width: 104, height: 31))
        }
        updateUI()
    }
    
    func updateUI(){
        yxs_scheduleImage.isHidden = true
        yxs_scheduleLabel.isHidden = true
        yxs_imageView.isHidden = true
        yxs_addScheduleButton.isHidden = true
        if let model = yxs_model,let imagurl = model.imageUrl{
            yxs_scheduleImage.isHidden = false
            yxs_scheduleImage.sd_setImage(with: URL.init(string: imagurl),placeholderImage: kImageDefualtImage, completed: nil)
        }else{
            yxs_imageView.isHidden = false
            yxs_scheduleLabel.isHidden = false
            if yxs_model?.position == "HEADMASTER"{
                yxs_addScheduleButton.isHidden = false
            }
        }
    }
    
    @objc func showImage(){
        YXSShowBrowserHelper.showImage(urls: [URL.init(string: yxs_model?.imageUrl ?? "")!], curruntIndex: nil)
    }
    
    // MARK: -yxs_loadData
    func yxs_loadData() {
        var request: YXSBaseRequset!
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            request = YXSEducationClassScheduleCardTeacherClassScheduleCardListRequest.init(currentPage: 1, stage: YXSPersonDataModel.sharePerson.personStage,classId:yxs_classId)
        }else{
            request = YXSEducationClassScheduleCardParentsClassScheduleCardListRequest.init(currentPage: 1, stage: YXSPersonDataModel.sharePerson.personStage,childrenId: yxs_childrenId,classId:yxs_classId)
        }
        request.requestCollection({ (list:[YXSClassScheduleCardModel]) in
            self.yxs_model = list.first
            self.initUI()
        }) { (msg, code) in
            self.view.makeToast("\(msg)")
        }
    }
    
    func yxs_loadDelectData(){
        if let model = yxs_model{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            YXSEducationTeacherDeleteClassScheduleCardRequest.init(classScheduleCardId: model.classScheduleCardId ?? 0, imageUrl: model.imageUrl ?? "").request({ (result) in
                MBProgressHUD.hide(for: self.view, animated: false)
                MBProgressHUD.yxs_showMessage(message: "删除成功")
                self.yxs_model?.imageUrl = nil
                self.updateUI()
                self.yxs_updateBlock?()
            }) { (msg, code) in
                MBProgressHUD.hide(for: self.view, animated: false)
                MBProgressHUD.yxs_showMessage(message: msg)
            }
            
        }
    }
    
    func yxs_loadSourceData(_ mediaModel: YXSMediaModel){
        YXSUploadSourceHelper().uploadImage(mediaModel: mediaModel, uploadPath: YXSUploadSourceHelper.curriculumDoucmentPath(classId: yxs_classId ?? 0), sucess: { (url) in
            self.yxs_loadPublishData(url)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    func yxs_loadPublishData(_ url: String){
        var request: YXSBaseRequset!
        if let model = yxs_model,model.imageUrl != nil{
            request = YXSEducationTeacherUpdateClassScheduleCardCardRequest.init(classScheduleCardId: model.classScheduleCardId ?? 0, imageUrl: url)
            
        }else{
            request =  YXSEducationTeacherAddClassScheduleCardRequest.init(classId: yxs_model?.classId ?? 0, imageUrl: url, teacherId: yxs_user.id ?? 0, stage: StageType.init(rawValue:yxs_model?.stage ?? "") ?? StageType.KINDERGARTEN)
        }
        request.request({ (result) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if self.yxs_model?.imageUrl == nil{
                MBProgressHUD.yxs_showMessage(message: "添加成功")
                self.yxs_model?.classScheduleCardId = result["classScheduleCardId"].intValue
            }else{
                MBProgressHUD.yxs_showMessage(message: "更新成功")
            }
            self.yxs_model?.imageUrl = url
            self.updateUI()
            self.yxs_updateBlock?()
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: false)
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: -action
    @objc func rightClick(){
        var lists = [YXSCommonBottomParams.init(title: "拍照", event: "photo"),YXSCommonBottomParams.init(title: "从相册选择", event: "select")]
        if yxs_model?.imageUrl != nil{
            lists.append(YXSCommonBottomParams.init(title: "删除", event: "delect"))
        }
        
        YXSCommonBottomAlerView.showIn(buttons: lists) { [weak self](model) in
            guard let strongSelf = self else { return }
            switch model.event {
            case "photo":
                YXSSelectMediaHelper.shareHelper.takePhoto()
                YXSSelectMediaHelper.shareHelper.delegate = strongSelf
            case "select":
                YXSSelectMediaHelper.shareHelper.pushImagePickerController(mediaStyle: SLSelectMediaStyle.onlyImage, showTakePhoto: false, maxCount: 1)
                YXSSelectMediaHelper.shareHelper.delegate = strongSelf
            case "delect":
                strongSelf.yxs_loadDelectData()
            default:
                break
            }
        }
    }
    
    lazy var yxs_scheduleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.addTaget(target: self, selctor: #selector(showImage))
        return imageView
    }()
    
    lazy var yxs_scheduleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        label.text = "暂无\(YXSPersonDataModel.sharePerson.personStage == StageType.KINDERGARTEN ? "食谱" : "课程安排")"
        return label
    }()
    
    lazy var yxs_addScheduleButton: YXSButton = {
        let goRemindButton = YXSButton()
        goRemindButton.setTitle("添加\(YXSPersonDataModel.sharePerson.personStage == StageType.KINDERGARTEN ? "食谱" : "课表")", for: .normal)
        goRemindButton.setTitleColor(kBlueColor, for: .normal)
        goRemindButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        goRemindButton.borderWidth = 1
        goRemindButton.borderColor = kBlueColor
        goRemindButton.cornerRadius = 15.5
        goRemindButton.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        return goRemindButton
    }()
    
    lazy var yxs_imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.mixedImage = MixedImage(normal: "yxs_empty_classScheduleCard", night: "yxs_empty_classScheduleCard_night")
        return imageView
    }()
}


extension YXSClassScheduleCardDetialController: YXSSelectMediaHelperDelegate{
    func didSelectMedia(asset: YXSMediaModel) {
        yxs_loadSourceData(asset)
    }
    
    func didSelectSourceAssets(assets: [YXSMediaModel]) {
        if let asset = assets.first{
            yxs_loadSourceData(asset)
        }
    }
}
