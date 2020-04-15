//
//  YXSUploadSourceHelper.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/29.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import AliyunOSSiOS
import SwiftyJSON
import ObjectMapper
import Photos


let productPrefix = sericeType == ServiceType.ServiceTest ? "test-environment/": "product-environment/"

//拍15s   大小50M以内 时长3min
//视频大小

//图片大小2M以内
let imageMax: Int = 3*1024*1024
let videoMax: Int = 50*1024*1024

let typeKey = "typeKey"
let modelKey = "modelKey"
let urlKey = "urlKey"
let classIdKey = "classIdKey"
let albumIdKey = "albumIdKey"

class SLUploadSourceModel: NSObject{
    let model: YXSMediaModel!
    let audioModel: SLAudioModel!
    let type: SourceNameType
    
    /// 阿里云存储路径
    var path: String
    
    
    /// 上传多个资源时候顺序
    var index: Int = 0
    
    /// 上传完成的阿里云地址
    var url: String?
    
    
    //上传图片 视频资源model
    init(model: YXSMediaModel? = nil, audioModel: SLAudioModel? = nil, type: SourceNameType, path: String? = nil) {
        self.model = model
        self.audioModel = audioModel
        self.type = type
        if type == .voice && audioModel == nil{
            assert(false, "音频资源不能为空")
        }
        
        if type != .voice && model == nil{
            assert(false, "媒体资源不能为空")
        }
        
        if let path = path{
            self.path = path
        }else{
            switch type {
            case .avatar,.image:
                self.path = NSUtil.getPath(sourceType: type, fileName: self.model.fileName.MD5(), fileType: "jpg")
            case .voice:
                self.path = NSUtil.getPath(sourceType: type, fileName: (self.audioModel.fileName ?? "").MD5(), fileType: "mp3")
            case .video:
                self.path = NSUtil.getPath(sourceType: type, fileName: self.model.fileName.MD5(), fileType: "mp4")
            case .firstVideo:
                self.path = NSUtil.getPath(sourceType: .video, fileName: self.model.fileName.MD5() + "_1", fileType: "jpg")
            case .album:
                assert(false, "相册资源请指定路径")
                self.path = ""
            }
            
        }
        super.init()
    }
}


/// 上传资源类型(存放在阿里云不同文件夹)
enum SourceNameType:String {
    case avatar//头像
    case voice//音频
    case image//图片
    case video//视频
    case firstVideo//视频第一帧
    case album//相册
}

class YXSUploadSourceHelper: NSObject {
    
    //现在一次请求 生成一个token
    private var ossClient: OSSClient?
    private var oSSAuth: YXSOSSAuthModel!
    private func initClient(){
        let conf = OSSClientConfiguration()
        conf.maxRetryCount = 2
        conf.timeoutIntervalForRequest = 300
        conf.timeoutIntervalForResource = TimeInterval(24 * 60 * 60)
        conf.maxConcurrentRequestCount = 50
        let credential2:OSSCredentialProvider = OSSStsTokenCredentialProvider.init(accessKeyId: self.oSSAuth.accessKeyId ?? "", secretKeyId: self.oSSAuth.accessKeySecret ?? "", securityToken: self.oSSAuth.securityToken ?? "")
        
        //实例化
        ossClient = OSSClient(endpoint: oSSAuth.endpoint ?? "", credentialProvider: credential2, clientConfiguration: conf)
    }
    
    
    /// 上传图片
    /// - Parameter mediaModel: YXSMediaModel
    /// - Parameter sourceNameType: 默认图片
    /// - Parameter sucess: 成功后回调图片地址
    /// - Parameter failureHandler: 失败错误信息
    func uploadImage(mediaModel:YXSMediaModel,sourceNameType: SourceNameType = .image, sucess:((String)->())?,failureHandler: ((String, String) -> ())?){
        uploadMedia(mediaInfos: [[modelKey:mediaModel, typeKey: sourceNameType]], sucess: { (urls) in
            sucess?((urls.first?[urlKey] as? String) ?? "")
        }, failureHandler: failureHandler)
    }
    
