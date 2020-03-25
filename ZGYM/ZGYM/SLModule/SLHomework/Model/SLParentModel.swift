//
//  SLParentModel.swift
//  ZGYM
//
//  Created by sl_mac on 2020/1/3.
//  Copyright © 2020 hnsl_mac. All rights reserved.
//

import Foundation
import ObjectMapper


class SLParentModel : NSObject, NSCoding, Mappable{

    var account : String?
    var avatar : String?
    var childrenId : Int?
    var imId : String?
    var parentName : String?
    var realName : String?
    var relationship : String?


    private override init(){}
    required init?(map: Map){}

    func mapping(map: Map)
    {
        account <- map["account"]
        avatar <- map["avatar"]
        childrenId <- map["childrenId"]
        imId <- map["imId"]
        parentName <- map["parentName"]
        realName <- map["realName"]
        relationship <- map["relationship"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         account = aDecoder.decodeObject(forKey: "account") as? String
         avatar = aDecoder.decodeObject(forKey: "avatar") as? String
         childrenId = aDecoder.decodeObject(forKey: "childrenId") as? Int
         imId = aDecoder.decodeObject(forKey: "imId") as? String
         parentName = aDecoder.decodeObject(forKey: "parentName") as? String
         realName = aDecoder.decodeObject(forKey: "realName") as? String
         relationship = aDecoder.decodeObject(forKey: "relationship") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if account != nil{
            aCoder.encode(account, forKey: "account")
        }
        if avatar != nil{
            aCoder.encode(avatar, forKey: "avatar")
        }
        if childrenId != nil{
            aCoder.encode(childrenId, forKey: "childrenId")
        }
        if imId != nil{
            aCoder.encode(imId, forKey: "imId")
        }
        if parentName != nil{
            aCoder.encode(parentName, forKey: "parentName")
        }
        if realName != nil{
            aCoder.encode(realName, forKey: "realName")
        }
        if relationship != nil{
            aCoder.encode(relationship, forKey: "relationship")
        }

    }

}
