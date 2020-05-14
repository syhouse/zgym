//
//  UIControl+YXSTapRange.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/14.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
private var ts_touchAreaEdgeInsets: UIEdgeInsets = .zero
extension UIControl {
    /// Increase your button touch area.
    /// If your button frame is (0,0,40,40). Then call button.ts_touchInsets = UIEdgeInsetsMake(-30, -30, -30, -30), it will Increase the touch area
    public var yxs_touchInsets: UIEdgeInsets {
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
        if self.yxs_touchInsets == .zero || !self.isEnabled || self.isHidden {
            return super.point(inside: point, with: event)
        }
        
        let relativeFrame = self.bounds
        let hitFrame = CGRect.init(x: -self.yxs_touchInsets.left, y: -self.yxs_touchInsets.top, width: relativeFrame.width + yxs_touchInsets.left + yxs_touchInsets.right, height: relativeFrame.height + yxs_touchInsets.top + yxs_touchInsets.bottom)
            relativeFrame.inset(by: self.yxs_touchInsets)
        return hitFrame.contains(point)
    }
}
