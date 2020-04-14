//
//  UINavigationController+Common.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/29.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation

extension UINavigationController {
    /// 是否包含ViewController
    func yxs_existViewController<T:Any>(existClass: T, complete:((_ isContain:Bool, _ resultVC: T)->())?) {
        for sub in self.viewControllers {
            if sub is T {
                complete?(true, sub as! T)
                break
            }
        }
    }
    
    
    /// 是否包含ViewController
    /// - Parameters:
    ///   - existClass: ViewController.Type
    ///   - complete: 找到后回调 返回该vc
    func yxs_existViewController<T: UIViewController>(existClass: T.Type, complete:((_ resultVC: T)->())?) {
        for sub in self.viewControllers {
            if sub.classForCoder ==  T.classForCoder(){
                complete?(sub as! T )
                break
            }
        }
    }
}
