//
//  SLHomeTableHeaderView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/15.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

let kYMHomeTableHeaderViewOrginTag = 10001

let kYMHomeTableHeaderViewLookClassEvent = "SLHomeTableHeaderViewLookClassEvent"
let kYMHomeTableHeaderViewScanEvent = "SLHomeTableHeaderViewScanEvent"
let kYMHomeTableHeaderViewAgendaClassEvent = "SLHomeTableHeaderViewAgendaClassEvent"
let kYMHomeTableHeaderViewReloadLocationEvent = "SLHomeTableHeaderViewReloadLocationEvent"
let kYMHomeTableHeaderViewPublishEvent = "SLHomeTableHeaderViewPublishEvent"
public enum SLHomeActionEvent: Int{
    case notice
    case homework
    case classstart
    case punchCard
    case solitaire
    case course
    case score
    case addressbook
    case friendCicle
}

private var texts = ["通知", "作业", "班级之星", "打卡", "接龙", "课表", "通讯录"]
private var images = [kNoticeKey, kHomeworkKey, kClassStartKey, kPunchCardKey, kSolitaireKey, kCourseKey, kAddressbookKey]
private var actions = [SLHomeActionEvent.notice,.homework, .classstart, .punchCard, .solitaire, .course, .addressbook]

private let kMaxCount = 8

class SLHomeTableHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#EFF1F7"), night: kNightBackgroundColor)
        addSubview(safeHeaderView)
        addSubview(bgImageView)
        addSubview(titleLabel)
        addSubview(dayLabel)
//        addSubview(scanButton)
        addSubview(agendaView)
        addSubview(classButton)
        
        safeHeaderView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(kSafeTopHeight)
        }
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 23)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(46 + kSafeTopHeight)
            make.left.equalTo(15.5)
            make.height.equalTo(23)
            make.right.equalTo(classButton.snp_left).offset(10)
        }
        
        dayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(17.5)
            make.left.equalTo(titleLabel)
            make.height.equalTo(15)
        }
        
//        scanButton.snp.makeConstraints { (make) in
//            make.centerY.equalTo(titleLabel)
//            make.right.equalTo(-3)
//            make.size.equalTo(CGSize.init(width: 42, height: 42))
//        }
        
        classButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
