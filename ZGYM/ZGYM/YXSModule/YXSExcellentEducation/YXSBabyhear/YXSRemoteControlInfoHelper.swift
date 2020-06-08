//
//  YXSRemoteControlInfoHelper.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/22.
//  Copyright © 2020 zgym. All rights reserved.
//

class YXSRemoteControlInfoHelper: NSObject {
    static var title: String{
        return YXSXMPlayerGlobalControlTool.share.currentTrack?.trackTitle ?? ""
    }
    
    static var author: String{
        return YXSXMPlayerGlobalControlTool.share.currentTrack?.announcer.nickname ?? ""
    }
    
    static var currentTime: UInt = 0
    
    static var totalTime: Int = YXSXMPlayerGlobalControlTool.share.currentTrack?.duration ?? 0
    
    static var imageUrl: String{
        return YXSXMPlayerGlobalControlTool.share.currentTrack?.coverUrlLarge ?? ""
    }
}
