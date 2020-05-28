//
//  YXSPhotoClassPhotoAlbumListMsgModel.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/5/27.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import ObjectMapper


class YXSPhotoClassPhotoAlbumListMsgModel : NSObject, NSCoding, Mappable{

    var messageAvatar : String?
    var messageCount : Int?
    var messageUserType : String?

    
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        messageAvatar <- map["messageAvatar"]
        messageCount <- map["messageCount"]
        messageUserType <- map["messageUserType"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         messageAvatar = aDecoder.decodeObject(forKey: "messageAvatar") as? String
         messageCount = aDecoder.decodeObject(forKey: "messageCount") as? Int
         messageUserType = aDecoder.decodeObject(forKey: "messageUserType") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if messageAvatar != nil{
            aCoder.encode(messageAvatar, forKey: "messageAvatar")
        }
        if messageCount != nil{
            aCoder.encode(messageCount, forKey: "messageCount")
        }
        if messageUserType != nil{
            aCoder.encode(messageUserType, forKey: "messageUserType")
        }

    }

}
