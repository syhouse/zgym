//
//  SLClassDetialTableHeaderView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/21.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

private var texts = ["通知", "作业", "班级之星", "打卡", "接龙", "课表", "通讯录"]
private var images = [kNoticeKey, kHomeworkKey, kClassStartKey, kPunchCardKey, kSolitaireKey, kCourseKey, kAddressbookKey]
private var actions = [SLHomeActionEvent.notice,.homework, .classstart, .punchCard, .solitaire, .course, .addressbook]
private var kMaxCount = 8

let kYMClassDetialTableHeaderViewLookChildDetialEvent = "SLClassDetialTableHeaderViewLookChildDetialEvent"
let kYMClassDetialTableHeaderViewUpDateListEvent = "SLClassDetialTableHeaderViewUpDateListEvent"

class SLClassDetialTableHeaderView: UIView {
    var classModel: SLClassModel
    var childModel: SLChildrenModel?
    init(frame: CGRect, classModel: SLClassModel) {
        self.classModel = classModel
        super.init(frame: frame)
        addSubview(teacherView)
        teacherView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }
        addSubview(parentView)
        parentView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }
        
        parentView.isHidden = SLPersonDataModel.sharePerson.personRole == .TEACHER ? true : false
        teacherView.isHidden = SLPersonDataModel.sharePerson.personRole == .TEACHER ? false : true
        addSubview(itemBgView)
        itemBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            if SLPersonDataModel.sharePerson.personRole == .TEACHER{
                make.top.equalTo(teacherView.snp_bottom)
            }else{
                make.top.equalTo(parentView.snp_bottom)
            }
            make.bottom.equalTo(0)
        }
        
        for index in 0..<kMaxCount{
            let control = SLCustomImageControl.init(imageSize: CGSize.init(width: 41, height: 41), position: .top, padding: 14)
            control.tag = index + kYMHomeTableHeaderViewOrginTag
            control.addTarget(self, action: #selector(controlClick), for: .touchUpInside)
            itemBgView.addSubview(control)
            
        }
        setButtonUI(stage:.PRIMARY_SCHOOL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -public
    func setButtonUI(stage: StageType){
        var lineCount = 0
        if stage == .KINDERGARTEN{
            texts = ["通知", "班级之星", "打卡", "接龙", "食谱", "通讯录"]
            images = [kNoticeKey, kClassStartKey, kPunchCardKey, kSolitaireKey, kFoodKey, kAddressbookKey]
            actions = [SLHomeActionEvent.notice, .classstart, .punchCard, .solitaire, .course, .addressbook]
            lineCount = 3
        }else{
            texts = ["通知", "作业", "班级之星", "打卡", "接龙", "课表", "通讯录"]
            images = [kNoticeKey, kHomeworkKey, kClassStartKey, kPunchCardKey, kSolitaireKey, kCourseKey, kAddressbookKey]
            actions = [SLHomeActionEvent.notice,.homework, .classstart, .punchCard, .solitaire, .course, .addressbook]
            lineCount = 4
        }
        var last: UIView!
        let padding: CGFloat = (SCREEN_WIDTH - 40*2 - 41*CGFloat(lineCount))/CGFloat((lineCount - 1))
        let itemMargin = 25
        let itemWidth: CGFloat = 41
        for index in 0..<kMaxCount{
            let control = viewWithTag(kYMHomeTableHeaderViewOrginTag + index)!
            control.isHidden = true
            control.snp_removeConstraints()
        }
        
        for index in 0..<texts.count{
            let control = viewWithTag(kYMHomeTableHeaderViewOrginTag + index) as! SLCustomImageControl
            control.title = texts[index]
            control.locailImage = images[index]
            control.mixedTextColor  = MixedColor(normal: kTextLightBlackColor, night: UIColor.white)
            control.font = UIFont.systemFont(ofSize: 14)
            let row = index % lineCount
            let low = index / lineCount
            control.snp.makeConstraints { (make) in
                if row == 0{
                    if low == 0{
                        make.top.equalTo(23)
                    }else{
                        make.top.equalTo(last!.snp_bottom).offset(17)
                    }
                    make.left.equalTo(itemMargin)
                }
                else {
                    make.top.equalTo(last!)
                    make.left.equalTo(last!.snp_right).offset(padding)
                    if row == lineCount - 1{
                        make.right.equalTo(-itemMargin)
                    }
                }
                
                make.width.equalTo(itemWidth)
                
                if index == texts.count - 1 {
                    make.bottom.equalTo(-23)
                }
                
            }
            control.isHidden = false
            last = control
        }
    }
    // MARK: -action
    @objc func controlClick(control: UIControl){
        let index = control.tag - kYMHomeTableHeaderViewOrginTag
        if SLPersonDataModel.sharePerson.personRole == .PARENT{
            sl_dealHomeAction(actions[index],classId: classModel.id,childModel: childModel)
        }else{
            sl_dealHomeAction(actions[index],classId: classModel.id,childModel: childModel)
        }
    }
    
    @objc func showChildDetial(){
        sl_routerEventWithName(eventName: kYMClassDetialTableHeaderViewLookChildDetialEvent)
    }
    
    
    lazy var itemBgView: UIView = {
        let itemBgView = UIView()
        itemBgView.mixedBackgroundColor =  MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        if NightNight.theme == .normal{
            itemBgView.addShadow(ofColor: UIColor(red: 0.83, green: 0.86, blue: 0.94, alpha: 0.35), radius: 10, offset: CGSize(width: 0, height: 3), opacity: 0.3)
        }
        return itemBgView
    }()
    
    
    lazy var teacherView: ClassDetialTeacherView = {
        let teacherView = ClassDetialTeacherView()
        teacherView.addTarget(self, action: #selector(showChildDetial), for: .touchUpInside)
        return teacherView
    }()
    
    lazy var parentView: ClassDetialParentView = {
        let parentView = ClassDetialParentView()
        parentView.addTarget(self, action: #selector(showChildDetial), for: .touchUpInside)
        return parentView
    }()
    
    
    
}

class ClassDetialTeacherView: UIControl{
    override init(frame: CGRect) {
        super.init(frame: frame)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight20232F)
        addSubview(leftView)
        addSubview(rightView)
        addSubview(lineView)
        leftView.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.right.equalTo(-(SCREEN_WIDTH/2) - 27)
            make.height.equalTo(26)
        }
        
        rightView.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.left.equalTo(SCREEN_WIDTH/2 + 27)
            make.height.equalTo(26)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(leftView.snp_bottom).offset(20)
            make.height.equalTo(0.5)
            make.bottom.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewModel(_ model: SLClassDetailModel?){
        leftView.title = "教师：\(model?.teachers ?? 0)"
        rightView.title = "成员：\(model?.members ?? 0)"
    }
    
    lazy var leftView: SLCustomImageControl = {
        let midView = SLCustomImageControl.init(imageSize: CGSize.init(width: 26, height: 26), position: .left, padding: 7.5)
        midView.mixedImage = MixedImage(normal: "sl_teacher_class", night: "sl_teacher_class_night")
        midView.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white)
        midView.font = UIFont.systemFont(ofSize: 17)
        midView.isUserInteractionEnabled = false
        return midView
    }()
    
    lazy var rightView: SLCustomImageControl = {
        let midView = SLCustomImageControl.init(imageSize: CGSize.init(width: 26, height: 26), position: .left, padding: 7.5)
        
        midView.mixedImage = MixedImage(normal: "sl_class_member", night: "sl_class_member_night")
        midView.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white)
        midView.font = UIFont.systemFont(ofSize: 17)
        midView.isUserInteractionEnabled = false
        return midView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#E6EAF3"), night: kNight2F354B)
        return lineView
    }()
}
private let kMaxChildCount = 4
private let kChildOrginTag = 101
class ClassDetialParentView: UIControl{
    override init(frame: CGRect) {
        super.init(frame: frame)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight20232F)
        
