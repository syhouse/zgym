//
//  SLClassStarPartentModel.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/10.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import Foundation
import ObjectMapper

class SLClassStarPartentModel : NSObject, NSCoding, Mappable{
    var averageScore : String?
    var currentChildren : SLClassStarChildrenModel?
    var currentSumScore : Int?
    var mapTop3 : ClassStarMapTop3?
    var sumScore : Int?
    var topPercent : String?
    
    var homeCurrentChildren : String?
    var homeMapTop3 : String?

    
    /// 是否展示提醒老师
    var showRemindTeacher : Bool{
        get{
            return mapTop3?.first == nil ? true : false
        }
    }
    
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        averageScore <- map["averageScore"]
        currentChildren <- map["currentChildren"]
        currentSumScore <- map["currentSumScore"]
        mapTop3 <- map["mapTop3"]
        sumScore <- map["sumScore"]
        topPercent <- map["topPercent"]
        
        homeCurrentChildren <- map["currentChildren"]
        homeMapTop3 <- map["mapTop3"]
        
    }
    
    @objc required init(coder aDecoder: NSCoder)
      {
          averageScore = aDecoder.decodeObject(forKey: "averageScore") as? String
          currentChildren = aDecoder.decodeObject(forKey: "currentChildren") as? SLClassStarChildrenModel
          currentSumScore = aDecoder.decodeObject(forKey: "currentSumScore") as? Int
          mapTop3 = aDecoder.decodeObject(forKey: "mapTop3") as? ClassStarMapTop3
          sumScore = aDecoder.decodeObject(forKey: "sumScore") as? Int
          topPercent = aDecoder.decodeObject(forKey: "topPercent") as? String
          homeCurrentChildren = aDecoder.decodeObject(forKey: "homeCurrentChildren") as? String
          homeMapTop3 = aDecoder.decodeObject(forKey: "homeMapTop3") as? String
      }
      
      /**
       * NSCoding required method.
       * Encodes mode properties into the decoder
       */
      @objc func encode(with aCoder: NSCoder)
      {
          if averageScore != nil{
              aCoder.encode(averageScore, forKey: "averageScore")
          }
          if currentChildren != nil{
              aCoder.encode(currentChildren, forKey: "currentChildren")
          }
          if currentSumScore != nil{
              aCoder.encode(currentSumScore, forKey: "currentSumScore")
          }
          if mapTop3 != nil{
              aCoder.encode(mapTop3, forKey: "mapTop3")
          }
          if sumScore != nil{
              aCoder.encode(sumScore, forKey: "sumScore")
          }
          if topPercent != nil{
              aCoder.encode(topPercent, forKey: "topPercent")
          }
          if homeCurrentChildren != nil{
              aCoder.encode(homeCurrentChildren, forKey: "homeCurrentChildren")
          }
          if homeMapTop3 != nil{
              aCoder.encode(homeMapTop3, forKey: "homeMapTop3")
          }
      }
}

class ClassStarMapTop3 : NSObject, NSCoding, Mappable{

    var first : [SLClassStarChildrenModel]?
    var secend : [SLClassStarChildrenModel]?
    var thrid : [SLClassStarChildrenModel]?

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        first <- map["1"]
        secend <- map["2"]
        thrid <- map["3"]
        
    }
    
    @objc required init(coder aDecoder: NSCoder)
      {
          first = aDecoder.decodeObject(forKey: "first") as? [SLClassStarChildrenModel]
          secend = aDecoder.decodeObject(forKey: "secend") as? [SLClassStarChildrenModel]
          thrid = aDecoder.decodeObject(forKey: "thrid") as? [SLClassStarChildrenModel]
      }
      
      /**
       * NSCoding required method.
       * Encodes mode properties into the decoder
       */
      @objc func encode(with aCoder: NSCoder)
      {
          if first != nil{
              aCoder.encode(first, forKey: "first")
          }
          if secend != nil{
              aCoder.encode(secend, forKey: "secend")
          }
          if thrid != nil{
              aCoder.encode(thrid, forKey: "thrid")
          }
      }
}
