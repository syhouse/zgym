//
//	LastUptrack.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class YXSLastUptrackModel : NSObject, NSCoding, Mappable{

	var createdAt : Int?
	var duration : Float?
	var trackId : Int?
	var trackTitle : String?
	var updatedAt : Int?

	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		createdAt <- map["created_at"]
		duration <- map["duration"]
		trackId <- map["track_id"]
		trackTitle <- map["track_title"]
		updatedAt <- map["updated_at"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         duration = aDecoder.decodeObject(forKey: "duration") as? Float
         trackId = aDecoder.decodeObject(forKey: "track_id") as? Int
         trackTitle = aDecoder.decodeObject(forKey: "track_title") as? String
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if duration != nil{
			aCoder.encode(duration, forKey: "duration")
		}
		if trackId != nil{
			aCoder.encode(trackId, forKey: "track_id")
		}
		if trackTitle != nil{
			aCoder.encode(trackTitle, forKey: "track_title")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}

	}

}