        addSubview(classNumberLabel)
        addSubview(memberLabel)
        addSubview(lineView)
        addSubview(nameLabel)
        addSubview(imageView)
        

        memberLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(classNumberLabel)
            make.right.equalTo(-15)
        }
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(15)
            make.size.equalTo(CGSize.init(width: 42, height: 42))
        }
        classNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(21.5)
            make.right.equalTo(memberLabel.snp_left).offset(-31)
        }
        
        nameLabel.isHidden = true
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(60)
            make.height.equalTo(0.5)
            make.bottom.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setViewModel(_ model: SLClassDetailModel?, classModel: SLClassModel){
        nameLabel.isHidden = true
        
        imageView.sd_setImage(with: URL.init(string: model?.getCurruntChild(classModel: classModel)?.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage, completed: nil)
        memberLabel.text = "成员:\(model?.members ?? 0)"
        classNumberLabel.text = "班级号：\(model?.num ?? "")"
    }
    
    lazy var nameLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.mixedTextColor = MixedColor(normal: kTextLightBlackColor, night: UIColor.white)
        return label
    }()
    
    lazy var classNumberLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: kTextLightBlackColor, night: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"))
        return label
    }()
    lazy var memberLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: kTextLightBlackColor, night: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"))
        return label
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#E6EAF3"), night: kNight2F354B)
        return lineView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(image: kImageUserIconStudentDefualtImage)
        imageView.cornerRadius = 21
        return imageView
    }()
}
