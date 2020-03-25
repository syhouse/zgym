//
//  SLRegisterSucessController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/15.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import YYText
import NightNight

class SLRegisterSucessController: SLBaseViewController {
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        self.fd_interactivePopDisabled = true
        
        view.addSubview(titleLabel)
        view.addSubview(topImageView)
        view.addSubview(desLabel)
        view.addSubview(addClassButton)
        view.addSubview(aroundLabel)
        
        
        sl_layout()
        
        //网页注册成功
        if let gradeNum = sl_user.gradeNum{
            let vc = SLClassAddController.init(classText: gradeNum)
            navigationController?.pushViewController(vc)
        }
    }
    
    // MARK: -UI
    func sl_layout(){
        topImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(120 + kSafeTopHeight)
            make.size.equalTo(CGSize.init(width: 201, height: 161.5))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(topImageView.snp_bottom).offset(28)
        }
        desLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(titleLabel.snp_bottom).offset(16)
        }
        addClassButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(desLabel.snp_bottom).offset(50)
            make.size.equalTo(CGSize.init(width: 230, height: 49))
        }
        aroundLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(addClassButton.snp_bottom).offset(27.5)
        }
    }
    
    // MARK: -loadData
    
    // MARK: - action
    /// 加入/创建班级成功 跳转到首页
    @objc func sl_successToRootVC() {
        self.sl_showTabRoot()
    }
    
    
    @objc func sl_goArountEvent(){
        sl_successToRootVC()
    }
    
    @objc func addClassClick(sender: SLButton){
        if sender.titleLabel?.text == "添加/加入班级" {
            /// 创建班级
            SLAddClassAlertView.showIn(target: self.view) { (event) in
                if event == .ClassEventAdd {
                    self.navigationController?.pushViewController(SLClassAddController())
                    
                } else {
                    self.navigationController?.pushViewController(SLClassCreateController())
                }
            }

        } else {
            /// 加入班级
            self.navigationController?.pushViewController(SLClassAddController())
        }
    }
    
    // MARK: -private
    
    // MARK: -public
    
    
    // MARK: - getter&setter
    lazy var titleLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
//        label.textColor = kTextBlackColor
        label.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFFFFFF)
        label.text = "恭喜！注册成功"
        return label
    }()
    
    lazy var topImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: NightNight.theme == .night ?  "sl_registerSucess_icon" : "register_top"))
        return imageView
    }()
    
    lazy var desLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#C4CDDA")
        label.text = "赶紧加入或创建班级吧！"
        return label
    }()
    
    lazy var addClassButton: SLButton = {
        
        let addClassButton = SLButton.init(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49))
        addClassButton.setTitleColor(UIColor.white, for: .normal)
        addClassButton.setImage(UIImage.init(named: "sl_add"), for: .normal)
        addClassButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        addClassButton.addTarget(self, action: #selector(addClassClick(sender:)), for: .touchUpInside)
        addClassButton.sl_gradualBackground(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        addClassButton.sl_shadow(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49), color: UIColor.gray, cornerRadius: 24.5, offset: CGSize(width: 4, height: 4))
        addClassButton.bringSubviewToFront(addClassButton.imageView!)
        
        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
            addClassButton.setTitle("添加/加入班级", for: .normal)
        } else {
            addClassButton.setTitle("加入班级", for: .normal)
        }
        
        
        return addClassButton
    }()
    
    lazy var aroundLabel: YYLabel = {
        let label = YYLabel()
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#898F9A")
        let text = NSMutableAttributedString(string: "暂不添加，先逛一逛")
        text.yy_setTextHighlight(NSRange.init(location: 0, length: 6 ),color: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"),backgroundColor: nil){ [weak self](view, str, range, rect) in
            guard let strongSelf = self else { return }

        }
        text.yy_setTextHighlight(NSRange.init(location: 6, length: 3 ),color: UIColor.sl_hexToAdecimalColor(hex: "#5E88F7"),backgroundColor: nil){ [weak self](view, str, range, rect) in
            guard let strongSelf = self else { return }
            strongSelf.sl_goArountEvent()
        }
        text.yy_setFont(UIFont.systemFont(ofSize: 14), range: text.yy_rangeOfAll())
        label.attributedText = text
        return label
    }()
}
