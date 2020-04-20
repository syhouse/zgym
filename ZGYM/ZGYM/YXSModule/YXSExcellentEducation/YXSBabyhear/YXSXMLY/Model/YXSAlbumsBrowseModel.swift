//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class YXSAlbumsBrowseModel : NSObject, NSCoding, Mappable{

	var albumId : Int?
	var albumIntro : String?
	var albumTitle : String?
	var canDownload : Bool?
	var categoryId : Int?
	var channelPlayCount : Int?
	var coverUrl : String?
	var coverUrlLarge : String?
	var coverUrlMiddle : String?
	var coverUrlSmall : String?
	var currentPage : Int?
	var recommendReason : String?
	var sellingPoint : String?
	var shortRichIntro : String?
	var totalCount : Int?
	var totalPage : Int?
	var tracks : [YXSTrackModel]?

	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		albumId <- map["album_id"]
		albumIntro <- map["album_intro"]
		albumTitle <- map["album_title"]
		canDownload <- map["can_download"]
		categoryId <- map["category_id"]
		channelPlayCount <- map["channel_play_count"]
		coverUrl <- map["cover_url"]
		coverUrlLarge <- map["cover_url_large"]
		coverUrlMiddle <- map["cover_url_middle"]
		coverUrlSmall <- map["cover_url_small"]
		currentPage <- map["current_page"]
		recommendReason <- map["recommend_reason"]
		sellingPoint <- map["selling_point"]
		shortRichIntro <- map["short_rich_intro"]
		totalCount <- map["total_count"]
		totalPage <- map["total_page"]
		tracks <- map["tracks"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         albumId = aDecoder.decodeObject(forKey: "album_id") as? Int
         albumIntro = aDecoder.decodeObject(forKey: "album_intro") as? String
         albumTitle = aDecoder.decodeObject(forKey: "album_title") as? String
         canDownload = aDecoder.decodeObject(forKey: "can_download") as? Bool
         categoryId = aDecoder.decodeObject(forKey: "category_id") as? Int
         channelPlayCount = aDecoder.decodeObject(forKey: "channel_play_count") as? Int
         coverUrl = aDecoder.decodeObject(forKey: "cover_url") as? String
         coverUrlLarge = aDecoder.decodeObject(forKey: "cover_url_large") as? String
         coverUrlMiddle = aDecoder.decodeObject(forKey: "cover_url_middle") as? String
         coverUrlSmall = aDecoder.decodeObject(forKey: "cover_url_small") as? String
         currentPage = aDecoder.decodeObject(forKey: "current_page") as? Int
         recommendReason = aDecoder.decodeObject(forKey: "recommend_reason") as? String
         sellingPoint = aDecoder.decodeObject(forKey: "selling_point") as? String
         shortRichIntro = aDecoder.decodeObject(forKey: "short_rich_intro") as? String
         totalCount = aDecoder.decodeObject(forKey: "total_count") as? Int
         totalPage = aDecoder.decodeObject(forKey: "total_page") as? Int
         tracks = aDecoder.decodeObject(forKey: "tracks") as? [YXSTrackModel]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if albumId != nil{
			aCoder.encode(albumId, forKey: "album_id")
		}
		if albumIntro != nil{
			aCoder.encode(albumIntro, forKey: "album_intro")
		}
		if albumTitle != nil{
			aCoder.encode(albumTitle, forKey: "album_title")
		}
		if canDownload != nil{
			aCoder.encode(canDownload, forKey: "can_download")
		}
		if categoryId != nil{
			aCoder.encode(categoryId, forKey: "category_id")
		}
		if channelPlayCount != nil{
			aCoder.encode(channelPlayCount, forKey: "channel_play_count")
		}
		if coverUrl != nil{
			aCoder.encode(coverUrl, forKey: "cover_url")
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
		if currentPage != nil{
			aCoder.encode(currentPage, forKey: "current_page")
		}
		if recommendReason != nil{
			aCoder.encode(recommendReason, forKey: "recommend_reason")
		}
		if sellingPoint != nil{
			aCoder.encode(sellingPoint, forKey: "selling_point")
		}
		if shortRichIntro != nil{
			aCoder.encode(shortRichIntro, forKey: "short_rich_intro")
		}
		if totalCount != nil{
			aCoder.encode(totalCount, forKey: "total_count")
		}
		if totalPage != nil{
			aCoder.encode(totalPage, forKey: "total_page")
		}
		if tracks != nil{
			aCoder.encode(tracks, forKey: "tracks")
		}

	}

}
