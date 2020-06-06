//
//  YXSChatHelper.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/11.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper
import NightNight

let kSDKAPPID = 1400295112

class YXSChatHelper: NSObject, TIMMessageListener, TIMUserStatusListener{
    var onUserStatusBlock: (()->())?
    /// 防重复从服务器拿新Usersig
    var isUserSigRequestEnd: Bool = true
    
    @objc static let sharedInstance: YXSChatHelper = {
        let instance = YXSChatHelper()
        // setup code
        return instance
    }()
    
    @objc func config() {
        TUIKit.sharedInstance()?.setup(withAppId: kSDKAPPID)
        TIMManager.sharedInstance()?.add(self)
        /// 不允许打印
        TIMManager.sharedInstance()?.getGlobalConfig()?.disableLogPrint = true
        registNofitication()
    }
    
    // MARK: - Login
    @objc func isLogin()-> Bool {
        if TIMManager.sharedInstance()?.getLoginStatus() == TIMLoginStatus.STATUS_LOGINED {
            /// 判断pushToken是否上传
            return true
        } else {
            return false
        }
    }
    
    @objc func login(completionHandler:(()->())? = nil) {
        
        if !YXSPersonDataModel.sharePerson.isNetWorkingConnect {
            /// 无网络不登录
            return
        }
        
        if YXSPersonDataModel.sharePerson.userModel.type == nil || YXSPersonDataModel.sharePerson.userModel.type?.count ?? 0 == 0 {
//            MBProgressHUD.yxs_showMessage(message: "未获取到用户ID")
            return
        }
        
        ///在登录中ing...
        if TIMManager.sharedInstance()?.getLoginStatus() == TIMLoginStatus.STATUS_LOGINING {
            return
        }
        
        if !isUserSigRequestEnd {
            return
        }
        
        userSigRequest {[weak self](userSig) in
            guard let weakSelf = self else {return}
            let identifier = "\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)\(YXSPersonDataModel.sharePerson.personRole.rawValue)"
            
            let param = TIMLoginParam()
            param.identifier = identifier
            param.userSig = userSig
            
            weakSelf.logout()
            TIMManager.sharedInstance()?.login(param, succ: {
                #if DEBUG
                SLLog("IM登录成功")
                #endif
                weakSelf.uploadPushToken()
                weakSelf.refreshData()
                completionHandler?()
                
            }, fail: { (code, msg) in
                SLLog("IM登录出错：\(msg ?? "")\(code)")
//                MBProgressHUD.yxs_showMessage(message: "\(msg ?? ""):\(code)")
            })
        }

    }
    
