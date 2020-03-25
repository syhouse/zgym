//
//  SLClassMembersTableViewCell.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/22.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLClassMembersTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
            
        self.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        
        self.contentView.addSubview(self.imgAvatar)
        self.contentView.addSubview(self.lbTitle)
        self.contentView.addSubview(self.lbSubTitle)
        
        self.imgAvatar.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(15)
            make.width.height.equalTo(46)
        })
        
        self.lbTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(self.imgAvatar.snp_right).offset(14)
        })
        
        self.lbSubTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(self.lbTitle.snp_right).offset(10)
            make.right.equalTo(self.contentView.snp_right).offset(-16)
        })
        
        contentView.sl_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor), leftMargin: 15, lineHeight: 0.5)
    }
    
    // MARK: - LazyLoad
    lazy var imgAvatar: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.cornerRadius = 23
        img.image = UIImage(named: "")
        img.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#D6E3FD")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var lbTitle: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNight898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbSubTitle: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: kGrayShadowColor, night: kNight898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
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