    //上传多张图片
    func uploadImages(mediaModels:[YXSMediaModel],sourceNameType: SourceNameType,progress : ((_ progress: CGFloat)->())? = nil, sucess:(([String])->())?,failureHandler: ((String, String) -> ())?){
        var infos = [[String: Any]]()
        for model in mediaModels{
            infos.append([typeKey: sourceNameType,modelKey: model])
        }
        uploadMedia(mediaInfos: infos,progress: progress, sucess: { (urls) in
            var paths = [String]()
            for url in urls{
                paths.append((url[urlKey] as? String) ?? "")
            }
            sucess?(paths)
        }, failureHandler: failureHandler)
    }
    
    func uploadVedio(mediaModel:YXSMediaModel,progress : ((_ progress: CGFloat)->())? = nil,sourceNameType: SourceNameType = SourceNameType.video, sucess:((String)->())?,failureHandler: ((String, String) -> ())?){
        uploadMedia(mediaInfos: [[modelKey:mediaModel, typeKey: sourceNameType]],progress: progress, sucess: { (urls) in
            sucess?((urls.first?[urlKey] as? String) ?? "")
        }, failureHandler: failureHandler)
    }
    
    func uploadAudio(mediaModel:SLAudioModel, progress : ((_ progress: CGFloat)->())? = nil, sucess:((String)->())?,failureHandler: ((String, String) -> ())?){
        uploadMedia(mediaInfos: [[modelKey:mediaModel, typeKey: SourceNameType.voice]],progress: progress, sucess: { (urls) in
            sucess?((urls.first?[urlKey] as? String) ?? "")
        }, failureHandler: failureHandler)
    }
    
    func uploadAudios(mediaModels:[SLAudioModel], progress : ((_ progress: CGFloat)->())? = nil,sucess:(([String])->())?,failureHandler: ((String, String) -> ())?){
        var infos = [[String: Any]]()
        for model in mediaModels{
            infos.append([typeKey: SourceNameType.voice,modelKey: model])
        }
        uploadMedia(mediaInfos: infos,progress: progress, sucess: { (urls) in
            var paths = [String]()
            for url in urls{
                paths.append((url[urlKey] as? String) ?? "")
            }
            sucess?(paths)
        }, failureHandler: failureHandler)
    }
    
    /// 上传多个媒体文件
    func uploadMedias(mediaModels:[YXSMediaModel], progress : ((_ progress: CGFloat)->())? = nil, sucess:(([String])->())?,failureHandler: ((String, String) -> ())?){
        var infos = [[String: Any]]()
        for model in mediaModels{
            if model.asset.mediaType == .image {
                infos.append([typeKey: SourceNameType.image, modelKey: model])
                
            } else if model.asset.mediaType == .video {
                infos.append([typeKey: SourceNameType.video, modelKey: model])
                
            } else if model.asset.mediaType == .audio {
                infos.append([typeKey: SourceNameType.voice, modelKey: model])
            }
        }
        uploadMedia(mediaInfos: infos,progress: progress, sucess: { (urls) in
            var paths = [String]()
            for url in urls{
                paths.append((url[urlKey] as? String) ?? "")
            }
            sucess?(paths)
        }, failureHandler: failureHandler)
    }
    
