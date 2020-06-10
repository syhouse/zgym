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
    
    var playerDelegate: YXSXMPlayerDelegate?
    
    ///当前播放专辑
    var currentTrack: XMTrack?{
        get{
            return YXSAVPlayer.share.getCurruntTrack()
        }
    }
    ///当前播放列表
    var playList:[XMTrack]{
        get{
            return YXSAVPlayer.share.getTrackList()
        }
    }
    ///当前播放模式
    var avPlayMode: YXSPlayerListModel{
        get{
            return YXSAVPlayer.share.playListModel
            
        }
    }
    
    private override init(){
        super.init()
        YXSAVPlayer.share.avPlayerDelegate = self
        
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
        return YXSAVPlayer.share.playerStatus == .stop
    }
    
    /// XM播放器是否暂停
    public func isPlayerIsPaused() -> Bool{
        return YXSAVPlayer.share.playerStatus == .paused
        
    }
    
    /// XM播放器是否正在播放
    public func isPlayerPlaying() -> Bool{
        return YXSAVPlayer.share.playerStatus == .playing
    }
    ///XM播放器停止播放
    public func stopXMPlay(){
        YXSAVPlayer.share.stopPlayer()
        
    }
    ///XM播放器暂停播放
    public func pauseXMPlay(){
        YXSAVPlayer.share.pausePlayer()
    }
    ///XM播放器恢复播放
    public func resumeXMPlay(){
         YXSAVPlayer.share.resumePlayer()
    }
    ///XM播放器播放下一首
    public func playXMNext(){
        YXSAVPlayer.share.playNext()
    }
    ///XM播放器播放上一首
    public func playXMPrev(){
        YXSAVPlayer.share.playPrev()
    }
    ///XM播放器播放到进度
    public func playXMSeek(second: CGFloat){
        YXSAVPlayer.share.playSeek(second: second)
    }

    
    ///播放器设置播放模式
    public func setAVPlayModel(_ listModel: YXSPlayerListModel){
         YXSAVPlayer.share.playListModel = listModel
    }
    
    ///启动喜马拉雅播放
    public func playXMPlay(track: XMTrack?, trackList: [Any]){
        YXSAVPlayer.share.play(track: track, playlist: trackList as? [XMTrack] ?? [XMTrack]())
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

extension YXSXMPlayerGlobalControlTool: YXSAVPlayerDelegate{
    // MARK: - Delegate
    func avPlayNotifyProcess(_ percent: CGFloat, currentSecond: UInt) {
        playerDelegate?.xmTrackPlayNotifyProcess(percent, currentSecond: currentSecond)
    }
    
    func avPlayerWillPlaying() {
        playerDelegate?.xmTrackPlayerWillPlaying()
    }
    
    func avPlayerDidPlaylistEnd() {
        playerDelegate?.xmTrackPlayerDidPlaylistEnd()
    }
    
    func avPlayerDidPlaying() {
        playerDelegate?.xmTrackPlayerDidPlaying()
    }
    
    func avPlayerDidPaused() {
        playerDelegate?.xmTrackPlayerDidPaused()
    }
    
    func avPlayerDidStart() {
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
