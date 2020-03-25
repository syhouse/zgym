//
//  SLRouterEventExtension.swift
//  SwiftBase
//
//  Created by sl_mac on 2019/9/7.
//  Copyright © 2019 macmini. All rights reserved.
//

import UIKit

@objc public protocol SLRouterEventProtocol {
    @objc func sl_user_routerEventWithName(eventName: String, info: [String: Any]?)
}

public extension UIResponder{
    func sl_routerEventWithName(eventName: String, info: [String: Any]? = nil) {
        if self.conforms(to: SLRouterEventProtocol.self) {
            (self as! SLRouterEventProtocol).sl_user_routerEventWithName(eventName: eventName,info: info)
        }else{
            self.next?.sl_routerEventWithName(eventName: eventName,info: info)
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
