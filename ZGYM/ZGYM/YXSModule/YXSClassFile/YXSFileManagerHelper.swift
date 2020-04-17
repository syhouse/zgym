//
//  YXSFileManagerHelper.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/3/21.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import MobileCoreServices
/// 开发者账号AppGroup标识
public let suitName = "group.youxuesheng.UMEducation"
/// ShareExtenstion URL Schemes
public let shareExtensionSchemes = "YMSHAREEXTENSION"

class YXSFileManagerHelper: NSObject {
    
    static let sharedInstance: YXSFileManagerHelper = {
        let instance = YXSFileManagerHelper()
        // setup code
        return instance
    }()
    
    
    // MARK: - Tool
    /// 根据文件路径返回文件对象
    @objc func getFileItem(fileUrl: URL) -> YXSFileItemModel {
        let model = YXSFileItemModel()
        model.fileName = fileUrl.lastPathComponent
        model.data = fileUrl2Data(fileUrl: fileUrl)
        model.exteonsion = YXSFileExtension(rawValue: fileUrl.pathExtension)
        model.fileSize = sizeOfDataSrouce(fileUrl: fileUrl)
        return model
    }
    
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
        
        if UInt64(1024.0*1024.0) > fileSize {
            /// 返回kb
            let kb = fileSize/1024
            if kb > 999 {
                return "999KB"
            } else {
                return "\(kb)KB"
            }
            
        } else {
            /// 返回MB
            return "\(fileSize/1024/1024)MB"
        }
    }
    
    /// 根据文件路径返回文件大小(MB)
    @objc func sizeOfDataSrouce(fileUrl: URL) -> CGFloat {

        var fileSize : UInt64 = 0
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: fileUrl.path)
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
    
    @objc func sizeOfDataSrouce(data: Data) -> CGFloat {

        var fileSize : UInt64 = 0
    
        fileSize = UInt64(data.count)//attr[FileAttributeKey.size] as! UInt64

        let mb = CGFloat(fileSize)/(1024.0*1024.0)
            
        print(">>>>fileSize:\(fileSize)")
        return CGFloat(mb)
    }
    
    
    
    /// 根据文件路径返回相对应的图标
    @objc func getIconWithFileUrl(_ fileUrl: URL) -> UIImage {
        let img = UIImage()
        
        let fileEx = fileUrl.pathExtension
        switch fileEx {
            /// 办公
            case "pptx":
                return UIImage(named: "yxs_file_ppt")!
            case "docx":
                return UIImage(named: "yxs_file_word")!
            case "xlsx":
                return UIImage(named: "yxs_file_excel")!
            case "pdf":
                return UIImage(named: "yxs_file_pdf")!
            
            /// 图片
            case "jpg":
            return img
            
            /// 音频
            case "m4a","mp3","wav","ogg","m4r","acc":
            return img
            
            /// 视频
            case "mp4","MP4","mov":
            return img
        default:
            return img
        }
    }
    
    ///
    @objc func getFileIcon(itemProvider: NSItemProvider) -> UIImage {
        let img = UIImage()
        if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePDF as String) {
            /// PDF
            
        } else if itemProvider.hasItemConformingToTypeIdentifier("org.openxmlformats.wordprocessingml.document") {
            /// Word
            
        } else if itemProvider.hasItemConformingToTypeIdentifier("org.openxmlformats.spreadsheetml.sheet") {
            /// Excel
            
        } else if itemProvider.hasItemConformingToTypeIdentifier("org.openxmlformats.presentationml.presentation") {
            /// PPT
            
        } else if itemProvider.hasItemConformingToTypeIdentifier("com.apple.m4a-audio") {
            /// 苹果系统录音
            
        } else if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeMP3 as String) {
            /// mp3
        }
        
        return img
    }
    
    // MARK: - Converter
    /// URL2Data
    @objc func fileUrl2Data(fileUrl: URL) -> Data?{
        do {
            let data = try Data(contentsOf: fileUrl)
            return data
            
        } catch {
            
        }
        return nil
    }
    
    /// 根据文件路径返回图片
    @objc func fileUrl2Image(fileUrl: URL) -> UIImage? {
        if let data = fileUrl2Data(fileUrl: fileUrl) {
            return UIImage(data: data)
        }
        return nil
    }
}
