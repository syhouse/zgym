//
//  UITextField+SLClearButton.swift
//  ZGYM
//
//  Created by yanlong on 2020/2/19.
//  Copyright © 2020 zgjy_mac. All rights reserved.
//

import Foundation
extension UITextField {
    /// 设置输入框清除按钮背景图片
    func setClearButtonImage(isUpdate:Bool) {
        if isUpdate {
            let clearButton : UIButton = self.value(forKey: "_clearButton") as! UIButton
            clearButton.setImage(UIImage(named: "yxs_account_clear"), for: .normal)
        }
    }
}
