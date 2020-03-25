//
//  SLPunchCardItemView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/28.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

let kSLPunchCardDetialHeaderViewUpdateHeaderViewEvent = "SLPunchCardDetialHeaderViewUpdateHeaderViewEvent"
let kSLPunchCardDetialHeaderViewRemindEvent = "SLPunchCardDetialHeaderViewRemindEvent"
let kSLPunchCardDetialHeaderViewSignEvent = "SLPunchCardDetialHeaderViewSignEvent"
class SLPunchCardTeacherView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(nameLabel)
        addSubview(headerIconView)
        addSubview(detailLabel)
        addSubview(showAllButton)
        
        
        headerIconView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.size.equalTo(CGSize.init(width: 41, height: 41))
            make.top.equalTo(18)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerIconView.snp_right).offset(13)
            make.centerY.equalTo(headerIconView)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(headerIconView.snp_bottom).offset(17)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(-16)
            make.top.equalTo(titleLabel.snp_bottom).offset(8.5)
        }
        
        showAllButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(titleLabel.snp_bottom).offset(18)
            make.bottom.equalTo(-8.5).priorityHigh()
            make.size.equalTo(CGSize.init(width: 23.5, height: 28.5))
        }
        detailLabel.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showClick(){
        showAllButton.isSelected = !showAllButton.isSelected
        let paragraphStye = NSMutableParagraphStyle()
        paragraphStye.lineSpacing = kMainContentLineHeight
        paragraphStye.lineBreakMode = NSLineBreakMode.byWordWrapping
        let dic = [NSAttributedString.Key.font: kTextMainBodyFont, NSAttributedString.Key.paragraphStyle:paragraphStye]
        let height = UIUtil.sl_getTextHeigh(textStr: detailLabel.text, attributes: dic , width: self.width - 32)
        if showAllButton.isSelected{
            if height < 20 {
                detailLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(titleLabel)
                    make.top.equalTo(titleLabel.snp_bottom).offset(8.5)
                } 
                detailLabel.sizeToFit()
            }
            else {
                detailLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(titleLabel)
                    make.right.equalTo(-16)
                    make.top.equalTo(titleLabel.snp_bottom).offset(8.5)
                    make.height.equalTo(height)
                }
            }

        }else{
            detailLabel.snp.removeConstraints()
        }
        
        showAllButton.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            if showAllButton.isSelected{
                detailLabel.isHidden = false
                make.top.equalTo(detailLabel.snp_bottom).offset(8.5)
            }else{
                detailLabel.isHidden = true
                make.top.equalTo(titleLabel.snp_bottom).offset(18)
            }
            make.bottom.equalTo(-8.5).priorityHigh()
            make.size.equalTo(CGSize.init(width: 23.5, height: 28.5))
        }
        sl_routerEventWithName(eventName:kSLPunchCardDetialHeaderViewUpdateHeaderViewEvent)
        
    }
    
    func setViewModel(_ model: SLPunchCardModel){
        titleLabel.numberOfLines = 0
        titleLabel.text = model.title
        nameLabel.text = model.teacherName
        UIUtil.sl_setLabelParagraphText(detailLabel, text: model.content)
//
//        let height = UIUtil.sl_getTextHeigh(textStr: model.content, attributes: nil , width: SCREEN_WIDTH - 36 - 36)
//        if height < 20 {
//            detailLabel.snp.remakeConstraints { (make) in
//                make.left.equalTo(titleLabel)
//                make.top.equalTo(titleLabel.snp_bottom).offset(8.5)
//            }
//            detailLabel.sizeToFit()
//        }
//        else {
//            detailLabel.snp.remakeConstraints { (make) in
//                make.left.equalTo(titleLabel)
//                make.right.equalTo(-16)
//                make.top.equalTo(titleLabel.snp_bottom).offset(8.5)
//            }
//        }
        headerIconView.sd_setImage(with: URL.init(string: model.teacherAvatar ?? ""),placeholderImage: kImageUserIconTeacherDefualtImage, completed: nil)
    }
    
    lazy var titleLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = kTextMainBodyColor
        label.numberOfLines = 0
        return label
    }()
    
    lazy var nameLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#575A60")
        return label
    }()
    
    lazy var detailLabel: SLEventCopyLabel = {
        let label = SLEventCopyLabel()
        label.font = kTextMainBodyFont
        label.textColor = kTextMainBodyColor
        label.numberOfLines = 0
        return label
    }()
    
    lazy var headerIconView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "sl_punchCard_midline"))
        imageView.cornerRadius = 20.5
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var showAllButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 4, y: 20 + kSafeTopHeight, width: 44, height: 44))
        button.addTarget(self, action: #selector(showClick), for: .touchUpInside)
        button.setImage(UIImage(named: "sl_punchCard_down"), for: .normal)
        button.setImage(UIImage(named: "sl_punchCard_up"), for: .selected)
        return button
    }()
}

