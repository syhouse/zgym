//
//  YXSScoreNumParentDetailsVC.swift
//  ZGYM
//
//  Created by yihao on 2020/6/1.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight
import FDFullscreenPopGesture_Bell
import ObjectMapper

/// 家长成绩学科 （单/多）
enum ParentScoreDisciplinaryType: String {
    case Multitude_Disciplinary//多科成绩
    case Singular_Disciplinary//单科成绩
}

class YXSScoreNumParentDetailsVC: YXSBaseViewController {
    var listModel: YXSScoreListModel?
    var detailsModel: YXSScoreDetailsModel?
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
        view.yxs_gradualBackground(frame: view.frame, startColor: UIColor.yxs_hexToAdecimalColor(hex: "#B4C8FD"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#A9CDFD"), cornerRadius: 0,isRightOrientation: false)
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
        loadData()
    }
    
    func initUI() {
        self.scrollView.addSubview(headerBgImageView)
        self.scrollView.addSubview(headerView)
        self.scrollView.addSubview(chartView)
        self.scrollView.addSubview(commentView)
        headerBgImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(242*SCREEN_SCALE)
        }
        
        headerView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(64)
        }
        chartView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(headerView.snp_bottom).offset(15)
        }
        commentView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(chartView.snp_bottom).offset(15)
            make.bottom.equalTo(-30)
        }
        
        chartView.formHeaderTitle.text = "得分分布情况"
    }
    
    // MARK: -loadData
    func loadData(){
        YXSEducationScoreParentDetailsRequest.init(examId: listModel?.examId ?? 0, childrenId: NSObject.init().yxs_user.currentChild?.id ?? 0).request({ (json) in
            print("12321")
            let model = Mapper<YXSScoreDetailsModel>().map(JSONObject:json.object) ?? YXSScoreDetailsModel.init(JSON: ["": ""])!
            self.detailsModel = model
            self.headerView.setModel(model: model)
        }) { (msg, code) in
             MBProgressHUD.yxs_showMessage(message: msg)
        }
    
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
        return scrollView
    }()
    
    lazy var headerBgImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage.init(named: "yxs_score_detailsHear_one")
        return imageV
    }()
    
    lazy var headerView: YXSScoreParentHeaderView = {
        let view = YXSScoreParentHeaderView.init()
        return view
    }()
    
    lazy var chartView: YXSScoreChildBarChartView = {
        let chartView = YXSScoreChildBarChartView.init(isHaveComment: true,isShowLookSubjects: true)
        return chartView
    }()
    
    lazy var commentView: YXSScoreTeacherCommentView = {
        let view = YXSScoreTeacherCommentView.init()
        return view
    }()
    
}

extension YXSScoreNumParentDetailsVC: UIScrollViewDelegate{
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
extension YXSScoreNumParentDetailsVC: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:
            break
        }
    }
}
