//
//  UIUtil.swift
//  ZGYM
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import ObjectMapper
import NightNight
import Photos
import MediaPlayer
import SDWebImage

enum YXSOperationPosition{
    ///首页操作
    case home
    ///班级圈首页操作
    case friendCircle
    ///单个班级首页操作
    case singleHome
    ///列表页操作
    case list
    ///详情页操作
    case detial
}


// MARK: - 我的信息  不想其他地方调用
let userDetail = "/user/detail"
private class YXSEducationUserDetailRequest: YXSBaseRequset {
    override init() {
        super.init()
        method = .post
        path = userDetail
    }
}

class UIUtil: NSObject {

    
    /// 根试图控制器
    @objc static func RootController() -> UIViewController{
        return UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
    }
    
    /// 当前导航栏控制器
    @objc static func currentNav() -> UINavigationController{
        
        if RootController() is UITabBarController{
            return (RootController() as! UITabBarController).selectedViewController as? UINavigationController ?? UINavigationController()
        }
        else if RootController() is UINavigationController{
            return RootController() as! UINavigationController
        }
        return UINavigationController()
    }
    /// 当前顶层控制器
    @objc static func TopViewController() -> UIViewController{
        return currentNav().topViewController ?? UIViewController()
    }
}

// MARK: -
extension UIUtil{
    /// 设置段落间距文字
    /// - Parameters:
    ///   - label: 需要设置的文本label
    ///   - text: 文字
    ///   - lineSpacing: 段落间距
    ///   - removeSpace: 是否删除空格换行符
    public static func yxs_setLabelParagraphText(_ label: UILabel?, text: String?,font: UIFont = kTextMainBodyFont, lineSpacing: CGFloat = kMainContentLineHeight, removeSpace: Bool = false) {
        var newText = text
        if removeSpace{
            newText = text?.removeSpace()
        }
        let paragraphStye = NSMutableParagraphStyle()
        //调整行间距
        paragraphStye.lineSpacing = lineSpacing
        paragraphStye.lineBreakMode = NSLineBreakMode.byWordWrapping
        let attributedString = NSMutableAttributedString.init(string: newText ?? "", attributes: [NSAttributedString.Key.paragraphStyle:paragraphStye,NSAttributedString.Key.font: font])
        label?.attributedText = attributedString
    }
    
    /// 设置label富文本
    /// - Parameter label: 需要设置富文本的label
    /// - Parameter texts: 文本数组
    /// - Parameter colors: 文本颜色数组
    /// - Parameter fonts: 文本字体数组
    ///   - paragraphLineSpacing: 段落间距
    public static func yxs_setLabelAttributed(_ label: UILabel?, text texts: [String]?, colors: [UIColor]? = nil, fonts: [UIFont]? = nil, paragraphLineSpacing: CGFloat? = nil) {
        var mixedColor = [MixedColor]()
        if let colors = colors{
            for color in colors{
                mixedColor.append(MixedColor(normal: color, night: color))
            }
            
        }
        yxs_setLabelAttributed(label, text: texts, colors: mixedColor, fonts: fonts,paragraphLineSpacing: paragraphLineSpacing)
    }
    
    
    /// 设置label富文本
    /// - Parameters:
    ///   - label: 需要设置富文本的label
    ///   - texts: 文本数组
    ///   - colors: 文本Mix颜色
    ///   - fonts: 文本字体数组
    ///   - paragraphLineSpacing: 段落间距
    public static func yxs_setLabelAttributed(_ label: UILabel?, text texts: [String]?, colors: [MixedColor]?, fonts: [UIFont]? = nil, paragraphLineSpacing: CGFloat? = nil) {
        let textStr = texts?.joined(separator: "")
        let attrStr = NSMutableAttributedString(string: textStr ?? "")
        for i in 0..<(texts?.count ?? 0) {
            if colors != nil && (colors?.count ?? 0) > i {
                if let range = (textStr as NSString?)?.range(of: texts?[i] ?? "") {
                    attrStr.setMixedAttributes([NNForegroundColorAttributeName: colors![i]], range: range)
                }
            }
            if fonts != nil && (fonts?.count ?? 0) > i {
                if let range = (textStr as NSString?)?.range(of: texts?[i] ?? "") {
                    attrStr.addAttribute(.font, value: fonts![i], range: range)
                }
            }
        }
        
        if let paragraphLineSpacing = paragraphLineSpacing{
            let paragraphStye = NSMutableParagraphStyle()
            //调整行间距
            paragraphStye.lineSpacing = paragraphLineSpacing
            paragraphStye.alignment = label?.textAlignment ?? .center
            paragraphStye.lineBreakMode = NSLineBreakMode.byWordWrapping
            attrStr.addAttributes([NSAttributedString.Key.paragraphStyle:paragraphStye], range: NSRange.init(location: 0, length: textStr!.count))
            
        }
        label?.attributedText = attrStr
    }
    
