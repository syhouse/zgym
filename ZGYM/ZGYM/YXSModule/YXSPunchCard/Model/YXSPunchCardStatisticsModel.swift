//
//  YXSPunchCardStatisticsModel.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/16.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import ObjectMapper

class YXSPunchCardStatisticsModel : NSObject, Mappable{

    var clockInListTopResponseList : [YXSClockInListTopResponseList]?
    var currentClockInDayNo : Int?
    var currentClockInPeopleCount : Int?
    var currentClockInTotalCount : Int?
    var totalDay : Int?


    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        currentClockInPeopleCount <- map["currentClockInPeopleCount"]
        currentClockInTotalCount <- map["currentClockInTotalCount"]
        clockInListTopResponseList <- map["clockInListTopResponseList"]
        currentClockInDayNo <- map["currentClockInDayNo"]
        totalDay <- map["totalDay"]
        
    }
}

class YXSClockInListTopResponseList : NSObject, Mappable{
    var avatar : String?
    var custodianId : Int?
    var dayCount : Int?
    var realName : String?
    var childrenId : Int?
    var topNo : Int?

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        avatar <- map["avatar"]
        custodianId <- map["custodianId"]
        dayCount <- map["dayCount"]
        realName <- map["realName"]
        childrenId <- map["childrenId"]
        topNo <- map["topNo"]
        
    }
}
