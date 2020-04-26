//
//  AppDelegate.swift
//  ZGYM
//
//  Created by hunanyoumeng on 2020/2/11.
//  Copyright © 2020 zgjy_mac. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftyJSON
import Bugly
import NightNight
import Alamofire
import CoreData
import MediaPlayer
import SDWebImage
//import LifetimeTracker

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    var window: UIWindow?
    
    
    /// 是否是第一次启动
    var isFirst:Bool{
        get{
            !UserDefaults.standard.bool(forKey: kIsNotFirstLuanchKey)
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        registAppleDeviceToken()
        
        initSystemConfigRoot()
        
        SLLog(NSUtil.yxs_cachePath())
        // MARK: -config Thrid
        
        // MARK: -IM
        YXSChatHelper.sharedInstance.config()
        
        // MARK: -高德地图
        YXSAMapManager.share().configured()

        // MARK: -夜间模式  默认设置夜间模式   默认打开设置夜间模式
//        iOS 13以上系统跟随系统模式展示日夜间   以下系统通过app自己控制
        if #available(iOS 13.0, *){
            //系统黑夜模式
            if UITraitCollection.current.userInterfaceStyle == .dark{
                NightNight.theme = .night
            }else{
                NightNight.theme = .normal
            }
        }else{
            if isFirst{
                NightNight.theme = .normal
            }
        }
        
        UIUtil.setCommonThemeConfig()
        // MARK: -push
//        let entity = JPUSHRegisterEntity()
//        entity.types = 1 << 0 | 1 << 1 | 1 << 2
        
//        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
//        JPUSHService.setup(withOption: launchOptions, appKey: JGAppkey, channel: "App Store", apsForProduction: false, advertisingIdentifier: nil)
        //销毁通知红点
        //        UIApplication.shared.applicationIconBadgeNumber = 0
        //        JPUSHService.setBadge(0)
        //        UIApplication.shared.cancelAllLocalNotifications()
        // MARK: -Bugly
        Bugly.start(withAppId: "366980be21")
        
        // MARK: -WXApi
        WXApi.registerApp(KWXAPPID, universalLink: KWXUNIVERSAL_LINK)
        // MARK: -TencentOAuth
        _ = TencentOAuth.init(appId: KQQAPPID, andUniversalLink: KQQ_LINK, andDelegate: self)

        //注册URL Loading System协议，让每一个请求都会经过MyURLProtocol处理
        URLProtocol.registerClass(YXSURLProtocol.classForCoder())

        // MARK: -DeBugFlex  调试器
        #if DEBUG
        FLEXManager.shared()?.showExplorer()
        #endif

//        // MARK: -创建网络缓存
//        NetworkReachabilityManager.init()?.startListening()
//        let urlCache = URLCache.init(memoryCapacity: 4*1024*1024, diskCapacity: 20*1024*1024, diskPath: nil)
//        URLCache.shared = urlCache
        
//        #if DEBUG  内存泄漏检测工具
//            LifetimeTracker.setup(onUpdate: LifetimeTrackerDashboardIntegration(visibility: .alwaysVisible, style: .bar).refreshUI)
//        #endif
        
        
        // MARK: - xmly
        registerXMLY()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.absoluteString.contains(shareExtensionSchemes) {
            /// ShareExtension
            let list = url.lastPathComponent.components(separatedBy: ",")
            var uploadArr:[YXSUploadDataResourceModel] = [YXSUploadDataResourceModel]()
            for sub in list {
                let fileName = sub
                let url = YXSFileManagerHelper.sharedInstance.getFullPathURL(lastPathComponent: fileName)
                let size = YXSFileManagerHelper.sharedInstance.sizeMbOfFilePath(filePath: url)

                let model = YXSUploadDataResourceModel()
                
                if fileName.pathExtension == "MOV" {
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
                
            }) { (msg, code) in
                
            }
            
            return true
        }
        
        let qqShare = QQApiInterface.handleOpen(url, delegate: HMQQShareResponseTool.shareTool)
        if qqShare{
            return qqShare
        }
        return WXApi.handleOpen(url, delegate: YXSShareTool.shareTool)
    }
    
    //微信UniversalLink需要
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let url = userActivity.webpageURL
        
        if TencentOAuth.canHandleUniversalLink(url){
            QQApiInterface.handleOpenUniversallink(url, delegate: HMQQShareResponseTool.shareTool)
            return TencentOAuth.handleUniversalLink(url)
        }
        return WXApi.handleOpenUniversalLink(userActivity, delegate: YXSShareTool.shareTool)
    }
    
    //点推送进来执行这个方法
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        SLLog("----->推送打开结果:\(userInfo)")
        if UIApplication.shared.applicationState == .active {
            //当APP在前台运行时，不做处理
            
        } else if UIApplication.shared.applicationState == .inactive {
            //当APP在后台运行时，当有通知栏消息时，点击它，就会执行下面的方法跳转到相应的页面
            UserDefaults.standard.set(userInfo, forKey: "kReceiveRemoteNotification")
            UserDefaults.standard.synchronize()
            YXSGlobalJumpManager.sharedInstance.checkPushJump()
        }
        
        
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    //系统获取Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UserDefaults.standard.set(deviceToken, forKey: kAppleDeviceToken)
        UserDefaults.standard.synchronize()
        JPUSHService.registerDeviceToken(deviceToken)
    }
    

    
    //获取token 失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { //可选
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        var bgTaskID: UIBackgroundTaskIdentifier!
        bgTaskID = application.beginBackgroundTask(expirationHandler: {
            //不管有没有完成，结束 background_task 任务
            application.endBackgroundTask(bgTaskID!)
            bgTaskID = UIBackgroundTaskIdentifier.invalid
        })
        
        //获取未读计数
        let unReadCount = YXSChatHelper.sharedInstance.refreshApplicationIconBadgeNum()
        
        //doBackground
        let param = TIMBackgroundParam()
        param.c2cUnread = Int32(unReadCount)
        TIMManager.sharedInstance()?.doBackground(param, succ: {
            SLLog("----->doBackgroud Succ")
        }, fail: { (code, msg) in
            SLLog("Fail----->: \(code)->\(msg ?? "")")
        })
        
        
        ///如果xmly播放器存在  开启锁屏控制
        if XMSDKPlayer.shared()?.playerState != .stop{
            UIUtil.configNowPlayingCenterUI()
            UIApplication.shared.beginReceivingRemoteControlEvents()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        TIMManager.sharedInstance()?.doForeground({
            SLLog("----->doForegroud Succ")
        }, fail: { (code, msg) in
            SLLog("Fail----->: \(code)->\(msg ?? "")")
        })
        
        ///如果xmly播放器存在  开启锁屏控制
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
    // MARK: -Other
    /// 向苹果后台请求 DeviceToken
    @objc func registAppleDeviceToken() {
        if #available(iOS 10, *){
            let application = UIApplication.shared
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
        } else if #available(iOS 8, *){
            let center = UNUserNotificationCenter.current()
            center.delegate = self as! UNUserNotificationCenterDelegate
            center.requestAuthorization(options: UNAuthorizationOptions.alert) { (isSucceseed: Bool, error:Error?) in
                 
                if isSucceseed == true{
                    print( "成功")
                }else{
                    print( "失败")
                    print("error = \(error)")
                }
            }
            UIApplication.shared.registerForRemoteNotifications()
            
        } else {
            let type = UIRemoteNotificationType.alert.rawValue | UIRemoteNotificationType.badge.rawValue | UIRemoteNotificationType.sound.rawValue
            UIApplication.shared.registerForRemoteNotifications(matching: UIRemoteNotificationType(rawValue: type))
        }
    }

    // MARK: - CoreData
    lazy var managedObjectModel: NSManagedObjectModel = {
        var modelURL = Bundle.main.url(forResource: "ZGYMEducation", withExtension: "mom")
        if modelURL == nil {
            modelURL = Bundle.main.url(forResource: "ZGYMEducation", withExtension: "momd")
        }
        let managedObjectModel = NSManagedObjectModel.init(contentsOf: modelURL!)
        return managedObjectModel!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: managedObjectModel)
        let sqliteURL = documentDir.appendingPathComponent("ZGYMEducation.sqlite")
        let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        var failureReason = "创建NSPersistentStoreCoordinator时出现错误"

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqliteURL, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "初始化NSPersistentStoreCoordinator失败" as Any?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as Any?
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 6666, userInfo: dict)
            print("未解决的错误： \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return persistentStoreCoordinator
    }()

    lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()

    lazy var documentDir: URL = {
        let documentDir = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
        return documentDir!
    }()
}

