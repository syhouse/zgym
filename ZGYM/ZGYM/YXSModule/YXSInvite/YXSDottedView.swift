//
//  SSSSView.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/25.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

/// 虚线View
class YXSDottedView: UIView {

    //一定要在这里设置 背景色， 不要再draw里面设置，
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
     
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
         
    override func draw(_ rect: CGRect) {
        
        let border = CAShapeLayer()
        border.strokeColor = UIColor.yxs_hexToAdecimalColor(hex: "#8085AB").cgColor
        border.fillColor = UIColor.clear.cgColor
        
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 11).cgPath
        border.frame = self.bounds
        
        border.lineWidth = 1
        border.lineDashPattern = [4, 4];
        
        self.layer.addSublayer(border)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
