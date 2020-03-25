//
//  NoticeRequset.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/13.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

// MARK: -提交回执
let noticeCustodianCommitReceipt = "/notice/custodian-commit-receipt"
class SLEducationNoticeCustodianCommitReceiptRequest: SLBaseRequset {
    init(noticeId: Int, childrenId:Int, noticeCreateTime: String) {
        super.init()
        method = .post
        host = homeHost
        path = noticeCustodianCommitReceipt
        param = [
                 "noticeCreateTime": noticeCreateTime,
                 "noticeId":noticeId,
                 "childrenId":childrenId]
    }
}

// MARK: -查询通知提交,已读详情
let noticeQueryCommitReadInfo = "/notice/query-commit-read-info"
class SLEducationNoticeQueryCommitReadInfoRequest: SLBaseRequset {
    init(noticeId: Int, gradeId:Int, noticeCreateTime: String) {
        super.init()
        method = .post
        host = homeHost
        path = noticeQueryCommitReadInfo
        param = [
                 "noticeCreateTime": noticeCreateTime,
                 "noticeId":noticeId,
                 "gradeId":gradeId]
    }
}

// MARK: -查询通知详情
let noticeQueryNoticeById = "/notice/query-notice-by-id"
class SLEducationNoticeQueryNoticeByIdRequest: SLBaseRequset {
    init(noticeId: Int, noticeCreateTime: String) {
        super.init()
        method = .post
        host = homeHost
        path = noticeQueryNoticeById
        isLoadCache = true
        param = [
                 "noticeCreateTime": noticeCreateTime,
                 "noticeId":noticeId]
    }
}

// MARK: -发布通知
let noticePublish = "/notice/publish"
class SLEducationNoticePublishRequest: SLBaseRequset {
    init(classIdList: [Int], content:String = "", audioUrl: String = "", teacherName: String, audioDuration: Int = 0,videoUrl: String = "",bgUrl: String = "",imageUrl: String = "",link: String = "",onlineCommit: Int ,isTop: Int) {
        super.init()
        method = .post
        host = homeHost
        path = noticePublish
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

// MARK: -分页查询
let noticePageQuery = "/notice/page-query"
class SLEducationNoticePageQueryRequest: SLBaseRequset {
//过滤条件(0:仅看我发布的),查所有无需传该条件
        init(currentPage: Int, pageSize: Int = kPageSize,classIdList: [Int],userType: String,filterType: Int?) {
        super.init()
        host = homeHost
        method = .post
        path = noticePageQuery
        param = ["pageSize":pageSize,
                 "userType": userType,
                 "classIdList": classIdList,
                 "currentPage": currentPage]
//
//        if let childrenId = childrenId{
//            param?["childrenId"] = childrenId
//        }
        if let filterType = filterType{
            param?["filterType"] = filterType
        }
    }
}

// MARK: -撤销
let noticeCancel = "/notice/cancel"
class SLEducationNoticeCancelRequest: SLBaseRequset {
    init(noticeId: Int, noticeCreateTime: String) {
        super.init()
        method = .post
        host = homeHost
        path = noticeCancel
        param = [
                 "noticeCreateTime": noticeCreateTime,
                 "noticeId":noticeId]
    }
}

// MARK: -置顶与取消置顶

let noticeUpdateTop = "/notice/update-top"
class SLEducationNoticeUpdateTopRequest: SLBaseRequset {
//    0:取消置顶|1:置顶
    init(noticeId: Int, noticeCreateTime: String,isTop: Int) {
        super.init()
        method = .post
        host = homeHost
        path = noticeUpdateTop
        param = [
                 "noticeCreateTime": noticeCreateTime,
                 "noticeId":noticeId,
                 "isTop":isTop]
    }
}
// MARK: -通知更新已读
let noticeCustodianUpdateRead = "/notice/custodian-update-read"
class SLEducationNoticeCustodianUpdateReadRequest: SLBaseRequset {
    init( childrenId: Int, noticeCreateTime: String, noticeId: Int ) {
        super.init()
        method = .post
        host = homeHost
        path = noticeCustodianUpdateRead
        param = ["childrenId":childrenId,
                 "noticeCreateTime": noticeCreateTime,
                 "noticeId":noticeId]
    }
}




// MARK: -老师通知待办分页查询
let noticePageQueryTeacherTodo = "/notice/page-query-teacher-todo"
class SLEducationNoticePageQueryTeacherTodoRequest: SLBaseRequset {
    init(currentPage: Int, pageSize: Int = kPageSize) {
        super.init()
        host = homeHost
        method = .post
        path = noticePageQueryTeacherTodo
        param = ["pageSize":pageSize,
                 "currentPage": currentPage]
    }
}

// MARK: -孩子通知待办分页查询
let noticePageQueryChildrenTodo = "/notice/page-query-children-todo"
class SLEducationNoticePageQueryChildrenTodoRequest: SLBaseRequset {
    init(currentPage: Int, pageSize: Int = kPageSize, childrenClassList: [[String: Int]]) {
        super.init()
        host = homeHost
        method = .post
        path = noticePageQueryChildrenTodo
        param = ["pageSize":pageSize,
                 "currentPage": currentPage,
                 "childrenClassList": childrenClassList]
    }
}


