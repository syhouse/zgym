//
//  SLSDWebImageMixedNight.swift
//  ZGYM
//
//  Created by sy_mac on 2020/2/26.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight
import Bugly

extension UIImageView{
    func yxs_setImageWithURL(url: URL?,placeholder: MixedImage?){
        self.sd_setImage(with: url, placeholderImage: nil) { (image, error, type, url) in
            if let image = image{
                self.mixedImage = MixedImage(normal: image, night: image)
            }else{
                self.mixedImage = placeholder
                ///记录未加载出来图片链接
                Bugly.setUserValue(url?.absoluteString ?? "", forKey: "YXSImageLoadError")
                if let error = error{
                    Bugly.reportError(NSError(domain: "图片加载失败:\((error as NSError).localizedDescription)", code: (error as NSError).code, userInfo: (error as NSError).userInfo) as Error)
                }else{
                   Bugly.reportError(NSError(domain: "图片加载失败", code: 100, userInfo: nil) as Error)
                }
                
            }
        }
    }
}


extension UIButton{
    func yxs_setImage(with url: URL?,for state: UIControl.State,placeholderImage: MixedImage){
        self.sd_setImage(with: url, for: state,placeholderImage: nil) {(image, error, type, url) in
            if let image = image{
                self.setMixedImage(MixedImage(normal: image, night: image), forState: state)

            }else{
                self.setMixedImage(placeholderImage, forState: state)
                Bugly.setUserValue(url?.absoluteString ?? "", forKey: "YXSImageLoadError")
                if let error = error{
                    Bugly.reportError(NSError(domain: "图片加载失败", code: (error as NSError).code, userInfo: (error as NSError).userInfo) as Error)
                }else{
                   Bugly.reportError(NSError(domain: "图片加载失败", code: 100, userInfo: nil) as Error)
                }
            }
        }
    }
}
