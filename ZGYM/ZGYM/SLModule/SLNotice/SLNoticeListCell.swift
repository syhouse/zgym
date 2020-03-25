//
//  SLNoticeListCell.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/29.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//
import UIKit
import NightNight

class SLNoticeListHomeCell: SLNoticeListCell {
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier,isShowTag: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SLNoticeListCell: SLHomeBaseCell {
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
            nameTimeLabel.snp.makeConstraints { (make) in
                make.left.equalTo(tagLabel.snp_right).offset(11)
                make.centerY.equalTo(tagLabel)
                make.right.equalTo(-45)
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
            nameTimeLabel.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(19)
                make.right.equalTo(-45)
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
        
        tagLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameTimeLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sl_setCellModel(_ model: SLHomeListModel){
        self.model = model
        setNoticeUI()
    }
    
    // MARK: - action
    override func showAllClick(){
        model.isShowAll = !model.isShowAll
        showAllControl.isSelected = model.isShowAll
        cellBlock?(.showAll)
    }
    override func sl_recallClick(){
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
    
    lazy var visibleView: SLCustomImageControl = {
        let visibleView = SLCustomImageControl.init(imageSize: CGSize.init(width: 18, height: 18), position: SLImagePositionType.left, padding: 7)
        visibleView.font = UIFont.systemFont(ofSize: 13)
        visibleView.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"))
        visibleView.locailImage = "visible"
        visibleView.isUserInteractionEnabled = false
        return visibleView
    }()
}

extension SLNoticeListCell{
    func setNoticeUI(){
        recallView.isHidden = true
        redView.isHidden = true
        stickView.isHidden = true
        self.isTop = model.isTop == 1
        
        if isShowTag{
            setTagUI("通知", backgroundColor: UIColor.sl_hexToAdecimalColor(hex: "#E1EBFE"), textColor: kBlueColor)
        }
        
        if SLPersonDataModel.sharePerson.personRole == .PARENT,SLLocalMessageHelper.shareHelper.sl_isLocalMessage(serviceId: model.serviceId ?? 1001, childId: model.childrenId ?? 0){
            redView.isHidden = false
        }
        
        UIUtil.sl_setLabelAttributed(nameTimeLabel, text: ["\(model.teacherName ?? "")", "  |  \(model.createTime?.sl_Time() ?? "")"], colors: [MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#4B4E54"), night: UIColor.sl_hexToAdecimalColor(hex: "#4B4E54")),MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"))])
        classLabel.text = model.className

        
        visibleView.locailImage = "visible"
        visibleView.imageSize = CGSize.init(width: 18, height: 18)
        
        UIUtil.sl_setLabelParagraphText(contentLabel, text: model.content,removeSpace: !model.isShowAll)
        contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 15 - 20 - 30
        setSourceViewData()


        showAllControl.isSelected = model.isShowAll
        contentLabel.numberOfLines = model.isShowAll ? 0 : 2
        
        // title处理是否有资源
        if model.hasSource{
            contentLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(nameTimeLabel.snp_bottom).offset(14)
                make.right.equalTo(sourceView.snp_left).offset(-20)
            }
            sourceView.isHidden = false
        }else{
            contentLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(nameTimeLabel.snp_bottom).offset(14)
                make.right.equalTo(-15)
            }
            sourceView.isHidden = true
        }
        
        /*
         需要展示全部  已展示全部 未展示全部
         不需要展示全部
         
         是否有资源
         
         家长  需要回执  已回执 未回执   不需要回执  已读 未读
         老师
         
         */
        
        //
        
        let dic = [NSAttributedString.Key.font: kTextMainBodyFont]
        var height: CGFloat = UIUtil.sl_getTextHeigh(textStr: model.content ?? "", attributes: dic , width: SCREEN_WIDTH - 30 - (model.hasSource ? 106.5 : 30))
        height = ((model.content ?? "") == "") ? 0 : height
        model.contentHeight = height
        //需要展示多行
        let showMore = height > 45
        let isTeacher: Bool = SLPersonDataModel.sharePerson.personRole == .TEACHER
        if showMore{
            showAllControl.isHidden = false
            showAllControl.snp.remakeConstraints { (make) in
                make.left.equalTo(contentLabel)
                make.top.equalTo(isTeacher ? visibleView.snp_bottom : classLabel.snp_bottom).offset(9)
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
            if model.teacherId == sl_user.id{
                recallView.isHidden = false
            }
            
            if model.needReceipt{
                visibleView.locailImage = "sl_notice_reply_gray"
                visibleView.imageSize = CGSize.init(width: 20.5, height: 15)
                UIUtil.sl_setLabelAttributed(visibleView.textLabel, text: ["\(model.commitCount)", "/\(model.memberCount ?? 0)"], colors: [UIColor.sl_hexToAdecimalColor(hex: "#898F9A"), kTextLightColor])
            }else{
                UIUtil.sl_setLabelAttributed(visibleView.textLabel, text: ["\(model.readCount)", "/\(model.memberCount ?? 0)"], colors: [UIColor.sl_hexToAdecimalColor(hex: "#898F9A"), kTextLightColor])
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
            make.top.equalTo(contentLabel.snp_bottom).offset(14)
            make.left.equalTo(contentLabel)
            make.right.equalTo(-80)
            //控制cell高度
            if showMore{
                if SLPersonDataModel.sharePerson.personRole == .TEACHER{
                    make.bottom.equalTo(-75)
                }else{
                    make.bottom.equalTo(-45)
                }
            }else{
                if model.hasSource{
                    if SLPersonDataModel.sharePerson.personRole == .TEACHER{
                        if recallView.isHidden == false{
                            make.bottom.equalTo(height - 80)
                        }else{
                            make.bottom.equalTo(-40)
                        }
                    }else{
                        make.bottom.equalTo(height - 85)
                    }
                }else{
                    if SLPersonDataModel.sharePerson.personRole == .TEACHER{
                        make.bottom.equalTo(-40)
                    }else{
                        make.bottom.equalTo(-19)
                    }
                    
                }
            }
        }
    }
}
