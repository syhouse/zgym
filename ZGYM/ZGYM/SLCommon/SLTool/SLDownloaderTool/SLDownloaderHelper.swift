//
//  SLDownloaderHelper.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/5.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import Alamofire


/// 下载资源类型
enum SLDownloaderType: String{
    case audio
}

class SLDownloaderHelper: NSObject {
    static let helper:SLDownloaderHelper = SLDownloaderHelper()
    private override init() {
    }
    
    /// 是否已下载资源
    /// - Parameters:
    ///   - url: 资源地址
    ///   - type: 资源类型
    public func hasDownloadSucess(url: String, type: SLDownloaderType = .audio) -> Bool{
        return FileManager.default.fileExists(atPath: self.downloadPath(url: url, type: type))
    }
    
    
    /// 资源本地下载地址
    /// - Parameters:
    ///   - url: 资源地址
    ///   - type: 资源类型
    public func downloadPath(url: String, type: SLDownloaderType = .audio) -> String{
        return NSUtil.sl_cachePath(file: "\(url.MD5()).mp3", directory: "Download\(type.rawValue)")
    }
    
    
    /// 下载资源 (目前只支持音频)
    /// - Parameters:
    ///   - urlStr: 资源地址
    ///   - type: 资源类型
    public func downloadFile(urlStr: String, type: SLDownloaderType = .audio){
        let destination: DownloadRequest.DownloadFileDestination = {(url, response) in
            
            return (URL.init(fileURLWithPath: NSUtil.sl_cachePath(file: "\(urlStr.MD5()).mp3", directory: "Download\(type.rawValue)")), [.removePreviousFile,.createIntermediateDirectories])
        }
        
        Alamofire.download(urlStr, to: destination).downloadProgress { progress in
            print("Download Progress: \(progress.fractionCompleted)")
        }.validate().responseData { response in

        }
    }
}
