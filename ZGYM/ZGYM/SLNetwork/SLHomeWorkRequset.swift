//
//  HomeWorkRequset.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/12.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

// MARK: - 作业
// MARK: -homeworkPublish
let homeworkPublish = "/homework/publish"
class SLEducationHomeworkPublishRequest: SLBaseRequset {
    init(classIdList: [Int], content:String = "", audioUrl: String = "", teacherName: String, audioDuration: Int = 0,videoUrl: String = "",bgUrl: String = "",imageUrl: String = "",link: String = "",onlineCommit: Int ,isTop: Int) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkPublish
        param = ["classIdList":classIdList,
                 "content": content,
                 "audioUrl":audioUrl,
                 "teacherName": teacherName,
                 "audioDuration":audioDuration,
                 "videoUrl": videoUrl,
                 "bgUrl":bgUrl,
                 "link": link,
                 "imageUrl": imageUrl,
                 "onlineCommit":onlineCommit,
                 "isTop": isTop]
    }
}

// MARK: -作业已读请求参数
let homeworkCustodianUpdateRead = "/homework/custodian-update-read"
class SLEducationHomeworkCustodianUpdateReadRequest: SLBaseRequset {
    init(childrenId: Int, homeworkCreateTime: String, homeworkId: Int ) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkCustodianUpdateRead
        param = ["childrenId":childrenId,
                 "homeworkCreateTime": homeworkCreateTime,
                 "homeworkId":homeworkId]
    }
}


// MARK: -作业详情请求参数
let homeworkQueryHomeworkById = "/homework/query-homework-by-id"
class SLEducationHomeworkQueryHomeworkByIdRequest: SLBaseRequset {
    init(childrenId: Int, homeworkCreateTime: String, homeworkId: Int ) {
        super.init()
        method = .post
        host = homeHost
        isLoadCache = true
        path = homeworkQueryHomeworkById
        param = ["childrenId":childrenId,
                 "homeworkCreateTime": homeworkCreateTime,
                 "homeworkId":homeworkId]
    }
}


// MARK: -作业提交后详情请求参数
let homeworkQueryHomeworkCommitById = "/homework/query-homework-commit-by-id"
class SLEducationHomeworkQueryHomeworkCommitByIdRequest: SLBaseRequset {
    init(childrenId: Int, homeworkCreateTime: String, homeworkId: Int ) {
        super.init()
        method = .post
        host = homeHost
        isLoadCache = true
        path = homeworkQueryHomeworkCommitById
        param = ["childrenId":childrenId,
                 "homeworkCreateTime": homeworkCreateTime,
                 "homeworkId":homeworkId]
    }
}

// MARK: - 阅读和提交列表请求参数
let homeworkQueryCommitReadInfo = "/homework/query-commit-read-info"
/// gradeId（班级id）
class SLEducationHomeworkQueryCommitReadInfoRequest: SLBaseRequset {
    init(gradeId: Int, homeworkCreateTime: String, homeworkId: Int ) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkQueryCommitReadInfo
        param = ["gradeId":gradeId,
                 "homeworkCreateTime": homeworkCreateTime,
                 "homeworkId":homeworkId]
    }
}


// MARK: -家长作业提交请求参数
let homeworkCustodianCommit = "/homework/custodian-commit-homework"
class SLEducationHomeworkCustodianCommitRequest: SLBaseRequset {
    init(id: Int,childrenId: Int, homeworkId: Int, content:String = "", audioUrl: String = "", audioDuration: Int = 0,videoUrl: String = "",bgUrl: String = "",imageUrl: String = "",homeworkCreateTime: String ) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkCustodianCommit
        param = ["id":id,
                 "childrenId":childrenId,
                 "content": content,
                 "audioUrl":audioUrl,
                 "homeworkId": homeworkId,
                 "audioDuration":audioDuration,
                 "videoUrl": videoUrl,
                 "bgUrl": bgUrl,
                 "imageUrl": imageUrl,
                 "homeworkCreateTime":homeworkCreateTime]
    }
}

