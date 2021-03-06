//
//  UIView+Border.swift
//  ZGYM
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

extension UIView{
    /**
     *  设置部分圆角(绝对布局)
     *
     *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
     *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
     */
    func yxs_addRoundedCorners(corners: UIRectCorner, radii: CGSize) {
        yxs_addRoundedCorners(corners: corners, radii: radii, rect: self.bounds)
    }
    
    /**
     *  设置部分圆角(相对布局)
     *
     *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
     *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
     *  @param rect    需要设置的圆角view的rect
     *  注意rect 宽度高度和view的实际宽高一致  否则无效(没有效果请先检查展示的宽高是否和设置的一致)
     */
    func yxs_addRoundedCorners(corners: UIRectCorner, radii: CGSize, rect: CGRect) {
        let rounded = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
        let shape = CAShapeLayer.init()
        shape.path = rounded.cgPath
        self.layer.mask = shape
    }
    
    func yxs_removeRoundedCorners() {
        self.layer.mask?.removeFromSuperlayer()
    }
}
