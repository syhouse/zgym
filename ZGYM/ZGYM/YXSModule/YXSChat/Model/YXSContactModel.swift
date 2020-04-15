//
//  YXSContactModel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/28.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class YXSContactModel : NSObject, NSCoding, Mappable{

    var account : String?
    var imAvatar : String?
    var imId : String?
    var imNick : String?
    var position : String?
    var userId : Int?

    private override init(){}
    required init?(map: Map){}

    func mapping(map: Map)
    {
        account <- map["account"]
        imAvatar <- map["imAvatar"]
        imId <- map["imId"]
        imNick <- map["imNick"]
        position <- map["position"]
        userId <- map["userId"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         account = aDecoder.decodeObject(forKey: "account") as? String
         imAvatar = aDecoder.decodeObject(forKey: "imAvatar") as? String
         imId = aDecoder.decodeObject(forKey: "imId") as? String
         imNick = aDecoder.decodeObject(forKey: "imNick") as? String
         position = aDecoder.decodeObject(forKey: "position") as? String
         userId = aDecoder.decodeObject(forKey: "userId") as? Int

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
        if imAvatar != nil{
            aCoder.encode(imAvatar, forKey: "imAvatar")
        }
        if imId != nil{
            aCoder.encode(imId, forKey: "imId")
        }
        if imNick != nil{
            aCoder.encode(imNick, forKey: "imNick")
        }
        if position != nil{
            aCoder.encode(position, forKey: "position")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "userId")
        }

    }

}
