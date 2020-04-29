//
//  YXSClassStarTopHistoryModel.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/29.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit

import Foundation
import ObjectMapper


class YXSClassStarTopHistoryModel : NSObject, Mappable{

    var endTime : String?
    var mapTop3 : YXSClassStarMapTop3?
    var startTime : String?

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        endTime <- map["endTime"]
        mapTop3 <- map["mapTop3"]
        startTime <- map["startTime"]
        
    }
}
