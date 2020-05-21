//
//  YXSHomeListModel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/18.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON


class YXSHomeSectionModel: NSObject,NSCoding{
    var hasSection: Bool = false
    var showText:String! = ""
    var items = [YXSHomeListModel]()
    
    override init(){}
    
    @objc required init(coder aDecoder: NSCoder)
    {
        hasSection = aDecoder.decodeBool(forKey: "hasSection")
        showText = aDecoder.decodeObject(forKey: "showText") as? String ?? ""
        items = aDecoder.decodeObject(forKey: "items") as? [YXSHomeListModel] ?? [YXSHomeListModel]()
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if showText != nil{
            aCoder.encode(showText, forKey: "showText")
        }
        aCoder.encode(items, forKey: "items")
        aCoder.encode(hasSection, forKey: "hasSection")
    }
    
}

class YXSHomeListModel : NSObject, NSCoding, Mappable, NSCopying{
    static var smallFontSize:CGFloat = 13
    static var bottomPadding:CGFloat = 19
    static var smallMagin:CGFloat = 10
    static var midMagin:CGFloat = 14
    
    
    func copy(with zone: NSZone? = nil) -> Any {
        let theCopyObj = YXSHomeListModel.init(JSON: self.toJSON())!
        return theCopyObj
    }
    
    ///视频的第一帧
    var bgUrl : String?
    var childrenId : Int?
    var classId : Int?
    var className : String?
    var content : String?
    var createTime : String?
    var endTime : String?
    var currentTime: String?
    var hasAv : Int?   //0无  1 音频 2 视频
    var hasLink : Int?
    /// 首页用的排序ID
    var id : Int?
    ///是否置顶 (1 置顶 0 未置顶)
    var isTop : Int?
    ///班级人数
    var memberCount : Int?
    /// 业务ID
    var serviceId : Int?
    //7优期刊
    /// 业务类型(0:通知,1:作业,2:打卡,3:接龙,4:成绩,5:班级圈6:班级之星  105 班级圈消息),首页聚合所有数据时无需传该参数,查询对应业务数据时需要传
    var serviceType : Int?
    /// 学段
    var stage : String?
    var teacherId : Int?
    var teacherName : String?
    var topTime : String?
    var updateTime : String?
    var startTime : String?
    
    var userId : Int?
    var userType : String?
    /// 是否需要在线提交 (0 不需要 1 需要)
    var onlineCommit : Int?
    /// 状态(接龙 打卡任务)
    var state: Int?
    
    ///最后一条记录id
    var lastRecordId: Int?
    ///最后一条记录时间
    var lastRecordTime: String?
    ///最近更新时间
    var tsLast: Int?
    
    /// 接龙提交人数上限
    var commitUpperLimit: Int?
    var surplusClockInDayCount: Int?
    
    var periodList : [Int]?
    
    ///孩子姓名  需要塞进去 班级之星用到
    var childrenRealName : String?
    
    /// 班级之星 朋友圈数据 通过这个字段拿到
    var dataJson : String?{
        didSet{
            
            if let dataJson = dataJson{
                if type == .classstart{
                    classStarModel = YXSClassStarPartentModel.init(JSONString: dataJson)
                }else if type == .friendCicle{
                    friendCircleModel = YXSFriendCircleModel.init(JSONString: dataJson)
                    friendCircleModel?.contentDealType = .homeList
                }
            }
        }
    }
    
    /// 当前作业是否已过期
    var isExpired: Bool {
        get {
            if endTime != nil {
                if endTime!.count > 0 {
                    let endDate = Date.init(fromString: endTime!, format: .custom("yyyy-MM-dd HH:mm:ss"))
                    if endDate?.compare(Date()) == .orderedAscending {
                        return true
                    }
                }
            }
            
            return false
        }
        
    }
    
    /// 已阅读孩子id列表
    var readList : [Int]?
    /// 已提交孩子id列表
    var committedList : [Int]?
    
