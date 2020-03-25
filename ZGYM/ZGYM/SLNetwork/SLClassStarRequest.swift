//
//  ClassStarRequest.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/19.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

// MARK: - 班级之星（小学|中学|幼儿园）
// MARK: -老师班级的排名信息

let classStarTeacherClassTop = "/classStar/teacherClassTop"
class SLEducationClassStarTeacherClassTopRequest: SLBaseRequset {
    init(childrenId: Int? = nil, classId: Int? = nil,stage: StageType? = nil, dateType: DateType?) {
        super.init()
        method = .post
        host = homeHost
        path = classStarTeacherClassTop
        param = [String: Any]()
        if let classId = classId{
            param?["classId"] = classId
        }
        if let childrenId = childrenId{
            param?["childrenId"] = childrenId
        }
        if let stage = stage{
            param?["stage"] = stage.rawValue
        }
        if let dateType = dateType{
            if dateType == .D{
                param?["startTime"] = sl_startTime()
                param?["endTime"] = sl_startTime().sl_tomorrow()
            }else{
                param?["dateType"] = dateType.rawValue
            }
        }
    }
}

// MARK: -学生得分详情
let classStarChildrenScoreDetail = "/classStar/childrenScoreDetail"
class SLEducationClassStarChildrenScoreDetailRequest: SLBaseRequset {
    init(classId: Int,childrenId: Int? = nil, dateType: DateType?) {
        super.init()
        method = .post
        host = homeHost
        path = classStarChildrenScoreDetail
        param = ["classId": classId]
        if let childrenId = childrenId{
            param?["childrenId"] = childrenId
        }
        if let dateType = dateType{
            if dateType == .D{
                param?["startTime"] = sl_startTime()
                param?["endTime"] = sl_startTime().sl_tomorrow()
            }else{
                param?["dateType"] = dateType.rawValue
            }
        }
    }
}


// MARK: -考评项列表
//KINDERGARTEN幼儿园 PRIMARY_SCHOOL小学 MIDDLE_SCHOOL中学
//分类：10:幼儿园,20小学和中学
let evaluationListList = "/evaluationList/list"
class SLEducationFEvaluationListListRequest: SLBaseRequset {
    init(classId: Int, stage: StageType) {
        super.init()
        var classify: Int = 20
        if stage == .KINDERGARTEN{
            classify = 10
        }
        method = .post
        host = homeHost
        path = evaluationListList
        param = ["classify": classify,
                 "classId": classId,
                 "clientType":"ios",
                 "definition":"@3x"]
    }
}

// MARK: -考评项类型列表
//KINDERGARTEN幼儿园 PRIMARY_SCHOOL小学 MIDDLE_SCHOOL中学
//分类：10:幼儿园,20小学和中学
let evaluationListTypeList = "/evaluationList/typeList"
class SLEducationFEvaluationListTypeListRequest: SLBaseRequset {
    init(stage: StageType) {
        super.init()
        method = .post
        host = homeHost
        path = evaluationListTypeList
        var classify: Int = 20
        if stage == .KINDERGARTEN{
            classify = 10
        }
        param = ["classify": classify,
                 "clientType":"ios",
                 "definition":"@3x"]
    }
}

// MARK: -新增与更新
//KINDERGARTEN幼儿园 PRIMARY_SCHOOL小学 MIDDLE_SCHOOL中学
//分类：10:幼儿园,20小学和中学
let evaluationListSaveOrUpdate = "/evaluationList/saveOrUpdate"
class SLEducationFEvaluationListSaveOrUpdateRequest: SLBaseRequset {
    init(id: Int? = nil,classId: Int,category: Int, evaluationItem: String,evaluationType: Int,score: Int,type: Int, stage: StageType) {
        super.init()
        var classify: Int = 20
        if stage == .KINDERGARTEN{
            classify = 10
        }
        method = .post
        host = homeHost
        path = evaluationListSaveOrUpdate
        param = ["classId": classId,
                 "category": category,
                 "evaluationItem": evaluationItem,
                 "evaluationType": evaluationType,
                 "classify": classify,
                 "score": score,
                 "type": type]
        
        if let id = id{
            param?["id"] = id
        }
    }
}
// MARK: -老师考评小孩（分页）
//类别(10:表扬类型,20:待改进类型)
let classStarTeacherEvaluationHistoryListPage = "/classStar/teacherEvaluationHistoryListPage"
class SLEducationClassStarTeacherEvaluationHistoryListPageRequest: SLBaseRequset {
    init(category: Int? = nil,childrenId: Int? = nil,classId: Int,currentPage: Int,pageSize: Int = kPageSize, dateType: DateType?,startTime: String? = nil, endTime: String? = nil) {
        super.init()
        
        method = .post
        host = homeHost
        path = classStarTeacherEvaluationHistoryListPage
        param = ["classId": classId,
                 "currentPage": currentPage,
                 "pageSize": pageSize]
        
        if let category = category{
            param?["category"] = category
        }
        if let childrenId = childrenId{
            param?["childrenId"] = childrenId
        }
        if let dateType = dateType{
            if dateType == .D{
                param?["startTime"] = sl_startTime()
                param?["endTime"] = sl_startTime().sl_tomorrow()
            }else{
                param?["dateType"] = dateType.rawValue
            }
        }
        
        if let startTime = startTime{
            param?["startTime"] = startTime
        }
        
        if let endTime = endTime{
            param?["endTime"] = endTime
        }
        
    }
}