// MARK: -作业撤销
let homeworkCancel = "/homework/cancel"
class SLEducationHomeworkCancelRequest: SLBaseRequset {
    init(homeworkId: Int, homeworkCreateTime: String) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkCancel
        param = [
                 "homeworkCreateTime": homeworkCreateTime,
                 "homeworkId":homeworkId]
    }
}
// MARK: -置顶与取消置顶

let homeworkUpdateTop = "/homework/update-top"
class SLEducationHomeworkUpdateTopRequest: SLBaseRequset {
//    0:取消置顶|1:置顶
    init(homeworkId: Int, homeworkCreateTime: String,isTop: Int) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkUpdateTop
        param = [
                 "homeworkCreateTime": homeworkCreateTime,
                 "homeworkId":homeworkId,
                 "isTop":isTop]
    }
}

// MARK: -查询分页查询
let homeworkPageQuery = "/homework/page-query"
class SLEducationHomeworkPageQueryRequest: SLBaseRequset {
//    过滤条件(0:老师仅看我发布的,1:未提交,2:已提交),查所有无需传该条件
    init(currentPage: Int, pageSize: Int = kPageSize,classIdList: [Int],userType: String,childrenId: Int?,filterType: Int?) {
        super.init()
        host = homeHost
        method = .post
        path = homeworkPageQuery
        param = ["pageSize":pageSize,
                 "userType": userType,
                 "classIdList": classIdList,
                 "currentPage": currentPage]
        
        if let childrenId = childrenId{
            param?["childrenId"] = childrenId
        }
        if let filterType = filterType{
            param?["filterType"] = filterType
        }
    }
}

// MARK: -老师作业待办分页查询
let homeworkPageQueryTeacherTodo = "/homework/page-query-teacher-todo"
class SLEducationHomeworkPageQueryTeacherTodoRequest: SLBaseRequset {
    init(currentPage: Int, pageSize: Int = kPageSize) {
        super.init()
        host = homeHost
        method = .post
        path = homeworkPageQueryTeacherTodo
        param = ["pageSize":pageSize,
                 "currentPage": currentPage]
    }
}

// MARK: -孩子作业待办分页查询
let homeworkPageQueryChildrenTodo = "/homework/page-query-children-todo"
class SLEducationHomeworkPageQueryChildrenTodoRequest: SLBaseRequset {
    init(currentPage: Int, pageSize: Int = kPageSize, childrenClassList: [[String: Int]]) {
        super.init()
        host = homeHost
        method = .post
        path = homeworkPageQueryChildrenTodo
        param = ["pageSize":pageSize,
                 "currentPage": currentPage,
                 "childrenClassList": childrenClassList]
    }
}


// MARK: -老师批量点评
let homeworkBatchRemark = "/homework/batch-remark"
class SLEducationHomeworkBatchRemark:SLBaseRequset {
    init(homeworkId: Int, remark: String , childrenIdList: [Int] , remarkAudioUrl: String ,remarkAudioDuration: Int ,homeworkCreateTime: String) {
        super.init()
        host = homeHost
        method = .post
        path = homeworkBatchRemark
        param = ["homeworkId":homeworkId,
                 "remark": remark,
                 "childrenIdList": childrenIdList,
                 "remarkAudioUrl":remarkAudioUrl,
                 "remarkAudioDuration":remarkAudioDuration,
                 "homeworkCreateTime":homeworkCreateTime ]
    }
}

// MARK: -老师点评撤销
let homeworkRemarkCancel = "/homework/remark-cancel"
class SLEducationHomeworkRemarkCancel:SLBaseRequset {
    init(homeworkId: Int, childrenId: Int , homeworkCreateTime: String) {
        super.init()
        host = homeHost
        method = .post
        path = homeworkRemarkCancel
        param = ["homeworkId":homeworkId,
                 "childrenId": childrenId,
                 "homeworkCreateTime":homeworkCreateTime ]
    }
}

 // MARK: -家长提交作业撤销
let homeworkStudentCancel = "/homework/custodian-commit-cancel"
class SLEducationHomeworkStudentCancelRequest: SLBaseRequset {
    init(childrenId: Int, homeworkCreateTime: String, homeworkId:Int) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkStudentCancel
        param = [
                 "homeworkCreateTime": homeworkCreateTime,
                 "childrenId":childrenId,
                 "homeworkId":homeworkId
        ]
    }
}
