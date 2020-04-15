//
//  YXSConversationListController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/11.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import IQKeyboardManager
import NightNight

/// 私聊会话列表
class YXSConversationListController: TUIConversationListController, TUIConversationListControllerDelegagte {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// 登录
        if !YXSChatHelper.sharedInstance.isLogin() {
            YXSChatHelper.sharedInstance.login()
        }
        
        self.navigationController?.navigationBar.shadowImage = UIImage();
        
        navigationController?.navigationBar.setBackgroundImage(NightNight.theme == .night ? UIImage.yxs_image(with: kNightForegroundColor) : UIImage.yxs_image(with: UIColor.white), for: .default)
        
        navigationController?.navigationBar.mixedTitleTextAttributes = [
            NNForegroundColorAttributeName: MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        ]
        
        IQKeyboardManager.shared().isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.titleTextAttributes = nil
        
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.titleView = titleView;
        self.navigationItem.title = "";
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            yxs_setNavBack()
        }
        let navRightButton = self.yxs_setRightButton(title: "通讯录")
        navRightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        navRightButton.setMixedTitleColor(MixedColor(normal: k575A60Color, night: kNight898F9A), forState: .normal)
        navRightButton.addTarget(self, action: #selector(contactsClick(sender:)), for: .touchUpInside)
        
        
        view.addSubview(btnSearch)
        btnSearch.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        })

        tableView.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor)
        //如果不加这一行代码，依然可以实现点击反馈，但反馈会有轻微延迟，体验不好。
        tableView.delaysContentTouches = false
        tableView.snp.remakeConstraints({ (make) in
            make.top.equalTo(btnSearch.snp_bottom).offset(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        })
        
        self.delegate = self;
        
        NotificationCenter.default.addObserver(self, selector: #selector(themeChangeReloadData), name: NSNotification.Name(kThemeChangeNotification), object: nil)
    }

    // MARK: - Acion
    @objc func contactsClick(sender: YXSButton) {
//        let vc = YXSContactController(classId: self.yxs_user.children?.first?.grade?.id ?? 0)
        let vc = YXSContactController()
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func searchClick(sender: YXSButton) {
        let vc = YXSSearchViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    // MARK: - Delegate
    func conversationListController(_ conversationController: TUIConversationListController, didSelectConversation conversation: TUIConversationCell) {
        
        let convData = conversation.convData
        let conv = TIMManager.sharedInstance()?.getConversation(convData.convType, receiver: convData.convId)
        if convData.convId == "assistant" {
            let chat = YXSAssistantChatViewController(conversation: conv)
            self.navigationController?.pushViewController(chat!)
            
        } else {
            let chat = YXSChatViewController(conversation: conv)
            self.navigationController?.pushViewController(chat!)
        }
    }
    
    // MARK: - Other
    /**
     *初始化导航栏Title，不同连接状态下Title显示内容不同
     */
    @objc func onNetworkChanged(notification: NSNotification) {
        let status = notification.object as? TUINetStatus
        if let status = status{
            switch status {
            case .TNet_Status_Succ:
                titleView.setTitle("私聊")
                break
            case .TNet_Status_Connecting:
                titleView.setTitle("连接中...")
                break
            case .TNet_Status_Disconnect:
                titleView.setTitle("私聊(未连接)")
                break
            case .TNet_Status_ConnFailed:
                titleView.setTitle("私聊(未连接)")
                break
            default:
                break
            }
        }
    }

    @objc func onNewMessageNotification(no: NSNotification) {
//        let msgs: [TIMMessage] = no.object as! [TIMMessage]
//        for msg in msgs {
//            let elem = msg.getElem(0)
//            if elem is TIMCustomElem {
//                let custom: TIMCustomElem = elem as! TIMCustomElem
//                let param: Dictionary = TCUtil.jsonData2Dictionary(custom.data)
////                if (param != nil && param["version"] == 2) {
////                }
//            }
//        }
    }
    
    @objc func themeChangeReloadData() {
        self.tableView.reloadData()
    }
    
    // MARK: -
    lazy var titleView: TNaviBarIndicatorView = {
        let view = TNaviBarIndicatorView()
        view.label.mixedTextColor = MixedColor(normal: UIColor.black, night: kNightFFFFFF)
        view.setTitle("私聊")
        NotificationCenter.default.addObserver(self, selector: #selector(onNetworkChanged(notification:)), name: NSNotification.Name(rawValue: TUIKitNotification_TIMConnListener), object: nil)
        return view
    }()
    
    // MARK: - LazyLoad
    lazy var btnSearch: YXSButton = {
        let btn = YXSButton()
        btn.setImage(UIImage(named: "yxs_chat_search"), for: .normal)
        btn.setTitle("搜索", for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btn.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNight2C3144)
        btn.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: kNightFFFFFF), forState: .normal)
        btn.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: kNightFFFFFF), forState: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 22
        btn.addTarget(self, action: #selector(searchClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
