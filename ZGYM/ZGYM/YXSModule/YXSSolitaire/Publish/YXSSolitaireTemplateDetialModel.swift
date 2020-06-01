//
//  YXSSolitaireTemplateDetialModel.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/29.
//  Copyright © 2020 zgym. All rights reserved.
//
import Foundation
import ObjectMapper


class YXSSolitaireTemplateDetialModel : NSObject, NSCoding, Mappable{

    var gatherHolders : [YXSGatherHolder]?
    var gatherId : Int?


    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        gatherHolders <- map["gatherHolders"]
        gatherId <- map["gatherId"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         gatherHolders = aDecoder.decodeObject(forKey: "gatherHolders") as? [YXSGatherHolder]
         gatherId = aDecoder.decodeObject(forKey: "gatherId") as? Int
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if gatherHolders != nil{
            aCoder.encode(gatherHolders, forKey: "gatherHolders")
        }
        if gatherId != nil{
            aCoder.encode(gatherId, forKey: "gatherId")
        }

    }

}


class YXSGatherHolder : NSObject, NSCoding, Mappable{

    var gatherHolderItemJson : String?{
        didSet{
            gatherHolderItem = YXSGatherHolderItem.init(JSONString: gatherHolderItemJson ?? "")
        }
    }

    
    var gatherType : String?
    
    var gatherHolderItem: YXSGatherHolderItem?


    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        gatherHolderItemJson <- map["gatherHolderItemJson"]
        gatherType <- map["gatherType"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         gatherHolderItemJson = aDecoder.decodeObject(forKey: "gatherHolderItemJson") as? String
         gatherType = aDecoder.decodeObject(forKey: "gatherType") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if gatherHolderItemJson != nil{
            aCoder.encode(gatherHolderItemJson, forKey: "gatherHolderItemJson")
        }
        if gatherType != nil{
            aCoder.encode(gatherType, forKey: "gatherType")
        }

    }

}

class YXSGatherHolderItem : NSObject, NSCoding, Mappable{
    var gatherType : String?

    var optionContext: String?
    
    var optionImage: String?
    
    var optionName: String?

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        gatherType <- map["gatherType"]
        optionContext <- map["optionContext"]
        optionImage <- map["optionImage"]
        optionName <- map["optionName"]
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         optionName = aDecoder.decodeObject(forKey: "optionName") as? String
         optionContext = aDecoder.decodeObject(forKey: "optionContext") as? String
        gatherType = aDecoder.decodeObject(forKey: "gatherType") as? String
        optionImage = aDecoder.decodeObject(forKey: "optionImage") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if optionImage != nil{
            aCoder.encode(optionImage, forKey: "optionImage")
        }
        if optionName != nil{
            aCoder.encode(optionName, forKey: "optionName")
        }
        if optionContext != nil{
            aCoder.encode(optionContext, forKey: "optionContext")
        }
        if gatherType != nil{
            aCoder.encode(gatherType, forKey: "gatherType")
        }

    }

}
