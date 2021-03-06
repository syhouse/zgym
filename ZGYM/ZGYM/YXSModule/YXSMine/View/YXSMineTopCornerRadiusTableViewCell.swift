//
//  SLMineTopCornerRadioTableViewCell.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/3/10.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

class YXSMineTopCornerRadiusTableViewCell: YXSMineTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bgView.yxs_addRoundedCorners(corners: [.topLeft, .topRight], radii: CGSize(width: 5, height: 5), rect: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-30, height: 50))
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