    /// 获取文字高度
    /// - Parameter textStr: 文本
    /// - Parameter font: 字体
    /// - Parameter width: 宽度
    public static func yxs_getTextHeigh(textStr : String?, font : UIFont, width : CGFloat) -> CGFloat{
        let dic = NSDictionary(object: font, forKey : kCTFontAttributeName as! NSCopying)
        return yxs_getTextHeigh(textStr: textStr, attributes:  dic as? [NSAttributedString.Key:Any], width: width)
    }
 
    /// 获取文字高度
    /// - Parameter textStr: 文本
    /// - Parameter font: 字体
    /// - Parameter width: 宽度
    public static func yxs_getTextHeigh(textStr : String?, attributes : [NSAttributedString.Key:Any]?, width : CGFloat) -> CGFloat{
        return yxs_getTextHeigh(textStr: textStr, attributes:  attributes, width: width, numberOfLines: nil)
    }
    
    /// 获取文字宽高
    /// - Parameter textStr: 文本
    /// - Parameter font: 字体
    /// - Parameter width: 宽度
    public static func yxs_getTextSize(textStr : String?, attributes : [NSAttributedString.Key:Any]?, width : CGFloat) -> CGSize{
        return yxs_getTextSize(textStr: textStr, attributes:  attributes, width: width, numberOfLines: nil)
    }
    
    /// 获取文字宽高
    /// - Parameters:
    ///   - textStr: 文本
    ///   - attributes: attributes
    ///   - width: 宽度
    ///   - numberOfLines: 高度限制几行
    public static func yxs_getTextSize(textStr : String?, attributes : [NSAttributedString.Key:Any]?, width : CGFloat, numberOfLines: Int?) -> CGSize{
        let lable = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 10))
        if let numberOfLines = numberOfLines{
            lable.numberOfLines = numberOfLines
        }else{
            lable.numberOfLines = 0
        }
        
        lable.attributedText = NSMutableAttributedString.init(string: textStr ?? "", attributes: attributes)
        lable.sizeToFit()
        
        return lable.size
    }
    
    /// 获取文字高度
    /// - Parameters:
    ///   - textStr: 文本
    ///   - attributes: attributes
    ///   - width: 宽度
    ///   - numberOfLines: 高度限制几行
    public static func yxs_getTextHeigh(textStr : String?, attributes : [NSAttributedString.Key:Any]?, width : CGFloat, numberOfLines: Int?) -> CGFloat{
        let lable = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 10))
        if let numberOfLines = numberOfLines{
            lable.numberOfLines = numberOfLines
        }else{
            lable.numberOfLines = 0
        }
        
        lable.attributedText = NSMutableAttributedString.init(string: textStr ?? "", attributes: attributes)
        lable.sizeToFit()
        return lable.height
    }
    
    
    /// 获取通用的占位文本框
    /// - Parameters:
    ///   - edgeInsets: 占位label的edgeInsets
    ///   - placeholder: 占位文本
    ///   - placeholderColor: 占位文本颜色
    ///   - mixedTextColor: label Mix颜色
    ///   - font: 字体
    public static func yxs_getTextField(_ edgeInsets: UIEdgeInsets = UIEdgeInsets.zero, placeholder: String? = nil, placeholderColor: UIColor? = nil, mixedTextColor: MixedColor? = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), night: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")), font: UIFont? = UIFont.systemFont(ofSize: 16) ) -> YXSQSTextField{
        let tf = YXSQSTextField()
        tf.edgeInsets = edgeInsets
        tf.placeholder = placeholder
        let str = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor:placeholderColor ?? UIColor.white])
        tf.attributedPlaceholder = str
        tf.mixedTextColor = mixedTextColor
        tf.font = font
        return tf
    }
    
    ///设置虚线
    public static func yxs_drawDashLine(_ lineView:UIView,strokeColor: UIColor, lineWidth: CGFloat = 1, lineLength: CGFloat = 10, lineSpacing: CGFloat = 5) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = lineView.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        //每一段虚线长度 和 每两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: Double(lineLength)) , NSNumber(value: Double(lineLength))]
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: lineWidth, y: 0))
        shapeLayer.path = path
        lineView.layer.addSublayer(shapeLayer)
    }
    
    
    /// 从相册资源获取image
    /// - Parameters:
    ///   - asset: asset
    ///   - resultBlock: 获取完成回调
    static func PHAssetToImage(_ asset:PHAsset, resultBlock:((_ image: UIImage) ->())?){
        // 新建一个默认类型的图像管理器imageManager
        let imageManager = PHImageManager.default()
        // 新建一个PHImageRequestOptions对象
        let imageRequestOption = PHImageRequestOptions()
        // PHImageRequestOptions是否有效
        imageRequestOption.isSynchronous = true
        // 缩略图的压缩模式设置为无
        imageRequestOption.resizeMode = .none
        // 缩略图的质量为高质量，不管加载时间花多少
        imageRequestOption.deliveryMode = .highQualityFormat
        // 按照PHImageRequestOptions指定的规则取出图片
        imageManager.requestImage(for: asset, targetSize: CGSize.init(width: 1080, height: 1920), contentMode: .aspectFill, options: imageRequestOption, resultHandler: {
            (result, _) -> Void in
            resultBlock?(result ?? UIImage())
        })
    }
}

