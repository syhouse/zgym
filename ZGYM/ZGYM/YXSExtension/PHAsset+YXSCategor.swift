//
//  PHAsset+YXSCategor.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/5/27.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit

extension PHAsset {
    func yxs_convert2ImageThumbnail(completionHandler:((UIImage?)->())?) {
        yxs_convert2ImageOrigin { (image) in
            if let img = image {
                let newSize = img.yxs_scaleImage(image: img, imageLength: 500)
                let thumbnailImage = img.yxs_resizeImage(image: img, newSize: newSize)
                completionHandler?(thumbnailImage)

            } else {
                completionHandler?(nil)
            }
        }
    }
    
    func yxs_convert2ImageOrigin(completionHandler:((UIImage?)->())?) {
        PHImageManager.default().requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: PHImageRequestOptions()) { (image, hashable) in
            if let img = image {
                completionHandler?(img)

            } else {
                completionHandler?(nil)
            }
        }
    }
}
