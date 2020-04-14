//
//  PaddingLabel.swift
//  EducationShop
//
//  Created by zgjy_mac on 2019/9/28.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

public class YXSPaddingLabel: UILabel {
    
    var textInsets: UIEdgeInsets = .zero
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = textInsets
        var rect = super.textRect(forBounds: bounds.inset(by: insets),
                                  limitedToNumberOfLines: numberOfLines)
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
    
}

