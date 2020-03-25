//
//  SLAssistantChatViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2020/1/9.
//  Copyright © 2020 hnsl_mac. All rights reserved.
//

import UIKit
///  官方小助手
class SLAssistantChatViewController: SLChatViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.messageController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        self.inputController?.removeFromParent()
//        self.inputController?.view.removeFromSuperview()
        self.messageController.tableView.register(SLCustomTextMessageCell.classForCoder(), forCellReuseIdentifier: "SLCustomTextMessageCell")
    }
    
    // MARK: - Delegate
    override func chatController(_ controller: TUIChatController!, onNewMessage msg: TIMMessage!) -> TUIMessageCellData! {
        if SLChatHelper.sharedInstance.isServiceMessage(msg: msg) {
            let data = SLCustomTextMessageCellData(direction: .MsgDirectionIncoming)
            let model = SLChatHelper.sharedInstance.msg2IMCustomModel(msg: msg)
            data.avatarImage = UIImage(named: "sl_logo")!
            data.content = model.content ?? ""
            data.innerMessage = msg
            return data
        }
        return nil
    }
    
    override func chatController(_ controller: TUIChatController!, onShowMessageData cellData: TUIMessageCellData!) -> TUIMessageCell! {
        if cellData is SLCustomTextMessageCellData {
            let cell: SLCustomTextMessageCell = SLCustomTextMessageCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "SLCell")            
            cell.fill(with: cellData as! SLCustomTextMessageCellData)
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
                SLLog("\(type(of: msgData.innerMessage))>>\(msgData.innerMessage)")
                let md = msgData.innerMessage
                if SLChatHelper.sharedInstance.isServiceMessage(msg: md) {
                    let model: IMCustomMessageModel = SLChatHelper.sharedInstance.msg2IMCustomModel(msg: md)
                    SLGlobalJumpManager.sharedInstance.jumpBy(model: model, fromViewControllter: self)
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
