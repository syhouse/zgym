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
    private var oSSAuth: YXSOSSAuthModel!
    private func configuration(){
        let conf = OSSClientConfiguration()
        conf.maxRetryCount = 2
        conf.timeoutIntervalForRequest = 300
        conf.timeoutIntervalForResource = TimeInterval(24 * 60 * 60)
        conf.maxConcurrentRequestCount = 50
        let credential2:OSSCredentialProvider = OSSStsTokenCredentialProvider.init(accessKeyId: self.oSSAuth.accessKeyId ?? "", secretKeyId: self.oSSAuth.accessKeySecret ?? "", securityToken: self.oSSAuth.securityToken ?? "")
        
        //实例化
        ossClient = OSSClient(endpoint: oSSAuth.endpoint ?? "", credentialProvider: credential2, clientConfiguration: conf)
    }
    
    /// 上传多个媒体文件
    func uploadMedias(mediaModels:[PHAsset], progress : ((_ progress: CGFloat)->())? = nil, sucess:(([String])->())?,failureHandler: ((String, String) -> ())?){
//        var infos = [[String: Any]]()
//        for model in mediaModels{
//            if model.asset.mediaType == .image {
//                infos.append([typeKey: SourceNameType.image, modelKey: model])
//
//            } else if model.asset.mediaType == .video {
//                infos.append([typeKey: SourceNameType.video, modelKey: model])
//
//            } else if model.asset.mediaType == .audio {
//                infos.append([typeKey: SourceNameType.voice, modelKey: model])
//            }
//        }
//        uploadMedia(mediaInfos: infos,progress: progress, sucess: { (urls) in
//            var paths = [String]()
//            for url in urls{
//                paths.append((url[urlKey] as? String) ?? "")
//            }
//            sucess?(paths)
//        }, failureHandler: failureHandler)
    }
}
