//
//  SLFileGroupCell.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/1.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

/// 文件夹
class SLFileGroupCell: SLBaseFileCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconBgView)
        iconBgView.addSubview(imgIcon)
        contentView.addSubview(lbTitle)
        contentView.addSubview(imgRightArrow)
        
        layout()
        
        imgIcon.image = UIImage(named: "yxs_file_folder")
        imgRightArrow.image = UIImage(named: "yxs_class_arrow")
    }
    
    @objc func layout() {
        iconBgView.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(50)
        })
        
        imgIcon.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        
        lbTitle.snp.makeConstraints({ (make) in
            make.left.equalTo(iconBgView.snp_right).offset(15)
            make.centerY.equalTo(contentView.snp_centerY)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(50)
        })
        
        imgRightArrow.snp.makeConstraints({ (make) in
            make.left.equalTo(lbTitle.snp_right)
            make.right.equalTo(-16)
            make.centerY.equalTo(contentView.snp_centerY)
            make.width.equalTo(9)
            make.height.equalTo(14)
        })
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
}
