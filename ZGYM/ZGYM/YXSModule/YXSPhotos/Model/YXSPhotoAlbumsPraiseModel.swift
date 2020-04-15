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

    var commentList : [AnyObject]?
    
    /// 点赞(0未点赞  1已点赞)
    var isPraise : Int?
    var praiseCount : Int?

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        commentList <- map["commentList"]
        isPraise <- map["isPraise"]
        praiseCount <- map["praiseCount"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         commentList = aDecoder.decodeObject(forKey: "commentList") as? [AnyObject]
         isPraise = aDecoder.decodeObject(forKey: "isPraise") as? Int
         praiseCount = aDecoder.decodeObject(forKey: "praiseCount") as? Int

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if commentList != nil{
            aCoder.encode(commentList, forKey: "commentList")
        }
        if isPraise != nil{
            aCoder.encode(isPraise, forKey: "isPraise")
        }
        if praiseCount != nil{
            aCoder.encode(praiseCount, forKey: "praiseCount")
        }

    }

}