    @objc func logout(showError: Bool = false,completionHandler:(()->())? = nil) {
        TIMManager.sharedInstance()?.logout({ [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.refreshApplicationIconBadgeNum()
            completionHandler?()
        }, fail: { (code, msg) in
            if showError{
                MBProgressHUD.yxs_showMessage(message: msg ?? "IM退出登录错误")
            }
        })
    }
    
    // MARK: - Request
    @objc func userSigRequest(completionHandler:@escaping((_ userSig: String)->())) {
        isUserSigRequestEnd = false
        YXSEducationTencentImUserSignRequest().request({ [weak self](json) in
            guard let weakSelf = self else {return}
            weakSelf.isUserSigRequestEnd = true
            completionHandler(json.stringValue)
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            weakSelf.isUserSigRequestEnd = true
            MBProgressHUD.yxs_showMessage(message: "Sig请求出错:\(msg)")
        }
    }
    
    // MARK: - DataConfig
    @objc func refreshData() {
        /// 清除spy会话
        TIMManager.sharedInstance()?.delete(TIMConversationType.C2C, receiver: "spy")
        
        /// 设置未读角标
        let list:[TIMConversation] = TIMManager.sharedInstance()?.getConversationList() ?? [TIMConversation]()
        var unReadCount: Int = 0
        for sub in list {
            if sub.getReceiver() == "spy" {
                continue
            }
            unReadCount += Int(sub.getUnReadMessageNum())
        }
        self.yxs_showBadgeOnItem(index: 3, count: unReadCount)
    }
    
    /// 上传 Token 到腾讯云
    @objc func uploadPushToken() {
        let param = TIMTokenParam()
        /* 用户自己到苹果注册开发者证书，在开发者帐号中下载并生成证书(p12 文件)，将生成的 p12 文件传到腾讯证书管理控制台，控制台会自动生成一个证书 ID，将证书 ID 传入一下 busiId 参数中。*/
        //企业证书 ID
        #if DEBUG
        param.busiId = 18956
        #else
        param.busiId = 18955
        #endif
        if let deviceToken = UserDefaults.standard.data(forKey: kAppleDeviceToken) {
            param.token = deviceToken
        }
        
        TIMManager.sharedInstance()?.setToken(param, succ: { [weak self] in
            guard let weakSelf = self else {return}
            SLLog("-----> 上传 token 成功 ")
            
            
        }, fail: { [weak self](code, msg) in
            guard let weakSelf = self else {return}
            if code == 22003 {
//                weakSelf.registAppleDeviceToken()
            }
            SLLog("-----> 上传 token 失败:\(code)\(msg) ")

        })
    }
    
    // MARK: - Notifaction
    @objc func registNofitication() {
        NotificationCenter.default.addObserver(self, selector: #selector(onUserStatus(notification:)), name: NSNotification.Name(rawValue: TUIKitNotification_TIMUserStatusListener), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeRole), name: NSNotification.Name(rawValue: kMineChangeRoleNotification), object: nil)
    }
        
    // MARK: - CallBack
    /// 切换身份重新登录IM
    @objc func changeRole() {
        if isLogin() {
            logout()
        }
        login()
    }
    
    func onNewMessage(_ msgs: [Any]!) {
        refreshData()
        /// 判断自定义消息
        let arr = msgs as! [TIMMessage]

        for sub:TIMMessage in arr {

            if isServiceMessage(msg: sub) {
                if sub.getConversation()?.getReceiver() == "spy" {
                    /// 标记消息已读
                    sub.getConversation()?.setRead(sub, succ: {
                        SLLog("设置spy消息为已读-成功")
                    }, fail: nil)
                    
                }
                
                let model = msg2IMCustomModel(msg: sub)
                if model.ring == 1 {
                    /// 播放音效
                    YXSSSAudioPlayer.sharedInstance.playMessageSoundEffect()
                }

                if model.serviceType == 105 {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kChatCallRefreshFriendsCircleNotification), object: model)
                }else if model.serviceType == 100 {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kChatCallRefreshPunchCardNotification), object: model)
                }else if model.serviceType == 101 {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kChatCallRefreshHomeworkNotification), object: model)
                }else if model.serviceType == 108 {//身份变更通知
                    let loaclDate: Date = UserDefaults.standard.value(forKey: "localLoginTime") as? Date ?? Date()
                    let localTime = loaclDate.timeIntervalSince1970 * 1000
                    ///切换时间大于登录时间
                    if TimeInterval((model.createTime ?? "0").int ?? 0) > localTime{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kChatCallChangeRoleLoginOutNotification), object: model)
                    }
                }
                else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kChatCallRefreshNotification), object: model)
                }
            } else if isSNSMessage(msg: sub) {
                msg2SNSSystemModel(msg: sub)
                
            } else if isProfileSystemMessage(msg: sub) {
                /// 用户信息变更了
                TIMFriendshipManager.sharedInstance()?.getSelfProfile({ (profile) in
                    TIMFriendshipManager.sharedInstance()?.getUsersProfile([(profile?.identifier ?? "")], forceUpdate: true, succ: { (result) in
                        
                    }, fail: nil)
                }, fail: nil)
                
            }  else {
                /// 播放音效
                YXSSSAudioPlayer.sharedInstance.playMessageSoundEffect()
                
                let receiver = sub.getConversation()?.getReceiver()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUserChatCallRefreshNotification), object: receiver)
            }
        }
    }
    
    
    
    @objc func onUserStatus(notification: NSNotification) {
        let status = notification.object as! Int
        
        switch status {
        /**
         *  踢下线通知
         */
        case Int(TUIUserStatus.TUser_Status_ForceOffline.rawValue):
            if YXSPersonDataModel.sharePerson.isLogin {
                YXSPersonDataModel.sharePerson.userLogout()
            }
            let alert = YXSConfirmationAlertView.showIn(target: UIUtil.RootController().view, hasCancel: false) { (sender, view) in
                view.close()
            }
            alert.lbTitle.text = "下线通知"
            alert.lbContent.text = "您的帐号于另一台手机上登录。"
            break
            
        case Int(TUIUserStatus.TUser_Status_SigExpired.rawValue):
            
            break
        case Int(TUIUserStatus.TUser_Status_ReConnFailed.rawValue):
            
            break
        default:
            break
        }
    }
    
    // MARK: - Other
    
    /// 获取Spy未读消息数组 并 标记其为已读
    @objc func getSpyUnreadMessage(completionHandler:@escaping((_ list:[IMCustomMessageModel]?)->())) {
        if !isLogin() {
            completionHandler(nil)
            return
        }
        
        let conv = TIMManager.sharedInstance()?.getConversation(TIMConversationType.C2C, receiver: "spy")
        conv?.getMessage(conv?.getUnReadMessageNum() ?? 0, last: nil, succ: { [weak self](list) in
            guard let weakSelf = self else {return}
            var tmpArr = [IMCustomMessageModel]()
            for sub in list ?? [TIMMessage]() {
                let msg = sub as? TIMMessage
                if !(msg?.isReaded())! {
                    /// 未读
                    let model: IMCustomMessageModel = weakSelf.msg2IMCustomModel(msg: msg ?? TIMMessage())
                    tmpArr.append(model)
                }
            }
            /// 标记会话为已读
            conv?.setRead(nil, succ: {
                SLLog("标记已读成功")
                completionHandler(tmpArr)
                
            }, fail: { (code, msg) in
                SLLog("标记已读失败:\(code)\(msg ?? "")")
                completionHandler(nil)
            })
            
        }, fail: nil)
    }
    
    @objc func isServiceMessage(msg: TIMMessage)->Bool {
        let elem = msg.getElem(0)
        if elem is TIMCustomElem {
            return true
        } else {
            return false
        }
    }

    @objc func msg2IMCustomModel(msg:TIMMessage)-> IMCustomMessageModel{
        let elem = msg.getElem(0)
        if elem is TIMCustomElem {
            let customElem: TIMCustomElem = elem as! TIMCustomElem
            let json = try? JSON(data: customElem.data)
            let str = String.init(data: customElem.data ?? Data(), encoding: .utf8)
//            SLLog(json)
            print("IM消息>>>>>>>:\(str)")
            let resultModel = Mapper<IMCustomMessageModel>().map(JSONObject:json?.object) ?? IMCustomMessageModel.init(JSON: ["": ""])!
            return resultModel
        }
        return IMCustomMessageModel.init(JSON: ["": ""])!
    }
    
    @objc func isSNSMessage(msg: TIMMessage)->Bool {
        let elem = msg.getElem(0)
        if elem is TIMSNSSystemElem {
            return true
        } else {
            return false
        }
    }
    
    @objc func msg2SNSSystemModel(msg:TIMMessage){
        let elem = msg.getElem(0)
        if elem is TIMSNSSystemElem {
            let snsElem: TIMSNSSystemElem = elem as! TIMSNSSystemElem
            SLLog("TIMSNSSystemElemType:\(snsElem.type)")
            for sub: TIMSNSChangeInfo in snsElem.users {
                SLLog(">>>>1:\(sub.identifier ?? "")")
                SLLog(">>>>2:\(sub.nickname ?? "")")
            }
//            let json = try? JSON(data: snsElem.data)
//            let resultModel = Mapper<IMCustomMessageModel>().map(JSONObject:json?.object) ?? IMCustomMessageModel.init(JSON: ["": ""])!
//            return resultModel
        }
//        return IMCustomMessageModel.init(JSON: ["": ""])!
    }
    
    
    @objc func getServiceMessage() {
        let conversationList = TIMManager.sharedInstance()?.getConversationList() ?? [TIMConversation]()
        for sub in conversationList {
            sub.getMessage(20, last: nil, succ: { (msgs:[Any]?) in
                let msgArr:[TIMMessage] = msgs as! [TIMMessage]
                for msg in msgArr {
                    SLLog("<<<<<<会话ID<<\(msg.getConversation()?.getReceiver() ?? "")")
                    
                    let elem = msg.getElem(0)
                    if elem is TIMCustomElem {
                        let customElem: TIMCustomElem = elem as! TIMCustomElem
                        let json = try? JSON(data: customElem.data)
                        SLLog("json")
                        let resultModel = Mapper<IMCustomMessageModel>().map(JSONObject:json?.object) ?? IMCustomMessageModel.init(JSON: ["": ""])!
                    }
                }
                
            }) { (code, msg) in
                SLLog("错误--->\(code):\(msg)")
            }
        }
    }
    
    @objc func isProfileSystemMessage(msg: TIMMessage)->Bool {
        let elem = msg.getElem(0)
        if elem is TIMProfileSystemElem {
            return true
        } else {
            return false
        }
    }
    
    /// 返回角标数量并自动刷新桌面角标
    @objc func refreshApplicationIconBadgeNum() -> Int32 {
        if isLogin() {
            var unReadCount:Int = 0
            let convs:[TIMConversation] = TIMManager.sharedInstance()?.getConversationList() ?? [TIMConversation]()
            for conv in convs {
                if conv.getType() == .SYSTEM {
                    continue
                }
                unReadCount += Int(conv.getUnReadMessageNum())
            }
            //加上本地红点数量
            if YXSPersonDataModel.sharePerson.personRole == .PARENT{
                unReadCount += YXSLocalMessageHelper.shareHelper.yxs_localMessageCount()
            }
            UIApplication.shared.applicationIconBadgeNumber = unReadCount
            return Int32(unReadCount)
            
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
            return 0
        }
    }

    
    // MARK: -当前主题
    @objc func isNightTheme()->Bool {
        return NightNight.theme == .night ? true : false
    }
}
