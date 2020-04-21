//
//  YXSPlayingViewController.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/13.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight
import SDWebImage

class YXSPlayingViewController: YXSBaseViewController, XMTrackPlayerDelegate,XMLivePlayerDelegate {

    private var track: XMTrack?
    private var trackList: [Any] = []
    private var radio: XMRadio?
    private var programList: [Any] = []
    private var radioSchedule: XMRadioSchedule?
    
    /// 播放列表菜单
    var playListVC: YXSPlayListViewController?
    
    // MARK: - init
    
    
    /// 展示当前喜马拉雅专辑播放UI
    override init() {
        super.init()
    }
    
    
    /// 播放新的专辑
    /// - Parameters:
    ///   - track: 当前声音
    ///   - trackList: 声音列表
    convenience init(track: XMTrack, trackList: [Any] = []){
        self.init()
        self.track = track
        self.trackList = trackList
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - leftCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ///注意顺序
        YXSMusicPlayerWindowView.hidePlayerWindow()
        
        ///接收锁屏事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ///注意顺序
        
        ///结束锁屏事件
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        
        YXSMusicPlayerWindowView.showPlayerWindow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNav.title = self.track?.trackTitle
        view.addSubview(customNav)
        customNav.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }
        self.fd_prefersNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
//        view.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#745683")
        
        /// 背景图
        view.addSubview(imgBgView)
        imgBgView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        
        /// 毛玻璃
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        view.insertSubview(blurEffectView, aboveSubview: imgBgView)
        blurEffectView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        
        XMSDKPlayer.shared()?.setAutoNexTrack(true)
        XMSDKPlayer.shared()?.trackPlayDelegate = self
        XMSDKPlayer.shared()?.livePlayDelegate = self
        
        view.addSubview(controlPanel)
        controlPanel.addSubview(btnPlayPause)
        controlPanel.addSubview(btnPrevious)
        controlPanel.addSubview(btnNext)
        
        view.addSubview(btnMenu)
        view.addSubview(btnCollect)
        
        view.addSubview(progressView)
        view.addSubview(lbCurrentDuration)
        view.addSubview(lbTotalDuration)
        
        view.addSubview(imgWaterMark)
        view.addSubview(imgCover)
        view.insertSubview(customBorderView, belowSubview: imgCover)
        view.bringSubviewToFront(customNav)
        
        layout()
        
        btnPlayPause.addTarget(self, action: #selector(playPauseClick(sender:)), for: .touchUpInside)
        btnPrevious.addTarget(self, action: #selector(playPreTrack(sender:)), for: .touchUpInside)
        btnNext.addTarget(self, action: #selector(playNextTrack(sender:)), for: .touchUpInside)
        progressView.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        btnMenu.addTarget(self, action: #selector(menuClick(sender:)), for: .touchUpInside)
        btnCollect.addTarget(self, action: #selector(collectClick(sender:)), for: .touchUpInside)
        
        if let _ = track{//操作喜马拉雅播放器  设置播放列表
            stop()
            play()
        }else{//根据喜马拉雅当前播放器设置播放UI
            track = XMSDKPlayer.shared()?.currentTrack()
            trackList = XMSDKPlayer.shared()?.playList() ?? [Any]()
            xmTrackPlayerDidStart()
            btnPlayPause.isSelected = !(XMSDKPlayer.shared()?.isPaused() ?? false)
        }
    }
    
    @objc func layout() {
        controlPanel.snp.makeConstraints({ (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.bottom.equalTo(view.snp_bottom).offset(-60)
        })
        
        btnPrevious.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.centerY.equalTo(btnPlayPause.snp_centerY)
        })
        
        btnPlayPause.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(btnPrevious.snp_right).offset(44)
            make.bottom.equalTo(0)
            make.width.height.equalTo(62)
        })
        
        btnNext.snp.makeConstraints({ (make) in
            make.left.equalTo(btnPlayPause.snp_right).offset(44)
            make.right.equalTo(0)
            make.centerY.equalTo(btnPlayPause.snp_centerY)
        })
        
        btnMenu.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(controlPanel.snp_centerY)
        })
        
