//
//  YXSClassStartPartentDetailStudentHeaderView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/10.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSClassStartPartentDetailStudentHeaderView: UIView {
    let stage: StageType
    var classId: Int?
    var childrenId: Int?
    var childrenName: String?
    ///是否是查看别人孩子
    var isLookOtherStudent: Bool = false{
        didSet{
            shareButton.isHidden = isLookOtherStudent
        }
    }
    init(frame: CGRect, stage: StageType) {
        self.stage = stage
        super.init(frame: frame)
        backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#D6E4FF")
        
        addSubview(headerImageView)
        addSubview(dayLabel)
        addSubview(firstRankView)
        addSubview(secendRankView)
        addSubview(thridRankView)
        addSubview(bottomView)
        addSubview(shareButton)
        layout()
    }
    
    func layout(){
        headerImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(389*SCREEN_SCALE + kSafeTopHeight)
        }
        
        dayLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(5 + kSafeTopHeight + 64)
        }
        shareButton.snp.makeConstraints { (make) in
            make.top.equalTo(dayLabel.snp_bottom).offset(3)
            make.right.equalTo(0)
            make.size.equalTo(CGSize.init(width: 59.5, height: 23))
        }
        firstRankView.snp.makeConstraints { (make) in
            make.top.equalTo(96*SCREEN_SCALE + kSafeTopHeight)
            make.centerX.equalTo(self)
        }
        
        secendRankView.snp.makeConstraints { (make) in
            make.top.equalTo(firstRankView).offset(26.5*SCREEN_SCALE)
            make.centerX.equalTo(SCREEN_WIDTH/4)
        }
        thridRankView.snp.makeConstraints { (make) in
            make.top.equalTo(firstRankView).offset(26.5*SCREEN_SCALE)
            make.centerX.equalTo(SCREEN_WIDTH/4*3)
        }
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(317*SCREEN_SCALE + kSafeTopHeight)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-13.5).priorityHigh()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func lookFirst(){
        YXSClassStarApposeView.showAlert(childs: model.mapTop3?.first ?? [YXSClassStarChildrenModel](), curruntChild: model.currentChildren, sort:1, stage:  stage)
    }
    @objc func lookSecend(){
        YXSClassStarApposeView.showAlert(childs: model.mapTop3?.secend ?? [YXSClassStarChildrenModel](), curruntChild: model.currentChildren, sort:2,stage:  stage)
    }
    @objc func lookThrid(){
        YXSClassStarApposeView.showAlert(childs: model.mapTop3?.thrid ?? [YXSClassStarChildrenModel](), curruntChild: model.currentChildren, sort:3,stage:  stage)
    }
    
    @objc func shareClick(){
        if model != nil{
            UIUtil.yxs_shareLink(requestModel: HMRequestShareModel.init(classStarId: classId ?? 0, childrenId: childrenId ?? 0, dateType: dateType), shareModel: YXSShareModel.init(title: "班级之星", descriptionText: "\(NSUtil.yxs_getDateText(dateType: dateType))班级之星已出炉,快来看看\(childrenName ?? "")的表现吧~", link: ""))
        }
    }
    
    var model: YXSClassStarPartentModel!
    var dateType = DateType.W
    func setHeaderModel(_ model: YXSClassStarPartentModel, dateType: DateType,startTime:String?, endTime: String?){
        self.model = model
        self.dateType = dateType
        if let startTime = startTime{
            dayLabel.text = "\(startTime.date(withFormat: "yyyy-MM-dd hh:mm:ss")?.toString(format: DateFormatType.custom("MM月dd日")) ?? "")-\(endTime?.date(withFormat: "yyyy-MM-dd hh:mm:ss")?.toString(format: DateFormatType.custom("MM月dd日")) ?? "")(本周)"
        }else{
            dayLabel.text = "\(NSUtil.yxs_timePeriodText(dateType: dateType))(\(NSUtil.yxs_getDateText(dateType: dateType)))"
        }
        
        firstRankView.setViewModel(model.mapTop3?.first, model.currentChildren, index: 1, stage: stage)
        secendRankView.setViewModel(model.mapTop3?.secend, model.currentChildren, index: 2, stage: stage)
        thridRankView.setViewModel(model.mapTop3?.thrid, model.currentChildren, index: 3, stage: stage)
        
        bottomView.isLookOtherStudent = isLookOtherStudent
        bottomView.setViewModel(model, dateType: dateType)
    }
    
    // MARK: -getter&setter
    
    lazy var headerImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_classstar_partent_bg"))
        return imageView
    }()
    lazy var firstRankView: ClassStartPartentRankView = {
        let firstRankView = ClassStartPartentRankView.init(size: CGSize.init(width: 70, height: 70), labelImage: "yxs_classstar_partent_frist", labelText: "冠军", borderColor: UIColor.yxs_hexToAdecimalColor(hex: "#FFCA28"), isFrist: true)
        firstRankView.bottomButton.addTarget(self, action: #selector(lookFirst), for: .touchUpInside)
        return firstRankView
    }()
    lazy var secendRankView: ClassStartPartentRankView = {
        let firstRankView = ClassStartPartentRankView.init(size: CGSize.init(width: 60, height: 60), labelImage: "yxs_classstar_partent_secend", labelText: "亚军", borderColor: UIColor.yxs_hexToAdecimalColor(hex: "#7567FB"), isFrist: false)
        firstRankView.bottomButton.addTarget(self, action: #selector(lookSecend), for: .touchUpInside)
        return firstRankView
    }()
    lazy var thridRankView: ClassStartPartentRankView = {
        let firstRankView = ClassStartPartentRankView.init(size: CGSize.init(width: 60, height: 60), labelImage: "yxs_classstar_partent_thrid", labelText: "季军", borderColor: UIColor.yxs_hexToAdecimalColor(hex: "#C2EEFC"), isFrist: false)
        firstRankView.bottomButton.addTarget(self, action: #selector(lookThrid), for: .touchUpInside)
        return firstRankView
    }()
    
    lazy var dayLabel: YXSLabel = {
        let label = YXSLabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#E7EDFD")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton.init()
        button.setBackgroundImage(UIImage.init(named: "yxs_classstar_share"), for: .normal)
        button.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
        return button
    }()
    
    lazy var bottomView: ClassStartPartentBottomView = {
        let bottomView = ClassStartPartentBottomView.init(frame: CGRect.zero, stage: stage)
        bottomView.backgroundColor = UIColor.white
        bottomView.cornerRadius = 5
        return bottomView
    }()
}


class ClassStartPartentRankView: UIView {
    init(size: CGSize, labelImage: String, labelText: String, borderColor: UIColor, isFrist: Bool) {
        super.init(frame: CGRect.zero)
        addSubview(iconImageView)
        addSubview(labelImageView)
        addSubview(nameLabel)
        labelImageView.addSubview(labelTextLabel)
        addSubview(bottomButton)
        addSubview(scorelabel)
        
        iconImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.size.equalTo(size)
        }
        
        labelImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            if isFrist{
                make.size.equalTo(CGSize.init(width: 69, height: 27.5))
                make.top.equalTo(55)
            }else{
                make.size.equalTo(CGSize.init(width: 60, height: 24))
                make.top.equalTo(54.5)
            }
            
        }
        labelTextLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(labelImageView)
            make.top.equalTo(1)
            
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(labelImageView)
            make.top.equalTo(labelImageView.snp_bottom).offset(9)
            
        }
        scorelabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(labelImageView)
            make.top.equalTo(nameLabel.snp_bottom).offset(7)
        }
        
        bottomButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(scorelabel.snp_bottom).offset(7)
            make.size.equalTo(CGSize.init(width: 61.5, height: 23))
            make.bottom.equalTo(0)
        }
        
        labelImageView.image = UIImage.init(named: labelImage)
        iconImageView.borderColor = borderColor
        iconImageView.cornerRadius = size.width/2
        labelTextLabel.text = labelText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewModel(_ models: [YXSClassStarChildrenModel]?,_ curruntChild: YXSClassStarChildrenModel?, index: Int,stage: StageType){
        if let models = models{
            var model = models.first!
            if let curruntChild = curruntChild{
                if curruntChild.topNo ?? 101 == index{
                    model = curruntChild
                }
            }
            iconImageView.sd_setImage(with: URL.init(string: model.avatar ?? ""),placeholderImage: kImageUserIconStudentDefualtImage, completed: nil)
            nameLabel.text = model.childrenName
            scorelabel.text = "\(model.score ?? 0)\(stage == .KINDERGARTEN ? "朵" : "分")"
            if models.count > 1{
                bottomButton.isHidden = false
                bottomButton.setTitle("\(models.count)人并列", for: .normal)
            }else{
                bottomButton.isHidden = true
            }
        }else{
            iconImageView.image = UIImage.init(named: "yxs_classstar_student_gray")
            nameLabel.text = "暂无"
            bottomButton.isHidden = true
        }
    }
    
    lazy var bottomButton: YXSButton = {
        let bottomButton = YXSButton()
        bottomButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bottomButton.setTitleColor(UIColor.white, for: .normal)
        bottomButton.cornerRadius = 11
        bottomButton.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6")
        return bottomButton
    }()
    
    lazy var nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.mixedTextColor = MixedColor(normal: UIColor.white, night: UIColor.white)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    
    lazy var labelTextLabel: YXSLabel = {
        let label = YXSLabel()
        label.mixedTextColor = MixedColor(normal: UIColor.white, night: UIColor.white)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.cornerRadius = 35
        iconImageView.borderWidth = 1.5
        iconImageView.contentMode = .scaleAspectFill
        return iconImageView
    }()
    lazy var labelImageView: UIImageView = {
        let iconImageView = UIImageView()
        
        return iconImageView
    }()
    
    lazy var scorelabel: YXSLabel = {
        let label = YXSLabel()
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#FFE400"), night: UIColor.yxs_hexToAdecimalColor(hex: "#FFE400"))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
}

