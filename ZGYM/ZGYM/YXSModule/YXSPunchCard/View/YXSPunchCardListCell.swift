//
//  YXSPunchCardListCell.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/27.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
class YXSPunchCardListHomeCell: YXSPunchCardListCell {
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier,isShowTag: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YXSPunchCardListCell: YXSHomeBaseCell {
    convenience override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.init(style: style, reuseIdentifier: reuseIdentifier,isShowTag: false)
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, isShowTag: Bool) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.isWaterfallCell = isShowTag
        
        initUI()
        layout()
        initCommonUI()
        if isShowTag{
            topTimeLabel.snp.makeConstraints { (make) in
                make.left.equalTo(68)
                make.centerY.equalTo(tagLabel)
                make.width.equalTo(SCREEN_WIDTH - 30 - 15 - 45)
            }
        }else{
            nameTimeLabel.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(19)
                make.width.equalTo(SCREEN_WIDTH - 30 - 15 - 45)
            }
            recallView.snp.remakeConstraints { (make) in
                make.right.equalTo(-8.5)
                make.bottom.equalTo(commonStatusButton.snp_top).offset(-8.5)
                make.size.equalTo(CGSize.init(width: 38, height: 38))
            }
            topTimeLabel.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var punchCardModel: YXSPunchCardModel!
    
    var isAgenda: Bool = false
    
    func yxs_setCellModel(_ model: YXSPunchCardModel){
        punchCardModel = model
        setPunchCardUI()
    }
    
    override func yxs_setCellModel(_ model: YXSHomeListModel) {
        self.model = model
        setPunchCardUI()
    }
    
    // MARK: -action
    
    override func yxs_recallClick(){
        cellBlock?(.recall)
    }
    
    override func stickClick(){
        if model != nil{
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER && model.teacherId == yxs_user.id{
                cellBlock?(.cancelStick)
            }
        }else{
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER && punchCardModel.teacherId == yxs_user.id{
                cellBlock?(.cancelStick)
            }
        }
        
    }

    @objc func punchStatusClick(){
        if YXSPersonDataModel.sharePerson.personRole == .PARENT{
            cellBlock?(.goPunch)
        }else{
            cellBlock?(.punchRemind)
        }
    }
    
    // MARK: -UI
    private func initUI(){
        contentView.addSubview(bgContainView)
        
        bgContainView.addSubview(recallView)
        
        bgContainView.addSubview(contentLabel)
        bgContainView.addSubview(nameTimeLabel)
        bgContainView.addSubview(topTimeLabel)
        bgContainView.addSubview(punchStatusLabel)
        bgContainView.addSubview(commonStatusButton)
        bgContainView.addSubview(punchTaskLabel)
        bgContainView.addSubview(classLabel)
    }
    private func layout(){
        bgContainView.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0).priorityHigh()
        }
        if isWaterfallCell{
            nameTimeLabel.snp.makeConstraints { (make) in
                make.left.equalTo(classLabel)
                make.bottom.equalTo(classLabel.snp_top).offset(-10)
                make.right.equalTo(classLabel)
            }
            contentLabel.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(topTimeLabel.snp_bottom).offset(YXSHomeListModel.midMagin)
                make.right.equalTo(-15)
            }
        }else{
            contentLabel.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(nameTimeLabel.snp_bottom).offset(YXSHomeListModel.midMagin)
                make.right.equalTo(-15)
            }
        }
        
        punchTaskLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentLabel)
            make.top.equalTo(classLabel.snp_bottom).offset(10)
        }
        punchStatusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentLabel)
            make.top.equalTo(punchTaskLabel.snp_bottom).offset(14)
        }
    }
    
    // MARK: -getter&setter
    
    lazy var contentLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.numberOfLines = 2
        return label
    }()
    //打卡
    lazy var punchStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = kRedMainColor
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var commonStatusButton: UIButton = {
        let button = UIButton.init()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(punchStatusClick), for: .touchUpInside)
        return button
    }()
    
    lazy var punchTaskLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
}


