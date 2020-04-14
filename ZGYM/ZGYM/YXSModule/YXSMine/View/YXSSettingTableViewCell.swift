//
//  YXSSettingTableViewCell.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/20.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSSettingTableViewCell: YXSBaseTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.lbTitle)
        self.contentView.addSubview(self.lbSubTitle)
        self.contentView.addSubview(self.imgRightArrow)
        
        

        self.lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(16)
            make.bottom.equalTo(-16)
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(self.contentView.snp_left).offset(15)
        })
        
        self.lbSubTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(self.lbTitle.snp_right).offset(10)
        })
        
        self.imgRightArrow.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(self.lbSubTitle.snp_right).offset(10)
            make.right.equalTo(self.contentView.snp_right).offset(-10)
        })
        
        self.contentView.yxs_addLine(position: LinePosition.bottom, color: kLineColor, leftMargin: 15, rightMargin: 0, lineHeight: 0.5)
    }
    
    // MARK: - LazyLoad
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: 0x222222, night: 0xFFFFFF)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbSubTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: 0x898F9A, night: 0x898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var imgRightArrow: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "arrow_gray")
        return img
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
