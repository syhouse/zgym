//
//  YXSMineSwitchTableViewCell.swift
//  HNYMEducation
//
//  Created by Liu Jie on 2020/2/26.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit

class YXSMineSwitchTableViewCell: YXSMineTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        imgRightArrow.isHidden = true
        redDot.isHidden = true
        
        self.bgView.addSubview(self.swt)
        self.swt.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.bgView.snp_centerY)
            make.right.equalTo(self.bgView.snp_right).offset(-15)
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
    lazy var swt: UISwitch = {
        let swt = UISwitch(frame: CGRect(x: 0, y: 0, width: 43, height: 22))
        swt.onTintColor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")
        
        return swt
    }()

}
