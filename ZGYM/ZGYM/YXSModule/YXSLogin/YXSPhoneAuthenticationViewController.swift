//
//  YXSPhoneAuthenticationViewController.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/29.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

/// 手机认证
class YXSPhoneAuthenticationViewController: YXSBaseViewController {

    var smsType:SMSType = .OPERATION_GRADE
    var completionHandler:((_ phone:String, _ authCode:Int, _ doneButton:YXSButton, _ vc:YXSPhoneAuthenticationViewController)->())?
    
    init(smsType:SMSType, doneClickBlock:((_ phone:String, _ authCode:Int, _ doneButton:YXSButton, _ vc:YXSPhoneAuthenticationViewController)->())?) {
        super.init()
        self.title = "手机认证"
        self.smsType = smsType
        self.completionHandler = doneClickBlock
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(contentView)
        
        self.contentView.addSubview(self.tfAccount)
        self.contentView.addSubview(self.tfAuthCode)
        self.contentView.addSubview(self.btnSMS)
        self.contentView.addSubview(self.btnDone)
        
        yxs_layout()
        yxs_verifySmsButtonEnable()
        yxs_verifyEnterButtonEnable()
    }
    
    func yxs_layout() {
        self.scrollView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }

        self.contentView.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
        })
        
        self.tfAccount.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(49)
        })
        
        self.tfAuthCode.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tfAccount.snp_bottom)
            make.left.equalTo(self.tfAccount.snp_left).offset(0)
            make.height.equalTo(self.tfAccount.snp_height)
        })
        
        
        self.btnSMS.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tfAccount.snp_bottom)
            make.left.equalTo(self.tfAuthCode.snp_right)
            make.right.equalTo(self.tfAccount.snp_right).offset(0)//.priorityRequired()
            make.height.equalTo(self.tfAuthCode.snp_height)
            make.width.equalTo(104)
        })
        
        self.btnDone.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tfAuthCode.snp_bottom).offset(34)
            make.centerX.equalTo(self.contentView.snp_centerX)
            make.width.equalTo(318)
            make.height.equalTo(49)
            make.bottom.equalTo(0)
        })
    }
    
    // MARK: - Action
    @objc func yxs_smsSendClick(sender: YXSButton) {
        if !(tfAccount.text?.isPhoneNumber ?? false) {
            MBProgressHUD.yxs_showMessage(message: "手机号格式校验失败")
            return
        }
        
        sender.isEnabled = false
        timerTool.yxs_startCountDown(residueTime: 60) { [weak self](value, result) in
            guard let weakSelf = self else {return}
            weakSelf.btnSMS.setTitle("重新获取\(value)s", for: .disabled)
            if result {
                weakSelf.btnSMS.isEnabled = true
            }
        }
        MBProgressHUD.yxs_showLoading(inView: self.view)
        YXSEducationSmsSendRequest.init(account: self.tfAccount.text!, smsTemplate:self.smsType).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUDInView(view: weakSelf.view)
            MBProgressHUD.yxs_showMessage(message: "发送成功")
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUDInView(view: weakSelf.view)
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    @objc func yxs_doneClick(sender: YXSButton) {
        self.view.endEditing(false)
        self.completionHandler?(self.tfAccount.text ?? "", Int(self.tfAuthCode.text ?? "0")! , sender, self)
    }
    
    // MARK: - Other
    @objc func accountDidChange(sender: UITextField) {
        if sender.text!.count > 11 {
            let subStr = sender.text!.prefix(11)
            sender.text = String(subStr)
            
        } else {
            yxs_verifySmsButtonEnable()
            yxs_verifyEnterButtonEnable()
        }
    }
    
    @objc func authCodeDidChange(sender: UITextField) {
        if sender.text!.count > 6 {
            let subStr = sender.text!.prefix(6)
            sender.text = String(subStr)
        
        } else {
            yxs_verifyEnterButtonEnable()
        }
    }
            
    func yxs_verifySmsButtonEnable() {
        if self.tfAccount.text!.count >= 11 && timerTool.isFinish {
            self.btnSMS.isEnabled = true
            
        } else {
            self.btnSMS.isEnabled = false
        }
    }
    
    func yxs_verifyEnterButtonEnable() {
        if self.tfAccount.text!.count >= 11 && self.tfAuthCode.text!.count >= 4 {
            self.btnDone.isEnabled = true
            
            self.btnDone.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24)
            self.btnDone.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: kBlueShadowColor, cornerRadius: 24, offset: CGSize(width: 2, height: 2))
            
        } else {
            self.btnDone.isEnabled = false
            
            self.btnDone.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#D2DBE7"), cornerRadius: 24)
            self.btnDone.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: kGrayShadowColor, cornerRadius: 24, offset: CGSize(width: 2, height: 2))
        }
    }
    
    
    // MARK: - LazyLoad
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.mixedBackgroundColor = MixedColor(normal: 0xF2F5F9, night: 0x181A23)
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
//        view.addLine(position: .top, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 10)
        return view
    }()
    
    lazy var tfAccount: YXSQSTextField = {
        let tf = YXSQSTextField()
        tf.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight20232F)
        tf.edgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tf.setPlaceholder(ph: "手机号")
        tf.keyboardType = .numberPad
        tf.mixedTextColor = MixedColor(normal: k575A60Color, night: kNightFFFFFF)
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.clearButtonMode = .whileEditing
        tf.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#CFD8E1"))
        tf.addTarget(self, action: #selector(accountDidChange(sender:)), for: .editingChanged)
        return tf
    }()

    lazy var tfAuthCode: YXSQSTextField = {
        let tf = YXSQSTextField()
        tf.keyboardType = .numberPad
        tf.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight20232F)
        tf.edgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tf.setPlaceholder(ph: "验证码") 
        tf.mixedTextColor = MixedColor(normal: k575A60Color, night: kNightFFFFFF)
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.addTarget(self, action: #selector(authCodeDidChange(sender:)), for: .editingChanged)
        return tf
    }()
    
    lazy var btnSMS: YXSButton = {
        let btn = YXSButton()
        btn.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight20232F)
        btn.isEnabled = false
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setMixedTitleColor(MixedColor(normal: 0x5E88F7, night: 0x858E9C), forState: .normal)
        btn.setMixedTitleColor(MixedColor(normal: 0xC4CDDA, night: 0xC4CDDA), forState: .disabled)
        btn.addTarget(self, action: #selector(yxs_smsSendClick(sender:)), for: .touchUpInside)
        return btn
    }()

    lazy var btnDone: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("确认", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setMixedTitleColor(MixedColor(normal: 0xFEFEFF, night: 0xFEFEFF), forState: .normal)
        btn.layer.cornerRadius = 24
        btn.addTarget(self, action: #selector(yxs_doneClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    
    // MARK: - LazyLoad
    lazy var timerTool: YXSCountDownTool = {
        let timer = YXSCountDownTool()
        return timer
    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
