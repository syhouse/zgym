//
//  SLFolderModel.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/8.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import ObjectMapper

class SLFolderModel : SLBaseFileModel {

    var createTime : String?
    var folderName : String?
    var id : Int?
    var parentId : Int?
    var updateTime : String?
    var userId : Int?

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map)
    {
        createTime <- map["createTime"]
        folderName <- map["folderName"]
        id <- map["id"]
        parentId <- map["parentId"]
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
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         folderName = aDecoder.decodeObject(forKey: "folderName") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         parentId = aDecoder.decodeObject(forKey: "parentId") as? Int
         updateTime = aDecoder.decodeObject(forKey: "updateTime") as? String
         userId = aDecoder.decodeObject(forKey: "userId") as? Int

    }
    
    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc override func encode(with aCoder: NSCoder)
    {
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if folderName != nil{
            aCoder.encode(folderName, forKey: "folderName")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if parentId != nil{
            aCoder.encode(parentId, forKey: "parentId")
        }
        if updateTime != nil{
            aCoder.encode(updateTime, forKey: "updateTime")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "userId")
        }

    }

}
