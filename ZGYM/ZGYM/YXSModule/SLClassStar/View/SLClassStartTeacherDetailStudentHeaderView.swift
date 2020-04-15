//
//  SLClassStartTeacherDetailStudentHeaderView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/9.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

class SLClassStartTeacherDetailStudentHeaderView: UIView {
    let stage: StageType
    init(frame: CGRect, stage: StageType) {
        self.stage = stage
        super.init(frame: frame)
        self.clipsToBounds = true
        backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#D2E4FF")
        
        if stage == .KINDERGARTEN{
            addSubview(topKINDERGARTENView)
            topKINDERGARTENView.snp.makeConstraints { (make) in
                make.left.right.top.equalTo(0)
                make.height.equalTo(450*SCREEN_SCALE + kSafeTopHeight)
            }
            
        }else{
            addSubview(topView)
            topView.snp.makeConstraints { (make) in
                make.left.right.top.equalTo(0)
                make.height.equalTo(395.5*SCREEN_SCALE + kSafeTopHeight)
            }
        }
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(5 + kSafeTopHeight + 64)
        }
        
        addSubview(dayLabel)
        layout()
    }
    
    func layout(){
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var model: SLClassStarChildrenModel!
    func setHeaderModel(_ model: SLClassStarChildrenModel){
        self.model = model
        
        dayLabel.text = "\(NSUtil.yxs_timePeriodText(dateType: model.dateType))(\(model.dateText))"
        if stage == .KINDERGARTEN{
            topKINDERGARTENView.setHeaderModel(model)
        }else{
            topView.setHeaderModel(model)
        }
    }
    
    // MARK: -getter&setter
    
    lazy var dayLabel: YXSLabel = {
        let label = YXSLabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#E7EDFD")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    lazy var topView: ClassStarTeacherDetialStudentHeaderOtherLevelView = {
        let topView = ClassStarTeacherDetialStudentHeaderOtherLevelView()
        return topView
    }()
    lazy var topKINDERGARTENView: ClassStarTeacherDetialStudentHeaderKINDERGARTENView = {
        let topKINDERGARTENView = ClassStarTeacherDetialStudentHeaderKINDERGARTENView()
        return topKINDERGARTENView
    }()
}


