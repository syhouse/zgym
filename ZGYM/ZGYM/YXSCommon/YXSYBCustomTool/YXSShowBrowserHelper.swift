//
//  YXSShowBrowserHelper.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/7.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import YBImageBrowser

/// 展示图片 视频  处理状态栏显示隐藏
class YXSShowBrowserHelper: NSObject, YBImageBrowserDelegate{
    static let helper: YXSShowBrowserHelper = YXSShowBrowserHelper()
    private override init(){}
    
    /// 展示图片资源
    /// - Parameters:
    ///   - urls: 服务器地址
    ///   - images: UIImage
    ///   - assets: 相册assets
    ///   - canRotation: 是否可以旋转视图  默认不支持旋转
    ///   - currentIndex: 当前index
    static func showImage(urls: [URL]? = nil, images: [UIImage?]? = nil, assets: [PHAsset]? = nil, canRotation: Bool = false, currentIndex: Int?){
        let browser = YBImageBrowser()
        
        let dataClass = canRotation ? YXSYBRotationData.self : YBIBImageData.self
        if let urls = urls{
            for url in urls{
                let imgData = dataClass.init()
                imgData.imageURL = url
                browser.dataSourceArray.append(imgData)
            }
            
        }
        
        if let images = images{
            for image in images{
                let imgData = dataClass.init()
                imgData.image = {return image}
                browser.dataSourceArray.append(imgData)
            }
            
        }
        
        if let assets = assets{
            for asset in assets{
                let imgData = dataClass.init()
                imgData.imagePHAsset = asset
                browser.dataSourceArray.append(imgData)
            }
            
        }
        
        
        if let currentIndex = currentIndex{
            browser.currentPage = currentIndex
        }
        browser.delegate = YXSShowBrowserHelper.helper
        browser.toolViewHandlers.append(YXSYBRotationToolViewHandler())
        browser.show()
    }
    
    
    /// 展示相册视频资源
    /// - Parameter assets: assets
    static func yxs_VedioBrowser(assets: PHAsset?, delegate: YBImageBrowserDelegate? = nil){
        yxs_VedioBrowser(asset: assets,videoURL: nil, delegate: delegate)
    }
    /// 展示本地路径资源
    /// - Parameter assets: assets
    static func yxs_VedioBrowser(videoURL: URL?, delegate: YBImageBrowserDelegate? = nil){
       yxs_VedioBrowser(asset: nil, videoURL: videoURL, delegate: delegate)
    }
    
    private static func yxs_VedioBrowser(asset: PHAsset?, videoURL: URL?, delegate: YBImageBrowserDelegate? = nil){
        let browser = YBImageBrowser()
        let videoData = YBIBVideoData()
        
        if let asset = asset{
            videoData.videoPHAsset = asset
        }
        
        if let videoURL = videoURL{
            videoData.videoURL = videoURL
        }
        
        videoData.autoPlayCount = 1
        browser.dataSourceArray.append(videoData)
        browser.delegate = delegate == nil ? YXSShowBrowserHelper.helper : delegate
        browser.show()
    }
    
    // MARK: - YBImageBrowserDelegate
    func yb_imageBrowser(_ imageBrowser: YBImageBrowser, beginTransitioningWithIsShow isShow: Bool) {
        UIApplication.shared.setStatusBarHidden(isShow, with: UIStatusBarAnimation.none)
        if isShow{
            YXSPlayerMediaSingleControlTool.share.pausePlayer()
        }else{
            YXSPlayerMediaSingleControlTool.share.resumePlayer()
        }
    }
}