// MARK: - RootUI
extension AppDelegate{
    private func initSystemConfigRoot(){
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = YXSSystemConfigController()
    }
    
    /// 切换根视图控制器
    public func showTabRoot(){
        let loginNav = YXSRootNavController.init(rootViewController: YXSLoginViewController())
        var curruntRootVc:UIViewController?
        
//        if isFirst{
//            //首次登录
//            curruntRootVc = YXSFirstLaunchController()
//            UserDefaults.standard.set(true, forKey: kIsNotFirstLuanchKey)
//        }else
            
            if yxs_user.accessToken == nil || yxs_user.type == nil || !YXSPersonDataModel.sharePerson.isLogin{
            //未登录或未选身份
            curruntRootVc = loginNav
            
        }else if yxs_user.name == nil || yxs_user.name?.count ?? 0 == 0{
            //未选昵称和学段
            let vc = YXSChoseNameStageController(role: YXSPersonDataModel.sharePerson.personRole) { [weak self](name, index, vc) in
                guard let weakSelf = self else {return}
                var stage: StageType = .KINDERGARTEN
                switch index {
                case 0:
                    stage = .KINDERGARTEN
                case 1:
                    stage = .PRIMARY_SCHOOL
                default:
                    stage = .MIDDLE_SCHOOL
                    
                }
                weakSelf.choseTypeRequest(name: name, userType: YXSPersonDataModel.sharePerson.personRole, stage: stage) {
                    weakSelf.showTabRoot()
                }
            }
            curruntRootVc = YXSRootNavController(rootViewController: vc)
            
        } else {
            //正常进入首页
            curruntRootVc = YXSBaseTabBarController()
                
        }
        window?.rootViewController = curruntRootVc
        
        if XMSDKPlayer.shared()?.playerState != .stop{
            YXSMusicPlayerWindowView.updateSuperView()
        }
        
        
        yxs_dealRootUI()
        yxs_addUI()
        yxs_changeUI(false)
    }
    
    func choseTypeRequest(name:String, userType:PersonRole, stage: StageType?, completionHandler:(()->())?) {

        MBProgressHUD.yxs_showLoading()
        YXSEducationUserChooseTypeRequest.init(name: name, userType: userType, stage: stage).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            
            weakSelf.yxs_user.name = name
            if userType == .TEACHER {
                weakSelf.yxs_user.stage = stage?.rawValue
            }
            completionHandler?()
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
}

// MARK: - TencentSessionDelegate
extension AppDelegate: TencentSessionDelegate{
    func tencentDidLogin() {
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
    }
    
    func tencentDidNotNetWork() {
    }
}

// MARK: - other func
extension AppDelegate{
    func yxs_dealRootUI() {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "aaaaa"
    }
    
    func yxs_changeUI(_ cancelled: Bool) {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "ccccccc"
    }
    
    func yxs_addUI() {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "测试"
    }
}
