//
//  YXSAVPlayer.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/8.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
///播放状态
enum YXSPlayerStatus: Int{
    ///播放中
    case playing
    ///暂停中
    case paused
    ///停止
    case stop
//    未知
//    case unKonwer
}

///播放回调
protocol YXSAVPlayerDelegate {
    ///播放进度 当前时间
    func avPlayNotifyProcess(_ percent: CGFloat, currentSecond: UInt)
    ///播放器将要开始播放
    func avPlayerWillPlaying()

    ///播放器正在播放
    func avPlayerDidPlaying()
    ///播放器暂停播放
    func avPlayerDidPaused()
    
    ///播放器开始播放
    func avPlayerDidStart()
    
    ///播放结束
    func avPlayerPlayEnd()
    
    ///获取到播放总时间回调
    func avPlayerGetTotalDuration(duration: Int)
    
    ///缓冲进度
    func avPlayerLoadedTimeRanges(percent: CGFloat)
}

extension YXSAVPlayerDelegate{
    func avPlayNotifyProcess(_ percent: CGFloat, currentSecond: UInt){}
    func avPlayerWillPlaying(){}
    func avPlayerDidPlaying(){}
    func avPlayerDidPaused(){}
    func avPlayerDidStart(){}
    func avPlayerPlayEnd(){}
    func avPlayerGetTotalDuration(duration: Int){}
    func avPlayerLoadedTimeRanges(percent: CGFloat){}
}

// MARK: - YXSAVPlayer
class YXSAVPlayer: NSObject{
    ///音乐播放器使用的单例
    static var musicShare: YXSAVPlayer = YXSAVPlayer()
    public var playerStatus: YXSPlayerStatus = .stop
    public var avPlayerDelegate: YXSAVPlayerDelegate?
    
    private var timeObser: Any?
    
    private var player: AVPlayer?
    ///进度跳转时间
    private var seekTime: Int?
    ///进度前进
    private var isseekforword: Bool = false
    ///当前播放时间
    private var curruntTime: Int = 0
    ///播放总时间
    private var duration: Int = 1{
        didSet{
            avPlayerDelegate?.avPlayerGetTotalDuration(duration: duration)
        }
    }
    
    private var isLocal: Bool = true
    // MARK: - setter func
    public func getCurruntTime() -> Int{
        return curruntTime
    }
    
    // MARK: - playerControl
    public func stopPlayer(){
        cleanTimeObser()
        self.player?.pause()
        self.player = nil
        playerStatus = .stop
        curruntTime = 0
        seekTime = nil
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
    
    public func playSeek(second: CGFloat){
        seekTime = Int(second)
        isseekforword = seekTime ?? 0 > curruntTime
        self.player?.seek(to: CMTime(seconds: Double(seekTime ?? 0), preferredTimescale: CMTimeScale(1.0)))
    }
    
    
    public func play(url: URL?){
        if let url = url{
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
            
            isLocal = url.isFileURL
            if isLocal{
                let totalDuration = CMTimeGetSeconds(item.duration)
                if !totalDuration.isNaN{
                    duration = Int(totalDuration)
                }
                self.player?.play()
                
                
                self.avPlayerDelegate?.avPlayerDidPlaying()
                self.avPlayerDelegate?.avPlayerDidStart()
            }
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
        avPlayerDelegate?.avPlayerPlayEnd()
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
            strongSelf.avPlayerDelegate?.avPlayNotifyProcess(CGFloat(currunt)/CGFloat(strongSelf.duration), currentSecond: UInt(currunt))
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
                        duration = Int(totalDuration)
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
            if let currentItem = self.player?.currentItem{
                let timeRanges = currentItem.loadedTimeRanges
                let timeRange = timeRanges.first?.timeRangeValue
                let totalDuration = CMTimeGetSeconds(currentItem.duration)
                if !totalDuration.isNaN{
                    duration = Int(totalDuration)
                }
                if let timeRange = timeRange{
                    let totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration)
                    avPlayerDelegate?.avPlayerLoadedTimeRanges(percent: CGFloat(totalLoadTime/Double(duration)))
                }
            }
            
        }else if keyPath == "playbackBufferEmpty"{
            SLLog("playbackBufferEmpty")
        }else if keyPath == "playbackLikelyToKeepUp"{
            SLLog("playbackLikelyToKeepUp")
        }
    }
}
