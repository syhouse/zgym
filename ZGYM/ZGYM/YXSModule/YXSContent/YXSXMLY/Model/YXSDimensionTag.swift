//
//	DimensionTag.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class YXSDimensionTag : NSObject, NSCoding, Mappable{

	var id : Int?
	var kind : String?
	var name : String?

	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		id <- map["id"]
		kind <- map["kind"]
		name <- map["name"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "id") as? Int
         kind = aDecoder.decodeObject(forKey: "kind") as? String
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
		if kind != nil{
			aCoder.encode(kind, forKey: "kind")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}

	}

}
