//
//  SLVersionUpdateManager.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/27.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

class SLVersionUpdateManager: NSObject {
    
    private var serviceVersion:String? = nil
    
    static let sharedInstance: SLVersionUpdateManager = {
        let instance = SLVersionUpdateManager()
        // setup code
        return instance
    }()
    
    private override init() {
        model = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.sl_archiveFile(file: "SLVersionUpdateModel")) as? SLVersionUpdateModel
    }
    
    /// 检查更新并自动唤起弹窗
    @objc func checkUpdate() {
        hasNewVersion { [weak self](hasNew) in
            guard let weakSelf = self else {return}
            if hasNew {
                let mandatory = weakSelf.model?.forceUpdate == "YES" ? true : false
                let popView = SLVersionUpdateView(mandatory: mandatory) { (clickType, view) in
                    /// 去苹果商店
                    if clickType == .UPDATE {
//                        view.cancelClick()
                        let updateUrl:URL = URL.init(string: "https://itunes.apple.com/cn/app/id1499944974")!
                        UIApplication.shared.openURL(updateUrl)
                    }
                }
                popView.model = weakSelf.model
                popView.showIn(target: UIUtil.RootController().view)
            }
        }
    }
    
    
    // MARK: - Setter
    var model: SLVersionUpdateModel? {
        didSet {
            if let model = model{
                NSKeyedArchiver.archiveRootObject(model, toFile: NSUtil.sl_archiveFile(file: "SLVersionUpdateModel"))
            }
        }
    }
    
    // MARK: - Other
    @objc func hasNewVersion(completionHandler:@escaping((_ hasNew:Bool)->())) {
        versionRequest { [weak self](model) in
            guard let weakSelf = self else {return}
            if model.version == nil || model.version?.count == 0 {
                completionHandler(false)
                
            } else {
                /*
                进行比较 返回结果为 NSComparisonResult 其中，NSComparisonResult有三个值：
                case OrderedAscending// 小于被比较的值case OrderedSame//等于被比较的值case OrderedDescending//大于被比较的值
                */
                let flag = weakSelf.bundleShortVersion().compare(model.version ?? "", options: NSString.CompareOptions.numeric)
                //如果bundleShortVersion版本号 < model?.version
                if flag == .orderedAscending//.OrderedAscending
                {
                    completionHandler(true)
                    
                } else {
                    completionHandler(false)
                }
            }
        }
    }

    /// 获取当前手机安装使用的版本号
    @objc func bundleShortVersion()->String {
        return NSUtil.BundleShortVersion()
    }
    
    @objc func versionRequest(completionHandler:((_ model: SLVersionUpdateModel)->())?) {
        SLEducationVersionManageLatestRequest().request({ [weak self](model:SLVersionUpdateModel) in
            guard let weakSelf = self else {return}
            weakSelf.model = model
            completionHandler?(model)
            
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
            completionHandler?(SLVersionUpdateModel(JSON: ["":""])!)
        }
    }
    
}
