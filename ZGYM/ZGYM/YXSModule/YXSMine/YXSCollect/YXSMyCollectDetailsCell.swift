//
//  YXSMyCollectDetailsCell.swift
//  ZGYM
//
//  Created by yihao on 2020/4/14.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import NightNight

class YXSMyCollectDetailsCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeImageV)
        contentView.addSubview(timeLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(18)
        }
        
        timeImageV.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp_bottom).offset(5)
            make.width.height.equalTo(11)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeImageV.snp_right).offset(5)
            make.top.equalTo(timeImageV)
            make.width.equalTo(100)
            make.height.equalTo(11)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model:YXSMyCollectModel) {
        nameLabel.text = model.voiceTitle
        timeLabel.text = model.voiceTimeStr
    }
    
    // MARK: -getter&setter
    lazy var nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#222222"), night: kNightBCC6D4)
        return label
    }()
    
    lazy var timeImageV: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage.init(named: "yxs_collect_time")
        return imgV
    }()
    
    lazy var timeLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        return label
    }()
}
