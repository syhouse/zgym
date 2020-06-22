//
//  YXSPlayerMediaSingleTool.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/27.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit

///喜马拉雅播放器功能 抽出 方便统一控制 和后期如果替换播放器
@objc class YXSXMPlayerGlobalControlTool: NSObject{
    @objc static let share: YXSXMPlayerGlobalControlTool = YXSXMPlayerGlobalControlTool()
    
    ///被强制停止(播放音频、播放视频 、 录音、、录视频、展示选择资源)
    var isPlayerBeForcedStop: Bool = false
    
    var playerDelegate: YXSMusicPlayerManagerDelegate?{
        didSet{
            YXSMusicPlayerManager.shareManager.delegate = playerDelegate
        }
    }
    
    ///当前播放专辑
    var currentTrack: XMTrack?{
        get{
            return YXSMusicPlayerManager.shareManager.getCurruntTrack()
        }
    }
    ///当前播放列表
    var playList:[XMTrack]{
        get{
            return YXSMusicPlayerManager.shareManager.getTrackList()
        }
    }
    ///当前播放模式
    var avPlayMode: YXSPlayerListModel{
        get{
            return YXSMusicPlayerManager.shareManager.playListModel
            
        }
    }
    
    private override init(){}
    
    ///控制暂停播放
    @objc public func pauseCompetitionPlayer(){
        changePlayerStatus(play: false)
    }
    
    ///控制开始播放
    @objc public func resumeCompetitionPlayer(){
        changePlayerStatus(play: true)
        
    }
    
    /// XM播放器是否停止
    public func isPlayerStop() -> Bool{
        return YXSMusicPlayerManager.shareManager.avPlayer.playerStatus == .stop
    }
    
    /// XM播放器是否暂停
    public func isPlayerIsPaused() -> Bool{
        return YXSMusicPlayerManager.shareManager.avPlayer.playerStatus == .paused
        
    }
    
    /// XM播放器是否正在播放
    public func isPlayerPlaying() -> Bool{
        return YXSMusicPlayerManager.shareManager.avPlayer.playerStatus == .playing
    }
    ///XM播放器停止播放
    public func stopXMPlay(){
        YXSMusicPlayerManager.shareManager.stopPlayer()
        
    }
    ///XM播放器暂停播放
    public func pauseXMPlay(){
        YXSMusicPlayerManager.shareManager.avPlayer.pausePlayer()
    }
    ///XM播放器恢复播放
    public func resumeXMPlay(){
         YXSMusicPlayerManager.shareManager.avPlayer.resumePlayer()
    }
    ///XM播放器播放下一首
    public func playXMNext(){
        YXSMusicPlayerManager.shareManager.playNext()
    }
    ///XM播放器播放上一首
    public func playXMPrev(){
        YXSMusicPlayerManager.shareManager.playPrev()
    }
    ///XM播放器播放到进度
    public func playXMSeek(second: CGFloat){
        YXSMusicPlayerManager.shareManager.avPlayer.playSeek(second: second)
    }

    
    ///播放器设置播放模式
    public func setAVPlayModel(_ listModel: YXSPlayerListModel){
         YXSMusicPlayerManager.shareManager.playListModel = listModel
    }
    
    ///启动喜马拉雅播放
    public func playXMPlay(track: XMTrack?, trackList: [Any]){
        YXSMusicPlayerManager.shareManager.play(track: track, playlist: trackList as? [XMTrack] ?? [XMTrack]())
    }
    
    private func changePlayerStatus(play: Bool){
        DispatchQueue.main.async {
            if play{
                if self.isPlayerBeForcedStop{
                    self.resumeXMPlay()
                    self.isPlayerBeForcedStop = false
                }
            }else{
                
                if self.isPlayerPlaying(){
                    self.pauseXMPlay()
                    self.isPlayerBeForcedStop = true
                }
            }
        }
    }
    
}
