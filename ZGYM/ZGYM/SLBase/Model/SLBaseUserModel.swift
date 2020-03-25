//
//    SLBaseUserModel.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class SLBaseUserModel : NSObject, NSCoding, Mappable{
    required init?(map: Map) {}
    
    var id : Int?
    var isSelected : Bool?
    var name : String?


    func mapping(map: Map)
    {
        id <- map["id"]
        isSelected <- map["isSelected"]
        name <- map["name"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         id = aDecoder.decodeObject(forKey: "id") as? Int
         isSelected = aDecoder.decodeObject(forKey: "isSelected") as? Bool
         name = aDecoder.decodeObject(forKey: "name") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isSelected != nil{
            aCoder.encode(isSelected, forKey: "isSelected")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }

    }

}
