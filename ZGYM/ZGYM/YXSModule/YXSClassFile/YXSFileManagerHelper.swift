//
//  YXSFileManagerHelper.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/3/21.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos

/// 开发者账号AppGroup标识
public let suitName = "group.com.youxueye.HNUMEducation.Share"
/// ShareExtenstion URL Schemes
public let shareExtensionSchemes = "YXSSHAREEXTENSION"

class YXSFileManagerHelper: NSObject {
    
    static let sharedInstance: YXSFileManagerHelper = {
        let instance = YXSFileManagerHelper()
        // setup code
        return instance
    }()
    
    
    // MARK: - Tool
    /**
     * 获得Documents路径
     * NSSearchPathDirectory.DocumentDirectory 查找Documents文件夹
     * NSSearchPathDomainMask.UserDomainMask 在用户的应用程序下查找
     * true 展开路径   false 当前应用的根路径 == “~”
    */
    @objc func getDocumentURL() -> URL {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        return URL(fileURLWithPath: docPath)
    }
    
    /// 根据文件名获取Document全路径
    @objc func getDocumentFullPathURL(lastPathComponent: String) -> URL {
        let fullPath = getDocumentURL().appendingPathComponent(lastPathComponent)
        return fullPath
    }
    
    
    /// AppGroup沙盒路径
    @objc func getContainerURL() -> URL {
        let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: suitName)
        return sharedContainer!
    }
    
    /// 根据文件名获取AppGroup全路径
    @objc func getFullPathURL(lastPathComponent: String) -> URL {
        let fullPath = getContainerURL().appendingPathComponent(lastPathComponent)
        return fullPath
    }
    
    /// 根据Data大小匹配返回 kb/mb 为单位的文件大小
    @objc func stringSizeOfDataSrouce(data: Data) -> String {
        var fileSize : UInt64 = 0
    
        fileSize = UInt64(data.count)//attr[FileAttributeKey.size] as! UInt64
        fileSize = fileSize/1024
        return stringSizeOfDataSrouce(fileSize: fileSize)
    }
    
    /// 参数:fileSize(KB)
    @objc func stringSizeOfDataSrouce(fileSize: UInt64) -> String {
        
        if 1024 > fileSize {
            /// 返回kb
            let kb = fileSize
            if kb > 999 {
                return "999KB"
            } else {
                return "\(kb)KB"
            }
            
        } else {
            /// 返回MB
            let mb = CGFloat(fileSize)/1024.0
            return String(format: "%.02fMB", mb)
        }
    }
    
    /// 根据文件路径返回文件大小(MB)
    @objc func sizeMbOfFilePath(filePath: URL) -> CGFloat {

        var fileSize : UInt64 = 0
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: filePath.path)
            fileSize = attr[FileAttributeKey.size] as! UInt64

            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
            let mb = CGFloat(fileSize)/(1024.0*1024.0)
            
            print(">>>>fileSize:\(fileSize)")
            return CGFloat(mb)
            
        } catch {
            print("Error: \(error)")
        }
        return 0
    }
    
    /// 根据数据Data返回文件大小(MB)
    @objc func sizeMbOfDataSrouce(data: Data) -> CGFloat {

        var fileSize : UInt64 = 0
    
        fileSize = UInt64(data.count)

        let mb = CGFloat(fileSize)/(1024.0*1024.0)
            
        print(">>>>fileSize:\(fileSize)")
        return CGFloat(mb)
    }
    
    /// 根据数据Data返回文件大小(KB)
    @objc func sizeKbOfDataSrouce(data: Data) -> CGFloat {

        var fileSize : UInt64 = 0
    
        fileSize = UInt64(data.count)

        let mb = CGFloat(fileSize)/1024.0
            
        print(">>>>fileSize:\(fileSize)")
        return CGFloat(mb)
    }
    
    
    /// 根据文件本地路径返回相对应的图标 注意:返回空的处理
    @objc func getIconWithFileUrl(_ fileUrl: URL) -> UIImage? {
        let img = UIImage(named: "defultImage")
        
        let fileEx = fileUrl.pathExtension.lowercased()
        switch fileEx {
            /// 办公
            case "pptx":
                return UIImage(named: "yxs_file_ppt") ?? img
            case "docx","doc":
                return UIImage(named: "yxs_file_word") ?? img
            case "xlsx", "xls":
                return UIImage(named: "yxs_file_excel") ?? img
            case "pdf":
                return UIImage(named: "yxs_file_pdf") ?? img
            case "txt":
                return UIImage(named: "yxs_file_txt") ?? img
            /// 图片
            case "jpg","png":
            return nil
            /// 音频
            case "m4a","mp3","wav","ogg","m4r","acc":
            return UIImage(named: "yxs_file_mp3") ?? img
            /// 视频
            case "mp4","MP4","mov":
                return getVideoFirstPicture(url: fileUrl)
        default:
            return img
        }
    }
    
    // MARK: - 获取视频第一帧
    @objc func getVideoFirstPicture(asset: AVAsset)-> UIImage? {
        let gen = AVAssetImageGenerator(asset: asset)
        gen.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 1)
        var actualTime : CMTime = CMTimeMakeWithSeconds(0, preferredTimescale: 0)
        if let image = try? gen.copyCGImage(at: time, actualTime: &actualTime) {
            let img: UIImage = UIImage.init(cgImage: image)
            return img
        }
        return nil
    }
    
    @objc func getVideoFirstPicture(url: URL)-> UIImage? {
        let asset = AVURLAsset(url: url)
        return getVideoFirstPicture(asset: asset)
    }
    
    // MARK: - Converter
}
