//
//  YXSMyCollectModel.swift
//  ZGYM
//
//  Created by yihao on 2020/4/14.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import ObjectMapper

class YXSMyCollectModel: NSObject, Mappable {
    
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
}
