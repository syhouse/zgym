//
//  HomeRequest.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/19.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

// MARK: - 首页

// MARK: -瀑布（小学|中学|幼儿园） 瀑布流分页请求参数
let waterfallPageQuery = "/waterfall/page-query"

//业务类型(0:通知,1:作业,2:打卡,3:接龙,4:成绩,5:班级圈6:班级之星 105 班级圈消息),首页聚合所有数据时无需传该参数,查询对应业务数据时需要传
//查询起始id
class SLEducationFWaterfallPageQueryRequest: SLBaseRequset {
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

// MARK: -老师分组红点统计
let todoTeacherRedPointGroup = "/todo/teacherRedPointGroup"
class SLEducationTodoTeacherRedPointGroupRequest: SLBaseRequset {
    override init() {
        super.init()
        host = homeHost
        method = .post
        path = todoTeacherRedPointGroup
    }
}

// MARK: -老师红点统计
let todoTeacherRedPoint = "/todo/teacherRedPoint"
class SLEducationTodoTeacherRedPointRequest: SLBaseRequset {
    override init() {
        super.init()
        host = homeHost
        method = .post
        path = todoTeacherRedPoint
    }
}

// MARK: -老师修改红点
let todoUpdateRedPoint = "/todo/updateRedPoint"
class SLEducationTodoUpdateRedPointRequest: SLBaseRequset {
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
class SLEducationTodoChildrenRedPointGroupRequest: SLBaseRequset {
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
class SLEducationTodoChildrenRedPointRequest: SLBaseRequset {
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
class SLEducationFWeatherCurrentRequest: SLBaseRequset {
    /// 初始化
    /// - Parameter city: 城市名称
    init(city: String) {
        super.init()
        method = .post
        path = weatherCurrent
        param = ["city": city]
    }
}

