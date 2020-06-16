//
//  YXSAssistantChatViewController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2020/1/9.
//  Copyright © 2020 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
///  官方小助手
class YXSAssistantChatViewController: YXSChatViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customNav = YXSCustomNav(YXSCustomStyle.backAndTitle)
        customNav?.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        customNav?.backImageButton.setMixedImage(MixedImage(normal: "back", night: "yxs_back_white"), forState: .normal)
        customNav?.titleLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        view.addSubview(customNav!)
        customNav?.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }
        if !YXSPersonDataModel.sharePerson.isNetWorkingConnect {
//          无网络从缓存中获取用户资料
            let userProfile = TIMFriendshipManager.sharedInstance()?.queryUserProfile((conversation?.getReceiver() ?? ""))
            if userProfile?.nickname.count ?? 0 > 0 {
                let arr = userProfile?.nickname.components(separatedBy: "&")
                self.customNav?.title = arr?.last ?? ""
            }
            
        } else {
            let receiver = conversation?.getReceiver() ?? ""
            TIMFriendshipManager.sharedInstance()?.getUsersProfile([receiver], forceUpdate: true, succ: { [weak self](list) in
                guard let weakSelf = self else {return}
                if list?.count ?? 0 > 0 {
                    if list?.count ?? 0 > 0 && list?.first?.nickname.count ?? 0 > 0 {
                        weakSelf.customNav?.title = list?.first?.nickname
                    }
                }
            }, fail: nil)
        }
        
        
//        self.messageController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        self.inputController?.removeFromParent()
//        self.inputController?.view.removeFromSuperview()
        self.messageController.tableView.register(YXSCustomTextMessageCell.classForCoder(), forCellReuseIdentifier: "YXSCustomTextMessageCell")
    }
    
    // MARK: - Delegate
    override func chatController(_ controller: TUIChatController!, onNewMessage msg: TIMMessage!) -> TUIMessageCellData! {
        if YXSChatHelper.sharedInstance.isServiceMessage(msg: msg) {
            let data = YXSCustomTextMessageCellData(direction: .MsgDirectionIncoming)
            let model = YXSChatHelper.sharedInstance.msg2IMCustomModel(msg: msg)
            data.avatarImage = UIImage(named: "yxs_logo")!
            data.content = model.content ?? ""
            data.innerMessage = msg
            return data
        }
        return nil
    }
    
    override func chatController(_ controller: TUIChatController!, onShowMessageData cellData: TUIMessageCellData!) -> TUIMessageCell! {
        if cellData is YXSCustomTextMessageCellData {
            let cell: YXSCustomTextMessageCell = YXSCustomTextMessageCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "SLCell")            
            cell.fill(with: cellData as! YXSCustomTextMessageCellData)
            return cell;
        }
        return nil
    }
    
    /**
     *  点击消息内容回调
     *
     *  @param controller 会话对象
     *  @param cell 所点击的消息单元
     */
    override func chatController(_ controller: TUIChatController!, onSelectMessageContent cell: TUIMessageCell!) {
        
        if let msgData = cell.messageData {
            if msgData.innerMessage != nil {
                SLLog("\(type(of: msgData.innerMessage))")
                let md = msgData.innerMessage
                if YXSChatHelper.sharedInstance.isServiceMessage(msg: md) {
                    let model: IMCustomMessageModel = YXSChatHelper.sharedInstance.msg2IMCustomModel(msg: md)
                    YXSGlobalJumpManager.sharedInstance.yxs_jumpBy(model: model, fromViewControllter: self)
                }
                
            } else {
                SLLog("无innerMessage")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
