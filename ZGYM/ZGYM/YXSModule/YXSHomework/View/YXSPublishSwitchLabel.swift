//
//  YXSPublishSwitchLabel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/26.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSPublishSwitchLabel: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(swt)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight20232F)
        yxs_addLine(position: .bottom, leftMargin: 15.5)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15.5)
            make.right.equalTo(60)
            make.centerY.equalTo(self)
        }
        swt.snp.makeConstraints { (make) in
            make.right.equalTo(-14.5)
            make.size.equalTo(CGSize.init(width: 43, height: 22))
            make.centerY.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var isSelect: Bool{
        get{
            return swt.isOn
        }
    }
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.text = "接收班级"
        return label
    }()
    
    lazy var swt: UISwitch = {
        let swt = UISwitch(frame: CGRect(x: 0, y: 0, width: 43, height: 22))
        swt.onTintColor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")
        
        return swt
    }()

    
}


class HMRightTextFieldLabel: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(contentField)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        yxs_addLine(position: .bottom, leftMargin: 15.5)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15.5)
            make.right.equalTo(60)
            make.centerY.equalTo(self)
        }
        contentField.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.left.equalTo(60)
            make.bottom.height.equalTo(self)
        }
            NotificationCenter.default.addObserver(self,
            selector: #selector(self.greetingTextFieldChanged),
            name:NSNotification.Name(rawValue:"UITextFieldTextDidChangeNotification"),
            object: self.contentField)
        
       
    }

deinit {
           NotificationCenter.default.removeObserver(self)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -action
    @objc func greetingTextFieldChanged(obj:Notification) {
        self.greetingTextFieldChanged(obj: obj, charslength: 10)
    }
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.text = "名称"
        return label
    }()
    
    lazy var contentField: YXSQSTextField = {
        let contentField = UIUtil.yxs_getTextField(UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0), placeholder: "请输入名称(10个字符内)", placeholderColor: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: UIColor.white))
        contentField.textAlignment = .right
        return contentField
    }()

    
}
