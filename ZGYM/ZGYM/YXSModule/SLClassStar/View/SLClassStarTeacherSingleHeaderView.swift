//
//  SLClassStarTeacherSingleHeaderView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/5.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

let kYXSClassStarTeacherSingleHeaderViewQuickCommentEvent = "SLClassStarTeacherSingleHeaderViewQuickCommentEvent"
let kYXSClassStarTeacherSingleHeaderViewSelectEvent = "SLClassStarTeacherSingleHeaderViewSelectEvent"
class SLClassStarTeacherSingleHeaderView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(bgView)
        bgView.addSubview(labelView)
        bgView.addSubview(quickCommentControl)
        bgView.addSubview(selectButton)
        contentView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#D2E4FF")
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(20.5).priorityHigh()
            make.right.equalTo(-20.5).priorityHigh()
            make.top.bottom.equalTo(0).priorityHigh()
        }
        
        labelView.snp.makeConstraints { (make) in
            make.left.equalTo(15.5)
            make.centerY.equalTo(contentView)
        }
        
        quickCommentControl.snp.makeConstraints { (make) in
            make.right.equalTo(-15.5)
            make.height.equalTo(20)
            make.centerY.equalTo(contentView)
        }
        quickCommentControl.isHidden = true
        selectButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10.5)
            make.width.height.equalTo(30)
            make.centerY.equalTo(contentView)
        }
        selectButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func quickCommentControlClick(){
        next?.yxs_routerEventWithName(eventName: kYXSClassStarTeacherSingleHeaderViewQuickCommentEvent)
    }
    
    @objc func selectClick(){
        next?.yxs_routerEventWithName(eventName: kYXSClassStarTeacherSingleHeaderViewSelectEvent)
    }
    
    lazy var labelView: YXSLabelView = {
        let labelView = YXSLabelView.init(title: "点评详情")
        return labelView
    }()
    lazy var quickCommentControl: YXSCustomImageControl = {
        let remaidControl = YXSCustomImageControl.init(imageSize: CGSize.init(width: 13.4, height: 13.4), position: YXSImagePositionType.right, padding: 9.5)
        remaidControl.font = UIFont.boldSystemFont(ofSize: 15)
        remaidControl.textColor = kBlueColor
        remaidControl.locailImage = "arrow_gray"
        remaidControl.title = "快捷点评"
        remaidControl.addTarget(self, action: #selector(quickCommentControlClick), for: .touchUpInside)
        return remaidControl
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        bgView.yxs_addRoundedCorners(corners: [.topLeft,.topRight], radii: CGSize.init(width: 5, height: 5), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 56.5))
        return bgView
    }()
    
    lazy var selectButton: YXSButton = {
        let button = YXSButton.init()
        button.setMixedImage(MixedImage(normal: "yxs_screening", night: "yxs_screening_night"), forState: .normal)
        button.addTarget(self, action: #selector(selectClick), for: .touchUpInside)
        return button
    }()
}
