//
//  YXSShareModel.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/23.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

enum YXSShareType: Int{
    case img
    case link
}

class YXSShareModel: NSObject {
    var type: YXSShareType
    var way: YXSShareWayType
    var image: UIImage?
    var title: String?
    var descriptionText: String?
    var link: String?
    private init(type: YXSShareType,way: YXSShareWayType) {
        self.type = type
        self.way = way
        super.init()
    }
    
    
    /// 分享图片
    /// - Parameter way: 分享方式
    /// - Parameter image: 分享图片
    convenience init(way: YXSShareWayType = .QQSession,image: UIImage){
        self.init(type:.img,way:way)
        self.image = image
    }
    
    /// 分享链接
    /// - Parameter way: 分享方式
    /// - Parameter image: 缩略图
    /// - Parameter title: 标题
    /// - Parameter descriptionText: 详情
    /// - Parameter link: 链接地址
    convenience init(way: YXSShareWayType = .QQSession,image: UIImage = UIImage.init(named: "yxs_logo")!,title: String,descriptionText: String,link: String){
        self.init(type:.link,way:way)
        self.image = image
        self.title = title
        self.descriptionText = descriptionText.count > 200 ? descriptionText.mySubString(from: 200) : descriptionText
        self.link = link
    }
}

enum HMRequestShareType: String{
    case INVITATION_TO_CLASS
    case CLASS_CIRCLE_TIME_AXIS_DETAIL
    case HOMEWORK_INFO
    case CLOCK_IN_TASK_DETAIL_PARENT
    case CLOCK_IN_TASK_DETAIL_TEACHER
    case NOTICE_INFO
    case CENSUS_INFO
    case CLASS_STAR
}

//分享类型（INVITATION_TO_CLASS入班邀请 CLASS_CIRCLE_TIME_AXIS_DETAIL班级圈详情 HOMEWORK_INFO作业详情 CLOCK_IN_TASK_DETAIL_PARENT打卡任务详情【家长】 CLOCK_IN_TASK_DETAIL_TEACHER打卡任务详情【老师】
class HMRequestShareModel: NSObject {
    var type: HMRequestShareType

    var gradeNum: String?
    var gradeName: String?
    var headmasterName: String?
    
    var classCircleId: Int?
    
    var homeworkId: Int?
    var homeworkCreateTime: String?
    var classCircleType: HMClassCircleType?
    
    var clockInId: Int?
    var childrenId: Int?
    var noticeId: Int?
    var noticeCreateTime: String?
    var censusId: Int?
    var classId: Int?
    var dateType: String?
    var startTime: String?
    var endTime: String?
    private init(type: HMRequestShareType) {
        self.type = type
        super.init()
    }
    
    /// 入班邀请
    /// - Parameter gradeNum: 班级编号
    /// - Parameter gradeName: 班级名称
    /// - Parameter headmasterName: 班主任称呼
    convenience init(gradeNum: String,gradeName: String,headmasterName: String){
        self.init(type:.INVITATION_TO_CLASS)
        self.gradeNum = gradeNum
        self.gradeName = gradeName
        self.headmasterName = headmasterName
    }
    
    /// 班级圈
    /// - Parameter classCircleId: 班级圈id
    convenience init(classCircleId: Int,classCircleType:HMClassCircleType){
        self.init(type:.CLASS_CIRCLE_TIME_AXIS_DETAIL)
        self.classCircleId = classCircleId
        self.classCircleType = classCircleType
    }
    
    
    /// 作业详情
    /// - Parameter homeworkId: 作业ID
    /// - Parameter homeworkCreateTime: 作业创建时间
    convenience init(homeworkId: Int,homeworkCreateTime: String){
        self.init(type:.HOMEWORK_INFO)
        self.homeworkId = homeworkId
        self.homeworkCreateTime = homeworkCreateTime
    }
    
    
    /// 打卡详情
    /// - Parameter clockInId: 打卡ID
    /// - Parameter childrenId: 孩子ID
    convenience init(clockInId: Int,childrenId: Int?){
        if let _ = childrenId{
            self.init(type:.CLOCK_IN_TASK_DETAIL_PARENT)
        }else{
            self.init(type:.CLOCK_IN_TASK_DETAIL_TEACHER)
        }
        self.clockInId = clockInId
        self.childrenId = childrenId
    }
    convenience init(noticeId: Int,noticeCreateTime: String){
        self.init(type:.NOTICE_INFO)
        self.noticeId = noticeId
        self.noticeCreateTime = noticeCreateTime
    }
    convenience init(censusId: Int){
        self.init(type:.CENSUS_INFO)
        self.censusId = censusId
    }
    convenience init(classStarId: Int,childrenId: Int?,dateType: DateType,startTime:String? = nil,endTime:String? = nil){
        self.init(type:.CLASS_STAR)
        self.classId = classStarId
        self.childrenId = childrenId
        self.dateType = dateType.rawValue
        let dayStr = NSUtil.yxs_timeDayText(dateType: dateType)
        self.startTime = dayStr.0
        self.endTime = dayStr.1
        
    }
}

