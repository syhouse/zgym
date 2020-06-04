//
//  YXSScoreChildListModel.swift
//  ZGYM
//
//  Created by yihao on 2020/6/3.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import ObjectMapper

class YXSScoreChildListModel: NSObject, Mappable {
    /// 孩子头像
    var avatar: String?
    /// 孩子id
    var childrenId: Int?
    /// 孩子名称
    var childrenName: String?
    /// 孩子总分数
    var sumScore: Int?
    
    required init?(map: Map){}

    func mapping(map: Map)
    {
        avatar <- map["avatar"]
        childrenId <- map["childrenId"]
        childrenName <- map["childrenName"]
        sumScore <- map["sumScore"]
    }
}
