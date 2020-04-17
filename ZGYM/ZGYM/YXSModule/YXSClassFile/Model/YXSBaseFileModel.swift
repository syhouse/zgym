//
//  YXSBaseFileModel.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/8.
//  Copyright © 2020 hmym. All rights reserved.
//
import Foundation
import ObjectMapper


class YXSBaseFileModel : NSObject, NSCoding, Mappable{

    var isEditing : Bool? = false
    var isSelected : Bool? = false

    required init?(map: Map){}

    func mapping(map: Map)
    {
        isEditing <- map["isEditing"]
        isSelected <- map["isSelected"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         isEditing = aDecoder.decodeObject(forKey: "isEditing") as? Bool
         isSelected = aDecoder.decodeObject(forKey: "isSelected") as? Bool

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if isEditing != nil{
            aCoder.encode(isEditing, forKey: "isEditing")
        }
        if isSelected != nil{
            aCoder.encode(isSelected, forKey: "isSelected")
        }

    }

}
