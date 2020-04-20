//
//  PunchCardModel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/13.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import ObjectMapper


class YXSPunchCardModel : NSObject, NSCopying, NSCoding, Mappable{
    func copy(with zone: NSZone? = nil) -> Any {
        let theCopyObj = YXSPunchCardModel.init(JSON: self.toJSON())!
        return theCopyObj
    }
    var classId : Int?
    var className : String?
    
    /// 打卡任务ID
    var clockInId : Int?
    var createTime : String?
    var teacherId : Int?
    
    /// 家长打卡提交id
    var clockInCommitId: Int?
    var currentClockInPeopleCount : Int?
    var currentClockInTotalCount : Int?
    var periodList : [Int]?
    // 30 进行中已打卡满 31 进行中（打卡未满）,32 今日不需要打卡 100 已结束:按照打卡的结束时间  老师
    //（10 没打卡 20 已打卡  32 今日不需要打卡 100 已结束:按照打卡的结束时间 ） 这个是 家长的
    var state : Int?
    var surplusClockInDayCount : Int?
    var clockInDayCount : Int?
    var title : String?
    var teacherName : String?
    var content : String?
    var teacherAvatar : String?
    var currentClockInDayNo : Int?
    var totalDay : Int?
    var startTime : String?
    var endTime : String?
    var clockInDateStatusResponseList : [YXSClockInDateStatusResponseList]?
    ///0:否,1:是
    var isTop : Int?
    ///是否可以撤销(对于老师来说 是否是自己发布)
    var undo : Bool?
    
    ///0 不能，1补能补卡
    var isPatchCard : Int?
    
    var teacherImId: String?
    ///是否是发布者
    var promulgator: Bool?
    
    
    var childrenId : Int?
    ///是否需要打卡
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
    
    ///是否有漏打
    var hasLeakyPunch: Bool{
        get{
            var leaky = false
            //不能补卡直接算无漏打
            if isPatchCard == 0{
                return false
            }
            if let clockInDateStatusResponseList = clockInDateStatusResponseList{
                for model in clockInDateStatusResponseList{
                    if model.state == 10 && self.yxs_isToDay(compareDate: model.clockInTime?.date(withFormat: kCommonDateFormatString)) == .Big{
                        leaky = true
                        break
                    }
                }
            }
            return leaky
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
    
    //当前展示全部
    var isShowAll: Bool = false
    
    // MARK: - 高度缓存
    ///缓存高度
    var height: CGFloat{
        get{
            if frameModel == nil{
                confingHeight()
            }
            
            let isTeacher = YXSPersonDataModel.sharePerson.personRole == .TEACHER
            //bg容器顶部高度
            var height: CGFloat = 14
            
            height += 45.5
            
            height += frameModel.contentHeight
            
            height += (isTeacher || hasPunch) ? 95.0 : 68.0
            return height
        }
    }
    
    /// frameModel
    var frameModel:YXSFriendsCircleFrameModel!
    
    func confingHeight(){

        frameModel = YXSFriendsCircleFrameModel()
        let paragraphStye = NSMutableParagraphStyle()
        //调整行间距
        paragraphStye.lineSpacing = kMainContentLineHeight
        paragraphStye.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedString.Key.paragraphStyle:paragraphStye, NSAttributedString.Key.font: kTextMainBodyFont]
        frameModel.contentHeight = UIUtil.yxs_getTextHeigh(textStr: title ?? "" , attributes: attributes,width: SCREEN_WIDTH - 30 - (15 + 18), numberOfLines: 2) + 1
    }
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        classId <- map["classId"]
        className <- map["className"]
        clockInId <- map["clockInId"]
        createTime <- map["createTime"]
        currentClockInPeopleCount <- map["currentClockInPeopleCount"]
        currentClockInTotalCount <- map["currentClockInTotalCount"]
        periodList <- map["periodList"]
        state <- map["state"]
        surplusClockInDayCount <- map["surplusClockInDayCount"]
        title <- map["title"]
        teacherName <- map["teacherName"]
        teacherAvatar <- map["teacherAvatar"]
        content <- map["content"]
        currentClockInDayNo <- map["currentClockInDayNo"]
        totalDay <- map["totalDay"]
        isTop <- map["isTop"]
        undo <- map["undo"]
        startTime <- map["startTime"]
        endTime <- map["endTime"]
        clockInDateStatusResponseList <- map["clockInDateStatusResponseList"]
        clockInDayCount <- map["clockInDayCount"]
        childrenId <- map["childrenId"]
        teacherId <- map["teacherId"]
        clockInCommitId <- map["clockInCommitId"]
        promulgator <- map["promulgator"]
        teacherImId <- map["teacherImId"]
        isPatchCard <- map["isPatchCard"]
        
        confingHeight()
    }
    
