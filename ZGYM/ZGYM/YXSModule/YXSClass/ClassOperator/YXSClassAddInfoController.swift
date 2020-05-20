//
//  YXSClassAddInfoController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/22.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//


import UIKit
import MBProgressHUD
import NightNight

class YXSClassAddInfoController: YXSBaseViewController {
    let isTeacherRole: Bool
    let gradeId: Int
    var childModel: YXSChildrenModel?
    var stage: StageType
    /// 孩子头像
    var headerUrl: String?
    
    /// 自己操作成功push
    var doSucessPush: (() -> ())?
    
    
    /// 初始化
    /// - Parameters:
    ///   - isTeacherRole: 是否是添加老师
    ///   - gradeId: 班级id
    ///   - childModel:   孩子model
    init(_ isTeacherRole: Bool, gradeId: Int, stage: StageType,childModel: YXSChildrenModel? = nil) {
        self.childModel = childModel
        self.isTeacherRole = isTeacherRole
        self.gradeId = gradeId
        self.stage = stage
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        
        title = "填写入班信息"
        
        if isDebug{
            studentNameField.text = "李五"
        }
        
        isTeacherRole ? initTeacherUI() : initParentUI()
        
    }
    
    // MARK: -UI
    func initTeacherUI(){
        view.addSubview(subjectSection)
        view.addSubview(joinClassButton)
        
        subjectSection.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(10)
            make.height.equalTo(49)
        }
        joinClassButton.snp.makeConstraints { (make) in
            make.left.equalTo(28.5)
            make.right.equalTo(-28.5)
            make.top.equalTo(subjectSection.snp_bottom).offset(42)
            make.height.equalTo(49)
        }
    }
    
    func initParentUI(){
        view.addSubview(studentNameField)
        view.addSubview(studentNameLabel)
        view.addSubview(avarSection)
        view.addSubview(studentNumberField)
        view.addSubview(studentNumberLabel)
        view.addSubview(roleSection)
        view.addSubview(joinClassButton)
        studentNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(18.5)
        }
        studentNameField.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(studentNameLabel.snp_bottom).offset(13)
            make.height.equalTo(49)
        }
        avarSection.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(studentNameField.snp_bottom).offset(13)
            make.height.equalTo(56)
        }
        studentNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(avarSection.snp_bottom).offset(18.5)
        }
        studentNumberField.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(studentNumberLabel.snp_bottom).offset(13)
            make.height.equalTo(49)
        }
        roleSection.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(studentNumberField.snp_bottom).offset(10)
            make.height.equalTo(49)
        }
        joinClassButton.snp.makeConstraints { (make) in
            make.left.equalTo(28.5)
            make.right.equalTo(-28.5)
            make.top.equalTo(roleSection.snp_bottom).offset(42)
            make.height.equalTo(49)
        }
        
        if let childModel = childModel{
            studentNameField.text = childModel.realName
            studentNameField.isEnabled = false
            
            studentNumberField.text = childModel.studentId
            studentNumberField.isEnabled = false
        }
    }
    
    // MARK: -loadData
    func loadJoinRequest(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        YXSEducationGradeMemberJoinRequest.init(gradeId: gradeId, position: isTeacherRole ? PersonRole.TEACHER : PersonRole.PARENT,subject: selectSubject?.paramsKey ?? "",childrenId: childModel?.id, relationship: selectRelationship?.paramsKey ?? "", realName: studentNameField.text!, studentId: studentNumberField.text!,avatar: headerUrl).request({ (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            YXSCommonAlertView.showAlert(title: "提示", message: "加入班级成功！", rightTitle: "确认", rightClick: {
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kAddClassSucessNotification), object: nil)
                for  vc in self.navigationController!.viewControllers{
                    if vc is YXSRegisterSucessController{
                        let popVc = vc as! YXSRegisterSucessController
                        self.navigationController?.popToViewController(popVc, animated: true)
                        popVc.yxs_successToRootVC()
                        return
                        
                    }else if vc is YXSTeacherClassListViewController{
                        let popVc = vc as! YXSTeacherClassListViewController
                        popVc.yxs_refreshData()
                        self.navigationController?.popToViewController(popVc, animated: true)
                        return
                    }else if vc is YXSParentClassListViewController{
                        let popVc = vc as! YXSParentClassListViewController
                        popVc.yxs_refreshData()
                        self.navigationController?.popToViewController(popVc, animated: true)
                        return
                    }
                }
                if let doSucessPush = self.doSucessPush{
                    doSucessPush()
                }else{
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            })
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: true)
            let errors = [YXSClassAddErrorModel].init(JSONString: msg)
            if let errors = errors{
                let errorModel = errors.first
                var relationships = [String]()
                for error in errors{
                    relationships.append(error.relationship ?? "")
                }
                
                if let errorModel = errorModel{
                    if errorModel.account != nil{
                        errorModel.relationships = relationships
                        let vc = YXSClassRepeatController.init(errorModel: errorModel)
                        vc.cheakReuslt = {
                            [weak self](sucess: Bool) in
                            guard let strongSelf = self else { return }
                            if sucess{//同一孩子  提交孩子
                                let chidlModel = YXSChildrenModel.init(JSON: ["" : ""])
                                chidlModel?.id = errorModel.childrenId
                                strongSelf.childModel = chidlModel
                                //身份冲突
                                if errorModel.relationships?.contains(strongSelf.selectRelationship?.paramsKey ?? "") ?? false{
                                    MBProgressHUD.yxs_showMessage(message: "请重新选择身份")
                                }else{
                                    strongSelf.loadJoinRequest()
                                }
                            }else{//不同身份 新增孩子
                                strongSelf.childModel = nil
                                strongSelf.studentNameField.isEnabled = true
                            }
                        }
                        self.navigationController?.pushViewController(vc)
                        return
                    }
                }
            }

            self.view.makeToast(msg)
        }
    }
    
    // MARK: -action
    @objc func textChange(_ field: UITextField){
        if field == studentNameField{//名字限制长度10
            if studentNameField.text!.count > 10{
                studentNameField.text = studentNameField.text?.mySubString(to: 10)
            }
        }
    }
    
    @objc func joinClassClick(){
        if isTeacherRole{
            if subjectSection.rightLabel.text == "请选择"{
                view.makeToast("请选择学科")
                return
            }
        }else{
            if studentNameField.text!.count == 0 {
                view.makeToast("请输入真实姓名")
                return
            }
            if roleSection.rightLabel.text == "请选择"{
                view.makeToast("请选择身份")
                return
            }
        }
        
        loadJoinRequest()
    }
    
    var selectSubject: YXSSelectSectionModel!
    @objc func selectSubjectClick(){
        let subjcts = YXSCommonSubjcts()
        YXSSelectAlertView.showAlert(subjcts, selectSubject,title: "选择学科") { [weak self](model) in
            guard let strongSelf = self else { return }
            strongSelf.selectSubject = model
            strongSelf.subjectSection.rightLabel.text = strongSelf.selectSubject.text
            strongSelf.subjectSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        }
    }
    var selectRelationship: YXSSelectSectionModel!
    @objc func roleSelectClick(){
        YXSSelectAlertView.showAlert(Relationships, selectSubject,title: "选择关系") { [weak self](model) in
            guard let strongSelf = self else { return }
            strongSelf.selectRelationship = model
            strongSelf.roleSection.rightLabel.text = strongSelf.selectRelationship.text
            strongSelf.roleSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        }
    }
    
    @objc func selectHeaderImage(){
        YXSSelectMediaHelper.shareHelper.showSelectMedia(selectImage: true)
         YXSSelectMediaHelper.shareHelper.delegate = self
    }
    
    // MARK: -private
    @objc func requestUploadImage(asset: YXSMediaModel) {
        MBProgressHUD.yxs_showLoading(inView: self.view)
        YXSUploadSourceHelper().uploadImage(mediaModel: asset, storageType: YXSStorageType.avatar, sucess: {(successUrl) in
            MBProgressHUD.yxs_hideHUDInView(view: self.view)
            self.headerUrl = successUrl
            self.avarSection.imgAvatar.image = asset.thumbnailImage
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    // MARK: -public
    
    
    // MARK: - getter&setter
    lazy var studentNameLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        label.text = "学生姓名"
        return label
    }()
    
    lazy var studentNumberLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        label.text = "学号"
        return label
    }()
    
    lazy var studentNameField: YXSQSTextField = {
        let classField = UIUtil.yxs_getTextField(UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0), placeholder: "请输入真实姓名", placeholderColor: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: UIColor.white))
        classField.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        classField.addTarget(self, action: #selector(textChange), for: .editingChanged)
        return classField
    }()
    
    lazy var studentNumberField: YXSQSTextField = {
        let classField = UIUtil.yxs_getTextField(UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0), placeholder: "请输入孩子学号", placeholderColor: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: UIColor.white))
        classField.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        classField.addTarget(self, action: #selector(textChange), for: .editingChanged)
        return classField
    }()
    
    lazy var avarSection: SLTipsRightImageSection = {
        let avarSection = SLTipsRightImageSection()
        avarSection.leftlabel.text = "孩子头像(选填)"
        avarSection.imgAvatar.image = kImageUserIconStudentDefualtImage
        avarSection.imgAvatar.addTaget(target: self, selctor: #selector(selectHeaderImage))
        return avarSection
    }()
    
    lazy var roleSection: SLTipsRightLabelSection = {
        let subjectSection = SLTipsRightLabelSection()
        subjectSection.leftlabel.text = "您是孩子的"
        subjectSection.rightLabel.text = "请选择"
        subjectSection.addTarget(self, action: #selector(roleSelectClick), for: .touchUpInside)
        subjectSection.yxs_addLine(color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"),leftMargin: 15, lineHeight: 0.5)
        return subjectSection
    }()
    
    
    lazy var subjectSection: SLTipsRightLabelSection = {
        let subjectSection = SLTipsRightLabelSection()
        subjectSection.leftlabel.text = "任教学科"
        subjectSection.rightLabel.text = "请选择"
        subjectSection.addTarget(self, action: #selector(selectSubjectClick), for: .touchUpInside)
        subjectSection.yxs_addLine(color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"),leftMargin: 15, lineHeight: 0.5)
        return subjectSection
    }()
    
    
    lazy var joinClassButton: YXSButton = {
        
        let joinClassButton = YXSButton.init(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49))
        joinClassButton.setTitleColor(UIColor.white, for: .normal)
        joinClassButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        joinClassButton.addTarget(self, action: #selector(joinClassClick), for: .touchUpInside)
        joinClassButton.yxs_gradualBackground(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 57, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        joinClassButton.yxs_shadow(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 57, height: 49), color: UIColor(red: 0.3, green: 0.45, blue: 0.96, alpha: 0.5), cornerRadius:  24.5, offset: CGSize(width: 0, height: 3))
        joinClassButton.setTitle("加入班级", for: .normal)
        
        return joinClassButton
    }()
}


extension YXSClassAddInfoController: YXSSelectMediaHelperDelegate{
    // MARK: - ImgSelectDelegate
    func didSelectMedia(asset: YXSMediaModel) {
        requestUploadImage(asset: asset)
    }
    
    /// 选中多个图片资源
    /// - Parameter assets: models
    func didSelectSourceAssets(assets: [YXSMediaModel]) {
        requestUploadImage(asset: assets.first ?? YXSMediaModel())
    }
}
