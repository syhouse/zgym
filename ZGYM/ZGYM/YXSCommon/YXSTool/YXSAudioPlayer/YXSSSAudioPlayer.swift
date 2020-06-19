//
//  SSAudioPlayer.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/18.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit


class YXSSSAudioPlayer: NSObject {
    static let sharedInstance: YXSSSAudioPlayer = {
        let instance = YXSSSAudioPlayer()
        // setup code
        return instance
    }()
    
    /// IM音效
    func playMessageSoundEffect() {
        let str = Bundle.main.path(forResource: "message", ofType: "wav")
        let url = URL(fileURLWithPath: str ?? "")
        play(url: url)
    }
    
    var sourceUrl: URL?
    var isPause: Bool {
        get{
            return avplayer?.playerStatus == .paused
        }
    }
    var isFinish: Bool = false
    
    var finish: (() -> ())?
    
    var avplayer: YXSAVPlayer?
    
    ///仅仅播放音频
    @objc public func play(url:URL, loop: Int = 1,finish: (() -> ())? = nil){
        self.sourceUrl = url
        self.finish = finish
        self.loop = loop
        isFinish = false
        
        YXSXMPlayerGlobalControlTool.share.pauseCompetitionPlayer()
        
        avplayer = YXSAVPlayer()
        avplayer?.play(url: url)
        avplayer?.avPlayerDelegate = self
        
    }
    
    ///播放音频并缓存
    @objc public func play(url:URL, loop: Int = 1,cacheAudio: Bool,finish: (() -> ())? = nil) {
        var localUrl: URL = url
        //下载音频资源
        if cacheAudio{
            if YXSDownloaderHelper.helper.hasDownloadSucess(url: url.absoluteString){
                localUrl = URL.init(fileURLWithPath: YXSDownloaderHelper.helper.downloadPath(url: url.absoluteString))
            }else{
                YXSDownloaderHelper.helper.downloadFile(urlStr: url.absoluteString)
            }
        }
        
        play(url: localUrl, loop: loop, finish: finish)
        
        
    }
    
    /// 停止播放
    public func stopVoice(){
        avplayer?.stopPlayer()
        avplayer = nil
        isFinish = true
        YXSXMPlayerGlobalControlTool.share.resumeCompetitionPlayer()
    }
    
    
    /// 暂停播放
    public func pauseVoice(){
        avplayer?.pausePlayer()
        YXSXMPlayerGlobalControlTool.share.resumeCompetitionPlayer()
    }
    
    /// 恢复
    @objc func resumeVoice() {
        avplayer?.resumePlayer()
        YXSXMPlayerGlobalControlTool.share.pauseCompetitionPlayer()
    }
        
    // MARK: - Setter
    var loop: Int? {
        didSet {
            
        }
    }

}

extension YXSSSAudioPlayer: YXSAVPlayerDelegate{
    func avPlayerPlayEnd() {
        if avplayer != nil{
            isFinish = true
            finish?()
            avplayer = nil
            YXSXMPlayerGlobalControlTool.share.resumeCompetitionPlayer()
        }
    }
}
