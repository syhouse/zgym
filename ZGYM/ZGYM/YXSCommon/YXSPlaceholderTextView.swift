//
//  PlaceholderTextView.swift
//  ZGYM
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import NightNight

/// 设置内边距时使用 textContainerInset
class YXSPlaceholderTextView: UITextView{
    var textDidChangeBlock: ((_ text: String) -> ())?
    var placeholder: String = ""{
        willSet{
            placeholderLabel.text = newValue
            self.setNeedsLayout()
        }
    }
    var placeholderMixColor:MixedColor!{
        willSet{
            placeholderLabel.mixedTextColor = newValue
            self.setNeedsLayout()
        }
    }
    
    var limitCount: Int = 100000
    var placeholderColor: UIColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1){
        willSet{
            placeholderLabel.textColor = newValue
        }
    }
    
    override var text: String!{
        didSet{
            placeholderLabel.isHidden = self.hasText
        }
    }
    
    
    fileprivate lazy var placeholderLabel: YXSLabel = {
        let label = YXSLabel()
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0;
        label.textColor = self.placeholderColor
        return label
    }()
    
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        createUI()
    }
    
    init(){
        super.init(frame: CGRect.zero, textContainer: nil)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func createUI(){
        self.addSubview(placeholderLabel)
        self.backgroundColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    override func layoutSubviews() {
        placeholderLabel.yxs_y = textContainerInset.top
        placeholderLabel.yxs_x = 2 + textContainerInset.left
        placeholderLabel.yxs_width = self.yxs_width - placeholderLabel.yxs_x*2
        placeholderLabel.yxs_height = placeholderLabel.sizeThatFits(CGSize(width: placeholderLabel.yxs_width,height: CGFloat.greatestFiniteMagnitude)).height
    }
    
    @objc func textDidChange(_ notification:Notification)  {
        if let object = notification.object as? UITextView, object == self{
            if text.count > limitCount{
                text = text.mySubString(to: limitCount)
            }
            placeholderLabel.isHidden = self.hasText
            textDidChangeBlock?(self.text)
        }
    }
}

