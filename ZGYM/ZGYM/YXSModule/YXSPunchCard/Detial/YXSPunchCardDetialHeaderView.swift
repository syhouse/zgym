//
//  SLPunchCardDetialHeaderView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/27.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

let kYXSPunchCardDetialHeaderViewUpdateHeaderViewEvent = "SLPunchCardDetialHeaderViewUpdateHeaderViewEvent"
let kYXSPunchCardDetialHeaderViewRemindEvent = "SLPunchCardDetialHeaderViewRemindEvent"
let kYXSPunchCardDetialHeaderViewSignEvent = "SLPunchCardDetialHeaderViewSignEvent"
let kYXSPunchCardDetialHeaderViewRankEvent = "SLPunchCardDetialHeaderViewRankEvent"

class YXSPunchCardDetialHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F5F4F7"), night: kNight383E56)
        addSubview(messageView)
        addSubview(cardTeacherView)
        addSubview(bottomView)
        bottomView.addSubview(surplusTipsLabel)
        bottomView.addSubview(surplusCountLabel)
        bottomView.addSubview(curruntPunchCountLabel)
        bottomView.addSubview(rightButton)
        bottomView.addSubview(statusLabel)
        layout()
    }
    
    func layout(){
        bottomView.snp.makeConstraints { (make) in
            make.right.left.equalTo(0)
            make.top.equalTo(cardTeacherView.snp_bottom)
            make.height.equalTo(107.5)
        }
        
        surplusTipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(26)
        }
        curruntPunchCountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.top.equalTo(surplusTipsLabel)
            make.left.equalTo(surplusTipsLabel.snp_right)
            make.width.equalTo(surplusTipsLabel)
        }
        surplusCountLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(surplusTipsLabel)
            make.top.equalTo(surplusTipsLabel.snp_bottom).offset(16)
        }
        rightButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(curruntPunchCountLabel)
            make.top.equalTo(curruntPunchCountLabel.snp_bottom).offset(11.5)
            make.size.equalTo(CGSize.init(width: 79, height: 31))
        }
        statusLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(curruntPunchCountLabel)
            make.centerY.equalTo(surplusCountLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var model: YXSPunchCardModel!
    func setHeaderModel(_ model: YXSPunchCardModel, messageModel: YXSPunchCardMessageTipsModel?){
        self.model = model
        
        statusLabel.isHidden = true
        rightButton.isHidden = true
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            if model.hasNeedPunch{
                curruntPunchCountLabel.text = "今日已打卡\(model.currentClockInPeopleCount ?? 0)/\(model.currentClockInTotalCount ?? 0)人"
                if model.hasPunchAll{
                    statusLabel.isHidden = false
                    statusLabel.text = "已完成"
                }else{
                    rightButton.isHidden = false
                }
            }else{
                statusLabel.isHidden = false
                curruntPunchCountLabel.text = "今日无需打卡"
                statusLabel.text = "进行中"
            }
        }else{
            curruntPunchCountLabel.text = "今日已打卡\(model.currentClockInPeopleCount ?? 0)/\(model.currentClockInTotalCount ?? 0)人"
            rightButton.isHidden = false
            rightButton.setTitle("查看排行", for: .normal)
            rightButton.snp.remakeConstraints { (make) in
                make.centerX.equalTo(curruntPunchCountLabel)
                make.top.equalTo(curruntPunchCountLabel.snp_bottom).offset(11.5)
                make.size.equalTo(CGSize.init(width: 89, height: 31))
            }
        }
        
        cardTeacherView.setViewModel(model)
        surplusCountLabel.text = "\(model.currentClockInDayNo ?? 0)/\(model.totalDay ?? 0)"
        
        if let messageModel = messageModel,messageModel.count != 0{
            messageView.snp.remakeConstraints { (make) in
                make.left.right.top.equalTo(0).priorityHigh()
                make.height.equalTo(42.5)
            }
            cardTeacherView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(messageView.snp_bottom).offset(0)
                make.bottom.equalTo(-117.5)
            }
            messageView.isHidden = false
            messageView.setMessageTipsModel(messageModel: messageModel)
        }else{

            cardTeacherView.snp.remakeConstraints { (make) in
                make.left.right.top.equalTo(0)
                make.bottom.equalTo(-117.5)
            }
            messageView.isHidden = true
        }
        
    }
    
    @objc func buttonClick(){
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            next?.yxs_routerEventWithName(eventName: kYXSPunchCardDetialHeaderViewRemindEvent)
        }else{
            next?.yxs_routerEventWithName(eventName: kYXSPunchCardDetialHeaderViewRankEvent)
        }
    }
    
    // MARK: -getter&setter
    
    lazy var cardTeacherView: SLPunchCardTeacherView = {
        let cardTeacherView = SLPunchCardTeacherView()
        cardTeacherView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        return cardTeacherView
    }()
    
    lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        return bottomView
    }()
    
    lazy var surplusTipsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        label.text = "打卡剩余天数"
        label.textAlignment = .center
        return label
    }()
    
    lazy var surplusCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 29)
        label.textColor = kBlueColor
        return label
    }()
    
    lazy var curruntPunchCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        label.textAlignment = .center
        return label
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton.init()
        button.layer.borderWidth = 1
        button.layer.borderColor = kBlueColor.cgColor
        button.setTitleColor(kBlueColor, for: .normal)
        button.backgroundColor = UIColor.clear
        button.cornerRadius = 15.5
        button.setTitle("去提醒", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return button
    }()
    
    lazy var statusLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = kBlueColor
        return label
    }()
    
    lazy var messageView: YXSFriendsCircleMessageView = {
        let messageView = YXSFriendsCircleMessageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 42.5))
        return messageView
    }()
    
}


