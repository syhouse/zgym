//
//  YXSLoginViewController.swift
//  HNYMEducation
//
//  Created by mac_hm on 2019/11/14.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import NightNight
import SwiftyJSON
import MBProgressHUD
import YYText

typealias funcBlock = () -> ()

class YXSLoginViewController: YXSBaseViewController {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var lbTitle: YXSLabel?
    var lbSubTitle: YXSLabel?
    var tfAccount: UITextField?
    var tfAuthCode: UITextField?
    var btnLogin: YXSButton?
    var btnSMS: YXSButton?
    var btnForgot: YXSButton?
    var btnGoPwdLogin: YXSButton?
    var completionHandler: ((Bool)->())?
    
    var termService: YXSLoginTipsAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.mixedBackgroundColor = MixedColor(normal: 0xFFFFFF, night: 0x191A21)
        yxs_createUI()
        yxs_resizeLayout()
        yxs_verifyEnterButtonEnable()
        #if DEBUG
        self.tfAccount?.text = "18565309951"
        #endif
    }

    // MARK: - CreateUI
    func yxs_createUI() {
        
        self.scrollView = UIScrollView()
        self.view.addSubview(self.scrollView)
        
        self.contentView = UIView()
        self.scrollView.addSubview(contentView)

        self.lbTitle = YXSLabel()
        self.lbTitle?.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFFFFFF)
        self.lbTitle?.text = "优学业快捷登录"
        self.lbTitle?.font = UIFont.boldSystemFont(ofSize: 25)
        self.contentView.addSubview(self.lbTitle!)

        self.lbSubTitle = YXSLabel()
        self.lbSubTitle?.mixedTextColor = MixedColor(normal: 0x898f9a, night: 0xC4CDDA)
        self.lbSubTitle?.text = "未注册优学业的手机号，登录时将自动注册"
        self.lbSubTitle?.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(self.lbSubTitle!)
        
        self.tfAccount = UITextField()
        self.tfAccount?.setPlaceholder(ph: "手机号")
        tfAccount?.keyboardType = .numberPad
        self.tfAccount?.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFFFFFF)
        self.tfAccount?.font = UIFont.systemFont(ofSize: 15)
        self.tfAccount?.clearButtonMode = .whileEditing
        self.tfAccount?.setClearButtonImage(isUpdate: true)
