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

class YXSPlayingViewController: YXSBaseViewController {
    
    private var track: XMTrack?
    private var trackList: [Any] = []
    private var radio: XMRadio?
    private var programList: [Any] = []
    private var radioSchedule: XMRadioSchedule?
    /// 播放列表菜单
    var playListVC: YXSPlayListViewController?
    
    private var isOnDragProgress: Bool = false
    
    // MARK: - init
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
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ///判断是否是当前播放器present出去
        if self.navigationController?.viewControllers.last != self{
            UIApplication.shared.endReceivingRemoteControlEvents()
            YXSMusicPlayerWindowView.showPlayerWindow()
        }
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
        
        YXSXMPlayerGlobalControlTool.share.playerDelegate = self
        
        view.addSubview(controlPanel)
        controlPanel.addSubview(btnPlayPause)
        controlPanel.addSubview(btnPrevious)
        controlPanel.addSubview(btnNext)
        
        view.addSubview(btnMenu)
        view.addSubview(btnPlayerMode)
        view.addSubview(progressView)
        view.addSubview(lbCurrentDuration)
        view.addSubview(lbTotalDuration)
        
        view.addSubview(labelWaterMark)
        view.addSubview(imgCover)
        view.insertSubview(customBorderView, belowSubview: imgCover)
        view.bringSubviewToFront(customNav)
        
        layout()
        
