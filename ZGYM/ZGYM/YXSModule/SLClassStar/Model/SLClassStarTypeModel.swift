//
//  SLClassStarTypeModel.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/6.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import ObjectMapper


class SLClassStarTypeModel : NSObject, Mappable{

    var code : Int?
    var id : Int?
    var name : String?
    var iconUrl : String?
    var isSelected: Bool = false

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        code <- map["code"]
        id <- map["id"]
        name <- map["name"]
        iconUrl <- map["iconUrl"]
    }

}
