//
//  YXSHomeworkDetailModel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/4.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper
import SwiftyJSON

class YXSHomeworkDetailModel : NSObject, NSCoding, Mappable{

    var audioDuration : Int?
    var audioUrl : String?
    var bgUrl : String?
    var classId : Int?
    var className : String?
    var committedList : [Int]?
    var committedListStr : String?{
        didSet{
            let jsonData:Data = (committedListStr ?? "").data(using: .utf8)!
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
    var content : String? {
        didSet{
            frameModel = nil
        }
    }
    var createTime : String?
    var endTime : String?
    var fileJson: String? {
        didSet {
            let list = Mapper<YXSHomeworkFileRequest>().mapArray(JSONString: fileJson ?? "") ?? [YXSHomeworkFileRequest]()
            fileList.removeAll()
            for item in list {
                let file = YXSFileModel.init(JSON: ["":""])
                file?.id = item.fileId
                file?.fileName = item.fileName
                file?.fileSize = item.fileSize
                file?.fileType = item.fileType
                file?.fileUrl = item.fileUrl
                fileList.append(file!)
            }
//            fileList = list
        }
    }
    
    var fileList: [YXSFileModel] = [YXSFileModel]()
    var endTimeIsUnlimited: Bool {
        get {
            //超过3个月为不限时
            var isUnlimited = false
            if endTime?.count ?? 0 > 0 {
                let endDate = Date.init(fromString: endTime!, format: .custom("yyyy-MM-dd HH:mm:ss"))
                if let date = endDate {
                    isUnlimited = date.yxs_isDifferWithMonth(month: 3) ?? false
                }
            }
            
            return isUnlimited
        }
    }
    
    var id : Int?
    var homeworkId: Int?
    var imageUrl : String? {
        didSet{
            showImages = nil
        }
    }
    
    /// 当前作业是否已过期
    var isExpired: Bool {
        get {
            if endTime?.count ?? 0 > 0 {
                let endDate = Date.init(fromString: endTime!, format: .custom("yyyy-MM-dd HH:mm:ss"))
                if endDate?.compare(Date()) == .orderedAscending {
                    return true
                }
            } else if homeworkEndTime?.count ?? 0 > 0 {
                let endDate = Date.init(fromString: homeworkEndTime!, format: .custom("yyyy-MM-dd HH:mm:ss"))
                if endDate?.compare(Date()) == .orderedAscending {
                    return true
                }
            }
            return false
        }
        
    }
    
    var homeworkEndTime: String?
    
    
    var isTop : Int?
    var link : String?

    /// 是否需要在线提交  0:不需要 1:需要
    var onlineCommit : Int?
    var readList : [Int]?
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
    var stage : String?
    var teacherAvatar : String?
    var teacherId : Int?
    var teacherName : String?
    var topTime : String?
    var updateTime : String?
    var remarkTime : String?
    var videoUrl : String? {
        didSet{
            showImages = nil
        }
    }
    var relationship: String? 
    var memberCount : Int?
    var childrenName : String?
    var optionList : [String]?
    var teacherImId : String?
    /// 作业提交者家长id
    var custodianId: Int?
    
    var remark : String? {
        didSet{
            remarkFrameModel = nil
        }
    }
    var remarkAudioUrl : String?
    var remarkAudioDuration : Int?
    var remarkList : [Int]?
    
    var childHeadPortrait : String?
    // 老师 接龙状态（0 全部 10 正在接龙 100 已结束:按照接龙的结束时间 ）
    //家长 0 全部 10 未接 20 已接龙 100 已结束:按照接龙的结束时间）
    var state : Int?

    
    /// 互动消息提醒数量
    var messageCount : Int?
    
    /// 互动消息最后一条用户头像
    var messageAvatar : String?
    
    /// 互动消息最后一条用户身份
    var messageUserType : String?
    
    /// 是否为优秀作业
    var isGood : Int?
    /// 是否已点评
    var isRemark : Int?
    /// 评论的json
    var commentJson : String? {
        didSet {
            let comment : JSON = JSON(commentJson ?? "")
            let commentList = Mapper<YXSHomeworkCommentModel>().mapArray(JSONString: comment.rawString()!) ?? [YXSHomeworkCommentModel]()
            commentJsonList = commentList
        }
    }
    /// 点赞的json
    var praiseJson : String? {
        didSet {
            let praise : JSON = JSON(praiseJson ?? "")
            let praiseList = Mapper<YXSFriendsPraiseModel>().mapArray(JSONString: praise.rawString()!) ?? [YXSFriendsPraiseModel]()
            praiseJsonList = praiseList
        }
    }

    var praiseJsonList : [YXSFriendsPraiseModel]?
    var commentJsonList : [YXSHomeworkCommentModel]?

    /// 作业语音地址数组
    var audioDurationList : [String]?

    /// 家长提交的作业是否相互可见
    var homeworkVisible : Int?

    /// 老师的点评是否对家长相互可见
    var remarkVisible : Int?

    /// 当前作业提交者的孩子id
    var childrenId : Int?

    /// 当前内容是否展开
    var isShowContentAll: Bool = false


    /// 当前评论是否展开
    var isShowCommentAll: Bool = false

    /// 是否需要展示评论展开按钮
    var isNeeedShowCommentAllButton: Bool{
        get{
            return (self.commentJsonList?.count ?? 0 > 3)
        }
    }
    /// 是否有音频
    var hasVoice : Bool{
        get{
            return (audioUrl ?? "").count > 0
        }
    }

    /// 是否是我发布  可操作优秀
    var isMyPublish: Bool {
        get {
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER && teacherId == YXSPersonDataModel.sharePerson.userModel.id {
                return true
            } else {
                return false
            }
        }
    }
    
    /// 当前作业是否是我提交的
    var isMySubmit : Bool {
        get {
            if childrenId == selectChildrenId && YXSPersonDataModel.sharePerson.personRole == .PARENT {
                return true
            } else {
                return false
            }
        }
    }

    var selectChildrenId: Int? = YXSPersonDataModel.sharePerson.userModel.currentChild?.id ?? 0
    
    /// 家长提交作业的原始图片地址
    var backImageUrl: String? {
        didSet {
            backImageUrlList = nil
            backImageUrlList = [YXSFriendsMediaModel]()
            if let backImageUrl = backImageUrl, backImageUrl.count > 0 {
                let pics = backImageUrl.components(separatedBy: ",")
                for pic in pics {
                    let img = YXSFriendsMediaModel.init(url: pic, type: .serviceImg)
                    backImageUrlList.append(img)
                }
            }
        }
    }
    
    /// 家长提交作业的原始图片地址
    var backImageUrlList: [YXSFriendsMediaModel]!
    
    /// 用来初始化存储
    var showImages: [YXSFriendsMediaModel]!
    
    /// 媒体资源
    var imgs: [YXSFriendsMediaModel] {
        get{
            if showImages != nil{
                return showImages
            }
            showImages = [YXSFriendsMediaModel]()
            if let imageUrl = imageUrl, imageUrl.count > 0{
                let pics = imageUrl.components(separatedBy: ",")
                for pic in pics{
                    let img = YXSFriendsMediaModel.init(url: pic, type: .serviceImg)
                    showImages.append(img)
                    
                }
                return showImages
                
            }
            if let videoUrl = videoUrl, videoUrl.count > 0{
                let videoModel = YXSFriendsMediaModel.init(url: videoUrl, type: .serviceVedio)
                videoModel.bgUrl = bgUrl
                showImages.append(videoModel)
                return showImages
            }
            return showImages
        }
        
    }
    
    ///headerView高度
    var headerHeight: CGFloat{
        get{
            if frameModel == nil{
                confingHeight()
            }
            if remarkFrameModel == nil{
                remarkConfingHeight()
            }
            let helper = YXSFriendsConfigHelper.helper
            //content顶部距离
            var height: CGFloat = 15 + 40
            if needShowAllButton{
                height += 26.0 + 9.0
            }
            if self.isShowContentAll{
                height += frameModel.contentIsShowAllHeight + 15

            }else{
                height += frameModel.contentHeight + 15
            }

            if (audioUrl ?? "").count > 0{
                height += 36.0 + 10.0
            }
            //有图片视频资源
            if self.imgs.count !=  0{
                //视频资源间距
                height += 10.0
                if (videoUrl ?? "").count != 0{
                    height += helper.videoSize.height
                }else{
                    let count: Int = imgs.count/3 +  (self.imgs.count%3 == 0 ? 0 : 1)
                    height +=  CGFloat(count)*CGFloat((SCREEN_WIDTH - 15.0 - 2*5.0 - 15.0)/3) + CGFloat(5*(count - 1))
                }
            }else{

            }
            height += 10.0 + 26.0
            height += remarkHeight
            if remarkHeight > 0 {
                height += 15
            }
//            if isRemark == 1 && (remarkVisible == 1 || isMySubmit) {
//                ///点评头部高度
//                height += 15 + 20 + 8 + 15 + 10 + 3
//
//                ///点评文字高度
//                if (remark ?? "").count > 0 {
//                    height += remarkFrameModel.contentIsShowAllHeight + 10
//                }
//
//                if (remarkAudioUrl ?? "").count > 0{
//                    height += 36.0 + 10.0
//                }
//            }
            var favs = [String]()
            if let prises = praiseJsonList, prises.count > 0{
                for (_,prise) in prises.enumerated(){
                    favs.append(prise.userName ?? "")
                }
                let favsStr = favs.joined(separator: ",")
                let paragraphStye = NSMutableParagraphStyle()
                //调整行间距
                paragraphStye.lineSpacing = 6
                paragraphStye.lineBreakMode = .byWordWrapping
                let attributes = [NSAttributedString.Key.paragraphStyle:paragraphStye, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]

                let favsHeight = UIUtil.yxs_getTextHeigh(textStr: favsStr, attributes: attributes, width: SCREEN_WIDTH - 15.0 - 31.0 - 15.0 - 15.0)
                height += 12.5 + favsHeight + 11 + 12.5
                
            } else {
                if let comment = commentJsonList,comment.count > 0 {
                    if remarkHeight <= 0 {
                        height += 12.5
                    } else {
                        height += 10
                    }
                } else {
                    height += 10
                }
            }
//            height += 30

            return height
        }
    }

    /// 朋友圈
    var frameModel:YXSFriendsCircleFrameModel!

    /// 是否需要showAllButton
    var needShowAllButton: Bool = false
    
    var homeworkCreateTime: String? ///发布作业创建时间
    
    // MARK: - func
    /// 计算朋友圈model值
    func confingHeight(){
        frameModel = YXSFriendsCircleFrameModel()
        let paragraphStye = NSMutableParagraphStyle()
        //调整行间距
        paragraphStye.lineSpacing = kMainContentLineHeight
        paragraphStye.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedString.Key.paragraphStyle:paragraphStye, NSAttributedString.Key.font: kTextMainBodyFont]
        frameModel.contentIsShowAllHeight = UIUtil.yxs_getTextHeigh(textStr: content ?? "", attributes: attributes, width: SCREEN_WIDTH - 30) + 1
        let text: String = content ?? ""
        frameModel.contentHeight = UIUtil.yxs_getTextHeigh(textStr: content ?? "" , attributes: attributes,width: SCREEN_WIDTH - 30, numberOfLines: 3) + 1
        needShowAllButton = frameModel.contentIsShowAllHeight > (kTextMainBodyFont.pointSize * 3 + kMainContentLineHeight * 4)  ? true : false
    }
    
    var goodMap: [String: Int]?
    
    func getChildGoodCount(id:Int) -> Int {
        let key = String(id)
        if goodMap?.has(key: key) ?? false {
            return goodMap?[key] ?? 0
        } else {
            return 0
        }
    }
    
    ///展示历史优秀作业
    var isShowLookGoodButton: Bool = true
    
    ///班级之星排行
    var topHistoryModel: YXSClassStarTopHistoryModel?
    
    func getMyClassStartRank(id:Int) -> Int {
        if let top3Model = topHistoryModel?.mapTop3{
            if let lists = top3Model.first{
                for model in lists{
                    if id == model.childrenId{
                        return 1
                    }
                }
            }
            
            if let lists = top3Model.secend{
                for model in lists{
                    if id == model.childrenId{
                        return 2
                    }
                }
            }
            
            if let lists = top3Model.thrid{
                for model in lists{
                    if id == model.childrenId{
                        return 3
                    }
                }
            }
        }
        return 0
    }
//    var myClassStartRank: Int?{
//        get{
//            if let top3Model = topHistoryModel?.mapTop3{
//                if let lists = top3Model.first{
//                    for model in lists{
//                        if childrenId == model.childrenId{
//                            return 1
//                        }
//                    }
//                }
//                
//                if let lists = top3Model.secend{
//                    for model in lists{
//                        if childrenId == model.childrenId{
//                            return 2
//                        }
//                    }
//                }
//                
//                if let lists = top3Model.thrid{
//                    for model in lists{
//                        if childrenId == model.childrenId{
//                            return 3
//                        }
//                    }
//                }
//            }
//            
//            return nil
//        }
//    }

    var remarkFrameModel:YXSFriendsCircleFrameModel!

    func remarkConfingHeight(){
        remarkFrameModel = YXSFriendsCircleFrameModel()
        let paragraphStye = NSMutableParagraphStyle()
        //调整行间距
        paragraphStye.lineSpacing = kMainContentLineHeight
        paragraphStye.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedString.Key.paragraphStyle:paragraphStye, NSAttributedString.Key.font: kTextMainBodyFont]
        remarkFrameModel.contentIsShowAllHeight = UIUtil.yxs_getTextHeigh(textStr: remark ?? "", attributes: attributes, width: SCREEN_WIDTH - 30) + 1
        let text: String = remark ?? ""
        remarkFrameModel.contentHeight = UIUtil.yxs_getTextHeigh(textStr: remark ?? "" , attributes: attributes,width: SCREEN_WIDTH - 30, numberOfLines: 3) + 1
        needShowAllButton = frameModel.contentIsShowAllHeight > (kTextMainBodyFont.pointSize * 3 + kMainContentLineHeight * 4)  ? true : false
    }
    
