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


let productPrefix = sericeType == ServiceType.ServiceTest ? "test-env/": "product-env/"

//拍15s   大小50M以内 时长3min
//视频大小

//图片大小2M以内
let imageMax: Int = 3*1024*1024
let videoMax: Int = 50*1024*1024

let typeKey = "typeKey"
let modelKey = "modelKey"
let urlKey = "urlKey"


class SLUploadSourceModel: NSObject{
    ///YXSMediaModel or SLAudioModel
    let model: Any
    ///资源类型(图片 音频 视频 视频第一帧)
    let type: SourceNameType
    ///文件名称(不带后缀)
    let fileName: String
    ///阿里云存储磁盘路径
    let storageType: YXSStorageType
    
    ///班级id
    let classId: Int?
    ///相册id
    let albumId: Int?
    
    ///阿里云上传路径
    var path: String{
        get{
            var suffix = ".mp4"
            switch type {
            case .image:
                suffix = ".jpg"
            case .firstVideo:
                suffix = "_1.jpg"
            case .voice:
                suffix = ".mp3"
            case .video:
                suffix = ".mp4"
            }
            switch storageType {
            case .temporary:
                switch type {
                case .image, .firstVideo:
                    return YXSFileUploadHelper.sharedInstance.getTmpImgUrl(fullName: fileName.MD5() + suffix)
                case .voice:
                    return YXSFileUploadHelper.sharedInstance.getTmpVoiceUrl(fullName: fileName.MD5() + suffix)
                case .video:
                    return YXSFileUploadHelper.sharedInstance.getTmpVideoUrl(fullName: fileName.MD5() + suffix)
                }
            case .album:
                return YXSFileUploadHelper.sharedInstance.getAlbumUrl(fullName: fileName.MD5() + suffix, classId: classId ?? 0, albumId: albumId ?? 0)
                
            case .classFile:
                return YXSFileUploadHelper.sharedInstance.getClassFileUrl(fullName: fileName.MD5() + suffix, classId: classId ?? 0)
                
            case .satchel:
                return YXSFileUploadHelper.sharedInstance.getSatchelUrl(fullName: fileName.MD5() + suffix)
                
            case .circle:
                return YXSFileUploadHelper.sharedInstance.getCircleUrl(fullName: fileName.MD5() + suffix)
            case .avatar:
                return YXSFileUploadHelper.sharedInstance.getAvatarUrl(fullName: fileName.MD5() + suffix)
            case .curriculum:
                return YXSFileUploadHelper.sharedInstance.getCurriculumUrl(fullName: fileName.MD5() + suffix, classId: classId ?? 0)
            case .star:
                return YXSFileUploadHelper.sharedInstance.getStarUrl(fullName: fileName.MD5() + suffix, classId: classId ?? 0)
            }
        }
    }
    
    //上传图片 视频资源model(普通上传)
    init(model: Any, type: SourceNameType, storageType: YXSStorageType, fileName: String, classId: Int? = nil, albumId: Int? = nil) {
        self.model = model
        self.type = type
        self.storageType = storageType
        self.fileName = fileName
        self.classId = classId
        self.albumId = albumId
        super.init()
    }
}

class SLUploadDataSourceModel: NSObject{
    ///需要上传的data
    let data: Data?
    ///上传到阿里云的路径
    let path: String
    ///上传资源类型
    let type: SourceNameType
    
    ///阿里云返回的url
    var aliYunUploadBackUrl: String?
    
    ///上传多个资源排序时使用
    var index: Int = 0
    
    init(data: Data?, path: String, type: SourceNameType) {
        self.data = data
        self.path = path
        self.type = type
        super.init()
    }
}


/// 上传资源类型(存放在阿里云不同文件夹)
enum SourceNameType:String {
    case voice//音频
    case image//图片
    case video//视频
    case firstVideo//视频第一帧
}

class YXSUploadSourceHelper: NSObject {
    /// 上传图片
    /// - Parameter mediaModel: YXSMediaModel
    /// - Parameter sucess: 成功后回调图片地址
    /// - Parameter failureHandler: 失败错误信息
    func uploadImage(mediaModel:YXSMediaModel, storageType: YXSStorageType, classId: Int? = nil, albumId: Int? = nil, sucess:((String)->())?,failureHandler: ((String, String) -> ())?){
        uploadMedia(mediaInfos: [SLUploadSourceModel.init(model: mediaModel, type: .image, storageType: storageType, fileName: mediaModel.fileName, classId: classId, albumId: albumId)], sucess:{ (urls) in
            sucess?(urls.first?.aliYunUploadBackUrl ?? "" )
        }, failureHandler: failureHandler)
        
    }
    
