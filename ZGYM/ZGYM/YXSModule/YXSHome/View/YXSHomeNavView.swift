//
//  HomeNavView.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/20.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSHomeNavView: UIView {
    
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
        yxs_routerEventWithName(eventName: kYXSHomeTableHeaderViewLookClassEvent)
    }
    @objc func scanClick(){
        yxs_routerEventWithName(eventName: kYXSHomeTableHeaderViewScanEvent)
    }
    @objc func publishClick(){
        yxs_routerEventWithName(eventName: kYXSHomeTableHeaderViewPublishEvent)
    }
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.text = "上午好，张老师"
        return label
    }()
    
    lazy var classButton: YXSButton = {
        let button = YXSButton.init()
        button.setMixedImage(MixedImage(normal: "class_list_icon", night: "yxs_classlist_night"), forState: .normal)
        button.addTarget(self, action: #selector(classButtonCick), for: .touchUpInside)
        return button
    }()
    
//    lazy var scanButton: YXSButton = {
//        let button = YXSButton.init()
//        button.setMixedImage(MixedImage(normal: "scan", night: "yxs_scan_night"), forState: .normal)
//        button.addTarget(self, action: #selector(scanClick), for: .touchUpInside)
//        return button
//    }()
}
