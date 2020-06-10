//
//  YXSTeacherSacnLoginController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/10.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import NightNight

class YXSTeacherSacnLoginController: YXSBaseViewController{
    var base64UUID: String = ""
    init(_ base64UUID: String) {
        self.base64UUID = base64UUID
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    func initUI(){
        
        view.addSubview(pcImageView)
        view.addSubview(titleLabel)
        view.addSubview(cancelButton)
        view.addSubview(certainButton)
        
        pcImageView.snp.makeConstraints { (make) in
            make.top.equalTo(168)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize.init(width: 117, height: 90))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(pcImageView.snp_bottom).offset(31)
        }
        certainButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-96.5 - kSafeBottomHeight)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize.init(width: 160, height: 41))
        }
        cancelButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-47.5 - kSafeBottomHeight)
            make.centerX.equalTo(view)
            make.height.equalTo(25)
        }
    }
    
    
    // MARK: -yxs_loadData
    
    func yxs_loadSourceData(_ mediaModel: YXSMediaModel){
        
    }
    
    func yxs_loadPublishData(_ url: String){
        
    }
    
    // MARK: -action
    @objc func certainClick(){
        MBProgressHUD.yxs_showLoading()
        YXSEducationAuthQrConfirmAuthRequest(base64UUID: base64UUID).request({ (json) in
            MBProgressHUD.yxs_showMessage(message: "授权成功")
            self.navigationController?.popToRootViewController(animated: false)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    @objc func cancelClick(){
        YXSEducationAuthQrCancelAuthRequest(base64UUID: base64UUID).request({ (json) in
            MBProgressHUD.yxs_showMessage(message: "取消授权")
            self.navigationController?.popViewController()
        }) { (msg, code) in
            MBProgressHUD.yxs_showLoading(message: msg)
        }
    }
    
    lazy var pcImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "yxs_Scan_pc")
        return imageView
    }()
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#222222")
        label.text = "网页端优学生确认登录"
        return label
    }()
    
    
    lazy var certainButton: YXSButton = {
        let certainButton = YXSButton()
        certainButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        certainButton.setTitleColor(UIColor.white, for: .normal)
        certainButton.setTitle("确定", for: .normal)
        certainButton.cornerRadius = 20.5
        certainButton.backgroundColor = kBlueColor
        certainButton.addTarget(self, action: #selector(certainClick), for: .touchUpInside)
        return certainButton
    }()
    
    lazy var cancelButton: YXSButton = {
        let cancelButton = YXSButton()
        cancelButton.setTitle("取消登录", for: .normal)
        cancelButton.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        return cancelButton
    }()
}
