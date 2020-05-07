//
//  APPDelegate+xmly.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/11.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit

extension AppDelegate: XMReqDelegate{
    func didXMInitReqOK(_ result: Bool) {
        SLLog("didXMInitReqOK:\(result ? "sucess" : "fail")")
    }
    
    func didXMInitReqFail(_ respModel: XMErrorModel!) {
        SLLog("didXMInitReqFail")
    }
    
    func registerXMLY(){
        XMReqMgr.sharedInstance()?.registerXMReqInfo(withKey: "aa31bbbe88a2d9ddc002588815f957d0", appSecret: "16b176443f1df1df86b0a56dc4fd9f76")
        XMReqMgr.sharedInstance()?.delegate = self
    }
}


// MARK: - 锁屏控制
extension AppDelegate{
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type == UIEvent.EventType.remoteControl{
            switch event?.subtype {
            case .remoteControlPause:
                if let playerVc = UIUtil.TopViewController() as? YXSPlayingViewController{
                    playerVc.btnPlayPause.isSelected = !playerVc.btnPlayPause.isSelected
                    playerVc.pause()
                }else{
                    YXSMusicPlayerWindowView.curruntWindowView().playerClick()
                }
                UIUtil.configNowPlayingIsPause(isPlaying: false)
            case .remoteControlPlay:
                if let playerVc = UIUtil.TopViewController() as? YXSPlayingViewController{
                    playerVc.btnPlayPause.isSelected = !playerVc.btnPlayPause.isSelected
                    playerVc.resume()
                }else{
                    YXSMusicPlayerWindowView.curruntWindowView().playerClick()
                }
                UIUtil.configNowPlayingIsPause(isPlaying: true)
            case .remoteControlNextTrack:
                if let playerVc = UIUtil.TopViewController() as? YXSPlayingViewController{
                    playerVc.playNextTrack(sender: YXSButton())
                }else{
                    YXSMusicPlayerWindowView.curruntWindowView().playerNextClick()
                }
            case .remoteControlPreviousTrack:
                if let playerVc = UIUtil.TopViewController() as? YXSPlayingViewController{
                    playerVc.playNextTrack(sender: YXSButton())
                }else{
                    XMSDKPlayer.shared()?.playPrevTrack()
                    YXSMusicPlayerWindowView.curruntWindowView().isPlayingMusic = true
                }
            default:
                break
            }
        }
    }
}
