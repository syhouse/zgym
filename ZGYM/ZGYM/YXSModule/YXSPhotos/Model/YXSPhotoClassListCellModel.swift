//
//  YXSPhotoClassListCellModel.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/5/26.
//  Copyright © 2020 zgym. All rights reserved.
//
import Foundation
import ObjectMapper

class YXSPhotoClassListCellModel : NSObject, NSCoding, Mappable{

    var albumCount : Int?
    var classChildrenSum : Int?
    var classId : Int?
    var className : String?
    var classNo : String?
    var stage : String?



    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        albumCount <- map["albumCount"]
        classChildrenSum <- map["classChildrenSum"]
        classId <- map["classId"]
        className <- map["className"]
        classNo <- map["classNo"]
        stage <- map["stage"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         albumCount = aDecoder.decodeObject(forKey: "albumCount") as? Int
         classChildrenSum = aDecoder.decodeObject(forKey: "classChildrenSum") as? Int
         classId = aDecoder.decodeObject(forKey: "classId") as? Int
         className = aDecoder.decodeObject(forKey: "className") as? String
         classNo = aDecoder.decodeObject(forKey: "classNo") as? String
         stage = aDecoder.decodeObject(forKey: "stage") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if albumCount != nil{
            aCoder.encode(albumCount, forKey: "albumCount")
        }
        if classChildrenSum != nil{
            aCoder.encode(classChildrenSum, forKey: "classChildrenSum")
        }
        if classId != nil{
            aCoder.encode(classId, forKey: "classId")
        }
        if className != nil{
            aCoder.encode(className, forKey: "className")
        }
        if classNo != nil{
            aCoder.encode(classNo, forKey: "classNo")
        }
        if stage != nil{
            aCoder.encode(stage, forKey: "stage")
        }

    }

}
