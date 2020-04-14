//
//  SLSelectPersonRoleController.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/14.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import FDFullscreenPopGesture_Bell
import NightNight

class SelectPersonSectionView: UIControl{
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(44.5)
            make.centerY.equalTo(self)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.right.equalTo(-52)
            make.size.equalTo(CGSize.init(width: 44.5, height: 66.5))
            make.bottom.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 23)
//        label.textColor = kTextBlackColor
        label.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFFFFFF)
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
}

class YXSSelectPersonRoleController: YXSBaseViewController {
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        self.fd_interactivePopDisabled = true

        self.view!.mixedBackgroundColor = MixedColor(normal: 0xFFFFFF, night: 0x191A21)
        view.addSubview(titleLabel)
        view.addSubview(yxs_teacherSectionView)
        view.addSubview(yxs_partentSectionView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(124 + kSafeTopHeight)
        }
        
        yxs_teacherSectionView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(titleLabel.snp_bottom).offset(52)
            make.size.equalTo(CGSize.init(width: 288, height: 75))
        }
        yxs_partentSectionView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(yxs_teacherSectionView.snp_bottom).offset(31.5)
            make.size.equalTo(CGSize.init(width: 288, height: 75))
        }
    }
    
    // MARK: - UI
    
    // MARK: - Request
    func yxs_choseTypeRequest(name:String, userType:PersonRole, stage: StageType?, completionHandler:(()->())?) {

        MBProgressHUD.yxs_showLoading()
        YXSEducationUserChooseTypeRequest.init(name: name, userType: userType, stage: stage).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            weakSelf.yxs_user.name = name
            weakSelf.yxs_user.type = userType.rawValue
            weakSelf.yxs_user.stage = stage?.rawValue
            
            completionHandler?()
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - action
    @objc func yxs_selectTeacher(){
        
        let vc = YXSChoseNameStageController(role: .TEACHER) { [weak self](name, index, vc) in
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
            weakSelf.yxs_choseTypeRequest(name: name, userType: .TEACHER, stage: stage) {
                vc.navigationController?.pushViewController(YXSRegisterSucessController())
            }
        }
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func yxs_selectPartent(){
        
        let vc = YXSChoseNameStageController(role: .PARENT) { [weak self](name, index, vc) in
            guard let weakSelf = self else {return}
            weakSelf.yxs_choseTypeRequest(name: name, userType: .PARENT, stage: nil) {
                vc.navigationController?.pushViewController(YXSRegisterSucessController())
            }
        }
        self.navigationController?.pushViewController(vc)
    }
    
    // MARK: -private
    
    // MARK: -public
    
    
    // MARK: - getter&setter
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
//        label.textColor = kTextBlackColor
        label.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFEFEFE)
        label.text = "选择身份"
        return label
    }()
    
    lazy var yxs_teacherSectionView: SelectPersonSectionView = {
        let yxs_teacherSectionView = SelectPersonSectionView()
        yxs_teacherSectionView.cornerRadius = 37.5
        yxs_teacherSectionView.mixedBackgroundColor = MixedColor(normal: 0xF3F5F9, night: 0x20232F)
//        yxs_teacherSectionView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9")
        yxs_teacherSectionView.addTarget(self, action: #selector(yxs_selectTeacher), for: .touchUpInside)
        yxs_teacherSectionView.titleLabel.text = "我是老师"
        yxs_teacherSectionView.imageView.image = UIImage.init(named: "teacher")
        return yxs_teacherSectionView
    }()
    
    lazy var yxs_partentSectionView: SelectPersonSectionView = {
        let yxs_partentSectionView = SelectPersonSectionView()
        yxs_partentSectionView.cornerRadius = 37.5
        yxs_partentSectionView.mixedBackgroundColor = MixedColor(normal: 0xF3F5F9, night: 0x20232F)
//        yxs_partentSectionView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9")
        yxs_partentSectionView.addTarget(self, action: #selector(yxs_selectPartent), for: .touchUpInside)
        yxs_partentSectionView.titleLabel.text = "我是家长"
        yxs_partentSectionView.imageView.image = UIImage.init(named: "partent")
        return yxs_partentSectionView
    }()
}