class SLPunchCardTeacherView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(nameLabel)
        addSubview(headerIconView)
        addSubview(detailLabel)
        addSubview(showAllControl)
        addSubview(classLabel)
        addSubview(btnChat)
        
        yxs_addLine(position: .bottom)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(18)
            make.right.equalTo(-16)
        }
        headerIconView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom).offset(20)
            make.size.equalTo(CGSize.init(width: 41, height: 41))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerIconView.snp_right).offset(13.5)
            make.top.equalTo(headerIconView).offset(1.5)
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                make.right.equalTo(-15)
            }else{
                make.right.equalTo(-103)
            }
        }
        
        classLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerIconView.snp_right).offset(13.5)
            make.top.equalTo(nameLabel.snp_bottom).offset(9)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(-16)
            make.top.equalTo(headerIconView.snp_bottom).offset(24)
        }
        
        btnChat.snp.makeConstraints({ (make) in
            make.centerY.equalTo(headerIconView.snp_centerY)
            make.right.equalTo(-15)
            make.width.equalTo(85)
            make.height.equalTo(31)
        })
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            btnChat.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showAllClick(){
        model.isShowAll = !model.isShowAll
        showAllControl.isSelected = model.isShowAll
        setViewModel(model)
        yxs_routerEventWithName(eventName:kYXSPunchCardDetialHeaderViewUpdateHeaderViewEvent)
    }
    
    @objc func chatTeacher(){
        UIUtil.TopViewController().yxs_pushChatVC(imId: model?.teacherImId ?? "")
    }
    
    var model: YXSPunchCardModel!
    func setViewModel(_ model: YXSPunchCardModel){
        self.model = model
        titleLabel.numberOfLines = 0
        titleLabel.text = model.title
        UIUtil.yxs_setLabelAttributed(nameLabel, text: ["\(model.teacherName ?? "") ", model.createTime?.yxs_Time() ?? ""], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#575A60"),UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")], fonts: [UIFont.systemFont(ofSize: 16),UIFont.systemFont(ofSize: 13)])
        UIUtil.yxs_setLabelParagraphText(detailLabel, text: model.content)
        
        let dic = [NSAttributedString.Key.font: kTextMainBodyFont]
        let height: CGFloat = UIUtil.yxs_getTextHeigh(textStr: model.content ?? "", attributes: dic , width: SCREEN_WIDTH - 16 - 16)
        classLabel.text = model.className
        detailLabel.numberOfLines = model.isShowAll ? 0 : 3
        //需要展示多行
        let showMore = height > 60
        if showMore{
            showAllControl.isHidden = false
            showAllControl.snp.remakeConstraints { (make) in
                make.left.equalTo(titleLabel)
                make.top.equalTo(detailLabel.snp_bottom).offset(10)
                make.height.equalTo(26)
                make.bottom.equalTo(-19)
            }
            detailLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(titleLabel)
                make.right.equalTo(-16)
                make.top.equalTo(headerIconView.snp_bottom).offset(24)
            }
        }else{
            showAllControl.isHidden = true
            showAllControl.snp.removeConstraints()
            detailLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(titleLabel)
                make.right.equalTo(-16)
                make.top.equalTo(headerIconView.snp_bottom).offset(24)
                make.bottom.equalTo(-24)
            }
        }
        headerIconView.sd_setImage(with: URL.init(string: model.teacherAvatar ?? ""),placeholderImage: kImageUserIconTeacherDefualtImage, completed: nil)
    }
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4)
        return label
    }()
    
    lazy var classLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        return label
    }()
    
    lazy var detailLabel: YXSEventCopyLabel = {
        let label = YXSEventCopyLabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var headerIconView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_punchCard_midline"))
        imageView.cornerRadius = 20.5
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var showAllControl: YXSCustomImageControl = {
        let showAllControl = YXSCustomImageControl.init(imageSize: CGSize.init(width: 14, height: 14), position: YXSImagePositionType.right, padding: 5.5)
        showAllControl.mixedTextColor = MixedColor(normal: kBlueColor, night: kBlueColor)
        showAllControl.setTitle("展开", for: .normal)
        showAllControl.setTitle("收起", for: .selected)
        showAllControl.font = UIFont.boldSystemFont(ofSize: 14)
        showAllControl.setImage(UIImage.init(named: "down_gray"), for: .normal)
        showAllControl.setImage(UIImage.init(named: "up_gray"), for: .selected)
        showAllControl.addTarget(self, action: #selector(showAllClick), for: .touchUpInside)
        showAllControl.isSelected = false
        return showAllControl
    }()
    
    
    lazy var btnChat: YXSButton = {
        let btn = YXSButton()
        //        UIFont.boldSystemFont(ofSize: 15)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.setMixedTitleColor(MixedColor(normal: kNight898F9A, night: kNight898F9A), forState: .normal)
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.mixedBorderColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        btn.layer.cornerRadius = 15.5
        btn.addTarget(self, action: #selector(chatTeacher), for: .touchUpInside)
        btn.setTitle("联系老师", for: .normal)
        return btn
    }()
}
