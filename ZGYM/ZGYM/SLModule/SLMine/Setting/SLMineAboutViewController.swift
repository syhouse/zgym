//
//  SLMineAboutViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/10.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLMineAboutViewController: SLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于优学生"
        
        // Do any additional setup after loading the view.
        self.view.addSubview(topView)
        self.view.addSubview(bottomView)
        self.view.addSubview(imgSss)
        self.view.addSubview(imgLogo)
        self.view.addSubview(lbName)
        self.view.addSubview(lbTitle)
        self.view.addSubview(lbSubTitle)
        
        topView.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0).offset(0)
            make.right.equalTo(0).offset(0)
            make.height.equalTo(212)
        })
        
        bottomView.snp.makeConstraints({ (make) in
            make.top.equalTo(topView.snp_bottom)
            make.left.equalTo(0).offset(0)
            make.right.equalTo(0).offset(0)
            make.bottom.equalTo(0)
        })
        
        imgSss.snp.makeConstraints({ (make) in
            make.top.equalTo(112)
            make.left.equalTo(0).offset(0)
            make.right.equalTo(0).offset(0)
        })
        
        imgLogo.snp.makeConstraints({ (make) in
            make.top.equalTo(60)
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.height.equalTo(93)
        })
        
        lbName.snp.makeConstraints({ (make) in
            make.top.equalTo(imgLogo.snp_bottom).offset(24)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(lbName.snp_bottom).offset(40)
            make.centerX.equalTo(self.view.snp_centerX)
        })
        
        lbSubTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle.snp_bottom).offset(14)
            make.centerX.equalTo(self.view.snp_centerX)
        })
    }
    

    
    
    // MARK: - Action
    @objc func showBuildVersion(sender: UILongPressGestureRecognizer) {
        if (sender.state != .began) {
            return
        }
        
        let net = sericeType.rawValue//sericeType == .ServiceTest ? "inside" : "external"
        #if DEBUG
        lbName.text = "优学生\(NSUtil.BundleShortVersion())"+"("+"build:\(NSUtil.BundleVersion())"+")"+"Dev."+"Net:\(net)"
        #else
        lbName.text = "优学生\(NSUtil.BundleShortVersion())"+"("+"build:\(NSUtil.BundleVersion())"+")"+"Pro."+"Net:\(net)"
        #endif
    }
    
    /// 切换学段
    @objc func changeStage(sender: UILongPressGestureRecognizer) {
        if (sender.state != .began) {
            return
        }
        
        var selectedIndex: Int = 0
        if self.sl_user.stage == "KINDERGARTEN" {
            selectedIndex = 0
        } else if self.sl_user.stage == "PRIMARY_SCHOOL" {
            selectedIndex = 1
        } else {
            selectedIndex = 2
        }
        
        let alert = SLSolitaireSelectReasonView(items: ["幼儿园","小学","中学"], selectedIndex: selectedIndex, inTarget: self.view) { (view, index) in
            if selectedIndex == index {
                view.cancelClick(sender: SLButton())
                return
            }
            var stage: StageType = .MIDDLE_SCHOOL
            switch index {
            case 0:
                stage = .KINDERGARTEN
            case 1:
                stage = .PRIMARY_SCHOOL
            default:
                stage = .MIDDLE_SCHOOL
                
            }
            
            MBProgressHUD.sl_showLoading()
            SLEducationUserSwitchStageRequest(stage:stage).request({ (json) in
                MBProgressHUD.sl_hideHUD()
                MBProgressHUD.sl_showMessage(message: "修改成功")
                view.cancelClick(sender: SLButton())
                UIUtil.sl_loadUserDetailRequest({ (user) in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMineChangeStageNotification), object: nil)
                    self.sl_showTabRoot()
                    
                }) { (msg, code) in
                    MBProgressHUD.sl_showMessage(message: msg)
                }
                
            }) { (msg, code) in
                MBProgressHUD.sl_showMessage(message: msg)
            }
        }
        alert.lbTitle.text = "选择学段"
    }
    
    // MARK: - LazyLoad
    lazy var topView: UIView = {
        let view = UIView()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: UIColor.sl_hexToAdecimalColor(hex: "#181A23"))
        return view
    }()

    lazy var bottomView: UIView = {
        let view = UIView()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#FFFFFF"), night: UIColor.sl_hexToAdecimalColor(hex: "#20232F"))
//        view.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#FFFFFF")
        return view
    }()
    
    lazy var imgLogo: UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true
        img.image = UIImage(named: "sl_mine_logo")
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(changeStage(sender:)))
        img.addGestureRecognizer(gesture)
        return img
    }()
    
    lazy var imgSss: UIImageView = {
        let img = UIImageView()
        img.mixedImage = MixedImage(normal: "sl_mine_sss", night: "sl_mine_sss_night")
        return img
    }()
    
    lazy var lbName: SLLabel = {
        let lb = SLLabel()
        lb.isUserInteractionEnabled = true
        lb.text = "优学生v\(NSUtil.BundleShortVersion())"
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNight898F9A)
        lb.font = UIFont.systemFont(ofSize: 16)
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(showBuildVersion(sender:)))
        lb.addGestureRecognizer(gesture)
        return lb
    }()
    
    lazy var lbTitle: SLLabel = {
        let lb = SLLabel()
        lb.text = "©️版权所有"
        lb.textColor = UIColor.sl_hexToAdecimalColor(hex: "#898F9A")
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    lazy var lbSubTitle: SLLabel = {
        let lb = SLLabel()
        lb.text = "湖南优盟教育科技有限公司"
        lb.textColor = UIColor.sl_hexToAdecimalColor(hex: "#898F9A")
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
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
