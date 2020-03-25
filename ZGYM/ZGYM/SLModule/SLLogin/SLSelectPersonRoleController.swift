//
//  SLSelectPersonRoleController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/14.
//  Copyright © 2019 hnsl_mac. All rights reserved.
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
    
    lazy var titleLabel: SLLabel = {
        let label = SLLabel()
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

class SLSelectPersonRoleController: SLBaseViewController {
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        self.fd_interactivePopDisabled = true

        self.view!.mixedBackgroundColor = MixedColor(normal: 0xFFFFFF, night: 0x191A21)
        view.addSubview(titleLabel)
        view.addSubview(sl_teacherSectionView)
        view.addSubview(sl_partentSectionView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(124 + kSafeTopHeight)
        }
        
        sl_teacherSectionView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(titleLabel.snp_bottom).offset(52)
            make.size.equalTo(CGSize.init(width: 288, height: 75))
        }
        sl_partentSectionView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(sl_teacherSectionView.snp_bottom).offset(31.5)
            make.size.equalTo(CGSize.init(width: 288, height: 75))
        }
    }
    
    // MARK: - UI
    
    // MARK: - Request
    func sl_choseTypeRequest(name:String, userType:PersonRole, stage: StageType?, completionHandler:(()->())?) {

        MBProgressHUD.sl_showLoading()
        SLEducationUserChooseTypeRequest.init(name: name, userType: userType, stage: stage).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_hideHUD()
            weakSelf.sl_user.name = name
            weakSelf.sl_user.type = userType.rawValue
            weakSelf.sl_user.stage = stage?.rawValue
            
            completionHandler?()
            
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: - action
    @objc func sl_selectTeacher(){
        
        let vc = SLChoseNameStageController(role: .TEACHER) { [weak self](name, index, vc) in
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
            weakSelf.sl_choseTypeRequest(name: name, userType: .TEACHER, stage: stage) {
                vc.navigationController?.pushViewController(SLRegisterSucessController())
            }
        }
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func sl_selectPartent(){
        
        let vc = SLChoseNameStageController(role: .PARENT) { [weak self](name, index, vc) in
            guard let weakSelf = self else {return}
            weakSelf.sl_choseTypeRequest(name: name, userType: .PARENT, stage: nil) {
                vc.navigationController?.pushViewController(SLRegisterSucessController())
            }
        }
        self.navigationController?.pushViewController(vc)
    }
    
    // MARK: -private
    
    // MARK: -public
    
    
    // MARK: - getter&setter
    lazy var titleLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
//        label.textColor = kTextBlackColor
        label.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFEFEFE)
        label.text = "选择身份"
        return label
    }()
    
    lazy var sl_teacherSectionView: SelectPersonSectionView = {
        let sl_teacherSectionView = SelectPersonSectionView()
        sl_teacherSectionView.cornerRadius = 37.5
        sl_teacherSectionView.mixedBackgroundColor = MixedColor(normal: 0xF3F5F9, night: 0x20232F)
//        sl_teacherSectionView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9")
        sl_teacherSectionView.addTarget(self, action: #selector(sl_selectTeacher), for: .touchUpInside)
        sl_teacherSectionView.titleLabel.text = "我是老师"
        sl_teacherSectionView.imageView.image = UIImage.init(named: "teacher")
        return sl_teacherSectionView
    }()
    
    lazy var sl_partentSectionView: SelectPersonSectionView = {
        let sl_partentSectionView = SelectPersonSectionView()
        sl_partentSectionView.cornerRadius = 37.5
        sl_partentSectionView.mixedBackgroundColor = MixedColor(normal: 0xF3F5F9, night: 0x20232F)
//        sl_partentSectionView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9")
        sl_partentSectionView.addTarget(self, action: #selector(sl_selectPartent), for: .touchUpInside)
        sl_partentSectionView.titleLabel.text = "我是家长"
        sl_partentSectionView.imageView.image = UIImage.init(named: "partent")
        return sl_partentSectionView
    }()
}

