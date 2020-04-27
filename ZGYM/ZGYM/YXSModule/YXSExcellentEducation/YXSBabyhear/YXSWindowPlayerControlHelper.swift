//
//  YXSWindowPlayerControlHelper.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/27.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit

class YXSWindowPlayerControlHelper: NSObject {
    static let shareHelper: YXSWindowPlayerControlHelper = YXSWindowPlayerControlHelper()
    
    ///被强制停止
    var isPlayerBeForcedStop: Bool = false
    private override init(){
        
    }
    
    ///单独控制暂停播放
    public func pausePlayer(){
        changePlayerStatus(play: false)
    }
    
    ///单独控制开始播放
    public func playingPlayer(){
        changePlayerStatus(play: true)
    }
    
    
    
    private func changePlayerStatus(play: Bool){
        if play{
            if isPlayerBeForcedStop{
                XMSDKPlayer.shared()?.resumeTrackPlay()
                isPlayerBeForcedStop = false
            }
        }else{
            if XMSDKPlayer.shared()?.isPlaying() ?? false{
                XMSDKPlayer.shared()?.pauseTrackPlay()
                isPlayerBeForcedStop = true
            }
        }
    }

}
