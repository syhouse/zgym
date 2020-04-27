//
//  YXSRootNavController.swift
//  EsayFreeBook
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019 mac_sy. All rights reserved.
//

import UIKit

class YXSRootNavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.delegate = self
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count != 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    
    // MARK: -屏幕旋转
    override var shouldAutorotate: Bool {
        return self.viewControllers.last?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.viewControllers.last?.supportedInterfaceOrientations ?? .portrait
    }
    
}

extension YXSRootNavController: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        ///跳转到导航栏根视图
        YXSMusicPlayerWindowView.setUpdateFrame(isNavFirstVC: self.viewControllers.first == viewController)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        if let _ = toVC as? SLVideoPlayController{
            YXSWindowPlayerControlHelper.shareHelper.pausePlayer()
        }
        if let _ = fromVC as? SLVideoPlayController{
            YXSWindowPlayerControlHelper.shareHelper.playingPlayer()
        }
        
        return nil
    }
    
}
