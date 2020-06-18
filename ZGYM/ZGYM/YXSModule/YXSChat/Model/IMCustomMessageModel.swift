//
//  SLMessageCustomModel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/27.
//  Copyright © 2019 zgjy_mac. All rights reserved.
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
    var stage: String?
    
    var callbackRequestParameter: CallbackRequestParameter?
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
        callbackRequestParameter <- map["callbackRequestParameter"]
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
        callbackRequestParameter = aDecoder.decodeObject(forKey: "callbackRequestParameter") as? CallbackRequestParameter
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
        if callbackRequestParameter != nil{
            aCoder.encode(callbackRequestParameter, forKey: "callbackRequestParameter")
        }
    }
}


class CallbackRequestParameter:NSObject, NSCoding, NSCopying, Mappable{
    func copy(with zone: NSZone? = nil) -> Any {
        let theCopyObj = CallbackRequestParameter.init(JSON: self.toJSON())!
        return theCopyObj
    }
    
    /// 打卡任务id
    var clockInId: Int?
    /// 家长打卡id
    var clockInCommitId: Int?
    var timeStamp: Int?
    var userType: String?
    ///接龙类型
    var type: Int?
    
    var calculativeStrategy: Int?
    ///瀑布流id
    var waterfallId: Int?
    
    private override init(){}
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        clockInId <- map["clockInId"]
        clockInCommitId <- map["clockInCommitId"]
        timeStamp <- map["timeStamp"]
        userType <- map["userType"]
        calculativeStrategy <- map["calculativeStrategy"]
        type <- map["type"]
        waterfallId <- map["waterfallId"]
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        clockInId = aDecoder.decodeObject(forKey: "clockInId") as? Int
        clockInCommitId = aDecoder.decodeObject(forKey: "clockInCommitId") as? Int
        timeStamp = aDecoder.decodeObject(forKey: "timeStamp") as? Int
        userType = aDecoder.decodeObject(forKey: "userType") as? String
        calculativeStrategy = aDecoder.decodeObject(forKey: "calculativeStrategy") as? Int
        type = aDecoder.decodeObject(forKey: "type") as? Int
        waterfallId = aDecoder.decodeObject(forKey: "waterfallId") as? Int
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if clockInCommitId != nil{
            aCoder.encode(clockInCommitId, forKey: "clockInCommitId")
        }
        if clockInId != nil{
            aCoder.encode(clockInId, forKey: "clockInId")
        }
        if timeStamp != nil{
            aCoder.encode(timeStamp, forKey: "timeStamp")
        }
        if userType != nil{
            aCoder.encode(userType, forKey: "userType")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if calculativeStrategy != nil{
            aCoder.encode(calculativeStrategy, forKey: "calculativeStrategy")
        }
        if waterfallId != nil{
            aCoder.encode(waterfallId, forKey: "waterfallId")
        }
    }
}

