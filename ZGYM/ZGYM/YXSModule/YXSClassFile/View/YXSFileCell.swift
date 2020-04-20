//
//  YXSFileCell.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/1.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

///
class YXSFileCell: YXSBaseFileCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titlesContainer)
        titlesContainer.addSubview(lbTitle)
        titlesContainer.addSubview(lbSubTitle)
        
        contentView.addSubview(iconBgView)
        iconBgView.addSubview(imgIcon)
        
        layout()
    }
    
    @objc func layout() {
        titlesContainer.snp.makeConstraints({ (make) in
            make.left.equalTo(17)
            make.centerY.equalTo(contentView.snp_centerY)
        })
        
        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        })
        
        lbSubTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle.snp_bottom).offset(8)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        })
        
        iconBgView.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.left.equalTo(titlesContainer.snp_right).offset(10)
            make.right.equalTo(-15)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(50)
        })
        
        imgIcon.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
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

    // MARK: - LazyLoad
    lazy var lbSubTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    lazy var titlesContainer: UIView = {
        let view = UIView()
        return view
    }()
}
