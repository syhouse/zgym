//
//  SLPunchCardSelectWeakView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/27.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

let kPunCardDefultWeaks = [PunchCardWeak.init("周一", 2),
PunchCardWeak.init("周二", 3),
PunchCardWeak.init("周三", 4),
PunchCardWeak.init("周四", 5),
PunchCardWeak.init("周五", 6),
PunchCardWeak.init("周六", 7),
PunchCardWeak.init("周日", 1)]

class PunchCardWeak:NSObject, NSCoding {
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
class SLPunchCardSelectWeakView: UIView {
    @discardableResult static func showAlert(_ selectweaks: [PunchCardWeak]? = nil,compelect:((_ modles: [PunchCardWeak]) ->())? = nil) -> SLPunchCardSelectWeakView{
        let view = SLPunchCardSelectWeakView(selectweaks)
        view.compelect = compelect
        view.beginAnimation()
        return view
    }
    
    var curruntIndex: Int!
    var selectweaks:[PunchCardWeak]?
    var dataSource:[PunchCardWeak] = kPunCardDefultWeaks
    
    var compelect:((_ modles: [PunchCardWeak]) ->())?
    init(_ selectweaks: [PunchCardWeak]? = nil) {
        self.selectweaks = selectweaks
        super.init(frame: CGRect.zero)
        
        self.addSubview(titleLabel)
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        
        leftButton.sl_addLine(position: .top, lineHeight: 0.5)
        rightButton.sl_addLine(position: .top, lineHeight: 0.5)
        leftButton.sl_addLine(position: .right, lineHeight: 0.5)
        
        if let selectweaks = selectweaks{
            for model in selectweaks{
                for data in dataSource{
                    if model.text == data.text{
                        data.isSelect = true
                    }
                }
            }
        }
        
        layout()
    }
    
    func layout(){
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(60)
            make.right.equalTo(-60)
            make.top.equalTo(24)
        }
        
        
        var last: UIView?
        for (index,model) in dataSource.enumerated(){
            let control = SLCustomImageControl.init(imageSize: CGSize.init(width: 17, height: 17), position: .right, padding: 29)
            control.setImage(UIImage.init(named: "sl_class_select"), for: .selected)
            control.setImage(UIImage.init(named: "sl_class_unselect"), for: .normal)
            control.setTitle(model.text, for: .normal)
            control.setTitle(model.text, for: .selected)
            control.isSelected = model.isSelect
            control.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNightBCC6D4)
            control.tag = index + controlTag
            control.addTarget(self, action: #selector(changeSelectClick), for: .touchUpInside)
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
                    make.top.equalTo(titleLabel.snp_bottom).offset(14.5)
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
        
        leftButton.snp.makeConstraints { (make) in
            make.height.equalTo(49)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(last!.snp_bottom).offset(9)
            make.left.equalTo(0)
        }
        rightButton.snp.makeConstraints { (make) in
            make.height.equalTo(49)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(leftButton)
            make.right.equalTo(0)
            make.left.equalTo(leftButton.snp_right)
            make.width.equalTo(leftButton)
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
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.snp.makeConstraints { (make) in
            make.left.equalTo(57.5)
            make.right.equalTo(-57.5)
            make.centerY.equalTo(bgWindow)
        }
        bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 1
        })
    }
    
    // MARK: -event
    
    @objc func dismiss(){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 0
        }) { finished in
            self.bgWindow.removeFromSuperview()
            
        }
    }
    @objc func changeSelectClick(_ control: UIControl){
        let index = control.tag - controlTag
        let model = dataSource[index]
        model.isSelect = !model.isSelect
        control.isSelected = model.isSelect
    }
    
    @objc func certainClick(){
        var selects = [PunchCardWeak]()
        for model in dataSource{
            if model.isSelect{
                selects.append(model)
            }
        }
        
        if selects.count == 0{
            UIApplication.shared.keyWindow?.makeToast("请选择周期")
            return
        }
        dismiss()
        compelect?(selects)
        
    }
    
    // MARK: -getter
    
    lazy var titleLabel : UILabel = {
        let view = getLabel(text: "选择周期")
        view.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#000000"), night: UIColor.white)
        view.font = UIFont.boldSystemFont(ofSize: 17)
        view.numberOfLines = 0
        view.textAlignment = NSTextAlignment.center
        return view
    }()
    
    
    
    lazy var leftButton : SLButton = {
        let button = SLButton.init()
        button.setTitleColor(UIColor.sl_hexToAdecimalColor(hex: "#797B7E"), for: .normal)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var rightButton : SLButton = {
        let button = SLButton.init()
        button.setTitleColor(kBlueColor, for: .normal)
        button.setTitle("确认", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(certainClick), for: .touchUpInside)
        return button
    }()
    
    lazy var bgWindow : UIControl! = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        return view
    }()
}
