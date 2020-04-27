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
        YXSEducationOssAuthTokenRequest().request({ (result: YXSOSSAuthModel) in
            completionHandler?(result)
            
        }, failureHandler: failureHandler)
    }

    // MARK: - Method
    func uploadDataSource(dataSource:[YXSUploadDataResourceModel], progress : ((_ progress: CGFloat)->())?, sucess:(([YXSFileModel])->())?, failureHandler: ((String, String) -> ())?) {
        
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
            
            if extName == "mp4" {
                /// 视频需获取视频第一帧
                group.enter()
                queue.async { [weak self] in
                    guard let weakSelf = self else {return}
                    path = weakSelf.kHostFilePath+fullName//weakSelf.getVideoUrl(name: fullName)
                    
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
                        let name = "\(fileName ?? "")_1.jpg"
                        //let path: String = weakSelf.getImageUrl(name: name)
                        path = weakSelf.kHostFilePath+name
                        let imgData = sub.bgImage?.jpegData(compressionQuality: 1)

                        weakSelf.aliyunOSSUpload(objectKey: path, uploadingData: imgData, uploadProgress: nil, completionHandler: { (result) in
                            model?.bgUrl = result
                            group.leave()
                            
                        }, failureHandler: failureHandler)
                        
                    } catch  {
                        print("错误")
                    }
                }
                
            } else if extName == "m4a" {
                /// 音频类型
                
            } else if extName == "pptx" || extName == "pdf" {
                /// 文档类型
                
            } else if extName == "jpg" || extName == "png" || extName == "gif" || extName == "jpeg" || extName == "bmp"  {
                /// 图片类型直接上传
                group.enter()
                queue.async { [weak self] in
                    guard let weakSelf = self else {return}
                    path = weakSelf.kHostFilePath+fullName//weakSelf.getImageUrl(name: fullName)
                    
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
    
    /// 班级相册 （长时间存放）
    func uploadAlbumMedias(mediaAssets:[PHAsset], classId: Int?, albumId: Int?, progress : ((_ progress: CGFloat)->())?, sucess:(([YXSFileModel])->())?,failureHandler: ((String, String) -> ())?) {
        
        if oSSAuth == nil {
            YXSEducationOssAuthTokenRequest().request({ [weak self](model: YXSOSSAuthModel) in
                guard let weakSelf = self else {return}
                weakSelf.oSSAuth = model
                weakSelf.uploadAlbumMedias(mediaAssets: mediaAssets, classId: classId, albumId: albumId, progress: progress, sucess: sucess, failureHandler: failureHandler)
                
            }, failureHandler: failureHandler)
            return
        }
        
        var resultArr = [YXSFileModel]()
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        
        for asset in mediaAssets{
            
            let model = YXSFileModel(JSON: ["":""])
            var path: String = ""
            
            if asset.mediaType == .image {
                group.enter()
                queue.async { [weak self] in
                    guard let weakSelf = self else {return}
                    
                    let tmpName = (asset.value(forKey: "filename") as? String ?? "")
                    let fileName = tmpName.deletingPathExtension
                    let extName = "jpg"//tmpName.pathExtension.lowercased()
                    let fullName = "\(fileName).\(extName)"
                    
                    if albumId == nil || classId == nil {
                        path = weakSelf.kHostFilePath+fullName//weakSelf.getImageUrl(name: name)
                        
                    } else {
                        path = weakSelf.kHostFilePath+fullName//weakSelf.getAlbumImageUrl(name: name, classId: classId ?? 0, albumId: albumId ?? 0)
                    }
                    

                    PHImageManager.default().requestImageData(for: asset, options: nil) { (imageData, dataUTI, orientation, info) in
                        
                        weakSelf.aliyunOSSUpload(objectKey: path, uploadingData: imageData, uploadProgress: nil, completionHandler: { (result) in
                            model?.fileUrl = result
                            model?.fileName = fullName
                            model?.fileSize = Int( YXSFileManagerHelper.sharedInstance.sizeKbOfDataSrouce(data: imageData!))
                            model?.fileType = extName
                            resultArr.append(model!)
                            group.leave()
                            
                        }, failureHandler: failureHandler)
                    }
                }

            } else if asset.mediaType == .video {
                
                PHCachingImageManager.default().requestAVAsset(forVideo: asset, options: nil) { (asset, audioMix, info) in
                   
                    let asset = asset as? AVURLAsset

                    if let url = asset?.url {
                        /// 视频数据
                        let tmpName = asset?.url.lastPathComponent
                        let fileName = tmpName?.deletingPathExtension
                        let extName = tmpName?.pathExtension.lowercased()
                        let fullName = "\(fileName ?? "").\(extName ?? "")"
                        
                        group.enter()
                        queue.async { [weak self] in
                            guard let weakSelf = self else {return}

                            if albumId == nil || classId == nil {
                                path = weakSelf.kHostFilePath+fullName//weakSelf.getVideoUrl(name: name)
                                
                            } else {
                                path = weakSelf.kHostFilePath+fullName//weakSelf.getAlbumVideoUrl(name: name, classId: classId ?? 0, albumId: albumId ?? 0)
                            }
                            let data = try? Data(contentsOf: asset!.url)
                            
                            weakSelf.aliyunOSSUpload(objectKey: path, uploadingData: data, uploadProgress: nil, completionHandler: { (result) in
                                
                                model?.fileUrl = result
                                model?.fileName = fullName
                                model?.fileSize = Int( YXSFileManagerHelper.sharedInstance.sizeKbOfDataSrouce(data: data!))
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
                                let name = "\(fileName ?? "")_1.jpg"
                                path = weakSelf.kHostFilePath+name
                                
                                let img = weakSelf.getVideoFirstPicture(asset: asset!)
                                let imgData = img?.jpegData(compressionQuality: 1)

                                weakSelf.aliyunOSSUpload(objectKey: path, uploadingData: imgData, uploadProgress: nil, completionHandler: { (result) in
                                    model?.bgUrl = result
                                    group.leave()
                                    
                                }, failureHandler: failureHandler)
                                
                            } catch  {
                                print("错误")
                            }
                        }
                    }
                }
                
            } else if asset.mediaType == .audio {

            }
        }
        
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                sucess?(resultArr)
            }
        }
    }
    
    /// 上传多个媒体文件 (可能会被服务端定时清理)
    func uploadMedias(mediaAssets:[PHAsset], progress : ((_ progress: CGFloat)->())? = nil, sucess:(([YXSFileModel])->())?,failureHandler: ((String, String) -> ())?) {
        
        uploadAlbumMedias(mediaAssets: mediaAssets, classId: nil, albumId: nil, progress: progress, sucess: sucess, failureHandler: failureHandler)
    }
    
    // MARK: - Base
    // uploadProgress: 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
    func aliyunOSSUpload(objectKey: String, uploadingFileURL: URL? = nil, uploadingData: Data? = nil, uploadProgress: OSSNetworkingUploadProgressBlock?, completionHandler:(((_ resultUrl: String)->())?), failureHandler:((String, String) -> ())?) {
        if uploadingFileURL == nil && uploadingData == nil {
            /// 上传数据源出错
            failureHandler?("上传数据源出错", "400")
            return
        }
        
        if oSSAuth == nil {
            requestYXSOSSAuth(completionHandler: { [weak self](model) in
                guard let weakSelf = self else {return}
                weakSelf.oSSAuth = model
                weakSelf.aliyunOSSUpload(objectKey: objectKey, uploadingFileURL: uploadingFileURL, uploadingData: uploadingData, uploadProgress: uploadProgress, completionHandler: completionHandler, failureHandler: failureHandler)
                
            }, failureHandler: nil)
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
        
        ///conf
        let conf = OSSClientConfiguration()
        conf.maxRetryCount = 2
        conf.timeoutIntervalForRequest = 300
        conf.timeoutIntervalForResource = TimeInterval(24 * 60 * 60)
        conf.maxConcurrentRequestCount = 50
        
        // 实例化client
        let credential: OSSCredentialProvider = OSSStsTokenCredentialProvider.init(accessKeyId: oSSAuth?.accessKeyId ?? "", secretKeyId: oSSAuth?.accessKeySecret ?? "", securityToken: oSSAuth?.securityToken ?? "")
        ossClient = OSSClient(endpoint: oSSAuth?.endpoint ?? "", credentialProvider: credential, clientConfiguration: conf)
        
        /// Task
        let putTask = ossClient?.putObject(put)
        putTask?.continue({ [weak self](task) -> Any? in
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
    /// 图片
    let kHostFilePath = "\(YXSPersonDataModel.sharePerson.userModel.account ?? "")/ios/"
//    @objc func getImageUrl(name: String)-> String{
//        let arr = name.components(separatedBy: ".")
//        if arr.count > 1 {
//            let strUrl = "image/iOS/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(YXSPersonDataModel.sharePerson.userModel?.type ?? "")/\(name)"
//            return strUrl
//
//        } else {
//            let strUrl = "image/iOS/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(YXSPersonDataModel.sharePerson.userModel?.type ?? "")/\(name).jpg"
//            return strUrl
//        }
//
//    }
//
//    /// 相册图片
//    @objc func getAlbumImageUrl(name: String, classId: Int, albumId: Int)-> String{
//        let arr = name.components(separatedBy: ".")
//        if arr.count > 1 {
//            let strUrl = "album/\(classId)/\(albumId)/\(name.MD5())"
//            return strUrl
//
//        } else {
//            let strUrl = "album/\(classId)/\(albumId)/\(name.MD5()).jpg"
//            return strUrl
//        }
//
//    }
//
//    /// 声音
//    @objc func getVoiceUrl(name: String)-> String {
//        let arr = name.components(separatedBy: ".")
//        if arr.count > 1 {
//            let strUrl = "voice/iOS/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(YXSPersonDataModel.sharePerson.userModel?.type ?? "")/\(name)"
//            return strUrl
//
//        } else {
//            let strUrl = "voice/iOS/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(YXSPersonDataModel.sharePerson.userModel?.type ?? "")/\(name).mp3"
//            return strUrl
//        }
//
//    }
//
//    /// 视频
//    @objc func getVideoUrl(name: String)-> String {
//        let arr = name.components(separatedBy: ".")
//        if arr.count > 1 {
//            let strUrl = "video/iOS/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(YXSPersonDataModel.sharePerson.userModel?.type ?? "")/\(name)"
//            return strUrl
//
//        } else {
//            let strUrl = "video/iOS/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(YXSPersonDataModel.sharePerson.userModel?.type ?? "")/\(name).mp4"
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
