//
//  SLClassScheduleCardCell.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/27.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//


import UIKit
import NightNight

class SLClassScheduleCardCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        
        contentView.addSubview(lineView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(numberLabel)
        contentView.addSubview(scheduleCardView)
        contentView.addSubview(imgRightArrow)
        
        lineView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(10)
        }
        
        scheduleCardView.snp.makeConstraints { (make) in
            make.right.equalTo(-36.5)
            make.top.equalTo(22)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
        
        imgRightArrow.snp.makeConstraints({ (make) in
            make.centerY.equalTo(scheduleCardView)
            make.right.equalTo(-14.5)
            make.size.equalTo(CGSize.init(width: 8.25, height: 13.4))
        })
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16.5)
            make.top.equalTo(scheduleCardView.snp_top).offset(5)
            make.right.equalTo(scheduleCardView.snp_left).offset(-10)
        }
        numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp_bottom).offset(9.5)
        }


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func sl_setCellModel(_ model: SLClassScheduleCardModel){
        nameLabel.text = model.className
        numberLabel.text = "班级号：\(model.classCode ?? "")      成员：\(model.numberCount ?? "")"
        scheduleCardView.sd_setImage(with: URL.init(string: model.imageUrl ?? ""),placeholderImage: kImageDefualtImage, completed: nil)
    }
    
    // MARK: -getter&setter
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        return lineView
    }()
    
    lazy var nameLabel: SLLabel = {
        let label = SLLabel()
        label.font = kTextMainBodyFont
        label.textColor = kTextMainBodyColor
        return label
    }()
    
    lazy var numberLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#898F9A")
        return label
    }()

    lazy var scheduleCardView: UIImageView = {
        let scheduleCardView = UIImageView()
        return scheduleCardView
    }()
    
    lazy var imgRightArrow: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "sl_class_arrow")
        return img
    }()
}
