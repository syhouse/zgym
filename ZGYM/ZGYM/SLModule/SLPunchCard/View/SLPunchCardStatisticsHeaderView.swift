//
//  SLPunchCardStatisticsHeaderView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/2.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLPunchCardStatisticsHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#A9CBFF")
        
        addSubview(headerImageView)

        addSubview(labelImageView)
        
        addSubview(midBgView)
        
        addSubview(bottomBgView)
        
        addSubview(linkLeftView)
        addSubview(linkRightView)
        
        midBgView.addSubview(leftLabel)
        leftLabel.sl_addLine(position: .right, mixedBackgroundColor: MixedColor(normal: kLineColor, night: kLineColor),leftMargin: 42.5, rightMargin: 45.5)
        midBgView.addSubview(rightLabel)
        
        bottomBgView.addSubview(colourBarView)
        colourBarView.addSubview(colourBarLabel)
        
        layout()
    }
    
    func layout(){
        headerImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(226 + kSafeTopHeight)
        }
       
        labelImageView.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.height.equalTo(33)
            make.top.equalTo(183 + kSafeTopHeight)
            
        }
        midBgView.snp.makeConstraints { (make) in
            make.left.equalTo(20.5)
            make.right.equalTo(-20.5)
            make.top.equalTo(labelImageView).offset(13.5)
            make.height.equalTo(140)
        }
        leftLabel.snp.makeConstraints { (make) in
            make.left.bottom.top.equalTo(0)
            make.width.equalTo(midBgView).multipliedBy(0.5)
        }
        rightLabel.snp.makeConstraints { (make) in
            make.right.bottom.top.equalTo(0)
            make.width.equalTo(leftLabel)
        }
        
        bottomBgView.snp.remakeConstraints { (make) in
            make.top.equalTo(midBgView.snp_bottom).offset(10)
            make.left.equalTo(20.5)
            make.right.equalTo(-20.5)
            make.height.equalTo(81)
            make.bottom.equalTo(0).priorityHigh()
        }
        
        colourBarView.snp.makeConstraints { (make) in
            make.centerX.equalTo(bottomBgView)
            make.top.equalTo(22.5)
            make.size.equalTo(CGSize.init(width: 204, height: 40))
        }
        colourBarLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(colourBarView)
            make.top.equalTo(8)
        }
        
        linkLeftView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(midBgView.snp_bottom).offset(-26)
            make.size.equalTo(CGSize.init(width: 31.5, height: 62))
        }
        linkRightView.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.top.equalTo(midBgView.snp_bottom).offset(-26)
            make.size.equalTo(CGSize.init(width: 31.5, height: 62))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var model: SLPunchCardStatisticsModel!
    func setHeaderModel(_ model: SLPunchCardStatisticsModel){
        self.model = model
        UIUtil.sl_setLabelAttributed(leftLabel, text: ["\(model.currentClockInDayNo ?? 0)", "/\(model.totalDay ?? 0)天\n\n", "已打卡天数"], colors: [kBlueColor, UIColor.sl_hexToAdecimalColor(hex: "#575A60"), UIColor.sl_hexToAdecimalColor(hex: "#898F9A")], fonts: [UIFont.boldSystemFont(ofSize: 26),UIFont.boldSystemFont(ofSize: 16), UIFont.boldSystemFont(ofSize: 15)])
        UIUtil.sl_setLabelAttributed(rightLabel, text: ["\(model.currentClockInPeopleCount ?? 0)", "/\(model.currentClockInTotalCount ?? 0)人\n\n", "已打卡人数"], colors: [kBlueColor, UIColor.sl_hexToAdecimalColor(hex: "#575A60"), UIColor.sl_hexToAdecimalColor(hex: "#898F9A")], fonts: [UIFont.boldSystemFont(ofSize: 26),UIFont.boldSystemFont(ofSize: 16), UIFont.boldSystemFont(ofSize: 15)])
 
    }
    
    // MARK: -getter&setter
    
    lazy var headerImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "sl_punchCardStatistics_bg"))
        return imageView
    }()
    
    lazy var labelImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "sl_punchCard_midline"))
        return imageView
    }()
    
    lazy var colourBarView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "sl_punchCardStatistics_colour_bar"))
        return imageView
    }()
    
    
    lazy var midBgView: UIView = {
        let midBgView = UIView()
        midBgView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#ffffff")
        midBgView.layer.cornerRadius = 5
        return midBgView
    }()
    
    lazy var bottomBgView: UIView = {
        let bottomBgView = UIView()
        bottomBgView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#ffffff")
        bottomBgView.sl_addRoundedCorners(corners: [.topLeft, .topRight], radii: CGSize.init(width: 5, height: 5), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 81))
        return bottomBgView
    }()
    
    lazy var linkLeftView: UIImageView = {
        let linkLeftView = UIImageView.init(image: UIImage.init(named: "sl_punchCard_link"))
        return linkLeftView
    }()
    
    lazy var linkRightView: UIImageView = {
        let linkRightView = UIImageView.init(image: UIImage.init(named: "sl_punchCard_link"))
        return linkRightView
    }()
    
    lazy var leftLabel: SLLabel = {
        let label = SLLabel()
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var rightLabel: SLLabel = {
        let label = SLLabel()
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        return label
    }()
    lazy var colourBarLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "打卡排行榜"
        label.textColor = UIColor.white
        return label
    }()
}

