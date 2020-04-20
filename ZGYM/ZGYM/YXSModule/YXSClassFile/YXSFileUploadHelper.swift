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

class YXSFileUploadHelper: NSObject {
    //现在一次请求 生成一个token
    private var ossClient: OSSClient?
    private var oSSAuth: YXSOSSAuthModel?
    
    // MARK: - Request
    @objc func requestYXSOSSAuth(completionHandler:(((_ model: YXSOSSAuthModel)->())?), failureHandler: ((String, String) -> ())?) {
        YXSEducationOssAuthTokenRequest().request({ (result: YXSOSSAuthModel) in
            completionHandler?(result)

        }, failureHandler: failureHandler)
    }
    
    // MARK: - GetUrl
    /// 图片
    @objc func getImageUrl(name: String)-> String{
        let strUrl = "image/iOS/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(YXSPersonDataModel.sharePerson.userModel?.type ?? "")/\(name).jpg"
        return strUrl
    }
    
    /// 相册图片
    @objc func getAlbumImageUrl(name: String, classId: Int, albumId: Int)-> String{
        let strUrl = "album/\(classId)/\(albumId)/\(name.MD5()).jpg"
        return strUrl
    }
    
    /// 声音
    @objc func getVoiceUrl(name: String)-> String {
        let strUrl = "voice/iOS/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(YXSPersonDataModel.sharePerson.userModel?.type ?? "")/\(name).mp3"
        return strUrl
    }
    
    /// 视频
    @objc func getVideoUrl(name: String)-> String {
        let strUrl = "video/iOS/\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/\(YXSPersonDataModel.sharePerson.userModel?.type ?? "")/\(name).mp4"
        return strUrl
    }
    
    /// 相册视频
    @objc func getAlbumVideoUrl(name: String, classId: Int, albumId: Int)-> String {
        let strUrl = "album/\(classId)/\(albumId)/\(name.MD5()).mp4"
        return strUrl
    }
    
    /// 文件
    @objc func getFileUrl(name: String)-> String {
        let strUrl = "iOS/files/\(name)"
        return strUrl
    }

    // MARK: - Method
    /// 班级相册 （长时间存放）
    func uploadAlbumMedias(mediaAssets:[PHAsset], classId: Int, albumId: Int, progress : ((_ progress: CGFloat)->())? = nil, sucess:(([YXSFileModel])->())?,failureHandler: ((String, String) -> ())?) {
        if oSSAuth == nil {
            YXSEducationOssAuthTokenRequest().request({ [weak self](model: YXSOSSAuthModel) in
                guard let weakSelf = self else {return}
                weakSelf.oSSAuth = model
                weakSelf.uploadMedias(mediaAssets: mediaAssets, progress: progress, sucess: sucess, failureHandler: failureHandler)
                
            }, failureHandler: failureHandler)
            return
        }
        
        for asset in mediaAssets {
            
            if asset.mediaType == .image {
                let strArr = (asset.value(forKey: "filename") as? String ?? "").split(separator: ".")
                let path: String = getAlbumImageUrl(name: String(strArr.first ?? ""), classId: classId, albumId: albumId)

                PHImageManager.default().requestImageData(for: asset, options: nil) { [weak self](imageData, dataUTI, orientation, info) in
                    guard let weakSelf = self else {return}
                    
                    weakSelf.aliyunOSSUpload(objectKey: path, uploadingData: imageData, uploadProgress: nil, completionHandler: { (result) in
                        
                    }, failureHandler: failureHandler)
                }
                
            } else if asset.mediaType == .video {
                
                

            } else if asset.mediaType == .audio {

            }
        }
    }
    
    /// 上传多个媒体文件
    func uploadMedias(mediaAssets:[PHAsset], progress : ((_ progress: CGFloat)->())? = nil, sucess:(([YXSFileModel])->())?,failureHandler: ((String, String) -> ())?) {
        
        if oSSAuth == nil {
            YXSEducationOssAuthTokenRequest().request({ [weak self](model: YXSOSSAuthModel) in
                guard let weakSelf = self else {return}
                weakSelf.oSSAuth = model
                weakSelf.uploadMedias(mediaAssets: mediaAssets, progress: progress, sucess: sucess, failureHandler: failureHandler)
                
            }, failureHandler: failureHandler)
            return
        }
        
        
        var resultArr = [YXSFileModel]()
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        
        for asset in mediaAssets{
            
            var model = YXSFileModel(JSON: ["":""])
            
            if asset.mediaType == .image {
                group.enter()
                queue.async { [weak self] in
                    guard let weakSelf = self else {return}
                    
                    let strArr = (asset.value(forKey: "filename") as? String ?? "").split(separator: ".")
                    let name = String(strArr.first ?? "")
                    let path: String = weakSelf.getImageUrl(name: name)

                    PHImageManager.default().requestImageData(for: asset, options: nil) { (imageData, dataUTI, orientation, info) in
                        
                        weakSelf.aliyunOSSUpload(objectKey: path, uploadingData: imageData, uploadProgress: nil, completionHandler: { (result) in
                            model?.fileUrl = result ?? ""
                            model?.fileName = name
                            model?.fileSize = Int( YXSFileManagerHelper.sharedInstance.sizeOfDataSrouce(data: imageData!))
                            model?.fileType = result.pathExtension
                            resultArr.append(model!)
                            group.leave()
                            
                        }, failureHandler: failureHandler)
                    }
                }

            } else if asset.mediaType == .video {
                group.enter()
                queue.async { [weak self] in
                    guard let weakSelf = self else {return}
                    
                    PHCachingImageManager.default().requestAVAsset(forVideo: asset, options: nil) { (asset, audioMix, info) in
                       
                        
                        let asset = asset as? AVURLAsset

                        if let url = asset?.url {
                            /// 视频数据
                            let strArr = asset?.url.lastPathComponent.split(separator: ".")
                            let name = String(strArr?.first ?? "")
                            let path: String = weakSelf.getVideoUrl(name: name)
                            let data = try? Data(contentsOf: asset!.url)
                            
                            weakSelf.aliyunOSSUpload(objectKey: path, uploadingData: data, uploadProgress: nil, completionHandler: { (result) in
                                
                                model?.fileUrl = result ?? ""
                                model?.fileName = name
                                model?.fileSize = Int( YXSFileManagerHelper.sharedInstance.sizeOfDataSrouce(data: data!))
                                model?.fileType = result.pathExtension
                                resultArr.append(model!)
                                group.leave()
                                
                            }, failureHandler: failureHandler)
                            
                            ///获取视频第一帧
                            do {
                                let name = String(strArr?.first ?? "")+"_1"
                                let path: String = weakSelf.getImageUrl(name: name)
                                
                                let img = weakSelf.getVideoFirstPicture(asset: asset!)
                                let imgData = img?.jpegData(compressionQuality: 1)

                                weakSelf.aliyunOSSUpload(objectKey: path, uploadingData: imgData, uploadProgress: nil, completionHandler: { (result) in
                                    model?.bgUrl = result
                                    
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
}
