//
//  UIView+CallUp.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/29.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation

extension UIView {
    func yxs_callUp(mobile:String) {
        _ = YXSCommonAlertView.showAlert(title: mobile, message: "", leftTitle: "取消", leftClick: nil, rightTitle: "拨打", rightClick: {
            let phone = "telprompt://" + "\(mobile)"
            if UIApplication.shared.canOpenURL(URL(string: phone)!) {
                 UIApplication.shared.openURL(URL(string: phone)!)
             }
        })
//        UIUtil.yxs_setLabelAttributed(alert.messageLabel, text: ["是否呼叫", "  \(mobile)"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#575A60"),kTextMainBodyColor])
//        alert.beginAnimation()
    }
}
