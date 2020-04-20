//
//  YXSNoticeListCell.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/29.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//
import UIKit
import NightNight

class SLNoticeListHomeCell: YXSNoticeListCell {
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier,isShowTag: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YXSNoticeListCell: YXSHomeBaseCell {
    convenience override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.init(style: style, reuseIdentifier: reuseIdentifier,isShowTag: false)
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, isShowTag: Bool) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.isShowTag = isShowTag
        
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

            redView.snp.makeConstraints { (make) in
                make.right.equalTo(-15)
                make.top.equalTo(0)
                make.size.equalTo(CGSize.init(width: 26, height: 29))
            }
        }else{
            topTimeLabel.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(19)
            }
            
            sourceView.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 65, height: 65))
                make.top.equalTo(19)
                make.right.equalTo(-15)
            }
            
            recallView.snp.remakeConstraints { (make) in
                make.right.equalTo(-8.5)
                make.size.equalTo(CGSize.init(width: 38, height: 38))
                make.bottom.equalTo(-8.5)
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
    
    override func yxs_setCellModel(_ model: YXSHomeListModel){
        self.model = model
        setNoticeUI()
    }
    
    // MARK: - action
    override func showAllClick(){
        model.isShowAll = !model.isShowAll
        showAllControl.isSelected = model.isShowAll
        cellBlock?(.showAll)
    }
    override func yxs_recallClick(){
        cellBlock?(.recall)
    }
    
    @objc override func readClick(){
        if model.needReceipt{
            cellBlock?(.noticeReceipt)
        }else{
            cellBlock?(.read)
        }
    }
    
    // MARK: - UI
    private func initUI(){
        contentView.addSubview(bgContainView)
        bgContainView.addSubview(recallView)
        
        bgContainView.addSubview(contentLabel)
        bgContainView.addSubview(nameTimeLabel)
        bgContainView.addSubview(topTimeLabel)
        bgContainView.addSubview(showAllControl)
        bgContainView.addSubview(sourceView)
        bgContainView.addSubview(visibleView)
        bgContainView.addSubview(classLabel)
        bgContainView.addSubview(readButton)
    }
    private func layout(){
        bgContainView.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0).priorityHigh()
        }
    }
    
    // MARK: - LazyLoad
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var visibleView: YXSCustomImageControl = {
        let visibleView = YXSCustomImageControl.init(imageSize: CGSize.init(width: 18, height: 18), position: YXSImagePositionType.left, padding: 7)
        visibleView.font = UIFont.systemFont(ofSize: 13)
        visibleView.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        visibleView.locailImage = "visible"
        visibleView.isUserInteractionEnabled = false
        return visibleView
    }()
}

extension YXSNoticeListCell{
    func setNoticeUI(){
        recallView.isHidden = true
        redView.isHidden = true
        stickView.isHidden = true
        self.isTop = model.isTop == 1
        
        if isShowTag{
            setTagUI("通知", backgroundColor: UIColor.yxs_hexToAdecimalColor(hex: "#E1EBFE"), textColor: kBlueColor)
        }
        ///红点
        if YXSPersonDataModel.sharePerson.personRole == .PARENT,YXSLocalMessageHelper.shareHelper.yxs_isLocalMessage(serviceId: model.serviceId ?? 1001, childId: model.childrenId ?? 0){
            redView.isHidden = false
        }
        
        UIUtil.yxs_setLabelAttributed(nameTimeLabel, text: ["\(model.teacherName ?? "")", "  |  \(model.createTime?.yxs_Time() ?? "")"], colors: [MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#4B4E54"), night: UIColor.yxs_hexToAdecimalColor(hex: "#4B4E54")),MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))])
        classLabel.text = model.className
        topTimeLabel.text = model.createTime?.date(withFormat: kCommonDateFormatString)?.yxs_homeTimeWeek()
        setSourceViewData()
        
        
        visibleView.locailImage = "visible"
        visibleView.imageSize = CGSize.init(width: 18, height: 18)

        UIUtil.yxs_setLabelParagraphText(contentLabel, text: model.content,removeSpace:  !model.isShowAll && model.needShowAllButton)
        showAllControl.isSelected = model.isShowAll
        contentLabel.numberOfLines = model.isShowAll ? 0 : 2
        
        sourceView.isHidden = !model.hasSource
        
        contentLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(topTimeLabel.snp_bottom).offset(YXSHomeListModel.midMagin)
            make.width.equalTo(model.contentLabelWidth)
        }

        
        let isTeacher: Bool = YXSPersonDataModel.sharePerson.personRole == .TEACHER
        if model.needShowAllButton{
            showAllControl.isHidden = false
            showAllControl.snp.remakeConstraints { (make) in
                make.left.equalTo(contentLabel)
                make.top.equalTo(classLabel.snp_bottom).offset(9)
                make.height.equalTo(26)
            }
        }else{
            showAllControl.isHidden = true
            showAllControl.snp.removeConstraints()
        }
        
        //老师所有处理
        if isTeacher{
            readButton.isHidden = true
            visibleView.isHidden = false
            if model.teacherId == yxs_user.id{
                recallView.isHidden = false
            }
            
            if model.needReceipt{
                visibleView.locailImage = "yxs_notice_reply_gray"
                visibleView.imageSize = CGSize.init(width: 20.5, height: 15)
                UIUtil.yxs_setLabelAttributed(visibleView.textLabel, text: ["\(model.commitCount)", "/\(model.memberCount ?? 0)"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), kTextLightColor])
            }else{
                UIUtil.yxs_setLabelAttributed(visibleView.textLabel, text: ["\(model.readCount)", "/\(model.memberCount ?? 0)"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), kTextLightColor])
            }
            
            if isShowTag{
                visibleView.snp.remakeConstraints { (make) in
                    make.height.equalTo(18)
                    make.right.equalTo(-15)
                    if model.isShowAll{
                        //                make.top.equalTo(fromLabel.snp_bottom).offset(7.5)
                        make.centerY.equalTo(classLabel)
                    }else{
                        if model.hasSource{
                            make.top.equalTo(sourceView.snp_bottom).offset(12.5)
                        }else{
                            make.centerY.equalTo(classLabel)
                        }
                    }
                }
            }else{
                visibleView.snp.remakeConstraints { (make) in
                    make.height.equalTo(22)
                    make.top.equalTo(classLabel.snp_bottom).offset(12)
                    make.left.equalTo(classLabel)
                }
            }

        }else{
            visibleView.isHidden = true
            readButton.isHidden = false
            changeReadUI(model.isRead)
        }
        // 老师提交 25
        classLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(contentLabel.snp_bottom).offset(37)
            make.left.equalTo(contentLabel)
            make.right.equalTo(-80)
        }
    }
}