    /// 已点评列表孩子id列表
    var remarkList: [Int]?
    
    
    /// 初始化设置已阅读列表
    var readListStr : String?{
        didSet{
            let jsonData:Data = (readListStr ?? "").data(using: .utf8)!
            let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            var list = [Int]()
            if let array = array as? [Any]{
                for item in array{
                    if item is Int{
                        list.append(item as! Int)
                    }
                }
            }
            readList = list
        }
    }
    /// 初始化设置已提交列表
    var committedListStr : String?{
        didSet{
            if let committedListStr = committedListStr{
                let jsonData:Data = committedListStr.data(using: .utf8)!
                let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                var list = [Int]()
                if let array = array as? [Any]{
                    for item in array{
                        if item is Int{
                            list.append(item as! Int)
                        }
                    }
                }
                committedList = list
            }
            
        }
    }
    /// 初始化设置已点评列表
    var remarkListStr : String?{
        didSet{
            if let remarkListStr = remarkListStr{
                let jsonData:Data = remarkListStr.data(using: .utf8)!
                let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                var list = [Int]()
                if let array = array as? [Any]{
                    for item in array{
                        if item is Int{
                            list.append(item as! Int)
                        }
                    }
                }
                remarkList = list
            }
            
        }
    }
    
    ///0 未读 1已读  (设置通过把孩子id添加到已读列表中)
    var isRead : Int{
        set(newIsRead){
            if newIsRead == 1{
                if readList != nil{
                    readList?.append(childrenId ?? 0)
                }else{
                    readList = [childrenId ?? 0]
                }
            }
        }
        get{
            return (self.readList?.contains(self.childrenId ?? 0) ?? false) ? 1 : 0
        }
    }
    
    /// 是否已被点评 (设置通过把孩子id添加到已点评列表中)
    var isRemark : Bool{
        set(newIsRemark){
            if newIsRemark{
                if remarkList != nil{
                    remarkList?.append(childrenId ?? 0)
                }else{
                    remarkList = [childrenId ?? 0]
                }
            }
        }
        get{
            return self.remarkList?.contains(self.childrenId ?? 0) ?? false
        }
    }
    
    /// 已提交人数  已打卡人数
    var commitCount : Int{
        return committedList?.count ?? 0
    }
    
    /// 已读人数
    var readCount: Int{
        return readList?.count ?? 0
    }
    /// 1 未提交 2 已提交 (设置通过把孩子id添加到已提交列表中)
    var commitState : Int{
        set(newCommitState){
            if newCommitState == 2{
                if  committedList != nil{
                    committedList?.append(childrenId ?? 0)
                }else{
                    committedList = [childrenId ?? 0]
                }
                //接龙 打卡
                if state != nil{
                    state = 20
                }
            }
            else {
                committedList = nil
            }
        }
        get{
            return (self.committedList?.contains(self.childrenId ?? 0) ?? false) ? 2 : 1
        }
    }
    ///当前是否展示全部
    var isShowAll: Bool = false
    ///是否展示折叠按钮
    var shouldShowMore: Bool = false
    
    ///(是否需要展示展开按钮)首页列表使用
    var needShowAllButton: Bool = false{
        didSet{
            //            SLLog("needShowAllButton=\(needShowAllButton) content=\(content ?? "")")
        }
    }
    
    /// 业务类型  通过 serviceId 获取的枚举
    var type: YXSHomeType{
        get{
            switch serviceType ?? 0 {
            case 0:
                return .notice
            case 1:
                return .homework
            case 2:
                return .punchCard
            case 3:
                return .solitaire
            case 4:
                return .classstart
            case 5:
                return .friendCicle
            case 6:
                return .classstart
            case 7:
                return .periodical
            default:
                return .notice
            }
        }
    }
    //是否有资源
    var hasSource :Bool{
        get {
            return (hasAv ?? 0 != 0 || (bgUrl ?? "").count > 0) ? true : false
        }
    }
    
    //资源类型  0 无 1 音频 2 图片  3 图片+音频  4 视频
    var sourceType :Int {
        get{
            let hasAv = self.hasAv ?? 0
            let bgUrl = self.bgUrl ?? ""
            if hasAv == 0{//视频
                if bgUrl.count > 0{
                    return 2
                }
            }else if hasAv == 2{
                return 4
            }else{
                if bgUrl.count > 0{
                    return 3
                }
                return 1
            }
            return 0
        }
    }
    
    ///接龙已完成
    var isFinish: Bool{
        get{
            return commitState == 2 && onlineCommit == 1
        }
    }
    
    /// 是否需要打卡
    var hasNeedPunch: Bool{
        get{
            if let state = state{
                if state == 32{
                    return false
                }
            }
            return true
        }
    }
    ///是否已打卡
    var hasPunch: Bool{
        get{
            if let state = state{
                if state == 20{
                    return true
                }
            }
            return false
        }
    }
    ///是否已结束
    var hasPunchFinish: Bool{
        get{
            if let state = state{
                if state == 100{
                    return true
                }
            }
            return false
        }
    }
    