    @objc required init(coder aDecoder: NSCoder)
    {
        classId = aDecoder.decodeObject(forKey: "classId") as? Int
        className = aDecoder.decodeObject(forKey: "className") as? String
        clockInId = aDecoder.decodeObject(forKey: "clockInId") as? Int
        createTime = aDecoder.decodeObject(forKey: "createTime") as? String
        currentClockInPeopleCount = aDecoder.decodeObject(forKey: "currentClockInPeopleCount") as? Int
        currentClockInTotalCount = aDecoder.decodeObject(forKey: "currentClockInTotalCount") as? Int
        isTop = aDecoder.decodeObject(forKey: "isTop") as? Int
        periodList = aDecoder.decodeObject(forKey: "periodList") as? [Int]
        state = aDecoder.decodeObject(forKey: "state") as? Int
        surplusClockInDayCount = aDecoder.decodeObject(forKey: "surplusClockInDayCount") as? Int
        teacherId = aDecoder.decodeObject(forKey: "teacherId") as? Int
        teacherName = aDecoder.decodeObject(forKey: "teacherName") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        undo = aDecoder.decodeObject(forKey: "undo") as? Bool
        
        teacherAvatar = aDecoder.decodeObject(forKey: "teacherAvatar") as? String
        content = aDecoder.decodeObject(forKey: "content") as? String
        currentClockInDayNo = aDecoder.decodeObject(forKey: "currentClockInDayNo") as? Int
        totalDay = aDecoder.decodeObject(forKey: "totalDay") as? Int
        startTime = aDecoder.decodeObject(forKey: "startTime") as? String
        endTime = aDecoder.decodeObject(forKey: "endTime") as? String
        childrenId = aDecoder.decodeObject(forKey: "childrenId") as? Int
        clockInDayCount = aDecoder.decodeObject(forKey: "clockInDayCount") as? Int
        clockInDateStatusResponseList = aDecoder.decodeObject(forKey: "clockInDateStatusResponseList") as? [YXSClockInDateStatusResponseList]
        clockInCommitId = aDecoder.decodeObject(forKey: "clockInCommitId") as? Int
        promulgator = aDecoder.decodeObject(forKey: "promulgator") as? Bool
        teacherImId = aDecoder.decodeObject(forKey: "teacherImId") as? String
        isPatchCard = aDecoder.decodeObject(forKey: "isPatchCard") as? Int
        frameModel = aDecoder.decodeObject(forKey: "frameModel") as? YXSFriendsCircleFrameModel
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if classId != nil{
            aCoder.encode(classId, forKey: "classId")
        }
        if className != nil{
            aCoder.encode(className, forKey: "className")
        }
        if clockInId != nil{
            aCoder.encode(clockInId, forKey: "clockInId")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if currentClockInPeopleCount != nil{
            aCoder.encode(currentClockInPeopleCount, forKey: "currentClockInPeopleCount")
        }
        if currentClockInTotalCount != nil{
            aCoder.encode(currentClockInTotalCount, forKey: "currentClockInTotalCount")
        }
        if isTop != nil{
            aCoder.encode(isTop, forKey: "isTop")
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
        if teacherId != nil{
            aCoder.encode(teacherId, forKey: "teacherId")
        }
        if teacherName != nil{
            aCoder.encode(teacherName, forKey: "teacherName")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if undo != nil{
            aCoder.encode(undo, forKey: "undo")
        }
        
        if teacherAvatar != nil{
            aCoder.encode(teacherAvatar, forKey: "teacherAvatar")
        }
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if currentClockInDayNo != nil{
            aCoder.encode(currentClockInDayNo, forKey: "currentClockInDayNo")
        }
        
        if totalDay != nil{
            aCoder.encode(totalDay, forKey: "totalDay")
        }
        if startTime != nil{
            aCoder.encode(startTime, forKey: "startTime")
        }
        if endTime != nil{
            aCoder.encode(endTime, forKey: "endTime")
        }
        
        if childrenId != nil{
            aCoder.encode(childrenId, forKey: "childrenId")
        }
        if clockInDayCount != nil{
            aCoder.encode(clockInDayCount, forKey: "clockInDayCount")
        }
        if clockInDateStatusResponseList != nil{
            aCoder.encode(clockInDateStatusResponseList, forKey: "clockInDateStatusResponseList")
        }
        if clockInCommitId != nil{
            aCoder.encode(clockInCommitId, forKey: "clockInCommitId")
        }
        if promulgator != nil{
            aCoder.encode(promulgator, forKey: "promulgator")
        }
        if teacherImId != nil{
            aCoder.encode(teacherImId, forKey: "teacherImId")
        }
        if isPatchCard != nil{
              aCoder.encode(isPatchCard, forKey: "isPatchCard")
        }
        if frameModel != nil{
              aCoder.encode(frameModel, forKey: "frameModel")
        }
    }
    
}

class YXSClockInDateStatusResponseList : NSObject, NSCoding, Mappable{
    
    var clockInTime : String?
    ///（10 没打卡 20 已打卡  32 今日不需要打卡 100 已结束:按照打卡的结束时间 ） 这个是 家长的
    var state : Int?
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        clockInTime <- map["clockInTime"]
        state <- map["state"]
    }
    
    @objc required init(coder aDecoder: NSCoder)
    {
        state = aDecoder.decodeObject(forKey: "classId") as? Int
        clockInTime = aDecoder.decodeObject(forKey: "className") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if state != nil{
            aCoder.encode(state, forKey: "state")
        }
        if clockInTime != nil{
            aCoder.encode(clockInTime, forKey: "clockInTime")
        }
        
        
    }
}
