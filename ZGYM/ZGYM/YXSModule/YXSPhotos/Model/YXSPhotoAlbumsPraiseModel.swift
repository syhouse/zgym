//
//  YXSPhotoAlbumsPraiseModel.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/13.
//  Copyright © 2020 hmym. All rights reserved.
//


import Foundation
import ObjectMapper


class YXSPhotoAlbumsPraiseModel : NSObject, NSCoding, Mappable{

    var commentCount : Int?
    
    /// 点赞(0未点赞  1已点赞)
    var praiseStat : Int?
    var praiseCount : Int?

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        commentCount <- map["commentCount"]
        praiseStat <- map["praiseStat"]
        praiseCount <- map["praiseCount"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         commentCount = aDecoder.decodeObject(forKey: "commentCount") as? Int
         praiseStat = aDecoder.decodeObject(forKey: "praiseStat") as? Int
         praiseCount = aDecoder.decodeObject(forKey: "praiseCount") as? Int

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if commentCount != nil{
            aCoder.encode(commentCount, forKey: "commentCount")
        }
        if praiseStat != nil{
            aCoder.encode(praiseStat, forKey: "praiseStat")
        }
        if praiseCount != nil{
            aCoder.encode(praiseCount, forKey: "praiseCount")
        }

    }

}