        btnCollect.snp.makeConstraints({ (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(controlPanel.snp_centerY)
        })
        
        progressView.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(controlPanel.snp_top).offset(-47)
        })
        
        lbCurrentDuration.snp.makeConstraints({ (make) in
            make.top.equalTo(progressView.snp_bottom).offset(13)
            make.left.equalTo(progressView.snp_left)
        })
        
        lbTotalDuration.snp.makeConstraints({ (make) in
            make.top.equalTo(progressView.snp_bottom).offset(13)
            make.right.equalTo(progressView.snp_right)
        })
        
        imgCover.snp.makeConstraints({ (make) in
            make.bottom.equalTo(progressView.snp_top).offset(-125.0 * SCREEN_SCALE)
            make.width.height.equalTo(214.0 * SCREEN_SCALE)
            make.centerX.equalTo(view.snp_centerX)
        })
        
        customBorderView.snp.makeConstraints({ (make) in
            make.width.height.equalTo(214.0 * SCREEN_SCALE + 20)
            make.centerX.equalTo(imgCover.snp_centerX)
            make.centerY.equalTo(imgCover.snp_centerY)
        })
        
        imgWaterMark.snp.makeConstraints({ (make) in
            make.bottom.equalTo(imgCover.snp_bottom)
            make.right.equalTo(-15)
        })
    }
    
    // MARK: - Request
    @objc func requestJudge(voiceId: Int) {
        YXSEducationBabyVoiceCollectionJudgeRequest(voiceId: voiceId).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            let isCollect: Bool = json["collection"].boolValue
            weakSelf.btnCollect.isSelected = isCollect
            
        }) { (msg, code) in
            
        }
    }

    
    // MARK: - Action
    @objc func playPauseClick(sender: YXSButton) {
        if sender.isSelected {
            sender.isSelected = !sender.isSelected
            /// pause
            pause()
            
        } else {
            sender.isSelected = !sender.isSelected
            /// play
            resume()
        }
    }
    
    @objc func play() {
        if trackList.count > 0 {
            btnPlayPause.isSelected = true
            progressView.value = 0.0
            XMSDKPlayer.shared()?.setPlayMode(.track)
            XMSDKPlayer.shared()?.setTrackPlayMode(.XMTrackPlayerModeList)
            XMSDKPlayer.shared()?.play(with: track, playlist: trackList)
            XMSDKPlayer.shared()?.setAutoNexTrack(true)
            
        } else if radio != nil {
            btnPlayPause.isSelected = true
            XMSDKPlayer.shared()?.setPlayMode(.live)
            XMSDKPlayer.shared()?.startLivePlay(with: radio)
            
        } else if radioSchedule != nil {
            btnPlayPause.isSelected = true
            XMSDKPlayer.shared()?.setPlayMode(.live)
            XMSDKPlayer.shared()?.startHistoryLivePlay(with: nil, withProgram: radioSchedule, inProgramList: programList)
        }
    }
    
    @objc func pause() {
        if trackList.count > 0 {
            XMSDKPlayer.shared()?.pauseTrackPlay()
            
        } else if radio != nil {
            XMSDKPlayer.shared()?.pauseLivePlay()
            
        } else if radioSchedule != nil {
            XMSDKPlayer.shared()?.pauseLivePlay()
        }
    }
    
    @objc func resume() {
        if trackList.count > 0 {
            XMSDKPlayer.shared()?.resumeTrackPlay()
            
        } else if radio != nil || radioSchedule != nil {
            XMSDKPlayer.shared()?.resumeLivePlay()
        }
    }
    
    @objc func stop() {
        if trackList.count > 0 {
            XMSDKPlayer.shared()?.stopTrackPlay()
            
        } else if radio != nil || radioSchedule != nil {
            XMSDKPlayer.shared()?.stopLivePlay()
        }
        progressView.value = 0.0;
    }

    @objc func playPreTrack(sender: YXSButton) {
        progressView.value = 0.0
        
        if trackList.count > 0 {
            XMSDKPlayer.shared()?.playPrevTrack()
            
        } else if radio != nil {
            //[[XMSDKPlayer sharedPlayer] pauseLivePlay];
            
        } else if radioSchedule != nil {
            XMSDKPlayer.shared()?.playPreProgram()
        }
    }

    @objc func playNextTrack(sender: YXSButton) {
        progressView.value = 0.0
        
        if trackList.count > 0 {
            XMSDKPlayer.shared()?.playNextTrack()
            
        } else if radio != nil {
            //[[XMSDKPlayer sharedPlayer] pauseLivePlay];
            
        } else if radioSchedule != nil {
            XMSDKPlayer.shared()?.playNextProgram()
        }
    }

    @objc func sliderValueChanged(sender: UISlider) {
        if(sender == progressView) {
            if(trackList.count > 0){
                let second = Float(XMSDKPlayer.shared()?.currentTrack()?.duration ?? 0) * progressView.value
                XMSDKPlayer.shared()?.seek(toTime: CGFloat(second))
                
            } else if radioSchedule != nil {
                let second = Float(XMSDKPlayer.shared()?.currentPlayingProgram()?.duration ?? 0) * progressView.value
                XMSDKPlayer.shared()?.seek(toTime: CGFloat(second))
            }
        }
    }

    @objc func menuClick(sender: YXSButton) {
        playListVC = YXSPlayListViewController(trackList: trackList as! [XMTrack]) { [weak self](index) in
            guard let weakSelf = self else {return}
            weakSelf.track = weakSelf.trackList[index] as! XMTrack
            weakSelf.play()
        }
        navigationController?.present(playListVC!, animated: true, completion: nil)
    }
    
    @objc func collectClick(sender: YXSButton) {
        let track = XMSDKPlayer.shared()?.currentTrack()
        
        if sender.isSelected {
            /// 取消
            YXSEducationBabyVoiceCollectionCancelRequest(voiceId: track?.trackId ?? 0).request({ (json) in
                sender.isSelected = !sender.isSelected
                MBProgressHUD.yxs_showMessage(message: "取消收藏成功")
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
            
        } else {
            /// 收藏
            YXSEducationBabyVoiceCollectionSaveRequest(voiceId: track?.trackId ?? 0, voiceTitle: track?.trackTitle ?? "", voiceDuration: track?.duration ?? 0).request({ (json) in
                sender.isSelected = !sender.isSelected
                MBProgressHUD.yxs_showMessage(message: "收藏成功")
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
    }
    
    @objc func onBackClick(sender: UIButton) {
        navigationController?.popViewController()
    }
    
    // MARK: - Delegate
    func xmTrackPlayNotifyProcess(_ percent: CGFloat, currentSecond: UInt) {
        progressView.value = Float(percent)
        lbCurrentDuration.text = stringWithDuration(duration: Int(currentSecond))
        UIUtil.configNowPlayingCenter(curruntTime: Int(currentSecond))
    }
    
    func xmTrackPlayNotifyCacheProcess(_ percent: CGFloat) {
        ///
        SLLog("CacheProcess:\(percent)")
    }
    
    func xmTrackPlayerWillPlaying() {
        playListVC?.tableView.reloadData()
    }
    
    func xmTrackPlayerDidStart() {
        let track = XMSDKPlayer.shared()?.currentTrack()
        requestJudge(voiceId: track?.trackId ?? 0)
        
        customNav.title = XMSDKPlayer.shared()?.currentTrack()?.trackTitle
        lbTotalDuration.text = stringWithDuration(duration: XMSDKPlayer.shared()?.currentTrack()?.duration ?? 0)
        
        if let image = SDImageCache.shared.imageFromCache(forKey: XMSDKPlayer.shared()?.currentTrack()?.coverUrlLarge ?? ""){
            UIUtil.configNowPlayingCenter(title: XMSDKPlayer.shared()?.currentTrack()?.trackTitle ?? "", author: XMSDKPlayer.shared()?.currentTrack()?.announcer.nickname ?? "", curruntTime: 0, totalTIme: XMSDKPlayer.shared()?.currentTrack()?.duration ?? 0, image: image)
        }else{
            imgCover.sd_setImage(with: URL(string: XMSDKPlayer.shared()?.currentTrack()?.coverUrlLarge ?? ""), completed: { (image, error, type, url) in
                UIUtil.configNowPlayingCenter(title: XMSDKPlayer.shared()?.currentTrack()?.trackTitle ?? "", author: XMSDKPlayer.shared()?.currentTrack()?.announcer.nickname ?? "", curruntTime: 0, totalTIme: XMSDKPlayer.shared()?.currentTrack()?.duration ?? 0, image: image)
            })
        }
        
        imgBgView.sd_setImage(with: URL(string: XMSDKPlayer.shared()?.currentTrack()?.coverUrlLarge ?? ""), completed: nil)
    }

    // MARK: - Live Radio
    func xmLiveRadioPlayerNotifyPlayProgress(_ percent: CGFloat, currentTime: Int) {
        progressView.value = Float(percent)
        lbCurrentDuration.text = stringWithDuration(duration: currentTime)
    }
    
    func xmLiveRadioPlayerNotifyCacheProgress(_ percent: CGFloat) {
        SLLog("CacheProcess:\(percent)")
    }
    

    
    func xmLiveRadioPlayerDidStart() {
        playListVC?.tableView.reloadData()
        setPlayerDidStartUI()
    }
    
    // MARK: -Tool
    /// 秒 转(分：秒)
    
    func setPlayerDidStartUI(){
        if radio != nil {
            customNav.title = XMSDKPlayer.shared()?.currentPlayingRadio()?.radioName
            let totalDuration = Int(XMSDKPlayer.shared()?.currentPlayingRadio()?.radioDesc ?? "0")
            lbTotalDuration.text = stringWithDuration(duration: totalDuration ?? 0)
            imgCover.sd_setImage(with: URL(string: XMSDKPlayer.shared()?.currentPlayingRadio()?.coverUrlLarge ?? ""), completed: nil)
            imgBgView.sd_setImage(with: URL(string: XMSDKPlayer.shared()?.currentPlayingRadio()?.coverUrlLarge ?? ""), completed: nil)
            
        } else {
            customNav.title = XMSDKPlayer.shared()?.currentPlayingProgram()?.relatedProgram.programName
            let totalDuration = XMSDKPlayer.shared()?.currentPlayingProgram()?.totalPlayedTime
            lbTotalDuration.text = String.init(format: "%02d:%02d", ((totalDuration ?? 0)/60),((totalDuration ?? 0)%60))
            imgCover.sd_setImage(with: URL(string: XMSDKPlayer.shared()?.currentPlayingProgram()?.relatedProgram.backPicUrl ?? ""), completed: nil)
            imgBgView.sd_setImage(with: URL(string: XMSDKPlayer.shared()?.currentPlayingProgram()?.relatedProgram.backPicUrl ?? ""), completed: nil)
        }
    }
    
    @objc func stringWithDuration(duration: Int) -> String {
        return String.init(format: "%02d:%02d", (duration/60),(duration%60))
    }
    
    // MARK: - LazyLoad
    lazy var controlPanel: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var btnPlayPause: YXSButton = {
        let btn = YXSButton()
        btn.setMixedImage(MixedImage(normal: "sl_player_play", night: "sl_player_play"), forState: .normal)
        btn.setMixedImage(MixedImage(normal: "sl_player_pause", night: "sl_player_pause"), forState: .selected)
        return btn
    }()

    lazy var btnPrevious: YXSButton = {
        let btn = YXSButton()
        btn.setMixedImage(MixedImage(normal: "sl_player_previous", night: "sl_player_previous"), forState: .normal)
        return btn
    }()
    
    lazy var btnNext: YXSButton = {
        let btn = YXSButton()
        btn.setMixedImage(MixedImage(normal: "sl_player_next", night: "sl_player_next"), forState: .normal)
        return btn
    }()
    
    lazy var btnMenu: YXSButton = {
        let btn = YXSButton()
        btn.setMixedImage(MixedImage(normal: "sl_player_menu", night: "sl_player_menu"), forState: .normal)
        return btn
    }()
    
    lazy var btnCollect: YXSButton = {
        let btn = YXSButton()
        btn.setMixedImage(MixedImage(normal: "yxs_xmly_no_fav", night: "yxs_xmly_no_fav"), forState: .normal)
        btn.setMixedImage(MixedImage(normal: "yxs_xmly_has_fav", night: "yxs_xmly_has_fav"), forState: .selected)
        
        return btn
    }()
    
    lazy var progressView : UISlider = {
        let slider = UISlider()
        slider.mixedMinimumTrackTintColor = MixedColor(normal: kNightFFFFFF, night: kNightFFFFFF)
        slider.mixedMaximumTrackTintColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF", alpha: 0.5), night: UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF", alpha: 0.5))
        return slider
    }()
    
    lazy var lbCurrentDuration: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "00:00"
        lb.mixedTextColor = MixedColor(normal: kNightFFFFFF, night: kNightFFFFFF)
        lb.font = UIFont.systemFont(ofSize: 12)
        return lb
    }()
    
    lazy var lbTotalDuration: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "00:00"
        lb.mixedTextColor = MixedColor(normal: kNightFFFFFF, night: kNightFFFFFF)
        lb.font = UIFont.systemFont(ofSize: 12)
        return lb
    }()
    
    /// 封面
    lazy var imgCover: UIImageView = {
        let img = UIImageView()
        img.mixedImage = kImageDefualtMixedImage
        img.cornerRadius = (SCREEN_SCALE * 214.0)/2
        return img
    }()
    
    lazy var customBorderView: UIView = {
        let view = UIView()
        view.cornerRadius = (SCREEN_SCALE * 214.0 + 20)/2
        view.backgroundColor = kNightFFFFFF
        view.alpha = 0.3
        view.clipsToBounds = true
        return view
    }()
    
    /// 水印喜马拉雅
    lazy var imgWaterMark: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "sl_player_mark")
        return img
    }()
    
    lazy var customNav: YXSCustomNav = {
        let customNav = YXSCustomNav.init(.backAndTitle)
        customNav.backImageButton.setMixedImage(MixedImage(normal: "yxs_back_white", night: "yxs_back_white"), forState: .normal)
        customNav.titleLabel.textColor = UIColor.white
        customNav.backImageButton.addTarget(self, action: #selector(onBackClick(sender:)), for: .touchUpInside)
        return customNav
    }()
    
    /// 背景图
    lazy var imgBgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#745683")
        return imgView
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - 锁屏控制
extension YXSPlayingViewController{
    
    override var canBecomeFirstResponder: Bool {
         get {
             return true
         }
     }
     
     override func remoteControlReceived(with event: UIEvent?) {
         if event?.type == UIEvent.EventType.remoteControl{
             switch event?.subtype {
             case .remoteControlPause:
                 btnPlayPause.isSelected = !btnPlayPause.isSelected
                 self.pause()
             case .remoteControlPlay:
                 btnPlayPause.isSelected = !btnPlayPause.isSelected
                 self.resume()
             case .remoteControlNextTrack:
                 self.playNextTrack(sender: YXSButton())
             case .remoteControlPreviousTrack:
                 self.playPreTrack(sender: YXSButton())
             default:
                 break
             }
         }
     }
}
