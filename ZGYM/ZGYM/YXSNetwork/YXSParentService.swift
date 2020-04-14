//
//  ParentService.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2020/1/4.
//  Copyright © 2020 zgjy_mac. All rights reserved.
//

import UIKit


// MARK: -家长-一键提醒
let parentOneTouchReminder = "/parent/oneTouchReminder"
class YXSEducationParentOneTouchReminderRequest: YXSBaseRequset {
    /// 教师-一键提醒
    /// - Parameters:
    ///   - teacherIdList:小孩ID集合
    ///   - opFlag: 0:提醒未阅读，1：提醒未提交
    ///   - serviceId: 业务ID
    ///   - serviceType: 0:通知,1:作业,2:打卡,3:接龙,5:班级圈,6:班级之星
    init(teacherIdList:[Int], opFlag:Int, serviceId:Int, serviceType:Int,childrenId:Int,classId: Int){
        super.init()
        method = .post
        host = homeHost
        path = parentOneTouchReminder
        param = ["teacherIdList":teacherIdList, "opFlag":opFlag, "serviceId":serviceId, "serviceType":serviceType,"childrenId":childrenId, "classId": classId]
    }
}
