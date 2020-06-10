//
//  YXSSolitaireDetailModel.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/5.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import ObjectMapper


class YXSSolitaireDetailModel : NSObject, NSCoding, Mappable{
    
    var audioDuration : Int?
    var audioUrl : String?
    var bgUrl : String?
    var censusId : Int?
    var classChildrenCount : Int?
    var classId : Int?
    var className : String?
    var commitCount : Int?
    var content : String?
    var createTime : String?
    var endTime : String?
    var imageUrl : String?
    var isTop : Int?
    var link : String?
    var optionList : [String]?
    var read : Bool?
    var readCount : Int?
    // 老师 接龙状态（0 全部 10 正在接龙 100 已结束:按照接龙的结束时间 ）
    //家长 0 全部 10 未接 20 已接龙 100 已结束:按照接龙的结束时间）
    var state : Int?
    var teacherAvatar : String?
    var teacherId : Int?
    var teacherName : String?
    var title : String?
    ///1普通(old) 2普通(new) 3调查卷 接龙类型
    var type : Int?
    var videoUrl : String?
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        audioDuration <- map["audioDuration"]
        audioUrl <- map["audioUrl"]
        bgUrl <- map["bgUrl"]
        censusId <- map["censusId"]
        classChildrenCount <- map["classChildrenCount"]
        classId <- map["classId"]
        className <- map["className"]
        commitCount <- map["commitCount"]
        content <- map["content"]
        createTime <- map["createTime"]
        endTime <- map["endTime"]
        imageUrl <- map["imageUrl"]
        isTop <- map["isTop"]
        link <- map["link"]
        optionList <- map["optionList"]
        read <- map["read"]
        readCount <- map["readCount"]
        state <- map["state"]
        teacherAvatar <- map["teacherAvatar"]
        teacherId <- map["teacherId"]
        teacherName <- map["teacherName"]
        title <- map["title"]
        type <- map["type"]
        videoUrl <- map["videoUrl"]
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
        censusId = aDecoder.decodeObject(forKey: "censusId") as? Int
        classChildrenCount = aDecoder.decodeObject(forKey: "classChildrenCount") as? Int
        classId = aDecoder.decodeObject(forKey: "classId") as? Int
        className = aDecoder.decodeObject(forKey: "className") as? String
        commitCount = aDecoder.decodeObject(forKey: "commitCount") as? Int
        content = aDecoder.decodeObject(forKey: "content") as? String
        createTime = aDecoder.decodeObject(forKey: "createTime") as? String
        endTime = aDecoder.decodeObject(forKey: "endTime") as? String
        imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? String
        isTop = aDecoder.decodeObject(forKey: "isTop") as? Int
        link = aDecoder.decodeObject(forKey: "link") as? String
        optionList = aDecoder.decodeObject(forKey: "optionList") as? [String]
        read = aDecoder.decodeObject(forKey: "read") as? Bool
        readCount = aDecoder.decodeObject(forKey: "readCount") as? Int
        state = aDecoder.decodeObject(forKey: "state") as? Int
        teacherAvatar = aDecoder.decodeObject(forKey: "teacherAvatar") as? String
        teacherId = aDecoder.decodeObject(forKey: "teacherId") as? Int
        teacherName = aDecoder.decodeObject(forKey: "teacherName") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        type = aDecoder.decodeObject(forKey: "type") as? Int
        videoUrl = aDecoder.decodeObject(forKey: "videoUrl") as? String
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
        if censusId != nil{
            aCoder.encode(censusId, forKey: "censusId")
        }
        if classChildrenCount != nil{
            aCoder.encode(classChildrenCount, forKey: "classChildrenCount")
        }
        if classId != nil{
            aCoder.encode(classId, forKey: "classId")
        }
        if className != nil{
            aCoder.encode(className, forKey: "className")
        }
        if commitCount != nil{
            aCoder.encode(commitCount, forKey: "commitCount")
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
        if imageUrl != nil{
            aCoder.encode(imageUrl, forKey: "imageUrl")
        }
        if isTop != nil{
            aCoder.encode(isTop, forKey: "isTop")
        }
        if link != nil{
            aCoder.encode(link, forKey: "link")
        }
        if optionList != nil{
            aCoder.encode(optionList, forKey: "optionList")
        }
        if read != nil{
            aCoder.encode(read, forKey: "read")
        }
        if readCount != nil{
            aCoder.encode(readCount, forKey: "readCount")
        }
        if state != nil{
            aCoder.encode(state, forKey: "state")
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
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if videoUrl != nil{
            aCoder.encode(videoUrl, forKey: "videoUrl")
        }
    }
    
}
