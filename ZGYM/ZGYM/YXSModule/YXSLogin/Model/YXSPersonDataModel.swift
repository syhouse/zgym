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
                instance.isNetWorkingConnect = false
                break
            case .reachableViaWiFi,.reachableViaWWAN:
                instance.isNetWorkingConnect = true
                if let vc = UIUtil.TopViewController() as? YXSContentHomeController{
                    vc.loadCategoryData()
                }
            default:
                break
            }
        }
        return instance
    }()
    
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
    
    public var showKINDERGARTENUI: Bool {
        get{
            return (YXSPersonDataModel.sharePerson.personRole == .PARENT && (StageType.init(rawValue:yxs_user.curruntChild?.grade?.stage ?? "") ?? StageType.PRIMARY_SCHOOL) == StageType.KINDERGARTEN) || (YXSPersonDataModel.sharePerson.personRole == .TEACHER && self.personStage == .KINDERGARTEN)
        }
    }
    
    //用户学段  老师就是当前自己的学段  家长就是当前选择孩子的学段
    public var personStage:StageType {
        get{
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                return StageType.init(rawValue: yxs_user.stage ?? "") ?? .PRIMARY_SCHOOL
            }else{
                return yxs_user.curruntChild?.stage ?? .PRIMARY_SCHOOL
            }
        }
    }
    
    /// 退出登录
    public func userLogout(){
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
