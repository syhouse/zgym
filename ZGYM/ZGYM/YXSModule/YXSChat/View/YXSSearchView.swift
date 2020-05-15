//
//  YXSSearchView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/21.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSSearchView: UIView {

    var editingDidBeginBlock: ((_ view:UITextField)->())?
    var editingChangedBlock: ((_ view:UITextField)->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = UIColor.white
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        
        self.tfInput.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
//        self.tfInput.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        self.tfInput.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        self.addSubview(self.bgMask)
        self.addSubview(self.panel)
        self.addSubview(self.tfInput)
        self.addSubview(self.btnCancel)
        
        self.bgMask.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        })
        
        self.panel.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.bgMask.snp_centerX)
            make.centerY.equalTo(self.bgMask.snp_centerY)
        })
        
        self.tfInput.snp.makeConstraints({ (make) in
            make.top.equalTo(self.bgMask.snp_top)
            make.left.equalTo(self.panel.snp_left).offset(23)
            make.right.equalTo(self.bgMask.snp_right).offset(-10)
            make.bottom.equalTo(self.bgMask.snp_bottom)
            make.height.equalTo(44)
        })
        
        self.btnCancel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.bgMask.snp_centerY)
            make.left.equalTo(self.bgMask.snp_right).offset(10)
        })
     
        UIView.animate(withDuration: 0.3) {
            self.bgMask.snp.updateConstraints({ (make) in
                make.right.equalTo(-50)
            })

            self.panel.snp.remakeConstraints({ (make) in
                make.left.equalTo(self.bgMask.snp_left).offset(15)
                make.centerY.equalTo(self.bgMask.snp_centerY)
            })

            self.layoutIfNeeded()
        }
//        editingDidBegin()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    @objc func cancelClick(sender: YXSButton) {
        self.tfInput.resignFirstResponder()
    }
    
    @objc func editingDidBegin() {
        editingDidBeginBlock?(self.tfInput)

    }
    
    @objc func editingDidEnd() {
        
        UIView.animate(withDuration: 0.3) {
            self.bgMask.snp.updateConstraints({ (make) in
                make.right.equalTo(-10)
            })
            
            self.panel.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(self.bgMask.snp_centerX)
                make.centerY.equalTo(self.bgMask.snp_centerY)
            })
            
            self.layoutIfNeeded()
        }
    }
    
    @objc func editingChanged() {
        if self.tfInput.text!.count > 0 {
            self.lbTitle.isHidden = true
        } else {
            self.lbTitle.isHidden = false
        }
        self.editingChangedBlock?(self.tfInput)
    }
    
    
    // MARK: - LazyLoad
    lazy var imgIcon: UIImageView = {
        let img = UIImageView()
//        img.backgroundColor = UIColor.red
        img.image = UIImage(named: "yxs_chat_search")
        return img
    }()
    
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: 0x898F9A, night: 0x898F9A)
        lb.text = "搜索"
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    
    /// 占位字符View
    lazy var panel: UIView = {
        let panel = UIView()
        panel.clipsToBounds = true
        panel.addSubview(self.imgIcon)
        panel.addSubview(self.lbTitle)
        self.imgIcon.snp.makeConstraints({ (make) in
            make.top.equalTo(panel.snp_top).offset(0)
            make.left.equalTo(panel.snp_left).offset(0)
            make.bottom.equalTo(panel.snp_bottom).offset(0)
            make.width.equalTo(self.imgIcon.snp_height)
        })
        
        self.lbTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(panel.snp_centerY)
            make.left.equalTo(self.imgIcon.snp_right).offset(10)
            make.right.equalTo(panel.snp_right).offset(0)
        })
        return panel
    }()
    
    lazy var btnCancel: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setMixedTitleColor(MixedColor(normal: UIColor.black, night: kNight898F9A), forState: .normal)
        btn.addTarget(self, action: #selector(cancelClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var tfInput: UITextField = {
        let tf = UITextField()
        tf.clearButtonMode = .whileEditing
        tf.mixedTextColor = MixedColor(normal: 0x222222, night: 0x222222)
        tf.font = UIFont.systemFont(ofSize: 15)
        return tf
    }()
    
    /// 输入框的背景
    lazy var bgMask: UIView = {
        let mask = UIView()
//        mask.backgroundColor = kTableViewBackgroundColor
        mask.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNight2C3144)
        mask.layer.cornerRadius = 22
        return mask
    }()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