// MARK: - loadData  通用的抽出来的请求
extension UIUtil{
    
    /// 分享链接 请求链接成功默认展示分享UI 否则自己处理compelect
    /// - Parameter requestModel: 请求model
    /// - Parameter shareModel: 分享model
    /// - Parameter compelect: 自己处理分享
    static func yxs_shareLink(requestModel: HMRequestShareModel,shareModel: YXSShareModel, compelect: (()->())? = nil){
        MBProgressHUD.yxs_showLoading()
        YXSEducationShareLinkRequest.init(model: requestModel).request({ (json) in
            MBProgressHUD.yxs_hideHUD()
            let link = json.stringValue
            shareModel.link = link
            if let compelect = compelect{
                compelect()
            }else{
                YXSShareTool.showCommonShare(shareModel: shareModel)
            }
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    /// 孩子有多个家长 拨打电话
    static func yxs_callPhoneNumberRequest(childrenId: Int, classId: Int) {
        MBProgressHUD.yxs_showLoading()
        YXSEducationTeacherParentsBaseInfoRequest(childrenId: childrenId, classId: classId).requestCollection({ (list:[YXSParentModel]) in
            //            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            var dic:[String:String] = Dictionary()
            var keys:[String] = [String]()
            for sub in list {
                for real in Relationships {
                    if real.paramsKey == sub.relationship {
                        let key = "\(sub.realName ?? "")\(real.text) \(sub.account ?? "")"
                        dic[key] = sub.account
                        keys.append(key)
                        break
                    }
                }
            }
            var defaultIndex = -1
            if keys.count == 1 {
                defaultIndex = 0
            }
            YXSSolitaireSelectReasonView(items: keys, selectedIndex: defaultIndex, title: "要拨打\(list.first?.realName ?? "")的电话吗？", inTarget: currentNav().view) { (view, index) in
                if keys.count > 0 {
                    var mobile = dic[keys[index]]
                    mobile = "telprompt://\(mobile ?? "")"
                    if UIApplication.shared.canOpenURL(URL(string: mobile ?? "")!) {
                        UIApplication.shared.openURL(URL(string: mobile ?? "")!)
                    }
                }
            }
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    /// 孩子有多个家长 IM私聊
    static func yxs_chatImRequest(childrenId: Int, classId: Int) {
        MBProgressHUD.yxs_showLoading()
        YXSEducationTeacherParentsBaseInfoRequest(childrenId: childrenId, classId: classId).requestCollection({ (list:[YXSParentModel]) in
            //            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            var dic:[String:String] = Dictionary()
            var keys:[String] = [String]()
            for sub in list {
                for real in Relationships {
                    if real.paramsKey == sub.relationship {
                        let key = "\(sub.realName ?? "")\(real.text)"
                        dic[key] = sub.imId
                        keys.append(key)
                        break
                    }
                }
            }
            var defaultIndex = -1
            if keys.count == 1 {
                defaultIndex = 0
            }
            YXSSolitaireSelectReasonView(items: keys, selectedIndex: defaultIndex, title: "要联系\(list.first?.realName ?? "")的私聊吗？", inTarget: currentNav().view) { (view, index) in
                let imId = dic[keys[index]]
                UIUtil.TopViewController().yxs_pushChatVC(imId: imId ?? "")
                view.cancelClick()
            }
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    
    /// 班级之星提醒
    /// - Parameters:
    ///   - teacherIdList: 老师id
    ///   - childrenId: 孩子id
    ///   - classId:    班级id
    static func yxs_loadClassStartReminderRequest(teacherLists: [YXSClassStartTeacherModel],childrenId: Int,classId: Int){
        var teacherIdList:[Int] = [Int]()
        for model in teacherLists {
            if (model.reminder ?? false) == false{
                teacherIdList.append(model.teacherId ?? 0)
            }
            
        }
        if teacherIdList.count == 0{
            MBProgressHUD.yxs_showMessage(message: "当前没有可提醒的老师")
            return
        }
        YXSEducationParentOneTouchReminderRequest.init(teacherIdList: teacherIdList, opFlag: 1, serviceId: 0, serviceType: 6,childrenId: childrenId, classId: classId).request({ (json) in
            MBProgressHUD.yxs_showMessage(message: "提醒成功")
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    
    /// 阅读
    /// - Parameter model: YXSHomeListModel
    static func yxs_loadReadData(_ model: YXSHomeListModel,showLoading: Bool = true){
        var isEnd: Bool = false
        if let endTime = model.endTime{
            let flag = endTime.compare(model.currentTime ?? "", options: NSString.CompareOptions.numeric)
            if flag == .orderedAscending
            {
                isEnd = true
            } else {
                isEnd = false
            }
        }
        
        UIUtil.yxs_reduceHomeRed(serviceId: model.serviceId ?? 0, childId: model.childrenId ?? 0)
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER || model.isRead == 1 || isEnd{
            return
        }
        model.isRead = 1
        if model.type == .homework || model.type == .notice{
            if model.type == .homework{
                YXSEducationHomeworkCustodianUpdateReadRequest.init(childrenId: model.childrenId ?? 0, homeworkCreateTime: model.createTime ?? "", homeworkId: model.serviceId ?? 0).request(nil, failureHandler: nil)
            }else if model.type == .notice{
                YXSEducationNoticeCustodianUpdateReadRequest.init( childrenId: model.childrenId ?? 0, noticeCreateTime: model.createTime ?? "", noticeId: model.serviceId ?? 0).request(nil, failureHandler: nil)
            }
            if showLoading{
                MBProgressHUD.yxs_showMessage(message: "已阅读", inView: UIUtil.currentNav().view)
            }
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentReadSucessNotification), object: [kNotificationModelKey: model])
        }
    }
    
    
    /// 撤销
    /// - Parameters:
    ///   - model: homeModel
    ///   - positon: 操作位置
    ///   - complete: 撤销成功block
    static func yxs_loadRecallData(_ model: YXSHomeListModel,positon: YXSOperationPosition = .home, complete:(() -> ())?){
        yxs_loadRecallData(model.type, id: model.serviceId ?? 0, createTime: model.createTime ?? "",positon: positon, complete: complete)
    }
    
    
    /// 撤销
    /// - Parameters:
    ///   - type: 类型
    ///   - id: 业务id
    ///   - createTime: 创建时间
    ///   - positon: 操作位置
    ///   - complete: 撤销成功block
    static func yxs_loadRecallData(_ type: YXSHomeType,id: Int = 0,createTime: String = "",positon: YXSOperationPosition = .home, complete:(() -> ())?){
        let showTitle = type == YXSHomeType.friendCicle ? "是否撤销该条优成长？" : "你是否确认撤销？"
        let sucessMessage = type == YXSHomeType.friendCicle ? "删除成功" : "撤销成功"
        YXSCommonAlertView.showAlert(title: showTitle, rightClick: {
            var requset: YXSBaseRequset!
            switch type {
            case .homework:
                requset = YXSEducationHomeworkCancelRequest.init( homeworkId: id,homeworkCreateTime: createTime)
            case .notice:
                requset = YXSEducationNoticeCancelRequest.init( noticeId: id,noticeCreateTime: createTime)
            case .solitaire:
                requset = YXSEducationCensusTeacherUndoRequest.init(censusId: id)
            case .punchCard:
                requset = YXSEducationClockInTeacherUndoRequest.init(clockInId: id)
            case .friendCicle:
                requset = YXSEducationClassCircleCancelRequest.init(classCircleId: id)
            default:
                break
            }
            MBProgressHUD.yxs_showLoading()
            requset.request({ (result) in
                MBProgressHUD.yxs_showMessage(message: sucessMessage)
                complete?()
                
                //                UIUtil.reduceHomeRed(serviceId: id)
                if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kHomeAgendaReducNotification), object: [kEventKey: type])
                }
                switch positon {
                case .singleHome:
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationRecallInSingleClassHomeNotification), object: [kNotificationIdKey: id])
                case .list:
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationRecallInItemListNotification), object: [kNotificationIdKey: id])
                case .friendCircle:
                    if type == .friendCicle && YXSPersonDataModel.sharePerson.personRole == .TEACHER && YXSPersonDataModel.sharePerson.personStage == .KINDERGARTEN{
                        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationRecallInFriendCirleNotification), object: [kNotificationIdKey: id])
                    }
                case .home:
                    if type == .friendCicle && YXSPersonDataModel.sharePerson.personRole == .TEACHER && YXSPersonDataModel.sharePerson.personStage == .KINDERGARTEN{
                        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationRecallInHomeNotification), object: [kNotificationIdKey: id])
                    }
                default:
                    break
                }
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        })
    }
    
    static func yxs_loadClassCircleMessageListData(completion:(() -> ())? = nil){
        YXSEducationClassCircleMessageTipsRequest().request({ (result: YXSFriendsTipsModel) in
            YXSPersonDataModel.sharePerson.friendsTips = result
            RootController().yxs_showBadgeOnItem(index: 1, count: result.count ?? 0)
            completion?()
        }, failureHandler: nil)
    }
    
    static func yxs_loadUserDetailRequest(_ completion: ((_ model:YXSEducationUserModel) -> ())?,
                                         failureHandler: ((String, String) -> ())?){
        yxs_loadUserDetailRequest(completion, failureHandler: failureHandler,IMLoginSucess: nil)
    }
    
    static func yxs_loadUserDetailRequest(_ completion: ((_ model:YXSEducationUserModel) -> ())?,
                                         failureHandler: ((String, String) -> ())?,IMLoginSucess:(() -> ())? = nil){
        YXSEducationUserDetailRequest().request({ (resultModel:YXSEducationUserModel) in
            resultModel.accessToken = YXSPersonDataModel.sharePerson.userModel.accessToken
            resultModel.hasSetPassword = YXSPersonDataModel.sharePerson.userModel.hasSetPassword
            resultModel.gradeNum = YXSPersonDataModel.sharePerson.userModel.gradeNum
            
            //选择默认孩子  没有就第一个  注意防止孩子model在其他地方被篡改
            let childId = UserDefaults.standard.integer(forKey: kHomeChildKey)
            if YXSPersonDataModel.sharePerson.personRole == .PARENT{
                if let children = resultModel.children{
                    var hasChild = false
                    for model in children{
                        if model.id == childId{
                            hasChild = true
                            resultModel.currentChild = model
                            model.isSelect = true
                            break
                        }
                    }
                    if !hasChild{
                        resultModel.currentChild = children.first
                        children.first?.isSelect = true
                    }
                }
            }
            YXSPersonDataModel.sharePerson.userModel = resultModel
            if !YXSChatHelper.sharedInstance.isLogin() {
                YXSChatHelper.sharedInstance.login(){
                    IMLoginSucess?()
                }
            }
            completion?(resultModel)
            
            DispatchQueue.global().async {
                YXSLocalMessageHelper.shareHelper.yxs_changeListData()
            }
            
        }, failureHandler: failureHandler)
    }
    
    /// 置顶请求
    /// - Parameters:
    ///   - type: 类型
    ///   - id: 业务id
    ///   - createTime: 创建时间
    ///   - isTop: 是否置顶 0取消置顶 1 置顶
    ///   - positon: 操作位置
    ///   - sucess: 成功block
    static func yxs_loadUpdateTopData(type: YXSHomeType,id: Int = 0,createTime:String = "", isTop: Int = 0,positon: YXSOperationPosition = .home, sucess: (()->())? = nil){
        MBProgressHUD.yxs_showLoading()
        var request: YXSBaseRequset?
        if type == .homework{
            request = YXSEducationHomeworkUpdateTopRequest.init(homeworkId: id, homeworkCreateTime: createTime, isTop: isTop)
        }else if type == .notice{
            request = YXSEducationNoticeUpdateTopRequest.init(noticeId: id, noticeCreateTime: createTime, isTop: isTop)
        }else if type == .punchCard{
            request = YXSEducationClockInUpdateTopRequest.init(clockInId: id)
        }else if type == .solitaire{
            request = YXSEducationCensusUpdateTopRequest.init(censusId: id,isTop: isTop)
        }
        request?.request({ (json) in
            MBProgressHUD.yxs_showMessage(message: "\(isTop == 0 ? "取消置顶" : "置顶")成功")
            sucess?()
            switch positon {
            case .detial:
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationUpdateToTopInItemDetailNotification), object: nil)
            case .singleHome:
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationUpdateToTopInSingleClassHomeNotification), object: nil)
            case .list:
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationUpdateToTopInItemListNotification), object: nil)
            default:
                break
            }
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    
    /// 待办事项
    /// - Parameters:
    ///   - serviceId:  serviceId
    ///   - info: 待办通知类型  kEventKey: HomeType
    static func yxs_reduceAgenda(serviceId: Int,info: [String: Any]){
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{//老师去掉待办红点
            YXSEducationTodoUpdateRedPointRequest.init(serviceId: serviceId).request({ (result) in
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kHomeAgendaReducNotification), object: info)
            }, failureHandler: nil)
        }else{
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kHomeAgendaReducNotification), object: info)
        }
    }
    
    
    /// 去掉首页红点
    /// - Parameter serviceId: serviceId 
    static func yxs_reduceHomeRed(serviceId: Int, childId: Int){
        if YXSPersonDataModel.sharePerson.personRole == .PARENT{
            if YXSLocalMessageHelper.shareHelper.yxs_isLocalMessage(serviceId: serviceId,childId: childId){
                YXSLocalMessageHelper.shareHelper.yxs_removeLocalMessage(serviceId: serviceId, childId: childId)
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kHomeCellReducNotification), object: serviceId)
            }
        }
    }
}

