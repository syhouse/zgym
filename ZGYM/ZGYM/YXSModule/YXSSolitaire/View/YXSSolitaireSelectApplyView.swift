//
//  YXSSolitaireSelectApplyView.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/2.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import NightNight
/// 接龙参与或不参与
class YXSSolitaireSelectApplyView: YXSBasePopingView{
    var items: [YXSSelectModel]
    var completionHandler:((_ view:YXSSolitaireSelectApplyView, _ selectedIndex:Int,_ remark: String)->())?
    @discardableResult init (items:[YXSSelectModel],title: String = "请选择" , inTarget: UIView, completionHandler:((_ view:YXSSolitaireSelectApplyView, _ selectedIndex:Int,_ remark: String)->())?) {
        self.items = items
        self.completionHandler = completionHandler
        super.init(frame: CGRect.zero)
        self.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight282C3B)
        self.lbTitle.text = title
        
        self.addSubview(itemView)
        self.addSubview(textView)
        self.addSubview(btnLeft)
        self.addSubview(btnRight)
        
        self.lbTitle.snp.remakeConstraints{ (make) in
            make.top.equalTo(24)
            make.left.equalTo(self.snp_left).offset(0)
            make.right.equalTo(self.snp_right).offset(0)
        }
        
        itemView.snp.makeConstraints { (make) in
            make.width.equalTo(260)
            make.top.equalTo(lbTitle.snp_bottom).offset(24)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        textView.snp.makeConstraints { (make) in
            make.height.equalTo(63.5)
            make.top.equalTo(itemView.snp_bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }

        btnLeft.snp.makeConstraints { (make) in
            make.height.equalTo(49)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(textView.snp_bottom).offset(24)
            make.left.equalTo(0)
        }

        btnRight.snp.makeConstraints { (make) in
            make.height.equalTo(49)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(btnLeft)
            make.right.equalTo(0)
            make.left.equalTo(btnLeft.snp_right)
            make.width.equalTo(btnLeft)
        }

        showIn(target: inTarget)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    @objc func doneClick(sender: YXSButton) {
        var selectIndex = -1
        for (index, model) in items.enumerated(){
            if model.isSelect{
                selectIndex = index
                break
            }
        }
        if selectIndex  != -1 {
            completionHandler?(self, selectIndex, textView.text ?? "")
        }
        else {
            MBProgressHUD.yxs_showMessage(message: "请先选择")
        }

    }
    
    // MARK: - LazyLoad
    lazy var itemView: YXSSelectSingleItemView = {
        let itemView = YXSSelectSingleItemView(frame: CGRect.init(x: 0, y: 0, width: 260, height: 0),items: items, didSelectItem: nil)
        itemView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        return itemView
    }()
    
    lazy var textView : YXSPlaceholderTextView = {
        let textView = YXSPlaceholderTextView()
        textView.limitCount = 20
        textView.font = kTextMainBodyFont
        textView.isScrollEnabled = false
        textView.placeholderMixColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), night: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"))
        textView.mixedTextColor =  MixedColor(normal: kTextMainBodyColor, night: UIColor.white )
        textView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNight20232F)
        textView.placeholder = "填写备注（选填20字以内）"
        textView.textContainerInset = UIEdgeInsets.init(top: 13, left: 12, bottom: 0, right: 12)
        return textView
    }()
    
    lazy var btnLeft : YXSButton = {
        let button = YXSButton.init()
        button.setMixedTitleColor(MixedColor(normal: k797B7EColor, night: kNight898F9A), forState: .normal)
        button.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight383E56)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.yxs_addLine(position: .top, color: UIColor.yxs_hexToAdecimalColor(hex: "#E3ECFF"), leftMargin: 0, rightMargin: 0, lineHeight: 1)
        button.yxs_addLine(position: .right, color: UIColor.yxs_hexToAdecimalColor(hex: "#E3ECFF"), leftMargin: 0, rightMargin: 0, lineHeight: 1)
        button.addTarget(self, action: #selector(cancelClick(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var btnRight : YXSButton = {
        let button = YXSButton.init()
        button.setMixedTitleColor(MixedColor(normal: kBlueColor, night: kNight898F9A), forState: .normal)
        button.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight383E56)
        button.setTitle("确认", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.yxs_addLine(position: .top, color: UIColor.yxs_hexToAdecimalColor(hex: "#E3ECFF"), leftMargin: 0, rightMargin: 0, lineHeight: 1)
        button.addTarget(self, action: #selector(doneClick(sender:)), for: .touchUpInside)
        return button
    }()
}

///多个选项 只可选中一个
class YXSSelectSingleItemView: UIView{
    var items: [YXSSelectModel]
    init(frame: CGRect, items: [YXSSelectModel], lineCount: Int = 2, itemGap: CGFloat = 10, didSelectItem: ((_ index: Int) ->())?) {
        self.items = items
        super.init(frame: frame)
        
        var lastView: UIView!
        for (index, model) in items.enumerated(){
            let btn = YXSButton()
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.setMixedTitleColor(MixedColor(normal: k575A60Color, night: kNightFFFFFF), forState: .normal)
            btn.setMixedTitleColor(MixedColor(normal: kNightFFFFFF, night: kNightFFFFFF), forState: .selected)
            if NightNight.theme == .night{
                btn.setBackgroundImage(UIImage.yxs_image(with: kNight383E56), for: .normal)
                btn.setBackgroundImage(UIImage.yxs_image(with: kBlueColor), for: .selected)

            }else{
                btn.setBackgroundImage(UIImage.yxs_image(with: kF3F5F9Color), for: .normal)
                btn.setBackgroundImage(UIImage.yxs_image(with: kBlueColor), for: .selected)
            }
            
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 2.5
            btn.tag = 1012 + index
            btn.isSelected = model.isSelect
            btn.setTitle(model.text, for: .normal)
            btn.isSelected = model.isSelect
            btn.setTitle(model.text, for: .normal)
            btn.addTarget(self, action: #selector(selectItem), for: .touchUpInside)
            
            
            let itemW: CGFloat = (frame.width - itemGap*CGFloat(lineCount - 1))/CGFloat(lineCount)
            
            self.addSubview(btn)
            
            let row = index % lineCount
            
            btn.snp.remakeConstraints { (make) in
                if index == 0{
                    make.top.equalTo(0).priorityHigh()
                }else if row == 0{
                    make.top.equalTo(lastView!.snp_bottom).offset(itemGap)
                }else{
                     make.top.equalTo(lastView!)
                }
                if index == items.count - 1{
                    make.bottom.equalTo(0).priorityHigh()
                }
                
                if row == 0{
                    make.left.equalTo(0)
                }else{
                    make.left.equalTo(lastView!.snp_right).offset(itemGap)
                }
                
                make.size.equalTo(CGSize.init(width: itemW, height: 41))
            }
            
            lastView = btn
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func selectItem(btn: UIButton){
        if btn.isSelected{
            return
        }
        let curruntIndex = btn.tag - 1012
        for (index, model) in items.enumerated(){
            if curruntIndex == index{
                model.isSelect = true
            }else{
                model.isSelect = false
            }
            
        }
        
        updateUI()
    }
    
    func updateUI(){
        for (index, model) in items.enumerated(){
            let btn = self.viewWithTag(1012 + index) as? UIButton
            if let btn = btn{
                btn.isSelected = model.isSelect
                btn.setTitle(model.text, for: .normal)
            }
        }
    }
}
