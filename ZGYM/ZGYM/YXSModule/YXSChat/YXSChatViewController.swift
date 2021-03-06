//
//  YXSChatViewController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/12.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import IQKeyboardManager
import NightNight

/// 聊天界面组件(章小飞妈妈)
class YXSChatViewController: TUIChatController,TUIChatControllerDelegate {
    
    var conversation: TIMConversation?  = nil
    
    var customNav: YXSCustomNav?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 登录
        if !YXSChatHelper.sharedInstance.isLogin() {
            YXSChatHelper.sharedInstance.login()
        }
        
//        self.navigationController?.navigationBar.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
//        self.navigationController?.navigationBar.shadowImage = UIImage();
//        navigationController?.navigationBar.setBackgroundImage(NightNight.theme == .night ? UIImage.yxs_image(with: kNightForegroundColor) : UIImage.yxs_image(with: UIColor.white), for: .default)
//        navigationController?.navigationBar.mixedTitleTextAttributes = [
//            NNForegroundColorAttributeName: MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
//        ]
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        YXSChatHelper.sharedInstance.refreshData()
        
//        navigationController?.navigationBar.shadowImage = nil
//        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
//        navigationController?.navigationBar.titleTextAttributes = nil
        
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override init!(conversation: TIMConversation!) {
        super.init(conversation: conversation)
        self.conversation = conversation
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fd_prefersNavigationBarHidden = true
        view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        customNav = YXSCustomNav(YXSCustomStyle.onlyback)
        customNav?.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        customNav?.backImageButton.setMixedImage(MixedImage(normal: "back", night: "yxs_back_white"), forState: .normal)
        customNav?.titleLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        if let navView = customNav {
            view.addSubview(navView)
            navView.snp.makeConstraints { (make) in
                make.left.right.top.equalTo(0)
            }
        }

        /// 设置标题
        let titleView = HMChatNav()
        customNav?.addSubview(titleView)
        let distance = kSafeTopHeight/2.0 + 10.0
        titleView.snp.makeConstraints({ (make) in
            make.centerX.equalTo(customNav!.snp_centerX)
            make.centerY.equalTo(customNav!.snp_centerY).offset(distance)
        })
        if !YXSPersonDataModel.sharePerson.isNetWorkingConnect {
//          无网络从缓存中获取用户资料
            let userProfile = TIMFriendshipManager.sharedInstance()?.queryUserProfile((conversation?.getReceiver() ?? ""))
            if userProfile?.nickname.count ?? 0 > 0 {
                let arr = userProfile?.nickname.components(separatedBy: "&")
                titleView.titles = arr?.count ?? 0 >= 2 ? [arr?.first ?? "", arr?.last ?? ""] : [arr?.first ?? ""]
            }
            
        } else {
            TIMFriendshipManager.sharedInstance()?.getUsersProfile([(conversation?.getReceiver() ?? "")], forceUpdate: true, succ: { [weak self](list) in
                guard let weakSelf = self else {return}
                if list?.count ?? 0 > 0 {
                    if list?.count ?? 0 > 0 && list?.first?.nickname.count ?? 0 > 0 {
                        let arr = list?.first?.nickname.components(separatedBy: "&")
                        titleView.titles = arr?.count ?? 0 >= 2 ? [arr?.first ?? "", arr?.last ?? ""] : [arr?.first ?? ""]
                    }
                }
            }, fail: nil)
        }
        
        
        
        self.messageController.tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#EEEFF8"), night: kNightBackgroundColor)
        self.inputController.view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        self.inputController.inputBar.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNight20232F)
        self.inputController.inputBar.inputTextView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight2C3144)
        self.inputController.inputBar.inputTextView.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightFFFFFF)

        self.delegate = self
        
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            yxs_setNavBack()
        }
        
        if(conversation?.getType() == TIMConversationType.C2C){
            self.title = conversation?.getReceiver() ?? ""
        } else if(conversation?.getType() == TIMConversationType.GROUP){
            self.title = conversation?.getGroupName() ?? ""
        }
        
        // Do any additional setup after loading the view.
        
        var moreMenus = [TUIInputMoreCellData]()
        let photo = TUIInputMoreCellData.photo
        photo?.image = UIImage(named: "yxs_chat_albunm")
        let picture = TUIInputMoreCellData.picture
        picture?.image = UIImage(named: "yxs_chat_camera")
        moreMenus.append(photo ?? TUIInputMoreCellData())
        moreMenus.append(picture ?? TUIInputMoreCellData())
        self.moreMenus = moreMenus
    }
    
    // MARK: - Delegate
    func chatController(_ controller: TUIChatController!, onNewMessage msg: TIMMessage!) -> TUIMessageCellData! {
        return nil
    }
    
    func chatController(_ controller: TUIChatController!, onShowMessageData cellData: TUIMessageCellData!) -> TUIMessageCell! {
        return nil
    }

    func chatController(_ controller: TUIChatController!, didSendMessage msgCellData: TUIMessageCellData!) {
        
    }

    func chatController(_ chatController: TUIChatController!, onSelect cell: TUIInputMoreCell!) {
            
    }

    func chatController(_ controller: TUIChatController!, onSelectMessageAvatar cell: TUIMessageCell!) {
        
    }

    func chatController(_ controller: TUIChatController!, onSelectMessageContent cell: TUIMessageCell!) {
        
    }
    
    
    // MARK: - LazyLoad
}

// MARK: -HMRouterEventProtocol
extension YXSChatViewController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:break
        }
    }
}


class HMChatNav: UIView {
    init() {
        super.init(frame: CGRect.zero)
        addSubview(lbTitle)
        addSubview(lbSubTitle)
        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(0).offset(0)
            make.centerX.equalTo(snp_centerX).offset(0)
        })
        
        lbSubTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle.snp_bottom).offset(5)
            make.centerX.equalTo(snp_centerX).offset(0)
            make.bottom.equalTo(0)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titles: [String]? {
        didSet {
            
            lbTitle.text = self.titles?.first
            lbSubTitle.text = self.titles?.last
            
            if self.titles?.count ?? 0 <= 1 {
                lbSubTitle.isHidden = true
                lbTitle.snp.remakeConstraints({ (make) in
                    make.centerY.equalTo(snp_centerY).offset(0)
                    make.centerX.equalTo(snp_centerX).offset(0)
                    make.bottom.equalTo(0)
                })
                
            } else {
                lbSubTitle.isHidden = false
                lbTitle.snp.remakeConstraints({ (make) in
                    make.top.equalTo(0).offset(0)
                    make.centerX.equalTo(snp_centerX).offset(0)
                })
                
                lbSubTitle.snp.remakeConstraints({ (make) in
                    make.top.equalTo(lbTitle.snp_bottom).offset(5)
                    make.centerX.equalTo(snp_centerX).offset(0)
                    make.bottom.equalTo(0)
                })
            }
        }
    }
    
    // MARK: - LazyLoad
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.text = ""
//        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#222222")
        lb.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#222222"), night: kNightFFFFFF)
        lb.font = UIFont.systemFont(ofSize: 18)
        return lb
    }()
    
    lazy var lbSubTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.text = ""
//        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        lb.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: kNightBCC6D4)
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
}
