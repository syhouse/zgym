//
//  SLSDWebImageMixedNight.swift
//  ZGYM
//
//  Created by sy_mac on 2020/2/26.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight


extension UIImageView{
    func yxs_setImageWithURL(url: URL?,placeholder: MixedImage?){
        self.sd_setImage(with: url, placeholderImage: nil) { (image, error, type, url) in
            if let image = image{
                self.mixedImage = MixedImage(normal: image, night: image)
            }else{
                self.mixedImage = placeholder
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
            }
        }
    }
}