// MARK: - 点赞 评论
extension UIUtil{
    /// 朋友圈点赞
    /// - Parameters:
    ///   - YXSFriendCircleModel: YXSFriendCircleModel model
    ///   - reloadViewBlock: 点赞成功刷新
    static func yxs_changeFriendCirclePrise(_ friendCircleModel: YXSFriendCircleModel,positon: YXSOperationPosition = .home, reloadViewBlock:(() -> ())?){
        if YXSPersonDataModel.sharePerson.isNetWorkingConnect == false{
            //            friendCircleModel.isOnRequsetPraise = false
            MBProgressHUD.yxs_showMessage(message: "网络不给力，请检查网络")
            return
        }
        var praiseModel: YXSFriendsPraiseModel! = nil
        if let  praises = friendCircleModel.praises{
            for model in praises{
                if model.isMyOperation{
                    praiseModel = model
                    break
                }
            }
        }
        let isCancelPraise = praiseModel == nil ? false : true
        if isCancelPraise {
            friendCircleModel.praises!.remove(at: friendCircleModel.praises!.firstIndex(of: praiseModel!) ?? 0)
        }else{
            let result:YXSFriendsPraiseModel = YXSFriendsPraiseModel.init(JSON: ["":""])!
            result.classCircleId = friendCircleModel.classCircleId
            result.userType = YXSPersonDataModel.sharePerson.personRole.rawValue
            result.userId = YXSPersonDataModel.sharePerson.userModel.id
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                result.userName = YXSPersonDataModel.sharePerson.userModel.name
            }else{
                var childrenNames = [String]()
                var gradeIds = [Substring]()
                gradeIds = friendCircleModel.gradeId?.split(separator: ",") ?? [Substring]()
                for gradeId in gradeIds{
                    if let childrens  = YXSPersonDataModel.sharePerson.userModel.children{
                        for children in childrens{
                            if children.grade?.id == Int(gradeId){
                                childrenNames.append(children.realName ?? "")
                            }
                            
                        }
                    }
                }
                
                result.userName = "\(childrenNames.joined(separator: "、"))的家长"
                
            }
            if friendCircleModel.praises == nil{
                friendCircleModel.praises = [result]
            }else{
                friendCircleModel.praises!.append(result)
            }
            praiseModel = result
        }
        
