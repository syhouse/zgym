//
//  SLHomeworkReadListSectionHeader.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/25.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLHomeworkReadListSectionHeader: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var selectedBlock:((_ selectedIndex:Int)->())?
    var alertClick:((_ view:SLButton)->())?
    var commentClick:((_ view:SLButton)->())?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight20232F)
        self.contentView.sl_addLine(position: .bottom, color: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 1)
        contentView.addSubview(btnTitle1)
        contentView.addSubview(btnTitle2)
        contentView.addSubview(lineView)
        contentView.addSubview(btnAlert)
        
        layout()
        
    }
    
    var model:String? {
        didSet {
            self.btnTitle1.setTitle("已阅（25）", for: .normal)
            self.btnTitle2.setTitle("未阅（15）", for: .normal)
        }
    }
    
    func layout() {
        btnTitle1.snp.makeConstraints({ (make) in
            make.top.equalTo(20)
            make.left.equalTo(20)
        })
        
        btnTitle2.snp.makeConstraints({ (make) in
            make.top.equalTo(20)
            make.left.equalTo(btnTitle1.snp_right).offset(36)
        })
        
        lineView.snp.makeConstraints({ (make) in
            make.top.equalTo(24)
            make.left.equalTo(btnTitle1.snp_right).offset(17)
            make.width.equalTo(0.5)
            make.height.equalTo(17)
        })
        
        
        btnAlert.snp.makeConstraints({ (make) in
            make.top.equalTo(17)
            make.right.equalTo(-15)
            make.width.equalTo(89)
            make.height.equalTo(30)
            make.bottom.equalTo(-17)
        })
        
        
    }
    
    func hiddenComment(isHidden:Bool) {
        if isHidden == false {
            contentView.addSubview(unCommentView)
            unCommentView.addSubview(lbComment)
            unCommentView.addSubview(btnComment)
            unCommentView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.btnTitle1.snp_bottom).offset(10)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(60)
            })
            
            lbComment.snp.makeConstraints({ (make) in
                make.top.equalTo(20)
                make.left.equalTo(20)
                make.right.equalTo(self.snp_centerX)
                make.height.equalTo(20)
            })
            
            btnComment.snp.makeConstraints({ (make) in
                make.top.equalTo(20)
                make.right.equalTo(-20)
                make.width.equalTo(66)
                make.height.equalTo(20)
            })
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setter
//    var selectedIndex:Int = 0
    var selectedIndex: Int? {
        didSet {
            if self.selectedIndex == 0 {
                btnTitle1.isSelected = true
                btnTitle2.isSelected = false
                
            } else {
                btnTitle1.isSelected = false
                btnTitle2.isSelected = true
            }
        }
    }
    
    // MARK: - Action
    @objc func titleButtonClick(sender:SLButton) {
        if sender == btnTitle1 && btnTitle1.isSelected == false{
            selectedIndex = 0
            selectedBlock?(selectedIndex!)
            
        } else if sender == btnTitle2 && btnTitle2.isSelected == false {
            selectedIndex = 1
            selectedBlock?(selectedIndex!)
        }
    }
    
    @objc func alertClick(sender: SLButton) {
        alertClick?(sender)
    }
    
    @objc func commentClick(sender: SLButton) {
           commentClick?(sender)
    }
    
    
    
    // MARK: - LazyLoad
    lazy var btnTitle1: SLButton = {
        let btn = SLButton()
        btn.isSelected = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setMixedTitleColor(MixedColor(normal: kNight898F9A, night: kNightBCC6D4), forState: .normal)
        btn.setMixedTitleColor(MixedColor(normal: k575A60Color, night: kNight5E88F7), forState: .selected)
        btn.addTarget(self, action: #selector(titleButtonClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnTitle2: SLButton = {
        let btn = SLButton()
        
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setMixedTitleColor(MixedColor(normal: kNight898F9A, night: kNightBCC6D4), forState: .normal)
        btn.setMixedTitleColor(MixedColor(normal: k575A60Color, night: kNight5E88F7), forState: .selected)
        btn.addTarget(self, action: #selector(titleButtonClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9")
        return view
    }()
    
    lazy var btnAlert: SLButton = {
        let btn = SLButton()
        btn.setTitle("一键提醒", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setMixedTitleColor(MixedColor(normal: 0x5E88F7, night: 0x5E88F7), forState: .normal)
        btn.layer.mixedBorderColor = MixedColor(normal: 0x5E88F7, night: 0x5E88F7)
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(alertClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var unCommentView: UIView = {
        let view = UIView()
        view.mixedBackgroundColor = MixedColor.init(normal: kF3F5F9Color, night: kNightBackgroundColor)
        return view
    }()
    
    lazy var btnComment: SLButton = {
        let btn = SLButton()
        btn.setTitle("批量点评", for: .normal)
        btn.setMixedTitleColor(MixedColor(normal: kBlueColor, night: kBlueColor), forState: .normal)
        btn.addTarget(self, action: #selector(commentClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var lbComment: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNightBCC6D4)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
}
