//
//  YXSParentClassListTableViewCell.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/20.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSParentClassListTableViewCell: YXSBaseClassListTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.lbName)
        self.contentView.addSubview(self.lbStudentNumber)
        
        self.lbTitle.snp.remakeConstraints({ (make) in
            make.top.equalTo(26)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        })
        
        self.lbName.snp.makeConstraints({ (make) in
            make.top.equalTo(self.lbClassNumber.snp_bottom).offset(15)
            make.left.equalTo(self.lbClassNumber.snp_left).offset(0)
            make.bottom.equalTo(-20)
        })
        
        self.lbStudentNumber.snp.makeConstraints({ (make) in
            make.top.equalTo(self.lbClassNumber.snp_bottom).offset(15)
            make.left.equalTo(self.lbName.snp_right).offset(18)
        })
        
        let cl = NightNight.theme == .night ? kNightBackgroundColor : UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9")
        self.contentView.yxs_addLine(position: LinePosition.top, color:cl , leftMargin: 0, rightMargin: 0, lineHeight: 10)
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
    lazy var lbName: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNight898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    /// 学号
    lazy var lbStudentNumber: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNight898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
}
