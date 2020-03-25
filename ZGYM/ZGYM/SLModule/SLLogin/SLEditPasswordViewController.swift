//
//  SLEditPasswordViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/9.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

class SLEditPasswordViewController: SLRegistViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码"
        // Do any additional setup after loading the view.
        lbTitle?.isHidden = true
        tfAccount?.isEnabled = false
        tfAccount?.text = self.sl_user.account ?? ""
        sl_verifySmsButtonEnable()
        tfAuthCode?.setPlaceholder(ph: "请输入验证码")
        tfPassword?.setPlaceholder(ph: "请输入6位以上数字字母组合密码") 
        tfPassword2?.setPlaceholder(ph: "请再次输入6位以上数字字母组合密码")
        btnRegist?.setTitle("确认修改", for: .normal)
        contentView.sl_addLine(position: .top, color: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 10)
    }
    
    override func sl_resizeLayout() {
        self.scrollView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }

        self.contentView.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
        })
        
        self.tfAccount?.edgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        self.tfAccount?.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(49)
        })
        
        self.tfAuthCode?.edgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        self.tfAuthCode?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tfAccount!.snp_bottom).offset(0)
            make.left.equalTo(self.tfAccount!.snp_left).offset(0)
            make.right.equalTo(self.tfAccount!.snp_right).offset(0)
            make.height.equalTo(self.tfAccount!.snp_height)
        })
        
        self.tfPassword?.edgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 40)
        self.tfPassword?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tfAuthCode!.snp_bottom).offset(0)
            make.left.equalTo(self.tfAuthCode!.snp_left).offset(0)
            make.right.equalTo(self.tfAuthCode!.snp_right)
            make.height.equalTo(self.tfAuthCode!.snp_height)
        })
        
        self.tfPassword2?.edgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 40)
        self.tfPassword2?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tfPassword!.snp_bottom).offset(0)
            make.left.equalTo(self.tfPassword!.snp_left).offset(0)
            make.right.equalTo(self.tfPassword!.snp_right).offset(0)
            make.height.equalTo(self.tfPassword!.snp_height)
        })
        
        self.btnSMS?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.tfAuthCode!.snp_centerY)
            make.right.equalTo(self.tfAccount!.snp_right).offset(-15)
        })
        
        self.btnRegist?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tfPassword2!.snp_bottom).offset(42)
            make.centerX.equalTo(self.contentView.snp_centerX)
            make.width.equalTo(318)
            make.height.equalTo(49)
            make.bottom.equalTo(-40)
        })
    }

    
    // MARK: - Action
    @objc override func sl_smsSendClick(sender: SLButton) {
        sender.isEnabled = false
        SLCountDownTool().sl_startCountDown(residueTime: 60) { [weak self](value, result) in
            guard let weakSelf = self else {return}
            weakSelf.btnSMS!.setTitle("重新获取\(value)s", for: .disabled)
            if result {
                weakSelf.btnSMS!.isEnabled = true
            }
        }
        
        MBProgressHUD.sl_showLoading()
        SLEducationSmsSendRequest.init(account: self.tfAccount!.text!, smsTemplate: SMSType.FORGET_PASSWORD).request({ (json) in
            MBProgressHUD.sl_showMessage(message: "发送成功")

        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    override func sl_registClick(sender: SLButton) {
        self.view.endEditing(false)
        MBProgressHUD.sl_showLoading()
        SLEducationUserEditRequest(parameter: ["smsCode":self.tfAuthCode?.text ?? "", "password":self.tfPassword?.text ?? "", "confirmPassword":self.tfPassword2?.text ?? ""]).request({ [weak self](json) in
            guard let weakSelf = self else {return}

            MBProgressHUD.sl_showMessage(message: "修改成功")
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                weakSelf.navigationController?.popViewController()
            }

        }) { (msg, code) in
            MBProgressHUD.sl_hideHUD()
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
