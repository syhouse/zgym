//
//  SLLoginViewController.swift
//  ZGYM
//
//  Created by mac_hm on 2019/11/14.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import Foundation
import NightNight
import SwiftyJSON
import MBProgressHUD
import YYText

typealias funcBlock = () -> ()

class SLLoginViewController: SLBaseViewController {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var lbTitle: SLLabel?
    var lbSubTitle: SLLabel?
    var tfAccount: UITextField?
    var tfAuthCode: UITextField?
    var btnLogin: SLButton?
    var btnSMS: SLButton?
    var btnForgot: SLButton?
    var btnGoPwdLogin: SLButton?
    var completionHandler: ((Bool)->())?
    
    var termService: SLLoginTipsAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.mixedBackgroundColor = MixedColor(normal: 0xFFFFFF, night: 0x191A21)
        sl_createUI()
        sl_resizeLayout()
        sl_verifyEnterButtonEnable()
        #if DEBUG
        self.tfAccount?.text = "18565309951"
        #endif
    }

    // MARK: - CreateUI
    func sl_createUI() {
        
        self.scrollView = UIScrollView()
        self.view.addSubview(self.scrollView)
        
        self.contentView = UIView()
        self.scrollView.addSubview(contentView)

        self.lbTitle = SLLabel()
        self.lbTitle?.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFFFFFF)
        self.lbTitle?.text = "优学生快捷登录"
        self.lbTitle?.font = UIFont.boldSystemFont(ofSize: 25)
        self.contentView.addSubview(self.lbTitle!)

        self.lbSubTitle = SLLabel()
        self.lbSubTitle?.mixedTextColor = MixedColor(normal: 0x898f9a, night: 0xC4CDDA)
        self.lbSubTitle?.text = "未注册优学生的手机号，登录时将自动注册"
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
//        clearButton.setImage(UIImage(named: "sl_account_clear"), for: .normal)
        self.tfAccount?.sl_addLine(position: LinePosition.bottom, color: UIColor.sl_hexToAdecimalColor(hex: "#CFD8E1"))
        self.tfAccount?.addTarget(self, action: #selector(sl_accountDidChange(sender:)), for: .editingChanged)
        self.contentView.addSubview(self.tfAccount!)

        
        self.tfAuthCode = UITextField()
        self.tfAuthCode?.setPlaceholder(ph: "验证码") 
        tfAuthCode?.keyboardType = .numberPad
        self.tfAuthCode?.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFFFFFF)
        self.tfAuthCode?.font = UIFont.systemFont(ofSize: 15)
        self.tfAuthCode?.sl_addLine(position: LinePosition.bottom, color: UIColor.sl_hexToAdecimalColor(hex: "#CFD8E1"))
        self.tfAuthCode?.addTarget(self, action: #selector(sl_authCodeDidChange(sender:)), for: .editingChanged)
        self.contentView.addSubview(self.tfAuthCode!)
        
        self.btnLogin = SLButton()
        self.btnLogin?.setTitle("快捷登录", for: .normal)
        self.btnLogin?.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.btnLogin?.isEnabled = false
        self.btnLogin?.setMixedTitleColor(MixedColor(normal: 0xFEFEFF, night: 0xFEFEFF), forState: .normal)
        self.btnLogin?.clipsToBounds = false
        self.btnLogin?.layer.cornerRadius = 24
        self.btnLogin?.addTarget(self, action: #selector(sl_loginClick(sender:)), for: .touchUpInside)
        self.contentView.addSubview(self.btnLogin!)
        
        self.btnSMS = SLButton()
        self.btnSMS?.isEnabled = false
        self.btnSMS?.setTitle("获取验证码", for: .normal)
        self.btnSMS?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.btnSMS?.setMixedTitleColor(MixedColor(normal: 0x5E88F7, night: 0x5E88F7), forState: .normal)
        self.btnSMS?.setMixedTitleColor(MixedColor(normal: 0xC4CDDA, night: 0x858E9C), forState: .disabled)
        self.btnSMS?.addTarget(self, action: #selector(sl_smsSendClick(sender:)), for: .touchUpInside)
        self.contentView.addSubview(self.btnSMS!)

        self.btnGoPwdLogin = SLButton()
        self.btnGoPwdLogin?.setTitle("使用账号密码登录", for: .normal)
        self.btnGoPwdLogin?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.btnGoPwdLogin?.setMixedTitleColor(MixedColor(normal: 0x898F9A, night: 0x898F9A), forState: .normal)
        //        self.btnGoPwdLogin?.addTarget(self, action: #selector(sl_goPasswordLoginClick(sender:)), for: .touchUpInside)
        self.btnGoPwdLogin?.addTarget(self, action: #selector(sl_goPasswordLoginClick(sender:)), for: .touchUpInside)
        self.contentView.addSubview(self.btnGoPwdLogin!)
        
        self.contentView.addSubview(bottomLabel)
    }
    
    func sl_resizeLayout() {
        
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
    @objc func sl_loginClick(sender: SLButton) {
        self.view.endEditing(false)
        MBProgressHUD.sl_showLoading()
        SLEducationUserLoginSmsSendRequest.init(account: self.tfAccount!.text!, smsCode: self.tfAuthCode?.text ?? "").request({ [weak self](result:SLEducationUserModel) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_hideHUD()
            SLPersonDataModel.sharePerson.userModel = result
            
            if result.type == nil {
                ///没选身份跳选身份
                weakSelf.loginSuccess(result: result)
                
            } else {
                MBProgressHUD.sl_showLoading()
                UIUtil.sl_loadUserDetailRequest({ (userModel: SLEducationUserModel) in
                    MBProgressHUD.sl_hideHUD()
                    weakSelf.loginSuccess(result: userModel)
                    
                }) { (msg, code) in
                    MBProgressHUD.sl_showMessage(message: msg)
                }
            }
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_showMessage(message: msg)
        }
        
    }
    
    @objc func sl_smsSendClick(sender: SLButton) {
        sender.isEnabled = false
        
        timerTool.sl_startCountDown(residueTime: 60) { [weak self](value, result) in
            guard let weakSelf = self else {return}
            weakSelf.btnSMS!.setTitle("重新获取\(value)s", for: .disabled)
            if result {
                weakSelf.btnSMS!.isEnabled = true
            }
        }
        MBProgressHUD.sl_showLoading()
        SLEducationSmsSendRequest.init(account: self.tfAccount!.text!).request({ (json) in
            MBProgressHUD.sl_showMessage(message: "发送成功")
            
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    @objc func sl_goPasswordLoginClick(sender: SLButton) {
        self.navigationController?.pushViewController(SLPasswordLoginViewController())
    }
    
    @objc func closeClick(sender: SLButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Other
    /// 登录成功 选择去向
    func loginSuccess(result:SLEducationUserModel) {
        SLPersonDataModel.sharePerson.userModel = result
        
        let key = kShowPrivacyProtocolKey+result.account!
        let isFirst:Bool = !UserDefaults.standard.bool(forKey: key)
        
        if result.type == nil {
            if isFirst {
                SLLoginTipsAlertView.showAlert { (type) in
                    switch type {
                    case .agreement:
                        UserDefaults.standard.set(true, forKey: key)
                        self.completionHandler?(true)
                        if result.type == nil{
                            self.navigationController?.pushViewController(SLSelectPersonRoleController(), animated: true)
                        }else{
                            self.sl_showTabRoot()
                        }
                        break
                        
                    case .notagreement: break
                        
                    case .service: break
                        
                    case .privacy: break
                        
                    }
                }
            } else {
                self.navigationController?.pushViewController(SLSelectPersonRoleController(), animated: true)
            }
            
        } else if result.name == nil || sl_user.name?.count ?? 0 == 0 {
            sl_choseNameStage { [weak self](stage) in
                guard let weakSelf = self else {return}
                weakSelf.sl_showTabRoot()
            }
            
        } else {
            self.sl_showTabRoot()
        }
    }
    
    func sl_choseNameStage(completionHandler:((_ stage:StageType)->())?) {
        //包含老师未选学段
        let vc = SLChoseNameStageController(role: SLPersonDataModel.sharePerson.personRole) { [weak self](name, index, vc) in
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
            MBProgressHUD.sl_showLoading()
            SLEducationUserChooseTypeRequest.init(name: name, userType: SLPersonDataModel.sharePerson.personRole, stage: stage).request({ (json) in
                MBProgressHUD.sl_hideHUD()
                
                SLPersonDataModel.sharePerson.userModel.name = name
                if SLPersonDataModel.sharePerson.personRole == .TEACHER {
                    SLPersonDataModel.sharePerson.userModel.stage = stage.rawValue
                }
                completionHandler?(SLPersonDataModel.sharePerson.personStage)
                
            }) { (msg, code) in
                MBProgressHUD.sl_showMessage(message: msg)
            }
        }
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func sl_accountDidChange(sender: UITextField) {
        sender.setClearButtonImage(isUpdate: true)
        if sender.text!.count > 11 {
            let subStr = sender.text!.prefix(11)
            sender.text = String(subStr)
            
        } else {
            sl_verifySmsButtonEnable()
            sl_verifyEnterButtonEnable()
        }
    }
    
    @objc func sl_authCodeDidChange(sender: UITextField) {
        if sender.text!.count > 6 {
            let subStr = sender.text!.prefix(6)
            sender.text = String(subStr)
            
        } else {
            sl_verifyEnterButtonEnable()
        }
    }
    
    func sl_verifySmsButtonEnable() {
        if self.tfAccount!.text!.count >= 11 && timerTool.isFinish {
            self.btnSMS?.isEnabled = true
            
        } else {
            self.btnSMS?.isEnabled = false
        }
    }
    
    func sl_verifyEnterButtonEnable() {
        if self.tfAccount!.text!.count >= 11 && self.tfAuthCode!.text!.count >= 4 {
            self.btnLogin?.isEnabled = true
//            2C3144
            self.btnLogin?.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24)
            self.btnLogin?.sl_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: UIColor.sl_hexToAdecimalColor(hex: "#4C74F6"), cornerRadius: 24, offset: CGSize(width: 2, height: 2))
            
        } else {
            self.btnLogin?.isEnabled = false

            if NightNight.theme == .night {
                self.btnLogin?.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.sl_hexToAdecimalColor(hex: "#2C3144"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#2C3144"), cornerRadius: 24)
                self.btnLogin?.sl_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: UIColor.sl_hexToAdecimalColor(hex: "#2C3144"), cornerRadius: 24, offset: CGSize(width: 2, height: 2))
            } else {
                self.btnLogin?.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.sl_hexToAdecimalColor(hex: "#C4CDDA"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#D2DBE7"), cornerRadius: 24)
                self.btnLogin?.sl_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: UIColor.sl_hexToAdecimalColor(hex: "#C4CDDA"), cornerRadius: 24, offset: CGSize(width: 2, height: 2))
            }
        }
    }
    
    // MARK: - LazyLoad
    lazy var timerTool: SLCountDownTool = {
        let timer = SLCountDownTool()
        return timer
    }()
    
    lazy var bottomLabel: YYLabel = {
        let label = YYLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#C4CDDA")
        let text = NSMutableAttributedString(string: "用户服务协议 | 隐私保护政策")
        text.yy_setTextHighlight(NSRange.init(location: 0, length: 6),color: kBlueColor,backgroundColor: nil){ [weak self](view, str, range, rect) in
            guard let weakSelf = self else {return}
            let vc = SLBaseWebViewController()
            vc.loadUrl = "\(sericeType.getH5Url())yhxy.html"
            weakSelf.navigationController?.pushViewController(vc)
        }
        var bottomlineColor = UIColor.sl_hexToAdecimalColor(hex: "#C4CDDA")
        if NightNight.theme == .night {
            bottomlineColor = UIColor.sl_hexToAdecimalColor(hex: "#FFFFFF")
        }
        text.yy_setTextHighlight(NSRange(location: 7, length: 3), color: bottomlineColor, backgroundColor: nil) { [weak self](view, str, range, rect) in
            guard let weakSelf = self else {return}
        }
        text.yy_setTextHighlight(NSRange(location: 9, length: 6), color: kBlueColor, backgroundColor: nil) { [weak self](view, str, range, rect) in
            guard let weakSelf = self else {return}
            let vc = SLBaseWebViewController()
            vc.loadUrl = "\(sericeType.getH5Url())yszc.html"
            weakSelf.navigationController?.pushViewController(vc)
        }
        label.attributedText = text
        return label
    }()
}