        reloadViewBlock?()
        let info:[String : Any] = [kNotificationIsCancelKey: isCancelPraise,kNotificationModelKey:praiseModel!,kNotificationIdKey: friendCircleModel.classCircleId ?? 0]
        switch positon {
        case .home:
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationPraiseInItemHomeNotification), object: info)
        case .friendCircle:
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationPraiseInItemFriendCirleNotification), object: info)
        case .list:
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationPraiseInItemListNotification), object: info)
        default:
            break
        }
        
        YXSEducationClassCirclePraiseUpdateRequest.init(classCircleId: friendCircleModel.classCircleId ?? 0).request({ (result:YXSFriendsPraiseModel) in
            
        }) { (msg, code) in
            //            friendCircleModel.isOnRequsetPraise = false
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    
    /// 朋友圈评论
    /// - Parameters:
    ///   - classCircleId: 朋友圈id
    ///   - commentId: 评论id 删除评论传
    ///   - commentModel: 评论model 添加评论
    ///   - content: 评论内容
    ///   - positon: 评论操作位置
    ///   - reloadViewBlock: 评论操作成功回调
    static func yxs_changeCommentFriendCirclePrise(_ classCircleId: Int,commentId: Int? = nil,commentModel: YXSFriendsCommentModel? = nil,content: String? = nil,positon: YXSOperationPosition = .home, reloadViewBlock:((YXSFriendsCommentModel) -> ())?){
        if YXSPersonDataModel.sharePerson.isNetWorkingConnect == false{
            MBProgressHUD.yxs_showMessage(message: "网络不给力，请检查网络")
            return
        }
        var isAddComment = true
        var request: YXSBaseRequset!
        if let commentId = commentId{
            isAddComment = false
            request = YXSEducationClassCircleCommentCancelRequest.init(classCircleId: classCircleId, id: commentId)
        }else{
            request = YXSEducationClassCircleCommentSaveRequest.init(classCircleId: classCircleId, type: commentModel?.id == nil ? FriendCircleComment.COMMENT : FriendCircleComment.REPLY, content: content ?? "", id: commentModel?.id)
        }
        request.request({ (model:YXSFriendsCommentModel) in
            if !isAddComment{
                model.id = commentId
            }
            reloadViewBlock?(model)
            let info:[String : Any] = [kNotificationIsDelectKey: isAddComment,kNotificationModelKey:model,kNotificationIdKey: classCircleId]
            switch positon {
            case .home:
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationCommentInItemHomeNotification), object: info)
            case .friendCircle:
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationCommentInItemFriendCirleNotification), object: info)
            case .list:
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationCommentInItemListNotification), object: info)
            default:
                break
            }
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
}

