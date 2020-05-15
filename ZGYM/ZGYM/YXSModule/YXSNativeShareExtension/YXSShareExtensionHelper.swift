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
    
    @objc func checkShareExtension(completionHandler:((()->())?)) {
        
        if UIUtil.RootController() is YXSBaseTabBarController {
            if let obj = UserDefaults.standard.url(forKey: "kReceiveShareExtension") {
                
                shareExtensoin(url: obj) {
                    UserDefaults.standard.removeObject(forKey: "kReceiveShareExtension")
                    UserDefaults.standard.synchronize()
                    completionHandler?()
                }
            }
        }
    }
    
    @objc func shareExtensoin(url:URL, completionHandler:((()->())?)) {
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            MBProgressHUD.yxs_showMessage(message: "家长身份无权添加文件", afterDelay: 3.0)
            return
        }
        
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
        UIUtil.currentNav().pushViewController(vc)
        
        let uploadArr = files2UploadDatas(files: files)
        
        let obj = UserDefaults.standard.url(forKey: "kReceiveShareExtension")
        if obj == nil { return }
        MBProgressHUD.yxs_showLoading(inView: vc.view)
        YXSFileUploadHelper.sharedInstance.uploadDataSource(dataSource: uploadArr, storageType: .satchel, progress: nil, sucess: { (list) in
            
            YXSSatchelUploadFileRequest(parentFolderId: -1, satchelFileList: list).request({ (json) in
                DispatchQueue.main.async {
                    MBProgressHUD.yxs_hideHUDInView(view: vc.view)
                    MBProgressHUD.yxs_showMessage(message: "上传成功")
                    completionHandler?()
                    vc.loadData2()
                }
                
            }) { (msg, code) in
                DispatchQueue.main.async {
                    MBProgressHUD.yxs_hideHUDInView(view: vc.view)
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
            }
            
        }) { (msg, code) in
            DispatchQueue.main.async {
                MBProgressHUD.yxs_hideHUDInView(view: vc.view)
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
    }
    
    // MARK: - 添加到班级文件
    @objc func shareToClassFile(files:[String], completionHandler:((()->())?)) {
        /// 请求班级列表 并push进选中的班级文件列表
        requestClassList { [weak self](vc, classModel) in
            guard let weakSelf = self else {return}
            
            let dataSrouceArr = weakSelf.files2UploadDatas(files: files)
            
            let obj = UserDefaults.standard.url(forKey: "kReceiveShareExtension")
            if obj == nil { return }
            
            MBProgressHUD.yxs_showLoading(inView: vc.view)
            YXSFileUploadHelper.sharedInstance.uploadDataSource(dataSource: dataSrouceArr, storageType: .classFile, classId: classModel.id, progress: { (progress) in
                
            }, sucess: { (list) in
                YXSFileUploadFileRequest(classId: classModel.id ?? 0, folderId: -1, classFileList: list).request({ (json) in
                    DispatchQueue.main.async {
                        MBProgressHUD.yxs_hideHUDInView(view: vc.view)
                        MBProgressHUD.yxs_showMessage(message: "上传成功")
                        completionHandler?()
                        vc.loadData2()
                    }

                }) { (msg, code) in
                    DispatchQueue.main.async {
                        MBProgressHUD.yxs_hideHUDInView(view: vc.view)
                        MBProgressHUD.yxs_showMessage(message: msg)
                    }
                }
                
            }) { (msg, code) in
                DispatchQueue.main.async {
                    MBProgressHUD.yxs_hideHUDInView(view: vc.view)
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
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
            
            if list.count == 1 {
                if let classModel = list.first {
                    let vc = YXSClassFileViewController(classId: classModel.id ?? 0, parentFolderId: -1)
                    completionHandler?(vc, classModel)
                    UIUtil.currentNav().pushViewController(vc)
                }

            } else if list.count > 1 {
                let vc = YXSFileClassListViewController(dataSource: list) { (idx) in
                    let classModel = list[idx]
                    let cfVc = YXSClassFileViewController(classId: classModel.id ?? 0, parentFolderId: -1)
                    completionHandler?(cfVc, classModel)
                    UIUtil.currentNav().pushViewController(cfVc)
                }
                UIUtil.currentNav().pushViewController(vc)
                
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
