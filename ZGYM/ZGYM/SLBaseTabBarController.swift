//
//  SLBaseTabBarController.swift
//  SwiftBase
//
//  Created by sl_mac on 2017/7/24.
//  Copyright © 2017年 sl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLBaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 检测更新
        SLVersionUpdateManager.sharedInstance.checkUpdate()
        
        ///朋友圈红点
        UIUtil.sl_loadClassCircleMessageListData()
        
        tabBar.tintColor = kBlueColor
        tabBar.mixedBarTintColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        
        self.addChildVC(childVC: SLHomeController(), titleName: "首页", imageName: "sl_home_normal", imageSelectName: "sl_home_select")

        self.addChildVC(childVC: SLFriendsCircleController(), titleName: "优成长", imageName: "sl_friend_normal", imageSelectName: "sl_friend_select")
        
        self.addChildVC(childVC: SLConversationListController(), titleName: "私聊", imageName: "sl_chat_normal", imageSelectName: "sl_chat_select")
//        self.addChildVC(childVC: SLContactController(), titleName: "通讯录", imageName: "sl_chat_normal", imageSelectName: "sl_chat_select")

        self.addChildVC(childVC: SLMineViewController(), titleName: "我的", imageName: "sl_mine_normal", imageSelectName: "sl_mine_select")

        /// IM登录
        if !SLChatHelper.sharedInstance.isLogin() {
            SLChatHelper.sharedInstance.login {
                SLGlobalJumpManager.sharedInstance.checkPushJump()
            }
        }
        
    }
    
    
    private func addChildVC(childVC:UIViewController,titleName:String,imageName:String,imageSelectName:String){
        let nav = SLRootNavController(rootViewController: childVC)
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





