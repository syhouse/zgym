//
//  YXSRemoteControlInfoHelper.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/22.
//  Copyright © 2020 zgym. All rights reserved.
//

class YXSRemoteControlInfoHelper: NSObject {
    static var title: String{
        return XMSDKPlayer.shared()?.currentTrack()?.trackTitle ?? ""
    }
    
    static var author: String{
        return XMSDKPlayer.shared()?.currentTrack()?.announcer.nickname ?? ""
    }
    
    static var curruntTime: UInt = 0
    
    static var totalTime: Int = XMSDKPlayer.shared()?.currentTrack()?.duration ?? 0
    
    static var imageUrl: String{
        return XMSDKPlayer.shared()?.currentTrack()?.coverUrlLarge ?? ""
    }
}
