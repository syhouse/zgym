//
//  YXSShareExtensionHelper.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/27.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit

class YXSShareExtensionHelper: NSObject {
    static let sharedInstance: YXSShareExtensionHelper = {
        let instance = YXSShareExtensionHelper()
        // setup code
        return instance
    }()
    
    /// 添加到书包
    @objc func shareToSatchel(url:URL, completionHandler:((()->())?)) {
        /// ShareExtension
        let vc = YXSSatchelFileViewController()
        UIUtil.curruntNav().pushViewController(vc)
        
        let list = url.lastPathComponent.components(separatedBy: ",")
        var uploadArr:[YXSUploadDataResourceModel] = [YXSUploadDataResourceModel]()
        
        for sub in list {
            
            let fileName = sub
            let extName = sub.pathExtension.lowercased()
            let url = YXSFileManagerHelper.sharedInstance.getFullPathURL(lastPathComponent: fileName)
            let size = YXSFileManagerHelper.sharedInstance.sizeMbOfFilePath(filePath: url)

            let model = YXSUploadDataResourceModel()
            
            if extName == "mov" || extName == "mp4" {
                model.bgImage = YXSFileUploadHelper.sharedInstance.getVideoFirstPicture(url: url)
                let semaphore = DispatchSemaphore(value: 0)
                YXSFileUploadHelper.sharedInstance.video2Mp4(url: url) { (data, newUrl) in
                    model.fileName = newUrl?.lastPathComponent
                    model.dataSource = data
                    uploadArr.append(model)
                    semaphore.signal()
                }
                semaphore.wait()
                
            } else {
                model.fileName = fileName
                model.dataSource = try? Data(contentsOf: url)
                uploadArr.append(model)
            }
        }
        
        YXSFileUploadHelper.sharedInstance.uploadDataSource(dataSource: uploadArr, progress: nil, sucess: { (list) in
            YXSSatchelUploadFileRequest(parentFolderId: -1, satchelFileList: list).request({ (json) in
                vc.loadData()
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
}
