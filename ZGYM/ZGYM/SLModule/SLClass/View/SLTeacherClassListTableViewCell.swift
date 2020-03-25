//
//  SLTeacherClassListTableViewCell.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/20.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLTeacherClassListTableViewCell: SLBaseClassListTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.contentView.addSubview(btnInvite)
        btnInvite.snp.makeConstraints({ (make) in
            make.top.equalTo(22)
            make.bottom.equalTo(-22)
            make.centerY.equalTo(self.lbStudentCount.snp_centerY)
            make.right.equalTo(imgRightArrow.snp_right).offset(-30)
            make.width.equalTo(89)
            make.height.equalTo(30)
        })
    }
    
    @objc func inviteClick(sender: SLButton) {
        
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
    lazy var btnInvite: SLButton = {
        let btn = SLButton()
        btn.isHidden = true
        btn.setTitle("邀请成员", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(UIColor.sl_hexToAdecimalColor(hex: "#5E88F7"), for: .normal)
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.borderColor = UIColor.sl_hexToAdecimalColor(hex: "#5E88F7")
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(inviteClick(sender:)), for: .touchUpInside)
        return btn
    }()
}
