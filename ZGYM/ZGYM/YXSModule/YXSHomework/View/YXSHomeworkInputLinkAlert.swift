//
//  YXSHomeworkInputLinkAlert.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/27.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSHomeworkInputLinkAlert: UIView {
    @discardableResult static func showAlert(_ link: String? = nil,compelect:((_ link: String?) ->())? = nil) -> YXSHomeworkInputLinkAlert{
        let view = YXSHomeworkInputLinkAlert(link)
        view.compelect = compelect
        view.beginAnimation()
        return view
    }
    
    var link:String?
    var compelect:((_ link: String?) ->())?
    init(_ link: String? = nil) {
        self.link = link
        super.init(frame: CGRect.zero)
        
        self.addSubview(linkField)
        self.addSubview(certainButton)
        
        layout()
        
        if let link = link{
            linkField.text = link
            certainButton.isSelected = true
        }
        
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
        self.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F7F7F7")
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
            link = linkField.text
        }else{
            certainButton.isSelected = false
        }
        
    }
    @objc func certainClick(){
        linkField.resignFirstResponder()
    }
    
    @objc func finishEvent(){
        if certainButton.isSelected{
            dismiss()
            compelect?(link)
        }else{
            dismiss()
        }
    }
    
    // MARK: -getter
    
    lazy var linkField: YXSQSTextField = {
        let classField = UIUtil.yxs_getTextField(UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0), placeholder: "请输入网址", placeholderColor: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: kNight898F9A))
        classField.backgroundColor = UIColor.white
        classField.cornerRadius = 4
        classField.delegate = self
        classField.addTarget(self, action: #selector(changeTextField), for: .editingChanged)
        return classField
    }()
    
    lazy var certainButton : YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#797B7E"), for: .normal)
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

extension YXSHomeworkInputLinkAlert: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        finishEvent()
    }
}
