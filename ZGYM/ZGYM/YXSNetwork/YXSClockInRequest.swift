//
//  ClockInRequest.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/12.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//


// MARK: - 打卡API
// MARK: -发布(老师)
let clockInTeacherPublish = "/clockIn/teacherPublish"
class YXSEducationClockInTeacherPublishRequest: YXSBaseRequset {
    init(classIdList: [Int], content:String = "",title: String,periodList: [Int],totalDay: Int, audioUrl: String = "", audioDuration: Int = 0,videoUrl: String = "",bgUrl: String = "",imageUrl: String = "",link: String = "",isTop: Int,reminder: Int, isPatchCard: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInTeacherPublish
        param = ["classIdList":classIdList,
                 "content": content,
                 "audioUrl":audioUrl,
                 "audioDuration":audioDuration,
                 "videoUrl": videoUrl,
                 "bgUrl":bgUrl,
                 "link": link,
                 "imageUrl": imageUrl,
                 "title":title,
                 "periodList":periodList,
                 "totalDay":totalDay,
                 "isTop": isTop,
                 "reminder": reminder,
                 "isPatchCard": isPatchCard]
    }
}

// MARK: -提交(家长)
let clockInParentCommit = "/clockIn/parentCommit"
class YXSEducationClockInParentCommitRequest: YXSBaseRequset {
    init(childrenId: Int,clockInId: Int, content:String = "", audioUrl: String = "", audioDuration: Int = 0,videoUrl: String = "",bgUrl: String = "",imageUrl: String = "") {
        super.init()
        method = .post
        host = homeHost
        path = clockInParentCommit
        param = ["childrenId":childrenId,
                 "clockInId": clockInId,
                 "content": content,
                 "audioUrl":audioUrl,
                 "audioDuration":audioDuration,
                 "videoUrl": videoUrl,
                 "bgUrl":bgUrl,
                 "imageUrl": imageUrl]
    }
}

// MARK: -打卡任务列表(老师)
let clockInTeacherTaskList = "/clockIn/teacherTaskList"
class YXSEducationClockInTeacherTaskListRequest: YXSBaseRequset {
//    打卡状态（0 全部 30 进行中（已打卡或者不需要打卡） 40 我发布的 100 已结束:按照打卡的结束时间 ）
    init(state: Int = 0,classId: Int?,currentPage: Int,pageSize: Int = kPageSize,stage: StageType) {
        super.init()
        method = .post
        host = homeHost
        path = clockInTeacherTaskList
        param = ["state": state,
                 "currentPage": currentPage,
                 "pageSize": pageSize,
                 "stage": stage.rawValue]
        if let classId = classId{
            param?["classId"] = classId
        }
    }
}

// MARK: -打卡任务列表(家长)
let clockInParentTaskList = "/clockIn/parentTaskList"
class YXSEducationClockInParentTaskListRequest: YXSBaseRequset {
//    打卡状态（（0 全部 10 未打卡 20 进行中（已打卡或者不需要打卡） 100 已结束:按照打卡的结束时间 ）
    init(state: Int = 0,childrenId: Int,currentPage: Int,pageSize: Int = kPageSize) {
        super.init()
        method = .post
        host = homeHost
        path = clockInParentTaskList
        param = ["state": state,
                 "currentPage": currentPage,
                 "pageSize": pageSize,"childrenId": childrenId]
    }
}

// MARK: -打卡任务详情(家长)
let clockInParentTaskDetail = "/clockIn/parentTaskDetail"
class YXSEducationClockInParentTaskDetailRequest: YXSBaseRequset {
    init(clockInId: Int,childrenId: Int,currentPage: Int,pageSize: Int = kPageSize) {
        super.init()
        method = .post
        host = homeHost
        path = clockInParentTaskDetail
        param = ["clockInId": clockInId,
                 "currentPage": currentPage,
                 "pageSize": pageSize,"childrenId": childrenId]
    }
}



// MARK: -打卡撤销(老师)
let clockInTeacherUndo = "/clockIn/teacherUndo"
class YXSEducationClockInTeacherUndoRequest: YXSBaseRequset {
    init(clockInId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInTeacherUndo
        param = ["clockInId": clockInId]
    }
}
// MARK: -置顶 (老师)
let clockInUpdateTop = "/clockIn/updateTop"
class YXSEducationClockInUpdateTopRequest: YXSBaseRequset {
    init(clockInId: Int, isTop: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInUpdateTop
        param = ["clockInId": clockInId,
                 "isTop": isTop]
    }
}

