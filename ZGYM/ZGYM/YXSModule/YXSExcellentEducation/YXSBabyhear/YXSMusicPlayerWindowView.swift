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
    public static func showPlayerWindow(){
        let instanceView = YXSMusicPlayerWindowView.instanceView
        UIUtil.RootController().view.addSubview(instanceView)
        instanceView.frame = CGRect(x: 15, y: SCREEN_HEIGHT, width: SCREEN_WIDTH - 30, height: 49)
        UIView.animate(withDuration: 0.25, animations: {
            instanceView.frame = CGRect(x: 15, y: SCREEN_HEIGHT - 49 - 5 - kSafeBottomHeight, width: SCREEN_WIDTH - 30, height: 49)
            let track = YXSXMPlayerGlobalControlTool.share.currentTrack
            instanceView.titleLabel.text = track?.trackTitle
            instanceView.startVoiceAnimation()
        })
        if YXSXMPlayerGlobalControlTool.share.isPlayerPlaying(){
            instanceView.isPlayingMusic = true
        }else{
            instanceView.isPlayingMusic = false
        }
        instanceView.isHidden = false
        YXSXMPlayerGlobalControlTool.share.playerDelegate = instanceView
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
    }
    
    /// 隐藏播放窗
    public static func hidePlayerWindow(){
        UIApplication.shared.endReceivingRemoteControlEvents()
        UIView.animate(withDuration: 0.25, animations: {
            instanceView.frame = CGRect(x: 15, y: SCREEN_HEIGHT, width: SCREEN_WIDTH - 30, height: 49)
            instanceView.removeFromSuperview()
        })
    }
    
    ///更新播放窗口是否需要隐藏
    public static func setView(hide: Bool){
        if YXSXMPlayerGlobalControlTool.share.isPlayerStop() || hide{
            YXSMusicPlayerWindowView.instanceView.isHidden = true
        }else{
            YXSMusicPlayerWindowView.instanceView.isHidden = false
            if YXSXMPlayerGlobalControlTool.share.isPlayerPlaying(){
                instanceView.isPlayingMusic = true
            }else{
                instanceView.isPlayingMusic = false
            }
            if instanceView.superview == nil{
                UIUtil.RootController().view.addSubview(instanceView)
            }
        }
    }
    
    ///更新播放窗口frame
    /// - Parameter isNavFirstVC: 是否是nav的第一个视图
    public static func setUpdateFrame(isNavFirstVC: Bool){
        if !YXSXMPlayerGlobalControlTool.share.isPlayerStop() && !(UIUtil.TopViewController() is YXSPlayingViewController){
            YXSMusicPlayerWindowView.instanceView.frame = CGRect(x: 15, y: SCREEN_HEIGHT - 49 - 5 - kSafeBottomHeight - (isNavFirstVC ? 49 : 0), width: SCREEN_WIDTH - 30, height: 49)
            if YXSXMPlayerGlobalControlTool.share.isPlayerPlaying(){
                instanceView.isPlayingMusic = true
            }else{
                instanceView.isPlayingMusic = false
            }
            if instanceView.superview == nil{
                UIUtil.RootController().view.addSubview(instanceView)
            }
        }
    }
    
    public static func updateSuperView(){
        let instanceView = YXSMusicPlayerWindowView.instanceView
        instanceView.removeFromSuperview()
        UIUtil.RootController().view.addSubview(instanceView)
    }
    
    public static func cheakPlayerUI(){
        if YXSXMPlayerGlobalControlTool.share.isPlayerPlaying(){
            instanceView.isPlayingMusic = true
        }else{
            instanceView.isPlayingMusic = false
        }
    }
    
    public static func currentWindowView() -> YXSMusicPlayerWindowView{
        return instanceView
    }
    
    private static let instanceView: YXSMusicPlayerWindowView = YXSMusicPlayerWindowView()
    
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
    var isPlayingMusic: Bool = true{
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
        YXSXMPlayerGlobalControlTool.share.stopXMPlay()
        YXSMusicPlayerWindowView.hidePlayerWindow()
        
        UIApplication.shared.endReceivingRemoteControlEvents()
        UIUtil.configNowPlayingCenterUI()
    }
    
    @objc func playerClick(){
        if isPlayingMusic{
            YXSXMPlayerGlobalControlTool.share.pauseXMPlay()
            isPlayingMusic = false
        }else{
            isPlayingMusic = true
            YXSXMPlayerGlobalControlTool.share.resumeXMPlay()
        }
    }
    
    @objc func playerNextClick(){
        YXSXMPlayerGlobalControlTool.share.playXMNext()
        isPlayingMusic = true
    }
    
    @objc func showPlayerView(){
        let vc = YXSPlayingViewController()
        UIUtil.currentNav().pushViewController(vc)
    }
    
    
    lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.yxs_touchInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
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
                YXSXMPlayerGlobalControlTool.share.playXMPrev()
                isPlayingMusic = true
            default:
                break
            }
        }
    }
}

extension YXSMusicPlayerWindowView: YXSXMPlayerDelegate{
    // MARK: - Delegate
    func xmTrackPlayNotifyProcess(_ percent: CGFloat, currentSecond: UInt) {
        UIUtil.configNowPlayingCenterUI()
    }
    
    func xmTrackPlayerWillPlaying() {
        let track = YXSXMPlayerGlobalControlTool.share.currentTrack
        titleLabel.text = track?.trackTitle
    }
    
    func xmTrackPlayerDidPlaylistEnd() {
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
