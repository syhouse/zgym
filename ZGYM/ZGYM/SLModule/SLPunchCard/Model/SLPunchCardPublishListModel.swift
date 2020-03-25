//
//  PunchCardPublishListModel.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/18.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import Foundation
import ObjectMapper


class PunchCardPublishListModel : NSObject, NSCoding, Mappable{
    
    var audioDuration : Int?
    var audioUrl : String?
    var avatar : String?
    var bgUrl : String?
    var childrenId : Int?
    var clockInCommitId : Int?
    var clockInId : Int?
    var content : String?
    var createTime : String?
    var custodianId : Int?
    var imageUrl : String?
    var realName : String?
    var studentId : String?
    var videoUrl : String?
    var relationship: String?
    
    var isShowAll: Bool = false
    
    var hasVoice : Bool{
        get{
            return (audioUrl ?? "").count > 0
        }
    }
    
    var isVideo: Bool{
        get{
            return (videoUrl ?? "").count > 0
        }
    }
    
    var medias: [SLFriendsMediaModel]{
        get{
            if isVideo{
                return [SLFriendsMediaModel.init(url: videoUrl, type: .serviceVedio)]
            }else if (imageUrl ?? "").count > 0{
                var medias = [SLFriendsMediaModel]()
                let imgs = imageUrl!.components(separatedBy: ",")
                for img in imgs{
                    medias.append(SLFriendsMediaModel.init(url: img, type: .serviceImg))
                }
                return medias
            }
            return [SLFriendsMediaModel]()
        }
    }
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        audioDuration <- map["audioDuration"]
        audioUrl <- map["audioUrl"]
        avatar <- map["avatar"]
        bgUrl <- map["bgUrl"]
        childrenId <- map["childrenId"]
        clockInCommitId <- map["clockInCommitId"]
        clockInId <- map["clockInId"]
        content <- map["content"]
        createTime <- map["createTime"]
        custodianId <- map["custodianId"]
        imageUrl <- map["imageUrl"]
        realName <- map["realName"]
        studentId <- map["studentId"]
        videoUrl <- map["videoUrl"]
        relationship <- map["relationship"]
    }
    
    
    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         audioDuration = aDecoder.decodeObject(forKey: "audioDuration") as? Int
         audioUrl = aDecoder.decodeObject(forKey: "audioUrl") as? String
         avatar = aDecoder.decodeObject(forKey: "avatar") as? String
         bgUrl = aDecoder.decodeObject(forKey: "bgUrl") as? String
         childrenId = aDecoder.decodeObject(forKey: "childrenId") as? Int
         clockInCommitId = aDecoder.decodeObject(forKey: "clockInCommitId") as? Int
         clockInId = aDecoder.decodeObject(forKey: "clockInId") as? Int
         content = aDecoder.decodeObject(forKey: "content") as? String
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         custodianId = aDecoder.decodeObject(forKey: "custodianId") as? Int
         imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? String
         realName = aDecoder.decodeObject(forKey: "realName") as? String
         relationship = aDecoder.decodeObject(forKey: "relationship") as? String
         studentId = aDecoder.decodeObject(forKey: "studentId") as? String
         videoUrl = aDecoder.decodeObject(forKey: "videoUrl") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if audioDuration != nil{
            aCoder.encode(audioDuration, forKey: "audioDuration")
        }
        if audioUrl != nil{
            aCoder.encode(audioUrl, forKey: "audioUrl")
        }
        if avatar != nil{
            aCoder.encode(avatar, forKey: "avatar")
        }
        if bgUrl != nil{
            aCoder.encode(bgUrl, forKey: "bgUrl")
        }
        if childrenId != nil{
            aCoder.encode(childrenId, forKey: "childrenId")
        }
        if clockInCommitId != nil{
            aCoder.encode(clockInCommitId, forKey: "clockInCommitId")
        }
        if clockInId != nil{
            aCoder.encode(clockInId, forKey: "clockInId")
        }
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if custodianId != nil{
            aCoder.encode(custodianId, forKey: "custodianId")
        }
        if imageUrl != nil{
            aCoder.encode(imageUrl, forKey: "imageUrl")
        }
        if realName != nil{
            aCoder.encode(realName, forKey: "realName")
        }
        if relationship != nil{
            aCoder.encode(relationship, forKey: "relationship")
        }
        if studentId != nil{
            aCoder.encode(studentId, forKey: "studentId")
        }
        if videoUrl != nil{
            aCoder.encode(videoUrl, forKey: "videoUrl")
        }

    }
}