    var remarkHeight: CGFloat {
        get{
            if remarkFrameModel == nil{
                remarkConfingHeight()
            }
            var height:CGFloat = 0.0
            if ((isRemark == 1 && (remarkVisible == 1 || isMySubmit)) || (isRemark == 1 && isMyPublish))  {
                ///点评头部高度
                height += 43 + 15

                ///点评文字高度
                if (remark ?? "").count > 0 {
                    height += remarkFrameModel.contentIsShowAllHeight + 10
                }
                
                if (remarkAudioUrl ?? "").count > 0{
                    height += 36.0 + 10.0
                }
            }
            return height
        }
    }

    private override init(){}
    required init?(map: Map){}

    func mapping(map: Map)
    {
        audioDuration <- map["audioDuration"]
        audioUrl <- map["audioUrl"]
        bgUrl <- map["bgUrl"]
        classId <- map["classId"]
        className <- map["className"]
        committedListStr <- map["committedList"]
        content <- map["content"]
        createTime <- map["createTime"]
        endTime <- map["endTime"]
        id <- map["id"]
        imageUrl <- map["imageUrl"]
        isTop <- map["isTop"]
        link <- map["link"]
        onlineCommit <- map["onlineCommit"]
        readListStr <- map["readList"]
        stage <- map["stage"]
        teacherAvatar <- map["teacherAvatar"]
        teacherId <- map["teacherId"]
        teacherName <- map["teacherName"]
        topTime <- map["topTime"]
        updateTime <- map["updateTime"]
        videoUrl <- map["videoUrl"]
        memberCount <- map["memberCount"]
        childrenName <- map["childrenName"]
        optionList <- map["optionList"]
        teacherImId <- map["teacherImId"]
        childHeadPortrait <- map["childHeadPortrait"]
        remark <- map["remark"]
        remarkAudioUrl <- map["remarkAudioUrl"]
        remarkAudioDuration <- map["remarkAudioDuration"]
        state <- map["state"]
        remarkList <- map["remarkList"]
        isGood <- map["isGood"]
        isRemark <- map["isRemark"]
        commentJson <- map["commentJson"]
        praiseJson <- map["praiseJson"]
        audioDurationList <- map["audioDurationList"]
        homeworkVisible <- map["homeworkVisible"]
        remarkVisible <- map["remarkVisible"]
        childrenId <- map["childrenId"]
        remarkTime <- map["remarkTime"]
        messageCount <- map["messageCount"]
        messageAvatar <- map["messageAvatar"]
        messageUserType <- map["messageUserType"]
        backImageUrl <- map["backImageUrl"]
        relationship <- map["relationship"]
        fileJson <- map["fileJson"]
        goodMap <- map["goodMap"]
        homeworkId <- map["homeworkId"]
        homeworkCreateTime <- map["homeworkCreateTime"]
        homeworkEndTime <- map["homeworkEndTime"]
        custodianId <- map["custodianId"]
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         audioDuration = aDecoder.decodeObject(forKey: "audioDuration") as? Int
         audioUrl = aDecoder.decodeObject(forKey: "audioUrl") as? String
         bgUrl = aDecoder.decodeObject(forKey: "bgUrl") as? String
         classId = aDecoder.decodeObject(forKey: "classId") as? Int
         className = aDecoder.decodeObject(forKey: "className") as? String
         committedList = aDecoder.decodeObject(forKey: "committedList") as? [Int]
         content = aDecoder.decodeObject(forKey: "content") as? String
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         endTime = aDecoder.decodeObject(forKey: "endTime") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? String
         isTop = aDecoder.decodeObject(forKey: "isTop") as? Int
         link = aDecoder.decodeObject(forKey: "link") as? String
         onlineCommit = aDecoder.decodeObject(forKey: "onlineCommit") as? Int
         readList = aDecoder.decodeObject(forKey: "readList") as? [Int]
         stage = aDecoder.decodeObject(forKey: "stage") as? String
         teacherAvatar = aDecoder.decodeObject(forKey: "teacherAvatar") as? String
         teacherId = aDecoder.decodeObject(forKey: "teacherId") as? Int
         teacherName = aDecoder.decodeObject(forKey: "teacherName") as? String
         topTime = aDecoder.decodeObject(forKey: "topTime") as? String
         updateTime = aDecoder.decodeObject(forKey: "updateTime") as? String
         videoUrl = aDecoder.decodeObject(forKey: "videoUrl") as? String
         memberCount = aDecoder.decodeObject(forKey: "memberCount") as? Int
         childrenName = aDecoder.decodeObject(forKey: "childrenName") as? String
         optionList = aDecoder.decodeObject(forKey: "optionList") as? [String]
         teacherImId = aDecoder.decodeObject(forKey: "teacherImId") as? String
         childHeadPortrait = aDecoder.decodeObject(forKey: "childHeadPortrait") as? String
         remark = aDecoder.decodeObject(forKey: "remark") as? String
         remarkAudioUrl = aDecoder.decodeObject(forKey: "remarkAudioUrl") as? String
         remarkAudioDuration = aDecoder.decodeObject(forKey: "remarkAudioDuration") as? Int
         state = aDecoder.decodeObject(forKey: "state") as? Int
         remarkList = aDecoder.decodeObject(forKey: "remarkList") as? [Int]
        isGood = aDecoder.decodeObject(forKey: "isGood") as? Int
        isRemark = aDecoder.decodeObject(forKey: "isRemark") as? Int
        commentJson = aDecoder.decodeObject(forKey: "commentJson") as? String
        praiseJson = aDecoder.decodeObject(forKey: "praiseJson") as? String
        audioDurationList = aDecoder.decodeObject(forKey: "audioDurationList") as? [String]
        homeworkVisible = aDecoder.decodeObject(forKey: "homeworkVisible") as? Int
        remarkVisible = aDecoder.decodeObject(forKey: "remarkVisible") as? Int
        childrenId = aDecoder.decodeObject(forKey: "childrenId") as? Int
        remarkTime = aDecoder.decodeObject(forKey: "remarkTime") as? String
        messageCount = aDecoder.decodeObject(forKey: "messageCount") as? Int
        messageAvatar = aDecoder.decodeObject(forKey: "messageAvatar") as? String
        messageUserType = aDecoder.decodeObject(forKey: "messageUserType") as? String
        backImageUrl = aDecoder.decodeObject(forKey: "backImageUrl") as? String
        relationship = aDecoder.decodeObject(forKey: "relationship") as? String
        fileJson = aDecoder.decodeObject(forKey: "fileJson") as? String
        goodMap = aDecoder.decodeObject(forKey: "goodMap") as? [String : Int]
        homeworkId = aDecoder.decodeObject(forKey: "homeworkId") as? Int
        homeworkCreateTime = aDecoder.decodeObject(forKey: "homeworkCreateTime") as? String
        homeworkEndTime = aDecoder.decodeObject(forKey: "homeworkEndTime") as? String
        selectChildrenId = aDecoder.decodeObject(forKey: "selectChildrenId") as? Int
        custodianId = aDecoder.decodeObject(forKey: "custodianId") as? Int
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if audioDuration != nil{
            aCoder.encode(audioDuration, forKey: "audioDuration")
        }
        if audioUrl != nil{
            aCoder.encode(audioUrl, forKey: "audioUrl")
        }
        if bgUrl != nil{
            aCoder.encode(bgUrl, forKey: "bgUrl")
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
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if endTime != nil{
            aCoder.encode(endTime, forKey: "endTime")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if imageUrl != nil{
            aCoder.encode(imageUrl, forKey: "imageUrl")
        }
        if isTop != nil{
            aCoder.encode(isTop, forKey: "isTop")
        }
        if link != nil{
            aCoder.encode(link, forKey: "link")
        }
        if onlineCommit != nil{
            aCoder.encode(onlineCommit, forKey: "onlineCommit")
        }
        if readList != nil{
            aCoder.encode(readList, forKey: "readList")
        }
        if stage != nil{
            aCoder.encode(stage, forKey: "stage")
        }
        if teacherAvatar != nil{
            aCoder.encode(teacherAvatar, forKey: "teacherAvatar")
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
        if videoUrl != nil{
            aCoder.encode(videoUrl, forKey: "videoUrl")
        }
        if memberCount != nil{
            aCoder.encode(memberCount, forKey: "memberCount")
        }
        if childrenName != nil{
            aCoder.encode(childrenName, forKey: "childrenName")
        }
        if optionList != nil{
            aCoder.encode(optionList, forKey: "optionList")
        }
        if teacherImId != nil{
            aCoder.encode(teacherImId, forKey: "teacherImId")
        }
        if childHeadPortrait != nil{
            aCoder.encode(childHeadPortrait, forKey: "childHeadPortrait")
        }
        if remark != nil{
            aCoder.encode(remark, forKey: "remark")
        }
        if remarkAudioUrl != nil{
            aCoder.encode(remarkAudioUrl, forKey: "remarkAudioUrl")
        }
        if remarkAudioDuration != nil{
            aCoder.encode(remarkAudioDuration, forKey: "remarkAudioDuration")
        }
        if state != nil{
            aCoder.encode(state, forKey: "state")
        }
        if remarkList != nil{
            aCoder.encode(remarkList, forKey: "remarkList")
        }
        if isGood != nil{
            aCoder.encode(isGood, forKey: "isGood")
        }
        if isRemark != nil{
            aCoder.encode(isRemark, forKey: "isRemark")
        }
        if commentJson != nil{
            aCoder.encode(commentJson, forKey: "commentJson")
        }
        if praiseJson != nil{
            aCoder.encode(praiseJson, forKey: "praiseJson")
        }
        if audioDurationList != nil{
            aCoder.encode(audioDurationList, forKey: "audioDurationList")
        }
        if homeworkVisible != nil{
            aCoder.encode(homeworkVisible, forKey: "homeworkVisible")
        }
        if remarkVisible != nil{
            aCoder.encode(remarkVisible, forKey: "remarkVisible")
        }
        if childrenId != nil{
            aCoder.encode(childrenId, forKey: "childrenId")
        }
        if remarkTime != nil{
            aCoder.encode(remarkTime, forKey: "remarkTime")
        }
        if messageCount != nil {
            aCoder.encode(messageCount, forKey: "messageCount")
        }
        if messageAvatar != nil {
            aCoder.encode(messageAvatar, forKey: "messageAvatar")
        }
        if messageUserType != nil {
            aCoder.encode(messageUserType, forKey: "messageUserType")
        }
        if backImageUrl != nil {
            aCoder.encode(backImageUrl, forKey: "backImageUrl")
        }
        if relationship != nil {
            aCoder.encode(relationship, forKey: "relationship")
        }
        if fileJson != nil {
            aCoder.encode(fileJson, forKey: "fileJson")
        }
        if goodMap != nil {
            aCoder.encode(goodMap, forKey: "goodMap")
        }
        if homeworkId != nil {
            aCoder.encode(homeworkId, forKey: "homeworkId")
        }
        if homeworkCreateTime != nil {
            aCoder.encode(homeworkCreateTime, forKey: "homeworkCreateTime")
        }
        if homeworkEndTime != nil {
            aCoder.encode(homeworkEndTime, forKey: "homeworkEndTime")
        }
        if selectChildrenId != nil {
            aCoder.encode(selectChildrenId, forKey: "selectChildrenId")
        }
        if custodianId != nil {
            aCoder.encode(custodianId, forKey: "custodianId")
        }
    }
}

