//
//  SLPersonDataModel.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/14.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import Alamofire
import NightNight

let kYMPersonDataModelTokenKey = "SLPersonDataModelTokenKey"


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

@objc class SLPersonDataModel: NSObject {
    @objc static let sharePerson:SLPersonDataModel = {
        let instance =  SLPersonDataModel()
        // setup code
        instance.net?.startListening()
        instance.net?.listener = { status in
            if instance.net?.isReachable ?? false{
                switch status{
                case .notReachable,.unknown:
                    instance.isNetWorkingConnect = false
                case .reachable(.ethernetOrWiFi),.reachable(.wwan):
                    instance.isNetWorkingConnect = true
                }
            } else {
                instance.isNetWorkingConnect = false
            }
        }
        return instance
    }()
    
    private override init() {
        userModel = NSKeyedUnarchiver.unarchiveObject(withFile: SLPersonDataModel.personDataPath) as? SLEducationUserModel ?? SLEducationUserModel.init(JSON: ["": ""])
        super.init()
    }
    
    private static let personDataPath = NSUtil.sl_cachePath(file: "PersonData")
    private let net = NetworkReachabilityManager()
    @objc var userModel:SLEducationUserModel! {
        didSet{
            if let model = userModel{
                if let accessToken = model.accessToken{
                    token = accessToken
                }
                NSKeyedArchiver.archiveRootObject(model, toFile: SLPersonDataModel.personDataPath)
            }
        }
    }
    
    public var token: String! = UserDefaults.standard.string(forKey: kYMPersonDataModelTokenKey) ?? "" {
        didSet{
            UserDefaults.standard.set(token, forKey: kYMPersonDataModelTokenKey)
        }
    }
    
    /// 是否登陆状态
    public var isLogin: Bool{
        get{
            return token?.count != 0
        }
    }
    
    public var friendsTips: SLFriendsTipsModel?
    
    /// 用户角色
    public var personRole:PersonRole {
        get{
            return PersonRole.init(rawValue: sl_user.type ?? "") ?? .PARENT
        }
    }
    
    public var showKINDERGARTENUI: Bool {
        get{
            return (SLPersonDataModel.sharePerson.personRole == .PARENT && (StageType.init(rawValue:sl_user.curruntChild?.grade?.stage ?? "") ?? StageType.PRIMARY_SCHOOL) == StageType.KINDERGARTEN) || (SLPersonDataModel.sharePerson.personRole == .TEACHER && self.personStage == .KINDERGARTEN)
        }
    }
    
    //用户学段  老师就是当前自己的学段  家长就是当前选择孩子的学段
    public var personStage:StageType {
        get{
            if SLPersonDataModel.sharePerson.personRole == .TEACHER{
                return StageType.init(rawValue: sl_user.stage ?? "") ?? .PRIMARY_SCHOOL
            }else{
                return sl_user.curruntChild?.stage ?? .PRIMARY_SCHOOL
            }
        }
    }
    
    /// 退出登录
    public func userLogout(){
        self.token = ""
        self.userModel = SLEducationUserModel.init(JSON: ["": ""])
        SLChatHelper.sharedInstance.logout()
        SLLocalMessageHelper.shareHelper.sl_removeAll()
        try? FileManager.default.removeItem(atPath: SLPersonDataModel.personDataPath)
        let appdelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.showTabRoot()
    }
    public var isNetWorkingConnect: Bool = true
    
    public var OSSAuth: SLOSSAuthModel!
}
