//
//  YXSURLProtocol.swift
//  ZGYM
//
//  Created by yanlong on 2020/3/19.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire

//记录请求数量
var requestCount = 0

class YXSURLProtocol: URLProtocol , URLSessionDataDelegate, URLSessionTaskDelegate{
    //NSURLSession数据请求任务
    var dataTask:URLSessionDataTask?
    //url请求响应
    var urlResponse: URLResponse?
    //url请求获取到的数据
    var receivedData: NSMutableData?

    //判断这个 protocol 是否可以处理传入的 request
    override class func canInit(with request: URLRequest) -> Bool {
        //对于已处理过的请求则跳过，避免无限循环标签问题
        if URLProtocol.property(forKey: "MyURLProtocolHandledKey", in: request) != nil {
            return false
        }
        if !(RequsetParamManager.getSharedInstance().isLoadCache ?? false) {
            return false
        }
        return true
    }

    //返回规范化的请求（通常只要返回原来的请求就可以）
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    //判断两个请求是否为同一个请求，如果为同一个请求那么就会使用缓存数据。
    //通常都是调用父类的该方法。我们也不许要特殊处理。
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
//        self.requestIsCacheEquivalent(a, to: b)
//        URLProtocol.requestIsCacheEquivalent(a, to: b)
        return super.requestIsCacheEquivalent(a, to: b)
    }

    //开始处理这个请求
    override func startLoading() {
        requestCount+=1

        print("Request请求\(requestCount): \(String(describing: request.url?.absoluteString))")
        //判断是否有本地缓存
        let reachability = NetworkReachabilityManager()
        if (reachability?.isReachable)! {
            print("===== 从网络获取响应内容 =====")

            let newRequest = self.request
            //NSURLProtocol接口的setProperty()方法可以给URL请求添加自定义属性。
            //（这样把处理过的请求做个标记，下一次就不再处理了，避免无限循环请求）
            URLProtocol.setProperty(true, forKey: "MyURLProtocolHandledKey", in: newRequest as! NSMutableURLRequest)
            //使用NSURLSession从网络获取数据

            let defaultConfigObj = URLSessionConfiguration.default
            let defaultSession = URLSession(configuration: defaultConfigObj,
                                              delegate: self, delegateQueue: nil)
            self.dataTask = defaultSession.dataTask(with: newRequest)
            self.dataTask!.resume()
        }
        else {

            DispatchQueue.main.async {
                //获得Core Data的NSManagedObjectContext
                let delegate = UIApplication.shared.delegate as! AppDelegate
                let context = delegate.context
                DispatchQueue.global().async {
                    let possibleCachedResponse = self.cachedResponseForCurrentRequest(context: context,delegate: delegate)
                    if let cachedResponse = possibleCachedResponse {
                        print("----- 从缓存中获取响应内容 -----")

                        //从本地缓中读取数据
                        let data = cachedResponse.value(forKey: "data") as! NSData?
                        let mimeType = cachedResponse.value(forKey: "mimeType") as! String?
                        let encoding = cachedResponse.value(forKey: "encoding") as! String?

                        //创建一个NSURLResponse 对象用来存储数据。

                        let response = URLResponse(url: self.request.url!, mimeType: mimeType,
                                                   expectedContentLength: data?.length ?? 0,
                                                     textEncodingName: encoding)

                        //将数据返回到客户端。然后调用URLProtocolDidFinishLoading方法来结束加载。
                        //（设置客户端的缓存存储策略.NotAllowed ，即让客户端做任何缓存的相关工作）
                        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                        if data != nil {
                            self.client?.urlProtocol(self, didLoad: data! as Data)
                        }
                        self.client?.urlProtocolDidFinishLoading(self)
                    } else {
                        //请求网络数据
                        print("===== 从网络获取响应内容 =====")
                        let newRequest = self.request
                        //NSURLProtocol接口的setProperty()方法可以给URL请求添加自定义属性。
                        //（这样把处理过的请求做个标记，下一次就不再处理了，避免无限循环请求）
                        URLProtocol.setProperty(true, forKey: "MyURLProtocolHandledKey", in: newRequest as! NSMutableURLRequest)
                        //使用NSURLSession从网络获取数据
                        let defaultConfigObj = URLSessionConfiguration.default
                        let defaultSession = URLSession(configuration: defaultConfigObj,
                                                          delegate: self, delegateQueue: nil)
                        self.dataTask = defaultSession.dataTask(with: newRequest)
                        self.dataTask!.resume()
                    }
                }
            }

        }

    }

    //结束处理这个请求
    override func stopLoading() {
        self.dataTask?.cancel()
        self.dataTask       = nil
        self.receivedData   = nil
        self.urlResponse    = nil
        SLLog("+++++  初始化data  +++++")
    }


    //保存获取到的请求响应数据
    func saveCachedResponse (context:NSManagedObjectContext, data: NSData) {
        print("+++++ 将获取到的数据缓存起来 +++++")
        SLLog("+++++  " + self.request.url!.absoluteString + "  +++++")



        //保存（Core Data数据要放在主线程中保存，要不并发是容易崩溃）
        SLLog("+++++  666添加data\(data.length)  +++++")
        DispatchQueue.global().async {
            let param = RequsetParamManager.getSharedInstance().urlParam

            let paramJson = param?.jsonString()
            //创建NSManagedObject的实例，来匹配在.xcdatamodeld 文件中所对应的数据模型。
            let cachedResponse = NSEntityDescription.insertNewObject(forEntityName: "SLCachedURLResponse", into: context)
            cachedResponse.setValue(data, forKey: "data")
            cachedResponse.setValue(paramJson, forKey: "param")
            cachedResponse.setValue(self.request.url?.absoluteString, forKey: "url")
            cachedResponse.setValue(NSDate(), forKey: "timestamp")
            if self.urlResponse != nil {
                cachedResponse.setValue(self.urlResponse?.mimeType, forKey: "mimeType")
                cachedResponse.setValue(self.urlResponse?.textEncodingName, forKey: "encoding")
            }
            SLLog("+++++  保存data  +++++")
//            let httpResponse: HTTPURLResponse =
//            let etag = httpResponse.allHeaderFields["Etag"]
//            cachedResponse.setValue(etag, forKey: "etag")
            do {
                try context.save()
            } catch {
                print("不能保存：\(error)")
            }
        }

//        dispatch_async(dispatch_get_main_queue(), {
//            do {
//                try context.save()
//            } catch {
//                print("不能保存：\(error)")
//            }
//        })
    }


    //检索缓存请求
    func cachedResponseForCurrentRequest(context:NSManagedObjectContext,delegate: AppDelegate ) -> NSManagedObject? {
        //获得managedObjectContext
        
        let context = delegate.context
        //创建一个NSFetchRequest，通过它得到对象模型实体：SLCachedURLResponse
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "SLCachedURLResponse")
        let entity = NSEntityDescription.entity(forEntityName: "SLCachedURLResponse", in: context)
        fetchRequest.entity = entity

        let param = RequsetParamManager.getSharedInstance().urlParam
        let paramJson = param?.jsonString() ?? ""
        var paramStr = paramJson.replacingOccurrences(of: "{", with: "")
        paramStr = paramStr.replacingOccurrences(of: "}", with: "")
        let paramArr = paramStr.components(separatedBy: ",")

        //设置查询条件
        var predicate = NSPredicate(format: "url == %@ && param == %@", self.request.url!.absoluteString, paramJson)
        switch paramArr.count {
        case 1:
            predicate = NSPredicate(format: "url == %@ && param == %@", self.request.url!.absoluteString, paramJson)
        case 2:
            predicate = NSPredicate(format: "url == %@ && param CONTAINS %@ && param CONTAINS %@", self.request.url!.absoluteString, paramArr[0],paramArr[1])
        case 3:
            predicate = NSPredicate(format: "url == %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@", self.request.url!.absoluteString, paramArr[0],paramArr[1],paramArr[2])
        case 4:
            predicate = NSPredicate(format: "url == %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@", self.request.url!.absoluteString, paramArr[0],paramArr[1],paramArr[2],paramArr[3])
        case 5:
            predicate = NSPredicate(format: "url == %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@", self.request.url!.absoluteString, paramArr[0],paramArr[1],paramArr[2],paramArr[3],paramArr[4])
        case 6:
            predicate = NSPredicate(format: "url == %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@", self.request.url!.absoluteString, paramArr[0],paramArr[1],paramArr[2],paramArr[3],paramArr[4],paramArr[5])
        case 7:
            predicate = NSPredicate(format: "url == %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@", self.request.url!.absoluteString, paramArr[0],paramArr[1],paramArr[2],paramArr[3],paramArr[4],paramArr[5],paramArr[6])
        case 8:
            predicate = NSPredicate(format: "url == %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@", self.request.url!.absoluteString, paramArr[0],paramArr[1],paramArr[2],paramArr[3],paramArr[4],paramArr[5],paramArr[6],paramArr[7])
        case 9:
            predicate = NSPredicate(format: "url == %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@", self.request.url!.absoluteString, paramArr[0],paramArr[1],paramArr[2],paramArr[3],paramArr[4],paramArr[5],paramArr[6],paramArr[7],paramArr[8])
        case 10:
            predicate = NSPredicate(format: "url == %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@", self.request.url!.absoluteString, paramArr[0],paramArr[1],paramArr[2],paramArr[3],paramArr[4],paramArr[5],paramArr[6],paramArr[7],paramArr[8],paramArr[9])
        case 11:
            predicate = NSPredicate(format: "url == %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@", self.request.url!.absoluteString, paramArr[0],paramArr[1],paramArr[2],paramArr[3],paramArr[4],paramArr[5],paramArr[6],paramArr[7],paramArr[8],paramArr[9],paramArr[10])
        case 12:
            predicate = NSPredicate(format: "url == %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@ && param CONTAINS %@", self.request.url!.absoluteString, paramArr[0],paramArr[1],paramArr[2],paramArr[3],paramArr[4],paramArr[5],paramArr[6],paramArr[7],paramArr[8],paramArr[9],paramArr[10],paramArr[11])
        default: break

        }
        fetchRequest.predicate = predicate

        //执行获取到的请求
        do {
            let result = try context.fetch(fetchRequest) as? Array<NSManagedObject>
            if !(result?.isEmpty ?? true) {
                return result?[0]
            }
//            let possibleResult = try context.execute(fetchRequest)
//                as? Array<NSManagedObject>
//            if let result = possibleResult {
//                if !result.isEmpty {
//                    return result[0]
//                }
//            }
        }
        catch {
            print("获取缓存数据失败：\(error)")
        }
        return nil
    }

    //NSURLSessionDataDelegate相关的代理方法
    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        self.urlResponse = response
        SLLog("+++++  清除data\(self.receivedData?.length)  +++++")
        self.receivedData = NSMutableData()
        completionHandler(.allow)
        
    }

    @available(iOS 7.0, *)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.client?.urlProtocol(self, didLoad: data)
        self.receivedData?.append(data)
        SLLog("+++++  添加data\(self.receivedData?.length)  +++++")
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            self.client?.urlProtocol(self, didFailWithError: error!)
        } else {
            if self.receivedData?.length ?? 0 > 0 {
                 let data = NSData.init(data: self.receivedData as! Data)
                //保存获取到的请求响应数据
                DispatchQueue.main.async {
                    //获得Core Data的NSManagedObjectContext
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    let context = delegate.context
                    self.saveCachedResponse(context: context,data: data)
                }
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }


}

