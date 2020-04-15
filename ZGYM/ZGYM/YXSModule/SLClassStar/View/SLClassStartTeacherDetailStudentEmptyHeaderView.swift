//
//  SLClassStartTeacherDetailStudentEmptyHeaderView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/10.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

let kYXSClassStartTeacherDetailStudentEmptyHeaderViewRemindEvent = "SLClassStartTeacherDetailStudentEmptyHeaderViewRemindEvent"
class SLClassStartTeacherDetailStudentEmptyHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9")
        addSubview(bgView)
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(titleLabel)
        addSubview(commentLabel)
        addSubview(goRemindButton)
        layout()
    }
    
    func layout(){
        bgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(-10)
        }
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(29 + kSafeTopHeight + 64)
            make.centerX.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 70, height: 70))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp_bottom).offset(11)
            make.centerX.equalTo(bgView)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_bottom).offset(12)
            make.centerX.equalTo(bgView)
        }
        goRemindButton.snp.makeConstraints { (make) in
            make.top.equalTo(commentLabel.snp_bottom).offset(25.5)
            make.bottom.equalTo(-34.5).priorityHigh()
            make.centerX.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 192, height: 49))
        }
    }
    
    @objc func goRemind(){
        next?.yxs_routerEventWithName(eventName: kYXSClassStartTeacherDetailStudentEmptyHeaderViewRemindEvent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: YXSChildrenModel!
    func setHeaderModel(_ model: YXSChildrenModel, dateType: DateType){
        titleLabel.text = "\(NSUtil.yxs_getDateText(dateType: dateType))暂无点评"
        nameLabel.text = model.realName
        iconImageView.sd_setImage(with: URL.init(string: model.avatar ?? ""),placeholderImage: kImageUserIconStudentDefualtImage, completed: nil)
        UIUtil.yxs_setLabelAttributed(commentLabel, text: ["全国已有", "200万", "名学生正在使用此功能，班级之星是学生德育培养的重要辅助功能，赶快去提醒老师使用吧！"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#BABDC2"),kBlueColor, UIColor.yxs_hexToAdecimalColor(hex: "#BABDC2")])
        
        let height = UIUtil.yxs_getTextHeigh(textStr: "全国已有" + "200万" + "名学生正在使用此功能，班级之星是学生德育培养的重要辅助功能，赶快去提醒老师使用吧！", font: UIFont.systemFont(ofSize: 14), width: SCREEN_WIDTH - 94)
        var frame = self.frame
        frame.size.height = CGFloat(177.5 + height + 10 + kSafeTopHeight + 64 + 119)
        self.frame = frame
        
        commentLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(24.5)
            make.left.equalTo(47)
            make.right.equalTo(-47)
            make.height.equalTo(height + 10)
        }
    }
    
    // MARK: -getter&setter
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        bgView.cornerRadius = 5
        return bgView
    }()
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#6A6C71")
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var commentLabel: YXSLabel = {
        let label = YXSLabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#6A6C71")
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var goRemindButton: YXSButton = {
        let goRemindButton = YXSButton()
        goRemindButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        goRemindButton.setTitleColor(UIColor.white, for: .normal)
        goRemindButton.setTitle("一键提醒", for: .normal)
        goRemindButton.cornerRadius = 24.5
        goRemindButton.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 192, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        goRemindButton.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 192, height: 49), color: UIColor.yxs_hexToAdecimalColor(hex: "#4C74F6"), cornerRadius: 7.5, offset: CGSize(width: 0, height: 3))
        goRemindButton.addTarget(self, action: #selector(goRemind), for: .touchUpInside)
        return goRemindButton
    }()
    
    lazy var nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.cornerRadius = 35
        iconImageView.contentMode = .scaleAspectFill
        return iconImageView
    }()
    
}