class PunchCardDaysView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.height.equalTo(self)
            make.centerX.equalTo(self)
        }
    }
    
    func setViewModel(_ model: SLPunchCardModel){
        UIUtil.sl_setLabelAttributed(titleView.textLabel, text: ["我已经坚持打卡","\(model.clockInDayCount ?? 0)","天"], colors: [UIColor.sl_hexToAdecimalColor(hex: "#575A60"),kBlueColor,UIColor.sl_hexToAdecimalColor(hex: "#575A60")])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleView: SLCustomImageControl = {
        
        let titleView = SLCustomImageControl.init(imageSize: CGSize.init(width: 21.5, height: 23), position: SLImagePositionType.left, padding: 11.5)
        titleView.font = UIFont.boldSystemFont(ofSize: 15)
        titleView.textColor = UIColor.sl_hexToAdecimalColor(hex: "#575A60")
        titleView.locailImage = "sl_punchCard_has_sign"
        return titleView
    }()
    
}


class PunchCardBottomView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        addSubview(signButton)
        signButton.snp.makeConstraints { (make) in
            make.left.equalTo(18.5)
            make.right.equalTo(-18.5)
            make.height.equalTo(49)
            make.centerY.equalTo(self)
        }
        addSubview(signView)
        signView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.centerX.equalTo(self)
        }
        addSubview(exceedView)
        exceedView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.centerX.equalTo(self)
        }
        
        addSubview(notTodayView)
        notTodayView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.centerX.equalTo(self)
        }
        exceedView.isHidden = true
        signView.isHidden = true
        signButton.isHidden = true
        notTodayView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setViewModel(_ model: SLPunchCardModel, calendarModel: CalendarModel? = nil){
        //已打卡
        if SLPersonDataModel.sharePerson.personRole == .PARENT{

            signButton.isHidden = true
            notTodayView.isHidden = true
            signView.isHidden = true
            exceedView.isHidden = true
            let state = calendarModel == nil ? model.state : calendarModel?.responseModel?.state
            if let state = state{
                if state == 20 {
                    signView.isHidden = false
                }else if state == 10{
                    
                    if let calendarModel = calendarModel,calendarModel.toDayDateCompare == .Small{
                        exceedView.isHidden = false
                    }else{
                        signButton.isHidden = false
                    }
                }else if state == 32{
                    notTodayView.isHidden = false
                }
            }
        }else{
            addSubview(labelView)
            labelView.snp.makeConstraints { (make) in
                make.top.equalTo(24)
                make.left.equalTo(16)
            }
            addSubview(sginCountLabel)
            sginCountLabel.snp.makeConstraints { (make) in
                make.top.equalTo(labelView.snp_bottom).offset(17.5)
                make.left.equalTo(labelView)
            }
            addSubview(remaidControl)
            remaidControl.snp.makeConstraints { (make) in
                make.height.equalTo(20)
                make.right.equalTo(-16)
                make.centerY.equalTo(sginCountLabel)
            }
            
            UIUtil.sl_setLabelAttributed(sginCountLabel, text: ["已打卡", "\(model.currentClockInPeopleCount ?? 0)", "/\(model.currentClockInTotalCount ?? 0)人"], colors: [UIColor.sl_hexToAdecimalColor(hex: "#575A60"),kBlueColor,UIColor.sl_hexToAdecimalColor(hex: "#575A60")])
            remaidControl.title = "提醒未打卡学生"
            remaidControl.isHidden = (model.currentClockInPeopleCount ?? 0) == (model.currentClockInTotalCount ?? 0)
            
            if  calendarModel != nil{
                remaidControl.title = "查看未打卡学生"
            }
            if  model.state == 100 {
                remaidControl.title = "查看未打卡学生"
            }
        }
    }
    
    @objc func remaidControlClick(){
        next?.sl_routerEventWithName(eventName: kSLPunchCardDetialHeaderViewRemindEvent)
    }
    
    @objc func signClick(){
        next?.sl_routerEventWithName(eventName: kSLPunchCardDetialHeaderViewSignEvent)
    }
    
    lazy var notTodayView: SLCustomImageControl = {
        let titleView = SLCustomImageControl.init(imageSize: CGSize.init(width: 55, height: 46), position: SLImagePositionType.left, padding: 22)
        titleView.font = UIFont.boldSystemFont(ofSize: 18)
        titleView.textColor = kBlueColor
        titleView.locailImage = "sl_punch_not_today"
        titleView.title = "还没到打卡期哦！"
        return titleView
    }()
    
    lazy var exceedView: SLCustomImageControl = {
        
        let titleView = SLCustomImageControl.init(imageSize: CGSize.init(width: 76.5, height: 47), position: SLImagePositionType.left, padding: 14)
        titleView.font = UIFont.boldSystemFont(ofSize: 18)
        titleView.textColor = UIColor.sl_hexToAdecimalColor(hex: "#898F9A")
        titleView.locailImage = "sl_punch_expcit"
        titleView.title = "您已经过了打卡时间"
        return titleView
    }()
    
    lazy var signView: SLCustomImageControl = {
        let titleView = SLCustomImageControl.init(imageSize: CGSize.init(width: 55, height: 46.5), position: SLImagePositionType.left, padding: 15.5)
        titleView.font = UIFont.boldSystemFont(ofSize: 18)
        titleView.textColor = kBlueColor
        titleView.locailImage = "sl_punch_sign"
        titleView.title = "今日已打卡"
        return titleView
    }()
    
    lazy var labelView: HMLabelView = {
        let labelView = HMLabelView.init(title: "今日打卡")
        return labelView
    }()
    
    lazy var sginCountLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var remaidControl: SLCustomImageControl = {
        let remaidControl = SLCustomImageControl.init(imageSize: CGSize.init(width: 13.4, height: 13.4), position: SLImagePositionType.right, padding: 7.5)
        remaidControl.font = UIFont.boldSystemFont(ofSize: 15)
        remaidControl.textColor = UIColor.sl_hexToAdecimalColor(hex: "#898F9A")
        remaidControl.locailImage = "arrow_gray"
        remaidControl.title = "提醒未打卡学生"
        remaidControl.addTarget(self, action: #selector(remaidControlClick), for: .touchUpInside)
        return remaidControl
    }()
    
    lazy var signButton: SLButton = {
        let signButton = SLButton()
        signButton.setTitleColor(UIColor.white, for: .normal)
        signButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        signButton.addTarget(self, action: #selector(signClick), for: .touchUpInside)
        signButton.sl_gradualBackground(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41 - 37, height: 49), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        signButton.sl_shadow(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41 - 37, height: 49), color: UIColor(red: 0.3, green: 0.45, blue: 0.96, alpha: 0.5), cornerRadius:  24.5, offset: CGSize(width: 0, height: 3))
        signButton.setTitle("立即打卡", for: .normal)
        return signButton
    }()
}



/// 颜色标签label
class HMLabelView: UIView{
    var color: UIColor
    var title: String
    init(_ color: UIColor = kBlueColor, title: String){
        self.color = color
        self.title = title
        super.init(frame: CGRect.zero)
        
        addSubview(leftView)
        addSubview(titleLabel)
        leftView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize.init(width: 6, height: 16.5))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftView.snp_right).offset(10.5)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0).priorityHigh()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var leftView: UIView = {
        let imageView = UIView()
        imageView.backgroundColor = color
        imageView.cornerRadius = 2
        return imageView
    }()
    
    lazy var titleLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = kTextMainBodyColor
        label.text = title
        return label
    }()
    
}
