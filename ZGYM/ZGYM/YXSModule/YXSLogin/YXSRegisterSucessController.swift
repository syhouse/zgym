//
//  YXSRegisterSucessController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/15.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import YYText
import NightNight

class YXSRegisterSucessController: YXSBaseViewController {
    
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
        
        
        yxs_layout()
        
        //网页注册成功
        if let gradeNum = yxs_user.gradeNum{
            let vc = YXSClassAddController.init(classText: gradeNum)
            navigationController?.pushViewController(vc)
        }
    }
    
    // MARK: -UI
    func yxs_layout(){
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
    @objc func yxs_successToRootVC() {
        self.yxs_showTabRoot()
    }
    
    
    @objc func yxs_goArountEvent(){
        yxs_successToRootVC()
    }
    
    @objc func addClassClick(sender: YXSButton){
        if sender.titleLabel?.text == "添加/加入班级" {
            /// 创建班级
            YXSAddClassAlertView.showIn(target: self.view) { (event) in
                if event == .ClassEventAdd {
                    self.navigationController?.pushViewController(YXSClassAddController())
                    
                } else {
                    self.navigationController?.pushViewController(YXSClassCreateController())
                }
            }

        } else {
            /// 加入班级
            self.navigationController?.pushViewController(YXSClassAddController())
        }
    }
    
    // MARK: -private
    
    // MARK: -public
    
    
    // MARK: - getter&setter
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
//        label.textColor = kTextBlackColor
        label.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFFFFFF)
        label.text = "恭喜！注册成功"
        return label
    }()
    
    lazy var topImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: NightNight.theme == .night ?  "yxs_registerSucess_icon" : "register_top"))
        return imageView
    }()
    
    lazy var desLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        label.text = "赶紧加入或创建班级吧！"
        return label
    }()
    
    lazy var addClassButton: YXSButton = {
        
        let addClassButton = YXSButton.init(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49))
        addClassButton.setTitleColor(UIColor.white, for: .normal)
        addClassButton.setImage(UIImage.init(named: "yxs_add"), for: .normal)
        addClassButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        addClassButton.addTarget(self, action: #selector(addClassClick(sender:)), for: .touchUpInside)
        addClassButton.yxs_gradualBackground(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        addClassButton.yxs_shadow(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49), color: UIColor.gray, cornerRadius: 24.5, offset: CGSize(width: 4, height: 4))
        addClassButton.bringSubviewToFront(addClassButton.imageView!)
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            addClassButton.setTitle("添加/加入班级", for: .normal)
        } else {
            addClassButton.setTitle("加入班级", for: .normal)
        }
        
        
        return addClassButton
    }()
    
    lazy var aroundLabel: YYLabel = {
        let label = YYLabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        let text = NSMutableAttributedString(string: "暂不添加，先逛一逛")
        text.yy_setTextHighlight(NSRange.init(location: 0, length: 6 ),color: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"),backgroundColor: nil){ [weak self](view, str, range, rect) in
            guard let strongSelf = self else { return }

        }
        text.yy_setTextHighlight(NSRange.init(location: 6, length: 3 ),color: UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"),backgroundColor: nil){ [weak self](view, str, range, rect) in
            guard let strongSelf = self else { return }
            strongSelf.yxs_goArountEvent()
        }
        text.yy_setFont(UIFont.systemFont(ofSize: 14), range: text.yy_rangeOfAll())
        label.attributedText = text
        return label
    }()
}
