//
//  YXSForgotPwdViewController.swift
//  ZGYM
//
//  Created by mac_hm on 2019/11/15.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import NightNight
import MBProgressHUD
import SwiftyJSON

class YXSForgotPwdViewController: YXSBaseViewController {
   
    var scrollView: UIScrollView!
    var contentView: UIView!
    var lbTitle: YXSLabel?
    var tfAccount: UITextField?
    var tfAuthCode: UITextField?
    var tfPassword: UITextField?
    var btnLogin: YXSButton?
    var btnSMS: YXSButton?
    var btnShowPwd: YXSButton?
    var completionHandler: ((Bool)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.fd_prefersNavigationBarHidden = true
        self.view.mixedBackgroundColor = MixedColor(normal: 0xFFFFFF, night: 0x191A21)
        yxs_createUI()
        yxs_resizeLayout()
        yxs_verifyEnterButtonEnable()
    }
    
    // MARK: - CreateUI
    func yxs_createUI() {
        
        self.scrollView = UIScrollView()
        self.view.addSubview(self.scrollView)
        
        self.contentView = UIView()
        self.scrollView.addSubview(contentView)
        
        self.lbTitle = YXSLabel()
        self.lbTitle?.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFFFFFF)
        self.lbTitle?.text = "找回密码"
        self.lbTitle?.font = UIFont.boldSystemFont(ofSize: 25)
        self.contentView.addSubview(self.lbTitle!)
    
        
        self.tfAccount = UITextField()
        self.tfAccount?.setPlaceholder(ph: "手机号")
        tfAccount?.keyboardType = .numberPad
//        self.tfAccount?.backgroundColor = UIColor.white
        self.tfAccount?.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFFFFFF)
        self.tfAccount?.font = UIFont.systemFont(ofSize: 15)
        self.tfAccount?.clearButtonMode = .whileEditing
        self.tfAccount?.setClearButtonImage(isUpdate: true)
        self.tfAccount?.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#CFD8E1"))
        self.tfAccount?.addTarget(self, action: #selector(accountDidChange(sender:)), for: .editingChanged)
        self.contentView.addSubview(self.tfAccount!)
        
        
        self.tfAuthCode = UITextField()
        self.tfAuthCode?.setPlaceholder(ph: "验证码")
//        self.tfAuthCode?.backgroundColor = UIColor.white
        tfAuthCode?.keyboardType = .numberPad
        self.tfAuthCode?.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFFFFFF)
        self.tfAuthCode?.font = UIFont.systemFont(ofSize: 15)
        self.tfAuthCode?.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#CFD8E1"))
        self.tfAuthCode?.addTarget(self, action: #selector(authCodeDidChange(sender:)), for: .editingChanged)
        self.contentView.addSubview(self.tfAuthCode!)
       
        
        self.btnShowPwd = YXSButton()
        self.btnShowPwd?.setImage(UIImage(named: "yxs_login_hide_pwd"), for: .normal)
        self.btnShowPwd?.setImage(UIImage(named: "yxs_login_show_pwd"), for: .selected)
        self.btnShowPwd?.addTarget(self, action: #selector(showPwdClick(sender:)), for: .touchUpInside)
        self.btnShowPwd?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        self.tfPassword = UITextField()
//        self.tfPassword?.backgroundColor = UIColor.white
        self.tfPassword?.setPlaceholder(ph: "请输入新的6位以上数字字母密码") 
        self.tfPassword?.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFFFFFF)
        self.tfPassword?.font = UIFont.systemFont(ofSize: 15)
        self.tfPassword?.isSecureTextEntry = true
        self.tfPassword?.rightView = self.btnShowPwd
        self.tfPassword?.rightViewMode = .always
        self.tfPassword?.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#CFD8E1"))
        self.tfPassword?.addTarget(self, action: #selector(passwordDidChange(sender:)), for: .editingChanged)
        self.contentView.addSubview(self.tfPassword!)
        
        
        self.btnLogin = YXSButton()
        self.btnLogin?.setTitle("保存修改", for: .normal)
        self.btnLogin?.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.btnLogin?.setMixedTitleColor(MixedColor(normal: 0xFEFEFF, night: 0xFEFEFF), forState: .normal)
        self.btnLogin?.layer.cornerRadius = 24
        self.btnLogin?.addTarget(self, action: #selector(loginClick(sender:)), for: .touchUpInside)
        self.contentView.addSubview(self.btnLogin!)
        
        
        self.btnSMS = YXSButton()
        self.btnSMS?.isEnabled = false
        self.btnSMS?.setTitle("获取验证码", for: .normal)
        self.btnSMS?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.btnSMS?.setMixedTitleColor(MixedColor(normal: 0x5E88F7, night: 0x5E88F7), forState: .normal)
        self.btnSMS?.setMixedTitleColor(MixedColor(normal: 0xC4CDDA, night: 0x858E9C), forState: .disabled)
        self.btnSMS?.addTarget(self, action: #selector(smsSendClick(sender:)), for: .touchUpInside)
        self.contentView.addSubview(self.btnSMS!)
        
    }
    
    func yxs_resizeLayout() {
        
        self.scrollView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }

        self.contentView.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(667)
        })
        
        self.lbTitle?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.contentView.snp_top).offset(45)
            make.left.equalTo(self.contentView.snp_left).offset(29)
        })
        
        self.tfAccount?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.lbTitle!.snp_bottom).offset(53)
            make.left.equalTo(self.contentView.snp_left).offset(29)
            make.right.equalTo(self.contentView.snp_right).offset(-29)
            make.height.equalTo(30+30)
        })
        
        self.tfAuthCode?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tfAccount!.snp_bottom).offset(30)
            make.left.equalTo(self.tfAccount!.snp_left).offset(0)
            make.right.equalTo(self.tfAccount!.snp_right).offset(0)
            make.height.equalTo(self.tfAccount!.snp_height)
        })
        
        self.tfPassword?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tfAuthCode!.snp_bottom).offset(30)
            make.left.equalTo(self.tfAuthCode!.snp_left).offset(0)
            make.right.equalTo(self.tfAuthCode!.snp_right).offset(0)
            make.height.equalTo(self.tfAuthCode!.snp_height)
        })
        
        self.btnSMS?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.tfAuthCode!.snp_centerY)
            make.right.equalTo(self.tfAccount!.snp_right).offset(0)
        })
        
        self.btnLogin?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tfPassword!.snp_bottom).offset(50)
            make.centerX.equalTo(self.contentView.snp_centerX)
            make.width.equalTo(318)
            make.height.equalTo(49)
        })
    }
    
    // MARK: - Action
    @objc func showPwdClick(sender: YXSButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.tfPassword?.isSecureTextEntry = true
            
        } else {
            sender.isSelected = true
            self.tfPassword?.isSecureTextEntry = false
        }
    }
    
    @objc func smsSendClick(sender: YXSButton) {
        if !(tfAccount?.text?.isPhoneNumber ?? false) {
            MBProgressHUD.yxs_showMessage(message: "手机号格式校验失败")
            return
        }
        
        sender.isEnabled = false
        timerTool.yxs_startCountDown(residueTime: 60) { [weak self](value, result) in
            guard let weakSelf = self else {return}
            weakSelf.btnSMS!.setTitle("重新获取\(value)s", for: .disabled)
            if result {
                weakSelf.btnSMS!.isEnabled = true
            }
        }
        
        MBProgressHUD.yxs_showLoading()
        YXSEducationSmsSendRequest.init(account: self.tfAccount!.text!, smsTemplate: SMSType.FORGET_PASSWORD).request({ (json) in
            MBProgressHUD.yxs_showMessage(message: "发送成功")
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    @objc func loginClick(sender: YXSButton) {
        self.view.endEditing(false)
        MBProgressHUD.yxs_showLoading()
        YXSEducationUserForgetPasswordRequest.init(account: self.tfAccount!.text!, smsCode: self.tfAuthCode!.text!, password: self.tfPassword!.text!).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            weakSelf.view.makeToast("修改成功")
            weakSelf.navigationController?.popViewController(animated: true)
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Other
    @objc func accountDidChange(sender: UITextField) {
        sender.setClearButtonImage(isUpdate: true)
        if sender.text!.count > 11 {
            let subStr = sender.text!.prefix(11)
            sender.text = String(subStr)
        
        } else {
            yxs_verifyEnterButtonEnable()
            yxs_verifySmsButtonEnable()
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
    
    let minPwdCout: Int = 6
    let maxPwdCount: Int = 15
    @objc func passwordDidChange(sender: UITextField) {
        if sender.text!.count > maxPwdCount {
            let subStr = sender.text!.prefix(maxPwdCount)
            sender.text = String(subStr)
        
        } else {
            yxs_verifyEnterButtonEnable()
        }
    }
    
    func yxs_verifySmsButtonEnable() {
        if self.tfAccount!.text!.count >= 11 && timerTool.isFinish {
            self.btnSMS?.isEnabled = true
            
        } else {
            self.btnSMS?.isEnabled = false
        }
    }
    
    func yxs_verifyEnterButtonEnable() {
        if self.tfAccount!.text!.count > 10 && self.tfAuthCode!.text!.count > 3 && self.tfPassword!.text!.count >= minPwdCout {
            self.btnLogin?.isEnabled = true
            
            self.btnLogin?.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24)
            self.btnLogin?.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: kBlueShadowColor, cornerRadius: 24, offset: CGSize(width: 2, height: 2))
            
        } else {
            self.btnLogin?.isEnabled = false
            if NightNight.theme == .night {
                self.btnLogin?.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#2C3144"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#2C3144"), cornerRadius: 24)
                self.btnLogin?.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: UIColor.yxs_hexToAdecimalColor(hex: "#2C3144"), cornerRadius: 24, offset: CGSize(width: 2, height: 2))
            } else {
                self.btnLogin?.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#D2DBE7"), cornerRadius: 24)
                self.btnLogin?.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: kGrayShadowColor, cornerRadius: 24, offset: CGSize(width: 2, height: 2))
            }

        }
    }
    
    // MARK: - LazyLoad
    lazy var timerTool: YXSCountDownTool = {
        let timer = YXSCountDownTool()
        return timer
    }()
    
}
