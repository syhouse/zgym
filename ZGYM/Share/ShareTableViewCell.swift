//
//  ShareTableViewCell.swift
//  Share
//
//  Created by Liu Jie on 2020/3/19.
//  Copyright © 2020 LiuJie. All rights reserved.
//

import UIKit

class ShareTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(lbTitle)
        self.contentView.addSubview(imgRightArrow)
        
        lbTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp_centerY)
            make.left.equalTo(0)
        })
        
//        imgRightArrow.backgroundColor = UIColor.red
        imgRightArrow.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(-15)
            make.width.equalTo(9)
            make.height.equalTo(14)
            
//            make.left.equalTo(lbTitle.snp_right).offset(10)
//            make.right.equalTo(0)
//            make.width.height.equalTo(19)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var lbTitle: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#333333")
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    lazy var imgRightArrow: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "right_arrow.png")
        return imgView
    }()
}
