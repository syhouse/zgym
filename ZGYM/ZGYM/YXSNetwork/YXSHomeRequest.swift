//
//  HomeRequest.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/19.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

// MARK: - 首页

// MARK: -瀑布（小学|中学|幼儿园） 瀑布流分页请求参数
let waterfallPageQuery = "/waterfall/page-query"

//业务类型(0:通知,1:作业,2:打卡,3:接龙,4:成绩,5:班级圈6:班级之星 105 班级圈消息),首页聚合所有数据时无需传该参数,查询对应业务数据时需要传
//查询起始id
class YXSEducationFWaterfallPageQueryRequest: YXSBaseRequset {
    init(currentPage: Int, pageSize: Int = kPageSize,classIdList: [Int],stage: String,userType: String, childrenId: Int?) {
        super.init()
        host = homeHost
        method = .post
        path = waterfallPageQuery
        param = ["pageSize":pageSize,
                 "stage": stage,
                 "userType": userType,
                 "classIdList": classIdList,
                 "currentPage": currentPage]
        if let childrenId = childrenId{
            param?["childrenId"] = childrenId
        }
    }
}

// MARK: -瀑布（小学|中学|幼儿园） 首页瀑布流分页查询v2
let waterfallPageQueryV2 = "/waterfall/page-query/v2"

//业务类型(0:通知,1:作业,2:打卡,3:接龙,4:成绩,5:班级圈6:班级之星 105 班级圈消息),首页聚合所有数据时无需传该参数,查询对应业务数据时需要传
//查询起始id
class YXSEducationwaterfallPageQueryV2Request: YXSBaseRequset {
    init(currentPage: Int, pageSize: Int = kPageSize,classIdList: [Int],stage: String,userType: String, childrenId: Int?,lastRecordId: Int,lastRecordTime: String?,tsLast: Int?) {
        super.init()
        host = homeHost
        method = .post
        path = waterfallPageQueryV2
        param = ["pageSize":pageSize,
                 "stage": stage,
                 "userType": userType,
                 "classIdList": classIdList,
                 "currentPage": currentPage,
                 "lastRecordId": lastRecordId]
        if let childrenId = childrenId{
            param?["childrenId"] = childrenId
        }
        if let lastRecordTime = lastRecordTime{
           param?["lastRecordTime"] = lastRecordTime
        }
        if let tsLast = tsLast{
           param?["tsLast"] = tsLast
        }
    }
}

// MARK: -老师分组红点统计
let todoTeacherRedPointGroup = "/todo/teacherRedPointGroup"
class YXSEducationTodoTeacherRedPointGroupRequest: YXSBaseRequset {
    override init() {
        super.init()
        host = homeHost
        method = .post
        path = todoTeacherRedPointGroup
    }
}

// MARK: -老师红点统计
let todoTeacherRedPoint = "/todo/teacherRedPoint"
class YXSEducationTodoTeacherRedPointRequest: YXSBaseRequset {
    override init() {
        super.init()
        host = homeHost
        method = .post
        path = todoTeacherRedPoint
    }
}

// MARK: -老师修改红点
let todoUpdateRedPoint = "/todo/updateRedPoint"
class YXSEducationTodoUpdateRedPointRequest: YXSBaseRequset {
    init(serviceId: Int) {
        super.init()
        host = homeHost
        method = .post
        path = todoUpdateRedPoint
        param = ["serviceId":serviceId]
    }
}

// MARK: -家长分组红点统计
let todoChildrenRedPointGroup = "/todo/childrenRedPointGroup"
class YXSEducationTodoChildrenRedPointGroupRequest: YXSBaseRequset {
    init(childrenClassList: [[String: Int]]) {
        super.init()
        host = homeHost
        method = .post
        path = todoChildrenRedPointGroup
        param = ["childrenClassList": childrenClassList]
    }
}

// MARK: -家长红点统计
let todoChildrenRedPoint = "/todo/childrenRedPoint"
class YXSEducationTodoChildrenRedPointRequest: YXSBaseRequset {
    init(childrenClassList: [[String: Int]]) {
        super.init()
        host = homeHost
        method = .post
        path = todoChildrenRedPoint
        param = ["childrenClassList": childrenClassList]
    }
}

// MARK: -获取当前天气
let weatherCurrent = "/weather/current"
class YXSEducationFWeatherCurrentRequest: YXSBaseRequset {
    /// 初始化
    /// - Parameter city: 城市名称
    init(city: String) {
        super.init()
        method = .post
        path = weatherCurrent
        param = ["city": city]
    }
}

