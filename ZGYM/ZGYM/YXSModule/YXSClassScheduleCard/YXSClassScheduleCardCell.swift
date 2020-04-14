//
//  YXSClassScheduleCardCell.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/27.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//


import UIKit
import NightNight

class YXSClassScheduleCardCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        
        contentView.addSubview(yxs_lineView)
        contentView.addSubview(yxs_nameLabel)
        contentView.addSubview(yxs_numberLabel)
        contentView.addSubview(yxs_scheduleCardView)
        contentView.addSubview(yxs_imgRightArrow)
        
        yxs_lineView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(10)
        }
        
        yxs_scheduleCardView.snp.makeConstraints { (make) in
            make.right.equalTo(-36.5)
            make.top.equalTo(22)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
        
        yxs_imgRightArrow.snp.makeConstraints({ (make) in
            make.centerY.equalTo(yxs_scheduleCardView)
            make.right.equalTo(-14.5)
            make.size.equalTo(CGSize.init(width: 8.25, height: 13.4))
        })
        
        yxs_nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16.5)
            make.top.equalTo(yxs_scheduleCardView.snp_top).offset(5)
            make.right.equalTo(yxs_scheduleCardView.snp_left).offset(-10)
        }
        yxs_numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(yxs_nameLabel)
            make.top.equalTo(yxs_nameLabel.snp_bottom).offset(9.5)
        }


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func yxs_setCellModel(_ model: YXSClassScheduleCardModel){
        yxs_nameLabel.text = model.className
        yxs_numberLabel.text = "班级号：\(model.classCode ?? "")      成员：\(model.numberCount ?? "")"
        yxs_scheduleCardView.sd_setImage(with: URL.init(string: model.imageUrl ?? ""),placeholderImage: kImageDefualtImage, completed: nil)
    }
    
    // MARK: -getter&setter
    lazy var yxs_lineView: UIView = {
        let yxs_lineView = UIView()
        yxs_lineView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        return yxs_lineView
    }()
    
    lazy var yxs_nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = kTextMainBodyFont
        label.textColor = kTextMainBodyColor
        return label
    }()
    
    lazy var yxs_numberLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return label
    }()

    lazy var yxs_scheduleCardView: UIImageView = {
        let yxs_scheduleCardView = UIImageView()
        return yxs_scheduleCardView
    }()
    
    lazy var yxs_imgRightArrow: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "yxs_class_arrow")
        return img
    }()
}
