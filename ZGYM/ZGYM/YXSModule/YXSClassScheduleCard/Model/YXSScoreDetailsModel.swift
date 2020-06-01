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
    var averageScore: Int?
    ///班级ID
    var classId: Int?
    ///班级名称
    var className: String?
    ///考试时间（yyyy-MM-dd HH:mm:ss）
    var creationTime: String?
    ///考试ID
    var examId: Int?
    ///考试名称
    var examName: String?
    ///最高学段分
    var highestBranch: String?
    ///最高分
    var highestScore: Int?
    ///最低分
    var lowestScore: Int?
    ///人数
    var number: Int?
    ///阅读人数
    var readNumber: Int?
    ///总人数统计报表
    var totalStatement: String?
    
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
    }
}