        btnPlayPause.addTarget(self, action: #selector(playPauseClick(sender:)), for: .touchUpInside)
        btnPrevious.addTarget(self, action: #selector(playPreTrack(sender:)), for: .touchUpInside)
        btnNext.addTarget(self, action: #selector(playNextTrack(sender:)), for: .touchUpInside)
        progressView.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        progressView.addTarget(self, action: #selector(sliderTouchUpInside(sender:)), for: .touchUpInside)
        btnMenu.addTarget(self, action: #selector(menuClick(sender:)), for: .touchUpInside)
        btnCollect.addTarget(self, action: #selector(collectClick(sender:)), for: .touchUpInside)
        
        if let _ = track{//操作喜马拉雅播放器  设置播放列表
            stop()
            play()
        }else{//根据喜马拉雅当前播放器设置播放UI
            track = YXSXMPlayerGlobalControlTool.share.currentTrack
            trackList = YXSXMPlayerGlobalControlTool.share.playList
            musicPlayerManagerDidStart()
            updatePlayerModelUI()
            
            progressView.value = Float(YXSRemoteControlInfoHelper.currentTime)/Float(YXSXMPlayerGlobalControlTool.share.currentTrack?.duration ?? 1)
            lbCurrentDuration.text = stringWithDuration(duration: YXSRemoteControlInfoHelper.currentTime)
            btnPlayPause.isSelected = !YXSXMPlayerGlobalControlTool.share.isPlayerIsPaused()
            if YXSXMPlayerGlobalControlTool.share.isPlayerPlaying(){
                self.imgCover.resumeRotate()
            }
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
        
        btnPlayerMode.snp.makeConstraints({ (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(btnMenu.snp_centerY)
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
        
        labelWaterMark.snp.makeConstraints({ (make) in
            make.bottom.equalTo(customBorderView.snp_bottom).offset(35)
            make.centerX.equalTo(customBorderView)
        })
    }
    
    // MARK: - public
    public func cheakPlayerUI(){
        if YXSXMPlayerGlobalControlTool.share.isPlayerPlaying(){
            btnPlayPause.isSelected = true
        }else{
            btnPlayPause.isSelected = false
        }
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
            YXSXMPlayerGlobalControlTool.share.playXMPlay(track: track, trackList: trackList)
            updatePlayerModelUI()
        }
    }
    
    @objc func pause() {
        if trackList.count > 0 {
            YXSXMPlayerGlobalControlTool.share.pauseXMPlay()
            
        }
    }
    
    @objc func resume() {
        if trackList.count > 0 {
            YXSXMPlayerGlobalControlTool.share.resumeXMPlay()
            
        }
    }
    
    @objc func stop() {
        if trackList.count > 0 {
            YXSXMPlayerGlobalControlTool.share.stopXMPlay()
        }
        progressView.value = 0.0;
    }
    
    @objc func playPreTrack(sender: YXSButton) {
        progressView.value = 0.0
        btnPlayPause.isSelected = true
        if trackList.count > 0 {
            YXSXMPlayerGlobalControlTool.share.playXMPrev()
            
        }
    }
    
    @objc func playNextTrack(sender: YXSButton) {
        progressView.value = 0.0
        btnPlayPause.isSelected = true
        if trackList.count > 0 {
            YXSXMPlayerGlobalControlTool.share.playXMNext()
        }
    }
    
    @objc func sliderValueChanged(sender: UISlider) {
        isOnDragProgress = true
    }
    
    @objc func sliderTouchUpInside(sender: UISlider) {
        if(trackList.count > 0){
            let second = Float(YXSXMPlayerGlobalControlTool.share.currentTrack?.duration ?? 0) * progressView.value
            YXSXMPlayerGlobalControlTool.share.playXMSeek(second: CGFloat(second))
        }
        isOnDragProgress = false
    }
    
    
    
    @objc func menuClick(sender: YXSButton) {
        playListVC = YXSPlayListViewController(trackList: trackList as! [XMTrack]) { [weak self](index) in
            guard let weakSelf = self else {return}
            weakSelf.track = weakSelf.trackList[index] as? XMTrack
            weakSelf.play()
        }
        navigationController?.present(playListVC!, animated: true, completion: nil)
    }
    
    @objc func collectClick(sender: YXSButton) {
        let track = YXSXMPlayerGlobalControlTool.share.currentTrack
        
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
    
    @objc func changePlayerModel(){
        switch YXSXMPlayerGlobalControlTool.share.avPlayMode {
        case .modelCycle:
            MBProgressHUD.yxs_showMessage(message: "随机播放")
            YXSXMPlayerGlobalControlTool.share.setAVPlayModel(.modelRandow)
        case .modelRandow:
            MBProgressHUD.yxs_showMessage(message: "单曲循环")
            YXSXMPlayerGlobalControlTool.share.setAVPlayModel(.modelSingle)
        case .modelSingle:
            MBProgressHUD.yxs_showMessage(message: "顺序播放")
            YXSXMPlayerGlobalControlTool.share.setAVPlayModel(.modelCycle)
        default:
            break
        }
        
        updatePlayerModelUI()
    }
    
    // MARK: -Tool
    
    ///切换模式更新UI
    func updatePlayerModelUI(){
        switch YXSXMPlayerGlobalControlTool.share.avPlayMode {
        case .modelCycle:
            btnPlayerMode.setMixedImage(MixedImage.init(normal: "yxs_player_cycle", night: "yxs_player_cycle"), forState: .normal)
        case .modelRandow:
            btnPlayerMode.setMixedImage(MixedImage.init(normal: "yxs_player_random", night: "yxs_player_random"), forState: .normal)
        case .modelSingle:
            btnPlayerMode.setMixedImage(MixedImage.init(normal: "yxs_player_single", night: "yxs_player_single"), forState: .normal)
        default:
            btnPlayerMode.setMixedImage(MixedImage.init(normal: "yxs_player_cycle", night: "yxs_player_cycle"), forState: .normal)
            break
        }
    }
    
    @objc func stringWithDuration(duration: UInt) -> String {
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
        img.mixedImage = MixedImage(normal: "yxs_player_defualt_bg", night: "yxs_player_defualt_bg")
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
    lazy var labelWaterMark: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#ABB2BE"), night: UIColor.yxs_hexToAdecimalColor(hex: "#ABB2BE"))
        label.text = "内容来自喜马拉雅APP"
        return label
    }()
    
    lazy var btnPlayerMode: YXSButton = {
        let btn = YXSButton()
        btn.setMixedImage(MixedImage(normal: "yxs_player_cycle", night: "yxs_player_cycle"), forState: .normal)
        btn.addTarget(self, action: #selector(changePlayerModel), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnCollect: YXSButton = {
        let btn = YXSButton()
        btn.setMixedImage(MixedImage(normal: "yxs_xmly_no_fav", night: "yxs_xmly_no_fav"), forState: .normal)
        btn.setMixedImage(MixedImage(normal: "yxs_xmly_has_fav", night: "yxs_xmly_has_fav"), forState: .selected)
        return btn
    }()
    
    lazy var customNav: YXSCustomNav = {
        let customNav = YXSCustomNav.init(.backAndTitle)
        customNav.backImageButton.setMixedImage(MixedImage(normal: "yxs_back_white", night: "yxs_back_white"), forState: .normal)
        customNav.titleLabel.textColor = UIColor.white
        customNav.backImageButton.addTarget(self, action: #selector(onBackClick(sender:)), for: .touchUpInside)
        
        customNav.addSubview(btnCollect)
        btnCollect.snp.makeConstraints({ (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(customNav.backImageButton)
        })
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


extension YXSPlayingViewController: CAAnimationDelegate{
    func animationDidStart(_ anim: CAAnimation) {
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
    }
}

// MARK: - YXSMusicPlayerManagerDelegate
extension YXSPlayingViewController: YXSMusicPlayerManagerDelegate{
    func musicPlayerManagerDidPlaylistEnd() {
        
    }
    
    func musicPlayerManagerNotifyProcess(_ percent: CGFloat, currentSecond: UInt) {
        if !isOnDragProgress{
            progressView.value = Float(percent)
        }
        lbCurrentDuration.text = stringWithDuration(duration: currentSecond)
        UIUtil.configNowPlayingCenterUI()
    }

    
    func musicPlayerManagerWillPlaying() {
        playListVC?.tableView.reloadData()
    }
    
    func musicPlayerManagerDidPlaying() {
        self.imgCover.resumeRotate()
    }
    
    func musicPlayerManagerDidPaused() {
        self.imgCover.stopRotating()
    }
    
    func musicPlayerManagerDidStart() {
        let track = YXSXMPlayerGlobalControlTool.share.currentTrack
        requestJudge(voiceId: track?.trackId ?? 0)
        
        customNav.title = YXSXMPlayerGlobalControlTool.share.currentTrack?.trackTitle
        lbTotalDuration.text = stringWithDuration(duration: UInt(YXSXMPlayerGlobalControlTool.share.currentTrack?.duration ?? 0))
        
        imgCover.sd_setImage(with: URL(string: YXSXMPlayerGlobalControlTool.share.currentTrack?.coverUrlLarge ?? ""), placeholderImage: UIImage.init(named: "yxs_player_defualt_bg"))
        imgBgView.sd_setImage(with: URL(string: YXSXMPlayerGlobalControlTool.share.currentTrack?.coverUrlLarge ?? ""), placeholderImage: UIImage.init(named: "yxs_player_defualt_bg"), completed: nil)
        UIUtil.configNowPlayingCenterUI()
    }
}

