//
//  YXSHomeworkListCell.swift
//  HNYMEducation
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
        label.font = UIFont.systemFont(ofSize: 14)
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
        
        if isShowTag{
            setTagUI("作业", backgroundColor: UIColor.yxs_hexToAdecimalColor(hex: "#DFF3EC"), textColor: UIColor.yxs_hexToAdecimalColor(hex: "#38B16B"))
        }
        
        if YXSPersonDataModel.sharePerson.personRole == .PARENT,YXSLocalMessageHelper.shareHelper.yxs_isLocalMessage(serviceId: model.serviceId ?? 1001, childId: model.childrenId ?? 0){
            redView.isHidden = false
        }
        
        UIUtil.yxs_setLabelAttributed(nameTimeLabel, text: ["\(model.teacherName ?? "")", "  |  \(model.createTime?.yxs_Time() ?? "")"], colors: [MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#4B4E54"), night: UIColor.yxs_hexToAdecimalColor(hex: "#4B4E54")),MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))])
        classLabel.text = model.className
        
        setSourceViewData()
        
        UIUtil.yxs_setLabelAttributed(visibleView.textLabel, text: ["\(model.readCount)", "/\(model.memberCount ?? 0)"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), kTextLightColor])
        showAllControl.isSelected = model.isShowAll
        contentLabel.numberOfLines = model.isShowAll ? 0 : 2
        
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            UIUtil.yxs_setLabelAttributed(setUpLabel, text: ["提交情况  ", "\(model.commitCount)","/\(model.memberCount ?? 0)"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"),kRedMainColor,UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")])
        }
        let dic = [NSAttributedString.Key.font: kTextMainBodyFont]
        let height = UIUtil.yxs_getTextHeigh(textStr: (model.content ?? ""), attributes: dic , width: SCREEN_WIDTH - 30 - (model.hasSource ? 106.5 : 30))
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
        //需要展示多行
        let needShowMore = height > 45
        
        UIUtil.yxs_setLabelParagraphText(contentLabel, text: model.content,removeSpace:  !model.isShowAll && needShowMore)
        contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 15 - 20 - (model.hasSource ? 106.5 : 30)
        
        let isTeacher: Bool = YXSPersonDataModel.sharePerson.personRole == .TEACHER
        
        if needShowMore{
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
            
            if model.onlineCommit == 1{
                setUpLabel.isHidden = false
                setUpLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(contentLabel)
                    make.top.equalTo(classLabel.snp_bottom).offset(16)
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
//                        make.right.equalTo(contentLabel)
                        make.right.equalTo(-103.5)
                    }
                    commentButton.isHidden = false
                    commentButton.isSelected = model.isRemark
                }else{
                    commonStatusButton.isHidden = false
                    commonStatusButton.layer.borderWidth = 1
                    commonStatusButton.layer.borderColor = kRedMainColor.cgColor
                    commonStatusButton.setTitleColor(kRedMainColor, for: .normal)
                    commonStatusButton.backgroundColor = UIColor.clear
                    commonStatusButton.setTitle("去完成", for: .normal)
                    commonStatusButton.snp.remakeConstraints { (make) in
                        make.right.equalTo(-15)
                        make.size.equalTo(CGSize.init(width: 79, height: 32))
                        make.bottom.equalTo(-13.5)
                    }
                }
                
            }
        }
        
        //  cell高度通过classLabel来约束 老师提交 25
        classLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(contentLabel.snp_bottom).offset(14)
            make.left.equalTo(contentLabel)
            make.right.equalTo(-80)
            if needShowMore{
                if YXSPersonDataModel.sharePerson.personRole == .TEACHER && model.onlineCommit == 1{
                    make.bottom.equalTo(-75).priorityHigh()
                }else{
                    if model.isShowAll{
                        make.bottom.equalTo(-45).priorityHigh()
                    }else{//去除空格会导致有问题
                        if model.hasSource{
                            let removeHeight = UIUtil.yxs_getTextHeigh(textStr: (model.content ?? "").removeSpace(), attributes: dic , width: SCREEN_WIDTH - 30 - (model.hasSource ? 106.5 : 30), numberOfLines: 2)
                            make.bottom.equalTo(removeHeight - 95).priorityHigh()
                        }else{
                            make.bottom.equalTo(-45).priorityHigh()
                        }
                    }
                }
            }else{
                if model.hasSource{
                    if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                        if recallView.isHidden == false{
                            make.bottom.equalTo(height - 80).priorityHigh()
                        }else{
                            make.bottom.equalTo(height - 80).priorityHigh()
                        }
                    }else{
                        if isShowTag{
                            let removeHeight = UIUtil.yxs_getTextHeigh(textStr: (model.content ?? "").removeSpace(), attributes: dic , width: SCREEN_WIDTH - 30 - (model.hasSource ? 106.5 : 30), numberOfLines: 2)
                            make.bottom.equalTo(removeHeight - 90).priorityHigh()
                        }else{
                            make.bottom.equalTo(height - 85).priorityHigh()
                        }
                    }
                }else{
                    if (YXSPersonDataModel.sharePerson.personRole == .TEACHER &&  model.onlineCommit == 1) || recallView.isHidden == false{
                        make.bottom.equalTo(-45).priorityHigh()
                    }else{
                        make.bottom.equalTo(-19).priorityHigh()
                    }
                    
                }
            }
        }
    }
}
