//
//  YXSSolitaireListCell.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/2.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class SLSolitaireListHomeCell: YXSSolitaireListCell {
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier,isShowTag: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class YXSSolitaireListCell: YXSHomeBaseCell {
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
    
    
    var solitaireModel :YXSSolitaireModel!
    func yxs_setCellModel(_ model: YXSSolitaireModel){
        self.solitaireModel = model
        setSolitaireUI()
    }
    
    override func yxs_setCellModel(_ model: YXSHomeListModel) {
        self.model = model
        setSolitaireUI()
    }
    
    // MARK: -action
    
    override func showAllClick(){
        if solitaireModel == nil{
            model.isShowAll = !model.isShowAll
            showAllControl.isSelected = model.isShowAll
        }else{
            solitaireModel.isShowAll = !solitaireModel.isShowAll
            showAllControl.isSelected = solitaireModel.isShowAll
        }
        
        
        cellBlock?(.showAll)
    }
    
    override func yxs_recallClick(){
        cellBlock?(.recall)
    }
    
    override func stickClick(){
        if model != nil{
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER && model.teacherId == yxs_user.id{
                cellBlock?(.cancelStick)
            }
        }else{
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER && solitaireModel.teacherId == yxs_user.id{
                cellBlock?(.cancelStick)
            }
        }
        
    }
    
    // MARK: -setTool
    
    // MARK: -UI
    private func initUI(){
        contentView.addSubview(bgContainView)
        bgContainView.addSubview(contentLabel)
        bgContainView.addSubview(showAllControl)
        bgContainView.addSubview(solitaireView)
        bgContainView.addSubview(nameTimeLabel)
        bgContainView.addSubview(recallView)
    }
    private func layout(){
        bgContainView.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0).priorityHigh()
        }
        
        contentLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(nameTimeLabel.snp_bottom).offset(14)
            make.right.equalTo(-18)
        }
        
    }
    // MARK: -getter&setter
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var solitaireView: YXSHomeSolitaireBottom = {
        let solitaireView = YXSHomeSolitaireBottom(self.isShowTag ? true : false)
        return solitaireView
    }()
}

// MARK: -接龙UI
extension YXSSolitaireListCell{
    func setSolitaireUI(){
        recallView.isHidden = true
        redView.isHidden = true
        stickView.isHidden = true
        if isShowTag{
            setTagUI("接龙", backgroundColor: UIColor.yxs_hexToAdecimalColor(hex: "#DFF3EC"), textColor: UIColor.yxs_hexToAdecimalColor(hex: "#38B16B"))
        }
        

        
        var content: String?
        var teacherId: Int?
        var isShowAll: Bool = false
        var createTime: String?
        var teacherName: String?
        var serviceId: Int?
        var childrenId: Int?
        var isTop: Int?
        if solitaireModel == nil{
            content = model.content ?? ""
            isShowAll = model.isShowAll
            teacherId = model.teacherId
            createTime = model.createTime
            teacherName = model.teacherName
            serviceId = model.serviceId
            childrenId = model.childrenId
            isTop = model.isTop
            solitaireView.setHomeModel(model)
        }else{
            content = solitaireModel.content ?? ""
            isShowAll = solitaireModel.isShowAll
            teacherId = solitaireModel.teacherId
            createTime = solitaireModel.createTime
            teacherName = solitaireModel.teacherName
            serviceId = solitaireModel.censusId
            childrenId = solitaireModel.childrenId
            isTop = solitaireModel.isTop
            solitaireView.setSolitaireModel(solitaireModel)
        }
        
        self.isTop = isTop == 1
        
        if YXSPersonDataModel.sharePerson.personRole == .PARENT,YXSLocalMessageHelper.shareHelper.yxs_isLocalMessage(serviceId: serviceId ?? 1001, childId: childrenId ?? 0){
            redView.isHidden = false
        }
        
//                createTime.text = "\((model.myPublish ?? false) ? "我" : "\(model.teacherName ?? "")")  ｜  \((model.createTime ?? "").yxs_Time())"
        UIUtil.yxs_setLabelAttributed(nameTimeLabel, text: ["\(teacherName ?? "")", "  |  \(createTime?.yxs_Time() ?? "")"], colors: [MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#4B4E54"), night: UIColor.yxs_hexToAdecimalColor(hex: "#4B4E54")),MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))])
        
        let dic = [NSAttributedString.Key.font: kTextMainBodyFont]
        
        
        showAllControl.isSelected = isShowAll
        contentLabel.numberOfLines = isShowAll ? 0 : 2
        
        let height = UIUtil.yxs_getTextHeigh(textStr: content ?? "", attributes: dic , width: SCREEN_WIDTH - 30 - 30)
        //需要展示多行
        let needShowMore = height > 45
        
        UIUtil.yxs_setLabelParagraphText(contentLabel, text: content,removeSpace:  !isShowAll && needShowMore)
        contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 15 - 20 - 30
        if needShowMore{
            showAllControl.isHidden = false
            showAllControl.snp.remakeConstraints { (make) in
                make.left.equalTo(contentLabel)
                make.top.equalTo(solitaireView.snp_bottom)
                make.height.equalTo(26)
                make.bottom.equalTo(-10)
            }
            solitaireView.snp.remakeConstraints{ (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(contentLabel.snp_bottom).offset(14)
            }
        }else{
            showAllControl.isHidden = true
            showAllControl.snp.removeConstraints()
            solitaireView.snp.remakeConstraints{ (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(contentLabel.snp_bottom).offset(12)
                make.bottom.equalTo(-19).priorityHigh()
            }
        }
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER && self.yxs_user.id == teacherId{
            recallView.isHidden = false
        }
    }
}

// MARK: -HMRouterEventProtocol
extension YXSSolitaireListCell: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kSolitaireBottomGoEvnet:
            cellBlock?(.goSolitaire)
        default:
            break
        }
    }
}

