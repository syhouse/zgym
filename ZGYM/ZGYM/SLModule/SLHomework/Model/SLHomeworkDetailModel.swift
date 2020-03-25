//
//  SLHomeworkDetailModel.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/4.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class SLHomeworkDetailModel : NSObject, NSCoding, Mappable{

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
    var content : String?
    var createTime : String?
    var endTime : String?
    var id : Int?
    var imageUrl : String?
    var isTop : Int?
    var link : String?
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
    var videoUrl : String?
    var memberCount : Int?
    var childrenName : String?
    var optionList : [String]?
    var teacherImId : String?
    
    var remark : String?
    var remarkAudioUrl : String?
    var remarkAudioDuration : Int?
    var remarkList : [Int]?
    
    var childHeadPortrait : String?
    // 老师 接龙状态（0 全部 10 正在接龙 100 已结束:按照接龙的结束时间 ）
    //家长 0 全部 10 未接 20 已接龙 100 已结束:按照接龙的结束时间）
    var state : Int?
    
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
    }
}
