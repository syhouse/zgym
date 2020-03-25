//
//  PlaceholderTextView.swift
//  ZGYM
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import NightNight

class SLPlaceholderTextView: UITextView{
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
    
    fileprivate lazy var placeholderLabel: SLLabel = {
        let label = SLLabel()
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
        placeholderLabel.sl_y = 5
        placeholderLabel.sl_x = 2
        placeholderLabel.sl_width = self.sl_width - placeholderLabel.sl_x*2
        placeholderLabel.sl_height = placeholderLabel.sizeThatFits(CGSize(width: placeholderLabel.sl_width,height: CGFloat.greatestFiniteMagnitude)).height
    }
    
    @objc func textDidChange()  {
        if text.count > limitCount{
            text = text.mySubString(to: limitCount)
        }
        placeholderLabel.isHidden = self.hasText
        textDidChangeBlock?(self.text)
    }
}

