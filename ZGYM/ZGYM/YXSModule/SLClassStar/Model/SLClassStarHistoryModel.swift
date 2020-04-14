//
//  SLClassStarHistoryModel.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/9.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import ObjectMapper


class SLClassStarHistoryModel : NSObject, Mappable{
    var category : Int?
    var childrenId : Int?
    var childrenName : String?
    var classId : Int?
    var createTime : String?
    var evaluationId : Int?
    var evaluationItem : String?
    var evaluationType : Int?
    var evaluationUrl : String?
    var id : Int?
    var score : Int?
    var scoreDescribe : String?
    var teacherId : Int?
    var teacherName : String?

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        category <- map["category"]
        childrenId <- map["childrenId"]
        childrenName <- map["childrenName"]
        classId <- map["classId"]
        createTime <- map["createTime"]
        evaluationId <- map["evaluationId"]
        evaluationItem <- map["evaluationItem"]
        evaluationType <- map["evaluationType"]
        evaluationUrl <- map["evaluationUrl"]
        id <- map["id"]
        score <- map["score"]
        scoreDescribe <- map["scoreDescribe"]
        teacherId <- map["teacherId"]
        teacherName <- map["teacherName"]
    }
}



class ClassStarBestModel : NSObject, Mappable{

    var avatar : String?
    var childrenId : Int?
    var childrenName : String?
    var evaluationId : Int?
    var evaluationItem : String?
    var evaluationName : String?
    var evaluationUrl : String?
    var score : Int?
    var studentId : String?

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        avatar <- map["avatar"]
        childrenId <- map["childrenId"]
        childrenName <- map["childrenName"]
        evaluationId <- map["evaluationId"]
        evaluationItem <- map["evaluationItem"]
        evaluationName <- map["evaluationName"]
        evaluationUrl <- map["evaluationUrl"]
        score <- map["score"]
        studentId <- map["studentId"]
        
    }
}
