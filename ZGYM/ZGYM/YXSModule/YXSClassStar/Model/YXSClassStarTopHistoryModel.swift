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


class YXSClassStarTopHistoryModel : NSObject, Mappable,NSCoding{
    
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
    
    @objc required init(coder aDecoder: NSCoder) {
        endTime = aDecoder.decodeObject(forKey: "endTime") as? String
        mapTop3 = aDecoder.decodeObject(forKey: "mapTop3") as? YXSClassStarMapTop3
        startTime = aDecoder.decodeObject(forKey: "startTime") as? String
    }
    
    @objc func encode(with aCoder: NSCoder)
    {
        if endTime != nil{
            aCoder.encode(endTime, forKey: "endTime")
        }
        if startTime != nil{
            aCoder.encode(startTime, forKey: "startTime")
        }
        if mapTop3 != nil{
            aCoder.encode(mapTop3, forKey: "mapTop3")
        }
    }
}
