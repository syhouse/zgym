//
//  SLFriendsMessageModel.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/17.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import Foundation
import ObjectMapper

class SLFriendsMessageModel : NSObject, NSCoding, Mappable{
    
    var attachment : String?
    var classCircleId : Int?
    var content : String?
    var createTime : String?
    var id : String?
    var operatorStatus : Int?
    var operatorAvatar : String?
    var operatorName : String?
    var receiver : Int?
    var receiverName : String?
    var recipient : Int?
    var sourceId : Int?
    var type : String?
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        attachment <- map["attachment"]
        classCircleId <- map["classCircleId"]
        content <- map["content"]
        createTime <- map["createTime"]
        id <- map["id"]
        operatorStatus <- map["operator"]
        operatorAvatar <- map["operatorAvatar"]
        operatorName <- map["operatorName"]
        receiver <- map["receiver"]
        receiverName <- map["receiverName"]
        recipient <- map["recipient"]
        sourceId <- map["sourceId"]
        type <- map["type"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        attachment = aDecoder.decodeObject(forKey: "attachment") as? String
        classCircleId = aDecoder.decodeObject(forKey: "classCircleId") as? Int
        content = aDecoder.decodeObject(forKey: "content") as? String
        createTime = aDecoder.decodeObject(forKey: "createTime") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        operatorStatus = aDecoder.decodeObject(forKey: "operatorStatus") as? Int
        operatorAvatar = aDecoder.decodeObject(forKey: "operatorAvatar") as? String
        operatorName = aDecoder.decodeObject(forKey: "operatorName") as? String
        receiver = aDecoder.decodeObject(forKey: "receiver") as? Int
        receiverName = aDecoder.decodeObject(forKey: "receiverName") as? String
        recipient = aDecoder.decodeObject(forKey: "recipient") as? Int
        sourceId = aDecoder.decodeObject(forKey: "sourceId") as? Int
        type = aDecoder.decodeObject(forKey: "type") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if attachment != nil{
            aCoder.encode(attachment, forKey: "attachment")
        }
        if classCircleId != nil{
            aCoder.encode(classCircleId, forKey: "classCircleId")
        }
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if operatorStatus != nil{
            aCoder.encode(operatorStatus, forKey: "operatorStatus")
        }
        if operatorAvatar != nil{
            aCoder.encode(operatorAvatar, forKey: "operatorAvatar")
        }
        if operatorName != nil{
            aCoder.encode(operatorName, forKey: "operatorName")
        }
        if receiver != nil{
            aCoder.encode(receiver, forKey: "receiver")
        }
        if receiverName != nil{
            aCoder.encode(receiverName, forKey: "receiverName")
        }
        if recipient != nil{
            aCoder.encode(recipient, forKey: "recipient")
        }
        if sourceId != nil{
            aCoder.encode(sourceId, forKey: "sourceId")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        
    }
    
}
