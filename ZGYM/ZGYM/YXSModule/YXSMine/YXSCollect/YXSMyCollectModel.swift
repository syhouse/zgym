//
//  YXSMyCollectModel.swift
//  ZGYM
//
//  Created by yihao on 2020/4/14.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import ObjectMapper

class YXSMyCollectModel: NSObject, NSCoding, Mappable {
    
    // MARK: - 声音相关字段
    /// 声音名称
    var voiceTitle : String?
    
    /// 声音时长 秒
    var voiceDuration : Int?
    
    /// 声音id
    var voiceId : Int?
    
    var voiceTimeStr: String? {
        get{
            let minute: Int = (voiceDuration ?? 0)/60
            let second: Int = (voiceDuration ?? 0)%60
            var minuteStr = "\(minute)"
            if minute < 10 {
                minuteStr = "0\(minute)"
            }
            var secondStr = "\(second)"
            if second < 10 {
                secondStr = "0\(second)"
            }
            
            return minuteStr + ":" + secondStr
        }
    }
    
    // MARK: - 专辑相关字段
    /// 专辑封面路径
    var albumCover : String?
    
    /// 专辑名称
    var albumTitle : String?
    
    /// 专辑内歌曲数量
    var albumNum : Int?
    
    /// 专辑id
    var albumId : Int?
    
    private override init(){}
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        voiceTitle <- map["voiceTitle"]
        voiceDuration <- map["voiceDuration"]
        voiceId <- map["voiceId"]
        albumCover <- map["albumCover"]
        albumTitle <- map["albumTitle"]
        albumNum <- map["albumNum"]
        albumId <- map["albumId"]
    }
    
    @objc required init(coder aDecoder: NSCoder)
    {
        voiceTitle = aDecoder.decodeObject(forKey: "voiceTitle") as? String
        voiceDuration = aDecoder.decodeObject(forKey: "voiceDuration") as? Int
        voiceId = aDecoder.decodeObject(forKey: "voiceId") as? Int
        albumCover = aDecoder.decodeObject(forKey: "albumCover") as? String
        albumTitle = aDecoder.decodeObject(forKey: "albumTitle") as? String
        albumNum = aDecoder.decodeObject(forKey: "albumNum") as? Int
        albumId = aDecoder.decodeObject(forKey: "albumId") as? Int
    }
    
    @objc func encode(with aCoder: NSCoder)
    {
        if voiceTitle != nil{
            aCoder.encode(voiceTitle, forKey: "voiceTitle")
        }
        if voiceDuration != nil{
            aCoder.encode(voiceDuration, forKey: "voiceDuration")
        }
        if voiceId != nil{
            aCoder.encode(voiceId, forKey: "voiceId")
        }
        if albumCover != nil{
            aCoder.encode(albumCover, forKey: "albumCover")
        }
        if albumTitle != nil{
            aCoder.encode(albumTitle, forKey: "albumTitle")
        }
        if albumNum != nil{
            aCoder.encode(albumNum, forKey: "albumNum")
        }
        if albumId != nil{
            aCoder.encode(albumId, forKey: "albumId")
        }
    }
}