    /// 上传音频
    /// - Parameters:
    ///   - mediaModel: 音频model
    ///   - uploadPath: 上传路径 除文件名称类型
    func uploadAudio(mediaModel:SLAudioModel, storageType: YXSStorageType = .temporary, progress : ((_ progress: CGFloat)->())? = nil, sucess:((String)->())?,failureHandler: ((String, String) -> ())?){
        uploadMedia(mediaInfos: [SLUploadSourceModel.init(model: mediaModel, type: .voice, storageType: storageType, fileName: mediaModel.fileName ?? "")], sucess:{ (urls) in
            sucess?(urls.first?.aliYunUploadBackUrl ?? "" )
        }, failureHandler: failureHandler)
    }
    
    /// 上传媒体文件
    /// - Parameters:
    ///   - mediaInfos: 媒体model
    ///   - progressBlock: 上传进度
    ///   - sucess: 成功
    ///   - failureHandler: 失败
    func uploadMedia(mediaInfos: [SLUploadSourceModel],progress progressBlock : ((_ progress: CGFloat)->())? = nil, sucess:(([SLUploadDataSourceModel])->())?,failureHandler: ((String, String) -> ())?) {
        var uploadModels = [SLUploadSourceModel]()
        
        ///整理上传需要的资源 (视频多传一个第一帧的数据)
        for uploadModel in mediaInfos{
            let sourceType: SourceNameType = uploadModel.type
            
            var mediaModel: YXSMediaModel!
            var audioModel: SLAudioModel!
            if sourceType == .voice{
                audioModel = uploadModel.model as? SLAudioModel
                if audioModel == nil{
                    assert(false, "上传资源请传audioModel")
                }
            }else{
                mediaModel = uploadModel.model as? YXSMediaModel
                if mediaModel == nil{
                    assert(false, "上传资源请传mediaModel")
                }
            }
            
            ///视频model上传第一帧
            if  sourceType == .video{
                let newModel = SLUploadSourceModel.init(model: uploadModel.model, type: SourceNameType.firstVideo, storageType: uploadModel.storageType, fileName: uploadModel.fileName, classId: uploadModel.classId, albumId: uploadModel.albumId)
                uploadModels.append(newModel)
            }
            
            uploadModels.append(uploadModel)
            
            
        }
        
        var failureHandlerMsg: String?
        
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        var newUploadModels: [SLUploadDataSourceModel] = [SLUploadDataSourceModel]()
        for uploadModel in uploadModels{
            let sourceType: SourceNameType = uploadModel.type
            switch sourceType {
            case .image,.firstVideo:
                if let model = (uploadModel.model as? YXSMediaModel){
                    if let showImg = model.showImg {
                        let data = showImg.yxs_compressImage(image: model.showImg!, maxLength: imageMax)
                        newUploadModels.append(SLUploadDataSourceModel.init(data: data, path: uploadModel.path, type: uploadModel.type))
                    }else{
                        group.enter()
                        queue.async{
                            UIUtil.PHAssetToImage(model.asset){
                                (result) in
                                model.showImg = result
                                let data = result.yxs_compressImage(image: model.showImg!, maxLength: imageMax)
                                newUploadModels.append(SLUploadDataSourceModel.init(data: data, path: uploadModel.path, type: uploadModel.type))
                                group.leave()
                            }
                        }
                    }
                    
                }
                
            case .video:
                //                if let model = (uploadModel.model as? YXSMediaModel){
                //                    group.enter()
                //                    queue.async {
                //                        PHCachingImageManager.default().requestAVAsset(forVideo: model.asset, options: nil) { (asset, audioMix, info) in
                //
                //                            let asset = asset as? AVURLAsset
                //
                //                            if let url = asset?.url {
                //                                newUploadModels.append(SLUploadDataSourceModel.init(data: try? Data.init(contentsOf: url), path: uploadModel.path, type: uploadModel.type))
                //
                //                            }else{
                //                                failureHandlerMsg = "视频资源为空"
                //                            }
                //                            group.leave()
                //                        }
                //                    }
//            }
                
                if let model = (uploadModel.model as? YXSMediaModel){
                    group.enter()
                    queue.async {
                        //从iCloud云下载
                        let options = PHVideoRequestOptions()
                        options.isNetworkAccessAllowed = true
                        options.version = .current
                        options.deliveryMode = .automatic
                        options.progressHandler = { (progress, error, point, obc)  in
                            
                        }
                        
                        PHImageManager.default().requestExportSession(forVideo: model.asset, options: options, exportPreset: AVAssetExportPresetMediumQuality) { (exportSession, info) in
                            //将asset转换为AVAssetExportSession对象,用AVAssetExportSession转化为Data
                            HMVideoCompression().compressVideo(exportSession) { (data) in
                                if data.count > 0 {//做判断,判断是否转化成功
                                    //进行视频上传
                                    newUploadModels.append(SLUploadDataSourceModel.init(data: data, path: uploadModel.path, type: uploadModel.type))
                                }else{
                                    failureHandlerMsg = "视频资源错误"
                                    
                                }
                                group.leave()
                                
                                
                            }
                        }
                    }
                }
            case .voice:
                if let audioModel = (uploadModel.model as? SLAudioModel){
                    let url = URL.init(fileURLWithPath: audioModel.path ?? "")
                    newUploadModels.append(SLUploadDataSourceModel.init(data: try? Data.init(contentsOf: url), path: uploadModel.path, type: uploadModel.type))
                }
                
            }
        }
        
        group.notify(queue: queue){
            DispatchQueue.main.async {
                if let failureHandlerMsg = failureHandlerMsg{
                    failureHandler?(failureHandlerMsg, "500")
                }else{
                    self.uploadMedia(uploadModels: newUploadModels, progress: progressBlock, sucess: sucess, failureHandler: failureHandler)
                }
            }
        }
    }
    
    
    /// 上传资源多个资源
    /// - Parameters:
    ///   - uploadModels: 资源model列表
    ///   - progressBlock: 进度
    ///   - sucess: 成功 返回资源model列表  里面带有成功上传的路径
    ///   - failureHandler: 上传失败
    /// - Returns:
    func uploadMedia(uploadModels: [SLUploadDataSourceModel],progress progressBlock : ((_ progress: CGFloat)->())? = nil, sucess:((_ uploadModels: [SLUploadDataSourceModel])->())?,failureHandler: ((String, String) -> ())?) {
        if let oSSAuth = YXSUploadDataHepler.shareHelper.oSSAuth{
            if oSSAuth.expirationDate.timeIntervalSince1970 <= Date().timeIntervalSince1970{
                YXSUploadDataHepler.shareHelper.oSSAuth = nil
            }
        }
        
        if YXSUploadDataHepler.shareHelper.oSSAuth == nil{
            YXSEducationOssAuthTokenRequest().request({ (model: YXSOSSAuthModel) in
                YXSUploadDataHepler.shareHelper.oSSAuth = model
                YXSUploadDataHepler.shareHelper.initClient()
                self.uploadMedia(uploadModels: uploadModels, progress: progressBlock, sucess: sucess, failureHandler: failureHandler)
            }, failureHandler: failureHandler)
            return
        }
        
        
        let ossClient = YXSUploadDataHepler.shareHelper.ossClient
        
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        
        var failureHandlerMsg: String?
        
        ///任务上传进度
        var progress: CGFloat = 0
        
        /// 上传数量
        let count = uploadModels.count
        for (index,uploadModel) in uploadModels.enumerated(){
            group.enter()
            uploadModel.index = index
            
            ///上一次上传进度
            var lastProgress: CGFloat = 0.0
            queue.async {
                YXSUploadDataHepler.shareHelper.uploadData(uploadModel: uploadModel, ossClient: ossClient, progress: { (singleProgress) in
                    progress += singleProgress/CGFloat(count) - lastProgress
                    lastProgress = singleProgress/CGFloat(count)
                    
                    if progress >= 1.0{
                        progress = 1.0
                    }
                    progressBlock?(progress)
                    SLLog("totalprogress = \(progress)")
                }, sucess: { (url) in
                    uploadModel.aliYunUploadBackUrl = url
                    group.leave()
                }) { (msg, code) in
                    failureHandlerMsg = msg
                    group.leave()
                }
            }
        }
        
        group.notify(queue: queue){
            DispatchQueue.main.async {
                if let failureHandlerMsg = failureHandlerMsg{
                    failureHandler?(failureHandlerMsg, "500")
                }else{
                    let sortModels = uploadModels.sorted(by: {(a,b) -> Bool in
                        return (a.index) < (b.index)
                    })
                    sucess?(sortModels)
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
        if let exportSession = exportSession{
            exportSession.exportAsynchronously(completionHandler: {
                
                switch exportSession.status{
                    
                case .failed:
                    print("失败...\(String(describing: exportSession.error?.localizedDescription))")
                    completion(Data())
                    break
                case .cancelled:
                    print("取消")
                    completion(Data())
                    break;
                case .completed:
                    print("转码成功")
                    do {
                        let data = try Data.init(contentsOf: URL.init(fileURLWithPath: uuu), options: Data.ReadingOptions.init())
                        let mp4Path = URL.init(fileURLWithPath: uuu)
                        let size = self.fileSize(url: mp4Path)
                        print("视频大小\(size)")
                        
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
        }else{
            completion(Data())
        }
        
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




///上传data
class YXSUploadDataHepler: NSObject{
    //现在一次请求 生成一个token
    var ossClient: OSSClient?
    var oSSAuth: YXSOSSAuthModel?
    static let shareHelper = YXSUploadDataHepler()
    private override init(){
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func initClient(){
        let conf = OSSClientConfiguration()
        conf.maxRetryCount = 2
        conf.timeoutIntervalForRequest = 300
        conf.timeoutIntervalForResource = TimeInterval(24 * 60 * 60)
        conf.maxConcurrentRequestCount = 50
        let credential2:OSSCredentialProvider = OSSStsTokenCredentialProvider.init(accessKeyId: self.oSSAuth?.accessKeyId ?? "", secretKeyId: self.oSSAuth?.accessKeySecret ?? "", securityToken: self.oSSAuth?.securityToken ?? "")
        
        //实例化
        ossClient = OSSClient(endpoint: oSSAuth?.endpoint ?? "", credentialProvider: credential2, clientConfiguration: conf)
    }
    
    
    /// 上传资源model
    /// - Parameters:
    ///   - uploadModel: 资源model
    ///   - progress: 进度
    ///   - sucess: 成功回调 返回model 里面带有上传成功路径
    ///   - failureHandler: 失败回调
    func uploadData(uploadModel: SLUploadDataSourceModel, progress : ((_ progress: CGFloat)->())? = nil, sucess:((String)->())?,failureHandler: ((String, String) -> ())?){
        if let oSSAuth = oSSAuth{
            if oSSAuth.expirationDate.timeIntervalSince1970 <= Date().timeIntervalSince1970{
                self.oSSAuth = nil
            }
        }
        
        if oSSAuth == nil{
            YXSEducationOssAuthTokenRequest().request({ (model: YXSOSSAuthModel) in
                self.oSSAuth = model
                self.initClient()
                self.uploadData(uploadModel: uploadModel, progress: progress,sucess: sucess,failureHandler: failureHandler)
            }, failureHandler: failureHandler)
            return
        }
        
        
        uploadData(uploadModel: uploadModel,ossClient: self.ossClient, progress: progress, sucess: sucess, failureHandler: failureHandler)
    }
    
    
    /// 上传资源model
    /// - Parameters:
    ///   - uploadModel: 资源model
    ///   - ossClient:  阿里云的ossClient
    ///   - progress: 进度
    ///   - sucess: 成功回调 返回model 里面带有上传成功路径
    ///   - failureHandler: 失败回调
    fileprivate func uploadData(uploadModel: SLUploadDataSourceModel, ossClient: OSSClient?, progress : ((_ progress: CGFloat)->())? = nil, sucess:((String)->())?,failureHandler: ((String, String) -> ())?){
        
        let ossPutObj: OSSPutObjectRequest = OSSPutObjectRequest()
        ossPutObj.uploadingData = uploadModel.data
        ossPutObj.bucketName = oSSAuth?.bucket
        ossPutObj.objectKey = uploadModel.path
        
        ossPutObj.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
            progress?(CGFloat(totalBytesSent)/CGFloat(totalBytesExpectedToSend))
        }
        
        let uploadTask = ossClient?.putObject(ossPutObj)
        uploadTask?.continue({ (uploadTask) -> Any? in
            if let _err = uploadTask.error {
                DispatchQueue.main.async {
                    failureHandler?(_err.localizedDescription, "1001")
                }
                
            } else {
                if  let _:OSSPutObjectResult  = uploadTask.result as? OSSPutObjectResult {
                    var point: NSString = (self.oSSAuth?.endpoint ?? "") as NSString
                    point = point.replacingOccurrences(of: "http://", with: "") as NSString
                    point = point.replacingOccurrences(of: "https://", with: "") as NSString
                    let picUrlStr = "http://\(self.oSSAuth?.bucket ?? "").\(point)/\(uploadModel.path)"
                    DispatchQueue.main.async {
                        sucess?(picUrlStr)
                    }
                }else{
                    DispatchQueue.main.async {
                        failureHandler?("链接拼接失败", "1001")
                    }
                }
            }
            return uploadTask
        })
    }
}
