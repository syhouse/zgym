//
//  YXSPunchCardStatisticsHeaderView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/2.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSPunchCardStatisticsHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F5F4F7"), night: kNight383E56)
        
        addSubview(yxs_topBgView)
        addSubview(yxs_bottomView)
        
        yxs_topBgView.addSubview(yxs_leftLabel)
        yxs_topBgView.addSubview(yxs_rightLabel)
        
        yxs_bottomView.addSubview(yxs_leftImage)
        yxs_bottomView.addSubview(yxs_rightImage)
        yxs_bottomView.addSubview(yxs_rankLabel)
        layout()
    }
    
    func layout(){
        yxs_topBgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(112)
            make.bottom.equalTo(-66)
        }
        yxs_leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(29.5)
            make.width.equalTo(yxs_topBgView).multipliedBy(0.5)
        }
        yxs_rightLabel.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.top.equalTo(29.5)
            make.width.equalTo(yxs_leftLabel)
        }
        yxs_bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(56)
        }
        yxs_rankLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(24)
        }
        yxs_leftImage.snp.makeConstraints { (make) in
            make.right.equalTo(yxs_rankLabel.snp_left).offset(-18.5)
            make.centerY.equalTo(yxs_rankLabel)
            make.width.height.equalTo(12.5)
        }
        yxs_rightImage.snp.makeConstraints { (make) in
            make.left.equalTo(yxs_rankLabel.snp_right).offset(18.5)
            make.centerY.equalTo(yxs_rankLabel)
            make.width.height.equalTo(12.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var model: YXSPunchCardStatisticsModel!
    func setHeaderModel(_ model: YXSPunchCardStatisticsModel){
        self.model = model
        UIUtil.yxs_setLabelAttributed(yxs_leftLabel, text: ["已打卡天数\n", "\(model.currentClockInDayNo ?? 0)/\(model.totalDay ?? 0)"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"),kBlueColor], fonts: [UIFont.systemFont(ofSize: 15),UIFont.boldSystemFont(ofSize: 29)], paragraphLineSpacing: 14.5)
        UIUtil.yxs_setLabelAttributed(yxs_rightLabel, text: ["已打卡人数\n","\(model.currentClockInPeopleCount ?? 0)/\(model.currentClockInTotalCount ?? 0)"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"),kBlueColor], fonts: [UIFont.systemFont(ofSize: 15),UIFont.boldSystemFont(ofSize: 29)], paragraphLineSpacing: 14.5)
        yxs_rankLabel.text = "打卡排行榜"
        yxs_leftImage.image = UIImage.init(named: "yxs_punch_sprit")
        yxs_rightImage.image = UIImage.init(named: "yxs_punch_sprit")
    }
    
    // MARK: -getter&setter
    lazy var yxs_topBgView: UIView = {
        let yxs_midBgView = UIView()
        yxs_midBgView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight383E56)
        return yxs_midBgView
    }()
    
    lazy var yxs_leftLabel: YXSLabel = {
        let label = YXSLabel()
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var yxs_rightLabel: YXSLabel = {
        let label = YXSLabel()
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var yxs_bottomView: UIView = {
        let yxs_bottomView = UIView()
        yxs_bottomView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        return yxs_bottomView
    }()
    
    lazy var yxs_rankLabel: YXSLabel = {
        let label = YXSLabel()
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    lazy var yxs_leftImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var yxs_rightImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
}


