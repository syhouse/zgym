//
//  SLPunchCardStatisticsCell.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/2.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//


import UIKit
import SnapKit
import SDWebImage
import NightNight

class SLPunchCardStatisticsCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#AACCFF")
        contentView.addSubview(bgView)
        bgView.addSubview(userIcon)
        bgView.addSubview(nameLabel)
        bgView.addSubview(timeLabel)
        bgView.addSubview(numberLabel)
        bgView.addSubview(numberIconView)
        
        bgView.sl_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: kLineColor, night: kLineColor), leftMargin: 15.5,rightMargin: 15.5)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(20.5)
            make.right.equalTo(-20.5)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        userIcon.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 41, height: 41))
            make.left.equalTo(45)
            make.centerY.equalTo(bgView)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userIcon.snp_right).offset(13)
            make.centerY.equalTo(bgView)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-26.5)
            make.centerY.equalTo(bgView)
        }
        numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(21)
            make.centerY.equalTo(bgView)
        }
        numberIconView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 21, height: 29))
            make.left.equalTo(15.5)
            make.centerY.equalTo(bgView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model:SLClassModel!
    
    var isLastRow: Bool = false{
        didSet{
            if isLastRow{
                bgView.sl_addRoundedCorners(corners: [.bottomLeft,.bottomRight], radii: CGSize.init(width: 4, height: 4), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 61.5))
            }else{
                bgView.sl_addRoundedCorners(corners: [.bottomLeft,.bottomRight], radii: CGSize.init(width: 0, height: 0), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 61.5))
            }
        }
    }
    func sl_setCellModel(_ model: ClockInListTopResponseList){
        nameLabel.text = model.realName
        timeLabel.text = "\(model.dayCount ?? 0)天"
        userIcon.sd_setImage(with: URL.init(string: model.avatar ?? ""),placeholderImage: kImageUserIconStudentDefualtImage, completed: nil)
        numberIconView.isHidden = true
        numberLabel.isHidden = true
        if let topNo = model.topNo{
            if topNo >= 4{
                numberLabel.isHidden = false
                numberLabel.text = "\(topNo)"
            }else{
                numberIconView.isHidden = false
                switch topNo - 1 {
                case 0:
                    numberIconView.image = UIImage.init(named: "sl_punchCard_first")
                case 1:
                    numberIconView.image = UIImage.init(named: "sl_punchCard_secend")
                default:
                    numberIconView.image = UIImage.init(named: "sl_PunchCard_thrid")
                }
            }
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    // MARK: -getter&setter
    lazy var numberIconView: UIImageView = {
        let numberIconView = UIImageView.init(image: kImageUserIconStudentDefualtImage)
        numberIconView.cornerRadius = 20.5
        return numberIconView
    }()
    lazy var userIcon: UIImageView = {
        let userIcon = UIImageView.init(image: kImageUserIconStudentDefualtImage)
        userIcon.cornerRadius = 20.5
        userIcon.contentMode = .scaleAspectFill
        return userIcon
    }()
    
    lazy var nameLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#575A60")
        return label
    }()
    
    lazy var numberLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#575A60")
        return label
    }()
    
    
    lazy var timeLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#898F9A")
        return label
    }()
    
}
