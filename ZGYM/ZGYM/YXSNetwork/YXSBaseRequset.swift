//
//  YXSBaseRequset.swift
//  EsayFreeBook
//
//  Created by mac on 2019/7/18.
//  Copyright © 2019 mac_HM. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON



public enum ServiceType: String {
    case ServiceProduct//生产
    case ServiceTest//测试
    case ServiceLocal//本地
    
    func getServiceUrl() -> String{
        switch self {
        case .ServiceProduct:
            return "https://pro.c989.cn:54321/"
        case .ServiceTest:
            return "http://test.zhixun5588.com/"
        case .ServiceLocal:
            return "http://edu.zhixun5588.com/"
        }
    }
//    http://www.ym698.com/lscj
    
    func getH5Url() -> String{
        switch self {
        case .ServiceProduct:
            return "https://pro.c989.cn:50009/"
        case .ServiceTest:
            return "https://pro.c989.cn:50009/"
        case .ServiceLocal:
            return "https://pro.c989.cn:50009/"
        }
    }
}


//接口环境
public let sericeType:ServiceType = .ServiceTest

let defaultBaseTimeOutInterval: TimeInterval = 10
//host 首页相关业务
let homeHost = sericeType.getServiceUrl() + "classmatter-api"
//host 首页相关业务
let fileHost = sericeType.getServiceUrl() + "file-api"
//host oss上传相关业务
let ossHost =  sericeType.getServiceUrl() + "oss-api"

//单例类 用于保存请求参数
class RequsetParamManager {
    public var urlParam: Parameters?
    public var isLoadCache: Bool? = false
    private static var _sharedInstance:RequsetParamManager?
    class func getSharedInstance() -> RequsetParamManager {
        guard let instance = _sharedInstance else {
            _sharedInstance = RequsetParamManager()
            return _sharedInstance!
        }
        return instance
    }
    //私有化init方法
    private init(){}

    //销毁单例对象
    class func destroy() {
        _sharedInstance = nil
    }


}

class YXSBaseRequset: NSObject {
    //默认host 用户相关业务
    var host: String =  sericeType.getServiceUrl() + "user-api"
    var classHost: String = sericeType.getServiceUrl() + "synch-classroom"
    var path: String = ""
    var isUploadImage = false

    /// 是否加载缓存
    var isLoadCache = false

    var encoding: ParameterEncoding = URLEncoding.default
    var method = HTTPMethod.post {
        didSet {
            encoding = method == HTTPMethod.post ? JSONEncoding.default : URLEncoding.default
        }
    }
    var headers = [String : String]()
    var param: Parameters?
    var timeoutInverval: TimeInterval = defaultBaseTimeOutInterval
    
    var manager: SessionManager!
    
    var urlPath: String! {
        return "\(host)"
    }
    
    var destinationJsonPaths: [String] = [String]()

    

    override init() {
        super.init()
        isLoadCache = false
        RequsetParamManager.getSharedInstance().isLoadCache = isLoadCache
    }

    func addHeaders() {
        headers["Access-Token"] = YXSPersonDataModel.sharePerson.token ?? ""
        headers["Content-Type"] = "application/json"
        
        /// IP地址
        headers["User-IP-Address"] = NSUtil.getIPAddressFromDNSQuery(url: "www.baidu.com") ?? "unkonw"
        /// 机型
        let sysVersion = UIDevice.current.systemName + UIDevice.current.systemVersion
        headers["Device-Model"] = "\(NSUtil.deviceModel()):\(sysVersion)"
        /// mac特征码
        headers["Mac-Code"] = NSUUID().uuidString
        /// imsi
        headers["Imsi"] = NSUtil.getImsi() ?? "unkonw"
    }
    
