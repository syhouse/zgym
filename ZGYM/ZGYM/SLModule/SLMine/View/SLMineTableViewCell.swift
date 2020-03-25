//
//  SLMineTableViewCell.swift
//  ZGYM
//
//  Created by mac_hm on 2019/11/16.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLMineTableViewCell: SLBaseTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.mixedBackgroundColor = MixedColor(normal: UIColor.clear, night: UIColor.clear)
        self.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.clear, night: UIColor.clear)
        
        
        self.contentView.addSubview(bgView)
        bgView.addSubview(self.imgView)
        bgView.addSubview(self.lbTitle)
        bgView.addSubview(self.redDot)
        bgView.addSubview(self.imgRightArrow)
        
        bgView.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
//            make.centerY.equalTo(self.contentView.snp_centerY)
            make.top.equalTo(0)
            make.right.equalTo(-15)
            make.bottom.equalTo(0)
            make.height.equalTo(50)
        })

        
        imgView.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(self.bgView.snp_centerY)
            make.width.height.equalTo(23)
        })
        
        lbTitle.snp.makeConstraints({ (make) in
            make.left.equalTo(self.imgView.snp_right).offset(13)
            make.centerY.equalTo(self.bgView.snp_centerY)
        })
        
        redDot.snp.makeConstraints({ (make) in
            make.centerY.equalTo(imgRightArrow.snp_centerY)
            make.right.equalTo(imgRightArrow.snp_left).offset(-13)
            make.width.height.equalTo(12)
        })
        
        imgRightArrow.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp_centerY)
            make.right.equalTo(-15)
        })
        
//        if NightNight.theme != .night {
//            self.contentView.sl_addLine(position: LinePosition.bottom, leftMargin: 15, rightMargin: 15)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LazyLoad
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        return bgView
    }()
    
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    lazy var lbTitle: SLLabel = {
        let lbTitle = SLLabel()
        lbTitle.text = ""
        lbTitle.mixedTextColor = MixedColor(normal: 0x222222, night: 0xFFFFFF)
        return lbTitle
    }()
    
    lazy var redDot: UIView = {
        let view = UIView()
        view.isHidden = true
        view.cornerRadius = 6
        view.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#E8534C")
        return view
    }()
    
    lazy var imgRightArrow: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "arrow_gray")
        return img
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
