//
//	SubordinatedAlbum.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class YXSSubordinatedAlbumModel : NSObject, NSCoding, Mappable{

	var albumTitle : String?
	var coverUrlLarge : String?
	var coverUrlMiddle : String?
	var coverUrlSmall : String?
	var id : Int?

	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		albumTitle <- map["album_title"]
		coverUrlLarge <- map["cover_url_large"]
		coverUrlMiddle <- map["cover_url_middle"]
		coverUrlSmall <- map["cover_url_small"]
		id <- map["id"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         albumTitle = aDecoder.decodeObject(forKey: "album_title") as? String
         coverUrlLarge = aDecoder.decodeObject(forKey: "cover_url_large") as? String
         coverUrlMiddle = aDecoder.decodeObject(forKey: "cover_url_middle") as? String
         coverUrlSmall = aDecoder.decodeObject(forKey: "cover_url_small") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if albumTitle != nil{
			aCoder.encode(albumTitle, forKey: "album_title")
		}
		if coverUrlLarge != nil{
			aCoder.encode(coverUrlLarge, forKey: "cover_url_large")
		}
		if coverUrlMiddle != nil{
			aCoder.encode(coverUrlMiddle, forKey: "cover_url_middle")
		}
		if coverUrlSmall != nil{
			aCoder.encode(coverUrlSmall, forKey: "cover_url_small")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}

	}

}
