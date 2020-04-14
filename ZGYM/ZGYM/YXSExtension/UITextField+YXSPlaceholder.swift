//
//  UITextField+Placeholder.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2020/1/8.
//  Copyright © 2020 zgjy_mac. All rights reserved.
//

import Foundation
extension UITextField {
    /// 深色模式 设置展位文字颜色
    @objc func setPlaceholder(ph:String) {
        self.placeholder = ph
        let str = NSAttributedString(string: ph, attributes: [NSAttributedString.Key.foregroundColor:UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")])
        self.attributedPlaceholder = str
    }
}
