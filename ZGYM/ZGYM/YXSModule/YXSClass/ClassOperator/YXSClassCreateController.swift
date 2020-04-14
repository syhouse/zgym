//
//  YXSClassCreateController.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/21.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import MBProgressHUD
import NightNight

class YXSClassCreateController: YXSBaseViewController {
    
    /// 自己操作成功push
    var doSucessPush: (() -> ())?
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        
        title = "创建班级"
        initUI()
    }
    
    // MARK: -UI
    func initUI(){
        view.addSubview(headerLabel)
        view.addSubview(classField)
        view.addSubview(subjectSection)
        view.addSubview(schoolSection)
        view.addSubview(finishCreateButton)
        
        
        headerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(18.5)
        }
        classField.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(headerLabel.snp_bottom).offset(13)
            make.height.equalTo(49)
        }
        subjectSection.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(classField.snp_bottom).offset(10)
            make.height.equalTo(49)
        }
        schoolSection.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(subjectSection.snp_bottom)
            make.height.equalTo(49)
        }
        finishCreateButton.snp.makeConstraints { (make) in
            make.left.equalTo(28.5)
            make.right.equalTo(-28.5)
            make.top.equalTo(schoolSection.snp_bottom).offset(42)
            make.height.equalTo(49)
        }
    }
    
    // MARK: -loadData
    
    // MARK: -action
    
    @objc func finishClick(){
        if classField.text!.count == 0 {
            view.makeToast("请输入班级名称")
            return
        }
        if subjectSection.rightLabel.text == "请选择"{
            view.makeToast("请选择学科")
            return
        }
        
        if schoolSection.rightLabel.text == "请选择"{
            view.makeToast("请选择院校")
            return
        }
        
        if schoolSection.rightLabel.text?.isBlank ?? true{
            view.makeToast("院校不能为空")
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        YXSEducationGradeCreateRequest.init(name: classField.text!, school: schoolSection.rightLabel.text!, subject: selectSubject.paramsKey,stage: YXSPersonDataModel.sharePerson.personStage).request({ (json) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.navigationController?.view.makeToast("创建成功")
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kCreateClassSucessNotification), object: nil)
            
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
                }
            }
            
            if let doSucessPush = self.doSucessPush{
                doSucessPush()
            }else{
               self.navigationController?.popViewController()
            }
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast("\(msg)")
        }
    }
    var selectSubject: YXSSelectSectionModel!
    @objc func selectSubjectClick(){
        var subjcts = YXSCommonSubjcts
        if YXSPersonDataModel.sharePerson.personStage == .KINDERGARTEN{
            subjcts.insert(YXSSelectSectionModel.init("幼教", "PRESCHOOL_EDUCATION"), at: 0)
        }
        YXSSelectAlertView.showAlert(subjcts, selectSubject,title: "选择学科") { [weak self](model) in
            guard let strongSelf = self else { return }
            strongSelf.selectSubject = model
            strongSelf.subjectSection.rightLabel.text = strongSelf.selectSubject.text
            strongSelf.subjectSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        }
    }
    
    @objc func selectSchoolClick(){
        //        showAlert(title: "selectSchoolClick")
        
        
        
        let vc = YXSAmapLoactionViewController()
        vc.completionHandler = {[weak self](coordinate, name) in
            guard let weakSelf = self else {return}
            if name.count > 0 {
                weakSelf.schoolSection.rightLabel.text = name
                weakSelf.schoolSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
                vc.navigationController?.popViewController()
            }
        }
        self.navigationController?.pushViewController(vc)
    }
    
    // MARK: -private
    
    // MARK: -public
    
    
    // MARK: - getter&setter
    lazy var headerLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        label.text = "班级信息"
        return label
    }()
    
    lazy var classField: YXSQSTextField = {
        let classField = UIUtil.yxs_getTextField(UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0), placeholder: "请输入班级名称", placeholderColor: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: UIColor.white))
        classField.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        classField.delegate = self
        //        classField.addTarget(self, action: #selector(classChange), for: .editingChanged)
        return classField
    }()
    
    lazy var subjectSection: SLTipsRightLabelSection = {
        let subjectSection = SLTipsRightLabelSection()
        subjectSection.leftlabel.text = "任教学科"
        subjectSection.rightLabel.text = "请选择"
        subjectSection.addTarget(self, action: #selector(selectSubjectClick), for: .touchUpInside)
        subjectSection.yxs_addLine(color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"),leftMargin: 15, lineHeight: 0.5)
        return subjectSection
    }()
    
    lazy var schoolSection: SLTipsRightLabelSection = {
        let schoolSection = SLTipsRightLabelSection()
        schoolSection.leftlabel.text = "所属院校"
        schoolSection.rightLabel.text = "请选择"
        schoolSection.addTarget(self, action: #selector(selectSchoolClick), for: .touchUpInside)
        return schoolSection
    }()
    
    lazy var finishCreateButton: YXSButton = {
        
        let finishCreateButton = YXSButton.init(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49))
        finishCreateButton.setTitleColor(UIColor.white, for: .normal)
        finishCreateButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        finishCreateButton.addTarget(self, action: #selector(finishClick), for: .touchUpInside)
        finishCreateButton.yxs_gradualBackground(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 57, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        finishCreateButton.yxs_shadow(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 57, height: 49), color: UIColor(red: 0.3, green: 0.45, blue: 0.96, alpha: 0.5), cornerRadius:  24.5, offset: CGSize(width: 0, height: 3))
        finishCreateButton.setTitle("完成创建", for: .normal)
        return finishCreateButton
    }()
}


extension YXSClassCreateController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = textField.text! as NSString
        let newStr = text.replacingCharacters(in: range, with: string)
        if newStr.yxs_numberOfChars() > 40{
            return false
        }
        return true
        
    }
}


// MARK: - TipsSection
class SLTipsRightLabelSection: SLTipsBaseSection{
    override init(frame: CGRect) {
        super.init(frame: frame)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        addSubview(rightLabel)
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImage.snp_left).offset(-11)
            make.centerY.equalTo(arrowImage)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var rightLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), night: UIColor.white)
        return label
    }()
}

class SLTipsRightImageSection: SLTipsBaseSection{
    override init(frame: CGRect) {
        super.init(frame: frame)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        addSubview(imgAvatar)
        imgAvatar.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImage.snp_left).offset(-11)
            make.centerY.equalTo(arrowImage)
            make.width.height.equalTo(42)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imgAvatar: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.lightGray
        img.cornerRadius = 21
        img.image = UIImage(named: "normal")
        img.contentMode = .scaleAspectFill
        return img
    }()
}

class SLTipsBaseSection: UIControl{
    override init(frame: CGRect) {
        super.init(frame: frame)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        addSubview(leftlabel)
        addSubview(arrowImage)
        
        leftlabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(self)
        }
        arrowImage.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.size.equalTo(CGSize.init(width: 13.4, height: 13.4))
            make.centerY.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var leftlabel: YXSLabel = {
        let label = YXSLabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return label
    }()
    
    lazy var arrowImage: UIImageView = {
        let arrowImage = UIImageView.init(image: UIImage.init(named: "arrow_gray"))
        return arrowImage
    }()
}
