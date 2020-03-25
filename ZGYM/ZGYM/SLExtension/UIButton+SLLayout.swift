//
//  UIButton+Layout.swift
//  HSZXShop
//
//  Created by sl_mac on 2019/9/11.
//  Copyright © 2019 Hszx. All rights reserved.
//

import UIKit

extension UIButton {
    
    /** 图片在左，标题在右 */
    
    func sl_setIconInLeft() {
        
        sl_setIconInLeftWithSpacing(0)
        
    }
    
    /** 图片在右，标题在左 */
    
    func sl_setIconInRight() {
        
        sl_setIconInRightWithSpacing(0)
        
    }
    
    /** 图片在上，标题在下 */
    
    func sl_setIconInTop() {
        
        sl_setIconInTopWithSpacing(0)
        
    }
    
    /** 图片在下，标题在上 */
    
    func sl_setIconInBottom() {
        
        sl_setIconInBottomWithSpacing(0)
        
    }
    
    //** 可以自定义图片和标题间的间隔 */
    
    func sl_setIconInLeftWithSpacing(_ Spacing: CGFloat) {
        
        titleEdgeInsets = UIEdgeInsets()
        
        titleEdgeInsets.top = 0
        
        titleEdgeInsets.left = 0
        
        titleEdgeInsets.bottom = 0
        
        titleEdgeInsets.right = -Spacing
        
        imageEdgeInsets = UIEdgeInsets()
        
        imageEdgeInsets.top = 0
        
        imageEdgeInsets.left = -Spacing
        
        imageEdgeInsets.bottom = 0
        
        imageEdgeInsets.right = 0
        
    }
    
    func sl_setIconInRightWithSpacing(_ Spacing: CGFloat) {
        
        let img_W: CGFloat = imageView?.frame.size.width ?? 0.0
        
        let tit_W: CGFloat = titleLabel?.frame.size.width ?? 0.0
        
        titleEdgeInsets = UIEdgeInsets()
        
        titleEdgeInsets.top = 0
        
        titleEdgeInsets.left = -(img_W + Spacing / 2)
        
        titleEdgeInsets.bottom = 0
        
        titleEdgeInsets.right = img_W + Spacing / 2
        
        imageEdgeInsets = UIEdgeInsets()
        
        imageEdgeInsets.top = 0
        
        imageEdgeInsets.left = tit_W + Spacing / 2
        
        imageEdgeInsets.bottom = 0
        
        imageEdgeInsets.right = -(tit_W + Spacing / 2)
        
    }
    
    func sl_setIconInTopWithSpacing(_ Spacing: CGFloat) {
        
        let img_W: CGFloat = imageView?.frame.size.width ?? 0.0
        
        let img_H: CGFloat = imageView?.frame.size.height ?? 0.0
        
        let tit_W: CGFloat = titleLabel?.frame.size.width ?? 0.0
        
        let tit_H: CGFloat = titleLabel?.frame.size.height ?? 0.0
        
        titleEdgeInsets = UIEdgeInsets()
        
        titleEdgeInsets.top = tit_H / 2 + Spacing / 2
        
        titleEdgeInsets.left = -(img_W / 2)
        
        titleEdgeInsets.bottom = -(tit_H / 2 + Spacing / 2)
        
        titleEdgeInsets.right = img_W / 2
        
        imageEdgeInsets = UIEdgeInsets()
        
        imageEdgeInsets.top = -(img_H / 2 + Spacing / 2)
        
        imageEdgeInsets.left = tit_W / 2
        
        imageEdgeInsets.bottom = img_H / 2 + Spacing / 2
        
        imageEdgeInsets.right = -(tit_W / 2)
        
    }
    
    func sl_setIconInBottomWithSpacing(_ Spacing: CGFloat) {
        
        let img_W: CGFloat = imageView?.frame.size.width ?? 0.0
        
        let img_H: CGFloat = imageView?.frame.size.height ?? 0.0
        
        let tit_W: CGFloat = titleLabel?.frame.size.width ?? 0.0
        
        let tit_H: CGFloat = titleLabel?.frame.size.height ?? 0.0
        
        titleEdgeInsets = UIEdgeInsets()
        
        titleEdgeInsets.top = -(tit_H / 2 + Spacing / 2)
        
        titleEdgeInsets.left = -(img_W / 2)
        
        titleEdgeInsets.bottom = tit_H / 2 + Spacing / 2
        
        titleEdgeInsets.right = img_W / 2
        
        imageEdgeInsets = UIEdgeInsets()
        
        imageEdgeInsets.top = img_H / 2 + Spacing / 2
        
        imageEdgeInsets.left = tit_W / 2
        
        imageEdgeInsets.bottom = -(img_H / 2 + Spacing / 2)
        
        imageEdgeInsets.right = -(tit_W / 2)
        
    }
    
}
