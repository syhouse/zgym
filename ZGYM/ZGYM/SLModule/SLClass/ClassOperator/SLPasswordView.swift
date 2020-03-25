//
//  SLPasswordView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/18.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

@objc protocol SLPasswordViewDelegate {
    //文本发生改变(插入或删除)时调用
    @objc optional func passwordView(textChanged: String, length: Int)
    
    //输入完成(输入的长度与指定的密码最大长度相同)时调用
    func passwordView(textFinished: String)
}

private let kOrginLabel = 101

class SLPasswordView: UIView, UIKeyInput {
    //输入的文本
    private var text: NSMutableString = ""
    
    //文本发生改变时的代理
    var delegate: SLPasswordViewDelegate?
    
    //密码最大长度
    var maxLength: Int = 6
    
    var itemSize: CGSize = CGSize.init(width: 41, height: 41)
    var itemPadding: CGFloat = 13.5
    
    var hasText: Bool {
        return text.length > 0
    }
    
    var viewSize: CGSize{
        return CGSize.init(width: itemSize.width * CGFloat(maxLength) + itemPadding * CGFloat(maxLength - 1), height: itemSize.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func insertText(_ text: String) {
        if self.text.length < maxLength {
            self.text.append(text)
            delegate?.passwordView?(textChanged: self.text as String, length: self.text.length)
            setNeedsDisplay()
            if self.text.length == maxLength {
                self.resignFirstResponder()
                delegate?.passwordView(textFinished: self.text as String)
            }
        }
    }
    
    func deleteBackward() {
        if self.text.length > 0 {
            self.text.deleteCharacters(in: NSRange(location: text.length - 1, length: 1))
            delegate?.passwordView?(textChanged: self.text as String, length: self.text.length)
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if bgView.subviews.count == 0{
            var last: UIView! = nil
            for index in 0..<maxLength{
                let view = SLLabel()
                view.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white)
                view.textAlignment = .center
                view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
                view.font = UIFont.systemFont(ofSize: 18)
                view.borderWidth = 1
                view.tag = kOrginLabel + index
                view.borderColor = UIColor.sl_hexToAdecimalColor(hex: "#E6EAF3")
                bgView.addSubview(view)
                view.snp.makeConstraints { (make) in
                    if index == 0{
                        make.left.equalTo(0)
                    }else{
                        make.left.equalTo(last.snp_right).offset(itemPadding)
                    }
                    make.size.equalTo(itemSize)
                    make.centerY.equalTo(bgView)
                }
                last = view
            }
        }
        for index in 0..<maxLength{
            let view = bgView.viewWithTag(kOrginLabel + index) as! UILabel
            if self.text.length >= index + 1{
                view.text = self.text.substring(with: NSRange.init(location: index, length: 1))
            }else{
                view.text = ""
            }
            
        }
        
    }
    
    //键盘的样式 (UITextInputTraits中的属性)
    var keyboardType: UIKeyboardType {
        get{
            return .numberPad
        } set{
            
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isFirstResponder {
            becomeFirstResponder()
        }
    }
    
    // MARK: -getter&setter
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        return bgView
    }()
}
