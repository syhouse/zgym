//
//	Announcer.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class YXSAnnouncer : NSObject, NSCoding, Mappable{

	var anchorGrade : Int?
	var avatarUrl : String?
	var id : Int?
	var isVerified : Bool?
	var kind : String?
	var nickname : String?

	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		anchorGrade <- map["anchor_grade"]
		avatarUrl <- map["avatar_url"]
		id <- map["id"]
		isVerified <- map["is_verified"]
		kind <- map["kind"]
		nickname <- map["nickname"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         anchorGrade = aDecoder.decodeObject(forKey: "anchor_grade") as? Int
         avatarUrl = aDecoder.decodeObject(forKey: "avatar_url") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         isVerified = aDecoder.decodeObject(forKey: "is_verified") as? Bool
         kind = aDecoder.decodeObject(forKey: "kind") as? String
         nickname = aDecoder.decodeObject(forKey: "nickname") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if anchorGrade != nil{
			aCoder.encode(anchorGrade, forKey: "anchor_grade")
		}
		if avatarUrl != nil{
			aCoder.encode(avatarUrl, forKey: "avatar_url")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if isVerified != nil{
			aCoder.encode(isVerified, forKey: "is_verified")
		}
		if kind != nil{
			aCoder.encode(kind, forKey: "kind")
		}
		if nickname != nil{
			aCoder.encode(nickname, forKey: "nickname")
		}

	}

}