// MARK: -打卡UI
extension YXSPunchCardListCell{
    func setPunchCardUI(){
        recallView.isHidden = true
        punchStatusLabel.isHidden = true
        commonStatusButton.isUserInteractionEnabled = isAgenda ? false : true
        redView.isHidden = true
        
        stickView.isHidden = true
        
        
        commonStatusButton.layer.cornerRadius = 15
        commonStatusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        var commonStatusButtonSize = CGSize.init(width: 79, height: 32)
        
        
        if isWaterfallCell{
            setTagUI("打卡", backgroundColor: UIColor.yxs_hexToAdecimalColor(hex: "#F4E2DF"), textColor: UIColor.yxs_hexToAdecimalColor(hex: "#E8534C"))
        }
        
        var content: String?
        var createTime: String?
        var teacherName: String?
        var className: String?
        var periodList:  [Int]?
        var currentClockInPeopleCount: Int?
        var currentClockInTotalCount: Int?
        var teacherId: Int?
        
        var currentClockInDayNo: Int?
        var totalDay: Int?
        
        var hasNeedPunch: Bool = false
        var hasPunch: Bool = false
        var hasPunchAll: Bool = false
        var hasPunchFinish: Bool = false
        
        var serviceId: Int?
        var childrenId: Int?
        var isTop: Int?
        if punchCardModel == nil{
            content = model.content?.listReplaceSpaceAndReturn() ?? ""
            createTime = model.createTime ?? ""
            teacherName = model.teacherName ?? ""
            className = model.className ?? ""
            periodList = model.periodList
            hasNeedPunch = model.hasNeedPunch
            hasPunch = model.hasPunch
            currentClockInPeopleCount = model.commitCount
            currentClockInTotalCount = model.memberCount
            hasPunchFinish = model.hasPunchFinish
            hasPunchAll = model.hasPunchAll
            teacherId = model.teacherId
            
            serviceId = model.serviceId
            childrenId = model.childrenId
            isTop = model.isTop
            
            currentClockInDayNo = (model.totalDay ?? 0) - (model.surplusClockInDayCount ?? 0)
            totalDay = model.totalDay
        }else{
            content = punchCardModel.title?.listReplaceSpaceAndReturn() ?? ""
            createTime = punchCardModel.createTime ?? ""
            teacherName = punchCardModel.teacherName ?? ""
            className = punchCardModel.className ?? ""
            periodList = punchCardModel.periodList
            hasNeedPunch = punchCardModel.hasNeedPunch
            hasPunch = punchCardModel.hasPunch
            currentClockInPeopleCount = punchCardModel.currentClockInPeopleCount
            currentClockInTotalCount = punchCardModel.currentClockInTotalCount
            hasPunchFinish = punchCardModel.hasPunchFinish
            hasPunchAll = punchCardModel.hasPunchAll
            teacherId = punchCardModel.teacherId
            
            serviceId = punchCardModel.clockInId
            childrenId = punchCardModel.childrenId
            isTop = punchCardModel.isTop
            
            currentClockInDayNo = (punchCardModel.totalDay ?? 0) - (punchCardModel.surplusClockInDayCount ?? 0)
            totalDay = punchCardModel.totalDay
        }
        
        self.isTop = isTop == 1
        
        if YXSPersonDataModel.sharePerson.personRole == .PARENT,YXSLocalMessageHelper.shareHelper.yxs_isLocalMessage(serviceId: serviceId ?? 1001, childId: childrenId ?? 0){
            redView.isHidden = false
        }
        
        contentLabel.text = content
        UIUtil.yxs_setLabelAttributed(nameTimeLabel, text: ["\(teacherName ?? "")", "  |  \(createTime?.yxs_Time() ?? "")"], colors: [MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#4B4E54"), night: UIColor.yxs_hexToAdecimalColor(hex: "#4B4E54")),MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))])
        classLabel.text = className
        topTimeLabel.text = createTime?.date(withFormat: kCommonDateFormatString)?.yxs_homeTimeWeek()
        
        punchTaskLabel.text = "剩余天数:\(currentClockInDayNo ?? 0)/\(totalDay ?? 0)  \(self.yxs_weakText(periodList: periodList))"
        if YXSPersonDataModel.sharePerson.personRole == .PARENT{
            let showGoToPunch = hasNeedPunch && !hasPunch
            if showGoToPunch{
                commonStatusButton.layer.borderWidth = 1
                commonStatusButton.layer.borderColor = kRedMainColor.cgColor
                commonStatusButton.backgroundColor = UIColor.clear
                commonStatusButton.setTitleColor(kRedMainColor, for: .normal)
                commonStatusButton.setTitle("去打卡", for: .normal)
                punchStatusLabel.text = "今日打卡\(currentClockInPeopleCount ?? 0)/\(currentClockInTotalCount ?? 0)"
            }
            else{
                punchStatusLabel.isHidden = false
                if hasPunch{
                    punchStatusLabel.text = "今日打卡完成"
                    commonStatusButton.layer.borderWidth = 0
                    commonStatusButton.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#38B16B"), for: .normal)
                    commonStatusButton.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#DFF3EC")
                    commonStatusButton.setTitle("已打卡", for: .normal)
                }else{
                    punchStatusLabel.text = "今日无需打卡"
                    commonStatusButton.layer.borderWidth = 0
                    commonStatusButton.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#E8534C"), for: .normal)
                    commonStatusButton.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F4E2DF")
                    commonStatusButton.setTitle("进行中", for: .normal)
                }
                commonStatusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
                commonStatusButtonSize = CGSize.init(width: 70, height: 19)
                commonStatusButton.cornerRadius = 9.5
            }
            
        }else{
            if teacherId == yxs_user.id{
                recallView.isHidden = false
            }
            punchStatusLabel.isHidden = false

            
        if hasNeedPunch{
                if hasPunchAll{
                    commonStatusButton.layer.borderWidth = 0
                    commonStatusButton.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#E8534C"), for: .normal)
                    commonStatusButton.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F4E2DF")
                    commonStatusButton.setTitle("进行中", for: .normal)
                    punchStatusLabel.text = "今日打卡完成"
                    commonStatusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
                    commonStatusButtonSize = CGSize.init(width: 70, height: 19)
                    commonStatusButton.cornerRadius = 9.5
                }else{
                    commonStatusButton.layer.borderWidth = 1
                    commonStatusButton.layer.borderColor = kRedMainColor.cgColor
                    commonStatusButton.backgroundColor = UIColor.clear
                    commonStatusButton.setTitleColor(kRedMainColor, for: .normal)
                    commonStatusButton.setTitle(isAgenda ? "去查看" : "去提醒", for: .normal)
                    
                    punchStatusLabel.text = "今日\((currentClockInTotalCount ?? 0) - (currentClockInPeopleCount ?? 0))人未打卡"
                }
            }else{
                commonStatusButton.layer.borderWidth = 0
                commonStatusButton.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#E8534C"), for: .normal)
                commonStatusButton.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F4E2DF")
                commonStatusButton.setTitle("进行中", for: .normal)
                punchStatusLabel.text = "今日无需打卡"
                commonStatusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
                commonStatusButtonSize = CGSize.init(width: 70, height: 19)
                commonStatusButton.cornerRadius = 9.5
            }
            
            
        }
        
        //打卡已结束
        if hasPunchFinish{
            commonStatusButton.layer.borderWidth = 0
            commonStatusButton.setTitleColor(UIColor.white, for: .normal)
            commonStatusButton.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
            commonStatusButton.setTitle("已结束", for: .normal)
            punchStatusLabel.text = "查看统计"
            commonStatusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            commonStatusButtonSize = CGSize.init(width: 70, height: 19)
            commonStatusButton.cornerRadius = 9.5
        }
        
        //老师待办区分
        if isAgenda && YXSPersonDataModel.sharePerson.personRole == .TEACHER && currentClockInTotalCount == currentClockInPeopleCount {
            punchStatusLabel.text = "今日打卡完成"
        }
        
        commonStatusButton.snp.remakeConstraints { (make) in
            make.right.equalTo(-15)
            make.size.equalTo(commonStatusButtonSize)
            make.bottom.equalTo(-19)
        }
        
        classLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(contentLabel.snp_bottom).offset(isWaterfallCell ? 37 : 14)
             make.left.equalTo(contentLabel)
             make.right.equalTo(-80)
        }
    }
}
