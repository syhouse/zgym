//
//  YXSSynClassModel.swift
//  ZGYM
//
//  Created by yihao on 2020/4/21.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import ObjectMapper

class YXSSynClassListModel: NSObject, NSCoding, Mappable{
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
    var subject: YXSSynClassSubjectType? {
        get {
            if subjectStr == "CHINESE" {
                return .CHINESE
            } else if subjectStr == "MATHEMATICS" {
                return .MATHEMATICS
            } else if subjectStr == "FOREIGN_LANGUAGES" {
                return .FOREIGN_LANGUAGES
            } else {
                return .CHINESE
            }
        }
    }
    var subjectStr: String?
    
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
        subjectStr <- map["subject"]
    }
    
    @objc required init(coder aDecoder: NSCoder) {
        homeUrl = aDecoder.decodeObject(forKey: "homeUrl") as? String
        playCount = aDecoder.decodeObject(forKey: "playCount") as? Int
        folderName = aDecoder.decodeObject(forKey: "folderName") as? String
        creator = aDecoder.decodeObject(forKey: "creator") as? Int
        updateTime = aDecoder.decodeObject(forKey: "updateTime") as? String
        synopsis = aDecoder.decodeObject(forKey: "synopsis") as? String
        coverUrl = aDecoder.decodeObject(forKey: "coverUrl") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        sortIndex = aDecoder.decodeObject(forKey: "sortIndex") as? Int
        createTime = aDecoder.decodeObject(forKey: "createTime") as? String
        tabId = aDecoder.decodeObject(forKey: "tabId") as? Int
        subjectStr = aDecoder.decodeObject(forKey: "subjectStr") as? String
    }
    
    @objc func encode(with aCoder: NSCoder) {
        if homeUrl != nil{
           aCoder.encode(homeUrl, forKey: "homeUrl")
        }
        if playCount != nil{
           aCoder.encode(playCount, forKey: "playCount")
        }
        if folderName != nil{
           aCoder.encode(folderName, forKey: "folderName")
        }
        if creator != nil{
           aCoder.encode(creator, forKey: "creator")
        }
        if updateTime != nil{
           aCoder.encode(updateTime, forKey: "updateTime")
        }
        if synopsis != nil{
           aCoder.encode(synopsis, forKey: "synopsis")
        }
        if coverUrl != nil{
           aCoder.encode(coverUrl, forKey: "coverUrl")
        }
        if id != nil{
           aCoder.encode(id, forKey: "id")
        }
        if sortIndex != nil{
           aCoder.encode(sortIndex, forKey: "sortIndex")
        }
        if createTime != nil{
           aCoder.encode(createTime, forKey: "createTime")
        }
        if tabId != nil{
           aCoder.encode(tabId, forKey: "tabId")
        }
        if subjectStr != nil{
           aCoder.encode(subjectStr, forKey: "subjectStr")
        }
    }
}

class YXSSynClassTabModel: NSObject, NSCoding, Mappable {
    
    var updateTime: String?
    /// tab标签id
    var id: Int?
    var createTime: String?
    var creator: Int?
    /// tab标签类型
    var stage: YXSSynClassListType? {
        get {
            if stageString == "PRIMARY_SCHOOL" {
                return .PRIMARY_SCHOOL
            } else if stageString == "MIDDLE_SCHOOL" {
                return .MIDDLE_SCHOOL
            } else if stageString == "HIGH_SCHOOL" {
                return .HIGH_SCHOOL
            } else {
                return .PRIMARY_SCHOOL
            }
        }
    }
    
    var stageString: String?
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
        stageString <- map["stage"]
        tabName <- map["tabName"]
        sortIndex <- map["sortIndex"]
    }
    
    @objc required init(coder aDecoder: NSCoder) {
        updateTime = aDecoder.decodeObject(forKey: "updateTime") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        createTime = aDecoder.decodeObject(forKey: "createTime") as? String
        creator = aDecoder.decodeObject(forKey: "creator") as? Int
        stageString = aDecoder.decodeObject(forKey: "stageString") as? String
        tabName = aDecoder.decodeObject(forKey: "tabName") as? String
        sortIndex = aDecoder.decodeObject(forKey: "sortIndex") as? Int
    }
    
    @objc func encode(with aCoder: NSCoder) {
        if updateTime != nil{
           aCoder.encode(updateTime, forKey: "updateTime")
        }
        if id != nil{
           aCoder.encode(id, forKey: "id")
        }
        if createTime != nil{
           aCoder.encode(createTime, forKey: "createTime")
        }
        if creator != nil{
           aCoder.encode(creator, forKey: "creator")
        }
        if stageString != nil{
           aCoder.encode(stageString, forKey: "stageString")
        }
        if tabName != nil{
           aCoder.encode(tabName, forKey: "tabName")
        }
        if sortIndex != nil{
           aCoder.encode(sortIndex, forKey: "sortIndex")
        }
    }
}
