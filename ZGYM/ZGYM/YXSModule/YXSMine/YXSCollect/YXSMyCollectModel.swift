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
    var voiceName : String?
    
    /// 声音时长
    var voiceTime : String?
    
    /// 声音id
    var voiceId : Int?
    
    
    // MARK: - 专辑相关字段
    /// 专辑封面路径
    var albumIconUrl : String?
    
    /// 专辑名称
    var albumName : String?
    
    /// 专辑内歌曲数量
    var albumSongs : Int?
    
    /// 专辑id
    var albumId : Int?
    
    private override init(){}
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        voiceName <- map["voiceName"]
        voiceTime <- map["voiceTime"]
        voiceId <- map["voiceId"]
        albumIconUrl <- map["albumIconUrl"]
        albumName <- map["albumName"]
        albumSongs <- map["albumSongs"]
        albumId <- map["albumId"]
    }
}
