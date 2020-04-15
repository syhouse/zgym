//
//  MBProgressHUD+Convenience.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/19.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import MBProgressHUD
    
extension MBProgressHUD {
    // MARK: - Message
    static func yxs_showMessage(message: String) {
        yxs_hideHUD()
        yxs_showMessage(message: message, inView: UIApplication.shared.keyWindow)
    }
    
    static func yxs_showMessage(message: String, afterDelay: TimeInterval = 0.89) {
        yxs_hideHUD()
        yxs_showMessage(message: message, inView: UIApplication.shared.keyWindow, afterDelay: afterDelay)
    }
    
    
    static func yxs_showMessage(message: String, inView: UIView?, afterDelay: TimeInterval = 0.89) {
        if inView == nil {
            return
        }
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: inView!, animated: true)
            hud.mode = .text
//            hud.label.text = message
            hud.detailsLabel.text = message
            hud.detailsLabel.font = UIFont.systemFont(ofSize: 16)
            hud.hide(animated: true, afterDelay: afterDelay)
        }
    }
    
    // MARK: - Loding...
    static func yxs_showLoading(ignore:Bool = false) {
        yxs_showLoading(message: "加载中...", ignore: ignore)
    }
    
    static func yxs_showLoading(message: String, ignore:Bool = false) {
//        UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
        yxs_showLoading(message: message, inView: UIApplication.shared.keyWindow, ignore: ignore)
    }
    
    static func yxs_showLoading(message: String = "加载中...", inView: UIView?, ignore:Bool = false) {
        if (inView == nil || ignore) {
            return
        }
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: inView!, animated: true)
            hud.label.text = message
            hud.mode = .indeterminate
            hud.yxs_commonSetup()
            hud.show(animated: true)

        }
    }
    
    // MARK: - Hide
    static func yxs_hideHUD() {
        yxs_hideHUDInView(view: UIApplication.shared.keyWindow ?? UIWindow())
    }
    
    static func yxs_hideHUDInView(view: UIView?) {
        if view == nil {
            return
        }
        MBProgressHUD.hide(for: view!, animated: true)
    }
    
    // MARK: - Private
    private static func yxs_hudInView(view: UIView) -> MBProgressHUD {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        return hud
    }
    
    func yxs_commonSetup() {
        self.removeFromSuperViewOnHide = true
        self.detailsLabel.font = UIFont.boldSystemFont(ofSize: 16)
    }
}
