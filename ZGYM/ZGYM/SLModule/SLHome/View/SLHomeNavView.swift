//
//  HomeNavView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/20.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLHomeNavView: UIView {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        
        addSubview(titleLabel)
        addSubview(classButton)
//        addSubview(scanButton)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20 + kSafeTopHeight)
            make.left.equalTo(15)
            make.height.equalTo(44)
            make.bottom.equalTo(0)
        }
        
        
        addSubview(classButton)
        classButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(-10)
//            make.right.equalTo(scanButton.snp_left).offset(-13)
            make.size.equalTo(CGSize.init(width: 28, height: 28))
        }
        
//        scanButton.snp.makeConstraints { (make) in
//            make.centerY.equalTo(titleLabel)
//            make.right.equalTo(-10)
//            make.size.equalTo(CGSize.init(width: 28, height: 28))
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func classButtonCick(){
        sl_routerEventWithName(eventName: kYMHomeTableHeaderViewLookClassEvent)
    }
    @objc func scanClick(){
        sl_routerEventWithName(eventName: kYMHomeTableHeaderViewScanEvent)
    }
    @objc func publishClick(){
        sl_routerEventWithName(eventName: kYMHomeTableHeaderViewPublishEvent)
    }
    
    lazy var titleLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.text = "上午好，张老师"
        return label
    }()
    
    lazy var classButton: SLButton = {
        let button = SLButton.init()
        button.setMixedImage(MixedImage(normal: "class_list_icon", night: "sl_classlist_night"), forState: .normal)
        button.addTarget(self, action: #selector(classButtonCick), for: .touchUpInside)
        return button
    }()
    
//    lazy var scanButton: SLButton = {
//        let button = SLButton.init()
//        button.setMixedImage(MixedImage(normal: "scan", night: "sl_scan_night"), forState: .normal)
//        button.addTarget(self, action: #selector(scanClick), for: .touchUpInside)
//        return button
//    }()
}
