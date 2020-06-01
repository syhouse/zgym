//
//  HomeWorkRequset.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/12.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import ObjectMapper

// MARK: - 作业
// MARK: -homeworkPublish
let homeworkPublish = "/homework/publish"
class YXSEducationHomeworkPublishRequest: YXSBaseRequset {
    
    init(classIdList: [Int], content:String = "", audioUrl: String = "", teacherName: String, audioDurationList: String,audioDuration: Int = 0,videoUrl: String = "",bgUrl: String = "",imageUrl: String = "",link: String = "",onlineCommit: Int ,isTop: Int, endTime: String?, homeworkVisible: Int, remarkVisible: Int, fileList: [[String: Any]],synchClassFile: Int = 0) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkPublish
        param = ["classIdList":classIdList,
                 "content": content,
                 "audioUrl":audioUrl,
                 "teacherName": teacherName,
//                 "audioDurationList":audioDurationList,
                 "audioDuration":audioDuration,
                 "videoUrl": videoUrl,
                 "bgUrl":bgUrl,
                 "link": link,
                 "imageUrl": imageUrl,
                 "onlineCommit":onlineCommit,
                 "isTop": isTop,
        "homeworkVisible": homeworkVisible,
        "remarkVisible": remarkVisible,
        "fileList":fileList,
        "synchClassFile":synchClassFile]
        if let endTime = endTime{
            param?["endTime"] = endTime
        }
    }
}

class YXSHomeworkFileRequest: NSObject,Mappable {
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        fileId <- map["fileId"]
        fileName <- map["fileName"]
        fileSize <- map["fileSize"]
        fileType <- map["fileType"]
        fileUrl <- map["fileUrl"]
    }
    
    init(fileModel:YXSFileModel) {
        super.init()
        fileId = fileModel.id
        fileName = fileModel.fileName
        fileSize = fileModel.fileSize
        fileType = fileModel.fileType
        fileUrl = fileModel.fileUrl
    }
    var fileId: Int?
    var fileName: String?
    var fileSize: Int?
    var fileType: String?
    var fileUrl: String?
}

// MARK: -作业已读请求参数
let homeworkCustodianUpdateRead = "/homework/custodian-update-read"
class YXSEducationHomeworkCustodianUpdateReadRequest: YXSBaseRequset {
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
class YXSEducationHomeworkQueryHomeworkByIdRequest: YXSBaseRequset {
    init(childrenId: Int, homeworkCreateTime: String, homeworkId: Int ) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkQueryHomeworkById
        param = ["childrenId":childrenId,
                 "homeworkCreateTime": homeworkCreateTime,
                 "homeworkId":homeworkId]
    }
}

// MARK: -孩子作业分页查询
let HomeworkChildrenPageQuery = "/homework/page-query-children-homework"
class YXSEducationHomeworkChildrenPageQueryRequest: YXSBaseRequset {
    init(currentPage: Int, homeworkCreateTime: String, homeworkId: Int ,pageSize: Int, isGood: Int = -1, isRemark: Int = -1) {
        super.init()
        method = .post
        host = homeHost
        path = HomeworkChildrenPageQuery
        param = ["currentPage":currentPage,
        "homeworkCreateTime": homeworkCreateTime,
        "homeworkId":homeworkId,
        "pageSize": pageSize]
        if isGood != -1 {
            //查询优秀作业
            param = ["currentPage":currentPage,
            "homeworkCreateTime": homeworkCreateTime,
            "homeworkId":homeworkId,
            "pageSize": pageSize,
            "isGood": 1]

        } else {
            param = ["currentPage":currentPage,
            "homeworkCreateTime": homeworkCreateTime,
            "homeworkId":homeworkId,
            "pageSize": pageSize,
            "isGood": 0]
            if isRemark != -1 {
                param = ["currentPage":currentPage,
                "homeworkCreateTime": homeworkCreateTime,
                "homeworkId":homeworkId,
                "pageSize": pageSize,
                "isRemark": isRemark,
                "isGood": 0]
            }
        }
    }
}

// MARK: -孩子作业点赞或取消点赞
let HomeworkPraiseRequest = "/homework/praise-or-cancel"
class YXSEducationHomeworkPraiseRequest: YXSBaseRequset {
    init(childrenId: Int, homeworkCreateTime: String, homeworkId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = HomeworkPraiseRequest
        param = ["childrenId":childrenId,
        "homeworkCreateTime": homeworkCreateTime,
        "homeworkId":homeworkId]
    }
}

