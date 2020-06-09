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

enum YXSPlayerListModel: Int{
    case modelList
    case modelSingle
    case modelRandow
    case modelCycle
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
    
    private var curruntTrack: XMTrack?
    private var trackList: [XMTrack] = [XMTrack]()
    public var playerStatus: YXSPlayerStatus = .stop
    public var playListModel: YXSPlayerListModel = .modelCycle
    public var avPlayerDelegate: YXSAVPlayerDelegate?
    
    
    private var isAutoNexTrack: Bool = false
    
    private var timeObser: Any?
    
    private var player: AVPlayer?
    
    private var seekTime: Int?
    ///进度前进
    private var isseekforword: Bool = false
    ///当前播放时间
    private var curruntTime: Int?
    
    // MARK: - setter func
    
    public func setAutoNex(_ isAutoNext: Bool){
        self.isAutoNexTrack = isAutoNext
    }
    
    // MARK: - getter func
    public func getCurruntTrack() -> XMTrack?{
        return curruntTrack
    }
    
    public func getTrackList() -> [XMTrack]{
        return trackList
    }
    
    // MARK: - player Control
    public func play(track: XMTrack?, playlist: [XMTrack]){
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
        curruntTime = nil
        seekTime = nil
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
        isseekforword = seekTime ?? 0 > curruntTime ?? 0
        self.player?.seek(to: CMTime(seconds: Double(seekTime ?? 0), preferredTimescale: CMTimeScale(1.0)))
    }
    
    private func play(playerUrl: String){
        if let url = URL.init(string: playerUrl){
            let asset = AVURLAsset.init(url: url)
            let item = AVPlayerItem(asset: asset)
            
            cleanTimeObser()
            self.player?.pause()
            self.player = nil
            
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(.playAndRecord)
            } catch {
                
            }
            try? session.setActive(true)
            
            self.player = AVPlayer.init(playerItem: item)
            
            self.avPlayerDelegate?.avPlayerWillPlaying()
        }else{
            MBProgressHUD.yxs_showLoading(message: "播放地址错误")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoPlayEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterreption), name: AVAudioSession.interruptionNotification, object: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        
        setTimeObser()
    }
    
    // MARK: - NotificationCenter
    @objc func videoPlayEnd(notification: Notification){
        if self.playerStatus == .playing{
            switch playListModel {
            case .modelList:
                if getCurruntIndex() == trackList.count - 1{
                    self.avPlayerDelegate?.avPlayerDidPlaylistEnd()
                }else{
                    playNext()
                }
            case .modelSingle:
                play(playerUrl: curruntTrack?.downloadUrl ?? "")
            case .modelCycle, .modelRandow:
                playNext()
            }
        }
    }
    
    @objc func handleInterreption(notification: Notification){
        guard let userInfo = notification.userInfo,
            let interruptionTypeRawValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeRawValue) else {
                return
        }
        
        switch interruptionType {
        case .began:
            print("interruption began")
            self.pausePlayer()
        case .ended:
            print("interruption ended")
            break
            
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
        return getNewTrack(isNext: true)
    }
    
    private func getPrevTrack() -> XMTrack?{
        return getNewTrack(isNext: false)
    }
    
    ///将要播放的音频
    private func getNewTrack(isNext: Bool) ->XMTrack?{
        if let index = getCurruntIndex(){
            if trackList.count != 0{
                switch playListModel {
                case .modelSingle, .modelCycle, .modelList:
                    if isNext{
                        if index == trackList.count - 1{
                            return trackList.first
                        }else{
                            return trackList[index + 1]
                        }
                    }else{
                        if index == 0{
                            return trackList.last
                        }else{
                            return trackList[index - 1]
                        }
                    }
                case .modelRandow:
                    if trackList.count == 1{
                        return curruntTrack
                    }else{
                        var newIndex = index
                        while newIndex == index{
                            newIndex = Int(arc4random() % UInt32(trackList.count - 1))
                        }
                        return trackList[newIndex]
                    }
                    
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
                if strongSelf.isseekforword{
                    if currunt < seekTime{
                        return
                    }
                }else{
                    if currunt > seekTime + 1{
                        return
                    }
                }
                
            }
            strongSelf.curruntTime = currunt
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
                    self.playerStatus = .playing
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
