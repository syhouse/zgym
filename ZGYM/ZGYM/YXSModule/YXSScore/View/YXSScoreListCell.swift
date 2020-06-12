//
//  YXSScoreListCell.swift
//  ZGYM
//
//  Created by yihao on 2020/5/26.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import UIKit
import NightNight
import SwiftyJSON

class YXSScoreListHomeCell: YXSScoreListCell {
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier,isShowTag: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YXSScoreListCell: YXSHomeBaseCell {
    var scoreModel: YXSScoreListModel = YXSScoreListModel.init(JSON: ["":""])!
    // MARK: - init
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, isShowTag: Bool) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.isWaterfallCell = isShowTag
        self.selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        contentView.addSubview(bgContainView)
        bgContainView.addSubview(recallView)
        bgContainView.addSubview(contentLabel)
        bgContainView.addSubview(classLabel)
        bgContainView.addSubview(nameTimeLabel)
        bgContainView.addSubview(topTimeLabel)
        bgContainView.addSubview(visibleView)
        bgContainView.addSubview(readButton)
        
        layer()
        
        initCommonUI()
        if isShowTag {
            topTimeLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(69)
                make.centerY.equalTo(tagLabel)
            }
            contentLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(topTimeLabel.snp_bottom).offset(10)
                make.right.equalTo(-15)
                make.height.equalTo(20)
            }
        } else {
            topTimeLabel.snp.removeConstraints()
            contentLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(10)
                make.right.equalTo(-15)
                make.height.equalTo(20)
            }
        }
    }
    
    convenience override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.init(style: style, reuseIdentifier: reuseIdentifier,isShowTag: false)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layer() {
        bgContainView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(14)
            make.right.equalTo(-15)
            make.bottom.equalTo(0).priorityHigh()
        }
        
        nameTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(contentLabel.snp_bottom).offset(10)
            make.right.equalTo(-15)
            make.height.equalTo(20)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.right.equalTo(-15)
            make.height.equalTo(20)
        }
        classLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(SCREEN_WIDTH - 60 - 80)
            make.top.equalTo(nameTimeLabel.snp_bottom).offset(10)
        }
        visibleView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(classLabel)
            make.height.equalTo(18)
        }
    }
    
    override func yxs_setCellModel(_ model: YXSHomeListModel){
        self.model = model
        recallView.isHidden = true
        redView.isHidden = true
        stickView.isHidden = true
        self.isTop = model.isTop == 1
        if isWaterfallCell{
            setTagUI("成绩", backgroundColor: UIColor.yxs_hexToAdecimalColor(hex: "#FAF0D7"), textColor: UIColor.yxs_hexToAdecimalColor(hex: "#EB9A3C"))
        }
        ///红点
        if YXSPersonDataModel.sharePerson.personRole == .PARENT,YXSLocalMessageHelper.shareHelper.yxs_isLocalMessage(serviceId: model.serviceId ?? 1001, childId: model.childrenId ?? 0){
            redView.isHidden = false
        }
        UIUtil.yxs_setLabelAttributed(nameTimeLabel, text: ["\(model.teacherName ?? "")", "  |  \(model.createTime?.yxs_Time() ?? "")"], colors: [MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#4B4E54"), night: UIColor.yxs_hexToAdecimalColor(hex: "#4B4E54")),MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))])
        classLabel.text = model.className
        topTimeLabel.text = model.createTime?.date(withFormat: kCommonDateFormatString)?.yxs_homeTimeWeek()
        visibleView.locailImage = "visible"
        visibleView.imageSize = CGSize.init(width: 18, height: 18)
        UIUtil.yxs_setLabelParagraphText(contentLabel, text: model.scoreListModel?.title?.listReplaceSpaceAndReturn())
        //老师所有处理
        let isTeacher: Bool = YXSPersonDataModel.sharePerson.personRole == .TEACHER
        if isTeacher{
            readButton.isHidden = true
            visibleView.isHidden = false
            if model.teacherId == yxs_user.id{
                recallView.isHidden = false
            }
            
            UIUtil.yxs_setLabelAttributed(visibleView.textLabel, text: ["\(model.readCount)", "/\(model.memberCount ?? 0)"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), kTextLightColor])
            
            visibleView.snp.remakeConstraints { (make) in
                make.height.equalTo(18)
                make.right.equalTo(-15)
                make.centerY.equalTo(classLabel)
            }

        }else{
            visibleView.isHidden = true
            readButton.isHidden = false
            changeReadUI(model.isRead)
        }
    }
    
    func setModel(model: YXSScoreListModel) {
        visibleView.isHidden = true
        readButton.isHidden = true
        self.scoreModel = model
        contentLabel.text = model.examName
        UIUtil.yxs_setLabelAttributed(nameTimeLabel, text: ["\(model.teacherName ?? "")", "  |  \(model.creationTime?.yxs_Time() ?? "")"], colors: [MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")),MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))])
        classLabel.text = model.className
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            visibleView.locailImage = "visible"
            visibleView.imageSize = CGSize.init(width: 18, height: 18)
            visibleView.isHidden = false
            UIUtil.yxs_setLabelAttributed(visibleView.textLabel, text: [String(model.readNumber ?? 0), "/\(String(model.sumNumber ?? 0))"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), kTextLightColor])
        } else {
            readButton.isHidden = false
            readButton.isEnabled = !(model.isRead ?? false)
            if readButton.isEnabled {
                readButton.mixedBackgroundColor = MixedColor(normal: kRedMainColor, night: kRedMainColor)
                readButton.cornerRadius = 14.5
                readButton.yxs_setIconInLeftWithSpacing(0)
            }else{
                readButton.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: UIColor.clear)
                readButton.cornerRadius = 0
                readButton.yxs_setIconInLeftWithSpacing(7)
            }
            let readButtonSize: CGSize = model.isRead ?? false ? CGSize.init(width: 65, height: 29) : CGSize.init(width: 65, height: 29)
            readButton.snp.remakeConstraints { (make) in
                make.size.equalTo(readButtonSize)
                make.right.equalTo(bgContainView.snp_right).offset(-10)
                make.centerY.equalTo(classLabel)
            }
        }
        
        
    }
    
    // MARK: - getter&setter
    
    lazy var visibleView: YXSCustomImageControl = {
        let visibleView = YXSCustomImageControl.init(imageSize: CGSize.init(width: 18, height: 18), position: YXSImagePositionType.left, padding: 7)
        visibleView.font = UIFont.systemFont(ofSize: 13)
        visibleView.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        visibleView.locailImage = "visible"
        visibleView.isUserInteractionEnabled = false
        return visibleView
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.numberOfLines = 1
        return label
    }()
}
