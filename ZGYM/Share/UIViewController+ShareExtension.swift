//
//  UIViewController+ShareExtension.swift
//  Share
//
//  Created by Liu Jie on 2020/3/25.
//  Copyright © 2020 LiuJie. All rights reserved.
//

import UIKit

struct MyError: Error {
    var localizedDescription: String
}

/// MaxFileSize 支持最大文件50M
public let maxFileSize: CGFloat = 50.0


extension UIViewController {
    
    /// 取消分享
    @objc func shareExtension_Cancel() {
        self.extensionContext?.cancelRequest(withError: MyError(localizedDescription: ""))
    }
    
    /// 获取数据
    @objc func shareExtension_LoadDataSource(completionHandler:@escaping ((_ filesPath:[URL])->())) {
        
        var listUrl = [URL]()
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "queue")
        
        for inputItem in self.extensionContext?.inputItems.compactMap({ $0 as? NSExtensionItem }) ?? [] {
            for itemProvider: NSItemProvider in inputItem.attachments ?? [] {
                
                if let typeIdentifiers = itemProvider.registeredTypeIdentifiers.first {
                    group.enter()
                    queue.async {
                        self.shareExtension_GetUrl(itemProvider: itemProvider, typeIdentifier: typeIdentifiers, completionHandler: { (url) in
                                          
                            listUrl.append(url)
                            group.leave()
//                            print(">>>>>>>>1:Count:\(listUrl.count)>>>\(url)")
                                  
                        }) { (errMsg) in
                            group.leave()
                        }
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            DispatchQueue.main.async {
//                print(">>>>>>>>2:Count:\(listUrl.count)")
                completionHandler(listUrl)
            }
        }
    }
    
    /// 获取单个分享URL
    @objc private func shareExtension_GetUrl(itemProvider: NSItemProvider, typeIdentifier: String, completionHandler:@escaping ((_ result: URL)->()), failureHandler:@escaping((_ message: String)->())) {
        itemProvider.loadItem(forTypeIdentifier: typeIdentifier, options: nil) { [weak self](data, error) in
            
            guard let weakSelf = self else {return}
            
            guard error == nil else {
                weakSelf.extensionContext?.cancelRequest(withError: error!)
                return
            }
                
            guard let element = data as? URL else {
                weakSelf.extensionContext?.cancelRequest(withError: MyError(localizedDescription: "点击取消处理失败"))
                return
            }
            
            // element 就是分享内容的 URL，可以在此保存备用。
            if YXSFileManagerHelper.sharedInstance.sizeMbOfFilePath(filePath: element) > maxFileSize {
                failureHandler("文件不得大于50MB")
                
            } else {
                completionHandler(element)
            }
        }
    }
    
    /// 打开主APP
    func shareExtension_OpenContainerApp(filesName: String) {

        var scheme = "\(shareExtensionSchemes):///\(filesName)"
        /// URL含有中文的处理
        scheme = scheme.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        if let url = URL(string: scheme) {
            
            let context = NSExtensionContext()
            context.open(url, completionHandler: nil)

            var responder = self as UIResponder?
            let selectorOpenURL = sel_registerName("openURL:")

            while (responder != nil) {
                
                if responder!.responds(to: selectorOpenURL) {
                    
                    responder!.perform(selectorOpenURL, with: url)
                    break
                }
                responder = responder?.next
            }
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
}
