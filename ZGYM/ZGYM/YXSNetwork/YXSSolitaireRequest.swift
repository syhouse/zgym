//
//  SolitaireRequest.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/14.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

// MARK: - 接龙详情
let censusCensusDetail = "/census/censusDetail"
class YXSEducationCensusCensusDetailRequest: YXSBaseRequset {
    //接龙状态（0 全部 10 正在接龙 100 已结束:按照接龙的结束时间 ）
    init(censusId: Int, childrenId: Int) {
        super.init()
        host = homeHost
        method = .post
        path = censusCensusDetail
        param = ["censusId":censusId, "childrenId":childrenId]
    }
}


let censusParentStaffList = "/census/parentStaffList"
// MARK: - 参与人员列表（家长）
class YXSEducationCensusParentStaffListRequest: YXSBaseRequset {
    //接龙状态（0 全部 10 正在接龙 100 已结束:按照接龙的结束时间 ）
    init(censusId: Int) {
        super.init()
        host = homeHost
        method = .post
        path = censusParentStaffList
        param = ["censusId":censusId]
    }
}


let censusParentCommit = "/census/parentCommit"
// MARK: - 提交(家长)
class YXSEducationCensusParentCommitRequest: YXSBaseRequset {
    //接龙状态（0 全部 10 正在接龙 100 已结束:按照接龙的结束时间 ）
    init(censusId: Int, childrenId: Int, option: String) {
        super.init()
        host = homeHost
        method = .post
        path = censusParentCommit
        param = ["censusId":censusId, "childrenId":childrenId, "option":option]
    }
}


let censusTeacherStaffList = "/census/teacherStaffList"
// MARK: - 参与人员列表（老师）
class YXSEducationCensusTeacherStaffListRequest: YXSBaseRequset {
    //接龙状态（0 全部 10 正在接龙 100 已结束:按照接龙的结束时间 ）
    init(censusId: Int) {
        super.init()
        host = homeHost
        method = .post
        path = censusTeacherStaffList
        param = ["censusId":censusId]
    }
}

// MARK: -发布(老师)
let censusTeacherPublish = "/census/teacherPublish"
class YXSEducationCensusTeacherPublishRequest: YXSBaseRequset {
    init(classIdList: [Int], content:String = "", audioUrl: String = "", audioDuration: Int = 0,videoUrl: String = "",bgUrl: String = "",imageUrl: String = "",link: String = "",commitUpperLimit: Int,optionList: [String] ,endTime: String ,isTop: Int) {
        super.init()
        //去除空字符串选项
        var newOptionList = [String]()
        for option in optionList{
            if !option.isBlank{
                newOptionList.append(option)
            }
        }
        method = .post
        host = homeHost
        path = censusTeacherPublish
        param = ["classIdList":classIdList,
                 "content": content,
                 "audioUrl":audioUrl,
                 "optionList": newOptionList,
                 "audioDuration":audioDuration,
                 "videoUrl": videoUrl,
                 "bgUrl":bgUrl,
                 "link": link,
                 "imageUrl": imageUrl,
                 "endTime":endTime,
                 "isTop": isTop,
                 "commitUpperLimit":commitUpperLimit]
    }
}

// MARK: -接龙列表(老师)
let censusTeacherCensusList = "/census/teacherCensusList"
class YXSEducationCensusTeacherCensusListRequest: YXSBaseRequset {
    //接龙状态（0 全部 10 正在接龙 100 已结束:按照接龙的结束时间 ）
    init(currentPage: Int, pageSize: Int = kPageSize,state: Int,classId: Int?,stage: StageType) {
        super.init()
        host = homeHost
        method = .post
        path = censusTeacherCensusList
        param = ["pageSize":pageSize,
                 "state": state,
                 "currentPage": currentPage,
                 "stage": stage.rawValue
        ]
        if let classId = classId{
            param?["classId"] = classId
        }
    }
}
// MARK: -接龙列表(家长)
let censusParentCensusList = "/census/parentCensusList"
class YXSEducationCensusParentCensusListRequest: YXSBaseRequset {
    //接龙状态（0 全部 10 未接 20 正在接龙 100 已结束:按照接龙的结束时间 ）
    init(currentPage: Int, pageSize: Int = kPageSize,state: Int,childrenId: Int) {
        super.init()
        host = homeHost
        method = .post
        path = censusParentCensusList
        param = ["pageSize":pageSize,
                 "state": state,
                 "childrenId": childrenId,
                 "currentPage": currentPage]
    }
}


///census/parentCensusList
//接龙列表(家长)

// MARK: -撤销(老师)
let censusTeacherUndo = "/census/teacherUndo"
class YXSEducationCensusTeacherUndoRequest: YXSBaseRequset {
    init(censusId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = censusTeacherUndo
        param = [
            "censusId": censusId]
    }
}