// MARK: - 主题

extension UIUtil{
    /// 切换主题
    public static func changeTheme(){
        
        NightNight.theme =  NightNight.theme == .night ? .normal : .night
        setCommonThemeConfig()
        
        let vc: YXSFriendsCircleController? = ((UIUtil.RootController() as? UITabBarController)?.viewControllers?[1] as? UINavigationController)?.topViewController as? YXSFriendsCircleController
        vc?.tableView.reloadData()
    }
    
    
    /// 主题配置
    public static func setCommonThemeConfig(){
        kImageDefualtImage = NightNight.theme == .night ? UIImage.init(named: "defultImage_night") : UIImage.init(named: "defultImage")
        kImageUserIconPartentDefualtImage = NightNight.theme == .night ? UIImage.init(named: "yxs_defult_partent_night") : UIImage.init(named: "yxs_defult_partent")
        kImageUserIconTeacherDefualtImage = NightNight.theme == .night ? UIImage.init(named: "yxs_defult_teacher_night") : UIImage.init(named: "yxs_defult_teacher")
        kImageUserIconStudentDefualtImage = NightNight.theme == .night ? UIImage.init(named: "yxs_defult_student_night") : UIImage.init(named: "yxs_defult_student")
        UIApplication.shared.statusBarStyle = NightNight.theme == .night ? .lightContent : .default
    }
}

