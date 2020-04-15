//
//  YXSClassStarTeacherDetialHeaderView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/3.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

let kYXSClassStarTeacherDetialHeaderViewLookDetialEvent = "YXSClassStarTeacherDetialHeaderViewLookDetialEvent"

class YXSClassStarTeacherDetialHeaderView: UIView {
    let stage: StageType
    init(frame: CGRect, stage: StageType) {
        self.stage = stage
        super.init(frame: frame)
        backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#D2E4FF")
        
        addSubview(topKINDERGARTENView)
        topKINDERGARTENView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(401*SCREEN_SCALE + kSafeTopHeight)
        }
        addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(321*SCREEN_SCALE + kSafeTopHeight)
        }
        
        addSubview(bottomView)
        bottomView.snp.remakeConstraints { (make) in
            make.top.equalTo(255*SCREEN_SCALE + kSafeTopHeight + 64)
            make.left.right.bottom.equalTo(0)
            make.bottom.equalTo(0).priorityHigh()
        }
        
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(5 + kSafeTopHeight + 64)
        }
    }
    
    func layout(){
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var model: YXSClassStartClassModel!
    func setHeaderModel(_ model: YXSClassStartClassModel?){
        if let model = model{
            topKINDERGARTENView.isHidden = true
            topView.isHidden = true
            self.model = model
            bottomView.setHeaderModel(model)
            dayLabel.text = "\(NSUtil.yxs_timePeriodText(dateType: model.dateType))(\(model.dateText))"
            if model.stageType == .KINDERGARTEN{
                topKINDERGARTENView.setHeaderModel(model)
                topKINDERGARTENView.isHidden = false
            }else{
                topView.setHeaderModel(model)
                topView.isHidden = false
            }
        }
        
    }
    
    // MARK: -getter&setter
    
    lazy var bottomView: YXSClassStarTeacherDetialHeaderMidView = {
        let bottomView = YXSClassStarTeacherDetialHeaderMidView()
        return bottomView
    }()
    
    lazy var topView: ClassStarTeacherDetialHeaderOtherLevelView = {
        let topView = ClassStarTeacherDetialHeaderOtherLevelView()
        return topView
    }()
    lazy var topKINDERGARTENView: ClassStarTeacherDetialHeaderKINDERGARTENView = {
        let topKINDERGARTENView = ClassStarTeacherDetialHeaderKINDERGARTENView()
        return topKINDERGARTENView
    }()
    
    
    lazy var dayLabel: YXSLabel = {
        let label = YXSLabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#E7EDFD")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
}

class ClassStarTeacherDetialHeaderKINDERGARTENView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerImageView)
        addSubview(leftCommont)
        addSubview(rightCommont)
        addSubview(countBugView)
        addSubview(countLabel)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout(){
        headerImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        countBugView.snp.makeConstraints { (make) in
            make.top.equalTo(42.5*SCREEN_SCALE + 64 + kSafeTopHeight)
            make.centerX.equalTo(self)
            make.width.height.equalTo(172.5*SCREEN_SCALE)
        }
        countLabel.snp.makeConstraints { (make) in
            make.center.equalTo(countBugView)
        }
        
        leftCommont.snp.makeConstraints { (make) in
            make.left.equalTo(25*SCREEN_SCALE)
            make.width.equalTo(50)
            make.centerY.equalTo(countBugView)
        }
        
        rightCommont.snp.makeConstraints { (make) in
            make.right.equalTo(-25*SCREEN_SCALE)
            make.width.equalTo(50)
            make.centerY.equalTo(countBugView)
        }
    }
    var model: YXSClassStartClassModel!
    func setHeaderModel(_ model: YXSClassStartClassModel){
        self.model = model
        UIUtil.yxs_setLabelAttributed(leftCommont.textLabel, text: ["班级平均\n\n", "\(model.averageScore ?? "")","朵"], fonts: [UIFont.boldSystemFont(ofSize: 14),UIFont.boldSystemFont(ofSize: 21),UIFont.boldSystemFont(ofSize: 14)])
        UIUtil.yxs_setLabelAttributed(rightCommont.textLabel, text: ["班级人数\n\n", "\(model.classChildrenSum ?? 0)","人"], fonts: [UIFont.boldSystemFont(ofSize: 14),UIFont.boldSystemFont(ofSize: 21)])
        UIUtil.yxs_setLabelAttributed(countLabel, text: ["\(model.score ?? 0)","朵\n\n","\(model.dateText)获得"], fonts: [UIFont.boldSystemFont(ofSize: 30),UIFont.boldSystemFont(ofSize: 14),UIFont.boldSystemFont(ofSize: 17)])
    }
    
    lazy var headerImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_classstar_KINDERGARTEN_bg"))
        return imageView
    }()
    
    
    lazy var leftCommont: YXSCustomImageControl = {
        
        let leftCommont = YXSCustomImageControl.init(imageSize: CGSize.init(width: 21.5, height: 23), position: YXSImagePositionType.top, padding: 7.5)
        leftCommont.textColor = UIColor.white
        leftCommont.locailImage = "yxs_classstar_cicle_huaduo"
        leftCommont.textLabel.textAlignment = .center
        return leftCommont
    }()
    lazy var rightCommont: YXSCustomImageControl = {
        
        let rightCommont = YXSCustomImageControl.init(imageSize: CGSize.init(width: 21.5, height: 23), position: YXSImagePositionType.top, padding: 7.5)
        rightCommont.textColor = UIColor.white
        rightCommont.locailImage = "yxs_classstar_cicle_zongrenshu"
        rightCommont.textLabel.textAlignment = .center
        return rightCommont
    }()
    lazy var countLabel: YXSLabel = {
        let label = YXSLabel()
        label.textColor = kBlueColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    lazy var countBugView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_classstar_cicle_bg"))
        return imageView
    }()
}

