//
//  ClassScheduleCardDetialController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/27.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import YBImageBrowser
import NightNight

class SLClassScheduleCardDetialController: SLBaseViewController{
    var model: SLClassScheduleCardModel?
    var childrenId: Int?
    var classId: Int?
    var updateBlock: (() -> ())?
    init(_ model: SLClassScheduleCardModel?,childrenId:Int? = nil,classId: Int? = nil) {
        self.model = model
        self.childrenId = childrenId
        self.classId = classId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = SLPersonDataModel.sharePerson.personStage == StageType.KINDERGARTEN ? "食谱" : "课表"
        if model == nil{
            loadData()
        }else{
            initUI()
        }
    }
    
    func initUI(){
        if model?.position == "HEADMASTER"{
            let rightButton = sl_setRightButton(title: "设置",titleColor: UIColor.sl_hexToAdecimalColor(hex: "#575A60"))
            rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            rightButton.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        }
        
        view.addSubview(scheduleImage)
        view.addSubview(scheduleLabel)
        
        view.addSubview(addScheduleButton)
        view.addSubview(imageView)
        scheduleImage.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.right.equalTo(view).offset(-100)
            make.size.equalTo(CGSize.init(width: 271, height: 188.5))
        }
        scheduleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(imageView.snp_bottom).offset(15.5)
        }
        addScheduleButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(scheduleLabel.snp_bottom).offset(23)
            make.size.equalTo(CGSize.init(width: 104, height: 31))
        }
        updateUI()
    }
    
    func updateUI(){
        scheduleImage.isHidden = true
        scheduleLabel.isHidden = true
        imageView.isHidden = true
        addScheduleButton.isHidden = true
        if let model = model,let imagurl = model.imageUrl{
            scheduleImage.isHidden = false
            scheduleImage.sd_setImage(with: URL.init(string: imagurl),placeholderImage: kImageDefualtImage, completed: nil)
        }else{
            imageView.isHidden = false
            scheduleLabel.isHidden = false
            if model?.position == "HEADMASTER"{
                addScheduleButton.isHidden = false
            }
        }
    }
    
    @objc func showImage(){
        let browser = YBImageBrowser()
        let imgData = YBIBImageData()
        imgData.imageURL = URL.init(string: model?.imageUrl ?? "")
        browser.dataSourceArray.append(imgData)
        browser.show()
    }
    
    // MARK: -loadData
    func loadData() {
        var request: SLBaseRequset!
        if SLPersonDataModel.sharePerson.personRole == .TEACHER{
            request = SLEducationClassScheduleCardTeacherClassScheduleCardListRequest.init(currentPage: 1, stage: SLPersonDataModel.sharePerson.personStage,classId:classId)
        }else{
            request = SLEducationClassScheduleCardParentsClassScheduleCardListRequest.init(currentPage: 1, stage: SLPersonDataModel.sharePerson.personStage,childrenId: childrenId,classId:classId)
        }
        request.requestCollection({ (list:[SLClassScheduleCardModel]) in
            self.model = list.first
            self.initUI()
        }) { (msg, code) in
            self.view.makeToast("\(msg)")
        }
    }
    
    func loadDelectData(){
        if let model = model{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            SLEducationTeacherDeleteClassScheduleCardRequest.init(classScheduleCardId: model.classScheduleCardId ?? 0, imageUrl: model.imageUrl ?? "").request({ (result) in
                MBProgressHUD.hide(for: self.view, animated: false)
                MBProgressHUD.sl_showMessage(message: "删除成功")
                self.model?.imageUrl = nil
                self.updateUI()
                self.updateBlock?()
            }) { (msg, code) in
                MBProgressHUD.hide(for: self.view, animated: false)
                MBProgressHUD.sl_showMessage(message: msg)
            }
            
        }
    }
    
    func loadSourceData(_ mediaModel: SLMediaModel){
        SLUploadSourceHelper().uploadImage(mediaModel: mediaModel, sucess: { (url) in
            self.loadPublishData(url)
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    func loadPublishData(_ url: String){
        var request: SLBaseRequset!
        if let model = model,model.imageUrl != nil{
            request = SLEducationTeacherUpdateClassScheduleCardCardRequest.init(classScheduleCardId: model.classScheduleCardId ?? 0, imageUrl: url)
            
        }else{
            request =  SLEducationTeacherAddClassScheduleCardRequest.init(classId: model?.classId ?? 0, imageUrl: url, teacherId: sl_user.id ?? 0, stage: StageType.init(rawValue:model?.stage ?? "") ?? StageType.KINDERGARTEN)
        }
        request.request({ (result) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if self.model?.imageUrl == nil{
                MBProgressHUD.sl_showMessage(message: "添加成功")
                self.model?.classScheduleCardId = result["classScheduleCardId"].intValue
            }else{
                MBProgressHUD.sl_showMessage(message: "更新成功")
            }
            self.model?.imageUrl = url
            self.updateUI()
            self.updateBlock?()
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: false)
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: -action
    @objc func rightClick(){
        var lists = [SLCommonBottomParams.init(title: "拍照", event: "photo"),SLCommonBottomParams.init(title: "从相册选择", event: "select")]
        if model?.imageUrl != nil{
            lists.append(SLCommonBottomParams.init(title: "删除", event: "delect"))
        }
        
        SLCommonBottomAlerView.showIn(buttons: lists) { [weak self](model) in
            guard let strongSelf = self else { return }
            switch model.event {
            case "photo":
                SLSelectMediaHelper.shareHelper.takePhoto()
                SLSelectMediaHelper.shareHelper.delegate = strongSelf
            case "select":
                SLSelectMediaHelper.shareHelper.pushImagePickerController(mediaStyle: SLSelectMediaStyle.onlyImage, showTakePhoto: false, maxCount: 1)
                SLSelectMediaHelper.shareHelper.delegate = strongSelf
            case "delect":
                strongSelf.loadDelectData()
            default:
                break
            }
        }
    }
    
    lazy var scheduleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.addTaget(target: self, selctor: #selector(showImage))
        return imageView
    }()
    
    lazy var scheduleLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#C4CDDA")
        label.text = "暂无\(SLPersonDataModel.sharePerson.personStage == StageType.KINDERGARTEN ? "食谱" : "课程安排")"
        return label
    }()
    
    lazy var addScheduleButton: SLButton = {
        let goRemindButton = SLButton()
        goRemindButton.setTitle("添加\(SLPersonDataModel.sharePerson.personStage == StageType.KINDERGARTEN ? "食谱" : "课表")", for: .normal)
        goRemindButton.setTitleColor(kBlueColor, for: .normal)
        goRemindButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        goRemindButton.borderWidth = 1
        goRemindButton.borderColor = kBlueColor
        goRemindButton.cornerRadius = 15.5
        goRemindButton.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        return goRemindButton
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.mixedImage = MixedImage(normal: "sl_empty_classScheduleCard", night: "sl_empty_classScheduleCard_night")
        return imageView
    }()
}


extension SLClassScheduleCardDetialController: SLSelectMediaHelperDelegate{
    func didSelectMedia(asset: SLMediaModel) {
        loadSourceData(asset)
    }
    
    func didSelectSourceAssets(assets: [SLMediaModel]) {
        if let asset = assets.first{
            loadSourceData(asset)
        }
    }
}
