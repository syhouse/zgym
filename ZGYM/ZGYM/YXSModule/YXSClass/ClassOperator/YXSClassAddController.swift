//
//  YXSClassAddController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/21.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import MBProgressHUD
import NightNight

class YXSClassAddController: YXSBaseViewController {
    var classText: String?
    init(classText: String? = nil) {
        self.classText = classText
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        let rightButton = yxs_setRightButton(image: "scan")
        rightButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -25)
        rightButton.addTarget(self, action: #selector(scanClick), for: .touchUpInside)
        title = "加入一个班级"
        initUI()
        
        if isDebug{
            classField.text = "Rztv83"
        }
        
        if let classText = classText{
            classField.text = classText
            lookClassClick()
        }
    }
    
    @objc func scanClick(){
        let vc = YXSScanViewController()
        navigationController?.pushViewController(vc)
    }
    
    // MARK: -UI
    func initUI(){
        view.addSubview(questionView)
        view.addSubview(classField)
        view.addSubview(lookClassButton)
        
        
        classField.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(10)
            make.height.equalTo(49)
        }
        questionView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(classField.snp_bottom).offset(16.5)
            make.height.equalTo(15)
        }
        
        lookClassButton.snp.makeConstraints { (make) in
            make.left.equalTo(28.5)
            make.right.equalTo(-28.5)
            make.top.equalTo(questionView.snp_bottom).offset(41.5)
            make.height.equalTo(49)
        }
    }
    
    // MARK: -loadData
    
    // MARK: -action
    @objc func classChange(){
    }
    
    @objc func lookClassClick(){
        self.view.endEditing(true)
        if classField.text!.count == 0 {
            view.makeToast("请输入老师给您的班级号")
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        YXSEducationGradeQueryRequest.init(num: classField.text!).request({ (model: YXSClassQueryResultModel) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if model.id == nil{
                self.view.makeToast("未查找到班级")
            }else{
                let vc = YXSClassQueryListController.init(model)
                self.navigationController?.pushViewController(vc)
            }
            
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast("\(msg)")
        }
    }
    
    @objc func questionClick(){
        yxs_showAlert(title: "班级号由老师提供")
    }
    // MARK: -private
    
    // MARK: -public
    
    
    // MARK: - getter&setter
    lazy var questionView: YXSCustomImageControl = {
        let questionView = YXSCustomImageControl.init(imageSize: CGSize.init(width: 15, height: 15), position: .left, padding: 7.5)
        questionView.font = UIFont.systemFont(ofSize: 15)
        questionView.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        questionView.title = "如何获取班级号？"
        questionView.locailImage = "yxs_class_quest"
        questionView.addTarget(self, action: #selector(questionClick), for: .touchUpInside)
        return questionView
    }()
    
    lazy var classField: YXSQSTextField = {
        let classField = UIUtil.yxs_getTextField(UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0), placeholder: "请输入老师给您的班级号", placeholderColor: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: UIColor.white))
        classField.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        classField.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        classField.addTarget(self, action: #selector(classChange), for: .editingChanged)
        return classField
    }()
    
    
    lazy var lookClassButton: YXSButton = {
        
        let finishCreateButton = YXSButton.init(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49))
        finishCreateButton.setTitleColor(UIColor.white, for: .normal)
        finishCreateButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        finishCreateButton.addTarget(self, action: #selector(lookClassClick), for: .touchUpInside)
        finishCreateButton.yxs_gradualBackground(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 57, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        finishCreateButton.yxs_shadow(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 57, height: 49), color: UIColor(red: 0.3, green: 0.45, blue: 0.96, alpha: 0.5), cornerRadius: 24.5, offset: CGSize(width: 0, height: 3))
        finishCreateButton.setTitle("查找班级", for: .normal)
        
        return finishCreateButton
    }()
}
