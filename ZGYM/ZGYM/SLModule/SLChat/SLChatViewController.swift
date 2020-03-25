//
//  SLChatViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/12.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import IQKeyboardManager
import NightNight

/// 聊天界面组件(章小飞妈妈)
class SLChatViewController: TUIChatController,TUIChatControllerDelegate {
    
    var conversation: TIMConversation?  = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 登录
        if !SLChatHelper.sharedInstance.isLogin() {
            SLChatHelper.sharedInstance.login()
        }
        
        self.navigationController?.navigationBar.shadowImage = UIImage();
        
        navigationController?.navigationBar.setBackgroundImage(NightNight.theme == .night ? UIImage.sl_image(with: kNightForegroundColor) : UIImage.sl_image(with: UIColor.white), for: .default)
        
        navigationController?.navigationBar.mixedTitleTextAttributes = [
            NNForegroundColorAttributeName: MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        ]
        IQKeyboardManager.shared().isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SLChatHelper.sharedInstance.refreshData()
        
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.titleTextAttributes = nil
        
        IQKeyboardManager.shared().isEnabled = false
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
        view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        /// 设置标题
        let titleView = HMChatNav()
        self.navigationItem.titleView = titleView
        TIMFriendshipManager.sharedInstance()?.getUsersProfile([(conversation?.getReceiver() ?? "")], forceUpdate: true, succ: { [weak self](list) in
            guard let weakSelf = self else {return}
            if list?.count ?? 0 > 0 {
                if list?.count ?? 0 > 0 && list?.first?.nickname.count ?? 0 > 0 {
                    let arr = list?.first?.nickname.components(separatedBy: "&")
                    titleView.titles = arr?.count ?? 0 >= 2 ? [arr?.first ?? "", arr?.last ?? ""] : [arr?.first ?? ""]
                }
            }
        }, fail: nil)
        
        
        self.messageController.tableView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#EEEFF8"), night: kNightBackgroundColor)
        self.inputController.view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        self.inputController.inputBar.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNight20232F)
        self.inputController.inputBar.inputTextView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight2C3144)
        self.inputController.inputBar.inputTextView.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: kNightFFFFFF)

        self.delegate = self
        
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            sl_setNavBack()
        }
        
        if(conversation?.getType() == TIMConversationType.C2C){
            self.title = conversation?.getReceiver() ?? ""
        } else if(conversation?.getType() == TIMConversationType.GROUP){
             self.title = conversation?.getGroupName() ?? ""
        }
        
        // Do any additional setup after loading the view.
        
        var moreMenus = [TUIInputMoreCellData]()
        let photo = TUIInputMoreCellData.photo
        photo?.image = UIImage(named: "sl_chat_albunm")
        let picture = TUIInputMoreCellData.picture
        picture?.image = UIImage(named: "sl_chat_camera")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
                })
            }
        }
    }
    
    // MARK: - LazyLoad
    lazy var lbTitle: SLLabel = {
        let lb = SLLabel()
        lb.text = ""
//        lb.textColor = UIColor.sl_hexToAdecimalColor(hex: "#222222")
        lb.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#222222"), night: kNightFFFFFF)
        lb.font = UIFont.systemFont(ofSize: 18)
        return lb
    }()
    
    lazy var lbSubTitle: SLLabel = {
        let lb = SLLabel()
        lb.text = ""
//        lb.textColor = UIColor.sl_hexToAdecimalColor(hex: "#898F9A")
        lb.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"), night: kNightBCC6D4)
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
}
