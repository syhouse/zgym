//
//  SLClassStarTeacherSingleCell.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/5.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class SLClassStarTeacherSingleCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        contentView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#D2E4FF")
        contentView.addSubview(bgView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(detialLabel)
        bgView.addSubview(iconImageView)
        yxs_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: kLineColor, night: kLineColor), leftMargin: 71, rightMargin: 15.5)
        
        bgView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(20.5)
            make.right.equalTo(-20.5)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 41, height: 41))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp_right).offset(14.5)
            make.top.equalTo(16)
        }
        detialLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom).offset(9.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var isPartent: Bool = false{
        didSet{
            if isPartent{
                bgView.snp.remakeConstraints { (make) in
                    make.top.bottom.equalTo(0)
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                }
            }
        }
    }
    var isLastRow: Bool = false{
        didSet{
            if isLastRow{
                bgView.yxs_addRoundedCorners(corners: [.bottomLeft,.bottomRight], radii: CGSize.init(width: 4, height: 4), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 69))
            }else{
                bgView.yxs_addRoundedCorners(corners: [.bottomLeft,.bottomRight], radii: CGSize.init(width: 0, height: 0), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 69))
            }
        }
    }
    
    var showChildName: Bool = false
    
    var model:SLClassStarHistoryModel!
    func yxs_setCellModel(_ model: SLClassStarHistoryModel){
        self.model = model
        let newUrl = (self.model.evaluationUrl ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        iconImageView.sd_setImage(with: URL.init(string: newUrl),placeholderImage: kImageDefualtImage, completed: nil)
        UIUtil.yxs_setLabelAttributed(titleLabel, text: ["\(model.scoreDescribe ?? "")  ", "\(model.evaluationItem ?? "")"], colors: [kBlueColor,UIColor.yxs_hexToAdecimalColor(hex: "#575A60")])
        detialLabel.text = "\(Date.yxs_Time(dateStr: model.createTime ?? "")) 由\(model.teacherName ?? "") 点评 \(showChildName ? model.childrenName ?? "" : "")"
    }
    // MARK: -getter&setter
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = kTextMainBodyFont
        label.textColor = kTextMainBodyColor
        return label
    }()
    
    lazy var detialLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return label
    }()
    
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.cornerRadius = 20.5
        return iconImageView
    }()
    
}


class ClassStarTeacherRemindCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
//        kNightForegroundColor
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: UIColor.white)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detialLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(remindButton)
        yxs_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: kLineColor, night: kLineColor), leftMargin: 15)
        
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 46, height: 46))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp_right).offset(14.5)
            make.top.equalTo(14)
        }
        detialLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom).offset(5.5)
        }
        remindButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 79, height: 31))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cellBlock: (()->())?
    @objc func remindClick(){
        cellBlock?()
    }
    
    func yxs_setCellModel(_ model: SLClassStartTeacherModel){
        iconImageView.sd_setImage(with: URL.init(string: model.avatar ?? ""),placeholderImage: kImageUserIconTeacherDefualtImage, completed: nil)
        detialLabel.text = model.position == "HEADMASTER" ? "班主任" : "任课老师"
        titleLabel.text = model.teacherName
    }
    // MARK: -getter&setter
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        return label
    }()
    
    lazy var detialLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return label
    }()
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.cornerRadius = 23
        iconImageView.contentMode = .scaleAspectFill
        return iconImageView
    }()
    
    lazy var remindButton: YXSButton = {
        let button = YXSButton.init()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15.5
        button.layer.borderWidth = 1
        button.layer.borderColor = kBlueColor.cgColor
        button.backgroundColor = UIColor.clear
        button.setTitleColor(kBlueColor, for: .normal)
        button.setTitle("提醒", for: .normal)
        button.addTarget(self, action: #selector(remindClick), for: .touchUpInside)
        return button
    }()
    
}
