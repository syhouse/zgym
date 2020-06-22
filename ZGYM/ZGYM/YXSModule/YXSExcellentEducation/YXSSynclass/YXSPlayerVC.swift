//
//  YXSPlayerVC.swift
//  ZGYM
//
//  Created by yihao on 2020/4/28.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import AVKit

class YXSPlayerVC: YXSBaseViewController {

    init(player:AVPlayer) {
        super.init()
        self.player = player
    }
    
    var player: AVPlayer?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playerVC.view.bounds = self.view.bounds
        self.playerVC.view.center = self.view.center
        self.addChild(self.playerVC)
        self.view.addSubview(self.playerVC.view)
        
    }
    
    
    override func yxs_onBackClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func fullScreen(btn: UIButton) {
        if !btn.isSelected {
            forceOrientationLandscape()
        } else {
            forceOrientationPortrait()
        }
        btn.isSelected = !btn.isSelected
    }
    
    // 强制旋转横屏
    func forceOrientationLandscape() {
        let appdelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.isForceLandscape = true
        appdelegate.isForcePortrait = false
        _ = appdelegate.application(UIApplication.shared, supportedInterfaceOrientationsFor: view.window)
        let oriention = UIInterfaceOrientation.landscapeRight // 设置屏幕为横屏
        UIDevice.current.setValue(oriention.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        fullScreenBtn.snp.updateConstraints { (make) in
            make.top.equalTo(6)
        }
    }
    // 强制旋转竖屏
    func forceOrientationPortrait() {
        let appdelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.isForceLandscape = false
        appdelegate.isForcePortrait = true
        _ = appdelegate.application(UIApplication.shared, supportedInterfaceOrientationsFor: view.window)
        let oriention = UIInterfaceOrientation.portrait // 设置屏幕为竖屏
        UIDevice.current.setValue(oriention.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        fullScreenBtn.snp.updateConstraints { (make) in
            make.top.equalTo(23)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        UIApplication.shared.isStatusBarHidden = true
        YXSXMPlayerGlobalControlTool.share.pauseCompetitionPlayer()
        view.addSubview(fullScreenBtn)
        fullScreenBtn.snp.makeConstraints { (make) in
            make.left.equalTo(130)
            make.top.equalTo(23)
            make.size.equalTo(CGSize(width: 60, height: 47))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        UIApplication.shared.isStatusBarHidden = false
        YXSXMPlayerGlobalControlTool.share.resumeCompetitionPlayer()
    }
    
    lazy var playerVC: AVPlayerViewController = {
        let playerVC = AVPlayerViewController.init()
        playerVC.player = self.player
        playerVC.videoGravity = .resizeAspect
        playerVC.showsPlaybackControls = true
        return playerVC
    }()
    
    lazy var fullScreenBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#37383A", alpha: 0.8) //7B7C80 20232F
        btn.addTarget(self, action: #selector(fullScreen(btn:)), for: .touchUpInside)
        btn.layer.cornerRadius = 12
        btn.layer.masksToBounds = true
        btn.setImage(UIImage.init(named: "yxs_fullScreen"), for: .normal)
        btn.setImage(UIImage.init(named: "yxs_smallScreen"), for: .selected)
        btn.imageEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    // MARK: -屏幕旋转
    override var shouldAutorotate: Bool {
        return true
    }
//
//
//
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
}
