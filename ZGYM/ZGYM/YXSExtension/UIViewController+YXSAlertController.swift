//
//  UIUtils.swift
//  HNYMEducation
//
//  Created by mac on 2019/6/27.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

extension UIViewController{
    func yxs_showAlert(title: String?) {
        self.showAlert(title: title, message: "")
    }
    
    func showAlert(title: String?, message: String?) {
        self.showAlert(title: title, message: message, complete: nil)
    }
    
    func showAlert(title: String?, complete: (() ->())?) {
        self.showAlert(title: title, message: "", complete: complete)
    }
    
    func showAlert(title: String?,message: String?, complete: (() ->())?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in
            if let block = complete{
                block();
            }
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String?,message: String? = nil,leftTitle: String?, leftClickBlock: (() ->())? = nil,rightTitle: String?, rightClickBlock: (() ->())?, leftColor: UIColor = kBlueColor, rightColor: UIColor = kBlueColor) {
        var left = "取消"
        var right = "确定"
        
        if let text = leftTitle{
            left = text
        }
        
        if let text = rightTitle{
            right = text
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let leftAcion = UIAlertAction(title: left, style: UIAlertAction.Style.default, handler: { action in
            if let block = leftClickBlock{
                block();
            }
        })
        leftAcion.setValue(leftColor, forKey: "_titleTextColor")
        alertController.addAction(leftAcion)
        
        let certainAction = UIAlertAction(title: right, style: UIAlertAction.Style.default, handler: { action in
            
            if let block = rightClickBlock{
                block();
            }
        })
        certainAction.setValue(rightColor, forKey: "_titleTextColor")
        alertController.addAction(certainAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
