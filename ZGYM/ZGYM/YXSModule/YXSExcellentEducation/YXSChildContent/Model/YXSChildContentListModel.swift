//
//  YXSChildContentListModel.swift
//  ZGYM
//
//  Created by yihao on 2020/4/24.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import ObjectMapper

class YXSChildContentHomeListModel: NSObject, Mappable {
    private override init(){}
    required init?(map: Map){}
    
    /// 封面图
    var cover: String?
    
    var id: Int?
    
    /// 标题
    var title: String?
    var publishTime: String?
    
    var uploadTime: String?

    func mapping(map: Map) {
        cover <- map["cover"]
        id <- map["id"]
        title <- map["title"]
        publishTime <- map["publishTime"]
        uploadTime <- map["uploadTime"]
    }
}



class YXSChildContentHomeTypeModel: NSObject, Mappable {
    private override init(){}
    required init?(map: Map){}
    
    /// 创建时间
    var createTime: String?
    
    /// 类型id
    var id: Int?
    
    /// 类型名称
    var name: String?

    func mapping(map: Map) {
        createTime <- map["createTime"]
        id <- map["id"]
        name <- map["name"]
    }
}