class ClassStartPartentBottomView: UIView {
    let stage: StageType
    ///是否是查看别人孩子
    var isLookOtherStudent: Bool = false
    init(frame: CGRect,stage: StageType) {
        self.stage = stage
        super.init(frame: CGRect.zero)
        addSubview(titleLabel)
        addSubview(labelImageView)
        addSubview(bottomView)
        bottomView.addSubview(scoreLabel)
        bottomView.addSubview(overLabel)
        bottomView.addSubview(avrgerLabel)
        bottomView.addSubview(lineView)
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(15)
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(85)
        }
        scoreLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo((SCREEN_WIDTH - 30)/4 - 10)
            make.centerY.equalTo(bottomView)
            
        }
        overLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(bottomView)
            make.centerY.equalTo(bottomView)
            
        }
        avrgerLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo((SCREEN_WIDTH - 30)/4*3 + 10)
            make.centerY.equalTo(bottomView)
            
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewModel(_ model: YXSClassStarPartentModel, dateType: DateType){
        labelImageView.isHidden = true
        titleLabel.isHidden = true
        var rankText: String? = nil
        
        if stage == .KINDERGARTEN{
            UIUtil.yxs_setLabelAttributed(scoreLabel, text: ["\(model.currentChildren?.score ?? 0)","朵\n", "\(NSUtil.yxs_getDateText(dateType: dateType))小红花"], colors: [kBlueColor, kBlueColor,UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")], fonts: [UIFont.boldSystemFont(ofSize: 23),UIFont.boldSystemFont(ofSize: 15),UIFont.boldSystemFont(ofSize: 15)],paragraphLineSpacing: 12)
            
            UIUtil.yxs_setLabelAttributed(avrgerLabel, text: ["\(model.averageScore ?? "")","朵\n", "班级平均分"], colors: [kBlueColor, kBlueColor,UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")], fonts: [UIFont.boldSystemFont(ofSize: 23),UIFont.boldSystemFont(ofSize: 15),UIFont.boldSystemFont(ofSize: 15)],paragraphLineSpacing: 12)
        }else{
            UIUtil.yxs_setLabelAttributed(scoreLabel, text: ["\(model.currentChildren?.score ?? 0)\n", "\(NSUtil.yxs_getDateText(dateType: dateType))得分"], colors: [kBlueColor,UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")], fonts: [UIFont.boldSystemFont(ofSize: 23),UIFont.boldSystemFont(ofSize: 15)],paragraphLineSpacing: 12)
            UIUtil.yxs_setLabelAttributed(avrgerLabel, text: ["\(model.averageScore ?? "")\n", "班级平均分"], colors: [kBlueColor,UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")], fonts: [UIFont.boldSystemFont(ofSize: 23),UIFont.boldSystemFont(ofSize: 15)],paragraphLineSpacing: 12)
        }
        UIUtil.yxs_setLabelAttributed(overLabel, text: ["\(model.currentChildren?.topPercent ?? "0")%\n", "超越本班同学"], colors: [kBlueColor,UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")], fonts: [UIFont.boldSystemFont(ofSize: 23),UIFont.boldSystemFont(ofSize: 15)],paragraphLineSpacing: 12)
        
        if  let showRankNotice = model.showRankNotice,showRankNotice{
            if let currentChildren = model.currentChildren{
                if currentChildren.topNo ?? 101 == 1{
                    rankText = "冠军"
                }else if currentChildren.topNo ?? 101 == 2{
                    rankText = "亚军"
                }else if currentChildren.topNo ?? 101 == 3{
                    rankText = "季军"
                }

            }
            if let rankText = rankText{
                UIUtil.yxs_setLabelAttributed(titleLabel, text: ["恭喜！\(model.currentChildren?.childrenName ?? "")\(NSUtil.yxs_getDateText(dateType: dateType))荣获\(rankText)", "\n\(isLookOtherStudent ? "" : "您的孩子")\(NSUtil.yxs_getDateText(dateType: dateType))在班级表现非常榜"], colors: [kTextMainBodyColor,UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")], fonts: [UIFont.boldSystemFont(ofSize: 20),UIFont.boldSystemFont(ofSize: 15)],paragraphLineSpacing: 13)
            }else{
                UIUtil.yxs_setLabelAttributed(titleLabel, text: ["孩子名\(NSUtil.yxs_getDateText(dateType: dateType))暂未上榜，请再接再厉！", "\n\(isLookOtherStudent ? "" : "您的孩子")\(NSUtil.yxs_getDateText(dateType: dateType))表现还有进步空间！"], colors: [kTextMainBodyColor,UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")], fonts: [UIFont.boldSystemFont(ofSize: 20),UIFont.boldSystemFont(ofSize: 15)],paragraphLineSpacing: 13)
            }
        }
        
        if model.showRemindTeacher{
            bottomView.backgroundColor = UIColor.white
            bottomView.snp.remakeConstraints { (make) in
                make.left.right.top.bottom.equalTo(0)
                make.height.equalTo(85)
            }
            titleLabel.snp_removeConstraints()
        }else{
            if let showRankNotice = model.showRankNotice,showRankNotice{
                titleLabel.isHidden = false
                if rankText != nil {
                    labelImageView.isHidden = false
                    
                    labelImageView.snp.remakeConstraints { (make) in
                        make.top.equalTo(0)
                        make.centerX.equalTo(self)
                        make.size.equalTo(CGSize.init(width: 149.5, height: 57))
                    }
                    
                    titleLabel.snp.remakeConstraints { (make) in
                        make.centerX.equalTo(self)
                        make.top.equalTo(labelImageView.snp_bottom).offset(20)
                    }
                }else{
                    labelImageView.isHidden = true
                    titleLabel.snp.remakeConstraints { (make) in
                        make.centerX.equalTo(self)
                        make.top.equalTo(15)
                        
                    }
                }
                bottomView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F4F7FF")
                bottomView.snp.remakeConstraints { (make) in
                    make.top.equalTo(titleLabel.snp_bottom).offset(15)
                    make.left.right.bottom.equalTo(0)
                    make.height.equalTo(85)
                }

            }else{
                bottomView.backgroundColor = UIColor.white
                bottomView.snp.remakeConstraints { (make) in
                    make.top.equalTo(0)
                    make.left.right.bottom.equalTo(0)
                    make.height.equalTo(85)
                }
            }
        }
    }
    
    ///不展示排名信息
    func updateShowNoRankUI(){
        
    }
    
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), night: kNight2F354B)
        return lineView
    }()
    
    lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F4F7FF")
        return bottomView
    }()
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.mixedTextColor = MixedColor(normal: UIColor.white, night: UIColor.white)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var scoreLabel: YXSLabel = {
        let label = YXSLabel()
        label.mixedTextColor = MixedColor(normal: UIColor.white, night: UIColor.white)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var overLabel: YXSLabel = {
        let label = YXSLabel()
        label.mixedTextColor = MixedColor(normal: UIColor.white, night: UIColor.white)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var avrgerLabel: YXSLabel = {
        let label = YXSLabel()
        label.mixedTextColor = MixedColor(normal: UIColor.white, night: UIColor.white)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var labelImageView: UIImageView = {
        let iconImageView = UIImageView.init(image: UIImage.init(named: "yxs_classstar_partent_prize"))
        return iconImageView
    }()
}



