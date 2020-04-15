//
//  SLFileModel.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/11.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import ObjectMapper

class SLFileModel : SLBaseFileModel {

    var bgUrl : String?
    var createTime : String?
    var fileDuration : Int?
    var fileName : String?
    var fileSize : Int?
    var fileType : String?
    var fileUrl : String?
    var folderId : Int?
    var id : Int?
    var updateTime : String?
    var userId : Int?

    required init?(map: Map){
        super.init(map: map)
    }

    override func mapping(map: Map)
    {
        bgUrl <- map["bgUrl"]
        createTime <- map["createTime"]
        fileDuration <- map["fileDuration"]
        fileName <- map["fileName"]
        fileSize <- map["fileSize"]
        fileType <- map["fileType"]
        fileUrl <- map["fileUrl"]
        folderId <- map["folderId"]
        id <- map["id"]
        updateTime <- map["updateTime"]
        userId <- map["userId"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
         bgUrl = aDecoder.decodeObject(forKey: "bgUrl") as? String
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         fileDuration = aDecoder.decodeObject(forKey: "fileDuration") as? Int
         fileName = aDecoder.decodeObject(forKey: "fileName") as? String
         fileSize = aDecoder.decodeObject(forKey: "fileSize") as? Int
         fileType = aDecoder.decodeObject(forKey: "fileType") as? String
         fileUrl = aDecoder.decodeObject(forKey: "fileUrl") as? String
         folderId = aDecoder.decodeObject(forKey: "folderId") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         updateTime = aDecoder.decodeObject(forKey: "updateTime") as? String
         userId = aDecoder.decodeObject(forKey: "userId") as? Int

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc override func encode(with aCoder: NSCoder)
    {
        if bgUrl != nil{
            aCoder.encode(bgUrl, forKey: "bgUrl")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if fileDuration != nil{
            aCoder.encode(fileDuration, forKey: "fileDuration")
        }
        if fileName != nil{
            aCoder.encode(fileName, forKey: "fileName")
        }
        if fileSize != nil{
            aCoder.encode(fileSize, forKey: "fileSize")
        }
        if fileType != nil{
            aCoder.encode(fileType, forKey: "fileType")
        }
        if fileUrl != nil{
            aCoder.encode(fileUrl, forKey: "fileUrl")
        }
        if folderId != nil{
            aCoder.encode(folderId, forKey: "folderId")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if updateTime != nil{
            aCoder.encode(updateTime, forKey: "updateTime")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "userId")
        }

    }

}
