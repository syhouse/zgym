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
//        let lbl = UILabel.init(frame: CGRect(x: 40, y: 100, width: 100, height: 80))
//        lbl.text = "12321321321"
//        view.addSubview(lbl)
//        self.yxs_setNavBack()
        
        self.playerVC.view.bounds = self.view.bounds
        self.playerVC.view.center = self.view.center
        self.addChild(self.playerVC)
        self.view.addSubview(self.playerVC.view)
    }
    
    
    override func yxs_onBackClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        UIApplication.shared.isStatusBarHidden = true
        YXSXMPlayerGlobalControlTool.share.pauseCompetitionPlayer()
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
    
    // MARK: -屏幕旋转
    override var shouldAutorotate: Bool {
        return true
    }
    

    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
}
