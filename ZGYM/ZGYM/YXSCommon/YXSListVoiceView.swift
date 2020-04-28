//
//  YXSListVoiceView.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/18.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit

class YXSListVoiceView: YXSVoiceBaseView {
    ///唯一播放id 必须设置 列表必须不一样
    var id: String = ""
    
    var model: YXSVoiceViewModel? {
        didSet {
            voiceDuration = model?.voiceDuration
            voiceUlr = model?.voiceUlr
            lbSecond.text = "\(voiceDuration ?? 0)\""
            updateLayout()
        }
    }
    
    override func indicatorClick(sender: UIControl) {
        if let url = URL(string: model?.voiceUlr ?? "") {
            YXSSSAudioListPlayer.sharedInstance.playerUrl(url: url, id: id, startAnimation: {
                self.startVoiceAnimation()
            }) {
                self.stopVoiceAnimation()
            }
        }
        
        self.completionHandler?(model?.voiceUlr ?? "", model?.voiceDuration ?? 0)
    }
}


/// 互斥的播放列表
class YXSSSAudioListPlayer: NSObject {
    private override init() {
        
    }
    
    static let sharedInstance: YXSSSAudioListPlayer = {
        let instance = YXSSSAudioListPlayer()
        // setup code
        return instance
    }()
    private var listPlayer: [String: YXSSSAudioPlayer] = [String: YXSSSAudioPlayer]()
    
    
    /// 播放列表音频
    /// - Parameters:
    ///   - url: 音频地址
    ///   - id: id 唯一标识
    ///   - operatorBlock: 回调  isPlaying true正在播放 false停止播放
    public func playerUrl(url: URL, id: String,startAnimation:(()->())?, finishAnimation: (()->())?){
        ///停止之前的
        for key in listPlayer.keys{
            if key != id{
                let player = listPlayer[key]
                player?.stopVoice()
                player?.finish?()
            }
        }
        
        if let curruntPlayer = listPlayer[id]{
            if curruntPlayer.isFinish{
                curruntPlayer.play(url: url, cacheAudio: true,finish: finishAnimation)
                startAnimation?()
            }else if curruntPlayer.isPause{
                curruntPlayer.resumeVoice()
                startAnimation?()
            }else{
                curruntPlayer.pauseVoice()
                finishAnimation?()
            }
        }else{
            
            let sudioPlayer = YXSSSAudioPlayer()
            sudioPlayer.play(url: url, cacheAudio: true,finish: finishAnimation)
            listPlayer[id] = sudioPlayer
            startAnimation?()
        }
    }
    
    ///停止播放player
    public func stopPlayer(){
        for key in listPlayer.keys{
            let player = listPlayer[key]
            player?.stopVoice()
            player?.finish?()
        }
        removerPlayer()
        
        YXSPlayerMediaSingleControlTool.share.resumePlayer()
    }
    
    ///移除播放player
    public func removerPlayer(){
        listPlayer.removeAll()
    }
}

