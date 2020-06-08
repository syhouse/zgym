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
    
    ///刚启动播放器默认停止状态
    var isPlayerStatusIsStop: Bool = true
    
    ///被强制停止(播放音频、播放视频 、 录音、、录视频、展示选择资源)
    var isPlayerBeForcedStop: Bool = false
    
    var playerDelegate: YXSXMPlayerDelegate?
    
    ///当前播放专辑
    var currentTrack: XMTrack?{
        get{
            XMSDKPlayer.shared()?.currentTrack()
        }
    }
    ///当前播放列表
    var playList:[Any]{
        get{
            XMSDKPlayer.shared()?.playList() ?? [Any]()
        }
    }
    ///当前播放模式
    var playMode: XMSDKTrackPlayMode{
        get{
            XMSDKPlayer.shared()?.getTrackPlayMode() ?? .XMTrackModeCycle
        }
    }
    
    private override init(){
        super.init()
        XMSDKPlayer.shared()?.trackPlayDelegate = self
    }
    
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
        if isPlayerStatusIsStop{
            return true
        }else{
            let isXMPlayerStop = self.isPlayerPlaying() == false && self.isPlayerIsPaused()
            if isXMPlayerStop{
                return true
            }
        }
        return false
    }
    
    /// XM播放器是否暂停
    public func isPlayerIsPaused() -> Bool{
        return XMSDKPlayer.shared()?.isPaused() ?? false
    }
    
    /// XM播放器是否正在播放
    public func isPlayerPlaying() -> Bool{
        return XMSDKPlayer.shared()?.isPlaying() ?? false
    }
    ///XM播放器停止播放
    public func stopXMPlay(){
        XMSDKPlayer.shared()?.stopTrackPlay()
        isPlayerStatusIsStop = true
    }
    ///XM播放器暂停播放
    public func pauseXMPlay(){
        XMSDKPlayer.shared()?.pauseTrackPlay()
        isPlayerStatusIsStop = false
    }
    ///XM播放器恢复播放
    public func resumeXMPlay(){
        XMSDKPlayer.shared()?.resumeTrackPlay()
        isPlayerStatusIsStop = false
    }
    ///XM播放器播放下一首
    public func playXMNext(){
        XMSDKPlayer.shared()?.playNextTrack()
        isPlayerStatusIsStop = false
    }
    ///XM播放器播放上一首
    public func playXMPrev(){
        XMSDKPlayer.shared()?.playPrevTrack()
        isPlayerStatusIsStop = false
    }
    ///XM播放器播放到进度
    public func playXMSeek(second: CGFloat){
        XMSDKPlayer.shared()?.seek(toTime: CGFloat(second))
        isPlayerStatusIsStop = false
    }
    ///XM播放器设置播放模式
    public func setXMPlayModel(_ playModel: XMSDKTrackPlayMode){
        XMSDKPlayer.shared()?.setTrackPlayMode(playMode)
    }
    
    ///启动喜马拉雅播放
    public func playXMPlay(track: XMTrack?, trackList: [Any]){
        XMSDKPlayer.shared()?.setPlayMode(.track)
        XMSDKPlayer.shared()?.setTrackPlayMode(.XMTrackModeCycle)
        XMSDKPlayer.shared()?.play(with: track, playlist: trackList)
        XMSDKPlayer.shared()?.setAutoNexTrack(true)
        isPlayerStatusIsStop = false
    }
    
    private func changePlayerStatus(play: Bool){
        DispatchQueue.main.async {
            if play{
                if self.isPlayerBeForcedStop{
                    self.resumeXMPlay()
                    
                    /// 有时候调用 resumeTrackPlay 无效  why?
                    self.pauseXMPlay()
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


extension YXSXMPlayerGlobalControlTool: XMTrackPlayerDelegate{
    // MARK: - Delegate
    func xmTrackPlayNotifyProcess(_ percent: CGFloat, currentSecond: UInt) {
        playerDelegate?.xmTrackPlayNotifyProcess(percent, currentSecond: currentSecond)
    }
    
    func xmTrackPlayerWillPlaying() {
        playerDelegate?.xmTrackPlayerWillPlaying()
    }
    
    func xmTrackPlayerDidPlaylistEnd() {
        playerDelegate?.xmTrackPlayerDidPlaylistEnd()
    }
    
    func xmTrackPlayerDidPlaying() {
        playerDelegate?.xmTrackPlayerDidPlaying()
    }
    
    func xmTrackPlayerDidPaused() {
        playerDelegate?.xmTrackPlayerDidPaused()
    }
    
    func xmTrackPlayerDidStart() {
        playerDelegate?.xmTrackPlayerDidStart()
    }
}


protocol YXSXMPlayerDelegate {
    func xmTrackPlayNotifyProcess(_ percent: CGFloat, currentSecond: UInt)
    
    func xmTrackPlayerWillPlaying()
    
    func xmTrackPlayerDidPlaylistEnd()
    
    func xmTrackPlayerDidPlaying()
    
    func xmTrackPlayerDidPaused()
    
    func xmTrackPlayerDidStart()
}
