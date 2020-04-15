//
//  UIView+line.swift
//  ZGYM
//
//  Created by mac on 2019/6/27.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import NightNight

//线在view的位置
enum LinePosition{
    case top,bottom,left,right
}

extension UIView{
    @discardableResult
    func yxs_addLine(position: LinePosition = .bottom, color: UIColor = kLineColor, leftMargin: CGFloat = 0, rightMargin: CGFloat = 0, lineHeight: CGFloat = 0.5) -> UIView {
        return yxs_addLine(position: position, mixedBackgroundColor: MixedColor(normal: color, night: UIColor.yxs_hexToAdecimalColor(hex: "#282C3B")), leftMargin: leftMargin, rightMargin: rightMargin, lineHeight: lineHeight)
    }
    
    @discardableResult
    func yxs_addLine(position: LinePosition = .bottom, mixedBackgroundColor: MixedColor , leftMargin: CGFloat = 0, rightMargin: CGFloat = 0, lineHeight: CGFloat = 0.5) -> UIView {
        let view = UIView.init()
        view.tag = 123456
        view.mixedBackgroundColor = mixedBackgroundColor
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        //        let lineHeight = 1.0
        
        var tempConstraints = [NSLayoutConstraint]()
        
        /*
         "H" 表示横向 横向描述关系
         "V" 表示纵向 纵向描述关系
         "[]"：表示View
         "|"：表示superView，用来确定View的上下左右关系
         */
        var vConstraints: String,hConstraints: String
        switch position {
        case .top:
            vConstraints = String(format: "V:|-0-[view(==%f)]", lineHeight)
            hConstraints = String(format: "H:|-%f-[view]-%f-|", arguments: [leftMargin,rightMargin])
        case .bottom:
            vConstraints = String(format: "V:[view(==%f)]-0-|", lineHeight)
            hConstraints = String(format: "H:|-%f-[view]-%f-|", arguments: [leftMargin,rightMargin])
        case .left:
            vConstraints = String(format: "V:|-%f-[view]-%f-|", arguments: [leftMargin,rightMargin])
            hConstraints = String(format: "H:|-0-[view(==%f)]", lineHeight)
        case .right:
            vConstraints = String(format: "V:|-%f-[view]-%f-|", arguments: [leftMargin,rightMargin])
            hConstraints = String(format: "H:[view(==%f)]-0-|", lineHeight)
        }
        
        let viewBindings = ["view":view]
        tempConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: vConstraints, options: NSLayoutConstraint.FormatOptions.alignAllLeft, metrics: nil, views: viewBindings))
        tempConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: hConstraints, options: NSLayoutConstraint.FormatOptions.alignAllLeft, metrics: nil, views: viewBindings))
        self.addConstraints(tempConstraints)

        return view
    }

    func yxs_removeLine() {
        for subView in self.subviews {
            if subView.tag == 123456 {
                subView.removeFromSuperview()
            }
        }
    }
}
