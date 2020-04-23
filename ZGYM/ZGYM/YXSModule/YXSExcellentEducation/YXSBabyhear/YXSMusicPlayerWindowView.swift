//
//  YXSMusicPlayerWindowView.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/20.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import SDWebImage

class YXSMusicPlayerWindowView: UIControl {
    
    /// 展示播放窗 当前播放时间
    public static func showPlayerWindow(curruntTime: UInt){
        let instanceView = YXSMusicPlayerWindowView.instanceView
        UIUtil.RootController().view.addSubview(instanceView)
        instanceView.frame = CGRect(x: 15, y: SCREEN_HEIGHT, width: SCREEN_WIDTH - 30, height: 49)
        UIView.animate(withDuration: 0.25, animations: {
            instanceView.frame = CGRect(x: 15, y: SCREEN_HEIGHT - 49 - 15 - kSafeBottomHeight, width: SCREEN_WIDTH - 30, height: 49)
            let track = XMSDKPlayer.shared()?.currentTrack()
            instanceView.titleLabel.text = track?.trackTitle
            instanceView.startVoiceAnimation()
        })
        if (XMSDKPlayer.shared()?.isPlaying())!{
            instanceView.isPlayingMusic = true
        }else{
            instanceView.isPlayingMusic = false
        }
        
        instanceView.curruntTime = curruntTime
        instanceView.isHidden = false
        XMSDKPlayer.shared()?.trackPlayDelegate = instanceView
        
        instanceView.becomeFirstResponder()
    }
    
    /// 隐藏播放窗
    public static func hidePlayerWindow(){
        UIView.animate(withDuration: 0.25, animations: {
            instanceView.frame = CGRect(x: 15, y: SCREEN_HEIGHT, width: SCREEN_WIDTH - 30, height: 49)
            instanceView.removeFromSuperview()
        })
        instanceView.resignFirstResponder()
    }
    
    ///更新播放窗口是否需要隐藏
    public static func setView(hide: Bool){
        if XMSDKPlayer.shared()?.playerState == .stop || hide{
            YXSMusicPlayerWindowView.instanceView.isHidden = true
        }else{
            YXSMusicPlayerWindowView.instanceView.isHidden = false
        }
    }
    
    ///更新播放窗口frame
    /// - Parameter isNavFirstVC: 是否是nav的第一个视图
    public static func setUpdateFrame(isNavFirstVC: Bool){
        if XMSDKPlayer.shared()?.playerState != .stop && !(UIUtil.TopViewController() is YXSPlayingViewController){
          YXSMusicPlayerWindowView.instanceView.frame = CGRect(x: 15, y: SCREEN_HEIGHT - 49 - 15 - kSafeBottomHeight - (isNavFirstVC ? 49 : 0), width: SCREEN_WIDTH - 30, height: 49)
        }
    }
    
    public static func updateSuperView(){
        let instanceView = YXSMusicPlayerWindowView.instanceView
        instanceView.removeFromSuperview()
        UIUtil.RootController().view.addSubview(instanceView)
    }
    
    private static let instanceView: YXSMusicPlayerWindowView = YXSMusicPlayerWindowView()
    private var curruntTime: UInt = 0
    
