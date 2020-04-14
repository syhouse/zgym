//
//  SLSearchSectionHeaderView.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/12.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

class HMSearchSectionHeaderView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let view = YXSSearchView()
        contentView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
