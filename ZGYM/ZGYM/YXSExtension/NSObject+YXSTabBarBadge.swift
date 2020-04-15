//
//  UIViewController+TabBarBadge.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/13.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import UIKit

extension NSObject{
    // 获取TabBarItem当前Count数
    func yxs_getBadgeCountOnItem(index:Int)-> Int {
        let tabBar = yxs_getTabBar()
        for subView:UIView in tabBar?.subviews ?? [UIView]() {
            if subView.tag == 888+index {
                if subView is YXSUnReadView {
                    let unReadView = subView as! YXSUnReadView
                    return unReadView.count
                }
            }
        }
        return 0
    }
    
    /// TabBar 红色未读角标
    func yxs_showBadgeOnItem(index:Int, count:Int) {
        yxs_removeBadgeOnItem(index: index)
        let bview = YXSUnReadView()
        bview.tag = 888+index
        bview.setNum(count)

        let tabBar = yxs_getTabBar()
        if tabBar == nil {
            return
        }
        
        let tabFrame = tabBar?.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        let percentX = (Float(index)+0.6)/Float(tabBar?.items?.count ?? 0)//(tabBar的总个数)
        let x = CGFloat(ceilf(percentX*Float(tabFrame.width)))
        let y = CGFloat(ceilf(0.1*Float(tabFrame.height)))
        bview.frame = CGRect(x: x-5, y: y-2, width: bview.frame.width, height: bview.frame.height)

        if tabBar != nil {
            tabBar?.addSubview(bview)
            tabBar?.bringSubviewToFront(bview)
        }
        
        if index == 0 {
            YXSChatHelper.sharedInstance.refreshApplicationIconBadgeNum()
        }
    }
    
    //隐藏红点
    func yxs_hideBadgeOnItem(index:Int) {
        yxs_removeBadgeOnItem(index: index)
    }
    
    //移除控件
    @objc func yxs_removeBadgeOnItem(index:Int) {
        if UIUtil.RootController() is UITabBarController {
            for subView:UIView in yxs_getTabBar()?.subviews ?? [UIView]() {
                if subView.tag == 888+index {
                    subView.removeFromSuperview()
                }
            }
        }
    }
    
    func yxs_getTabBar()-> UITabBar?{
        if UIUtil.RootController() is UITabBarController {
            let tabBarController = UIUtil.RootController() as! UITabBarController
            return tabBarController.tabBar
        } else {
            return nil
        }
    }
}
