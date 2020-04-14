//
//  YXSDownloaderHelper.swift
//  HNYMEducation
//
//  Created by sy_mac on 2020/3/5.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import Alamofire


/// 下载资源类型
enum YXSDownloaderType: String{
    case audio
}

class YXSDownloaderHelper: NSObject {
    static let helper:YXSDownloaderHelper = YXSDownloaderHelper()
    private override init() {
    }
    
    /// 是否已下载资源
    /// - Parameters:
    ///   - url: 资源地址
    ///   - type: 资源类型
    public func hasDownloadSucess(url: String, type: YXSDownloaderType = .audio) -> Bool{
        return FileManager.default.fileExists(atPath: self.downloadPath(url: url, type: type))
    }
    
    
    /// 资源本地下载地址
    /// - Parameters:
    ///   - url: 资源地址
    ///   - type: 资源类型
    public func downloadPath(url: String, type: YXSDownloaderType = .audio) -> String{
        return NSUtil.yxs_cachePath(file: "\(url.MD5()).mp3", directory: "Download\(type.rawValue)")
    }
    
    
    /// 下载资源 (目前只支持音频)
    /// - Parameters:
    ///   - urlStr: 资源地址
    ///   - type: 资源类型
    public func downloadFile(urlStr: String, type: YXSDownloaderType = .audio){
        let destination: DownloadRequest.DownloadFileDestination = {(url, response) in
            
            return (URL.init(fileURLWithPath: NSUtil.yxs_cachePath(file: "\(urlStr.MD5()).mp3", directory: "Download\(type.rawValue)")), [.removePreviousFile,.createIntermediateDirectories])
        }
        
        Alamofire.download(urlStr, to: destination).downloadProgress { progress in
            print("Download Progress: \(progress.fractionCompleted)")
        }.validate().responseData { response in

        }
    }
}
