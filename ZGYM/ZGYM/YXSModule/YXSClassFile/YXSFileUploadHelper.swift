//
//  YXSFileUploadHelper.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/17.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import AliyunOSSiOS
import SwiftyJSON
import ObjectMapper
import Photos

/// 存储类型
enum YXSStorageType: String {
    /// 临时
    case temporary
    /// 班级相册
    case album
    /// 班级文件
    case classFile
    /// 书包
    case satchel
    /// 班级圈
    case circle
    /// 头像
    case avatar
    /// 班级之星
    case star
    /// 课表
    case curriculum
}


/// 上传文件到阿里云的工具
class YXSFileUploadHelper: NSObject {
    //现在一次请求 生成一个token
    private var ossClient: OSSClient?
    private var oSSAuth: YXSOSSAuthModel?
    
    static let sharedInstance: YXSFileUploadHelper = {
        let instance = YXSFileUploadHelper()
        // setup code
        return instance
    }()
    
    // MARK: - Request
    @objc func requestYXSOSSAuth(completionHandler:(((_ model: YXSOSSAuthModel)->())?), failureHandler: ((String, String) -> ())?) {
        YXSEducationOssAuthTokenRequest().request({ [weak self](result: YXSOSSAuthModel) in
            guard let weakSelf = self else {return}
            
            weakSelf.oSSAuth = result
            
            ///conf
            let conf = OSSClientConfiguration()
            conf.maxRetryCount = 2
            conf.timeoutIntervalForRequest = 300
            conf.timeoutIntervalForResource = TimeInterval(24 * 60 * 60)
            conf.maxConcurrentRequestCount = 50
            
            // 实例化client
            let credential: OSSCredentialProvider = OSSStsTokenCredentialProvider.init(accessKeyId: weakSelf.oSSAuth?.accessKeyId ?? "", secretKeyId: weakSelf.oSSAuth?.accessKeySecret ?? "", securityToken: weakSelf.oSSAuth?.securityToken ?? "")
            
            weakSelf.ossClient = OSSClient(endpoint: weakSelf.oSSAuth?.endpoint ?? "", credentialProvider: credential, clientConfiguration: conf)
            
            completionHandler?(result)
            
        }, failureHandler: failureHandler)
    }

