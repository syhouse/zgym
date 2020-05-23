//
//  YXSHomeworkListCell.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/27.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class SLHomeworkListHomeCell: YXSHomeworkListCell {
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier,isShowTag: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YXSHomeworkListCell: YXSHomeBaseCell {
    /// 是否待办事项列表(在设置model前设置)
    public var isAgenda: Bool = false
    
    // MARK: - init
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
            topTimeLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(69)
                make.centerY.equalTo(tagLabel)
            }
            sourceView.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 65, height: 65))
                make.top.equalTo(contentLabel)
                make.right.equalTo(-15)
            }
        }else{
            topTimeLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(19)
            }
            
            sourceView.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 65, height: 65))
                make.top.equalTo(contentLabel)
                make.right.equalTo(-15)
            }
            
            recallView.snp.remakeConstraints { (make) in
                make.right.equalTo(-8.5)
                make.centerY.equalTo(topTimeLabel)
            }
        }
        
        nameTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(classLabel)
            make.bottom.equalTo(classLabel.snp_top).offset(-10)
            make.right.equalTo(classLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override
    override func yxs_setCellModel(_ model: YXSHomeListModel){
        self.model = model
        setHomeWorkUI()
    }
    
    override func showAllClick(){
        model.isShowAll = !model.isShowAll
        showAllControl.isSelected = model.isShowAll
        cellBlock?(.showAll)
    }
    
    override func yxs_recallClick(){
        cellBlock?(.recall)
    }
    
    // MARK: - action
    @objc func punchStatusClick(){
        cellBlock?(.punchRemind)
    }
    
    // MARK: -UI
    private func initUI(){
        contentView.addSubview(bgContainView)
        
        bgContainView.addSubview(recallView)
        
        bgContainView.addSubview(contentLabel)
        bgContainView.addSubview(nameTimeLabel)
        bgContainView.addSubview(topTimeLabel)
        bgContainView.addSubview(showAllControl)
        bgContainView.addSubview(sourceView)
        bgContainView.addSubview(visibleView)
        
        bgContainView.addSubview(readButton)
        
        bgContainView.addSubview(setUpLabel)
        
        bgContainView.addSubview(commonStatusButton)
        
        bgContainView.addSubview(finishView)
        bgContainView.addSubview(commentButton)
        bgContainView.addSubview(classLabel)
        
    }
    private func layout(){
        bgContainView.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0).priorityHigh()
        }
        
        commentButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.bottom.equalTo(-10)
        }
    }
    
    
    // MARK: -getter&setter
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    lazy var visibleView: YXSCustomImageControl = {
        let visibleView = YXSCustomImageControl.init(imageSize: CGSize.init(width: 18, height: 18), position: YXSImagePositionType.left, padding: 7)
        visibleView.font = UIFont.systemFont(ofSize: 13)
        visibleView.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        visibleView.locailImage = "visible"
        visibleView.isUserInteractionEnabled = false
        return visibleView
    }()
    
    lazy var stickImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "Stick"))
        return imageView
    }()
    
    //作业
    lazy var setUpLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        label.font = UIFont.systemFont(ofSize: YXSHomeListModel.smallFontSize)
        return label
    }()
    
    lazy var commonStatusButton: UIButton = {
        let button = UIButton.init()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.isUserInteractionEnabled = false
        //        button.addTarget(self, action: #selector(punchStatusClick), for: .touchUpInside)
        return button
    }()
    
    lazy var finishView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "finish_work"))
        return imageView
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton.init()
        button.setTitleColor(kRedMainColor, for: .normal)
        button.setTitle("待点评", for: .normal)
        button.setTitle("查看点评", for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        //        button.addTarget(self, action: #selector(<#click#>), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        return button
    }()
}

