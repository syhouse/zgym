//
//  YXSCompressionImageHelper.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/6.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit

class YXSCompressionImageHelper: NSObject{
    static let shareHepler: YXSCompressionImageHelper = YXSCompressionImageHelper()
    private override init() {
        self.queue = {
            let operationQueue = OperationQueue()
            operationQueue.maxConcurrentOperationCount = 3
            return operationQueue
        }()
    }
    private let queue: OperationQueue
    
    
    /**
     *  压缩上传图片到指定字节
     *
     *  image     压缩的图片
     *  maxLength 压缩后最大字节大小(byte)
     *
     *  return 压缩后图片的二进制
     */
    static func yxs_compressImage(image: UIImage, maxLength: Int) -> Data? {
        var data: Data?
        let semaphore = DispatchSemaphore(value: 0)
        shareHepler.queue.addOperation {
            data = image.jpegData(compressionQuality: 1.0)
            //检查原图
            if data?.count ?? 0 > maxLength{
                let newSize = UIImage().yxs_scaleImage(image: image, imageLength: 1920)
                let newImage = UIImage().yxs_resizeImage(image: image, newSize: newSize)
                
                var compress:CGFloat = 0.9
                data = newImage.jpegData(compressionQuality: compress)
                
                while (data?.count ?? 0) > maxLength && compress > 0.01 {
                    compress -= 0.04
                    data = image.jpegData(compressionQuality: compress)
                }
            }
            semaphore.signal()
        }
        semaphore.wait()
        return data
    }
    //
    //    static func yxs_compressImage(image: UIImage, maxLength: Int) -> Data? {
    //        let semaphore = DispatchSemaphore(value: 0)
    //        var imageData: Data?
    //        shareHepler.queue.addOperation {
    //            imageData = image.jpegData(compressionQuality: 1.0)
    //            if var data = imageData, data.count > maxLength{
    //                var compression:CGFloat = 1
    //                var max: CGFloat = 1
    //                var min: CGFloat = 0
    //                for _ in 0..<6 {
    //                    compression = (max + min) / 2
    //                    data = image.jpegData(compressionQuality: compression) ?? Data()
    //                    if data.count < maxLength * Int(0.9) {
    //                        min = compression
    //                    } else if data.count > maxLength {
    //                        max = compression
    //                    } else {
    //                        break
    //                    }
    //                }
    //                if var resultImage = UIImage(data: data){
    //                    // Compress by size
    //                    var lastDataLength = 0
    //                    while data.count > maxLength && data.count != lastDataLength {
    //                        lastDataLength = data.count
    //                        let ratio = Float(maxLength)/Float(data.count)
    //                        //NSLog(@"Ratio = %.1f", ratio);
    //                        let size = CGSize(
    //                            width: CGFloat(Int(resultImage.size.width * CGFloat(sqrtf(ratio)))),
    //                            height: CGFloat(Int(resultImage.size.height * CGFloat(sqrtf(ratio))))) // Use NSUInteger to prevent white blank
    //                        UIGraphicsBeginImageContext(size)
    //                        resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    //                        resultImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    //                        UIGraphicsEndImageContext()
    //                        data = resultImage.jpegData(compressionQuality: compression) ?? Data()
    //                    }
    //                    imageData = data
    //                }
    //            }
    //            semaphore.signal()
    //        }
    //        semaphore.wait()
    //        return imageData
    //
    //    }
    //
}