    ///老师  是否已全部打卡
    var hasPunchAll: Bool{
        get{
            if let state = state{
                if state == 30{
                    return true
                }
            }
            return false
        }
    }
    
    ///家长通知是否已提交回执
    var hasSubmitReceipt: Bool{
        get{
            return (self.committedList?.contains(self.childrenId ?? 0) ?? false) ? true : false
        }
    }
    ///通知是否需要回执
    var needReceipt: Bool{
        get{
            return (onlineCommit ?? 0  == 1 && type == .notice) ? true : false
        }
    }
    
    
    /// 通用的readButton大小
    var readButtonSize: CGSize{
        get{
            if onlineCommit == 1{
                return commitState == 2 ? CGSize.init(width: 79, height: 29) :  CGSize.init(width: 65, height: 29)
            }else{
                return isRead == 1 ? CGSize.init(width: 65, height: 29) : CGSize.init(width: 65, height: 29)
            }
        }
    }
    
    /// 班级之星数据 使用该model
    var classStarModel: YXSClassStarPartentModel?
    /// 朋友圈数据 使用该model
    var friendCircleModel: YXSFriendCircleModel?
    
    ///是否是首页需要显示标签
    var isShowTag: Bool = false
    
    // MARK: - 高度缓存
    ///缓存高度
    var height: CGFloat{
        get{
            //优期刊
            if serviceType == 7{
                if let classstartModel = classStarModel,classstartModel.showRemindTeacher{
                    return 14.0 + 512.0
                }
                let titleHeight: CGFloat = 40.0
                return 14.0 + 52 + 41 + titleHeight + CGFloat(43.0*Double(maxHomePeriodicalLine)) + 5.5
            }
            //班级之星
            if serviceType == 6{
                if let classstartModel = classStarModel{
                    if   classstartModel.showRemindTeacher{
                        return 14.0 + 512.0
                    }else if classstartModel.currentChildren == nil{
                        let titleHeight = UIUtil.yxs_getTextHeigh(textStr: "\(self.yxs_user.currentChild?.realName ?? "")\(NSUtil.yxs_getDateText(dateType: .W))暂未上榜，请再接再厉！", font: UIFont.boldSystemFont(ofSize: 20), width: SCREEN_WIDTH - 30 - 30)
                        return 14.0 + 396.0 + titleHeight
                    }
                }
                return 14.0 + 468.0
            }
            //朋友圈
            if serviceType == 5{
                if let friendsModel = friendCircleModel{
                    friendsModel.contentAdjustWidth = 30
                    return friendsModel.friendHeight + 30
                }
                return 0
            }
            
            if frameModel == nil{
                confingHeight()
            }
            
            let isTeacher = YXSPersonDataModel.sharePerson.personRole == .TEACHER
            //bg容器顶部高度
            var height: CGFloat = 14
            if isShowTag{
                height += 52.0
            }else{
                height += 48.5
            }
            
            if needShowAllButton{
                height += 25 + 9
            }else{
                //有资源补偿高度  单行的时候高度不够
                if hasSource{
                    var totalHeight:CGFloat = frameModel.contentHeight
                    if serviceType == 0{
                        if isShowTag{
                            totalHeight = isTeacher ? 45.0 : 55.0
                        }else{
                            if isTeacher {
                                totalHeight = 45.0
                            }else{
                                totalHeight = 55.0
                            }
                        }
                    }else if serviceType == 1 && !isTeacher || (isTeacher && onlineCommit == 0){
                        totalHeight = 55.0
                    }
                    height  +=  totalHeight - frameModel.contentHeight
                }
            }
            
            
            if self.isShowAll || !self.needShowAllButton{
                height += frameModel.contentIsShowAllHeight
                
            }else{
                height += frameModel.contentHeight
            }
            
            
            ///底部高度
            switch serviceType ?? 0 {
            case 0:
                height += 67.5
            case 1:
                height += (isTeacher && onlineCommit == 1) ? 90.5 : 67.5
            case 2:
                height += (isTeacher || hasPunch || !hasNeedPunch) ? 117.5 : 95.0
            case 3:
                if isShowTag{
                    height += 120.0
                }else{
                    height += 90.5
                }
            default:
                height += 67.5
                break
            }
            return height
        }
    }
    
