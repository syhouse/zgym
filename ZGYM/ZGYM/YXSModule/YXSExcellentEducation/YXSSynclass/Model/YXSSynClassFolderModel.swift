//
//  YXSSynClassFolderModel.swift
//  ZGYM
//
//  Created by yihao on 2020/4/21.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import ObjectMapper

class YXSSynClassFolderModel: NSObject, NSCoding, Mappable{
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
    
    @objc required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? Int
        folderId = aDecoder.decodeObject(forKey: "folderId") as? Int
        coverUrl = aDecoder.decodeObject(forKey: "coverUrl") as? String
        resourceName = aDecoder.decodeObject(forKey: "resourceName") as? String
        resourceUrl = aDecoder.decodeObject(forKey: "resourceUrl") as? String
        updateTime = aDecoder.decodeObject(forKey: "updateTime") as? String
        createTime = aDecoder.decodeObject(forKey: "createTime") as? String
    }
    @objc func encode(with aCoder: NSCoder) {
        if id != nil{
           aCoder.encode(id, forKey: "id")
        }
        if folderId != nil{
           aCoder.encode(folderId, forKey: "folderId")
        }
        if coverUrl != nil{
           aCoder.encode(coverUrl, forKey: "coverUrl")
        }
        if resourceName != nil{
           aCoder.encode(resourceName, forKey: "resourceName")
        }
        if resourceUrl != nil{
           aCoder.encode(resourceUrl, forKey: "resourceUrl")
        }
        if updateTime != nil{
           aCoder.encode(updateTime, forKey: "updateTime")
        }
        if createTime != nil{
           aCoder.encode(createTime, forKey: "createTime")
        }
    }
}

class YXSSynClassFolderInfoModel: NSObject, NSCoding, Mappable{
    private override init(){}
    required init?(map: Map){}

    var synopsis: String?
    var homeUrl: String?

    func mapping(map: Map) {
        synopsis <- map["synopsis"]
        homeUrl <- map["homeUrl"]
    }
    
    @objc required init(coder aDecoder: NSCoder) {
        synopsis = aDecoder.decodeObject(forKey: "synopsis") as? String
        homeUrl = aDecoder.decodeObject(forKey: "homeUrl") as? String
    }
    @objc func encode(with aCoder: NSCoder) {
        if synopsis != nil{
           aCoder.encode(synopsis, forKey: "synopsis")
        }
        if homeUrl != nil{
           aCoder.encode(homeUrl, forKey: "homeUrl")
        }
    }
}