// MARK: -打卡任务详情(老师)
let clockInTeacherTaskDetail = "/clockIn/teacherTaskDetail"
class YXSEducationClockInTeacherTaskDetailRequest: YXSBaseRequset {
    init(clockInId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInTeacherTaskDetail
        param = ["clockInId": clockInId]
    }
}

// MARK: -打卡名单（老师 未打卡|已打开）
let clockInTeacherStaffList = "/clockIn/teacherStaffList"
class YXSEducationClockInTeacherStaffListRequest: YXSBaseRequset {
    init(clockInId: Int, startTime: String? = nil,endTime: String? = nil) {
        super.init()
        method = .post
        host = homeHost
        path = clockInTeacherStaffList
        param = ["clockInId": clockInId]
        if let startTime = startTime{
            param?["startTime"] = startTime
        }
        if let endTime = endTime{
            param?["endTime"] = endTime
        }
    }
}

// MARK: -打卡统计（老师）
let clockInTeacherPunchStatistics = "/clockIn/teacherPunchStatistics"
class YXSEducationClockInTeacherPunchStatisticsRequest: YXSBaseRequset {
    init(clockInId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInTeacherPunchStatistics
        param = ["clockInId": clockInId]
    }
}

// MARK: -打卡记录分页(家长)
let clockInParentCommitListPage = "/clockIn/parentCommitListPage"
class YXSEducationClockInClockInParentCommitListPageRequest: YXSBaseRequset {
    init(clockInId: Int, currentPage: Int,pageSize: Int = kPageSize, startTime: String? = nil,endTime: String? = nil) {
        super.init()
        method = .post
        host = homeHost
        path = clockInParentCommitListPage
        param = ["clockInId": clockInId,
        "currentPage": currentPage,
        "pageSize": pageSize]
        if let startTime = startTime{
            param?["startTime"] = startTime
        }
        if let endTime = endTime{
            param?["endTime"] = endTime
        }
    }
}

// MARK: -待办分页查询 (老师)
let clockInTeacherTodo = "/clockIn/teacherTodo"
class YXSEducationClockInTeacherTodoRequest: YXSBaseRequset {
    init(currentPage: Int,pageSize: Int = kPageSize) {
        super.init()
        method = .post
        host = homeHost
        path = clockInTeacherTodo
        param = ["currentPage": currentPage,
        "pageSize": pageSize]
    }
}

// MARK: -待办分页查询 (家长)
let clockInParentTodo = "/clockIn/parentTodo"
class YXSEducationClockInParentTodoRequest: YXSBaseRequset {
    init(currentPage: Int,pageSize: Int = kPageSize) {
        super.init()
        method = .post
        host = homeHost
        path = clockInParentTodo
        param = ["currentPage": currentPage,
        "pageSize": pageSize]
    }
}

// MARK: -统计小孩打卡信息
let clockInStatisticsTodayChildren = "/clockIn/statisticsTodayChildren"
class YXSEducationClockInStatisticsTodayChildrenRequest: YXSBaseRequset {
    init(childrenId: Int,clockInId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInStatisticsTodayChildren
        param = ["childrenId": childrenId,
        "clockInId": clockInId]
    }
}

// MARK: -打卡记录分页(单个孩子)
let singleChildCommitListPage = "/clockIn/singleChildCommitListPage"
class YXSEducationClockInSingleChildCommitListPageRequest: YXSBaseRequset {
    init(childrenId: Int,clockInId: Int,currentPage: Int,pageSize: Int = kPageSize) {
        super.init()
        method = .post
        host = homeHost
        path = singleChildCommitListPage
        param = ["childrenId": childrenId,
        "clockInId": clockInId,
        "currentPage": currentPage,
        "pageSize": pageSize]
    }
}

// MARK: 打卡评论列表（老师-全部打卡）
let clockInTeacherAllCommentsList = "/clockIn/teacherAllCommentsList"
class YXSEducationClockInTeacherAllCommentsListRequest: YXSBaseRequset {
    init(clockInId: Int,currentPage: Int,pageSize: Int = kPageSize) {
        super.init()
        method = .post
        host = homeHost
        path = clockInTeacherAllCommentsList
        param = ["clockInId": clockInId,
        "currentPage": currentPage,
        "pageSize": pageSize]
    }
}

// MARK: 优秀打卡评论列表（家长、老师）
let clockInExcellentCommentsList = "/clockIn/excellentCommentsList"
class YXSEducationClockInExcellentCommentsListRequest: YXSBaseRequset {
    init(clockInId: Int,currentPage: Int,pageSize: Int = kPageSize) {
        super.init()
        method = .post
        host = homeHost
        path = clockInExcellentCommentsList
        param = ["clockInId": clockInId,
        "currentPage": currentPage,
        "pageSize": pageSize]
    }
}

