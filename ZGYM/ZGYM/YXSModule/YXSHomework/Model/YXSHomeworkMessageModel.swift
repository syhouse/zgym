//
//  YXSHomeworkMessageModel.swift
//  ZGYM
//
//  Created by yihao on 2020/4/9.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import ObjectMapper

//{
//  "commentId" : 0,
//  "createTime" : "2020-04-08 16:23:58",
//  "attachment" : "",
//  "operatorAvatar" : null,
//  "id" : 338,
//  "classId" : 184,
//  "childrenId" : 181,
//  "operatorType" : "PARENT",
//  "homeworkId" : 444921945637654551,
//  "content" : "",
//  "recipientType" : "PARENT",
//  "recipient" : 100150,
//  "type" : "PRAISE",
//  "homeworkCreateTime" : "2020-04-07 15:22:04",
//  "operatorName" : "李五1的家长",
//  "operator" : 100150
//}

//类型（COMMENT评论 REPLY回复）
enum HomeworkMessageType: String{
    case COMMENT ///评论
    case REPLY  ///回复
    case PRAISE ///点赞
}

class YXSHomeworkMessageModel: NSObject, Mappable {
    var commentId : Int?
    var createTime : String?
    /// 附件
    var attachment : String?
    var id : Int?
    var classId : Int?
    var childrenId : Int?
    /// 消息类型（ COMMENT评论  REPLY回复  PRAISE点赞）
    var type : HomeworkMessageType?
    var homeworkCreateTime : String?
    var homeworkId : Int?
    /// 评论或回复内容
    var content : String?
    
    
    /// 操作人身份类型
    var operatorType : String?
    /// 操作人头像
    var operatorAvatar : String?
    /// 操作人昵称
    var operatorName : String?
    /// 操作人id
    var operatorId : Int?
    
    
    /// 接收人身份类型
    var recipientType : String?
    /// 接收人id
    var recipient : Int?
    
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map) {
        commentId <- map["commentId"]
        createTime <- map["createTime"]
        attachment <- map["attachment"]
        operatorAvatar <- map["operatorAvatar"]
        id <- map["id"]
        classId <- map["classId"]
        childrenId <- map["childrenId"]
        operatorType <- map["operatorType"]
        homeworkId <- map["homeworkId"]
        content <- map["content"]
        recipientType <- map["recipientType"]
        recipient <- map["recipient"]
        type <- map["type"]
        homeworkCreateTime <- map["homeworkCreateTime"]
        operatorName <- map["operatorName"]
        operatorId <- map["operator"]
    }
}
