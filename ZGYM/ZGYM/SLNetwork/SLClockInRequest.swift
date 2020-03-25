//
//  ClockInRequest.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/12.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//


// MARK: - 打卡API
// MARK: -发布(老师)
let clockInTeacherPublish = "/clockIn/teacherPublish"
class SLEducationClockInTeacherPublishRequest: SLBaseRequset {
    init(classIdList: [Int], content:String = "",title: String,periodList: [Int],totalDay: Int, audioUrl: String = "", audioDuration: Int = 0,videoUrl: String = "",bgUrl: String = "",imageUrl: String = "",link: String = "",isTop: Int) {
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
                 "isTop": isTop]
    }
}

// MARK: -提交(家长)
let clockInParentCommit = "/clockIn/parentCommit"
class SLEducationClockInParentCommitRequest: SLBaseRequset {
    init(childrenId: Int,clockInId: Int, content:String = "", audioUrl: String = "", audioDuration: Int = 0,videoUrl: String = "",bgUrl: String = "",imageUrl: String = "",link: String = "") {
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
                 "link": link,
                 "imageUrl": imageUrl]
    }
}

// MARK: -打卡任务列表(老师)
let clockInTeacherTaskList = "/clockIn/teacherTaskList"
class SLEducationClockInTeacherTaskListRequest: SLBaseRequset {
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
class SLEducationClockInParentTaskListRequest: SLBaseRequset {
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
class SLEducationClockInParentTaskDetailRequest: SLBaseRequset {
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
class SLEducationClockInTeacherUndoRequest: SLBaseRequset {
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
class SLEducationClockInUpdateTopRequest: SLBaseRequset {
    init(clockInId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = clockInUpdateTop
        param = ["clockInId": clockInId]
    }
}

// MARK: -打卡任务详情(老师)
let clockInTeacherTaskDetail = "/clockIn/teacherTaskDetail"
class SLEducationClockInTeacherTaskDetailRequest: SLBaseRequset {
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
class SLEducationClockInTeacherStaffListRequest: SLBaseRequset {
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
class SLEducationClockInTeacherPunchStatisticsRequest: SLBaseRequset {
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
class SLEducationClockInClockInParentCommitListPageRequest: SLBaseRequset {
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
class SLEducationClockInTeacherTodoRequest: SLBaseRequset {
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
class SLEducationClockInParentTodoRequest: SLBaseRequset {
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
class SLEducationClockInStatisticsTodayChildrenRequest: SLBaseRequset {
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
class SLEducationClockInSingleChildCommitListPageRequest: SLBaseRequset {
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

