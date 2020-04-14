//
//  TextInputAlertView.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/19.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

/// 带关闭/确认按钮的输入框
class YXSInputAlertView: UIView {

    var complete: ((_ text: String, _ clickButton:YXSButton)->())?
    private var maxLength:Int = 11
    
    static func showIn(target: UIView, maxLength:Int = 11, complete:((_ text: String, _ clickButton:YXSButton) ->())?) -> YXSInputAlertView{
        let view = YXSInputAlertView()
        view.complete = complete
        view.maxLength = maxLength
        
        target.addSubview(view.panelView)
        view.panelView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        
        self.addSubview(self.lbTitle)
        self.addSubview(self.tfInput)
        self.addSubview(self.btnClose)
        self.addSubview(self.btnDone)
        
        self.panelView.addSubview(self)
        self.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.panelView.snp_centerX)
            make.centerY.equalTo(self.panelView.snp_centerY)
            make.width.equalTo(300)
            make.height.equalTo(187)
        })
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        self.lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(24)
            make.left.equalTo(self.snp_left).offset(0)
            make.right.equalTo(self.snp_right).offset(0)
        })
        
        self.tfInput.snp.makeConstraints({ (make) in
            make.top.equalTo(self.lbTitle.snp_bottom).offset(24)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(49)
        })
        
        self.btnClose.snp.makeConstraints({ (make) in
            make.top.equalTo(25)
            make.right.equalTo(-18)
            make.width.height.equalTo(15)
        })
        
        self.btnDone.snp.makeConstraints({ (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(49)
        })
    }
    
    // MARK: - Action
    @objc func doneClick(sender: YXSButton) {
        complete?(tfInput.text!, sender)
        self.panelView.removeFromSuperview()
    }
    
    @objc func closeClick(sender: YXSButton) {
        complete?(tfInput.text!, sender)
        self.panelView.removeFromSuperview()
    }
    
    
    // MARK: - Other
    @objc func accountDidChange(sender: UITextField) {
        guard let _:UITextRange = sender.markedTextRange else {
            //记录当前光标的位置，后面需要进行修改
            let cursorPostion = sender.offset(from: sender.endOfDocument, to: sender.selectedTextRange!.end)

            var str = sender.text!
            //限制最大输入长度
            if str.count > maxLength {
                str = String(str.prefix(maxLength))
            }
            sender.text = str
            //让光标停留在正确的位置
            let targetPosion = sender.position(from: sender.endOfDocument, offset: cursorPostion)!
            sender.selectedTextRange = sender.textRange(from: targetPosion, to: targetPosion)
            return
        }
//        if sender.text!.count > maxLength {
//            let subStr = sender.text!.prefix(maxLength)
//            sender.text = String(subStr)
//
//        } else {
//
//        }
    }
    
    // MARK: - LazyLoad
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: 0x000000, night: 0x000000)
        lb.mixedTextColor = MixedColor(normal: UIColor.black, night: kNightFFFFFF)
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var btnClose: YXSButton = {
        let btn = YXSButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.addTarget(self, action: #selector(closeClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var tfInput: YXSQSTextField = {
        let tf = YXSQSTextField()
        tf.edgeInsets = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        tf.setPlaceholder(ph: "如：李小明妈妈或者张三老师")
        tf.mixedTextColor = MixedColor(normal: UIColor.black, night: kNight898F9A)
        tf.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightForegroundColor)
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.cornerRadius = 5
        tf.addTarget(self, action: #selector(accountDidChange(sender:)), for: .editingChanged)
        return tf
    }()
    
    lazy var btnDone: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("确认", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightForegroundColor)
        btn.setMixedTitleColor(MixedColor(normal: kNight5E88F7, night: kNight898F9A), forState: .normal)
        btn.addTarget(self, action: #selector(doneClick(sender:)), for: .touchUpInside)
        btn.yxs_addLine(position: LinePosition.top, color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
        return btn
    }()
    
    lazy var panelView: UIView = {
        let mask = UIView()
        mask.backgroundColor = UIColor(white: 0.252, alpha: 0.7)
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
