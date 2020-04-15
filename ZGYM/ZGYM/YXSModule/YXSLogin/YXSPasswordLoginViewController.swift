//
//  YXSPasswordLoginViewController.swift
//  ZGYM
//
//  Created by mac_hm on 2019/11/14.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import NightNight
import YYText
import MBProgressHUD

class YXSPasswordLoginViewController: YXSBaseViewController {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var lbTitle: YXSLabel?
    var tfAccount: UITextField?
    var tfPassword: UITextField?
    var btnLogin: YXSButton?
    var yyTxtRegistForgot: YYLabel?
    var btnRegist: YXSButton?
    var btnForgot: YXSButton?
    var completionHandler: ((Bool)->())?
    var btnShowPwd: YXSButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.fd_prefersNavigationBarHidden = true
        self.view.mixedBackgroundColor = MixedColor(normal: 0xFFFFFF, night: 0x191A21)
        yxs_createUI()
        yxs_resizeLayout()
        #if DEBUG
        self.tfAccount?.text = "18674407668"
        self.tfPassword?.text = "123456"
        #endif
        
        verifyEnterButtonEnable()
    }

    // MARK: - CreateUI
    func yxs_createUI() {

        self.scrollView = UIScrollView()
        self.view.addSubview(self.scrollView)
        
        self.contentView = UIView()
        self.scrollView.addSubview(contentView)
        
        self.lbTitle = YXSLabel()
        self.lbTitle?.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFFFFFF)
        self.lbTitle?.text = "账号密码登录"
        self.lbTitle?.font = UIFont.boldSystemFont(ofSize: 25)
        self.contentView.addSubview(self.lbTitle!)

        self.tfAccount = UITextField()
        self.tfAccount?.setPlaceholder(ph: "手机号")
        tfAccount?.keyboardType = .numberPad
        self.tfAccount?.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFFFFFF)
        self.tfAccount?.font = UIFont.systemFont(ofSize: 15)
        self.tfAccount?.clearButtonMode = .whileEditing
        self.tfAccount?.setClearButtonImage(isUpdate: true)
        self.tfAccount?.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#CFD8E1"))
        self.tfAccount?.addTarget(self, action: #selector(accountDidChange(sender:)), for: .editingChanged)
        self.contentView.addSubview(self.tfAccount!)

        
        self.btnShowPwd = YXSButton()
        self.btnShowPwd?.setImage(UIImage(named: "yxs_login_hide_pwd"), for: .normal)
        self.btnShowPwd?.setImage(UIImage(named: "yxs_login_show_pwd"), for: .selected)
        self.btnShowPwd?.addTarget(self, action: #selector(showPwdClick(sender:)), for: .touchUpInside)
        self.btnShowPwd?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        self.tfPassword = UITextField()
        self.tfPassword?.setPlaceholder(ph: "密码") 
        self.tfPassword?.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFFFFFF)
        self.tfPassword?.font = UIFont.systemFont(ofSize: 15)
        self.tfPassword?.isSecureTextEntry = true
        self.tfPassword?.rightView = self.btnShowPwd
        self.tfPassword?.rightViewMode = .always
        self.tfPassword?.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#CFD8E1"))
        self.tfPassword?.addTarget(self, action: #selector(passwordDidChange(sender:)), for: .editingChanged)
        self.contentView.addSubview(self.tfPassword!)

        self.btnLogin = YXSButton()
        self.btnLogin?.setTitle("登录", for: .normal)
        self.btnLogin?.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.btnLogin?.setMixedTitleColor(MixedColor(normal: 0xFEFEFF, night: 0xFEFEFF), forState: .normal)
        self.btnLogin?.layer.cornerRadius = 24
        self.btnLogin?.addTarget(self, action: #selector(loginClick(sender:)), for: .touchUpInside)
        self.contentView.addSubview(self.btnLogin!)


        self.btnForgot = YXSButton()
        self.btnForgot?.setTitle("使用账号密码登录", for: .normal)
        self.btnForgot?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.btnForgot?.setMixedTitleColor(MixedColor(normal: 0x898F9A, night: 0x000000), forState: .normal)
        self.btnForgot?.addTarget(self, action: #selector(forgotPwdClick(sender:)), for: .touchUpInside)
        self.contentView.addSubview(self.btnForgot!)
        
        
        self.yyTxtRegistForgot = YYLabel()
        self.yyTxtRegistForgot?.font = UIFont.systemFont(ofSize: 14)
        self.yyTxtRegistForgot?.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#CFD8E1")
        let text = NSMutableAttributedString(string: "注册 ｜ 忘记密码？")
        text.yy_setTextHighlight(NSRange.init(location: 0, length: 2),color: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"),backgroundColor: nil){ [weak self](view, str, range, rect) in
            guard let weakSelf = self else {return}
            
            weakSelf.yxs_registClick()
        }
        var registlineColor = UIColor.yxs_hexToAdecimalColor(hex: "#CFD8E1")
        if NightNight.theme == .night {
            registlineColor = UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF")
        }
        text.yy_setTextHighlight(NSRange(location: 3, length: 3), color: registlineColor, backgroundColor: nil) { [weak self](view, str, range, rect) in
            guard let weakSelf = self else {return}
        }
        text.yy_setTextHighlight(NSRange(location: 5, length: 5), color: UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), backgroundColor: nil) { [weak self](view, str, range, rect) in
            guard let weakSelf = self else {return}
            
            weakSelf.forgotPwdClick(sender: weakSelf.btnForgot!)
        }
        self.yyTxtRegistForgot?.attributedText = text
        self.contentView.addSubview(self.yyTxtRegistForgot!)
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
            make.top.equalTo(self.contentView.snp_top).offset(45)
            make.left.equalTo(self.contentView.snp_left).offset(29)
        })
        
        self.tfAccount?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.lbTitle!.snp_bottom).offset(53)
            make.left.equalTo(self.contentView.snp_left).offset(29)
            make.right.equalTo(self.contentView.snp_right).offset(-29)
            make.height.equalTo(30+30)
        })
        
        self.tfPassword?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tfAccount!.snp_bottom).offset(30)
            make.left.equalTo(self.tfAccount!.snp_left).offset(0)
            make.right.equalTo(self.tfAccount!.snp_right).offset(0)
            make.height.equalTo(self.tfAccount!.snp_height)
        })
        
        self.btnLogin?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tfPassword!.snp_bottom).offset(50)
            make.centerX.equalTo(self.contentView.snp_centerX)
            make.width.equalTo(318)
            make.height.equalTo(49)
        })

        self.yyTxtRegistForgot?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.btnLogin!.snp_bottom).offset(28)
            make.centerX.equalTo(self.btnLogin!.snp_centerX)
        })
        
        bottomLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(-kSafeBottomHeight - 15)
        }
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
    
    @objc func loginClick(sender: YXSButton) {
        self.view.endEditing(false)
        MBProgressHUD.yxs_showLoading()
        YXSEducationUserLoginPasswordRequest.init(account: self.tfAccount!.text!, password: self.tfPassword!.text!).request({ [weak self](result:YXSEducationUserModel) in
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
            
        }) { (msg, code) in
            MBProgressHUD.yxs_hideHUD()
            self.view.makeToast(msg)
        }
    }
  
    @objc func yxs_registClick() {
        self.navigationController?.pushViewController(YXSRegistViewController())
    }
    
    @objc func forgotPwdClick(sender: YXSButton) {
        self.navigationController?.pushViewController(YXSForgotPwdViewController())
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
    
    @objc func accountDidChange(sender: UITextField) {
        sender.setClearButtonImage(isUpdate: true)
        if sender.text!.count > 11 {
            let subStr = sender.text!.prefix(11)
            sender.text = String(subStr)
        
        } else {
            verifyEnterButtonEnable()
        }
    }
    
    let minPwdCout: Int = 6
    let maxPwdCount: Int = 15
    @objc func passwordDidChange(sender: UITextField) {
        if sender.text!.count > maxPwdCount {
            let subStr = sender.text!.prefix(maxPwdCount)
            sender.text = String(subStr)
        
        } else {
            verifyEnterButtonEnable()
        }
    }
    
    func verifyEnterButtonEnable() {
        if self.tfAccount!.text!.count > 10 && self.tfPassword!.text!.count >= minPwdCout {
            self.btnLogin?.isEnabled = true
            
            self.btnLogin?.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24)
            self.btnLogin?.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: kBlueShadowColor, cornerRadius: 24, offset: CGSize(width: 2, height: 2))
            
        } else {
            if NightNight.theme == .night {
                self.btnLogin?.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#2C3144"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#2C3144"), cornerRadius: 24)
                self.btnLogin?.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: UIColor.yxs_hexToAdecimalColor(hex: "#2C3144"), cornerRadius: 24, offset: CGSize(width: 2, height: 2))
            } else {
                self.btnLogin?.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#D2DBE7"), cornerRadius: 24)
                self.btnLogin?.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: kGrayShadowColor, cornerRadius: 24, offset: CGSize(width: 2, height: 2))
            }
            self.btnLogin?.isEnabled = false
            

        }
    }
    
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
        var lineColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        if NightNight.theme == .night {
            lineColor = UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF")
        }
        text.yy_setTextHighlight(NSRange(location: 7, length: 3), color: lineColor, backgroundColor: nil) { [weak self](view, str, range, rect) in
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