    //上传资源
    func uploadMedia(mediaInfos: [[String: Any]] ,progress progressBlock : ((_ progress: CGFloat)->())? = nil, sucess:(([[String: Any]])->())?,failureHandler: ((String, String) -> ())?) {
        if oSSAuth == nil{
            YXSEducationOssAuthTokenRequest().request({ (model: YXSOSSAuthModel) in
                self.oSSAuth = model
                self.uploadMedia(mediaInfos: mediaInfos, progress: progressBlock,sucess: sucess,failureHandler: failureHandler)
            }, failureHandler: failureHandler)
            return
        }
        
        initClient()
        var urls = [[String: Any]]()
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        
        var failureHandlerMsg: String?
        
        var uploadModels = [SLUploadSourceModel]()
        
        for (index,info) in mediaInfos.enumerated(){
            let sourceType: SourceNameType = info[typeKey] as! SourceNameType
            
            var mediaModel: YXSMediaModel!
            var audioModel: SLAudioModel!
            if sourceType == .voice{
                audioModel = info[modelKey] as? SLAudioModel
                if audioModel == nil{
                    assert(false, "上传资源请传audioModel")
                }
            }else{
                mediaModel = info[modelKey] as? YXSMediaModel
                if mediaModel == nil{
                    assert(false, "上传资源请传mediaModel")
                }
            }
            
            if  sourceType == .video{
                let newModel = SLUploadSourceModel.init(model: mediaModel, type: SourceNameType.firstVideo)
                newModel.index = index
                uploadModels.append(newModel)
                
                let curruntModel = SLUploadSourceModel.init(model: mediaModel, type: sourceType)
                curruntModel.index = index
                uploadModels.append(curruntModel)
            }else if sourceType == .album{
                if let classId = info[classIdKey] as? Int, let albumId = info[albumIdKey] as? Int{
                    if mediaModel.type == .video{
                        let newModel = SLUploadSourceModel.init(model: mediaModel, type: SourceNameType.album,path:
                            "\(sourceType.rawValue)/\(classId )/\(albumId)/+\(mediaModel.fileName.MD5())_1.jpg")
                        newModel.index = index
                        uploadModels.append(newModel)
                        
                        let curruntModel = SLUploadSourceModel.init(model: mediaModel, type: sourceType,path: "\(sourceType.rawValue)/\(classId )/\(albumId)/+\(mediaModel.fileName.MD5()).mp4")
                        curruntModel.index = index
                        uploadModels.append(curruntModel)
                        
                    }else{
                        let curruntModel = SLUploadSourceModel.init(model: mediaModel, type: sourceType,path: "\(sourceType.rawValue)/\(classId )/\(albumId)/+\(mediaModel.fileName.MD5()).jpg")
                        curruntModel.index = index
                        uploadModels.append(curruntModel)
                    }
                }else{
                    assert(false, "相册资源必须传classId和albumId")
                }
                
            }else if sourceType == .voice{
                let curruntModel = SLUploadSourceModel.init(audioModel: audioModel, type: sourceType)
                curruntModel.index = index
                uploadModels.append(curruntModel)
            }else{
                let curruntModel = SLUploadSourceModel.init(model: mediaModel, type: sourceType)
                curruntModel.index = index
                uploadModels.append(curruntModel)
            }
        }
        
        /// 单次任务上传进度
        var progress: CGFloat = 0
        
        /// 上传数量
        let count = uploadModels.count
        
        for uploadModel in uploadModels{
            let ossPutObj: OSSPutObjectRequest = OSSPutObjectRequest()
            //path为上传到阿里云的路径
            var path: String = productPrefix
            group.enter()
            queue.async {
                let sourceType: SourceNameType = uploadModel.type
                switch sourceType {
                case .image,.avatar,.firstVideo:
                    let data = uploadModel.model.showImg?.yxs_compressImage(image: uploadModel.model.showImg!, maxLength: imageMax)
                    ossPutObj.uploadingData = data
                    path += uploadModel.path
                case .video:
                    let semaphore = DispatchSemaphore(value: 0)
                    PHImageManager.default().requestExportSession(forVideo: uploadModel.model.asset, options: nil, exportPreset: AVAssetExportPresetMediumQuality) { (exportSession, info) in
                        //将asset转换为AVAssetExportSession对象,用AVAssetExportSession转化为Data
                        HMVideoCompression().compressVideo(exportSession) { (data) in
                            if data.count > 0 {//做判断,判断是否转化成功
                                //进行视频上传
                                ossPutObj.uploadingData = data
                            }else{
                                failureHandlerMsg = "视频资源请传mediaModel"
                                
                            }
                            semaphore.signal()
                        }
                    }
                    semaphore.wait()
                    path += uploadModel.path
                case .voice:
                    ossPutObj.uploadingFileURL = URL.init(string: uploadModel.audioModel.path ?? "")!
                    path += uploadModel.path
                case .album:
                    if uploadModel.model.type == .video{
                        let semaphore = DispatchSemaphore(value: 0)
                        PHImageManager.default().requestExportSession(forVideo: uploadModel.model.asset, options: nil, exportPreset: AVAssetExportPresetMediumQuality) { (exportSession, info) in
                            //将asset转换为AVAssetExportSession对象,用AVAssetExportSession转化为Data
                            HMVideoCompression().compressVideo(exportSession) { (data) in
                                if data.count > 0 {//做判断,判断是否转化成功
                                    //进行视频上传
                                    ossPutObj.uploadingData = data
                                }else{
                                    failureHandlerMsg = "视频资源请传mediaModel"
                                    
                                }
                                semaphore.signal()
                            }
                        }
                        semaphore.wait()
                        path += uploadModel.path
                    }else{
                        let data = uploadModel.model.showImg?.yxs_compressImage(image: uploadModel.model.showImg!, maxLength: imageMax)
                        ossPutObj.uploadingData = data
                        path += uploadModel.path
                    }
                }
                
                ossPutObj.bucketName = self.oSSAuth.bucket
                ossPutObj.objectKey = path
                
                ossPutObj.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
                    progress += (CGFloat(bytesSent)/CGFloat(totalBytesExpectedToSend))/CGFloat(count)
//                    SLLog(progress)
                    progressBlock?(progress)
                }
                
                let uploadTask = self.ossClient?.putObject(ossPutObj)
                
                uploadTask?.continue({ (uploadTask) -> Any? in
                    if let _err = uploadTask.error {
                        failureHandlerMsg = _err.localizedDescription
                        group.leave()
                    } else {
                        if  let _:OSSPutObjectResult  = uploadTask.result as? OSSPutObjectResult {
                            var point: NSString = (self.oSSAuth.endpoint ?? "") as NSString
                            point = point.replacingOccurrences(of: "http://", with: "") as NSString
                            point = point.replacingOccurrences(of: "https://", with: "") as NSString
                            let picUrlStr = "http://\(self.oSSAuth.bucket ?? "").\(point)/\(path)"
                            urls.append([typeKey: sourceType, urlKey: picUrlStr,"index" : uploadModel.index])
                        }else{
                            failureHandlerMsg = "链接拼接失败"
                        }
                        group.leave()
                    }
                    
                    return uploadTask
                })
                
            }
        }
        
