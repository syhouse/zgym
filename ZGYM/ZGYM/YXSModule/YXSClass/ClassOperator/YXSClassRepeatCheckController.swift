//
//  YXSClassRepeatCheckController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/18.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSClassRepeatCheckController: YXSBaseViewController {
    let errorModel: YXSClassAddErrorModel
    var text: String = ""
    init(errorModel: YXSClassAddErrorModel){
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
        view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor) 
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
                if vc is YXSClassAddInfoController{
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
            cheakSucess?()
        }else{
            MBProgressHUD.yxs_showMessage(message: "验证错误")
        }
    }

    // MARK: -private
    
    // MARK: -public
    
    
    // MARK: - getter&setter
    
    lazy var tipsLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: kNightBCC6D4)
        label.text = "请输入电话号码缺少的信息"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return label
    }()
    
    lazy var leftLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return label
    }()
    
    lazy var rightLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return label
    }()
    
    lazy var certainButton: YXSButton = {
        let btn = YXSButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.cornerRadius = 24.5
        btn.setTitle("是的", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        btn.addShadow(ofColor: UIColor.yxs_hexToAdecimalColor(hex: "#4C74F6"), radius: 7.5, offset: CGSize(width: 0, height: 3), opacity: 0.5)
        btn.addTarget(self, action: #selector(isClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var passwordView: YXSPasswordView = {
        let passwordView = YXSPasswordView()
        passwordView.delegate = self
        passwordView.maxLength = 4
        return passwordView
    }()
}

extension YXSClassRepeatCheckController: SLPasswordViewDelegate {
    func passwordView(textFinished: String) {
        text = textFinished
        print("输入完成: \(textFinished)")
    }
    
    func passwordView(textChanged: String, length: Int) {
        print("文本改变: \(textChanged), length: \(length)")
    }
}
