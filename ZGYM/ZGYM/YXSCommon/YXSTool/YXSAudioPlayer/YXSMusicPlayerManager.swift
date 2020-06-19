//
//  YXSMusicPlayerManager.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/12.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation


///播放模式
enum YXSPlayerListModel: Int{
    ///列表
    case modelList
    ///单曲循环
    case modelSingle
    ///随机播放
    case modelRandow
    ///循环播放
    case modelCycle
}

///播放回调
protocol YXSMusicPlayerManagerDelegate {
    ///播放进度 当前时间
    func musicPlayerManagerNotifyProcess(_ percent: CGFloat, currentSecond: UInt)
    ///播放器将要开始播放
    func musicPlayerManagerWillPlaying()
    ///播放列表完成 结束播放
    func musicPlayerManagerDidPlaylistEnd()
    ///播放器正在播放
    func musicPlayerManagerDidPlaying()
    ///播放器暂停播放
    func musicPlayerManagerDidPaused()
    ///播放器缓冲完成 开始播放
    func musicPlayerManagerDidStart()
}

///音乐播放管理工具
class YXSMusicPlayerManager: NSObject{
    static var shareManager: YXSMusicPlayerManager = YXSMusicPlayerManager()
    private override init() {
        super.init()
        avPlayer.avPlayerDelegate = self
    }
    public var playListModel: YXSPlayerListModel = .modelCycle
    private var curruntTrack: XMTrack?
    private var trackList: [XMTrack] = [XMTrack]()
    public let avPlayer = YXSAVPlayer.musicShare
    ///是否自动播放下一首
    private var isAutoNexTrack: Bool = false
    
    public var delegate: YXSMusicPlayerManagerDelegate?
    
    // MARK: - getter func
    ///获取当前播放model
    public func getCurruntTrack() -> XMTrack?{
        return curruntTrack
    }
    ///获取当前播放列表
    public func getTrackList() -> [XMTrack]{
        return trackList
    }
    
    // MARK: - player Control
    public func play(track: XMTrack?, playlist: [XMTrack]){
        self.curruntTrack = track
        self.trackList = playlist
        
        avPlayer.play(url: URL.init(string: track?.downloadUrl ?? ""))
    }
    
    public func stopPlayer(){
        avPlayer.stopPlayer()
        curruntTrack = nil
        trackList.removeAll()
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
    
    // MARK: - NotificationCenter
    @objc func videoPlayEnd(){
        if avPlayer.playerStatus == .playing{
            switch playListModel {
            case .modelList:
                if getCurruntIndex() == trackList.count - 1{
                    delegate?.musicPlayerManagerDidPlaylistEnd()
                }else{
                    playNext()
                }
            case .modelSingle:
                avPlayer.play(url: URL.init(string: curruntTrack?.downloadUrl ?? ""))
            case .modelCycle, .modelRandow:
                playNext()
            }
        }
    }
    
    
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
    
    
}

extension YXSMusicPlayerManager: YXSAVPlayerDelegate{
    func avPlayNotifyProcess(_ percent: CGFloat, currentSecond: UInt){
        delegate?.musicPlayerManagerNotifyProcess(percent, currentSecond: currentSecond)
    }
    func avPlayerWillPlaying(){
        delegate?.musicPlayerManagerWillPlaying()
    }
    func avPlayerDidPlaying(){
        delegate?.musicPlayerManagerDidPlaying()
    }
    func avPlayerDidPaused(){
        delegate?.musicPlayerManagerDidPaused()
    }
    func avPlayerDidStart(){
        delegate?.musicPlayerManagerDidStart()
    }
    func avPlayerPlayEnd(){
        videoPlayEnd()
    }
    func avPlayerGetTotalDuration(duration: Int){
        curruntTrack?.duration = duration
    }
    func avPlayerLoadedTimeRanges(percent: CGFloat){
//        SLLog("缓存进度: \(percent)")
    }
}