// MARK: -家庭作业UI
extension YXSHomeworkListCell{
    func setHomeWorkUI(){
        visibleView.isHidden = true
        sourceView.isHidden = true
        showAllControl.isHidden = true
        recallView.isHidden = true
        setUpLabel.isHidden = true
        commonStatusButton.isHidden = true
        finishView.isHidden = true
        readButton.isHidden = true
        commentButton.isHidden = true
        redView.isHidden = true
        
        self.isTop = model.isTop == 1
        
        if isWaterfallCell{
            setTagUI("作业", backgroundColor: UIColor.yxs_hexToAdecimalColor(hex: "#DFF3EC"), textColor: UIColor.yxs_hexToAdecimalColor(hex: "#38B16B"))
        }
        
        if YXSPersonDataModel.sharePerson.personRole == .PARENT,YXSLocalMessageHelper.shareHelper.yxs_isLocalMessage(serviceId: model.serviceId ?? 1001, childId: model.childrenId ?? 0){
            redView.isHidden = false
        }
        
        UIUtil.yxs_setLabelAttributed(nameTimeLabel, text: ["\(model.teacherName ?? "")", "  |  \(model.createTime?.yxs_Time() ?? "")"], colors: [MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#4B4E54"), night: UIColor.yxs_hexToAdecimalColor(hex: "#4B4E54")),MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))])
        classLabel.text = model.className
        topTimeLabel.text = model.createTime?.date(withFormat: kCommonDateFormatString)?.yxs_homeTimeWeek()
        setSourceViewData()
        
        UIUtil.yxs_setLabelAttributed(visibleView.textLabel, text: ["\(model.readCount)", "/\(model.memberCount ?? 0)"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), kTextLightColor])
        showAllControl.isSelected = model.isShowAll
        
        sourceView.isHidden = !model.hasSource
        contentLabel.numberOfLines = model.isShowAll ? 0 : 2
        contentLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(topTimeLabel.snp_bottom).offset(YXSHomeListModel.midMagin)
            make.width.equalTo(model.contentLabelWidth)
        }
        UIUtil.yxs_setLabelParagraphText(contentLabel, text: model.content?.listReplaceSpaceAndReturn())
        contentLabel.lineBreakMode = .byTruncatingTail
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            UIUtil.yxs_setLabelAttributed(setUpLabel, text: ["提交情况  ", "\(model.commitCount)","/\(model.memberCount ?? 0)"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"),kRedMainColor,UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")])
        }
        
        let isTeacher: Bool = YXSPersonDataModel.sharePerson.personRole == .TEACHER
        
        if model.needShowAllButton{
            showAllControl.isHidden = false
            showAllControl.snp.remakeConstraints { (make) in
                make.left.equalTo(contentLabel)
                make.top.equalTo(isTeacher ? (model.onlineCommit == 0 ? classLabel.snp_bottom : setUpLabel.snp_bottom) : classLabel.snp_bottom).offset(9)
                make.height.equalTo(26)
            }
        }else{
            showAllControl.isHidden = true
            showAllControl.snp.removeConstraints()
        }
        
        if isTeacher{
            visibleView.isHidden = false
            if model.teacherId == yxs_user.id{
                recallView.isHidden = false
            }
            visibleView.snp.remakeConstraints { (make) in
                make.height.equalTo(18)
                make.right.equalTo(-15)
                if model.isShowAll{
                    make.centerY.equalTo(classLabel)
                }else{
                    if model.hasSource{
                        make.top.equalTo(sourceView.snp_bottom).offset(12.5)
                    }else{
                        make.centerY.equalTo(classLabel)
                    }
                }
            }
            
            if model.onlineCommit == 1{
                setUpLabel.isHidden = false
                setUpLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(contentLabel)
                    make.top.equalTo(classLabel.snp_bottom).offset(10)
                }
            }
            
        }else{
            visibleView.isHidden = true
            readButton.isHidden = false
            changeReadUI(model.isRead)
            //需要在线提交
            if model.onlineCommit == 1{
                if model.isFinish{
                    finishView.isHidden = false
                    finishView.snp.remakeConstraints { (make) in
                        make.top.equalTo(20.5)
                        make.size.equalTo(CGSize.init(width: 62.5, height: 64.5))
                        make.right.equalTo(-103.5)
                    }
                    commentButton.isHidden = false
                    commentButton.isSelected = model.isRemark
                }else{
                    if model.isExpired {
                        commonStatusButton.layer.borderColor = UIColor.clear.cgColor
                        commonStatusButton.setTitleColor(UIColor.white, for: .normal)
                        commonStatusButton.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
                        commonStatusButton.setTitle("已过期", for: .normal)
                        commonStatusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
                        commonStatusButton.cornerRadius = 9.5
                        commonStatusButton.snp.remakeConstraints { (make) in
                            make.right.equalTo(-15)
                            make.size.equalTo(CGSize.init(width: 70, height: 19))
                            make.bottom.equalTo(-13.5)
                        }
                    } else {
                        commonStatusButton.layer.borderWidth = 1
                        commonStatusButton.layer.borderColor = kRedMainColor.cgColor
                        commonStatusButton.setTitleColor(kRedMainColor, for: .normal)
                        commonStatusButton.backgroundColor = UIColor.clear
                        commonStatusButton.setTitle("去完成", for: .normal)
                        commonStatusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                        commonStatusButton.layer.cornerRadius = 15
                        commonStatusButton.snp.remakeConstraints { (make) in
                            make.right.equalTo(-15)
                            make.size.equalTo(CGSize.init(width: 79, height: 32))
                            make.bottom.equalTo(-13.5)
                        }
                    }
                    commonStatusButton.isHidden = false
                    
                }
                
            }
        }
        
        classLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(contentLabel.snp_bottom).offset(37)
            make.left.equalTo(contentLabel)
            make.right.equalTo(-80)
        }
    }
}
