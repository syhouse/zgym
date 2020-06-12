//
//  YXSScoreListModel.swift
//  ZGYM
//
//  Created by yihao on 2020/5/26.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import ObjectMapper

class YXSScoreListModel: NSObject, NSCoding, Mappable {

    /// 创建时间
    var creationTime: String?
    /// 计分策略（10分数制  /  20等级制）
    var calculativeStrategy: Int?
    /// 是否已阅
    var isRead: Bool?
    /// 总数
    var sumNumber: Int?
    /// 已阅数量
    var readNumber: Int?
    
    /// 班级id
    var classId: Int?
    /// 班级名称
    var className: String?
    
    var title: String?
    
    /// 老师名称
    var teacherName: String?
    /// 老师id
    var teacherId: Int?
    
    
    /// 考试ID
    var examId: Int?
    /// 考试名称
    var examName: String?
    /// 考试状态（-10 已删除 10未上传成绩、20已上传成绩、30 已发布）
    var examState: Int?
    
    
    required init?(map: Map){}

    func mapping(map: Map)
    {
        title <- map["title"]
        classId <- map["classId"]
        calculativeStrategy <- map["calculativeStrategy"]
        creationTime <- map["creationTime"]
        className <- map["className"]
        isRead <- map["isRead"]
        examId <- map["examId"]
        teacherName <- map["teacherName"]
        examName <- map["examName"]
        examState <- map["examState"]
        teacherId <- map["teacherId"]
        sumNumber <- map["sumNumber"]
        readNumber <- map["readNumber"]
    }
    
    @objc required init(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as? String
        classId = aDecoder.decodeObject(forKey: "classId") as? Int
        calculativeStrategy = aDecoder.decodeObject(forKey: "calculativeStrategy") as? Int
        creationTime = aDecoder.decodeObject(forKey: "creationTime") as? String
        className = aDecoder.decodeObject(forKey: "className") as? String
        isRead = aDecoder.decodeObject(forKey: "isRead") as? Bool
        examId = aDecoder.decodeObject(forKey: "examId") as? Int
        teacherName = aDecoder.decodeObject(forKey: "teacherName") as? String
        examName = aDecoder.decodeObject(forKey: "examName") as? String
        examState = aDecoder.decodeObject(forKey: "examState") as? Int
        teacherId = aDecoder.decodeObject(forKey: "teacherId") as? Int
        sumNumber = aDecoder.decodeObject(forKey: "sumNumber") as? Int
        readNumber = aDecoder.decodeObject(forKey: "readNumber") as? Int
    }
    @objc func encode(with aCoder: NSCoder)
    {
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if classId != nil{
            aCoder.encode(classId, forKey: "classId")
        }
        if calculativeStrategy != nil{
            aCoder.encode(calculativeStrategy, forKey: "calculativeStrategy")
        }
        if creationTime != nil{
            aCoder.encode(creationTime, forKey: "creationTime")
        }
        if className != nil{
            aCoder.encode(className, forKey: "className")
        }
        if isRead != nil{
            aCoder.encode(isRead, forKey: "isRead")
        }
        if examId != nil{
            aCoder.encode(examId, forKey: "examId")
        }
        if teacherName != nil{
            aCoder.encode(teacherName, forKey: "teacherName")
        }
        if examName != nil{
            aCoder.encode(examName, forKey: "examName")
        }
        if examState != nil{
            aCoder.encode(examState, forKey: "examState")
        }
        if teacherId != nil{
            aCoder.encode(teacherId, forKey: "teacherId")
        }
        if sumNumber != nil{
            aCoder.encode(sumNumber, forKey: "sumNumber")
        }
        if readNumber != nil{
            aCoder.encode(readNumber, forKey: "readNumber")
        }

    }
}
