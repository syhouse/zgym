//
//  YXSSynClassFolderModel.swift
//  ZGYM
//
//  Created by yihao on 2020/4/21.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import ObjectMapper

class YXSSynClassFolderModel: NSObject, Mappable{
    private override init(){}
    required init?(map: Map){}
    /// 主键id
    var id: Int?
    /// 所属文件夹id
    var folderId: Int?
    /// 封面图
    var coverUrl: String?
    /// 资源名
    var resourceName: String?
    /// 资源地址
    var resourceUrl: String?
    /// 更新时间
    var updateTime: String?
    /// 创建时间
    var createTime: String?
    
    func mapping(map: Map) {
        id <- map["id"]
        folderId <- map["folderId"]
        coverUrl <- map["coverUrl"]
        resourceName <- map["resourceName"]
        resourceUrl <- map["resourceUrl"]
        updateTime <- map["updateTime"]
        createTime <- map["createTime"]
    }
}

class YXSSynClassFolderInfoModel: NSObject, Mappable{
    private override init(){}
    required init?(map: Map){}

    var synopsis: String?
    var homeUrl: String?

    func mapping(map: Map) {
        synopsis <- map["synopsis"]
        homeUrl <- map["homeUrl"]
    }
}
