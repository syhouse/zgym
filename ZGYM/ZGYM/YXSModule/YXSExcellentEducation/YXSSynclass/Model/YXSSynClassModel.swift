//
//  YXSSynClassModel.swift
//  ZGYM
//
//  Created by yihao on 2020/4/21.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import ObjectMapper

class YXSSynClassListModel: NSObject, Mappable{
    private override init(){}
    required init?(map: Map){}

    var homeUrl: String?
    var playCount: Int?
    var folderName: String?
    var creator: Int?
    var updateTime: String?
    var synopsis: String?
    var coverUrl: String?
    var id: Int?
    var sortIndex: Int?
    var createTime: String?
    var tabId: Int?
    var subject: YXSSynClassSubjectType?
    
    func mapping(map: Map) {
        homeUrl <- map["homeUrl"]
        playCount <- map["playCount"]
        folderName <- map["folderName"]
        creator <- map["creator"]
        updateTime <- map["updateTime"]
        synopsis <- map["synopsis"]
        coverUrl <- map["coverUrl"]
        id <- map["id"]
        sortIndex <- map["sortIndex"]
        createTime <- map["createTime"]
        tabId <- map["tabId"]
        subject <- map["subject"]
    }
}

class YXSSynClassTabModel: NSObject, Mappable {
    
    var updateTime: String?
    /// tab标签id
    var id: Int?
    var createTime: String?
    var creator: Int?
    /// tab标签类型
    var stage: YXSSynClassListType?
    /// tab标签名字
    var tabName: String?
    var sortIndex: Int?
    
    private override init(){}
    required init?(map: Map){}

    func mapping(map: Map) {
        updateTime <- map["updateTime"]
        id <- map["id"]
        createTime <- map["createTime"]
        creator <- map["creator"]
        stage <- map["stage"]
        tabName <- map["tabName"]
        sortIndex <- map["sortIndex"]
    }
}
