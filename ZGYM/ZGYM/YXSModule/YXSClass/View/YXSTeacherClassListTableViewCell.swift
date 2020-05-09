//
//  YXSTeacherClassListTableViewCell.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/20.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSTeacherClassListTableViewCell: YXSBaseClassListTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
//        self.lbStudentCount.snp.remakeConstraints({ (make) in
//            make.top.equalTo(self.lbClassNumber.snp_top)
//            make.left.equalTo(self.lbClassNumber.snp_right).offset(22)
//        })
        
        self.contentView.addSubview(btnInvite)
        btnInvite.snp.makeConstraints({ (make) in
            make.top.equalTo(22)
            make.bottom.equalTo(-22)
//            make.centerY.equalTo(self.lbStudentCount.snp_centerY)
//            make.centerY.equalTo(contentView.snp_centerY)
            make.right.equalTo(imgRightArrow.snp_right).offset(-30)
            make.width.equalTo(89)
            make.height.equalTo(30)
        })
    }
    
    @objc func inviteClick(sender: YXSButton) {
        
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
    lazy var btnInvite: YXSButton = {
        let btn = YXSButton()
        btn.isHidden = true
        btn.setTitle("邀请成员", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(kRedMainColor, for: .normal)
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.borderColor = kRedMainColor
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(inviteClick(sender:)), for: .touchUpInside)
        return btn
    }()
}