// MARK: -置顶 (老师)
let censusUpdateTop = "/census/updateTop"
class YXSEducationCensusUpdateTopRequest: YXSBaseRequset {
    //    0:取消置顶|1:置顶
    init(censusId: Int,isTop: Int) {
        super.init()
        method = .post
        host = homeHost
        path = censusUpdateTop
        param = [
            "censusId": censusId,
            "isTop" : isTop]
    }
}


// MARK: -待办分页查询 (老师)
let censusTeacherTodo = "/census/teacherTodo"
class YXSEducationCensusTeacherTodoTodoRequest: YXSBaseRequset {
    init(currentPage: Int,pageSize: Int = kPageSize) {
        super.init()
        method = .post
        host = homeHost
        path = censusTeacherTodo
        param = ["currentPage": currentPage,
                 "pageSize": pageSize]
    }
}

// MARK: -待办分页查询 (家长)
let censusParentTodo = "/census/parentTodo"
class YXSEducationCensusParentTodoRequest: YXSBaseRequset {
    init(currentPage: Int,pageSize: Int = kPageSize) {
        super.init()
        method = .post
        host = homeHost
        path = censusParentTodo
        param = ["currentPage": currentPage,
                 "pageSize": pageSize]
    }
}


// MARK: -班级学生人员数量
let gradeFindNumberOfStudents = "/grade/findNumberOfStudents"
class YXSEducationGradeFindNumberOfStudentsRequest: YXSBaseRequset {
    //接龙状态（0 全部 10 未接 20 正在接龙 100 已结束:按照接龙的结束时间 ）
    init(gradeId: Int) {
        super.init()
        host = homeHost
        method = .post
        path = gradeFindNumberOfStudents
        param = ["gradeId":gradeId]
    }
}

// MARK: - 调查表模板列表(老师)
let censusTeacherGatherTemplateList = "/census/teacherTemplateList"
class YXSEducationCensusTeacherGatherTemplateListRequest: YXSBaseRequset {
    init(currentPage: Int,pageSize: Int = kPageSize) {
        super.init()
        host = homeHost
        method = .post
        path = censusTeacherGatherTemplateList
        param = ["currentPage": currentPage,
                 "pageSize": pageSize]
    }
}

// MARK: - 调查表模板详情(老师)
let censusTeacherGatherTemplateDetail = "/census/teacherTemplateDetail"
class YXSEducationCensusTeacherGatherTemplateDetailRequest: YXSBaseRequset {
    init(id: Int) {
        super.init()
        host = homeHost
        method = .post
        path = censusTeacherGatherTemplateDetail
        param = ["id": id]
    }
}

// MARK: - v1发布采集(老师)
let censusV1TeacherPublishGather = "/census/v1/teacherPublishGather"
class YXSCensusV1TeacherPublishGatherRequest: YXSBaseRequset {
    init(classIdList: [Int], content:String = "", title: String, audioUrl: String = "", audioDuration: Int = 0,videoUrl: String = "",bgUrl: String = "",imageUrl: String = "",link: String = "",commitUpperLimit: Int,endTime: String ,isTop: Int, optionList:[[String: String]])  {
        super.init()
        host = homeHost
        method = .post
        path = censusV1TeacherPublishGather
        //        //去除空字符串选项
        //        var newOptionList = [String]()
        //        for option in optionList{
        //            if !option.isBlank{
        //                newOptionList.append(option)
        //            }
        //        }
        
        param = [
            "title": title,
            "classIdList":classIdList,
            "content": content,
            "audioUrl":audioUrl,
            "gatherHolders": optionList,
            "audioDuration":audioDuration,
            "videoUrl": videoUrl,
            "bgUrl":bgUrl,
            "link": link,
            "imageUrl": imageUrl,
            "endTime":endTime,
            "isTop": isTop,
            "commitUpperLimit":commitUpperLimit]
    }
}


// MARK: - v1发布采集(老师)
let censusV1TeacherPublishEnter = "/census/v1/teacherPublishEnter"
class YXSCensusV1TeacherPublishEnterRequest: YXSBaseRequset {
    init(classIdList: [Int], content:String = "", title: String, audioUrl: String = "", audioDuration: Int = 0,videoUrl: String = "",bgUrl: String = "",imageUrl: String = "",link: String = "",commitUpperLimit: Int,endTime: String ,isTop: Int)  {
        super.init()
        host = homeHost
        method = .post
        path = censusV1TeacherPublishEnter
        
        param = [
            "title": title,
            "classIdList":classIdList,
            "content": content,
            "audioUrl":audioUrl,
            "audioDuration":audioDuration,
            "videoUrl": videoUrl,
            "bgUrl":bgUrl,
            "link": link,
            "imageUrl": imageUrl,
            "endTime":endTime,
            "isTop": isTop,
            "commitUpperLimit":commitUpperLimit]
    }
}