// MARK: -作业提交后详情请求参数
let homeworkQueryHomeworkCommitById = "/homework/query-homework-commit-by-id"
class YXSEducationHomeworkQueryHomeworkCommitByIdRequest: YXSBaseRequset {
    init(childrenId: Int, homeworkCreateTime: String, homeworkId: Int ) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkQueryHomeworkCommitById
        param = ["childrenId":childrenId,
                 "homeworkCreateTime": homeworkCreateTime,
                 "homeworkId":homeworkId]
    }
}

// MARK: -分页查询孩子历史优秀
let homeworkQueryHistoryGood = "/homework/page-query-history-good"
class YXSEducationHomeworkQueryHistoryGoodRequest: YXSBaseRequset {
    init(childrenId: Int, classId: Int, currentPage: Int = 1) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkQueryHistoryGood
        param = ["childrenId":childrenId,
                 "classId": classId,
                 "currentPage":currentPage,
                 "pageSize":20]
    }
}

// MARK: - 阅读和提交列表请求参数
let homeworkQueryCommitReadInfo = "/homework/query-commit-read-info"
/// gradeId（班级id）
class YXSEducationHomeworkQueryCommitReadInfoRequest: YXSBaseRequset {
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
class YXSEducationHomeworkCustodianCommitRequest: YXSBaseRequset {
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

// MARK: -家长修改作业
let homeworkCustodianUpdateHomework = "/homework/custodian-update-homework"
class YXSEducationHomeworkCustodianUpdateHomeworkRequest: YXSBaseRequset {
    init(childrenId: Int, homeworkId: Int, content:String = "", audioUrl: String = "", audioDuration: Int = 0,videoUrl: String = "",bgUrl: String = "",imageUrl: String = "",homeworkCreateTime: String ) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkCustodianUpdateHomework
        param = [
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
class YXSEducationHomeworkCancelRequest: YXSBaseRequset {
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
class YXSEducationHomeworkUpdateTopRequest: YXSBaseRequset {
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
class YXSEducationHomeworkPageQueryRequest: YXSBaseRequset {
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
class YXSEducationHomeworkPageQueryTeacherTodoRequest: YXSBaseRequset {
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
class YXSEducationHomeworkPageQueryChildrenTodoRequest: YXSBaseRequset {
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
class YXSEducationHomeworkBatchRemark:YXSBaseRequset {
    init(homeworkId: Int, remark: String , childrenIdList: [Int] , remarkAudioUrl: String ,remarkAudioDuration: Int ,homeworkCreateTime: String, isGood: Int = 0) {
        super.init()
        host = homeHost
        method = .post
        path = homeworkBatchRemark
        if isGood == -1 {
            param = ["homeworkId":homeworkId,
            "remark": remark,
            "childrenIdList": childrenIdList,
            "remarkAudioUrl":remarkAudioUrl,
            "remarkAudioDuration":remarkAudioDuration,
            "homeworkCreateTime":homeworkCreateTime]
        } else {
            param = ["homeworkId":homeworkId,
            "remark": remark,
            "childrenIdList": childrenIdList,
            "remarkAudioUrl":remarkAudioUrl,
            "remarkAudioDuration":remarkAudioDuration,
            "homeworkCreateTime":homeworkCreateTime,
            "isGood":isGood]
        }
        
    }
}

// MARK: -老师点评修改
let homeworkRemarkUpdate = "/homework/update-remark"
class YXSEducationHomeworkRemarkUpdate:YXSBaseRequset {
    init(homeworkId: Int, remark: String , childrenId: Int , remarkAudioUrl: String ,remarkAudioDuration: Int ,homeworkCreateTime: String, isGood: Int = 0) {
        super.init()
        host = homeHost
        method = .post
        path = homeworkRemarkUpdate
        param = ["homeworkId":homeworkId,
        "remark": remark,
        "childrenId": childrenId,
        "remarkAudioUrl":remarkAudioUrl,
        "remarkAudioDuration":remarkAudioDuration,
        "homeworkCreateTime":homeworkCreateTime,
        "isGood":isGood]
    }
}

// MARK: -老师点评撤销
let homeworkRemarkCancel = "/homework/remark-cancel"
class YXSEducationHomeworkRemarkCancel:YXSBaseRequset {
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
class YXSEducationHomeworkStudentCancelRequest: YXSBaseRequset {
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
