//
//  SLPublishSwitchLabel.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/26.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLPublishSwitchLabel: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(swt)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight20232F)
        sl_addLine(position: .bottom, leftMargin: 15.5)
        
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
    
    lazy var titleLabel: SLLabel = {
        let label = SLLabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.text = "接收班级"
        return label
    }()
    
    lazy var swt: UISwitch = {
        let swt = UISwitch(frame: CGRect(x: 0, y: 0, width: 43, height: 22))
        swt.onTintColor = UIColor.sl_hexToAdecimalColor(hex: "#5E88F7")
        
        return swt
    }()

    
}


class HMRightTextFieldLabel: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(contentField)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        sl_addLine(position: .bottom, leftMargin: 15.5)
        
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
        self.greetingTextFieldChanged(obj: obj, length: 10)
    }
    
    lazy var titleLabel: SLLabel = {
        let label = SLLabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.text = "名称"
        return label
    }()
    
    lazy var contentField: SLQSTextField = {
        let contentField = UIUtil.sl_getTextField(UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0), placeholder: "请输入名称(5个字内)", placeholderColor: UIColor.sl_hexToAdecimalColor(hex: "#C4CDDA"), mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: UIColor.white))
        contentField.textAlignment = .right
        return contentField
    }()

    
}
extension HMRightTextFieldLabel: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = textField.text! as NSString
        let newStr = text.replacingCharacters(in: range, with: string)
        if newStr.sl_numberOfChars() > 10{
            return false
        }
        return true
        
    }
}
