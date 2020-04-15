//
//  SLPunchCardSelectWeakView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/27.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

let kYXSPunCardDefultWeaks = [YXSPunchCardWeak.init("周一", 2),
YXSPunchCardWeak.init("周二", 3),
YXSPunchCardWeak.init("周三", 4),
YXSPunchCardWeak.init("周四", 5),
YXSPunchCardWeak.init("周五", 6),
YXSPunchCardWeak.init("周六", 7),
YXSPunchCardWeak.init("周日", 1)]

class YXSPunchCardWeak:NSObject, NSCoding {
    var text: String
    var paramsKey: Int
    var isSelect: Bool = false
    init(_ text: String, _ paramsKey: Int) {
        self.text = text
        self.paramsKey = paramsKey
    }
    @objc required init(coder aDecoder: NSCoder){
        text = aDecoder.decodeObject(forKey: "text") as! String
        paramsKey = aDecoder.decodeInteger(forKey: "paramsKey") as Int
    }
    @objc func encode(with aCoder: NSCoder)
    {
        aCoder.encode(paramsKey, forKey: "paramsKey")
        aCoder.encode(text, forKey: "text")
    }
}

private let controlTag = 101

/// 选择打卡周期
class YXSPunchCardSelectWeakView: UIView {
    @discardableResult static func showAlert(_ yxs_selectweaks: [YXSPunchCardWeak]? = nil,yxs_compelect:((_ modles: [YXSPunchCardWeak]) ->())? = nil) -> YXSPunchCardSelectWeakView{
        let view = YXSPunchCardSelectWeakView(yxs_selectweaks)
        view.yxs_compelect = yxs_compelect
        view.yxs_beginAnimation()
        return view
    }
    
    private var yxs_curruntIndex: Int!
    private var yxs_selectweaks:[YXSPunchCardWeak]?
    private var yxs_dataSource:[YXSPunchCardWeak] = kYXSPunCardDefultWeaks
    
    private var yxs_compelect:((_ modles: [YXSPunchCardWeak]) ->())?
    private init(_ yxs_selectweaks: [YXSPunchCardWeak]? = nil) {
        self.yxs_selectweaks = yxs_selectweaks
        super.init(frame: CGRect.zero)
        
        self.addSubview(yxs_titleLabel)
        self.addSubview(yxs_leftButton)
        self.addSubview(yxs_rightButton)
        
        yxs_leftButton.yxs_addLine(position: .top, lineHeight: 0.5)
        yxs_rightButton.yxs_addLine(position: .top, lineHeight: 0.5)
        yxs_leftButton.yxs_addLine(position: .right, lineHeight: 0.5)
        
        if let yxs_selectweaks = yxs_selectweaks{
            for model in yxs_selectweaks{
                for data in yxs_dataSource{
                    if model.text == data.text{
                        data.isSelect = true
                    }
                }
            }
        }
        
        yxs_layout()
    }
    
    private func yxs_layout(){
        yxs_titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(60)
            make.right.equalTo(-60)
            make.top.equalTo(24)
        }
        
        
        var last: UIView?
        for (index,model) in yxs_dataSource.enumerated(){
            let control = YXSCustomImageControl.init(imageSize: CGSize.init(width: 17, height: 17), position: .right, padding: 29)
            control.setImage(UIImage.init(named: "yxs_class_select"), for: .selected)
            control.setImage(UIImage.init(named: "yxs_class_unselect"), for: .normal)
            control.setTitle(model.text, for: .normal)
            control.setTitle(model.text, for: .selected)
            control.isSelected = model.isSelect
            control.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNightBCC6D4)
            control.tag = index + controlTag
            control.addTarget(self, action: #selector(yxs_changeSelectClick), for: .touchUpInside)
            addSubview(control)
            
            let row = index % 2
            let low = index / 2
            control.snp.makeConstraints { (make) in
                make.height.equalTo(37)
                if row == 0{
                    make.centerX.equalTo(self).offset(-60)
                }else{
                    make.centerX.equalTo(self).offset(60)
                }
                if row == 0 && low == 0{
                    make.top.equalTo(yxs_titleLabel.snp_bottom).offset(14.5)
                }else{
                    if row == 0{
                        make.top.equalTo(last!.snp_bottom).offset(14.5)
                    }else{
                        make.top.equalTo(last!)
                    }
                }
            }
            last = control
        }
        
        yxs_leftButton.snp.makeConstraints { (make) in
            make.height.equalTo(49)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(last!.snp_bottom).offset(9)
            make.left.equalTo(0)
        }
        yxs_rightButton.snp.makeConstraints { (make) in
            make.height.equalTo(49)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(yxs_leftButton)
            make.right.equalTo(0)
            make.left.equalTo(yxs_leftButton.snp_right)
            make.width.equalTo(yxs_leftButton)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func yxs_beginAnimation() {
        UIApplication.shared.keyWindow?.addSubview(yxs_bgWindow)
        
        yxs_bgWindow.addSubview(self)
        yxs_bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.snp.makeConstraints { (make) in
            make.left.equalTo(57.5)
            make.right.equalTo(-57.5)
            make.centerY.equalTo(yxs_bgWindow)
        }
        yxs_bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.yxs_bgWindow.alpha = 1
        })
    }
    
    // MARK: -event
    
    @objc func dismiss(){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.yxs_bgWindow.alpha = 0
        }) { finished in
            self.yxs_bgWindow.removeFromSuperview()
            
        }
    }
    @objc func yxs_changeSelectClick(_ control: UIControl){
        let index = control.tag - controlTag
        let model = yxs_dataSource[index]
        model.isSelect = !model.isSelect
        control.isSelected = model.isSelect
    }
    
    @objc func yxs_certainClick(){
        var selects = [YXSPunchCardWeak]()
        for model in yxs_dataSource{
            if model.isSelect{
                selects.append(model)
            }
        }
        
        if selects.count == 0{
            UIApplication.shared.keyWindow?.makeToast("请选择周期")
            return
        }
        dismiss()
        yxs_compelect?(selects)
        
    }
    
    // MARK: -getter
    
    lazy var yxs_titleLabel : UILabel = {
        let view = getLabel(text: "选择周期")
        view.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#000000"), night: UIColor.white)
        view.font = UIFont.boldSystemFont(ofSize: 17)
        view.numberOfLines = 0
        view.textAlignment = NSTextAlignment.center
        return view
    }()
    
    
    
    lazy var yxs_leftButton : YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#797B7E"), for: .normal)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var yxs_rightButton : YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(kBlueColor, for: .normal)
        button.setTitle("确认", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(yxs_certainClick), for: .touchUpInside)
        return button
    }()
    
    lazy var yxs_bgWindow : UIControl! = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        return view
    }()
}
