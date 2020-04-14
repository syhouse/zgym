//
//  UIButton+Layout.swift
//  HSZXShop
//
//  Created by zgjy_mac on 2019/9/11.
//  Copyright © 2019 Hszx. All rights reserved.
//

import UIKit

extension UIButton {
    
    /** 图片在左，标题在右 */
    
    func yxs_setIconInLeft() {
        
        yxs_setIconInLeftWithSpacing(0)
        
    }
    
    /** 图片在右，标题在左 */
    
    func yxs_setIconInRight() {
        
        yxs_setIconInRightWithSpacing(0)
        
    }
    
    /** 图片在上，标题在下 */
    
    func yxs_setIconInTop() {
        
        yxs_setIconInTopWithSpacing(0)
        
    }
    
    /** 图片在下，标题在上 */
    
    func yxs_setIconInBottom() {
        
        yxs_setIconInBottomWithSpacing(0)
        
    }
    
    //** 可以自定义图片和标题间的间隔 */
    
    func yxs_setIconInLeftWithSpacing(_ Spacing: CGFloat) {
        
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
    
    func yxs_setIconInRightWithSpacing(_ Spacing: CGFloat) {
        
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
    
    func yxs_setIconInTopWithSpacing(_ Spacing: CGFloat) {
        
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
    
    func yxs_setIconInBottomWithSpacing(_ Spacing: CGFloat) {
        
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


// MARK: - touchAreaEdgeInsets
private var ts_touchAreaEdgeInsets: UIEdgeInsets = .zero

extension UIButton {
    /// Increase your button touch area.
    /// If your button frame is (0,0,40,40). Then call button.ts_touchInsets = UIEdgeInsetsMake(-30, -30, -30, -30), it will Increase the touch area
    public var ts_touchInsets: UIEdgeInsets {
        get {
            if let value = objc_getAssociatedObject(self, &ts_touchAreaEdgeInsets) as? NSValue {
                var edgeInsets: UIEdgeInsets = .zero
                value.getValue(&edgeInsets)
                return edgeInsets
            }else {
                return .zero
            }
        }
        set(newValue) {
            var newValueCopy = newValue
            let objCType = NSValue(uiEdgeInsets: .zero).objCType
            let value = NSValue(&newValueCopy, withObjCType: objCType)
            objc_setAssociatedObject(self, &ts_touchAreaEdgeInsets, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.ts_touchInsets == .zero || !self.isEnabled || self.isHidden {
            return super.point(inside: point, with: event)
        }
        
        let relativeFrame = self.bounds
        let hitFrame = relativeFrame.inset(by: self.ts_touchInsets)
        
        return hitFrame.contains(point)
    }
}
