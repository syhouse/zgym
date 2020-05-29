//
//  YXSScoreNumTeacherDetailsVC.swift
//  ZGYM
//
//  Created by yihao on 2020/5/27.
//  Copyright © 2020 zgym. All rights reserved.
//  成绩详情分数制（老师）

import Foundation
import NightNight
import FDFullscreenPopGesture_Bell

class YXSScoreNumTeacherDetailsVC: YXSBaseViewController {
    
    var listModel: YXSScoreListModel?
    init(model:YXSScoreListModel) {
        super.init()
        self.listModel = model
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
        view.yxs_gradualBackground(frame: view.frame, startColor: UIColor.yxs_hexToAdecimalColor(hex: "#B4C8FD"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#A9CDFD"), cornerRadius: 0,isRightOrientation: false)
//        view.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#9DC5FA")
        self.fd_prefersNavigationBarHidden = true
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
        customNav.title = listModel?.examName
        initUI()
    }
    
    func initUI() {
        self.scrollView.addSubview(headerBgImageView)
        self.scrollView.addSubview(headerView)
        self.scrollView.addSubview(contentView)
        headerBgImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(242*SCREEN_SCALE)
        }
        headerView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(headerBgImageView.snp_bottom).offset(-16)
            make.height.equalTo(75)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(370*SCREEN_SCALE)
            make.top.equalTo(headerView.snp_bottom).offset(8)
        }
    }
    
    // MARK: - getter&stter
    lazy var customNav: YXSCustomNav = {
        let customNav = YXSCustomNav()
        customNav.leftImage = "back"
        customNav.titleLabel.textColor = UIColor.black
        customNav.hasRightButton = false
        customNav.backgroundColor = UIColor.clear
        return customNav
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.frame)
        return scrollView
    }()
    
    lazy var headerBgImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage.init(named: "yxs_score_detailsHear")
        return imageV
    }()
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.addSubview(self.headerClassNameLbl)
        view.addSubview(self.headerExmTimeLbl)
        self.headerClassNameLbl.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(17)
            make.height.equalTo(20)
        }
        self.headerExmTimeLbl.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-17)
            make.height.equalTo(20)
        }
        
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    /// 班级名称
    lazy var headerClassNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")
        return lbl
    }()
    /// 考试时间
    lazy var headerExmTimeLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return lbl
    }()
    
    
}


// MARK: -HMRouterEventProtocol
extension YXSScoreNumTeacherDetailsVC: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:
            break
        }
    }
}
