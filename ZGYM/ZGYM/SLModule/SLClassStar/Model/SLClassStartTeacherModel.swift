//
//  SLClassStartTeacherModel.swift
//  ZGYM
//
//  Created by hnsl_mac on 2020/1/4.
//  Copyright © 2020 hnsl_mac. All rights reserved.
//

import Foundation
import ObjectMapper


class SLClassStartTeacherModel : NSObject, Mappable{
    var avatar : String?
    var imId : String?
    var position : String?
    var subject : String?
    var teacherId : Int?
    var teacherName : String?
    var reminder : Bool?

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        avatar <- map["avatar"]
        imId <- map["imId"]
        position <- map["position"]
        subject <- map["subject"]
        teacherId <- map["teacherId"]
        teacherName <- map["teacherName"]
        reminder <- map["reminder"]
    }
}
