//
//  YXSPunchCardStatisticsCell.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/2.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//


import UIKit
import SnapKit
import SDWebImage
import NightNight

class YXSPunchCardStatisticsCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(yxs_userIcon)
        contentView.addSubview(yxs_nameLabel)
        contentView.addSubview(yxs_timeLabel)
        contentView.addSubview(yxs_numberLabel)
        contentView.addSubview(yxs_numberIconView)
        
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        contentView.yxs_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: kLineColor, night: kLineColor), leftMargin: 16,rightMargin: 0)
        
        yxs_userIcon.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 41, height: 41))
            make.left.equalTo(45)
            make.centerY.equalTo(contentView)
        }
        yxs_nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(yxs_userIcon.snp_right).offset(13)
            make.centerY.equalTo(contentView)
        }
        yxs_timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-26.5)
            make.centerY.equalTo(contentView)
        }
        yxs_numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(21)
            make.centerY.equalTo(contentView)
        }
        yxs_numberIconView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 21, height: 29))
            make.left.equalTo(15.5)
            make.centerY.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model:SLClassModel!
    
    func yxs_setCellModel(_ model: YXSClockInListTopResponseList){
        yxs_nameLabel.text = model.realName
        yxs_timeLabel.text = "\(model.dayCount ?? 0)天"
        yxs_userIcon.sd_setImage(with: URL.init(string: model.avatar ?? ""),placeholderImage: kImageUserIconStudentDefualtImage, completed: nil)
        yxs_numberIconView.isHidden = true
        yxs_numberLabel.isHidden = true
        if let topNo = model.topNo{
            if topNo >= 4{
                yxs_numberLabel.isHidden = false
                yxs_numberLabel.text = "\(topNo)"
            }else{
                yxs_numberIconView.isHidden = false
                switch topNo - 1 {
                case 0:
                    yxs_numberIconView.image = UIImage.init(named: "yxs_punchCard_first")
                case 1:
                    yxs_numberIconView.image = UIImage.init(named: "yxs_punchCard_secend")
                default:
                    yxs_numberIconView.image = UIImage.init(named: "yxs_PunchCard_thrid")
                }
            }
        }
    }
    // MARK: -getter&setter
    lazy var yxs_numberIconView: UIImageView = {
        let yxs_numberIconView = UIImageView()
        yxs_numberIconView.cornerRadius = 20.5
        return yxs_numberIconView
    }()
    lazy var yxs_userIcon: UIImageView = {
        let yxs_userIcon = UIImageView.init(image: kImageUserIconStudentDefualtImage)
        yxs_userIcon.cornerRadius = 20.5
        yxs_userIcon.contentMode = .scaleAspectFill
        return yxs_userIcon
    }()
    
    lazy var yxs_nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4)
        return label
    }()
    
    lazy var yxs_numberLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4)
        return label
    }()
    
    
    lazy var yxs_timeLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        return label
    }()
    
}
