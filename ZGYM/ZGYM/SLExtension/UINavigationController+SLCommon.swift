//
//  UINavigationController+Common.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/29.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import Foundation

extension UINavigationController {
    /// 是否包含ViewController
    func sl_existViewController<T:Any>(existClass: T, complete:((_ isContain:Bool, _ resultVC: T)->())?) {
        for sub in self.viewControllers {
            if sub is T {
                complete?(true, sub as! T)
                break
            }
        }
    }
}
