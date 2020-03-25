//
//  TeacherService.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/27.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

// MARK: -删除点评项(教师)
let teacherDeleteEvaluationHistory = "/teacher/deleteEvaluationHistory"
class SLEducationTeacherDeleteEvaluationHistoryRequest: SLBaseRequset {
    init(classId:Int, evaluationHistoryId:Int){
        super.init()
        method = .post
        host = homeHost
        path = teacherDeleteEvaluationHistory
        param = ["classId":classId,
                 "evaluationHistoryId":evaluationHistoryId]
    }
}


// MARK: -教师-我的点评
let teacherMyEvaluationHistoryList = "/teacher/myEvaluationHistoryList"
class SLEducationTeacherMyEvaluationHistoryListRequest: SLBaseRequset {
    init(currentPage:Int, stage: String){
        super.init()
        method = .post
        host = homeHost
        path = teacherMyEvaluationHistoryList
        param = ["currentPage":currentPage,
                 "stage":stage,
                 "pageSize":20]
    }
}

// MARK: -家长-基本信息(获取电话号码)
let teacherParentsBaseInfo = "/teacher/parentsBaseInfo"
class SLEducationTeacherParentsBaseInfoRequest: SLBaseRequset {
    init(childrenId:Int, classId: Int){
        super.init()
        method = .post
        host = homeHost
        path = teacherParentsBaseInfo
        param = ["childrenId":childrenId,
                 "classId":classId]
    }
}


// MARK: -教师-一键提醒
let teacherOneTouchReminder = "/teacher/oneTouchReminder"
class SLEducationTeacherOneTouchReminderRequest: SLBaseRequset {
    /// 教师-一键提醒
    /// - Parameters:
    ///   - childrenIdList:小孩ID集合
    ///   - classId: 班级ID
    ///   - opFlag: 0:提醒未阅读，1：提醒未提交
    ///   - serviceId: 业务ID
    ///   - serviceType: 0:通知,1:作业,2:打卡,3:接龙,5:班级圈,6:班级之星
    init(childrenIdList:[Int], classId: Int, opFlag:Int, serviceId:Int, serviceType:Int, serviceCreateTime:String = ""){
        super.init()
        method = .post
        host = homeHost
        path = teacherOneTouchReminder
        param = ["childrenIdList":childrenIdList,
                 "classId":classId, "opFlag":opFlag, "serviceId":serviceId, "serviceType":serviceType, "serviceCreateTime":serviceCreateTime]
    }
}

// MARK: -家长-通讯录
let parentQueryContacts = "/parent/query-contacts"
class SLEducationParentQueryContactsRequest: SLBaseRequset {
    init(classId: Int){
        super.init()
        isLoadCache = true
        method = .post
        host = homeHost
        path = parentQueryContacts
        param = [
        "classId":classId]
    }
}

// MARK: -教师-通讯录
let teacherQueryContacts = "/teacher/query-contacts"
class SLEducationTeacherQueryContactsRequest: SLBaseRequset {
    init(classId: Int){
        super.init()
        isLoadCache = true
        method = .post
        host = homeHost
        path = teacherQueryContacts
        param = [
        "classId":classId]
    }
}

// MARK: -新增课表
let teacherAddClassScheduleCard = "/classScheduleCard/teacher/addClassScheduleCard"
//20:课程表 10:食谱
class SLEducationTeacherAddClassScheduleCardRequest: SLBaseRequset {
    init(classId: Int,imageUrl: String, teacherId: Int, stage: StageType){
        super.init()
        method = .post
        host = homeHost
        path = teacherAddClassScheduleCard
        param = [
        "classId":classId,
        "imageUrl":imageUrl,
        "teacherId":teacherId,
        "type":stage == .KINDERGARTEN ? 10 : 20]
    }
}

// MARK: -课表列表(老师) 10:食谱 20：课程表
let classScheduleCardTeacherClassScheduleCardList = "/classScheduleCard/teacher/classScheduleCardList"
class SLEducationClassScheduleCardTeacherClassScheduleCardListRequest: SLBaseRequset {
    init(currentPage: Int,pageSize: Int = kPageSize, stage: StageType,classId: Int?){
        super.init()
        method = .post
        host = homeHost
        path = classScheduleCardTeacherClassScheduleCardList
        param = [
        "currentPage":currentPage,
        "pageSize":pageSize,
        "type":stage == .KINDERGARTEN ? 10 : 20,
        "stage": stage.rawValue]
        if let classId = classId{
            param?["classId"] = classId
        }
    }
}

// MARK: -课表列表(家长) 10:食谱 20：课程表
let classScheduleCardParentsClassScheduleCardList = "/classScheduleCard/parents/classScheduleCardList"
class SLEducationClassScheduleCardParentsClassScheduleCardListRequest: SLBaseRequset {
    init(currentPage: Int,pageSize: Int = kPageSize, stage: StageType,childrenId: Int?,classId: Int?){
        super.init()
        method = .post
        host = homeHost
        path = classScheduleCardParentsClassScheduleCardList
        param = [
        "currentPage":currentPage,
        "pageSize":pageSize,
        "type":stage == .KINDERGARTEN ? 10 : 20,
        "stage": stage.rawValue]
        
        if let childrenId = childrenId{
            param?["childrenId"] = childrenId
        }
        if let classId = classId{
            param?["classId"] = classId
        }
    }
}


// MARK: -删除课表
let teacherDeleteClassScheduleCard = "/classScheduleCard/teacher/deleteClassScheduleCard"
class SLEducationTeacherDeleteClassScheduleCardRequest: SLBaseRequset {
    init(classScheduleCardId: Int,imageUrl: String){
        super.init()
        method = .post
        host = homeHost
        path = teacherDeleteClassScheduleCard
        param = [
        "classScheduleCardId":classScheduleCardId,
        "imageUrl":imageUrl]
    }
}

// MARK: -更新课表
let teacherUpdateClassScheduleCardCard = "/classScheduleCard/teacher/updateClassScheduleCard"
class SLEducationTeacherUpdateClassScheduleCardCardRequest: SLBaseRequset {
    init(classScheduleCardId: Int,imageUrl: String){
        super.init()
        method = .post
        host = homeHost
        path = teacherUpdateClassScheduleCardCard
        param = [
        "classScheduleCardId":classScheduleCardId,
        "imageUrl":imageUrl]
    }
}

// MARK: -教师-基本信息
let teacherTeacherBaseInfo = "/teacher/teacherBaseInfo"
class SLEducationTeacherTeacherBaseInfoRequest: SLBaseRequset {
    init(childrenId:Int, classId: Int){
        super.init()
        method = .post
        host = homeHost
        path = teacherTeacherBaseInfo
        param = ["childrenId":childrenId,
                 "classId":classId]
    }
}