    private init() {
        super.init(frame: CGRect.zero)
        
        addSubview(closeBtn)
        
        addSubview(imgIcon)
        
        addSubview(titleLabel)
        
        addSubview(playerBtn)
        
        addSubview(nextBtn)
        
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 12.5, height: 12))
        }
        
        imgIcon.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 15.5, height: 14))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imgIcon.snp_right).offset(13)
            make.centerY.equalTo(self)
            make.right.equalTo(playerBtn.snp_left).offset(-15)
        }
        
        nextBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-16.5)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 29.5, height: 30))
        }
        
        playerBtn.snp.makeConstraints { (make) in
            make.right.equalTo(nextBtn.snp_left).offset(-17.5)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 29.5, height: 30))
        }
        
        closeBtn.isHidden = true
        
        self.addTarget(self, action: #selector(showPlayerView), for: .touchUpInside)
        
        self.backgroundColor = UIColor.black
        self.cornerRadius = 5
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///当前播放状态
    private var isPlayingMusic: Bool = true{
        didSet{
            if isPlayingMusic{
                closeBtn.isHidden = true
                playerBtn.isSelected = true
                imgIcon.snp.remakeConstraints { (make) in
                    make.left.equalTo(16)
                    make.centerY.equalTo(self)
                    make.size.equalTo(CGSize(width: 15.5, height: 14))
                }
                startVoiceAnimation()
            }else{
                playerBtn.isSelected = false
                closeBtn.isHidden = false
                imgIcon.snp.remakeConstraints { (make) in
                    make.left.equalTo(39)
                    make.centerY.equalTo(self)
                    make.size.equalTo(CGSize(width: 15.5, height: 14))
                }
                stopVoiceAnimation()
            }
                
        }
    }
    
    private func startVoiceAnimation(){
         //  Converted to Swift 5.1 by Swiftify v5.1.28520 - https://objectivec2swift.com/
         let ary = [
             UIImage(named: "yxs_xmla_audio_0"),
             UIImage(named: "yxs_xmla_audio_1"),
             UIImage(named: "yxs_xmla_audio_2"),
             UIImage(named: "yxs_xmla_audio_3")
         ]
         imgIcon.animationImages = ary.compactMap { $0 }
         imgIcon.animationDuration = 1 //动画时间
         imgIcon.animationRepeatCount = 0 //动画重复次数，0：无限
         imgIcon.startAnimating() //

     }
     
     private func stopVoiceAnimation(){
         imgIcon.stopAnimating() //
     }
    
    @objc func closeClick(){
        XMSDKPlayer.shared()?.stopTrackPlay()
        YXSMusicPlayerWindowView.hidePlayerWindow()
    }
    
    @objc func playerClick(){
        if isPlayingMusic{
            XMSDKPlayer.shared()?.pauseTrackPlay()
            isPlayingMusic = false
        }else{
            isPlayingMusic = true
            XMSDKPlayer.shared()?.resumeTrackPlay()
        }
    }
    
    @objc func playerNextClick(){
        XMSDKPlayer.shared()?.playNextTrack()
        isPlayingMusic = true
    }
    
    @objc func showPlayerView(){
        let vc = YXSPlayingViewController(curruntTime: curruntTime)
        UIUtil.curruntNav().pushViewController(vc)
    }
    
    
    lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.ts_touchInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        button.setImage(UIImage.init(named: "yxs_xmly_close"), for: .normal)
        button.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var imgIcon: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_xmla_audio_0"))
        return imageView
    }()
    
    lazy var playerBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setImage(UIImage.init(named: "sl_player_play"), for: .normal)
        button.setImage(UIImage.init(named: "sl_player_pause"), for: .selected)
        button.addTarget(self, action: #selector(playerClick), for: .touchUpInside)
        return button
    }()
    
    lazy var nextBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setImage(UIImage.init(named: "yxs_xmly_next"), for: .normal)
        button.addTarget(self, action: #selector(playerNextClick), for: .touchUpInside)
        return button
    }()
}

// MARK: - 锁屏控制
extension YXSMusicPlayerWindowView{
    override var canBecomeFirstResponder: Bool {
         get {
             return true
         }
     }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type == UIEvent.EventType.remoteControl{
            switch event?.subtype {
            case .remoteControlPause:
                playerClick()
            case .remoteControlPlay:
                playerClick()
            case .remoteControlNextTrack:
                playerNextClick()
            case .remoteControlPreviousTrack:
                XMSDKPlayer.shared()?.playPrevTrack()
                isPlayingMusic = true
            default:
                break
            }
        }
    }
}

extension YXSMusicPlayerWindowView: XMTrackPlayerDelegate{
    // MARK: - Delegate
    func xmTrackPlayNotifyProcess(_ percent: CGFloat, currentSecond: UInt) {
        YXSRemoteControlInfoHelper.curruntTime = currentSecond
        curruntTime = currentSecond
        
        UIUtil.configNowPlayingCenterUI()
    }
    
    func xmTrackPlayerWillPlaying() {
        let track = XMSDKPlayer.shared()?.currentTrack()
        titleLabel.text = track?.trackTitle
    }
    
    func xmTrackPlayerDidEnd() {
        YXSMusicPlayerWindowView.hidePlayerWindow()
    }
    
    func xmTrackPlayerDidPlaying() {
        startVoiceAnimation()
    }
    
    func xmTrackPlayerDidPaused() {
        stopVoiceAnimation()
    }
    
    func xmTrackPlayerDidStart() {
         UIUtil.configNowPlayingCenterUI()
    }
}