//        let clearButton : UIButton = self.tfAccount?.value(forKey: "_clearButton") as! UIButton
//        clearButton.setImage(UIImage(named: "yxs_account_clear"), for: .normal)
        self.tfAccount?.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#CFD8E1"))
        self.tfAccount?.addTarget(self, action: #selector(yxs_accountDidChange(sender:)), for: .editingChanged)
        self.contentView.addSubview(self.tfAccount!)

        
        self.tfAuthCode = UITextField()
        self.tfAuthCode?.setPlaceholder(ph: "验证码") 
        tfAuthCode?.keyboardType = .numberPad
        self.tfAuthCode?.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFFFFFF)
        self.tfAuthCode?.font = UIFont.systemFont(ofSize: 15)
        self.tfAuthCode?.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#CFD8E1"))
        self.tfAuthCode?.addTarget(self, action: #selector(yxs_authCodeDidChange(sender:)), for: .editingChanged)
        self.contentView.addSubview(self.tfAuthCode!)
        
        self.btnLogin = YXSButton()
        self.btnLogin?.setTitle("快捷登录", for: .normal)
        self.btnLogin?.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.btnLogin?.isEnabled = false
        self.btnLogin?.setMixedTitleColor(MixedColor(normal: 0xFEFEFF, night: 0xFEFEFF), forState: .normal)
        self.btnLogin?.clipsToBounds = false
        self.btnLogin?.layer.cornerRadius = 24
        self.btnLogin?.addTarget(self, action: #selector(yxs_loginClick(sender:)), for: .touchUpInside)
        self.contentView.addSubview(self.btnLogin!)
        
        self.btnSMS = YXSButton()
        self.btnSMS?.isEnabled = false
        self.btnSMS?.setTitle("获取验证码", for: .normal)
        self.btnSMS?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.btnSMS?.setMixedTitleColor(MixedColor(normal: 0x5E88F7, night: 0x5E88F7), forState: .normal)
        self.btnSMS?.setMixedTitleColor(MixedColor(normal: 0xC4CDDA, night: 0x858E9C), forState: .disabled)
        self.btnSMS?.addTarget(self, action: #selector(yxs_smsSendClick(sender:)), for: .touchUpInside)
        self.contentView.addSubview(self.btnSMS!)

        self.btnGoPwdLogin = YXSButton()
        self.btnGoPwdLogin?.setTitle("使用账号密码登录", for: .normal)
        self.btnGoPwdLogin?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.btnGoPwdLogin?.setMixedTitleColor(MixedColor(normal: 0x898F9A, night: 0x898F9A), forState: .normal)
        //        self.btnGoPwdLogin?.addTarget(self, action: #selector(yxs_goPasswordLoginClick(sender:)), for: .touchUpInside)
        self.btnGoPwdLogin?.addTarget(self, action: #selector(yxs_goPasswordLoginClick(sender:)), for: .touchUpInside)
        self.contentView.addSubview(self.btnGoPwdLogin!)
        
        self.contentView.addSubview(bottomLabel)
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
            make.top.equalTo(self.contentView.snp_top).offset(60)
            make.left.equalTo(self.contentView.snp_left).offset(29)
        })
        
        self.lbSubTitle?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.lbTitle!.snp_bottom).offset(19)
            make.left.equalTo(self.contentView.snp_left).offset(29)
            make.right.equalTo(self.contentView.snp_right).offset(-29)
        })
        
        self.tfAccount?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.lbSubTitle!.snp_bottom).offset(30)
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
        
        self.btnSMS?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.tfAuthCode!.snp_centerY)
            make.right.equalTo(self.tfAccount!.snp_right).offset(0)
        })
        
        self.btnLogin?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tfAuthCode!.snp_bottom).offset(50)
            make.centerX.equalTo(self.contentView.snp_centerX)
            make.width.equalTo(318)
            make.height.equalTo(49)
        })
        
        self.btnGoPwdLogin?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.btnLogin!.snp_bottom).offset(28)
            make.centerX.equalTo(self.btnLogin!.snp_centerX)
        })
        
        bottomLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(-kSafeBottomHeight - 15)
        }
    }
    
    // MARK: - Action
    @objc func yxs_loginClick(sender: YXSButton) {
        self.view.endEditing(false)
        MBProgressHUD.yxs_showLoading()
        YXSEducationUserLoginSmsSendRequest.init(account: self.tfAccount!.text!, smsCode: self.tfAuthCode?.text ?? "").request({ [weak self](result:YXSEducationUserModel) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            YXSPersonDataModel.sharePerson.userModel = result
            
            if result.type == nil {
                ///没选身份跳选身份
                weakSelf.loginSuccess(result: result)
                
            } else {
                MBProgressHUD.yxs_showLoading()
                UIUtil.yxs_loadUserDetailRequest({ (userModel: YXSEducationUserModel) in
                    MBProgressHUD.yxs_hideHUD()
                    weakSelf.loginSuccess(result: userModel)
                    
                }) { (msg, code) in
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
            }
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
    }
    
    @objc func yxs_smsSendClick(sender: YXSButton) {
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
        YXSEducationSmsSendRequest.init(account: self.tfAccount!.text!).request({ (json) in
            MBProgressHUD.yxs_showMessage(message: "发送成功")
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    @objc func yxs_goPasswordLoginClick(sender: YXSButton) {
        self.navigationController?.pushViewController(YXSPasswordLoginViewController())
    }
    
    @objc func closeClick(sender: YXSButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Other
    /// 登录成功 选择去向
    func loginSuccess(result:YXSEducationUserModel) {
        YXSPersonDataModel.sharePerson.userModel = result
        
        let key = kShowPrivacyProtocolKey+result.account!
        let isFirst:Bool = !UserDefaults.standard.bool(forKey: key)
        
        if result.type == nil {
            if isFirst {
                YXSLoginTipsAlertView.showAlert { (type) in
                    switch type {
                    case .agreement:
                        UserDefaults.standard.set(true, forKey: key)
                        self.completionHandler?(true)
                        if result.type == nil{
                            self.navigationController?.pushViewController(YXSSelectPersonRoleController(), animated: true)
                        }else{
                            self.yxs_showTabRoot()
                        }
                        break
                        
                    case .notagreement: break
                        
                    case .service: break
                        
                    case .privacy: break
                        
                    }
                }
            } else {
                self.navigationController?.pushViewController(YXSSelectPersonRoleController(), animated: true)
            }
            
        } else if result.name == nil || yxs_user.name?.count ?? 0 == 0 {
            yxs_choseNameStage { [weak self](stage) in
                guard let weakSelf = self else {return}
                weakSelf.yxs_showTabRoot()
            }
            
        } else {
            self.yxs_showTabRoot()
        }
    }
    
    func yxs_choseNameStage(completionHandler:((_ stage:StageType)->())?) {
        //包含老师未选学段
        let vc = YXSChoseNameStageController(role: YXSPersonDataModel.sharePerson.personRole) { [weak self](name, index, vc) in
            guard let weakSelf = self else {return}
            var stage: StageType = .KINDERGARTEN
            switch index {
            case 0:
                stage = .KINDERGARTEN
            case 1:
                stage = .PRIMARY_SCHOOL
            default:
                stage = .MIDDLE_SCHOOL
                
            }
            MBProgressHUD.yxs_showLoading()
            YXSEducationUserChooseTypeRequest.init(name: name, userType: YXSPersonDataModel.sharePerson.personRole, stage: stage).request({ (json) in
                MBProgressHUD.yxs_hideHUD()
                
                YXSPersonDataModel.sharePerson.userModel.name = name
                if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                    YXSPersonDataModel.sharePerson.userModel.stage = stage.rawValue
                }
                completionHandler?(YXSPersonDataModel.sharePerson.personStage)
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func yxs_accountDidChange(sender: UITextField) {
        sender.setClearButtonImage(isUpdate: true)
        if sender.text!.count > 11 {
            let subStr = sender.text!.prefix(11)
            sender.text = String(subStr)
            
        } else {
            yxs_verifySmsButtonEnable()
            yxs_verifyEnterButtonEnable()
        }
    }
    
    @objc func yxs_authCodeDidChange(sender: UITextField) {
        if sender.text!.count > 6 {
            let subStr = sender.text!.prefix(6)
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
        if self.tfAccount!.text!.count >= 11 && self.tfAuthCode!.text!.count >= 4 {
            self.btnLogin?.isEnabled = true
//            2C3144
            self.btnLogin?.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24)
            self.btnLogin?.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: UIColor.yxs_hexToAdecimalColor(hex: "#4C74F6"), cornerRadius: 24, offset: CGSize(width: 2, height: 2))
            
        } else {
            self.btnLogin?.isEnabled = false

            if NightNight.theme == .night {
                self.btnLogin?.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#2C3144"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#2C3144"), cornerRadius: 24)
                self.btnLogin?.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: UIColor.yxs_hexToAdecimalColor(hex: "#2C3144"), cornerRadius: 24, offset: CGSize(width: 2, height: 2))
            } else {
                self.btnLogin?.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#D2DBE7"), cornerRadius: 24)
                self.btnLogin?.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), cornerRadius: 24, offset: CGSize(width: 2, height: 2))
            }
        }
    }
    
    // MARK: - LazyLoad
    lazy var timerTool: YXSCountDownTool = {
        let timer = YXSCountDownTool()
        return timer
    }()
    
    lazy var bottomLabel: YYLabel = {
        let label = YYLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        let text = NSMutableAttributedString(string: "用户服务协议 | 隐私保护政策")
        text.yy_setTextHighlight(NSRange.init(location: 0, length: 6),color: kBlueColor,backgroundColor: nil){ [weak self](view, str, range, rect) in
            guard let weakSelf = self else {return}
            let vc = YXSBaseWebViewController()
            vc.loadUrl = "\(sericeType.getH5Url())yhxy.html"
            weakSelf.navigationController?.pushViewController(vc)
        }
        var bottomlineColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        if NightNight.theme == .night {
            bottomlineColor = UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF")
        }
        text.yy_setTextHighlight(NSRange(location: 7, length: 3), color: bottomlineColor, backgroundColor: nil) { [weak self](view, str, range, rect) in
            guard let weakSelf = self else {return}
        }
        text.yy_setTextHighlight(NSRange(location: 9, length: 6), color: kBlueColor, backgroundColor: nil) { [weak self](view, str, range, rect) in
            guard let weakSelf = self else {return}
            let vc = YXSBaseWebViewController()
            vc.loadUrl = "\(sericeType.getH5Url())yszc.html"
            weakSelf.navigationController?.pushViewController(vc)
        }
        label.attributedText = text
        return label
    }()
}
