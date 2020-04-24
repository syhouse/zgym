//
//  YXSBaseTabBarController.swift
//  SwiftBase
//
//  Created by zgjy_mac on 2017/7/24.
//  Copyright © 2017年 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSBaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 检测更新
        YXSVersionUpdateManager.sharedInstance.checkUpdate()
        
        ///朋友圈红点
//        UIUtil.yxs_loadClassCircleMessageListData()
        
        tabBar.tintColor = kRedMainColor
        tabBar.mixedBarTintColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        
        self.addChildVC(childVC: YXSHomeController(), titleName: "首页", imageName: "yxs_home_normal", imageSelectName: "yxs_home_select")
//        YXSExcellentEducationVC YXSContentHomeController
        self.addChildVC(childVC: YXSExcellentEducationVC(), titleName: "优教育", imageName: "yxs_education_normal", imageSelectName: "yxs_education_select")
//        self.addChildVC(childVC: YXSFriendsCircleController(), titleName: "优成长", imageName: "yxs_friend_normal", imageSelectName: "yxs_friend_select")

        
        
        self.addChildVC(childVC: YXSConversationListController(), titleName: "私聊", imageName: "yxs_chat_normal", imageSelectName: "yxs_chat_select")
        
        
//        self.addChildVC(childVC: YXSContactController(), titleName: "通讯录", imageName: "yxs_chat_normal", imageSelectName: "yxs_chat_select")

        self.addChildVC(childVC: YXSMineViewController(), titleName: "我的", imageName: "yxs_mine_normal", imageSelectName: "yxs_mine_select")

        /// IM登录
        if !YXSChatHelper.sharedInstance.isLogin() {
            YXSChatHelper.sharedInstance.login {
                YXSGlobalJumpManager.sharedInstance.checkPushJump()
            }
        }
        
        self.delegate = self
        ///fps
        if isDebug{
//            let fpsView = LSLFPSMonitor.init(frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100 - 70, y: 0, width: 100, height: 30))
//            self.view.addSubview(fpsView)
        }
    }
    
    deinit {
        SLLog("deinit")
    }
    
    
    private func addChildVC(childVC:UIViewController,titleName:String,imageName:String,imageSelectName:String){
        let nav = YXSRootNavController(rootViewController: childVC)
        nav.navigationBar.tintColor = UIColor.white
        
        let dic : Dictionary = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20)]
        nav.navigationBar.titleTextAttributes = dic
        childVC.title = titleName
        childVC.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        childVC.tabBarItem.selectedImage = UIImage(named: imageSelectName)?.withRenderingMode(.alwaysOriginal)
        self.addChild(nav)
    }
    
    override var shouldAutorotate: Bool {
        return self.selectedViewController?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }
}

extension YXSBaseTabBarController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        ///当前控制器不是优教育 隐藏弹窗
        if let nav = viewController as? UINavigationController{
            YXSMusicPlayerWindowView.setView(hide: !(nav.viewControllers.first is YXSExcellentEducationVC))
        }
        return true
    }
}





