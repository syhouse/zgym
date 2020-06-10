//
//  YXSMediaHelper.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/6.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import Photos
import YBImageBrowser

class YXSMediaHelper: NSObject{
    static let shareHepler: YXSMediaHelper = YXSMediaHelper()
    private override init() {
        self.queue = {
            let operationQueue = OperationQueue()
            operationQueue.maxConcurrentOperationCount = 4
            return operationQueue
        }()
    }
    private let queue: OperationQueue
    
    
    /// 相册资源获取图片
    /// - Parameters:
    ///   - asset: 相册资源
    ///   - resultBlock: 获取到图片后回调
    static func PHAssetToImage(_ asset:PHAsset, resultBlock:((_ image: UIImage) ->())?){
        shareHepler.queue.addOperation {
            let semaphore = DispatchSemaphore(value: 0)
            YBIBPhotoAlbumManager.getImageData(with: asset) { (data) in
                resultBlock?( UIImage.init(data: data ?? Data()) ?? UIImage())
                semaphore.signal()
            }
            semaphore.wait()
        }
    }
}
               
