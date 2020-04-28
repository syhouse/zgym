//
//  YXSPlayerMediaSingleTool.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/27.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit

@objc class YXSPlayerMediaSingleControlTool: NSObject {
    @objc static let share: YXSPlayerMediaSingleControlTool = YXSPlayerMediaSingleControlTool()
    
    
    ///被强制停止(播放音频、播放视频 、 录音、、录视频、展示选择资源)
    var isPlayerBeForcedStop: Bool = false
    private override init(){
        
    }
    
    ///控制暂停播放
    @objc public func pausePlayer(){
        changePlayerStatus(play: false)
    }
    
    ///控制开始播放
    @objc public func resumePlayer(){
        changePlayerStatus(play: true)
    }
    
    
    
    private func changePlayerStatus(play: Bool){
        DispatchQueue.main.async {
            if play{
                if self.isPlayerBeForcedStop{
                    XMSDKPlayer.shared()?.resumeTrackPlay()
                    
                    /// 有时候调用 resumeTrackPlay 无效  why?
                    XMSDKPlayer.shared()?.pauseTrackPlay()
                    XMSDKPlayer.shared()?.resumeTrackPlay()
                    self.isPlayerBeForcedStop = false
                }
            }else{
                
                if XMSDKPlayer.shared()?.isPlaying() ?? false{
                    XMSDKPlayer.shared()?.pauseTrackPlay()
                    self.isPlayerBeForcedStop = true
                }
            }
        }
        
    }

}