class ClassStarTeacherDetialHeaderOtherLevelView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerImageView)
        addSubview(labelImageView)
        addSubview(leftCommont)
        addSubview(rightCommont)
        labelImageView.addSubview(averageLabel)
        addSubview(progressView)
        addSubview(countLabel)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout(){
        headerImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        labelImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize.init(width: 159.5, height: 48))
            make.top.equalTo(180*SCREEN_SCALE + kSafeTopHeight + 64)
        }
        
        averageLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(15*SCREEN_SCALE)
        }
        progressView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.height.width.equalTo(120*SCREEN_SCALE)
            make.top.equalTo(40*SCREEN_SCALE + kSafeTopHeight + 64)
            
        }
        countLabel.snp.makeConstraints { (make) in
            make.center.equalTo(progressView)
        }
        
        leftCommont.snp.makeConstraints { (make) in
            make.left.equalTo(25*SCREEN_SCALE)
            make.width.equalTo(50)
            make.centerY.equalTo(progressView)
        }
        
        rightCommont.snp.makeConstraints { (make) in
            make.right.equalTo(-25*SCREEN_SCALE)
            make.width.equalTo(50)
            make.centerY.equalTo(progressView)
        }
    }
    
    var model: YXSClassStartClassModel!
    func setHeaderModel(_ model: YXSClassStartClassModel){
        self.model = model
        if model.hasComment{
            UIUtil.yxs_setLabelAttributed(averageLabel, text: ["班级平均分：", "\(model.averageScore ?? "")"], fonts: [UIFont.boldSystemFont(ofSize: 15),UIFont.boldSystemFont(ofSize: 21)])
        }else{
            UIUtil.yxs_setLabelAttributed(averageLabel, text: ["班级平均分：", "暂无"], fonts: [UIFont.boldSystemFont(ofSize: 15),UIFont.boldSystemFont(ofSize: 21)])
        }
        
        UIUtil.yxs_setLabelAttributed(leftCommont.textLabel, text: ["表扬\n\n", "\(model.praiseScore ?? 0)"], fonts: [UIFont.boldSystemFont(ofSize: 14),UIFont.boldSystemFont(ofSize: 21)])
        UIUtil.yxs_setLabelAttributed(rightCommont.textLabel, text: ["待改进\n\n", "\(model.improveScore ?? 0)"], fonts: [UIFont.boldSystemFont(ofSize: 14),UIFont.boldSystemFont(ofSize: 21)])
        progressView.setProgress(model.praiseScore ?? 0, model.improveScore ?? 0)
        UIUtil.yxs_setLabelAttributed(countLabel, text: ["\(model.score ?? 0)\n","\(model.dateText)得分"], fonts: [UIFont.boldSystemFont(ofSize: 30),UIFont.boldSystemFont(ofSize: 15)])
        
    }
    
    lazy var headerImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_classstar_teacher_class_single_detial_bg"))
        return imageView
    }()
    
    lazy var labelImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_classstar_teacher_class_rectangle"))
        return imageView
    }()
    
    lazy var leftCommont: YXSCustomImageControl = {
        
        let leftCommont = YXSCustomImageControl.init(imageSize: CGSize.init(width: 21.5, height: 23), position: YXSImagePositionType.top, padding: 7.5)
        leftCommont.textColor = UIColor.white
        leftCommont.locailImage = "yxs_classstar_teacher_class_good"
        leftCommont.textLabel.textAlignment = .center
        return leftCommont
    }()
    lazy var rightCommont: YXSCustomImageControl = {
        
        let rightCommont = YXSCustomImageControl.init(imageSize: CGSize.init(width: 21.5, height: 23), position: YXSImagePositionType.top, padding: 7.5)
        rightCommont.textColor = UIColor.white
        rightCommont.locailImage = "yxs_classstar_teacher_class_bad"
        rightCommont.textLabel.textAlignment = .center
        return rightCommont
    }()
    lazy var averageLabel: YXSLabel = {
        let label = YXSLabel()
        label.textColor = UIColor.white
        
        return label
    }()
    lazy var countLabel: YXSLabel = {
        let label = YXSLabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    lazy var progressView: ClassStarProgressView = {
        let progressView = ClassStarProgressView()
        return progressView
    }()
}