// MARK: -删除自定义考评项
let evaluationListDelete = "/evaluationList/delete"
class SLEducationFEvaluationListDeleteRequest: SLBaseRequset {
    init(evaluationIds: [Int]) {
        super.init()
        
        method = .post
        host = homeHost
        path = evaluationListDelete
        param = ["evaluationIds": evaluationIds]
    }
}

// MARK: -学生排名榜（老师）
let classStarTeacherClassChildrenTop = "/classStar/teacherClassChildrenTop"
class SLEducationClassStarTeacherClassChildrenTopRequest: SLBaseRequset {
    //    排序方式（1 姓氏排序 2 总分数排序 默认为：2）
    init(childrenId: Int? = nil, classId: Int = 0, sortType: Int = 2, dateType: DateType? = nil) {
        super.init()
        method = .post
        host = homeHost
        path = classStarTeacherClassChildrenTop
        param = ["classId": classId,
                 "sortType":sortType]
        if let childrenId = childrenId{
            param?["childrenId"] = childrenId
        }
        if let dateType = dateType{
            if dateType == .D{
                param?["startTime"] = sl_startTime()
                param?["endTime"] = sl_startTime().sl_tomorrow()
            }else{
                param?["dateType"] = dateType.rawValue
            }
        }
        
        
    }
}

// MARK: -老师对学生考评
let classStarTeacherEvaluationChildren = "/classStar/teacherEvaluationChildren"
class SLEducationClassStarTeacherEvaluationChildrenRequest: SLBaseRequset {
    init(childrenIds: [Int], classId: Int, evaluationId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = classStarTeacherEvaluationChildren
        param = ["childrenIds": childrenIds,
                 "classId":classId,
                 "evaluationId":evaluationId]
    }
}

// MARK: -最高学生得分
let classStarChildrenBest = "/classStar/childrenBest"
class SLEducationClassStarChildrenBestRequest: SLBaseRequset {
    init(classId: Int, dateType: DateType) {
        super.init()
        method = .post
        host = homeHost
        path = classStarChildrenBest
        param = ["classId": classId]
        if dateType == .D{
            param?["startTime"] = sl_startTime()
            param?["endTime"] = sl_startTime().sl_tomorrow()
        }else{
            param?["dateType"] = dateType.rawValue
        }
    }
}

// MARK: -学生排名榜（家长）
let classStarParentClassChildrenTop = "/classStar/parentClassChildrenTop"
class SLEducationClassStarParentClassChildrenTopRequest: SLBaseRequset {
//    排序方式（1 姓氏排序 2 总分数排序 默认为：2）
    init(childrenId: Int, classId: Int, dateType: DateType?,sortType: Int = 2,startTime: String? = nil, endTime: String? = nil) {
        super.init()
        method = .post
        host = homeHost
        path = classStarParentClassChildrenTop
        param = ["classId": classId,
                 "childrenId": childrenId,
                 "sortType": sortType]
        
        if let dateType = dateType{
            if dateType == .D{
                param?["startTime"] = sl_startTime()
                param?["endTime"] = sl_startTime().sl_tomorrow()
            }else{
                param?["dateType"] = dateType.rawValue
            }
        }
        
        
        
        if let startTime = startTime{
            param?["startTime"] = startTime
        }
        
        if let endTime = endTime{
            param?["endTime"] = endTime
        }
    }
}
