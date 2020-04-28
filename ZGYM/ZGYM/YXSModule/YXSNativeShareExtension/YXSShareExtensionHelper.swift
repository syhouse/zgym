//
//  YXSShareExtensionHelper.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/27.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper

class YXSShareExtensionHelper: NSObject {
    static let sharedInstance: YXSShareExtensionHelper = {
        let instance = YXSShareExtensionHelper()
        // setup code
        return instance
    }()
    
    
    @objc func shareExtensoin(url:URL, completionHandler:((()->())?)) {
        /// 拿到Json字符串
        let strTmp = url.lastPathComponent
        
        /// 转字典
        let data = strTmp.data(using: String.Encoding.utf8)
        let dic = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any]
        if dic == nil {
            /// 字典
            return
        }
        
        ///
        let type = dic?["type"] as? String
        let strFiles = dic?["files"] as? String
        let list = strFiles?.components(separatedBy: ",") ?? [String]()
        
        if type == "satchel" {
            /// 书包
            shareToSatchel(files: list) {
                completionHandler?()
            }
            
        } else if type == "class" {
            /// 班级文件
            shareToClassFile(files: list) {
                completionHandler?()
            }
            
        }
    }
    
    // MARK: - 添加到书包
    @objc func shareToSatchel(files:[String], completionHandler:((()->())?)) {
        /// ShareExtension
        let vc = YXSSatchelFileViewController()
        UIUtil.curruntNav().pushViewController(vc)

        let list = files
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
                DispatchQueue.main.async {
                    vc.loadData()
                }
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - 添加到班级文件
    @objc func shareToClassFile(files:[String], completionHandler:((()->())?)) {
        requestClassList { [weak self](vc, classModel) in
            guard let weakSelf = self else {return}
            
            let dataSrouceArr = weakSelf.files2UploadDatas(files: files)
            
            YXSFileUploadHelper.sharedInstance.uploadDataSource(dataSource: dataSrouceArr, progress: { (progress) in
                
            }, sucess: { (list) in
                YXSFileUploadFileRequest(classId: classModel.id ?? 0, folderId: -1, classFileList: list).request({ (json) in
                    DispatchQueue.main.async {
                        vc.loadData()
                    }

                }) { (msg, code) in
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
    }
    
    // MARK: - Other
    /// 显示班级列表 点击列表 返回相应班级的班级文件页
    @objc func requestClassList(completionHandler:(((_ vc:YXSClassFileViewController, _ classModel:YXSClassModel)->())?)) {
        /// 班级文件
        YXSEducationGradeListRequest().request({ [weak self](json) in
            guard let weakSelf = self else {return}
            var list:[YXSClassModel] = [YXSClassModel]()
            let joinClassList = Mapper<YXSClassModel>().mapArray(JSONString: json["listJoin"].rawString()!) ?? [YXSClassModel]()
            let createClassList = Mapper<YXSClassModel>().mapArray(JSONString: json["listCreate"].rawString()!) ?? [YXSClassModel]()
            
            list += createClassList
            list += joinClassList
            
            
            if list.count > 1 {
                let vc = YXSFileClassListViewController(dataSource: list) { (idx) in
                    let classModel = list[idx]
                    let cfVc = YXSClassFileViewController(classId: classModel.id ?? 0, parentFolderId: -1)
                    completionHandler?(cfVc, classModel)
                    UIUtil.curruntNav().pushViewController(cfVc)
                }
                UIUtil.curruntNav().pushViewController(vc)
                
            } else if list.count == 1 {
                if let classModel = list.first {
                    let vc = YXSClassFileViewController(classId: classModel.id ?? 0, parentFolderId: -1)
                    completionHandler?(vc, classModel)
                    UIUtil.curruntNav().pushViewController(vc)
                }

            } else {
                MBProgressHUD.yxs_showMessage(message: "暂未班级")
            }
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    /// Native分享过来拿到的文件名 转成 上传模型
    @objc func files2UploadDatas(files:[String]) -> [YXSUploadDataResourceModel] {
        let list = files
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
        
        return uploadArr
    }
}