    /// frameModel
    var frameModel:YXSFriendsCircleFrameModel!
    
    var contentLabelWidth : CGFloat{
        return SCREEN_WIDTH - 30 - (hasSource ? (15 + 107) : (15 + 18))
    }
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        bgUrl <- map["bgUrl"]
        childrenId <- map["childrenId"]
        classId <- map["classId"]
        className <- map["className"]
        readListStr <- map["readList"]
        committedListStr <- map["committedList"]
        content <- map["content"]
        createTime <- map["createTime"]
        endTime <- map["endTime"]
        hasAv <- map["hasAv"]
        hasLink <- map["hasLink"]
        id <- map["id"]
        isTop <- map["isTop"]
        memberCount <- map["memberCount"]
        serviceId <- map["serviceId"]
        serviceType <- map["serviceType"]
        stage <- map["stage"]
        teacherId <- map["teacherId"]
        teacherName <- map["teacherName"]
        topTime <- map["topTime"]
        updateTime <- map["updateTime"]
        userId <- map["userId"]
        userType <- map["userType"]
        onlineCommit <- map["onlineCommit"]
        dataJson <- map["dataJson"]
        periodList <- map["periodList"]
        state <- map["state"]
        surplusClockInDayCount <- map["surplusClockInDayCount"]
        remarkListStr <- map["remarkList"]
        commitUpperLimit <- map["commitUpperLimit"]
        startTime <- map["startTime"]
        
        currentTime <- map["currentTime"]
        
        confingHeight()
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        bgUrl = aDecoder.decodeObject(forKey: "bgUrl") as? String
        childrenId = aDecoder.decodeObject(forKey: "childrenId") as? Int
        classId = aDecoder.decodeObject(forKey: "classId") as? Int
        className = aDecoder.decodeObject(forKey: "className") as? String
        committedList = aDecoder.decodeObject(forKey: "committedList") as? [Int]
        readList = aDecoder.decodeObject(forKey: "readList") as? [Int]
        remarkList = aDecoder.decodeObject(forKey: "remarkList") as? [Int]
        content = aDecoder.decodeObject(forKey: "content") as? String
        createTime = aDecoder.decodeObject(forKey: "createTime") as? String
        endTime = aDecoder.decodeObject(forKey: "endTime") as? String
        hasAv = aDecoder.decodeObject(forKey: "hasAv") as? Int
        hasLink = aDecoder.decodeObject(forKey: "hasLink") as? Int
        id = aDecoder.decodeObject(forKey: "id") as? Int
        isTop = aDecoder.decodeObject(forKey: "isTop") as? Int
        memberCount = aDecoder.decodeObject(forKey: "memberCount") as? Int
        serviceId = aDecoder.decodeObject(forKey: "serviceId") as? Int
        serviceType = aDecoder.decodeObject(forKey: "serviceType") as? Int
        stage = aDecoder.decodeObject(forKey: "stage") as? String
        teacherId = aDecoder.decodeObject(forKey: "teacherId") as? Int
        teacherName = aDecoder.decodeObject(forKey: "teacherName") as? String
        topTime = aDecoder.decodeObject(forKey: "topTime") as? String
        updateTime = aDecoder.decodeObject(forKey: "updateTime") as? String
        userId = aDecoder.decodeObject(forKey: "userId") as? Int
        userType = aDecoder.decodeObject(forKey: "userType") as? String
        onlineCommit = aDecoder.decodeObject(forKey: "onlineCommit") as? Int
        dataJson = aDecoder.decodeObject(forKey: "dataJson") as? String
        periodList = aDecoder.decodeObject(forKey: "periodList") as? [Int]
        state = aDecoder.decodeObject(forKey: "state") as? Int
        surplusClockInDayCount = aDecoder.decodeObject(forKey: "surplusClockInDayCount") as? Int
        classStarModel = aDecoder.decodeObject(forKey: "classStarModel") as? YXSClassStarPartentModel
        friendCircleModel = aDecoder.decodeObject(forKey: "friendCircleModel") as? YXSFriendCircleModel
        commitUpperLimit = aDecoder.decodeObject(forKey: "commitUpperLimit") as? Int
        childrenRealName = aDecoder.decodeObject(forKey: "childrenRealName") as? String
        startTime = aDecoder.decodeObject(forKey: "startTime") as? String
        