        group.notify(queue: queue){
            DispatchQueue.main.async {
                if let failureHandlerMsg = failureHandlerMsg{
                    failureHandler?(failureHandlerMsg, "500")
                }else{
                    let newUrls = urls.sorted(by: {(a,b) -> Bool in
                        return (a["index"] as? Int ?? 0) < (b["index"] as? Int ?? 0)
                    })
                    sucess?(newUrls)
                }
            }
        }
    }
}


/// 获取视频data
class HMVideoCompression: NSObject {
    public func compressVideo(_ exportSession:AVAssetExportSession? , completion: @escaping (_ data: Data)-> Void) {
        
        let uuu = self.compressedUrl()
        exportSession?.outputURL = URL.init(fileURLWithPath: uuu)
        exportSession?.outputFileType = .mp4
        exportSession?.shouldOptimizeForNetworkUse = true;
        
        if let assetTime = exportSession?.asset.duration {
            let duration = CMTimeGetSeconds(assetTime)
            print("视频时长 \(duration)");
        }
        
        exportSession?.exportAsynchronously(completionHandler: {
            
            switch exportSession?.status{
                
            case .failed?:
                print("失败...\(String(describing: exportSession?.error?.localizedDescription))")
                completion(Data())
                break
            case .cancelled?:
                print("取消")
                completion(Data())
                break;
            case .completed?:
                print("转码成功")
                do {
                    let data = try Data.init(contentsOf: URL.init(fileURLWithPath: uuu), options: Data.ReadingOptions.init())
                    let mp4Path = URL.init(fileURLWithPath: uuu)
                    let size = self.fileSize(url: mp4Path)
                    print("视频时长\(size)")
                    
                    try? FileManager.default.removeItem(atPath: uuu)
                    
                    completion(data)
                } catch let error {
                    print("失败 \(error)")
                    
                    try? FileManager.default.removeItem(atPath: uuu)
                    completion(Data())
                }
                
                break;
            default:
                print("..")
                completion(Data())
                break;
            }
        })
    }
    
    //保存压缩
    func compressedUrl() -> String {
        
        let string = NSHomeDirectory() + "/Documents/\(Date().timeIntervalSince1970).mp4"
        
        return string//URL.init(fileURLWithPath: string)
    }
    
    //计算视频大小
    func fileSize(url:URL) -> CGFloat {
        return CGFloat(NSData.init(contentsOf: url)?.length ?? 0 )/// 1024 / 1024
    }
}