    // MARK: - Method 上传文件方法
    /**
     *  注意！
     *  当storageType 为 classFile时 classId必填；
     *  当storageType 为 album时 classId、albumId必填
     */
    func uploadDataSource(dataSource: [YXSUploadDataResourceModel], storageType: YXSStorageType, classId: Int? = nil, albumId: Int? = nil, progress : ((_ progress: CGFloat)->())?, sucess: (([YXSFileModel])->())?, failureHandler: ((String, String) -> ())?) {

        var resultArr = [YXSFileModel]()
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        
        for sub in dataSource {
            
            /// 文件名
            let fileName = sub.fileName?.deletingPathExtension
            /// 文件后缀名
            let extName = sub.fileName?.pathExtension.lowercased()
            /// 文件名(带后缀)
            let fullName = "\(fileName ?? "").\(extName ?? "")"
            
            let model = YXSFileModel(JSON: ["":""])
            var path: String = ""
            
            if extName == "mp4" || extName == "mov" {
                /// 拼接路径
                switch storageType {
                case .temporary:
                    path = self.getTmpVideoUrl(fullName: fullName)
                    
                case .album:
                    if classId == nil {
                        failureHandler?("album没有班级ID", "400")
                        return
                    }
                    
                    if albumId == nil {
                        failureHandler?("album没有相册ID", "400")
                        return
                    }
                    path = self.getAlbumUrl(fullName: fullName, classId: classId ?? 0, albumId: albumId ?? 0)
                    
                case .classFile:
                    if classId == nil {
                        failureHandler?("classFile没有班级ID", "400")
                        return
                    }
                    path = self.getClassFileUrl(fullName: fullName, classId: classId ?? 0)
                    
                case .satchel:
                    path = self.getSatchelUrl(fullName: fullName)
                    
                case .circle:
                    path = self.getCircleUrl(fullName: fullName)

                default:
                    path = self.getAvatarUrl(fullName: fullName)
                }
                
                group.enter()
                queue.async { [weak self] in
                    guard let weakSelf = self else {return}
                    /// 传视频数据
                    weakSelf.aliyunOSSUpload(objectKey: path, uploadingData: sub.dataSource, uploadProgress: nil, completionHandler: { (result) in
                        model?.fileUrl = result
                        model?.fileName = fullName
                        model?.fileSize = Int( YXSFileManagerHelper.sharedInstance.sizeKbOfDataSrouce(data: sub.dataSource!))
                        model?.fileType = extName
                        resultArr.append(model!)
                        group.leave()
                        
                    }, failureHandler: failureHandler)
                }
                
                group.enter()
                queue.async { [weak self] in
                    guard let weakSelf = self else {return}
                    
                    ///获取视频第一帧
                    do {
                        /// 重新拼接路径
                        let tmp = path.deletingPathExtension
                        path = "\(tmp)_1.jpg"
                        
                        let imgData = sub.bgImage?.jpegData(compressionQuality: 1)
                        /// 传视频首图
                        weakSelf.aliyunOSSUpload(objectKey: path, uploadingData: imgData, uploadProgress: nil, completionHandler: { (result) in
                            model?.bgUrl = result
                            group.leave()
                            
                        }, failureHandler: failureHandler)
                        
                    } catch  {
                        print("错误")
                    }
                }
                
            } else if extName == "jpg" || extName == "png" || extName == "gif"{
                
                /// 拼接路径
                switch storageType {
                case .temporary:
                    path = self.getTmpImgUrl(fullName: fullName)
                    
                case .album:
                    if classId == nil {
                        failureHandler?("album没有班级ID", "400")
                        return
                    }
                    
                    if albumId == nil {
                        failureHandler?("album没有相册ID", "400")
                        return
                    }
                    path = self.getAlbumUrl(fullName: fullName, classId: classId ?? 0, albumId: albumId ?? 0)
                    
                case .classFile:
                    if classId == nil {
                        failureHandler?("classFile没有班级ID", "400")
                        return
                    }
                    path = self.getClassFileUrl(fullName: fullName, classId: classId ?? 0)
                    
                case .satchel:
                    path = self.getSatchelUrl(fullName: fullName)
                    
                case .circle:
                    path = self.getCircleUrl(fullName: fullName)

                default:
                    path = self.getAvatarUrl(fullName: fullName)
                }
                
                /// 直接上传
                group.enter()
                queue.async { [weak self] in
                    guard let weakSelf = self else {return}
                    
                    weakSelf.aliyunOSSUpload(objectKey: path, uploadingData: sub.dataSource, uploadProgress: nil, completionHandler: { (result) in
                        model?.fileUrl = result
                        model?.fileName = fullName
                        model?.fileSize = Int( YXSFileManagerHelper.sharedInstance.sizeKbOfDataSrouce(data: sub.dataSource!))
                        model?.fileType = extName
                        resultArr.append(model!)
                        group.leave()
                        
                    }, failureHandler: failureHandler)
                }
            } else if extName == "m4a" || extName == "mp3" || extName == "wav" || extName == "ogg" || extName == "m4r" || extName == "acc" {
                /// 拼接路径
                switch storageType {
                case .temporary:
                    path = self.getTmpVoiceUrl(fullName: fullName)
                    
                case .album:
                    if classId == nil {
                        failureHandler?("album没有班级ID", "400")
                        return
                    }
                    
                    if albumId == nil {
                        failureHandler?("album没有相册ID", "400")
                        return
                    }
                    path = self.getAlbumUrl(fullName: fullName, classId: classId ?? 0, albumId: albumId ?? 0)
                    
                case .classFile:
                    if classId == nil {
                        failureHandler?("classFile没有班级ID", "400")
                        return
                    }
                    path = self.getClassFileUrl(fullName: fullName, classId: classId ?? 0)
                    
                case .satchel:
                    path = self.getSatchelUrl(fullName: fullName)
                    
                case .circle:
                    path = self.getCircleUrl(fullName: fullName)

                default:
                    path = self.getAvatarUrl(fullName: fullName)
                }
                
                /// 直接上传
                group.enter()
                queue.async { [weak self] in
                    guard let weakSelf = self else {return}
                    
                    weakSelf.aliyunOSSUpload(objectKey: path, uploadingData: sub.dataSource, uploadProgress: nil, completionHandler: { (result) in
                        model?.fileUrl = result
                        model?.fileName = fullName
                        model?.fileSize = Int( YXSFileManagerHelper.sharedInstance.sizeKbOfDataSrouce(data: sub.dataSource!))
                        model?.fileType = extName
                        resultArr.append(model!)
                        group.leave()
                        
                    }, failureHandler: failureHandler)
                }
                
            } else {
                /// 拼接路径
                switch storageType {
                case .temporary:
                    failureHandler?("存放路径不支持", "400")
                    return
                    
                case .album:
                    if classId == nil {
                        failureHandler?("album没有班级ID", "400")
                        return
                    }
                    
                    if albumId == nil {
                        failureHandler?("album没有相册ID", "400")
                        return
                    }
                    path = self.getAlbumUrl(fullName: fullName, classId: classId ?? 0, albumId: albumId ?? 0)
                    
                case .classFile:
                    if classId == nil {
                        failureHandler?("classFile没有班级ID", "400")
                        return
                    }
                    path = self.getClassFileUrl(fullName: fullName, classId: classId ?? 0)
                    
                case .satchel:
                    path = self.getSatchelUrl(fullName: fullName)
                    
                case .circle:
                    path = self.getCircleUrl(fullName: fullName)

                default:
                    path = self.getAvatarUrl(fullName: fullName)
                }
                
                /// 直接上传
                group.enter()
                queue.async { [weak self] in
                    guard let weakSelf = self else {return}
                    
                    weakSelf.aliyunOSSUpload(objectKey: path, uploadingData: sub.dataSource, uploadProgress: nil, completionHandler: { (result) in
                        model?.fileUrl = result
                        model?.fileName = fullName
                        model?.fileSize = Int( YXSFileManagerHelper.sharedInstance.sizeKbOfDataSrouce(data: sub.dataSource!))
                        model?.fileType = extName
                        resultArr.append(model!)
                        group.leave()
                        
                    }, failureHandler: failureHandler)
                }
            }
        }
        
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                sucess?(resultArr)
            }
        }
    }
    
    /**
     *  注意！
     *  当storageType 为 classFile时 classId必填；
     *  当storageType 为 album时 classId、albumId必填
     */
    func uploadPHAssetDataSource(mediaAssets:[PHAsset],storageType: YXSStorageType, classId: Int? = nil, albumId: Int? = nil, progress : ((_ progress: CGFloat)->())?, sucess:(([YXSFileModel])->())?,failureHandler: ((String, String) -> ())?) {
        
        var dataSource: [YXSUploadDataResourceModel] = [YXSUploadDataResourceModel]()
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        
        for asset in mediaAssets {
            let model = YXSUploadDataResourceModel()
            if asset.mediaType == .image {
                let tmpName = (asset.value(forKey: "filename") as? String ?? "")
                let fileName = tmpName.deletingPathExtension
                let extName = "jpg"//tmpName.pathExtension.lowercased()
                let fullName = "\(fileName).\(extName)"
                
                group.enter()
                queue.async {
                    PHImageManager.default().requestImageData(for: asset, options: nil) { (imageData, dataUTI, orientation, info) in
                        model.dataSource = imageData
                        model.fileName = fullName
                        dataSource.append(model)
                        group.leave()
                    }
                }

                
            } else if asset.mediaType == .video {
                group.enter()
                queue.async {
                    PHCachingImageManager.default().requestAVAsset(forVideo: asset, options: nil) { (asset, audioMix, info) in
                       
                        let asset = asset as? AVURLAsset

                        if let url = asset?.url {
                            /// 视频数据
                            let tmpName = asset?.url.lastPathComponent
                            let fileName = tmpName?.deletingPathExtension
                            let extName = tmpName?.pathExtension.lowercased()
                            let fullName = "\(fileName ?? "").\(extName ?? "")"
                            
                            let data = try? Data(contentsOf: url)
                            model.dataSource = data
                            model.fileName = fullName
                            let img = self.getVideoFirstPicture(asset: asset!)
                            model.bgImage = img
                            dataSource.append(model)
                            group.leave()
                        }
                    }
                }
            } else if asset.mediaType == .audio {
                
            }
        }
        
        group.notify(queue: queue) { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.uploadDataSource(dataSource: dataSource, storageType: storageType, classId: classId, albumId: albumId, progress: progress, sucess: sucess, failureHandler: failureHandler)
        }
    }
    
    // MARK: - Base
    // uploadProgress: 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
    func aliyunOSSUpload(objectKey: String, uploadingFileURL: URL? = nil, uploadingData: Data? = nil, uploadProgress: OSSNetworkingUploadProgressBlock?, completionHandler:(((_ resultUrl: String)->())?), failureHandler:((String, String) -> ())?) {
        if uploadingFileURL == nil && uploadingData == nil {
            /// 上传数据源出错
            failureHandler?("上传数据源出错", "400")
            return
        }
        
        ///判断tokenModel是否过期
        if let oSSAuth = oSSAuth{
            if oSSAuth.expirationDate.timeIntervalSince1970 <= Date().timeIntervalSince1970{
                self.oSSAuth = nil
            }
        }
        
        if oSSAuth == nil {
            requestYXSOSSAuth(completionHandler: { [weak self](model) in
                guard let weakSelf = self else {return}
                
                weakSelf.aliyunOSSUpload(objectKey: objectKey, uploadingFileURL: uploadingFileURL, uploadingData: uploadingData, uploadProgress: uploadProgress, completionHandler: completionHandler, failureHandler: failureHandler)
                
            }, failureHandler:{ (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
                failureHandler?(msg, code)
            })
            
            return
        }
        
        let put = OSSPutObjectRequest()
        // 必填字段
        put.bucketName = oSSAuth?.bucket
        put.objectKey = objectKey;
        put.uploadProgress = uploadProgress
        if uploadingData != nil {
            put.uploadingData = uploadingData
            
        } else {
            put.uploadingFileURL = uploadingFileURL
        }
        
        // 以下可选字段的含义参考： https://docs.aliyun.com/#/pub/oss/api-reference/object&PutObject
        // put.contentType = @"";
        // put.contentMd5 = @"";
        // put.contentEncoding = @"";
        // put.contentDisposition = @"";
        // put.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil]; // 可以在上传时设置元信息或者其他HTTP头部
        
//        ///conf
//        let conf = OSSClientConfiguration()
//        conf.maxRetryCount = 2
//        conf.timeoutIntervalForRequest = 300
//        conf.timeoutIntervalForResource = TimeInterval(24 * 60 * 60)
//        conf.maxConcurrentRequestCount = 50
        
//        // 实例化client
//        let credential: OSSCredentialProvider = OSSStsTokenCredentialProvider.init(accessKeyId: oSSAuth?.accessKeyId ?? "", secretKeyId: oSSAuth?.accessKeySecret ?? "", securityToken: oSSAuth?.securityToken ?? "")
//        ossClient = OSSClient(endpoint: oSSAuth?.endpoint ?? "", credentialProvider: credential, clientConfiguration: conf)
        
        /// Task
        if let putTask = ossClient?.putObject(put) {
            putTask.continue({ [weak self](task) -> Any? in
                guard let weakSelf = self else {return nil}
                
                if task.error == nil {
                    SLLog("upload object success!")
                    if  let _:OSSPutObjectResult  = task.result as? OSSPutObjectResult {
                        var point: NSString = (weakSelf.oSSAuth?.endpoint ?? "") as NSString
                        point = point.replacingOccurrences(of: "http://", with: "") as NSString
                        point = point.replacingOccurrences(of: "https://", with: "") as NSString
                        let strUrl = "http://\(weakSelf.oSSAuth?.bucket ?? "").\(point)/\(objectKey)"
                        completionHandler?(strUrl)
                        
                    } else {
                        /// "链接拼接失败"
                        failureHandler?("链接拼接失败", "400")
                    }

                } else {
                    SLLog("upload object failed, error:\(task.error)")
                    failureHandler?(task.error?.localizedDescription ?? "", "400")
                }
                return nil
            })
        }
    }
    
    
    // MARK: - Tool
    /// 获取视频第一帧
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
    
    
    
    @objc func video2Mp4(url: URL, completion:((_ data:Data, _ newPath:URL?)->())?) {
        
        let avAsset = AVURLAsset.init(url: url, options: nil)
        let tracks:NSArray = avAsset.tracks(withMediaType: AVMediaType.video) as NSArray

        let fileName = url.lastPathComponent.deletingPathExtension
        let destinationPath = NSTemporaryDirectory() + "\(fileName).mp4"
        let newVideoPath: NSURL = NSURL(fileURLWithPath: destinationPath as String)
        let exporter = AVAssetExportSession(asset: avAsset,
                                                    presetName:AVAssetExportPresetHighestQuality)!
        exporter.outputURL = newVideoPath as URL
        exporter.outputFileType = AVFileType.mp4
        exporter.shouldOptimizeForNetworkUse = true
        exporter.exportAsynchronously(completionHandler: {
            
            switch exporter.status{
                case .failed:
                    print("失败...\(String(describing: exporter.error?.localizedDescription))")
                    completion?(Data(), nil)
                    break
                case .cancelled:
                    print("取消")
                    completion?(Data(), nil)
                    break;
                case .completed:
                    print("转码成功")
                    do {
                        let data = try Data.init(contentsOf: newVideoPath as URL, options: Data.ReadingOptions.init())
                        let size = CGFloat(NSData.init(contentsOf: newVideoPath as URL)?.length ?? 0 )
                        print("视频时长\(size)")
                        
                        try? FileManager.default.removeItem(atPath: newVideoPath.path ?? "")
                        completion?(data, newVideoPath as URL)
                        
                    } catch let error {
                        print("失败 \(error)")
                        
                        try? FileManager.default.removeItem(atPath: newVideoPath.path ?? "")
                        completion?(Data(), nil)
                    }
                    
                    break;
                    
                default:
                    print("..")
                    completion?(Data(), nil)
                    break;
            }
        })
    }
    
    // MARK: - GetUrl
    /// 临时图片
    let isTest = sericeType == ServiceType.ServiceTest
    @objc func getTmpImgUrl(fullName: String)-> String{
        let name = fullName.deletingPathExtension
        let extName = fullName.pathExtension.lowercased()
        #if isTest
        return "test-env/img/ios/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(name).\(extName)"
        #else
        return "product-env/img/ios/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(name).\(extName)"
        #endif
    }
    
    /// 临时语音
    @objc func getTmpVoiceUrl(fullName: String)-> String{
        let name = fullName.deletingPathExtension
        let extName = fullName.pathExtension.lowercased()
        #if isTest
        return "test-env/voice/ios/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(name).\(extName)"
        #else
        return "product-env/voice/ios/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(name).\(extName)"
        #endif
        

    }
    
    /// 临时视频
    @objc func getTmpVideoUrl(fullName: String)-> String{
        let name = fullName.deletingPathExtension
        let extName = fullName.pathExtension.lowercased()
        #if isTest
        return "test-env/video/ios/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(name).\(extName)"
        #else
        return "product-env/video/ios/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(name).\(extName)"
        #endif
    }
    
    /// 相册文件
    @objc func getAlbumUrl(fullName: String, classId: Int, albumId: Int)-> String {
        let name = fullName.deletingPathExtension
        let extName = fullName.pathExtension.lowercased()
        #if isTest
        return "test-env/album/ios/\(classId)/\(albumId)/\(name).\(extName)"
        #else
        return "product-env/album/ios/\(classId)/\(albumId)/\(name).\(extName)"
        #endif
    }
    
    /// 班级文件
    @objc func getClassFileUrl(fullName:String, classId: Int)-> String {
        let name = fullName.deletingPathExtension
        let extName = fullName.pathExtension.lowercased()
        #if isTest
        return "test-env/class-file/ios/\(classId)/\(name).\(extName)"
        #else
        return "product-env/class-file/ios/\(classId)/\(name).\(extName)"
        #endif
    }
    
    /// 个人文件(书包)
    @objc func getSatchelUrl(fullName:String)-> String {
        let name = fullName.deletingPathExtension
        let extName = fullName.pathExtension.lowercased()
        #if isTest
        return "test-env/satchel/ios/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(name).\(extName)"
        #else
        return "product-env/satchel/ios/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(name).\(extName)"
        #endif
    }
    
    /// 优成长
    @objc func getCircleUrl(fullName:String)-> String {
        let name = fullName.deletingPathExtension
        let extName = fullName.pathExtension.lowercased()
        #if isTest
        return "test-env/class-circle/ios/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(name).\(extName)"
        #else
        return "product-env/class-circle/ios/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(name).\(extName)"
        #endif
    }
    
    /// 头像
    @objc func getAvatarUrl(fullName:String)-> String {
        let name = fullName.deletingPathExtension
        let extName = fullName.pathExtension.lowercased()
        #if isTest
        return "test-env/avatar/ios/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(name).\(extName)"
        #else
        return "product-env/avatar/ios/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(name).\(extName)"
        #endif
    }
    
//
//    /// 临时声音
//    @objc func getVoiceUrl(fullName: String)-> String {
//        let arr = name.components(separatedBy: ".")
//        if arr.count > 1 {
//            let strUrl = "voice/ios/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(name)"
//            return strUrl
//
//        } else {
//            let strUrl = "voice/ios/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(name).mp3"
//            return strUrl
//        }
//    }
//
//    /// 临时视频
//    @objc func getVideoUrl(name: String)-> String {
//        let arr = name.components(separatedBy: ".")
//        if arr.count > 1 {
//
//            let strUrl = "video/ios/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(name)"
//            return strUrl
//
//        } else {
//            let strUrl = "video/ios/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(name).mp4"
//            return strUrl
//        }
//    }
    
//    @objc func getAlbumImageUrl(name: String, classId: Int, albumId: Int)-> String{
//        let arr = name.components(separatedBy: ".")
//        if arr.count > 1 {
//
//            let strUrl = "album/ios/\(classId)/\(albumId)/\(name)"
//            return strUrl
//
//        } else {
//            let strUrl = "album/ios/\(classId)/\(albumId)/\(name).jpg"
//            return strUrl
//        }
//
//    }
//
//    /// 相册视频
//    @objc func getAlbumVideoUrl(name: String, classId: Int, albumId: Int)-> String {
//        let arr = name.components(separatedBy: ".")
//        if arr.count > 1 {
//            let strUrl = "album/\(classId)/\(albumId)/\(name.MD5())"
//            return strUrl
//
//        } else {
//            let strUrl = "album/\(classId)/\(albumId)/\(name.MD5()).mp4"
//            return strUrl
//        }
//
//    }
//
//    /// 文件
//    @objc func getFileUrl(name: String)-> String {
//        let strUrl = "iOS/files/\(name)"
//        return strUrl
//    }
}

class YXSUploadDataResourceModel: NSObject {
    var dataSource: Data?
    /// 文件名 带后缀 例如IMG_02.jpg
    var fileName: String?
    /// 视频/Gif的首图(选填)
    var bgImage: UIImage? = UIImage(named: "defultImage")
}
