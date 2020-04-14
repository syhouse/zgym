//
//  YXSRouterEventProtocol.swift
//  SwiftBase
//
//  Created by zgjy_mac on 2019/9/7.
//  Copyright © 2019 macmini. All rights reserved.
//

import UIKit

@objc public protocol YXSRouterEventProtocol {
    @objc func yxs_user_routerEventWithName(eventName: String, info: [String: Any]?)
}

public extension UIResponder{
    func yxs_routerEventWithName(eventName: String, info: [String: Any]? = nil) {
        if self.conforms(to: YXSRouterEventProtocol.self) {
            (self as! YXSRouterEventProtocol).yxs_user_routerEventWithName(eventName: eventName,info: info)
        }else{
            self.next?.yxs_routerEventWithName(eventName: eventName,info: info)
        }
    }
    
    ///获取label的便捷方法
    func getLabel(fontSize: CGFloat = 14.0,textColor: UIColor = kTextBlackColor,text: String = "") -> UILabel {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: fontSize)
        view.textColor = textColor
        view.text = text
        return view
    }
}
