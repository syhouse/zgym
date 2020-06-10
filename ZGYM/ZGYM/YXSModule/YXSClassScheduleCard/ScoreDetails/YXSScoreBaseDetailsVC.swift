//
//  YXSScoreBaseDetailsVC.swift
//  ZGYM
//
//  Created by yihao on 2020/6/8.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight
import FDFullscreenPopGesture_Bell

class YXSScoreBaseDetailsVC: YXSBaseViewController {
    var examId: Int = 0
    var childrenId: Int = 0
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.yxs_gradualBackground(frame: view.frame, startColor: UIColor.yxs_hexToAdecimalColor(hex: "#B4C8FD"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#A9CDFD"), cornerRadius: 0,isRightOrientation: false)
        self.fd_prefersNavigationBarHidden = true
        view.addSubview(headerBgImageView)
        headerBgImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(242*SCREEN_SCALE)
        }
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        
        view.addSubview(customNav)
        customNav.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }
        if #available(iOS 11.0, *){
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        initUI()
        loadData()
    }
    
    func initUI() {

    }
    
    // MARK: -loadData
    func loadData(){
    
    }
    
    // MARK: - getter&stter
    lazy var customNav: YXSCustomNav = {
        let customNav = YXSCustomNav()
        customNav.leftImage = "back"
        customNav.titleLabel.textColor = kTextMainBodyColor
        customNav.hasRightButton = false
        customNav.backgroundColor = UIColor.clear
        return customNav
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.frame)
        scrollView.delegate = self
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var headerBgImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage.init(named: "yxs_score_detailsHear_one")
        return imageV
    }()
}

extension YXSScoreBaseDetailsVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > kSafeTopHeight + 64{
            customNav.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
            customNav.backImageButton.setMixedImage(MixedImage(normal: "back", night: "yxs_back_white"), forState: .normal)
            customNav.titleLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        }else{
            customNav.mixedBackgroundColor = MixedColor(normal: UIColor.clear, night: UIColor.clear)
            customNav.backImageButton.setMixedImage(MixedImage(normal: "back", night: "back"), forState: .normal)
            customNav.titleLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kTextMainBodyColor)
        }
    }
}


// MARK: -HMRouterEventProtocol
extension YXSScoreBaseDetailsVC: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:
            break
        }
    }
}