class ClassStarTeacherDetialStudentHeaderKINDERGARTENView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerImageView)
        addSubview(leftLabel)
        addSubview(rightLabel)
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
            make.top.equalTo(63.5*SCREEN_SCALE + 64 + kSafeTopHeight)
            make.centerX.equalTo(self)
            make.width.height.equalTo(172.5*SCREEN_SCALE)
        }
        countLabel.snp.makeConstraints { (make) in
            make.center.equalTo(countBugView)
        }
        
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(25*SCREEN_SCALE)
            make.width.equalTo(50)
            make.centerY.equalTo(countBugView)
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-25*SCREEN_SCALE)
            make.width.equalTo(50)
            make.centerY.equalTo(countBugView)
        }
    }
    var model: SLClassStarChildrenModel!
    func setHeaderModel(_ model: SLClassStarChildrenModel){
        self.model = model
        UIUtil.yxs_setLabelAttributed(leftLabel, text: ["总获得\n\n", "\(model.score ?? 0)","朵"], fonts: [UIFont.boldSystemFont(ofSize: 14),UIFont.boldSystemFont(ofSize: 21),UIFont.boldSystemFont(ofSize: 14)])
        UIUtil.yxs_setLabelAttributed(rightLabel, text: ["班级平均获得\n\n", "\(model.averageScore ?? "")","朵"], fonts: [UIFont.boldSystemFont(ofSize: 14),UIFont.boldSystemFont(ofSize: 21)])
        UIUtil.yxs_setLabelAttributed(countLabel, text: ["\(model.topNo ?? 0)\n","\(model.dateText)排名"], fonts: [UIFont.boldSystemFont(ofSize: 30),UIFont.boldSystemFont(ofSize: 15)])
    }
    
    lazy var headerImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_classstar_KINDERGARTEN_bg"))
        return imageView
    }()
    
    
    lazy var leftLabel: YXSLabel = {
        let leftLabel = YXSLabel()
        leftLabel.textColor = UIColor.white
        leftLabel.textAlignment = .center
        leftLabel.numberOfLines = 0
        return leftLabel
    }()
    lazy var rightLabel: YXSLabel = {
        
        let rightLabel = YXSLabel()
        rightLabel.textColor = UIColor.white
        rightLabel.textAlignment = .center
        rightLabel.numberOfLines = 0
        return rightLabel
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

class ClassStarTeacherDetialStudentHeaderOtherLevelView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
               addSubview(headerImageView)
        addSubview(leftBgView)
        addSubview(rightBgView)
        
        addSubview(progressView)
        addSubview(countLabel)
        addSubview(totalLabel)
        addSubview(averageLabel)
        
        leftBgView.addSubview(leftCommont)
        rightBgView.addSubview(rightCommont)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func layout(){
        headerImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(395.5*SCREEN_SCALE + kSafeTopHeight)
        }
        
        progressView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.height.width.equalTo(141)
            make.top.equalTo(106.5*SCREEN_SCALE + kSafeTopHeight)
            
        }
        countLabel.snp.makeConstraints { (make) in
            make.center.equalTo(progressView)
        }
        
        totalLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(headerImageView).offset(-SCREEN_WIDTH/2 + 60)
            make.centerY.equalTo(progressView)
        }
        
        averageLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(headerImageView).offset(SCREEN_WIDTH/2 - 60)
            make.centerY.equalTo(progressView)
        }
        
        leftBgView.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.top.equalTo(progressView.snp_bottom).offset(23.5)
            make.width.equalTo(rightBgView)
            make.height.equalTo(45)
        }
        rightBgView.snp.makeConstraints { (make) in
            make.left.equalTo(leftBgView.snp_right).offset(16)
            make.right.equalTo(-25)
            make.top.equalTo(progressView.snp_bottom).offset(23.5)
            make.height.equalTo(45)
        }
        leftCommont.snp.makeConstraints { (make) in
            make.height.equalTo(45)
            make.centerX.equalTo(leftBgView)
        }
        
        rightCommont.snp.makeConstraints { (make) in
            make.height.equalTo(45)
            make.centerX.equalTo(rightBgView)
        }
        
    }
    
    var model: SLClassStarChildrenModel!
    func setHeaderModel(_ model: SLClassStarChildrenModel){
        self.model = model
        
        UIUtil.yxs_setLabelAttributed(leftCommont.textLabel, text: ["表扬：", "\(model.praiseScore ?? 0)"], fonts: [UIFont.boldSystemFont(ofSize: 14),UIFont.boldSystemFont(ofSize: 21)])
        UIUtil.yxs_setLabelAttributed(rightCommont.textLabel, text: ["待改进：", "\(model.improveScore ?? 0)"], fonts: [UIFont.boldSystemFont(ofSize: 14),UIFont.boldSystemFont(ofSize: 21)])
        progressView.setProgress(model.praiseScore ?? 0, model.improveScore ?? 0)
        UIUtil.yxs_setLabelAttributed(countLabel, text: ["\(model.topNo ?? 0)\n","\(model.dateText)排名"], fonts: [UIFont.boldSystemFont(ofSize: 30),UIFont.boldSystemFont(ofSize: 15)])
        UIUtil.yxs_setLabelAttributed(totalLabel, text: ["总分\n\n","\(model.score ?? 0)\n"], fonts: [UIFont.boldSystemFont(ofSize: 14),UIFont.boldSystemFont(ofSize: 21)])
        UIUtil.yxs_setLabelAttributed(averageLabel, text: ["班级平均分\n\n","\(model.averageScore ?? "")\n"], fonts: [UIFont.boldSystemFont(ofSize: 14),UIFont.boldSystemFont(ofSize: 21)])
        dayLabel.text = "\(NSUtil.yxs_timePeriodText(dateType: model.dateType))(\(model.dateText))"
        
    }
    
    lazy var headerImageView: UIImageView = {
         let imageView = UIImageView.init(image: UIImage.init(named: "yxs_classstar_teacher_class_single_detial_bg"))
         return imageView
     }()
     
     lazy var leftCommont: YXSCustomImageControl = {
         
         let leftCommont = YXSCustomImageControl.init(imageSize: CGSize.init(width: 21.5, height: 23), position: YXSImagePositionType.left, padding: 12)
         leftCommont.textColor = UIColor.white
         leftCommont.locailImage = "yxs_classstar_teacher_class_good"
         return leftCommont
     }()
     lazy var rightCommont: YXSCustomImageControl = {
         
         let rightCommont = YXSCustomImageControl.init(imageSize: CGSize.init(width: 21.5, height: 23), position: YXSImagePositionType.left, padding: 12)
         rightCommont.textColor = UIColor.white
         rightCommont.locailImage = "yxs_classstar_teacher_class_bad"
         return rightCommont
     }()
     
     lazy var countLabel: YXSLabel = {
         let label = YXSLabel()
         label.textColor = UIColor.white
         label.textAlignment = .center
         label.numberOfLines = 0
         return label
     }()
     
     lazy var totalLabel: YXSLabel = {
         let label = YXSLabel()
         label.textColor = UIColor.white
         label.textAlignment = .center
         label.numberOfLines = 0
         return label
     }()
     lazy var averageLabel: YXSLabel = {
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
     
     lazy var dayLabel: YXSLabel = {
         let label = YXSLabel()
         label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#E7EDFD")
         label.font = UIFont.systemFont(ofSize: 14)
         return label
     }()
     
     lazy var leftBgView: UIView = {
         let leftBgView = UIView()
         leftBgView.backgroundColor = UIColor(red: 0.37, green: 0.53, blue: 0.97, alpha: 1)
         leftBgView.cornerRadius = 4
         return leftBgView
     }()
     lazy var rightBgView: UIView = {
         let rightBgView = UIView()
         rightBgView.backgroundColor = UIColor(red: 0.37, green: 0.53, blue: 0.97, alpha: 1)
         rightBgView.cornerRadius = 4
         return rightBgView
     }()
}