// MARK: - helper
extension UIUtil{
    
    /// 播放缓存视频
    /// - Parameter url: 视频链接地址
    public static func pushOpenVideo(url: String){
        let vc = SLVideoPlayController()
        vc.videoUrl = url
        self.currentNav().pushViewController(vc)
    }
}


// MARK: - 锁屏播放控制
extension UIUtil{
    static func configNowPlayingCenterUI(){
        let isPlayerStop = (XMSDKPlayer.shared()?.isPlaying() ?? false) == false && (XMSDKPlayer.shared()?.isPaused() ?? false) == false
        if isPlayerStop{
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            return
        }
        
        if let image = SDImageCache.shared.imageFromCache(forKey: YXSRemoteControlInfoHelper.imageUrl){
            UIUtil.configNowPlayingCenter(title: YXSRemoteControlInfoHelper.title, author: YXSRemoteControlInfoHelper.author, currentTime: YXSRemoteControlInfoHelper.currentTime, totalTIme: YXSRemoteControlInfoHelper.totalTime, image: image)
        }else{
            UIImageView().sd_setImage(with: URL(string: YXSRemoteControlInfoHelper.imageUrl), completed: { (image, error, type, url) in
                UIUtil.configNowPlayingCenter(title: YXSRemoteControlInfoHelper.title, author: YXSRemoteControlInfoHelper.author, currentTime: YXSRemoteControlInfoHelper.currentTime, totalTIme: YXSRemoteControlInfoHelper.totalTime, image: image)
            })
        }
    }
    
