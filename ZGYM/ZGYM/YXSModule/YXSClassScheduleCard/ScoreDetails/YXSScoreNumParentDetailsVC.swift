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
    }
    
    // MARK: -loadData
    func loadData(){
        YXSEducationScoreTeacherDetailsRequest.init(examId: listModel?.examId ?? 0).request({ (json) in
            let model = Mapper<YXSScoreDetailsModel>().map(JSONObject:json.object) ?? YXSScoreDetailsModel.init(JSON: ["": ""])!
            self.detailsModel = model

//            self.barChartView.xValuesArr = ["0-60","61-70","71-80","81-90","91-100"]
//            self.barChartView.yValuesArr = ["3人","10人","15人","9人","4人"]
//            self.barChartView.yAxisCount = 6
//            self.barChartView.yScaleValue = 4
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
        imageV.image = UIImage.init(named: "yxs_score_detailsHear")
        return imageV
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
