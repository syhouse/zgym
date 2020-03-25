//
//  SLClassRepeatCheckController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/18.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLClassRepeatCheckController: SLBaseViewController {
    let errorModel: SLClassAddErrorModel
    var text: String = ""
    init(errorModel: SLClassAddErrorModel){
        self.errorModel = errorModel
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var cheakSucess: (() -> ())?
    lazy var phoneText =  errorModel.account ?? "18565309951"
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        title = "验证信息"
        
        var text = errorModel.realName ?? ""
        for model in Relationships{
            if model.paramsKey == errorModel.relationship{
                text += model.text
                break
            }
        }
        titleLabel.text = "\(text)电话"
        leftLabel.text = phoneText.mySubString(to: 3)
        rightLabel.text = phoneText.mySubString(from: 7)
        passwordView.becomeFirstResponder()
    }
    
    // MARK: -UI
    func initUI(){
        view.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor) 
        view.addSubview(tipsLabel)
        view.addSubview(titleLabel)
        view.addSubview(leftLabel)
        view.addSubview(rightLabel)
        view.addSubview(passwordView)
        view.addSubview(certainButton)
        tipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(19)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tipsLabel.snp_bottom).offset(35.5)
            make.left.equalTo(15)
        }
        passwordView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(37.5)
            make.centerX.equalTo(view)
            make.size.equalTo(passwordView.viewSize)
        }
        leftLabel.snp.makeConstraints { (make) in
            make.right.equalTo(passwordView.snp_left).offset(-13.5)
            make.centerY.equalTo(passwordView)
        }
        rightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(passwordView.snp_right).offset(13.5)
            make.centerY.equalTo(passwordView)
        }
        certainButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordView.snp_bottom).offset(49.5)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize.init(width: 318, height: 49))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if passwordView.isFirstResponder {
            passwordView.resignFirstResponder()
        }
    }
    
    // MARK: -loadData
    
    // MARK: -action
    @objc func isClick(){
        if "\(leftLabel.text ?? "")\(text)\(rightLabel.text ?? "")" == phoneText {
            for vc in navigationController!.viewControllers{
                if vc is SLClassAddInfoController{
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
            cheakSucess?()
        }else{
            MBProgressHUD.sl_showMessage(message: "验证错误")
        }
    }

    // MARK: -private
    
    // MARK: -public
    
    
    // MARK: - getter&setter
    
    lazy var tipsLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"), night: kNightBCC6D4)
        label.text = "请输入电话号码缺少的信息"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var titleLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return label
    }()
    
    lazy var leftLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return label
    }()
    
    lazy var rightLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return label
    }()
    
    lazy var certainButton: SLButton = {
        let btn = SLButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.cornerRadius = 24.5
        btn.setTitle("是的", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        btn.addShadow(ofColor: UIColor.sl_hexToAdecimalColor(hex: "#4C74F6"), radius: 7.5, offset: CGSize(width: 0, height: 3), opacity: 0.5)
        btn.addTarget(self, action: #selector(isClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var passwordView: SLPasswordView = {
        let passwordView = SLPasswordView()
        passwordView.delegate = self
        passwordView.maxLength = 4
        return passwordView
    }()
}

extension SLClassRepeatCheckController: SLPasswordViewDelegate {
    func passwordView(textFinished: String) {
        text = textFinished
        print("输入完成: \(textFinished)")
    }
    
    func passwordView(textChanged: String, length: Int) {
        print("文本改变: \(textChanged), length: \(length)")
    }
}