// MARK: 打卡评论列表（家长-全部打卡）
let clockInParentAllCommentsList = "/clockIn/parentAllCommentsList"
class YXSEducationClockInParentAllCommentsListRequest: YXSBaseRequset {
    init(clockInId: Int,currentPage: Int,pageSize: Int = kPageSize) {
        super.init()
        method = .post
        host = homeHost
        path = clockInParentAllCommentsList
        param = ["clockInId": clockInId,
        "currentPage": currentPage,
        "pageSize": pageSize]
    }
}

// MARK: 打卡评论列表（日历)
let clockInCalendarCommentsList = "/clockIn/calendarCommentsList"
class YXSEducationClockInCalendarCommentsListRequest: YXSBaseRequset {
    init(clockInId: Int,currentPage: Int,pageSize: Int = kPageSize, endTime: String, startTime: String) {
        super.init()
        method = .post
        host = homeHost
        path = clockInCalendarCommentsList
        param = ["clockInId": clockInId,
        "currentPage": currentPage,
        "pageSize": pageSize,
        "endTime": endTime,
        "startTime": startTime]
    }
}

// MARK: 打卡评论列表（家长-我的打卡）
let clockInParentMyCommentsList = "/clockIn/parentMyCommentsList"
class YXSEducationClockInParentMyCommentsListRequest: YXSBaseRequset {
    init(clockInId: Int,currentPage: Int,pageSize: Int = kPageSize, childrenId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInParentMyCommentsList
        param = ["clockInId": clockInId,
        "currentPage": currentPage,
        "pageSize": pageSize,
        "childrenId": childrenId]
    }
}

// MARK: 点赞（老师）
let clockInTeacherPraiseComments = "/clockIn/teacherPraiseComments"
class YXSEducationClockInTeacherPraiseCommentsRequest: YXSBaseRequset {
    init(clockInId: Int,clockInCommitId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInTeacherPraiseComments
        param = ["clockInId": clockInId,
        "clockInCommitId": clockInCommitId]
    }
}

// MARK: 点赞（家长）
let clockInParentPraiseComments = "/clockIn/parentPraiseComments"
class YXSEducationClockInParentPraiseCommentsRequest: YXSBaseRequset {
    init(clockInId: Int,clockInCommitId: Int,childrenId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInParentPraiseComments
        param = ["clockInId": clockInId,
        "clockInCommitId": clockInCommitId,
        "childrenId": childrenId]
    }
}

// MARK: 评论（老师）
let clockInTeacherReplyClockContent = "/clockIn/teacherReplyClockContent"
class YXSEducationClockInTeacherReplyClockContentRequest: YXSBaseRequset {
    init(clockInId: Int,clockInCommitId: Int,content: String) {
        super.init()
        method = .post
        host = homeHost
        path = clockInTeacherReplyClockContent
        param = ["clockInId": clockInId,
        "clockInCommitId": clockInCommitId,
        "content": content]
    }
}

// MARK: 回复（老师）
let clockInTeacherReplyComments = "/clockIn/teacherReplyComments"
class YXSEducationClockInTeacherReplyCommentsRequest: YXSBaseRequset {
    init(clockInId: Int,clockInCommitId: Int,content: String,clockInCommentsId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInTeacherReplyComments
        param = ["clockInId": clockInId,
        "clockInCommitId": clockInCommitId,
        "content": content,
        "clockInCommentsId": clockInCommentsId]
    }
}

// MARK: 评论（家长）
let clockInParentReplyClockContent = "/clockIn/parentReplyClockContent"
class YXSEducationClockInParentReplyClockContentRequest: YXSBaseRequset {
    init(clockInId: Int,clockInCommitId: Int,content: String,childrenId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInParentReplyClockContent
        param = ["clockInId": clockInId,
        "clockInCommitId": clockInCommitId,
        "content": content,
        "childrenId": childrenId]
    }
}

// MARK: 回复（家长）
let clockInParentReplyComments = "/clockIn/parentReplyComments"
class YXSEducationClockInParentReplyCommentsRequest: YXSBaseRequset {
    init(clockInId: Int,clockInCommitId: Int,content: String,childrenId: Int,clockInCommentsId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInParentReplyComments
        param = ["clockInId": clockInId,
        "clockInCommitId": clockInCommitId,
        "content": content,
        "childrenId": childrenId,
        "clockInCommentsId": clockInCommentsId]
    }
}

// MARK: 打卡设置优秀（老师）
let clockInTeacherApproval = "/clockIn/teacherApproval"
class YXSEducationClockInTeacherApprovalRequest: YXSBaseRequset {
    init(clockInId: Int,clockInCommitId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInTeacherApproval
        param = ["clockInId": clockInId,
        "clockInCommitId": clockInCommitId]
    }
}


