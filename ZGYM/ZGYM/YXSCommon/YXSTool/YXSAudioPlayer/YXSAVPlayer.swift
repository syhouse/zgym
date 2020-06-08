//
//  YXSAVPlayer.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/8.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation

enum YXSPlayerStatus: Int{
    case playing
    case paused
    case stop
    case unKonwer
}

protocol YXSAVPlayerDelegate {
    func avPlayNotifyProcess(_ percent: CGFloat, currentSecond: UInt)
    
    func avPlayerWillPlaying()
    
    func avPlayerDidPlaylistEnd()
    
    func avPlayerDidPlaying()
    
    func avPlayerDidPaused()
    
    func avPlayerDidStart()
}


class YXSAVPlayer: NSObject{
    static var share: YXSAVPlayer = YXSAVPlayer()
    private override init() {
    }
    
    var curruntTrack: XMTrack?
    var trackList: [XMTrack] = [XMTrack]()
    var playerStatus: YXSPlayerStatus = .stop
    var isAutoNexTrack: Bool = false
    
    var timeObser: Any?
    
    var avPlayerDelegate: YXSAVPlayerDelegate?
    
    var playListModel: XMSDKTrackPlayMode = .XMTrackPlayerModeList
    
    private var player: AVPlayer?
    
    private var seekTime: Int?
//    XMSDKPlayer.shared()?.setPlayMode(.track)
//    XMSDKPlayer.shared()?.setTrackPlayMode(.XMTrackModeCycle)
//    XMSDKPlayer.shared()?.play(with: track, playlist: trackList)
//    XMSDKPlayer.shared()?.setAutoNexTrack(true)
//    isPlayerStatusIsStop = false
    
    func play(track: XMTrack?, playlist: [XMTrack]){
        self.curruntTrack = track
        self.trackList = playlist
        
        self.play(playerUrl: track?.downloadUrl ?? "")
    }
    
    public func stopPlayer(){
        cleanTimeObser()
        self.player?.pause()
        self.player = nil
        playerStatus = .stop
        curruntTrack = nil
        trackList.removeAll()
    }
    
    public func pausePlayer(){
        self.player?.pause()
        playerStatus = .paused
        
        avPlayerDelegate?.avPlayerDidPaused()
    }

    public func resumePlayer(){
        self.player?.play()
        playerStatus = .playing
        avPlayerDelegate?.avPlayerDidPlaying()
    }

    public func playNext(){
        if let track = getNextTrack(){
            play(track: track, playlist: trackList)
        }
        
    }
    
    public func playPrev(){
        if let track = getPrevTrack(){
            play(track: track, playlist: trackList)
        }
        
    }
    
    public func playSeek(second: CGFloat){
        seekTime = Int(second)
        self.player?.seek(to: CMTime(seconds: Double(seekTime ?? 0), preferredTimescale: CMTimeScale(1.0)))
    }

    ///XM播放器设置播放模式
    public func setPlayModel(_ playModel: XMSDKTrackPlayMode){
        self.playListModel = playModel
    }
    
    private func play(playerUrl: String){
        if let url = URL.init(string: playerUrl){
            let asset = AVURLAsset.init(url: url)
            let item = AVPlayerItem(asset: asset)
            
            cleanTimeObser()
            self.player?.pause()
            self.player = nil
            
            
            self.player = AVPlayer.init(playerItem: item)
            
            self.avPlayerDelegate?.avPlayerWillPlaying()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoPlayEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        
        setTimeObser()
    }
    
    @objc func videoPlayEnd(){
        if playListModel == .XMTrackPlayerModeList && getCurruntIndex() == trackList.count - 1{
            self.avPlayerDelegate?.avPlayerDidPlaylistEnd()
        }
    }
    
    // MARK: - tool
    
    private func getCurruntIndex() -> Int?{
           if let curruntTrack = curruntTrack{
               let index = trackList.firstIndex { (track) -> Bool in
                   track.trackId == curruntTrack.trackId
               }
               return index
           }
           return nil
       }
       
       private func getNextTrack() -> XMTrack?{
           if let index = getCurruntIndex(){
               if trackList.count != 0{
                   if index == trackList.count - 1{
                       return trackList.first
                   }else{
                       return trackList[index + 1]
                   }
               }
           }
           return nil
       }
       
       private func getPrevTrack() -> XMTrack?{
           if let index = getCurruntIndex(){
               if trackList.count != 0{
                   if index == 0{
                       return trackList.last
                   }else{
                       return trackList[index - 1]
                   }
               }
           }
           return nil
       }
    

    
    private func cleanTimeObser(){
        if let timeObser = timeObser{
            self.player?.removeTimeObserver(timeObser)
        }
        timeObser = nil
    }
    
    private func setTimeObser(){
        timeObser = self.player?.addPeriodicTimeObserver(forInterval: CMTime(value: CMTimeValue(1.0), timescale: CMTimeScale(1.0)), queue: DispatchQueue.main, using: { [weak self](time) in
            guard let strongSelf = self else { return }
            let currunt: Int = Int(CMTimeGetSeconds(time))
            if let seekTime = strongSelf.seekTime{//跳转丢弃时间
                if seekTime != currunt || seekTime != currunt + 1 || seekTime != currunt - 1{
                    return
                }
            }
            
            strongSelf.avPlayerDelegate?.avPlayNotifyProcess(CGFloat(currunt)/CGFloat(strongSelf.curruntTrack?.duration ?? 1), currentSecond: UInt(currunt))
            strongSelf.seekTime = nil
        })
    }
    

    
    // MARK: - observe
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status"{
//
            if let currentItem = self.player?.currentItem{
                switch currentItem.status{
                case .readyToPlay:
                    let totalDuration = CMTimeGetSeconds(currentItem.duration)
                    if !totalDuration.isNaN{
                        curruntTrack?.duration = Int(totalDuration)
                    }
                    self.player?.play()
                    self.avPlayerDelegate?.avPlayerDidStart()
                    self.avPlayerDelegate?.avPlayerDidPlaying()
                    
                case .failed:
                    
                    SLLog("资源加载失败")
                case .unknown:
                    SLLog("未知错误")
                }
            }
            
        }else if keyPath == "loadedTimeRanges"{
            
        }else if keyPath == "playbackBufferEmpty"{
            SLLog("playbackBufferEmpty")
        }else if keyPath == "playbackLikelyToKeepUp"{
            SLLog("playbackLikelyToKeepUp")
        }
    }
}
