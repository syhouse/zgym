//
//  SLSystemMessageTableViewCell.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/20.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLSystemMessageTableViewCell: SLBaseTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.lbTitle)
        self.contentView.addSubview(self.lbDate)
        
        self.lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(16)
            make.left.equalTo(15)
            make.right.equalTo(-10)
        })
        
        self.lbDate.snp.makeConstraints({ (make) in
            make.top.equalTo(self.lbTitle.snp_bottom).offset(9)
            make.left.equalTo(15)
            make.right.equalTo(-10)
            make.bottom.equalTo(-16)
        })
        
        self.contentView.sl_addLine(position: LinePosition.bottom, color: UIColor.gray, leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lazy
    lazy var lbTitle: SLLabel = {
        let lb = SLLabel()
        lb.numberOfLines = 0
        lb.mixedTextColor = MixedColor(normal: 0x575A60, night: 0x575A60)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbDate: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: 0x898F9A, night: 0x898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
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