        frameModel = aDecoder.decodeObject(forKey: "frameModel") as? YXSFriendsCircleFrameModel
        needShowAllButton = aDecoder.decodeBool(forKey: "needShowAllButton")
        
        currentTime = aDecoder.decodeObject(forKey: "currentTime") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if bgUrl != nil{
            aCoder.encode(bgUrl, forKey: "bgUrl")
        }
        if childrenId != nil{
            aCoder.encode(childrenId, forKey: "childrenId")
        }
        if classId != nil{
            aCoder.encode(classId, forKey: "classId")
        }
        if className != nil{
            aCoder.encode(className, forKey: "className")
        }
        if committedList != nil{
            aCoder.encode(committedList, forKey: "committedList")
        }
        if readList != nil{
            aCoder.encode(readList, forKey: "readList")
        }
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if endTime != nil{
            aCoder.encode(endTime, forKey: "endTime")
        }
        if hasAv != nil{
            aCoder.encode(hasAv, forKey: "hasAv")
        }
        if hasLink != nil{
            aCoder.encode(hasLink, forKey: "hasLink")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isTop != nil{
            aCoder.encode(isTop, forKey: "isTop")
        }
        if memberCount != nil{
            aCoder.encode(memberCount, forKey: "memberCount")
        }
        if serviceId != nil{
            aCoder.encode(serviceId, forKey: "serviceId")
        }
        if serviceType != nil{
            aCoder.encode(serviceType, forKey: "serviceType")
        }
        if stage != nil{
            aCoder.encode(stage, forKey: "stage")
        }
        if teacherId != nil{
            aCoder.encode(teacherId, forKey: "teacherId")
        }
        if teacherName != nil{
            aCoder.encode(teacherName, forKey: "teacherName")
        }
        if topTime != nil{
            aCoder.encode(topTime, forKey: "topTime")
        }
        if updateTime != nil{
            aCoder.encode(updateTime, forKey: "updateTime")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "userId")
        }
        if userType != nil{
            aCoder.encode(userType, forKey: "userType")
        }
        if onlineCommit != nil{
            aCoder.encode(onlineCommit, forKey: "onlineCommit")
        }
        if dataJson != nil{
            aCoder.encode(dataJson, forKey: "dataJson")
        }
        if periodList != nil{
            aCoder.encode(periodList, forKey: "periodList")
        }
        if state != nil{
            aCoder.encode(state, forKey: "state")
        }
        if surplusClockInDayCount != nil{
            aCoder.encode(surplusClockInDayCount, forKey: "surplusClockInDayCount")
        }
        if classStarModel != nil{
            aCoder.encode(classStarModel, forKey: "classStarModel")
        }
        if friendCircleModel != nil{
            aCoder.encode(friendCircleModel, forKey: "friendCircleModel")
        }
        if remarkList != nil{
            aCoder.encode(remarkList, forKey: "remarkList")
        }
        if commitUpperLimit != nil{
            aCoder.encode(commitUpperLimit, forKey: "commitUpperLimit")
        }
        if childrenRealName != nil{
            aCoder.encode(childrenRealName, forKey: "childrenRealName")
        }
        if startTime != nil{
            aCoder.encode(startTime, forKey: "startTime")
        }
        
        if frameModel != nil{
            aCoder.encode(frameModel, forKey: "frameModel")
        }
        
        aCoder.encode(needShowAllButton, forKey: "needShowAllButton")
        
        if currentTime != nil{
            aCoder.encode(currentTime, forKey: "currentTime")
        }
    }
}


extension YXSHomeListModel{
    func confingHeight(){
        
        frameModel = YXSFriendsCircleFrameModel()
        let paragraphStye = NSMutableParagraphStyle()
        //调整行间距
        paragraphStye.lineSpacing = kMainContentLineHeight
        paragraphStye.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedString.Key.paragraphStyle:paragraphStye, NSAttributedString.Key.font: kTextMainBodyFont]
        frameModel.contentIsShowAllHeight = UIUtil.yxs_getTextHeigh(textStr: content?.listReplaceSpaceAndReturn() ?? "", attributes: attributes , width: contentLabelWidth)
        frameModel.contentHeight = UIUtil.yxs_getTextHeigh(textStr: content?.listReplaceSpaceAndReturn() ?? "", attributes: attributes,width: contentLabelWidth, numberOfLines: 2) + 1
        needShowAllButton = frameModel.contentIsShowAllHeight > 50  ? true : false
    }
}
