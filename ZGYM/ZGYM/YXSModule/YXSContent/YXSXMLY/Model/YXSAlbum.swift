//
//	Album.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class YXSAlbum : NSObject, NSCoding, Mappable{

	var albumIntro : String?
	var albumTitle : String?
	var announcer : YXSAnnouncer?
	var channelPlayCount : Int?
	var composedPriceType : Int?
	var coverUrlLarge : String?
	var coverUrlMiddle : String?
	var coverUrlSmall : String?
	var createdAt : Int?
	var dimensionTags : [YXSDimensionTag]?
	var id : Int?
	var includeTrackCount : Int?
	var isPaid : Int?
	var kind : String?
	var operationCategory : YXSOperationCategory?
	var playCount : Int?
	var priceTypeInfo : [AnyObject]?
	var updatedAt : Int?

	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		albumIntro <- map["album_intro"]
		albumTitle <- map["album_title"]
		announcer <- map["announcer"]
		channelPlayCount <- map["channel_play_count"]
		composedPriceType <- map["composed_price_type"]
		coverUrlLarge <- map["cover_url_large"]
		coverUrlMiddle <- map["cover_url_middle"]
		coverUrlSmall <- map["cover_url_small"]
		createdAt <- map["created_at"]
		dimensionTags <- map["dimension_tags"]
		id <- map["id"]
		includeTrackCount <- map["include_track_count"]
		isPaid <- map["is_paid"]
		kind <- map["kind"]
		operationCategory <- map["operation_category"]
		playCount <- map["play_count"]
		priceTypeInfo <- map["price_type_info"]
		updatedAt <- map["updated_at"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         albumIntro = aDecoder.decodeObject(forKey: "album_intro") as? String
         albumTitle = aDecoder.decodeObject(forKey: "album_title") as? String
         announcer = aDecoder.decodeObject(forKey: "announcer") as? YXSAnnouncer
         channelPlayCount = aDecoder.decodeObject(forKey: "channel_play_count") as? Int
         composedPriceType = aDecoder.decodeObject(forKey: "composed_price_type") as? Int
         coverUrlLarge = aDecoder.decodeObject(forKey: "cover_url_large") as? String
         coverUrlMiddle = aDecoder.decodeObject(forKey: "cover_url_middle") as? String
         coverUrlSmall = aDecoder.decodeObject(forKey: "cover_url_small") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         dimensionTags = aDecoder.decodeObject(forKey: "dimension_tags") as? [YXSDimensionTag]
         id = aDecoder.decodeObject(forKey: "id") as? Int
         includeTrackCount = aDecoder.decodeObject(forKey: "include_track_count") as? Int
         isPaid = aDecoder.decodeObject(forKey: "is_paid") as? Int
         kind = aDecoder.decodeObject(forKey: "kind") as? String
         operationCategory = aDecoder.decodeObject(forKey: "operation_category") as? YXSOperationCategory
         playCount = aDecoder.decodeObject(forKey: "play_count") as? Int
         priceTypeInfo = aDecoder.decodeObject(forKey: "price_type_info") as? [AnyObject]
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if albumIntro != nil{
			aCoder.encode(albumIntro, forKey: "album_intro")
		}
		if albumTitle != nil{
			aCoder.encode(albumTitle, forKey: "album_title")
		}
		if announcer != nil{
			aCoder.encode(announcer, forKey: "announcer")
		}
		if channelPlayCount != nil{
			aCoder.encode(channelPlayCount, forKey: "channel_play_count")
		}
		if composedPriceType != nil{
			aCoder.encode(composedPriceType, forKey: "composed_price_type")
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
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if dimensionTags != nil{
			aCoder.encode(dimensionTags, forKey: "dimension_tags")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if includeTrackCount != nil{
			aCoder.encode(includeTrackCount, forKey: "include_track_count")
		}
		if isPaid != nil{
			aCoder.encode(isPaid, forKey: "is_paid")
		}
		if kind != nil{
			aCoder.encode(kind, forKey: "kind")
		}
		if operationCategory != nil{
			aCoder.encode(operationCategory, forKey: "operation_category")
		}
		if playCount != nil{
			aCoder.encode(playCount, forKey: "play_count")
		}
		if priceTypeInfo != nil{
			aCoder.encode(priceTypeInfo, forKey: "price_type_info")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}

	}

}
