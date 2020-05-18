//
//  YXSPeriodicalCell.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/8.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import NightNight

class YXSPeriodicalCell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(rightImageView)
        contentView.addSubview(yxs_nameLabel)
        contentView.addSubview(yxs_desLabel)
        contentView.addSubview(timeLabel)
        
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: UIColor.white)
        contentView.yxs_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: kLineColor, night: kLineColor), leftMargin: 15)

        yxs_nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(24)
        }
        
        yxs_desLabel.snp.makeConstraints { (make) in
            make.top.equalTo(yxs_nameLabel.snp_bottom).offset(9)
            make.left.equalTo(yxs_nameLabel)
            make.right.equalTo(rightImageView.snp_left).offset(-20)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(yxs_desLabel.snp_bottom).offset(23)
            make.left.equalTo(yxs_nameLabel)
            make.bottom.equalTo(-27.5).priorityHigh()
        }
        
        rightImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.width.height.equalTo(86)
            make.top.equalTo(yxs_nameLabel).offset(-5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func yxs_setCellModel(_ model: YXSPeriodicalListModel){
        yxs_nameLabel.text = "优期刊第\(model.numPeriods ?? 1)期"
        yxs_desLabel.text = model.theme
        timeLabel.text = model.publishTime?.yxs_Date().toString(format: DateFormatType.custom("MM.dd HH:mm"))
        rightImageView.sd_setImage(with: URL.init(string: model.cover?.yxs_getImageThumbnail() ?? ""), placeholderImage: kImageDefualtImage)
    }

    // MARK: -getter&setter
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.contentMode = .scaleAspectFill
        rightImageView.layer.cornerRadius = 2.5
        return rightImageView
    }()
    
    lazy var yxs_nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kTextMainBodyColor)
        return label
    }()
    
    lazy var yxs_desLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"))
        return label
    }()
    
    lazy var timeLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        return label
    }()
}
