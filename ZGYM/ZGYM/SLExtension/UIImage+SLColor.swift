//
//  UIImage+color.swift
//  EsayFreeBook
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019 mac_sy. All rights reserved.
//

import UIKit

extension UIImage {
    static func sl_image(with color: UIColor,size: CGSize = CGSize.init(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    static func sl_screenSnapshot() -> UIImage? {
        
        guard let window = UIApplication.shared.keyWindow else { return nil }
        
        // 用下面这行而不是UIGraphicsBeginImageContext()，因为前者支持Retina
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, 0.0)
        
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        return image
    }
    
    static func sl_getScreenShotImage(fromVideoPath filePath: String?) -> UIImage? {
        //视频路径URL
        let fileURL = URL(fileURLWithPath: filePath ?? "")
        return sl_getScreenShotImage(fromVideoUrl: fileURL)
    }
    
    static func sl_getScreenShotImage(fromVideoUrl fileURL: URL?) -> UIImage? {
        
        var shotImage: UIImage?
        
        guard let fileURL = fileURL else {
            return nil
        }
        
        let asset = AVURLAsset(url: fileURL, options: nil)
        
        let gen = AVAssetImageGenerator(asset: asset)
        
        gen.appliesPreferredTrackTransform = true
        
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        
        var actualTime = CMTime()
        
        var image: CGImage? = nil
        do {
            image = try gen.copyCGImage(at: time, actualTime: &actualTime)
        } catch {
        }
        
        if let image = image {
            shotImage = UIImage(cgImage: image)
        }
        return shotImage
        
    }
    
    
    ///对指定图片进行拉伸
    func sl_resizableImage(name: String) -> UIImage {
        
        var normal = UIImage(named: name)!
        let imageWidth = normal.size.width * 0.5
        let imageHeight = normal.size.height * 0.5
        normal = resizableImage(withCapInsets: UIEdgeInsets(top: imageHeight, left: imageWidth, bottom: imageHeight, right: imageWidth))
        
        return normal
    }
    
    /**
     *  压缩上传图片到指定字节
     *
     *  image     压缩的图片
     *  maxLength 压缩后最大字节大小
     *
     *  return 压缩后图片的二进制
     */
    func sl_compressImage(image: UIImage, maxLength: Int) -> Data? {
        var data = image.jpegData(compressionQuality: 1.0)
        //检查原图
        if data?.count ?? 0 <= maxLength{
            return data
        }
        
        let newSize = self.sl_scaleImage(image: image, imageLength: 1920)
        let newImage = self.sl_resizeImage(image: image, newSize: newSize)
        
        var compress:CGFloat = 0.9
        data = newImage.jpegData(compressionQuality: compress)
        
        while (data?.count ?? 0) > maxLength && compress > 0.01 {
            compress -= 0.02
            data = newImage.jpegData(compressionQuality: compress)
        }
        
        return data
    }
    
    /**
     *  通过指定图片最长边，获得等比例的图片size
     *
     *  image       原始图片
     *  imageLength 图片允许的最长宽度（高度）
     *
     *  return 获得等比例的size
     */
    func sl_scaleImage(image: UIImage, imageLength: CGFloat) -> CGSize {
        
        var newWidth:CGFloat = 0.0
        var newHeight:CGFloat = 0.0
        let width = image.size.width
        let height = image.size.height
        
        if (width > imageLength || height > imageLength){
            
            if (width > height) {
                
                newWidth = imageLength;
                newHeight = newWidth * height / width;
                
            }else if(height > width){
                
                newHeight = imageLength;
                newWidth = newHeight * width / height;
                
            }else{
                
                newWidth = imageLength;
                newHeight = imageLength;
            }
            
        }
        return CGSize(width: newWidth, height: newHeight)
    }
    
    /**
     *  获得指定size的图片
     *
     *  image   原始图片
     *  newSize 指定的size
     *
     *  return 调整后的图片
     */
    func sl_resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    @discardableResult static func sl_screenSnapshot(save: Bool,view: UIView) -> UIImage {
        // 用下面这行而不是UIGraphicsBeginImageContext()，因为前者支持Retina
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()

        UIGraphicsEndImageContext()
        
        if save { UIImageWriteToSavedPhotosAlbum(image , self, nil, nil) }
        
        return image
    }
}


