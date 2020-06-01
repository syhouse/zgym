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
let ScoreTeacherDetails = "/achievement/childScoreDetails"
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

