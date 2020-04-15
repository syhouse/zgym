//
//  YXSFriendsCommentAlert.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/16.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

class YXSFriendsCommentAlert: UIView {
    @discardableResult static func showAlert(_ tips: String? = nil, maxCount: Int = Int.max,compelect:((_ content: String?) ->())? = nil) -> YXSFriendsCommentAlert{
        let view = YXSFriendsCommentAlert(tips)
        view.textMaxCount = maxCount
        view.compelect = compelect
        view.beginAnimation()
        return view
    }
    
    ///最大数量
    public var textMaxCount = Int.max
    
    private var tips:String?
    private var compelect:((_ content: String?) ->())?
    
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
        let textCount = linkField.text!.count
        if textCount > 0{
            if textCount > textMaxCount{
                linkField.text = linkField.text.mySubString(to: textMaxCount)
                //防止被键盘遮挡，放置在最后一个window上
                MBProgressHUD.yxs_showMessage(message: "最多输入\(textMaxCount)字", inView: UIApplication.shared.windows.last)
            }
            
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
    
//    lazy var linkField: YXSQSTextField = {
//        let classField = UIUtil.yxs_getTextField(UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0), placeholder: tips, placeholderColor: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: UIColor.white))
//        classField.backgroundColor = UIColor.white
//        classField.cornerRadius = 4
//        //        classField.delegate = self
//        classField.addTarget(self, action: #selector(changeTextField), for: .editingChanged)
//        return classField
//    }()
    
    lazy var linkField: YXSPlaceholderTextView = {
        let textView = YXSPlaceholderTextView()
        textView.placeholder = tips ?? ""
        textView.font = kTextMainBodyFont
        textView.placeholderColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        textView.textColor = kTextMainBodyColor
        textView.backgroundColor = UIColor.white
        textView.contentInset = UIEdgeInsets.init(top: 5, left: 15, bottom: 0, right: 0)
//        let classField = UIUtil.yxs_getTextField(UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0), placeholder: tips, placeholderColor: , mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: UIColor.white))
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

extension YXSFriendsCommentAlert: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        finishEvent()
    }

}
