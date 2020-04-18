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
    
//    - (void)playPassAudio {
//        //获得本地文件路径
//        NSString * str = [[NSBundle mainBundle] pathForResource:@"pass" ofType:@"mp3"];
//        //将本地文件的路径转成url；
//        NSURL * urlStr = [NSURL fileURLWithPath:str];
//        [[QSPlayerManager shareManager] playWithURL:urlStr];
//    }
    
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var sourceUrl: URL?
    var isPause: Bool = false
    var isFinish: Bool = false
    
    var finish: (() -> ())?
    
    ///仅仅播放音频
    @objc public func play(url:URL, loop: Int = 1,finish: (() -> ())? = nil){
        self.sourceUrl = url
        self.finish = finish
        self.loop = loop
        let session = AVAudioSession()
         do{
             try session.setCategory(AVAudioSession.Category.playback,options: [.mixWithOthers])
             try session.setActive(true)
         }catch{
             SLLog(error)
         }
         playerItem = AVPlayerItem(url: url)
         //如果要切换视频需要调AVPlayer的replaceCurrentItemWithPlayerItem:方法
         if player?.currentItem != nil {
             player?.replaceCurrentItem(with: playerItem)
             
         } else {
             player = AVPlayer(playerItem: playerItem)
         }
         player?.play()
         isPause = false
         isFinish = false
         
         NotificationCenter.default.addObserver(self, selector: #selector(videoPlayEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
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
        player?.pause()
        player = nil
        isFinish = true
    }
    
    
    /// 暂停播放
    public func pauseVoice(){
        stopVoice()
    }
    
    /// 恢复
    @objc func resumeVoice() {
        if let player = player{
            if isFinish {
                player.seek(to: CMTimeMake(value: 0, timescale: 1))
                isFinish = false
            }
            player.play()
            isPause = false
            
        }
    }
    
    @objc func videoPlayEnd(){
        try? AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.none)
        isFinish = true
        isPause = true
        finish?()
    }
        
    // MARK: - Setter
    var loop: Int? {
        didSet {
            
        }
    }


}
