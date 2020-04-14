//
//  YXSMineFeedbackViewController.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/10.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSMineFeedbackViewController: YXSBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "问题反馈"
        // Do any additional setup after loading the view.
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        self.view.addSubview(textView)
        self.view.addSubview(btnDone)
        self.view.yxs_addLine(position: .top, color: kTableViewBackgroundColor, leftMargin: 0, rightMargin: 0, lineHeight: 10)
        
        textView.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(232)
        })
        
        btnDone.snp.makeConstraints({ (make) in
            make.top.equalTo(textView.snp_bottom).offset(45)
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.equalTo(318)
            make.height.equalTo(49)
        })
    }
    
    
    @objc func doneClick(sender: YXSButton) {
        if self.textView.text.isEmpty {
            return
        }
        
        if self.textView.text.isBlank {
            MBProgressHUD.yxs_showMessage(message: "输入内容不能为空，请重新输入", inView: self.view, afterDelay: 1.0)
            return
        }
        
        MBProgressHUD.yxs_showLoading()
        YXSEducationFeedbackSubmitRequest(content: self.textView.text).request({ (json) in
            MBProgressHUD.yxs_hideHUD()
            MBProgressHUD.yxs_showMessage(message: "提交成功", inView: self.navigationController?.view)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                self.navigationController?.popViewController()
            }
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    lazy var textView: YXSPlaceholderTextView = {
        let tv = YXSPlaceholderTextView()
        tv.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight2C3144)
        tv.contentInset = UIEdgeInsets(top: 17, left: 17, bottom: -17, right: 17)
//        tv.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        tv.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightFFFFFF)
        tv.placeholderColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        tv.placeholder = "请输入您想说的..."
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    }()
    
    lazy var btnDone: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("提交", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setMixedTitleColor(MixedColor(normal: 0xFFFFFF, night: 0xFFFFFF), forState: .normal)
        btn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24)
        btn.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: UIColor.gray, cornerRadius: 24, offset: CGSize(width: 4, height: 4))
        btn.layer.cornerRadius = 24
        btn.addTarget(self, action: #selector(doneClick(sender:)), for: .touchUpInside)
        return btn
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
