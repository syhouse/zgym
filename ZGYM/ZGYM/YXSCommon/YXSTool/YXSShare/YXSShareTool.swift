//
//  YXSShareTool.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/20.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
enum YXSShareWayType: Int{
    case WXSession//聊天
    case WXTimeline//朋友圈
    case QQSession
    case QQTimeline
}

class YXSShareTool: NSObject{
    public static let shareTool:YXSShareTool = YXSShareTool()
    private override init() {
        super.init()
    }
    
    
    /// 分享制定Model
    /// - Parameter model: 分享model
    public static func share(model: YXSShareModel){
        switch model.way {
        case .WXSession, .WXTimeline:
            let message = WXMediaMessage()
            if model.type == .img{
                let imageObject = WXImageObject()
                imageObject.imageData = model.image!.jpegData(compressionQuality: 1.0)!
                message.mediaObject = imageObject
            }else{
                let webpageObject = WXWebpageObject()
                webpageObject.webpageUrl = model.link!
                message.mediaObject = webpageObject
                message.title = model.title!
                message.description = model.descriptionText!
                message.setThumbImage(model.image!)
            }
            
            let req = SendMessageToWXReq()
            req.bText = false
            req.message = message
            req.scene = model.way == .WXTimeline ? Int32(WXSceneTimeline.rawValue) : Int32(WXSceneSession.rawValue)
            WXApi.send(req)
            
        case .QQSession, .QQTimeline:
            var obj: QQApiObject?
            if model.type == .img{
                obj = QQApiImageObject.init(data: model.image!.jpegData(compressionQuality: 1.0)!, previewImageData: model.image!.jpegData(compressionQuality: 0.2)!, title: "", description: "")
            }else{
                let link = (model.link ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                if let url = URL.init(string:link){
                    obj = QQApiNewsObject.init(url: url, title: model.title ?? "", description: model.descriptionText ?? "", previewImageData: model.image!.jpegData(compressionQuality: 1.0)!, targetContentType: QQApiURLTargetType.news)
                }
                
            }
            if let obj = obj{
                let req = SendMessageToQQReq.init(content: obj)
                model.way ==  .QQSession ? QQApiInterface.send(req) : QQApiInterface.sendReq(toQZone: req)
            }
        }
    }
    
    
    /// 通用shareView
    /// - Parameter shareModel: 分享model
    public static func showCommonShare(shareModel: YXSShareModel){
        var items = [YXSShareItemType]()
        if WXApi.isWXAppInstalled() && !isOldUI{
            items.append(.YXSShareWechatFriend)
            items.append(.YXSShareWechatMoment)
        }
        if TencentOAuth.iphoneQQInstalled(){
            items.append(.YXSShareQQ)
            items.append(.YXSShareQZone)
        }
        
        let shareView = YXSShareView.init(items: items) { (item, itemType, view) in
            switch itemType {
            case .YXSShareWechatFriend:
                shareModel.way = .WXSession
                share(model: shareModel)
            case .YXSShareWechatMoment:
                shareModel.way = .WXTimeline
                share(model: shareModel)
            case .YXSShareQQ:
                shareModel.way = .QQSession
                share(model: shareModel)
            case .YXSShareQZone:
                shareModel.way = .QQTimeline
                share(model: shareModel)
            default:
                break
            }
            view.cancelClick()
        }
        shareView.showIn(target: UIUtil.RootController().view)
    }
    
    
    /// 分享结果
    /// - Parameter errorMsg: 失败信息
    fileprivate static func shareResult(errorMsg: String?){
        if let errorMsg = errorMsg{
            MBProgressHUD.yxs_showMessage(message: errorMsg)
        }else{
            MBProgressHUD.yxs_showMessage(message: "分享成功")
        }
    }
}

extension YXSShareTool: WXApiDelegate{
    func onReq(_ req: BaseReq) {
        
    }
    
    func onResp(_ resp: BaseResp) {
        switch resp.errCode {
        case 0:
//            YXSShareTool.shareResult(errorMsg: nil)
            //微信分享 成功和取消都是这个code 所以取消提示
            break
        case -2:
            YXSShareTool.shareResult(errorMsg: "取消分享")
        default:
            YXSShareTool.shareResult(errorMsg: "分享失败")
        }
    }
}


class HMQQShareResponseTool: NSObject,QQApiInterfaceDelegate{
    public static let shareTool:HMQQShareResponseTool = HMQQShareResponseTool()
    private override init() {
        super.init()
    }
    func isOnlineResponse(_ response: [AnyHashable : Any]!) {
        
    }
    
    func onReq(_ req: QQBaseReq!) {
        
    }
    
    func onResp(_ resp: QQBaseResp!) {
        if resp.errorDescription == nil{
            //分享成功
            YXSShareTool.shareResult(errorMsg: nil)
        }else{
            //分享失败
            YXSShareTool.shareResult(errorMsg: "分享失败")
        }
    }
    
    
}


