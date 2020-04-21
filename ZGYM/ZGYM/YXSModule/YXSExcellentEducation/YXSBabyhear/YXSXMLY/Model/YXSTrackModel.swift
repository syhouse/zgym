//
//	Track.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class YXSTrackModel : NSObject, NSCoding, Mappable{

	var announcer : YXSAnnouncer?
	var canDownload : Bool?
	var categoryId : Int?
	var commentCount : Int?
	var containVideo : Bool?
	var coverUrlLarge : String?
	var coverUrlMiddle : String?
	var coverUrlSmall : String?
	var createdAt : Int?
	var downloadCount : Int?
	var downloadSize : Int?
	var downloadUrl : String?
	var duration : Int?
	var favoriteCount : Int?
	var id : Int?
	var kind : String?
	var orderNum : Int?
	var playCount : Int?
	var playSize24M4a : Int?
	var playSize32 : Int?
	var playSize64 : Int?
	var playSize64M4a : Int?
	var playSizeAmr : Int?
	var playUrl24M4a : String?
	var playUrl32 : String?
	var playUrl64 : String?
	var playUrl64M4a : String?
	var playUrlAmr : String?
	var source : Int?
	var subordinatedAlbum : YXSSubordinatedAlbumModel?
	var trackIntro : String?
	var trackTags : String?
	var trackTitle : String?
	var updatedAt : Int?
	var vipFirstStatus : Int?


	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		announcer <- map["announcer"]
		canDownload <- map["can_download"]
		categoryId <- map["category_id"]
		commentCount <- map["comment_count"]
		containVideo <- map["contain_video"]
		coverUrlLarge <- map["cover_url_large"]
		coverUrlMiddle <- map["cover_url_middle"]
		coverUrlSmall <- map["cover_url_small"]
		createdAt <- map["created_at"]
		downloadCount <- map["download_count"]
		downloadSize <- map["download_size"]
		downloadUrl <- map["download_url"]
		duration <- map["duration"]
		favoriteCount <- map["favorite_count"]
		id <- map["id"]
		kind <- map["kind"]
		orderNum <- map["order_num"]
		playCount <- map["play_count"]
		playSize24M4a <- map["play_size_24_m4a"]
		playSize32 <- map["play_size_32"]
		playSize64 <- map["play_size_64"]
		playSize64M4a <- map["play_size_64_m4a"]
		playSizeAmr <- map["play_size_amr"]
		playUrl24M4a <- map["play_url_24_m4a"]
		playUrl32 <- map["play_url_32"]
		playUrl64 <- map["play_url_64"]
		playUrl64M4a <- map["play_url_64_m4a"]
		playUrlAmr <- map["play_url_amr"]
		source <- map["source"]
		subordinatedAlbum <- map["subordinated_album"]
		trackIntro <- map["track_intro"]
		trackTags <- map["track_tags"]
		trackTitle <- map["track_title"]
		updatedAt <- map["updated_at"]
		vipFirstStatus <- map["vip_first_status"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         announcer = aDecoder.decodeObject(forKey: "announcer") as? YXSAnnouncer
         canDownload = aDecoder.decodeObject(forKey: "can_download") as? Bool
         categoryId = aDecoder.decodeObject(forKey: "category_id") as? Int
         commentCount = aDecoder.decodeObject(forKey: "comment_count") as? Int
         containVideo = aDecoder.decodeObject(forKey: "contain_video") as? Bool
         coverUrlLarge = aDecoder.decodeObject(forKey: "cover_url_large") as? String
         coverUrlMiddle = aDecoder.decodeObject(forKey: "cover_url_middle") as? String
         coverUrlSmall = aDecoder.decodeObject(forKey: "cover_url_small") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         downloadCount = aDecoder.decodeObject(forKey: "download_count") as? Int
         downloadSize = aDecoder.decodeObject(forKey: "download_size") as? Int
         downloadUrl = aDecoder.decodeObject(forKey: "download_url") as? String
         duration = aDecoder.decodeObject(forKey: "duration") as? Int
         favoriteCount = aDecoder.decodeObject(forKey: "favorite_count") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         kind = aDecoder.decodeObject(forKey: "kind") as? String
         orderNum = aDecoder.decodeObject(forKey: "order_num") as? Int
         playCount = aDecoder.decodeObject(forKey: "play_count") as? Int
         playSize24M4a = aDecoder.decodeObject(forKey: "play_size_24_m4a") as? Int
         playSize32 = aDecoder.decodeObject(forKey: "play_size_32") as? Int
         playSize64 = aDecoder.decodeObject(forKey: "play_size_64") as? Int
         playSize64M4a = aDecoder.decodeObject(forKey: "play_size_64_m4a") as? Int
         playSizeAmr = aDecoder.decodeObject(forKey: "play_size_amr") as? Int
         playUrl24M4a = aDecoder.decodeObject(forKey: "play_url_24_m4a") as? String
         playUrl32 = aDecoder.decodeObject(forKey: "play_url_32") as? String
         playUrl64 = aDecoder.decodeObject(forKey: "play_url_64") as? String
         playUrl64M4a = aDecoder.decodeObject(forKey: "play_url_64_m4a") as? String
         playUrlAmr = aDecoder.decodeObject(forKey: "play_url_amr") as? String
         source = aDecoder.decodeObject(forKey: "source") as? Int
         subordinatedAlbum = aDecoder.decodeObject(forKey: "subordinated_album") as? YXSSubordinatedAlbumModel
         trackIntro = aDecoder.decodeObject(forKey: "track_intro") as? String
         trackTags = aDecoder.decodeObject(forKey: "track_tags") as? String
         trackTitle = aDecoder.decodeObject(forKey: "track_title") as? String
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Int
         vipFirstStatus = aDecoder.decodeObject(forKey: "vip_first_status") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if announcer != nil{
			aCoder.encode(announcer, forKey: "announcer")
		}
		if canDownload != nil{
			aCoder.encode(canDownload, forKey: "can_download")
		}
		if categoryId != nil{
			aCoder.encode(categoryId, forKey: "category_id")
		}
		if commentCount != nil{
			aCoder.encode(commentCount, forKey: "comment_count")
		}
		if containVideo != nil{
			aCoder.encode(containVideo, forKey: "contain_video")
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
		if downloadCount != nil{
			aCoder.encode(downloadCount, forKey: "download_count")
		}
		if downloadSize != nil{
			aCoder.encode(downloadSize, forKey: "download_size")
		}
		if downloadUrl != nil{
			aCoder.encode(downloadUrl, forKey: "download_url")
		}
		if duration != nil{
			aCoder.encode(duration, forKey: "duration")
		}
		if favoriteCount != nil{
			aCoder.encode(favoriteCount, forKey: "favorite_count")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if kind != nil{
			aCoder.encode(kind, forKey: "kind")
		}
		if orderNum != nil{
			aCoder.encode(orderNum, forKey: "order_num")
		}
		if playCount != nil{
			aCoder.encode(playCount, forKey: "play_count")
		}
		if playSize24M4a != nil{
			aCoder.encode(playSize24M4a, forKey: "play_size_24_m4a")
		}
		if playSize32 != nil{
			aCoder.encode(playSize32, forKey: "play_size_32")
		}
		if playSize64 != nil{
			aCoder.encode(playSize64, forKey: "play_size_64")
		}
		if playSize64M4a != nil{
			aCoder.encode(playSize64M4a, forKey: "play_size_64_m4a")
		}
		if playSizeAmr != nil{
			aCoder.encode(playSizeAmr, forKey: "play_size_amr")
		}
		if playUrl24M4a != nil{
			aCoder.encode(playUrl24M4a, forKey: "play_url_24_m4a")
		}
		if playUrl32 != nil{
			aCoder.encode(playUrl32, forKey: "play_url_32")
		}
		if playUrl64 != nil{
			aCoder.encode(playUrl64, forKey: "play_url_64")
		}
		if playUrl64M4a != nil{
			aCoder.encode(playUrl64M4a, forKey: "play_url_64_m4a")
		}
		if playUrlAmr != nil{
			aCoder.encode(playUrlAmr, forKey: "play_url_amr")
		}
		if source != nil{
			aCoder.encode(source, forKey: "source")
		}
		if subordinatedAlbum != nil{
			aCoder.encode(subordinatedAlbum, forKey: "subordinated_album")
		}
		if trackIntro != nil{
			aCoder.encode(trackIntro, forKey: "track_intro")
		}
		if trackTags != nil{
			aCoder.encode(trackTags, forKey: "track_tags")
		}
		if trackTitle != nil{
			aCoder.encode(trackTitle, forKey: "track_title")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if vipFirstStatus != nil{
			aCoder.encode(vipFirstStatus, forKey: "vip_first_status")
		}

	}

}
