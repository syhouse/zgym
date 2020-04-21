//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class YXSColumnContentModel : NSObject, NSCoding, Mappable{

	var albumIntro : String?
	var albumRichIntro : String?
	var albumTags : String?
	var albumTitle : String?
	var announcer : YXSAnnouncer?
	var buyNotes : String?
	var canDownload : Bool?
	var categoryId : Int?
	var channelPlayCount : Int?
	var composedPriceType : Int?
	var coverUrl : String?
	var coverUrlLarge : String?
	var coverUrlMiddle : String?
	var coverUrlSmall : String?
	var createdAt : Int?
	var detailBannerUrl : String?
	var estimatedTrackCount : Int?
	var expectedRevenue : String?
	var favoriteCount : Int?
	var freeTrackCount : Int?
	var freeTrackIds : String?
	var hasSample : Bool?
	var id : Int?
	var includeTrackCount : Int?
	var isFinished : Int?
	var isFreeListen : Bool?
	var isPaid : Bool?
	var isVipExclusive : Bool?
	var isVipfree : Bool?
	var kind : String?
	var lastUptrack : YXSLastUptrackModel?
	var meta : String?
	var playCount : Int?
	var recommendReason : String?
	var saleIntro : String?
	var sellingPoint : String?
	var shareCount : Int?
	var shortIntro : String?
	var shortRichIntro : String?
	var speakerContent : String?
	var speakerIntro : String?
	var speakerTitle : String?
	var subscribeCount : Int?
	var tracksNaturalOrdered : Bool?
	var updatedAt : Int?
	var wrapCoverUrl : String?
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		albumIntro <- map["album_intro"]
		albumRichIntro <- map["album_rich_intro"]
		albumTags <- map["album_tags"]
		albumTitle <- map["album_title"]
		announcer <- map["announcer"]
		buyNotes <- map["buy_notes"]
		canDownload <- map["can_download"]
		categoryId <- map["category_id"]
		channelPlayCount <- map["channel_play_count"]
		composedPriceType <- map["composed_price_type"]
		coverUrl <- map["cover_url"]
		coverUrlLarge <- map["cover_url_large"]
		coverUrlMiddle <- map["cover_url_middle"]
		coverUrlSmall <- map["cover_url_small"]
		createdAt <- map["created_at"]
		detailBannerUrl <- map["detail_banner_url"]
		estimatedTrackCount <- map["estimated_track_count"]
		expectedRevenue <- map["expected_revenue"]
		favoriteCount <- map["favorite_count"]
		freeTrackCount <- map["free_track_count"]
		freeTrackIds <- map["free_track_ids"]
		hasSample <- map["has_sample"]
		id <- map["id"]
		includeTrackCount <- map["include_track_count"]
		isFinished <- map["is_finished"]
		isFreeListen <- map["is_free_listen"]
		isPaid <- map["is_paid"]
		isVipExclusive <- map["is_vip_exclusive"]
		isVipfree <- map["is_vipfree"]
		kind <- map["kind"]
		lastUptrack <- map["last_uptrack"]
		meta <- map["meta"]
		playCount <- map["play_count"]
		recommendReason <- map["recommend_reason"]
		saleIntro <- map["sale_intro"]
		sellingPoint <- map["selling_point"]
		shareCount <- map["share_count"]
		shortIntro <- map["short_intro"]
		shortRichIntro <- map["short_rich_intro"]
		speakerContent <- map["speaker_content"]
		speakerIntro <- map["speaker_intro"]
		speakerTitle <- map["speaker_title"]
		subscribeCount <- map["subscribe_count"]
		tracksNaturalOrdered <- map["tracks_natural_ordered"]
		updatedAt <- map["updated_at"]
		wrapCoverUrl <- map["wrap_cover_url"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         albumIntro = aDecoder.decodeObject(forKey: "album_intro") as? String
         albumRichIntro = aDecoder.decodeObject(forKey: "album_rich_intro") as? String
         albumTags = aDecoder.decodeObject(forKey: "album_tags") as? String
         albumTitle = aDecoder.decodeObject(forKey: "album_title") as? String
         announcer = aDecoder.decodeObject(forKey: "announcer") as? YXSAnnouncer
         buyNotes = aDecoder.decodeObject(forKey: "buy_notes") as? String
         canDownload = aDecoder.decodeObject(forKey: "can_download") as? Bool
         categoryId = aDecoder.decodeObject(forKey: "category_id") as? Int
         channelPlayCount = aDecoder.decodeObject(forKey: "channel_play_count") as? Int
         composedPriceType = aDecoder.decodeObject(forKey: "composed_price_type") as? Int
         coverUrl = aDecoder.decodeObject(forKey: "cover_url") as? String
         coverUrlLarge = aDecoder.decodeObject(forKey: "cover_url_large") as? String
         coverUrlMiddle = aDecoder.decodeObject(forKey: "cover_url_middle") as? String
         coverUrlSmall = aDecoder.decodeObject(forKey: "cover_url_small") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         detailBannerUrl = aDecoder.decodeObject(forKey: "detail_banner_url") as? String
         estimatedTrackCount = aDecoder.decodeObject(forKey: "estimated_track_count") as? Int
         expectedRevenue = aDecoder.decodeObject(forKey: "expected_revenue") as? String
         favoriteCount = aDecoder.decodeObject(forKey: "favorite_count") as? Int
         freeTrackCount = aDecoder.decodeObject(forKey: "free_track_count") as? Int
         freeTrackIds = aDecoder.decodeObject(forKey: "free_track_ids") as? String
         hasSample = aDecoder.decodeObject(forKey: "has_sample") as? Bool
         id = aDecoder.decodeObject(forKey: "id") as? Int
         includeTrackCount = aDecoder.decodeObject(forKey: "include_track_count") as? Int
         isFinished = aDecoder.decodeObject(forKey: "is_finished") as? Int
         isFreeListen = aDecoder.decodeObject(forKey: "is_free_listen") as? Bool
         isPaid = aDecoder.decodeObject(forKey: "is_paid") as? Bool
         isVipExclusive = aDecoder.decodeObject(forKey: "is_vip_exclusive") as? Bool
         isVipfree = aDecoder.decodeObject(forKey: "is_vipfree") as? Bool
         kind = aDecoder.decodeObject(forKey: "kind") as? String
         lastUptrack = aDecoder.decodeObject(forKey: "last_uptrack") as? YXSLastUptrackModel
         meta = aDecoder.decodeObject(forKey: "meta") as? String
         playCount = aDecoder.decodeObject(forKey: "play_count") as? Int
         recommendReason = aDecoder.decodeObject(forKey: "recommend_reason") as? String
         saleIntro = aDecoder.decodeObject(forKey: "sale_intro") as? String
         sellingPoint = aDecoder.decodeObject(forKey: "selling_point") as? String
         shareCount = aDecoder.decodeObject(forKey: "share_count") as? Int
         shortIntro = aDecoder.decodeObject(forKey: "short_intro") as? String
         shortRichIntro = aDecoder.decodeObject(forKey: "short_rich_intro") as? String
         speakerContent = aDecoder.decodeObject(forKey: "speaker_content") as? String
         speakerIntro = aDecoder.decodeObject(forKey: "speaker_intro") as? String
         speakerTitle = aDecoder.decodeObject(forKey: "speaker_title") as? String
         subscribeCount = aDecoder.decodeObject(forKey: "subscribe_count") as? Int
         tracksNaturalOrdered = aDecoder.decodeObject(forKey: "tracks_natural_ordered") as? Bool
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Int
         wrapCoverUrl = aDecoder.decodeObject(forKey: "wrap_cover_url") as? String

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
		if albumRichIntro != nil{
			aCoder.encode(albumRichIntro, forKey: "album_rich_intro")
		}
		if albumTags != nil{
			aCoder.encode(albumTags, forKey: "album_tags")
		}
		if albumTitle != nil{
			aCoder.encode(albumTitle, forKey: "album_title")
		}
		if announcer != nil{
			aCoder.encode(announcer, forKey: "announcer")
		}
		if buyNotes != nil{
			aCoder.encode(buyNotes, forKey: "buy_notes")
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
		if composedPriceType != nil{
			aCoder.encode(composedPriceType, forKey: "composed_price_type")
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
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if detailBannerUrl != nil{
			aCoder.encode(detailBannerUrl, forKey: "detail_banner_url")
		}
		if estimatedTrackCount != nil{
			aCoder.encode(estimatedTrackCount, forKey: "estimated_track_count")
		}
		if expectedRevenue != nil{
			aCoder.encode(expectedRevenue, forKey: "expected_revenue")
		}
		if favoriteCount != nil{
			aCoder.encode(favoriteCount, forKey: "favorite_count")
		}
		if freeTrackCount != nil{
			aCoder.encode(freeTrackCount, forKey: "free_track_count")
		}
		if freeTrackIds != nil{
			aCoder.encode(freeTrackIds, forKey: "free_track_ids")
		}
		if hasSample != nil{
			aCoder.encode(hasSample, forKey: "has_sample")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if includeTrackCount != nil{
			aCoder.encode(includeTrackCount, forKey: "include_track_count")
		}
		if isFinished != nil{
			aCoder.encode(isFinished, forKey: "is_finished")
		}
		if isFreeListen != nil{
			aCoder.encode(isFreeListen, forKey: "is_free_listen")
		}
		if isPaid != nil{
			aCoder.encode(isPaid, forKey: "is_paid")
		}
		if isVipExclusive != nil{
			aCoder.encode(isVipExclusive, forKey: "is_vip_exclusive")
		}
		if isVipfree != nil{
			aCoder.encode(isVipfree, forKey: "is_vipfree")
		}
		if kind != nil{
			aCoder.encode(kind, forKey: "kind")
		}
		if lastUptrack != nil{
			aCoder.encode(lastUptrack, forKey: "last_uptrack")
		}
		if meta != nil{
			aCoder.encode(meta, forKey: "meta")
		}
		if playCount != nil{
			aCoder.encode(playCount, forKey: "play_count")
		}
		if recommendReason != nil{
			aCoder.encode(recommendReason, forKey: "recommend_reason")
		}
		if saleIntro != nil{
			aCoder.encode(saleIntro, forKey: "sale_intro")
		}
		if sellingPoint != nil{
			aCoder.encode(sellingPoint, forKey: "selling_point")
		}
		if shareCount != nil{
			aCoder.encode(shareCount, forKey: "share_count")
		}
		if shortIntro != nil{
			aCoder.encode(shortIntro, forKey: "short_intro")
		}
		if shortRichIntro != nil{
			aCoder.encode(shortRichIntro, forKey: "short_rich_intro")
		}
		if speakerContent != nil{
			aCoder.encode(speakerContent, forKey: "speaker_content")
		}
		if speakerIntro != nil{
			aCoder.encode(speakerIntro, forKey: "speaker_intro")
		}
		if speakerTitle != nil{
			aCoder.encode(speakerTitle, forKey: "speaker_title")
		}
		if subscribeCount != nil{
			aCoder.encode(subscribeCount, forKey: "subscribe_count")
		}
		if tracksNaturalOrdered != nil{
			aCoder.encode(tracksNaturalOrdered, forKey: "tracks_natural_ordered")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if wrapCoverUrl != nil{
			aCoder.encode(wrapCoverUrl, forKey: "wrap_cover_url")
		}

	}

}