    func cleanCookies() {
        let array:NSArray = HTTPCookieStorage.shared.cookies! as NSArray
        
        for cookieie in array{
            if let cookie:HTTPCookie = cookieie as? HTTPCookie{
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    func request(_ completion: ((JSON) -> ())?,
                 failureHandler: ((String, String) -> ())?) {
        
        let complete: (DataResponse<Any>) -> Void = { response in
            switch response.result {
            case .success:
                
                let resutlValue = response.result.value
                let resultJson = JSON(resutlValue ?? "");
                let code = resultJson["code"].stringValue
                if code == "0"{
                    SLLog(resultJson.stringValue)

                    completion?(resultJson["data"])
                }else{
                    //message
                    var msg: String = resultJson["msg"].stringValue
                    if msg.count == 0{
                        msg = resultJson["message"].stringValue
                    }
                    failureHandler?(msg, "\(code)")
                    
                    if code == "201"{//授权无效
                        YXSPersonDataModel.sharePerson.userLogout()
                    }
                }
            case .failure(let error):
                self.delError(error, failureHandler: failureHandler)
                
            }
        }
        requset(complete: complete,failureHandler: failureHandler)
    }
    
    /**
     请求 数据 返回 model
     
     - parameter completion:     成功 返回值
     - parameter result:         遵循 Mappable
     - parameter failureHandler: 失败 返回
     - parameter err_code:       错误码
     */
    func request<T: Mappable>(_ completion: ((T) -> ())?,
                              failureHandler: ((String, String) -> ())?) {
        let complete: (DataResponse<Any>) -> Void = { response in
            switch response.result {
            case .success:
                let resutlValue = response.result.value
                let resultJson = JSON(resutlValue ?? "")
                var resultJsonModel = resultJson["data"]
                var resultModel: T = T.init(JSON: ["": ""])!
                
                for key in self.destinationJsonPaths{
                    resultJsonModel = resultJsonModel[key]
                }
                resultModel = Mapper<T>().map(JSONObject:resultJsonModel.object) ?? T.init(JSON: ["": ""])!
                let code = resultJson["code"].stringValue
                if code == "0"{
                    SLLog(resultJson.stringValue)
                    completion?(resultModel)
                }else{
                    //message
                    var msg: String = resultJson["msg"].stringValue
                    if msg.count == 0{
                        msg = resultJson["message"].stringValue
                    }
                    failureHandler?(msg, "\(code)")
                    if code == "201"{//授权无效
                        YXSPersonDataModel.sharePerson.userLogout()
                    }
                }
            case .failure(let error):
                self.delError(error, failureHandler: failureHandler)
                
            }
        }
        
        requset(complete: complete,failureHandler: failureHandler)
    }
    
    /**
     请求 数据 返回 固定格式
     - parameter completion:     成功 返回值
     - parameter result:         遵循 Mappable
     - parameter failureHandler: 失败 返回
     - parameter err_code:       错误码
     */
    func requestCollection<T: Mappable>(_ completion: (([T]) -> ())?,
                                        failureHandler: ((String, String) -> ())?) {
        let complete: (DataResponse<Any>) -> Void = { response in
            switch response.result {
            case .success:
                let resutlValue = response.result.value
                let resultJson = JSON(resutlValue ?? "")
                var resultJsonModels = resultJson["data"]
                
                var resultModel: [T] = [T]()
                
                for key in self.destinationJsonPaths{
                    resultJsonModels = resultJsonModels[key]
                }
                
                resultModel = Mapper<T>().mapArray(JSONObject: resultJsonModels.object) ?? [T]()
 
                let code = resultJson["code"].stringValue
                if code == "0"{
//                    SLLog(resultJson.stringValue)
                    completion?(resultModel)
                }else{
                    //message
                    var msg: String = resultJson["msg"].stringValue
                    if msg.count == 0{
                        msg = resultJson["message"].stringValue
                    }
                    failureHandler?(msg, "\(code)")
                    if code == "201"{//授权无效
                        YXSPersonDataModel.sharePerson.userLogout()
                    }
                }
            case .failure(let error):
                self.delError(error, failureHandler: failureHandler)
            }
            //清除请求参数
            RequsetParamManager.getSharedInstance().urlParam = nil
        }
        
        requset(complete: complete,failureHandler: failureHandler)
    }
    
    func delError(_ error: Error,failureHandler: ((String, String) -> ())?){
        let code = (error as NSError).code
        if code == 401{
            
        }else{
            failureHandler?("网络不给力，请稍后重试", "\(code)")
        }
        //清除请求参数
        RequsetParamManager.getSharedInstance().urlParam = nil
    }
    
    func requset(complete: (@escaping (DataResponse<Any>) -> Void),failureHandler: ((String, String) -> ())?){
        cleanCookies()
        addHeaders()
        RequsetParamManager.getSharedInstance().isLoadCache = isLoadCache
        if param != nil {
            RequsetParamManager.getSharedInstance().urlParam = param
        }
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInverval
        configuration.httpMaximumConnectionsPerHost = 10

        if isLoadCache {
            configuration.protocolClasses!.insert(YXSURLProtocol.self, at: 0)
//            let reachability = NetworkReachabilityManager()
//            if (reachability?.isReachable)! {
//                configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
//            }else
//            {
//                configuration.requestCachePolicy = .returnCacheDataElseLoad
//            }
        }
        else {
            if YXSPersonDataModel.sharePerson.isNetWorkingConnect == false{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                    failureHandler?("网络不给力，请检查网络","999")
                }
                return
            }
        }
        
        manager = Alamofire.SessionManager(configuration: configuration)
        manager.delegate.sessionDidReceiveChallenge = {
            session,challenge in
            return    (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
        }

        SLLog(host+path)
        SLLog(param)
        if isUploadImage {
            manager.upload(multipartFormData: { (formData) in
                for param in self.param!{
                    formData.append(param.value as! Data, withName: "file" , fileName: param.key, mimeType: "image/png")
                    
                }
                
            }, to: URL.init(string: host+path)!) { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON(completionHandler: complete).session.finishTasksAndInvalidate()
                case .failure(_):
                    failureHandler?("图片上传错误", "\(201)")
                }
            }
        }else{
            manager.request(host+path,
                            method: method,
                            parameters: param,
                            encoding: encoding,
                            headers: headers).responseJSON(completionHandler: complete).session.finishTasksAndInvalidate()
        }
    }
    
}
