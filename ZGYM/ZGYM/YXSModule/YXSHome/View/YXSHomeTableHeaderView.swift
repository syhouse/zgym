//
//  YXSHomeTableHeaderView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/15.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

let kYXSHomeTableHeaderViewOrginTag = 10001

let kYXSHomeTableHeaderViewLookClassEvent = "SLHomeTableHeaderViewLookClassEvent"
let kYXSHomeTableHeaderViewScanEvent = "SLHomeTableHeaderViewScanEvent"
let kYXSHomeTableHeaderViewAgendaClassEvent = "SLHomeTableHeaderViewAgendaClassEvent"
let kYXSHomeTableHeaderViewReloadLocationEvent = "SLHomeTableHeaderViewReloadLocationEvent"
let kYXSHomeTableHeaderViewPublishEvent = "SLHomeTableHeaderViewPublishEvent"
//
public enum YXSHomeHeaderActionEvent: Int{
    case notice
    case homework
    case classstart
    case punchCard
    case solitaire
    case course
    case score
    case addressbook
    case friendCicle
    case photo
}

private var kHeaderTexts = ["通知", "作业", "班级之星", "打卡", "接龙", "课表","班级相册", "通讯录"]
private var kHeaderImages = [kNoticeKey, kHomeworkKey, kClassStartKey, kPunchCardKey, kSolitaireKey, kCourseKey,"yxs_photo", kAddressbookKey]
private var kHeaderActions = [YXSHomeHeaderActionEvent.notice,.homework, .classstart, .punchCard, .solitaire, .course, .photo,.addressbook]

private let kMaxCount = 8

class YXSHomeTableHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !isOldUI{
            self.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#EFF1F7"), night: kNightBackgroundColor)
        }
        addSubview(yxs_bgImageView)
        addSubview(yxs_titleLabel)
        addSubview(yxs_dayLabel)
        addSubview(yxs_classButton)
        
        yxs_titleLabel.font = UIFont.boldSystemFont(ofSize: 23)
        yxs_titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(46)
            make.left.equalTo(15.5)
            make.height.equalTo(23)
            make.right.equalTo(yxs_classButton.snp_left).offset(10)
        }
        
        yxs_dayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(yxs_titleLabel.snp_bottom).offset(17.5)
            make.left.equalTo(yxs_titleLabel)
            make.height.equalTo(15)
        }
        
        yxs_classButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(yxs_titleLabel)
            make.right.equalTo(-3).priorityHigh()
            make.size.equalTo(CGSize.init(width: 42, height: 42)).priorityHigh()
        }
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            yxs_bgImageView.snp.makeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(0)
                
                
                if isOldUI{
                    make.height.equalTo(110)
                    make.bottom.equalTo(0).priorityHigh()
                }else{
                    make.height.equalTo(273)
                }
            }
        }else{
            addSubview(yxs_childView)
            yxs_childView.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.top.equalTo(yxs_dayLabel.snp_bottom).offset(14.5)
                make.height.equalTo(41)
            }
            yxs_bgImageView.snp.makeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(0)
                
                if isOldUI{
                    make.height.equalTo(157.5)
                    make.bottom.equalTo(0).priorityHigh()
                }else{
                    make.height.equalTo(315.5)
                }
            }
        }
        
        if !isOldUI{
            addSubview(yxs_agendaView)
            addSubview(yxs_itemBgView)
            yxs_itemBgView.snp.makeConstraints { (make) in
                make.left.equalTo(15).priorityHigh()
                make.right.equalTo(-15).priorityHigh()
                if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                    make.top.equalTo(yxs_dayLabel.snp_bottom).offset(42.5)
                }else{
                    make.top.equalTo(yxs_childView.snp_bottom).offset(28.5)
                }
            }
            yxs_agendaView.snp.makeConstraints { (make) in
                make.top.equalTo(yxs_itemBgView.snp_bottom).offset(13)
                make.left.right.equalTo(0).priorityHigh()
                make.bottom.equalTo(0).priorityHigh()
            }
            
            for index in 0..<kMaxCount{
                let control = YXSCustomImageControl.init(imageSize: CGSize.init(width: 41, height: 41), position: .top, padding: 14)
                control.tag = index + kYXSHomeTableHeaderViewOrginTag
                control.addTarget(self, action: #selector(yxs_controlClick), for: .touchUpInside)
                yxs_itemBgView.addSubview(control)
                
            }
            yxs_setButtonUI()
        }
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -public
    public func setHeaderModel(_ model: YXSWeathModel?, agendaCount: Int){
        yxs_childView.isHidden = true
        if YXSPersonDataModel.sharePerson.personRole == .PARENT{
            yxs_childView.setModels(yxs_user.children)
            yxs_childView.isHidden = false
        }
        yxs_titleLabel.text = "\(Date.yxs_helloTime(interval: TimeInterval(yxs_user.timestamp ?? 0)))，\(yxs_user.name ?? "")"
        if let model = model{
            if model.loadFailure{
                yxs_dayLabel.setTitle("无法获取位置信息", for: .normal)
            }else{
                yxs_dayLabel.setTitle("今天是\((model.date ?? "").yxs_Date().toString(format: DateFormatType.custom("MM月dd日"))) \(model.week ?? "") \(model.wea ?? "")  \(model.tem ?? "")℃", for: .normal)
            }
        }else{
            yxs_dayLabel.setTitle("无法获取位置信息", for: .normal)
        }
        
        if !isOldUI{
            yxs_setButtonUI()
            yxs_agendaView.count = agendaCount
        }
        
    }
    
    // MARK: - action
    @objc func yxs_controlClick(control: UIControl){
        let index = control.tag - kYXSHomeTableHeaderViewOrginTag
        if YXSPersonDataModel.sharePerson.personRole == .PARENT{
            yxs_dealHomeAction(kHeaderActions[index], classId: yxs_user.curruntChild?.classId, childModel: yxs_user.curruntChild)
        }else{
            yxs_dealHomeAction(kHeaderActions[index], classId: nil, childModel: nil)
        }
        
    }
    
    @objc func agendaSectionClick(){
        yxs_routerEventWithName(eventName: kYXSHomeTableHeaderViewAgendaClassEvent)
    }
    @objc func yxs_classButtonCick(){
        yxs_routerEventWithName(eventName: kYXSHomeTableHeaderViewLookClassEvent)
    }
    @objc func reloadLocation(){
        yxs_routerEventWithName(eventName: kYXSHomeTableHeaderViewReloadLocationEvent)
    }
    @objc func publishClick(){
        yxs_routerEventWithName(eventName: kYXSHomeTableHeaderViewPublishEvent)
    }
    
    // MARK: - getter&setter
    lazy var yxs_titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        if isOldUI{
            label.mixedTextColor = MixedColor(normal: UIColor.white, night: UIColor.white)
        }else{
            label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        }
        return label
    }()
    
    lazy var yxs_dayLabel: YXSButton = {
        let label = YXSButton()
        label.titleLabel?.font = kTextMainBodyFont
        label.setMixedTitleColor(MixedColor(normal: isOldUI ? UIColor.white : kTextMainBodyColor, night: UIColor.white), forState: .normal)
        label.addTarget(self, action: #selector(reloadLocation), for: .touchUpInside)
        return label
    }()
    
    lazy var yxs_classButton: YXSButton = {
        let button = YXSButton.init()
        button.setMixedImage(MixedImage(normal: isOldUI ? "yxs_classlist_night" : "class_list_icon", night: "yxs_classlist_night"), forState: .normal)
        button.addTarget(self, action: #selector(yxs_classButtonCick), for: .touchUpInside)
        return button
    }()
    
    lazy var yxs_childView: YXSHomeChildView = {
        let childView = YXSHomeChildView()
        return childView
    }()
    
    lazy var yxs_bgImageView: UIImageView = {
        let imageView = UIImageView()
        if !isOldUI{
            imageView.mixedImage = YXSPersonDataModel.sharePerson.personRole == .TEACHER ? MixedImage(normal: "bg_teacher", night: "bg_teacher_night") : MixedImage(normal: "bg_parent", night: "bg_parent_night")
        }
        return imageView
    }()
    
    lazy var yxs_itemBgView: UIView = {
        let itemBgView = UIView()
        itemBgView.mixedBackgroundColor = MixedColor(normal: UIColor.white , night: kNightForegroundColor)
        itemBgView.cornerRadius = 4
        itemBgView.addShadow(ofColor: MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#ECEFF5"), night: UIColor.clear), radius: 10, offset: CGSize(width: 0, height: 2), opacity: 1)
        return itemBgView
    }()
    
    lazy var yxs_agendaView: YXSHomeAgendaView = {
        let yxs_agendaView = YXSHomeAgendaView.init(false)
        yxs_agendaView.addTaget(target: self, selctor: #selector(agendaSectionClick))
        return yxs_agendaView
    }()
}

///目前不需要
extension YXSHomeTableHeaderView{
    func yxs_setButtonUI(){
        var lineCount = 0
        if YXSPersonDataModel.sharePerson.showKINDERGARTENUI{
            kHeaderTexts = ["通知", "班级之星", "打卡", "接龙", "食谱", "通讯录"]
            kHeaderImages = [kNoticeKey, kClassStartKey, kPunchCardKey, kSolitaireKey, kFoodKey, kAddressbookKey]
            kHeaderActions = [YXSHomeHeaderActionEvent.notice, .classstart, .punchCard, .solitaire, .course, .addressbook]
            lineCount = 4
        }else{
            kHeaderTexts = ["通知", "作业", "班级之星", "打卡", "接龙", "课表", "成绩", "通讯录"]
            kHeaderImages = [kNoticeKey, kHomeworkKey, kClassStartKey, kPunchCardKey, kSolitaireKey, kCourseKey, kScoreKey, kAddressbookKey]
            kHeaderActions = [YXSHomeHeaderActionEvent.notice,.homework, .classstart, .punchCard, .solitaire, .course, .score, .addressbook]
            
            lineCount = 4
            
        }
        var last: UIView!
        let padding: CGFloat = (SCREEN_WIDTH - 40*2 - 41*CGFloat(lineCount))/CGFloat((lineCount - 1))
        let itemWidth: CGFloat =  41
        let itemMargin =  25
        for index in 0..<kMaxCount{
            let control = viewWithTag(kYXSHomeTableHeaderViewOrginTag + index)!
            control.isHidden = true
            control.snp_removeConstraints()
        }
        
        for index in 0..<kHeaderTexts.count{
            let control = viewWithTag(kYXSHomeTableHeaderViewOrginTag + index) as! YXSCustomImageControl
            control.title = kHeaderTexts[index]
            control.locailImage = kHeaderImages[index]
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
                }
                
                make.width.equalTo(itemWidth)
                
                if index == kHeaderTexts.count - 1 {
                    make.bottom.equalTo(-23)
                }
                
            }
            control.isHidden = false
            last = control
        }
    }
}