    static private func configNowPlayingCenter(title: String, author: String, currentTime: UInt, totalTIme: Int, image: UIImage?){
        //  Converted to Swift 5.2 by Swiftify v5.2.18740 - https://swiftify.com/
        var info: [String : Any] = [:]
        //音乐的标题
        info[MPMediaItemPropertyTitle] = title
        //音乐的艺术家
        let author = author
        info[MPMediaItemPropertyArtist] = author
        //音乐的播放时间
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: currentTime)
        
        //音乐的播放速度
        if XMSDKPlayer.shared()?.isPlaying() ?? false{
            info[MPNowPlayingInfoPropertyPlaybackRate] = NSNumber(value: 1)
        }else{
            info[MPNowPlayingInfoPropertyPlaybackRate] = NSNumber(value: 0)
        }
        
        //音乐的总时间
        info[MPMediaItemPropertyPlaybackDuration] = NSNumber(value: totalTIme)
        //音乐的封面
        var artwork: MPMediaItemArtwork? = nil
        if let image = image {
            artwork = MPMediaItemArtwork(image: image)
        }else{
            artwork = MPMediaItemArtwork(image: UIImage.init(named: "yxs_player_defualt_bg")!)
        }
        info[MPMediaItemPropertyArtwork] = artwork
        //完成设置
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info

    }
    
    static func configNowPlayingIsPause(isPlaying: Bool){
        let info = MPNowPlayingInfoCenter.default().nowPlayingInfo
        if var info = info{
            info[MPNowPlayingInfoPropertyPlaybackRate] = NSNumber(value: isPlaying ? 1 : 0)
            MPNowPlayingInfoCenter.default().nowPlayingInfo = info
            SLLog(MPNowPlayingInfoCenter.default().nowPlayingInfo)
        }
    }
}