// MARK: 删除评论（老师）
let clockInTeacherDeleteComments = "/clockIn/teacherDeleteComments"
class YXSEducationClockInTeacherDeleteCommentsRequest: YXSBaseRequset {
    init(clockInId: Int,clockInCommitId: Int, clockInCommentsId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInTeacherDeleteComments
        param = ["clockInId": clockInId,
        "clockInCommitId": clockInCommitId,
        "clockInCommentsId": clockInCommentsId]
    }
}

// MARK: 删除评论（家长）
let clockInParentDeleteComments = "/clockIn/parentDeleteComments"
class YXSEducationClockInParentDeleteCommentsRequest: YXSBaseRequset {
    init(clockInId: Int,clockInCommitId: Int, clockInCommentsId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInParentDeleteComments
        param = ["clockInId": clockInId,
        "clockInCommitId": clockInCommitId,
        "clockInCommentsId": clockInCommentsId]
    }
}

// MARK: 撤回打卡（家长）
let clockInParentCancelCard = "/clockIn/parentCancelCard"
class YXSEducationClockInParentCancelCardRequest: YXSBaseRequset {
    init(clockInId: Int,clockInCommitId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInParentCancelCard
        param = ["clockInId": clockInId,
        "clockInCommitId": clockInCommitId]
    }
}

// MARK: 撤回打卡（家长）
let clockInParentPatchCard = "/clockIn/parentPatchCard"
class YXSEducationClockInParentPatchCardRequest: YXSBaseRequset {
    //2019-12-25 00:00:00
    init(clockInId: Int,childrenId: Int, patchCardTime: String, content:String = "", audioUrl: String = "", audioDuration: Int = 0,videoUrl: String = "",bgUrl: String = "",imageUrl: String = "") {
        super.init()
        method = .post
        host = homeHost
        path = clockInParentPatchCard
        param = ["clockInId": clockInId,
        "childrenId": childrenId,
        "patchCardTime": patchCardTime,
        "content": content,
        "audioUrl":audioUrl,
        "audioDuration":audioDuration,
        "videoUrl": videoUrl,
        "bgUrl":bgUrl,
        "imageUrl": imageUrl]
    }
}

// MARK: 提交更新(家长)
let clockInParentUpDateCommit = "/clockIn/parentUpDateCommit"
class YXSEducationClockInParentUpDateCommitRequest: YXSBaseRequset {
    init(childrenId: Int,clockInId: Int, content:String = "", audioUrl: String = "", audioDuration: Int = 0,videoUrl: String = "",bgUrl: String = "",imageUrl: String = "",clockInCommitId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInParentUpDateCommit
        param = ["childrenId":childrenId,
        "clockInId": clockInId,
        "content": content,
        "audioUrl":audioUrl,
        "audioDuration":audioDuration,
        "videoUrl": videoUrl,
        "bgUrl":bgUrl,
        "imageUrl": imageUrl,
        "clockInCommitId": clockInCommitId]
    }
}

// MARK: 未读通知条数统计(老师，家长)
let clockInUnreadNoticeCount = "/clockIn/unreadNoticeCount"
class YXSEducationClockInUnreadNoticeCountRequest: YXSBaseRequset {
    init(clockInId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInUnreadNoticeCount
        param = ["clockInId": clockInId]
    }
}

// MARK: 未读通知列表(老师，家长)
let clockInUnreadNoticeList = "/clockIn/unreadNoticeList"
class YXSEducationClockInUnreadNoticeListRequest: YXSBaseRequset {
    init(clockInId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInUnreadNoticeList
        param = ["clockInId": clockInId]
    }
}

// MARK: 提交打卡单挑记录(老师，家长)
let clockInSingleCommitDetail = "/clockIn/singleCommitDetail"
class YXSEducationClockInSingleCommitDetailRequest: YXSBaseRequset {
    init(clockInId: Int, clockInCommitId : Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInSingleCommitDetail
        param = ["clockInId": clockInId,
                 "clockInCommitId": clockInCommitId]
    }
}

// MARK: 优秀打卡评论列表（家长-我的）
let clockInMyExcellentCommentsList = "/clockIn/myExcellentCommentsList"
class YXSEducationClockInMyExcellentCommentsListRequest: YXSBaseRequset {
    init(childrenId: Int, classId : Int, currentPage: Int, pageSize: Int = kPageSize) {
        super.init()
        method = .post
        host = homeHost
        path = clockInMyExcellentCommentsList
        param = ["childrenId": childrenId,
                 "classId": classId,
                 "currentPage": currentPage,
                 "pageSize": pageSize]
    }
}
