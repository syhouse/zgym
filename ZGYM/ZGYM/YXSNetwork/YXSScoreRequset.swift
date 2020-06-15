//
//  YXSScoreRequset.swift
//  ZGYM
//
//  Created by yihao on 2020/5/26.
//  Copyright © 2020 zgym. All rights reserved.
//  成绩URL请求

import Foundation

// MARK: -成绩列表分页(老师)
let ScoreTeacherListRequest = "/achievement/teacher/listPage"
class YXSEducationScoreTeacherListRequest: YXSBaseRequset {
    init(currentPage: Int = 1, classId: Int = 0) {
        super.init()
        method = .post
        host = homeHost
        path = ScoreTeacherListRequest
        if classId > 0 {
            param = [
            "currentPage": currentPage,
            "classId" : classId,
            "pageSize":20]
        } else {
            param = [
            "currentPage": currentPage,
            "pageSize":20]
        }
        
    }
}

// MARK: -成绩列表分页(家长)
let ScoreParentListRequest = "/achievement/parent/listPage"
class YXSEducationScoreParentListRequest: YXSBaseRequset {
    init(currentPage: Int = 1, childrenId: Int, classId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = ScoreParentListRequest
        param = [
            "currentPage": currentPage,
            "pageSize":20,
            "childrenId":childrenId,
            "classId":classId]
    }
}

// MARK: -已阅成绩(家长)
let readingScoreRequest = "/achievement/readingAchievement"
class YXSEducationReadingScoreRequest: YXSBaseRequset {
    init(childrenId: Int, examId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = readingScoreRequest
        param = [
            "childrenId":childrenId,
            "examId":examId]
    }
}

// MARK: -成绩详情报表(老师)
let ScoreParentDetails = "/achievement/parent/childScoreReport"
class YXSEducationScoreParentDetailsRequest: YXSBaseRequset {
    init(examId: Int,childrenId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = ScoreParentDetails
        param = [
            "examId":examId,
            "childrenId":childrenId]
    }
}


// MARK: -成绩详情报表(老师)
let ScoreTeacherDetails = "/achievement/achievementDetails"
class YXSEducationScoreTeacherDetailsRequest: YXSBaseRequset {
    init(examId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = ScoreTeacherDetails
        param = [
            "examId":examId]
    }
}

// MARK: -班级全班人员成绩列表(老师)
let ClassMemberListScore = "/achievement/classMemberListScore"
class YXSEducationClassMemberListScoreRequest: YXSBaseRequset {
    init(examId: Int, currentPage: Int = 1, pageSize: Int = 20) {
        super.init()
        method = .post
        host = homeHost
        path = ClassMemberListScore
        param = [
            "examId":examId,
            "currentPage":currentPage,
            "pageSize":pageSize]
    }
}

// MARK: -单科成绩分布情况列表(家长)
let ChildScoreSingleReport = "/achievement/parent/childScoreSingleReport"
class YXSEducationChildScoreSingleReport: YXSBaseRequset {
    init(examId: Int, childrenId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = ChildScoreSingleReport
        param = [
            "examId":examId,
            "childrenId":childrenId]
    }
}


// MARK: 等级制成绩详情-孩子成绩列表
let ScoreLevelChildDetailsList = "/achievement/achievementHierarchyChildList"
class YXSEducationScoreLevelChildDetailsListRequset: YXSBaseRequset {
    init(examId: Int, currentPage: Int = 1, pageSize: Int = 20) {
        super.init()
        method = .post
        host = homeHost
        path = ScoreLevelChildDetailsList
        param = [
            "examId":examId,
            "currentPage":currentPage,
            "pageSize":pageSize]
    }
}

// MARK: 等级制成绩详情-单个孩子成绩详情
let ScoreLevelSingleChildDetails = "/achievement/hierarchyChildAchievementDetails"
class YXSEducationScoreLevelSingleChildDetailsRequset: YXSBaseRequset {
    init(examId: Int, childrenId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = ScoreLevelSingleChildDetails
        param = [
            "examId":examId,
            "childrenId":childrenId]
    }
}

// MARK: 已阅未阅列表
let ScoreReadingChildList = "/achievement/readAndNotReadList"
class YXSEducationScoreReadingChildListRequset: YXSBaseRequset {
    init(examId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = ScoreReadingChildList
        param = [
            "examId":examId]
    }
}

// MARK: 已阅未阅列表
let ScoreChildDetails = "/achievement/achievementSingleDetails"
class YXSEducationScoreChildDetailsRequset: YXSBaseRequset {
    init(examId: Int, childrenId: Int = 0) {
        super.init()
        method = .post
        host = homeHost
        path = ScoreChildDetails
        
        if childrenId == 0 {
            param = [
            "examId":examId]
        } else {
            param = [
            "examId":examId,
            "childrenId":childrenId]
        }
        
    }
}

