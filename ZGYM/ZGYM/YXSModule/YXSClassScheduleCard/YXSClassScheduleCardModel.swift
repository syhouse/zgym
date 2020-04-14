//
//  ClassScheduleCardModel.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/27.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import ObjectMapper


class YXSClassScheduleCardModel : NSObject, Mappable{

    var classCode : String?
    var classId : Int?
    var className : String?
    var classScheduleCardId : Int?
    var createTime : String?
    var imageUrl : String?
    var numberCount : String?
    var position : String?
    var stage : String?
    var teacherId : Int?
    var type : Int?
    var updateTime : String?


    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        classCode <- map["classCode"]
        classId <- map["classId"]
        className <- map["className"]
        classScheduleCardId <- map["classScheduleCardId"]
        createTime <- map["createTime"]
        imageUrl <- map["imageUrl"]
        numberCount <- map["numberCount"]
        position <- map["position"]
        stage <- map["stage"]
        teacherId <- map["teacherId"]
        type <- map["type"]
        updateTime <- map["updateTime"]
        
    }
}
