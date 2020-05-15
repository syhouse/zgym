//
//  YXSPeriodicalListModel.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/15.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import ObjectMapper

class YXSPeriodicalListModel: NSObject, Mappable {
    private override init(){}
    required init?(map: Map){}
    
    /// 封面图
    var cover: String?
    
    var id: Int?

    var publishTime: String?

    var theme: String?
    ///期数
    var numPeriods: Int?

    func mapping(map: Map) {
        cover <- map["cover"]
        id <- map["id"]
        publishTime <- map["publishTime"]
        theme <- map["theme"]
        numPeriods <- map["numPeriods"]
    }
}
