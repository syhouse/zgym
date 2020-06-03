//
//  YXSPersonDataModel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/14.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import Alamofire
import NightNight

let kYXSPersonDataModelTokenKey = "YXSPersonDataModelTokenKey"


///身份
public enum PersonRole: String{
    case TEACHER
    case PARENT
}

/// 学段
enum StageType: String {
    case KINDERGARTEN//幼儿园
    case PRIMARY_SCHOOL//小学
    case MIDDLE_SCHOOL//中学
}

@objc class YXSPersonDataModel: NSObject {
    @objc static let sharePerson:YXSPersonDataModel = {
        let instance =  YXSPersonDataModel()
        // setup code
        instance.net.startMonitoring()
        instance.net.setReachabilityStatusChange { (status) in
            switch status {
            case .notReachable,.unknown:
                MBProgressHUD.yxs_showMessage(message: "网络连接不可用，请稍后重试", afterDelay: 5.0)
                if isFirstConnect{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0) {
                        MBProgressHUD.yxs_hideHUD()
                        isFirstConnect = false
                        MBProgressHUD.yxs_showMessage(message: "网络连接不可用，请稍后重试", afterDelay: 3.0)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
                            MBProgressHUD.yxs_hideHUD()
                            isFirstConnect = true
                            
                        }
                    }
                }else{
                    MBProgressHUD.yxs_showMessage(message: "网络连接不可用，请稍后重试", afterDelay: 3.0)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
                        MBProgressHUD.yxs_hideHUD()
                        isFirstConnect = true
                    }
                }
                
                instance.isNetWorkingConnect = false
                break
            case .reachableViaWiFi,.reachableViaWWAN:
                MBProgressHUD.yxs_hideHUD()
                isFirstConnect = true
                instance.isNetWorkingConnect = true
                if let vc = UIUtil.TopViewController() as? YXSContentHomeController{
                    vc.loadCategoryData()
                }
            default:
                break
            }
        }
        
        NotificationCenter.default.addObserver(instance, selector: #selector(notificationLogout), name: NSNotification.Name(rawValue: kChatCallChangeRoleLoginOutNotification), object: nil)
        return instance
    }()
    /*
     1.WIFI切换4G时，提示“网络连接不可用，请稍后重试”，直到新连接重新建立后取消提示。

     2.网络断开后，提示“网络连接不可用，请稍后重试”，首次断开后提示时间为５秒；后续操作：切换列表或者刷新当前网页，提示“网络连接不可用，请稍后重试”，提示持续时间为３秒*/
    private static var isFirstConnect = true
    
    
    private override init() {
        userModel = NSKeyedUnarchiver.unarchiveObject(withFile: YXSPersonDataModel.personDataPath) as? YXSEducationUserModel ?? YXSEducationUserModel.init(JSON: ["": ""])
        super.init()
    }
    
    private static let personDataPath = NSUtil.yxs_cachePath(file: "PersonData")
//    private let net = NetworkReachabilityManager()
    private let net = AFNetworkReachabilityManager.shared()
    @objc var userModel:YXSEducationUserModel! {
        didSet{
            if let model = userModel{
                if let accessToken = model.accessToken{
                    token = accessToken
                }
                NSKeyedArchiver.archiveRootObject(model, toFile: YXSPersonDataModel.personDataPath)
            }
        }
    }
    
    public var token: String! = UserDefaults.standard.string(forKey: kYXSPersonDataModelTokenKey) ?? "" {
        didSet{
            UserDefaults.standard.set(token, forKey: kYXSPersonDataModelTokenKey)
        }
    }
    
    /// 是否登陆状态
    public var isLogin: Bool{
        get{
            return token?.count != 0
        }
    }
    
    
    /// 朋友圈消息model
    public var friendsTips: YXSFriendsTipsModel?
    
    /// 用户角色
    public var personRole:PersonRole {
        get{
            return PersonRole.init(rawValue: yxs_user.type ?? "") ?? .PARENT
        }
    }
    
    ///是否是班主任
    public func isMaster(_ classId: Int) -> Bool{
        for model in YXSCacheHelper.yxs_getCacheClassCreateList(){
            if model.id == classId{
                return true
            }
        }
        return false
    }
    
    public var showKINDERGARTENUI: Bool {
        get{
            return (YXSPersonDataModel.sharePerson.personRole == .PARENT && (StageType.init(rawValue:yxs_user.currentChild?.grade?.stage ?? "") ?? StageType.PRIMARY_SCHOOL) == StageType.KINDERGARTEN) || (YXSPersonDataModel.sharePerson.personRole == .TEACHER && self.personStage == .KINDERGARTEN)
        }
    }
    
    //用户学段  老师就是当前自己的学段  家长就是当前选择孩子的学段
    public var personStage:StageType {
        get{
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                return StageType.init(rawValue: yxs_user.stage ?? "") ?? .PRIMARY_SCHOOL
            }else{
                return yxs_user.currentChild?.stage ?? .PRIMARY_SCHOOL
            }
        }
    }
    
    @objc private func notificationLogout(){
        userLogout()
        YXSCommonAlertView.showAlert(title: "下线通知", message: "您的账户于小程序端切换身份")
    }
    
    /// 退出登录
    @objc public func userLogout(){
        YXSEducationUserLogoutRequest().request({ (json) in
            
        }) { (msg, code) in
            
        }
        
        
        
        self.token = ""
        self.userModel = YXSEducationUserModel.init(JSON: ["": ""])
        YXSChatHelper.sharedInstance.logout()
        YXSLocalMessageHelper.shareHelper.yxs_removeAll()
        /// 播放器停止播放
        XMSDKPlayer.shared()?.stopTrackPlay()
        XMSDKPlayer.shared()?.stopLivePlay()
        
        UIApplication.shared.endReceivingRemoteControlEvents()
        try? FileManager.default.removeItem(atPath: YXSPersonDataModel.personDataPath)
        let appdelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.showTabRoot()
    }
    
    /// 当前是否有网络  NetworkReachabilityManager()?.isReachable ?? true
    public var isNetWorkingConnect: Bool = true
    
    public var OSSAuth: YXSOSSAuthModel!
}
