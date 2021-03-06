//
//  YXSScoreDetailsModel.swift
//  ZGYM
//
//  Created by yihao on 2020/5/29.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import ObjectMapper

class YXSScoreDetailsModel: NSObject, Mappable {
    ///平均分
    var averageScore: Float?
    ///班级ID
    var classId: Int?
    ///班级名称
    var className: String?
    ///发布时间（yyyy-MM-dd HH:mm:ss）
    var creationTime: String?
    ///考试ID
    var examId: Int?
    ///考试名称
    var examName: String?
    ///最高学段分
    var highestBranch: String?
    ///最高分
    var highestScore: Float?
    ///最低分
    var lowestScore: Float?
    ///人数
    var number: Int?
    ///阅读人数
    var readNumber: Int?
    ///总人数统计报表
    var totalStatement: [YXSScoreTotalStatementModel]?
    ///孩子ID
    var childrenId: Int?
    ///孩子名称
    var childrenName: String?
    ///小孩当前得分分段
    var currentBranch: String?
    ///小孩当前得分分段评语
    var currentBranchComment: String?
    ///老师评语
    var comment: String?
    /// 孩子头像
    var avatar: String?
    
    /// 是否已阅
    var isRead: Bool?
    
    /// 老师imid
    var teacherImId: String {
        get {
            return "\(teacherId ?? 0)TEACHER"
        }
    }
    
    var teacherId: Int?
    
    var achievementChildrenSubjectsResponseList: [YXSScoreChildrenSubjectsModel]?
    var achievementChildrenSubjectsResponseSum: YXSScoreChildrenSubjectsModel?
    var childrenSubjects: [YXSScoreChildrenSubjectsModel] = [YXSScoreChildrenSubjectsModel]()
    
    var hierarchySubjectsResponseList: [YXSScoreChildrenSubjectsModel]?
    
    required init?(map: Map){}

    func mapping(map: Map)
    {
        averageScore <- map["averageScore"]
        classId <- map["classId"]
        className <- map["className"]
        creationTime <- map["creationTime"]
        examId <- map["examId"]
        examName <- map["examName"]
        highestBranch <- map["highestBranch"]
        highestScore <- map["highestScore"]
        lowestScore <- map["lowestScore"]
        number <- map["number"]
        readNumber <- map["readNumber"]
        totalStatement <- map["totalStatement"]
        childrenId <- map["childrenId"]
        childrenName <- map["childrenName"]
        currentBranch <- map["currentBranch"]
        currentBranchComment <- map["currentBranchComment"]
        comment <- map["comment"]
        avatar <- map["avatar"]
        achievementChildrenSubjectsResponseList <- map["achievementChildrenSubjectsResponseList"]
        achievementChildrenSubjectsResponseSum <- map["achievementChildrenSubjectsResponseSum"]
        hierarchySubjectsResponseList <- map["hierarchySubjectsResponseList"]
        teacherId <- map["teacherId"]
        isRead <- map["isRead"]
    }
}

class YXSScoreChildrenSubjectsModel: NSObject, Mappable {
    /// 小孩当前得分分段
    var branch: String?
    /// 得分
    var score: Float?
    /// 科目ID
    var subjectsId: Int?
    /// 科目名
    var subjectsName: String?
    
    /// 等级
    var rank: String?
    
    required init?(map: Map){}
    func mapping(map: Map) {
        branch <- map["branch"]
        score <- map["score"]
        subjectsId <- map["subjectsId"]
        subjectsName <- map["subjectsName"]
        rank <- map["rank"]
    }
}

class YXSScoreTotalStatementModel: NSObject, Mappable {
    /// 小孩当前得分分段
    var branch: String?
    /// 分段人数
    var quantity: Int?
    /// 分段ID
    var subjectsId: Int?
    required init?(map: Map){}
    func mapping(map: Map) {
        branch <- map["branch"]
        quantity <- map["quantity"]
        subjectsId <- map["subjectsId"]
    }
    
}
