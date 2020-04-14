//
//  YXSBaseViewController.swift
//  EsayFreeBook
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019 mac_sy. All rights reserved.
//

import UIKit
import IQKeyboardManager
import NightNight

class YXSBaseViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage();
        
        //导航栏设置 1
        navigationController?.navigationBar.setBackgroundImage(NightNight.theme == .night ? UIImage.yxs_image(with: kNightForegroundColor) : UIImage.yxs_image(with: UIColor.white), for: .default)
        
        //导航栏设置2  有问题
//        navigationController?.navigationBar.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
//        navigationController?.navigationBar.mixedBarTintColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)

        
        navigationController?.navigationBar.mixedTitleTextAttributes = [
            NNForegroundColorAttributeName: MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        ]
        IQKeyboardManager.shared().isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.titleTextAttributes = nil
        
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.mixedBackgroundColor = MixedColor.init(normal: UIColor.white, night: kNightBackgroundColor)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // MARK: -设置通用返回按钮
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            yxs_setNavBack()
        }
    }
    
    // MARK: -屏幕旋转
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
