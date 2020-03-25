//
//  MBProgressHUD+Convenience.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/19.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import Foundation
import MBProgressHUD
    
extension MBProgressHUD {
    // MARK: - Message
    static func sl_showMessage(message: String) {
        sl_hideHUD()
        sl_showMessage(message: message, inView: UIApplication.shared.keyWindow)
    }
    
    static func sl_showMessage(message: String, afterDelay: TimeInterval = 0.89) {
        sl_hideHUD()
        sl_showMessage(message: message, inView: UIApplication.shared.keyWindow, afterDelay: afterDelay)
    }
    
    
    static func sl_showMessage(message: String, inView: UIView?, afterDelay: TimeInterval = 0.89) {
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
    static func sl_showLoading(ignore:Bool = false) {
        sl_showLoading(message: "加载中...", ignore: ignore)
    }
    
    static func sl_showLoading(message: String, ignore:Bool = false) {
//        UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
        sl_showLoading(message: message, inView: UIApplication.shared.keyWindow, ignore: ignore)
    }
    
    static func sl_showLoading(message: String = "加载中...", inView: UIView?, ignore:Bool = false) {
        if (inView == nil || ignore) {
            return
        }
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: inView!, animated: true)
            hud.label.text = message
            hud.mode = .indeterminate
            hud.sl_commonSetup()
            hud.show(animated: true)

        }
    }
    
    // MARK: - Hide
    static func sl_hideHUD() {
        sl_hideHUDInView(view: UIApplication.shared.keyWindow ?? UIWindow())
    }
    
    static func sl_hideHUDInView(view: UIView?) {
        if view == nil {
            return
        }
        MBProgressHUD.hide(for: view!, animated: true)
    }
    
    // MARK: - Private
    private static func sl_hudInView(view: UIView) -> MBProgressHUD {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        return hud
    }
    
    func sl_commonSetup() {
        self.removeFromSuperViewOnHide = true
        self.detailsLabel.font = UIFont.boldSystemFont(ofSize: 16)
    }
}
