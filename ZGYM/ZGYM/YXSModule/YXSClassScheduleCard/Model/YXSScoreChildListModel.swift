//
//  YXSScoreChildListModel.swift
//  ZGYM
//
//  Created by yihao on 2020/6/3.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import ObjectMapper

class YXSScoreChildListModel: NSObject, Mappable {
    /// 孩子头像
    var avatar: String?
    /// 孩子id
    var childrenId: Int?
    /// 孩子名称
    var childrenName: String?
    /// 孩子总分数
    var sumScore: Int?
    
    /// 等级
    var rank: String?
    
    ///考试名称
    var examName: String?
    ///发布时间（yyyy-MM-dd HH:mm:ss）
    var creationTime: String?
    ///考试ID
    var examId: Int?
    
    var statisticsParentChildScoreSingleReportResponseList: [YXSScoreChildSingleReportModel]?
    
    required init?(map: Map){}

    func mapping(map: Map)
    {
        avatar <- map["avatar"]
        childrenId <- map["childrenId"]
        childrenName <- map["childrenName"]
        sumScore <- map["sumScore"]
        examName <- map["examName"]
        creationTime <- map["creationTime"]
        examId <- map["examId"]
        rank <- map["rank"]
        statisticsParentChildScoreSingleReportResponseList <- map["statisticsParentChildScoreSingleReportResponseList"]
    }
}

class YXSScoreChildSingleReportModel: NSObject, Mappable {
    /// 统计柱状图数据
    var statisticsBranchSubjectsScoreNumberEntities: [YXSScoreTotalStatementModel]?
    /// 孩子当前得分
    var currentScore: Int?
    /// 科目id
    var subjectsId: Int?
    /// 孩子当前分段
    var currentBranch: String?
    /// 科目名
    var subjectsName: String?
    required init?(map: Map){}

    func mapping(map: Map)
    {
        statisticsBranchSubjectsScoreNumberEntities <- map["statisticsBranchSubjectsScoreNumberEntities"]
        currentScore <- map["currentScore"]
        subjectsId <- map["subjectsId"]
        currentBranch <- map["currentBranch"]
        subjectsName <- map["subjectsName"]
    }
}