//            make.right.equalTo(scanButton.snp_left)
            make.right.equalTo(-3)
            make.size.equalTo(CGSize.init(width: 42, height: 42))
        }
        if SLPersonDataModel.sharePerson.personRole == .TEACHER{
            bgImageView.snp.makeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(kSafeTopHeight)
                make.height.equalTo(273)
            }
        }else{
            addSubview(childView)
            childView.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.top.equalTo(dayLabel.snp_bottom).offset(14.5)
                make.height.equalTo(41)
            }
            bgImageView.snp.makeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(kSafeTopHeight)
                make.height.equalTo(315.5)
            }
        }
        
        addSubview(itemBgView)
        itemBgView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            if SLPersonDataModel.sharePerson.personRole == .TEACHER{
                make.top.equalTo(dayLabel.snp_bottom).offset(42.5)
            }else{
                make.top.equalTo(childView.snp_bottom).offset(28.5)
            }
        }
        agendaView.snp.makeConstraints { (make) in
            make.top.equalTo(itemBgView.snp_bottom).offset(13)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0).priorityHigh()
        }
        
        for index in 0..<kMaxCount{
            let control = SLCustomImageControl.init(imageSize: CGSize.init(width: 41, height: 41), position: .top, padding: 14)
            control.tag = index + kYMHomeTableHeaderViewOrginTag
            control.addTarget(self, action: #selector(controlClick), for: .touchUpInside)
            itemBgView.addSubview(control)
            
        }
        setButtonUI()
        
    }
    
    func setButtonUI(){
        var lineCount = 0
        if SLPersonDataModel.sharePerson.showKINDERGARTENUI{
            texts = ["通知", "班级之星", "打卡", "接龙", "食谱", "通讯录"]
            images = [kNoticeKey, kClassStartKey, kPunchCardKey, kSolitaireKey, kFoodKey, kAddressbookKey]
            actions = [SLHomeActionEvent.notice, .classstart, .punchCard, .solitaire, .course, .addressbook]
            lineCount = 3
        }else{
            texts = ["通知", "作业", "班级之星", "打卡", "接龙", "课表", "通讯录"]
            images = [kNoticeKey, kHomeworkKey, kClassStartKey, kPunchCardKey, kSolitaireKey, kCourseKey, kAddressbookKey]
            actions = [SLHomeActionEvent.notice,.homework, .classstart, .punchCard, .solitaire, .course, .addressbook]
            lineCount = 4

        }
        var last: UIView!
        let padding: CGFloat = (SCREEN_WIDTH - 40*2 - 41*CGFloat(lineCount))/CGFloat((lineCount - 1))
        let itemWidth: CGFloat =  41
        let itemMargin =  25
        for index in 0..<kMaxCount{
            let control = viewWithTag(kYMHomeTableHeaderViewOrginTag + index)!
            control.isHidden = true
            control.snp_removeConstraints()
        }

        for index in 0..<texts.count{
            let control = viewWithTag(kYMHomeTableHeaderViewOrginTag + index) as! SLCustomImageControl
            control.title = texts[index]
            control.locailImage = images[index]
            control.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
            control.font = UIFont.systemFont(ofSize: 14)
            let row = index % lineCount
            let low = index / lineCount
            control.snp.makeConstraints { (make) in
                if row == 0{
                    if low == 0{
                        make.top.equalTo(23)
                    }else{
                        make.top.equalTo(last!.snp_bottom).offset(17)
                    }
                    make.left.equalTo(itemMargin)
                }
                else {
                    make.top.equalTo(last!)
                    make.left.equalTo(last!.snp_right).offset(padding)
                    if row == lineCount - 1{
                        make.right.equalTo(-itemMargin)
                    }
                }

                make.width.equalTo(itemWidth)

                if index == texts.count - 1 {
                    make.bottom.equalTo(-23)
                }

            }
            control.isHidden = false
            last = control
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -public
    
    public func setHeaderModel(_ model: SLWeathModel?, agendaCount: Int){
        childView.isHidden = true
        if SLPersonDataModel.sharePerson.personRole == .PARENT{
            childView.setModels(sl_user.children)
            childView.isHidden = false
        }
        titleLabel.text = "\(Date.sl_helloTime(interval: TimeInterval(sl_user.timestamp ?? 0)))，\(sl_user.name ?? "")"
        if let model = model{
            if model.loadFailure{
                dayLabel.setTitle("无法获取位置信息", for: .normal)
            }else{
                dayLabel.setTitle("今天是\((model.date ?? "").sl_Date().toString(format: DateFormatType.custom("MM月dd日"))) \(model.week ?? "") \(model.wea ?? "")  \(model.tem ?? "")℃", for: .normal)
            }
        }else{
            dayLabel.setTitle("无法获取位置信息", for: .normal)
        }
        setButtonUI()
        agendaView.count = agendaCount

    }
    
    // MARK: -action
    @objc func controlClick(control: UIControl){
        let index = control.tag - kYMHomeTableHeaderViewOrginTag
        if SLPersonDataModel.sharePerson.personRole == .PARENT{
            sl_dealHomeAction(actions[index], classId: sl_user.curruntChild?.classId, childModel: sl_user.curruntChild)
        }else{
            sl_dealHomeAction(actions[index], classId: nil, childModel: nil)
        }
        
    }
    
    @objc func agendaSectionClick(){
        sl_routerEventWithName(eventName: kYMHomeTableHeaderViewAgendaClassEvent)
    }
    @objc func classButtonCick(){
        sl_routerEventWithName(eventName: kYMHomeTableHeaderViewLookClassEvent)
    }
    @objc func scanClick(){
        sl_routerEventWithName(eventName: kYMHomeTableHeaderViewScanEvent)
    }
    @objc func reloadLocation(){
        sl_routerEventWithName(eventName: kYMHomeTableHeaderViewReloadLocationEvent)
    }
    @objc func publishClick(){
        sl_routerEventWithName(eventName: kYMHomeTableHeaderViewPublishEvent)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return label
    }()
    
    lazy var dayLabel: SLButton = {
        let label = SLButton()
        label.titleLabel?.font = kTextMainBodyFont
        label.setMixedTitleColor(MixedColor(normal: kTextMainBodyColor, night: UIColor.white), forState: .normal)
        label.addTarget(self, action: #selector(reloadLocation), for: .touchUpInside)
        return label
    }()
    
    lazy var itemBgView: UIView = {
        let itemBgView = UIView()
        itemBgView.mixedBackgroundColor = MixedColor(normal: UIColor.white , night: kNightForegroundColor)
        itemBgView.cornerRadius = 4
        itemBgView.addShadow(ofColor: MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#ECEFF5"), night: UIColor.clear), radius: 10, offset: CGSize(width: 0, height: 2), opacity: 1)
        return itemBgView
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

    lazy var childView: SLHomeChildView = {
        let childView = SLHomeChildView()
        return childView
    }()
    
    lazy var safeHeaderView: UIView = {
        let safeHeaderView = UIView()
        safeHeaderView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "F5F8FE"), night: kNightBackgroundColor)
        return safeHeaderView
    }()
    
    lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.mixedImage = SLPersonDataModel.sharePerson.personRole == .TEACHER ? MixedImage(normal: "bg_teacher", night: "bg_teacher_night") : MixedImage(normal: "bg_parent", night: "bg_parent_night")
        return imageView
    }()
    
    lazy var agendaView: SLHomeAgendaView = {
        let agendaView = SLHomeAgendaView.init(false)
        agendaView.addTaget(target: self, selctor: #selector(agendaSectionClick))
        return agendaView
    }()
}
