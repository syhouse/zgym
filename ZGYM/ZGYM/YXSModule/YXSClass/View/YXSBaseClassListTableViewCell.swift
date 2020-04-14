//
//  YXSBaseClassListTableViewCell.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/20.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

/// 班级列表Cell基类
class YXSBaseClassListTableViewCell: YXSBaseTableViewCell {//UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        
        self.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        self.contentView.addSubview(self.lbTitle)
        self.contentView.addSubview(self.lbClassNumber)
        self.contentView.addSubview(self.lbStudentCount)
        self.contentView.addSubview(self.imgRightArrow)
        
        self.lbTitle.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentView.snp_centerY).offset(-5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        })
        
        self.lbClassNumber.snp.makeConstraints({ (make) in
            make.top.equalTo(self.lbTitle.snp_bottom).offset(12)
            make.left.equalTo(15)
        })
        
        self.lbStudentCount.snp.makeConstraints({ (make) in
            make.top.equalTo(self.lbTitle.snp_bottom).offset(12)
            make.left.equalTo(self.lbClassNumber.snp_right).offset(22)
        })
        
        self.imgRightArrow.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.right.equalTo(self.contentView.snp_right).offset(-15)
        })
        
        self.contentView.yxs_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor), leftMargin: 15, lineHeight: 0.5)
    }
    
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
    
    // MARK: - LazyLoad
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: k222222Color, night: kNightFFFFFF)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    /// 班级号
    lazy var lbClassNumber: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    /// 成员
    lazy var lbStudentCount: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    lazy var imgRightArrow: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "yxs_class_arrow")
        return img
    }()
}
