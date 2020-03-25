//
//  SLFriendsCommentAlert.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/16.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

class SLFriendsCommentAlert: UIView {
    @discardableResult static func showAlert(_ tips: String? = nil,compelect:((_ content: String?) ->())? = nil) -> SLFriendsCommentAlert{
        let view = SLFriendsCommentAlert(tips)
        view.compelect = compelect
        view.beginAnimation()
        return view
    }
    
    var tips:String?
    var compelect:((_ content: String?) ->())?
    init(_ tips: String? = nil) {
        self.tips = tips
        super.init(frame: CGRect.zero)
        
        self.addSubview(linkField)
        self.addSubview(certainButton)
        
        layout()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_ :)),name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_ :)),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func layout(){
        linkField.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-60)
            make.centerY.equalTo(self)
            make.height.equalTo(39)
        }
        certainButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 39, height: 30))
            make.right.equalTo(-10)
            make.centerY.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginAnimation() {
        UIApplication.shared.keyWindow?.addSubview(bgWindow)
        
        bgWindow.addSubview(self)
        bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#F7F7F7")
        self.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(60.5)
        }
        bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 1
        })
        
        linkField.becomeFirstResponder()
    }
    
    // MARK: - Notification
    @objc func keyBoardWillShow(_ notification:Notification){
        let user_info = notification.userInfo
        let keyboardRect = (user_info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.snp.remakeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(60.5)
            make.bottom.equalTo(-keyboardRect.height)
        }
        
    }
    @objc func keyBoardWillHide(_ notification:Notification){
        self.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(60.5)
        }
    }
    
    // MARK: -event
    
    @objc func dismiss(){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 0
        }) { finished in
            self.bgWindow.removeFromSuperview()
            
        }
    }
    @objc func changeTextField(){
        if linkField.text!.count > 0{
            certainButton.isSelected = true
        }else{
            certainButton.isSelected = false
        }
        
    }
    @objc func certainClick(){
        linkField.resignFirstResponder()
    }
    
    func finishEvent(){
        if certainButton.isSelected{
            dismiss()
            compelect?(linkField.text!)
        }else{
            dismiss()
        }
    }
    
    // MARK: -getter
    
//    lazy var linkField: SLQSTextField = {
//        let classField = UIUtil.sl_getTextField(UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0), placeholder: tips, placeholderColor: UIColor.sl_hexToAdecimalColor(hex: "#C4CDDA"), mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: UIColor.white))
//        classField.backgroundColor = UIColor.white
//        classField.cornerRadius = 4
//        //        classField.delegate = self
//        classField.addTarget(self, action: #selector(changeTextField), for: .editingChanged)
//        return classField
//    }()
    
    lazy var linkField: SLPlaceholderTextView = {
        let textView = SLPlaceholderTextView()
        textView.placeholder = tips ?? ""
        textView.font = kTextMainBodyFont
        textView.placeholderColor = UIColor.sl_hexToAdecimalColor(hex: "#C4CDDA")
        textView.textColor = kTextMainBodyColor
        textView.backgroundColor = UIColor.white
        textView.contentInset = UIEdgeInsets.init(top: 5, left: 15, bottom: 0, right: 0)
//        let classField = UIUtil.sl_getTextField(UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0), placeholder: tips, placeholderColor: , mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: UIColor.white))
        textView.backgroundColor = UIColor.white
        textView.cornerRadius = 4
        textView.delegate = self
        textView.textDidChangeBlock = {[weak self](_)
             in
            guard let strongSelf = self else { return }
            strongSelf.changeTextField()
        }
//        textView.addTarget(self, action: #selector(changeTextField), for: .editingChanged)
        return textView
    }()
    
    lazy var certainButton : SLButton = {
        let button = SLButton.init()
        button.setTitleColor(UIColor.sl_hexToAdecimalColor(hex: "#797B7E"), for: .normal)
        button.setTitle("取消", for: .normal)
        button.setTitle("确认", for: .selected)
        button.setTitleColor(kTextMainBodyColor, for: .normal)
        button.setTitleColor(kBlueColor, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(certainClick), for: .touchUpInside)
        return button
    }()
    
    lazy var bgWindow : UIControl! = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        return view
    }()
}

extension SLFriendsCommentAlert: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        finishEvent()
    }
}
