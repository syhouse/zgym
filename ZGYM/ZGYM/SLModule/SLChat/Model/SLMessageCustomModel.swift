//
//  SLMessageCustomModel.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/27.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class IMCustomMessageModel : NSObject, NSCoding, NSCopying, Mappable{
    func copy(with zone: NSZone? = nil) -> Any {
        let theCopyObj = IMCustomMessageModel.init(JSON: self.toJSON())!
        return theCopyObj
    }
    
    @objc var content : String?
    var createTime : String?
    var msgType : Int?  /// (0:待办,1:变更,2:通知,3:撤销)
    var onlinePush : Int?
    var serviceId : Int?
    var serviceType : Int?
    var classId : Int?
    var childrenId : Int?
    var ring: Int?      /// 是否响铃(0否，1是)
    var stage: String?      /// 是否响铃(0否，1是)
    
    private override init(){}
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        content <- map["content"]
        createTime <- map["createTime"]
        msgType <- map["msgType"]
        onlinePush <- map["onlinePush"]
        serviceId <- map["serviceId"]
        serviceType <- map["serviceType"]
        classId <- map["classId"]
        childrenId <- map["childrenId"]
        ring <- map["ring"]
        stage <- map["stage"]
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        content = aDecoder.decodeObject(forKey: "content") as? String
        createTime = aDecoder.decodeObject(forKey: "createTime") as? String
        msgType = aDecoder.decodeObject(forKey: "msgType") as? Int
        onlinePush = aDecoder.decodeObject(forKey: "onlinePush") as? Int
        serviceId = aDecoder.decodeObject(forKey: "serviceId") as? Int
        serviceType = aDecoder.decodeObject(forKey: "serviceType") as? Int
        classId = aDecoder.decodeObject(forKey: "classId") as? Int
        childrenId = aDecoder.decodeObject(forKey: "childrenId") as? Int
        ring = aDecoder.decodeObject(forKey: "ring") as? Int
        stage = aDecoder.decodeObject(forKey: "stage") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if msgType != nil{
            aCoder.encode(msgType, forKey: "msgType")
        }
        if onlinePush != nil{
            aCoder.encode(onlinePush, forKey: "onlinePush")
        }
        if serviceId != nil{
            aCoder.encode(serviceId, forKey: "serviceId")
        }
        if serviceType != nil{
            aCoder.encode(serviceType, forKey: "serviceType")
        }
        if classId != nil{
            aCoder.encode(classId, forKey: "classId")
        }
        if childrenId != nil{
            aCoder.encode(childrenId, forKey: "childrenId")
        }
        if ring != nil{
            aCoder.encode(ring, forKey: "ring")
        }
        if stage != nil{
            aCoder.encode(stage, forKey: "stage")
        }
    }
}
