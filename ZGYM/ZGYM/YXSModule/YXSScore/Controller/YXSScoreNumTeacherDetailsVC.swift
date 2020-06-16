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
import ObjectMapper

class YXSScoreNumTeacherDetailsVC: YXSBaseViewController {
    
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
        scrollView.addSubview(contentBgView)
        contentBgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
        }
        view.addSubview(self.scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
//            make.edges.equalTo(0)
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
        contentBgView.addSubview(headerBgImageView)
        contentBgView.addSubview(headerView)
        contentBgView.addSubview(contentView)
        contentBgView.addSubview(lookAllScoreBtn)
        contentBgView.addSubview(visibleView)
        contentBgView.addSubview(leftConnectionImgV)
        contentBgView.addSubview(rightConnectionImgV)
        
        headerBgImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(242)
        }
        headerBgImageView.layoutIfNeeded()
        print("123")
        headerView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(headerBgImageView.snp_bottom).offset(-16)
            make.height.equalTo(75)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(420) //370
            make.top.equalTo(headerView.snp_bottom).offset(8)
        }
        leftConnectionImgV.snp.makeConstraints { (make) in
            make.left.equalTo(headerView.snp_left).offset(15)
            make.top.equalTo(headerView.snp_top).offset(33)
            make.width.equalTo(10)
            make.height.equalTo(75)
        }
        rightConnectionImgV.snp.makeConstraints { (make) in
            make.right.equalTo(headerView.snp_right).offset(-15)
            make.top.equalTo(leftConnectionImgV)
            make.width.height.equalTo(leftConnectionImgV)
        }
        
        lookAllScoreBtn.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp_bottom).offset(20)
            make.left.equalTo(17.5)
            make.height.equalTo(20)
            make.bottom.equalTo(-30)
        }
        
        visibleView.snp.makeConstraints { (make) in
            make.centerY.equalTo(lookAllScoreBtn)
            make.right.equalTo(-15)
            make.height.equalTo(40)
        }
    }
    
    // MARK: - loadData
    func loadData(){
        YXSEducationScoreTeacherDetailsRequest.init(examId: listModel?.examId ?? 0).request({ (json) in
            let model = Mapper<YXSScoreDetailsModel>().map(JSONObject:json.object) ?? YXSScoreDetailsModel.init(JSON: ["": ""])!
            self.detailsModel = model
            self.headerClassNameLbl.text = model.className ?? ""
            if let dateStr = model.creationTime, dateStr.count > 0 {
                self.headerExmTimeLbl.text = "发布时间：\(dateStr.yxs_Date().toString(format: .custom("yyyy/MM/dd")))"
            }
            
            self.highestScoreLbl.text = "\(model.highestScore?.cleanZero ?? "")分"
            self.averageScoreLbl.text = "\(model.averageScore?.cleanZero ?? "")分"
            
            self.setBarChartData(list: model.totalStatement ?? [YXSScoreTotalStatementModel]())
            UIUtil.yxs_setLabelAttributed(self.visibleView.textLabel, text: [String(model.readNumber ?? 0), "/\(model.number ?? 0)"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF"), UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF")])

        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    
    }
    
    func setBarChartData(list:[YXSScoreTotalStatementModel]) {
        let xArr: NSMutableArray = NSMutableArray.init()
        let yArr: NSMutableArray = NSMutableArray.init()
        var maxY: Int = 0
        var maxNumStr: String = ""
        var maxAllNum: Int = 0
        for model in list {
            xArr.add(model.branch ?? "")
            yArr.add("\(String(model.quantity ?? 0))人")
            if let quantity = model.quantity, quantity > maxY {
                maxY = quantity
            }
        }
        for model in list {
            if let quantity = model.quantity, quantity == maxY {
                if maxNumStr.count > 0 {
                    maxNumStr.append("和")
                }
                maxNumStr.append("\(model.branch ?? "")分")
                maxAllNum += quantity
            }
        }
        UIUtil.yxs_setLabelAttributed(self.maxNumberLbl, text: ["人数最多的分段是:", "\(maxNumStr),共\(String(maxAllNum))人"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")])
//        self.maxNumberLbl.text = "人数最多的分段是:\(maxNumStr),共\(String(maxAllNum))人"
        barChartView.xValuesArr = xArr
        barChartView.yValuesArr = yArr
        if maxY < 4 {
            barChartView.yScaleValue = CGFloat(1)
        } else {
            barChartView.yScaleValue = CGFloat(maxY / 4)
        }
        let count: Int = xArr.count
        let gapWidth = ((Int(SCREEN_WIDTH) - 90) - 35 * count) / (count+1)
        barChartView.gapWidth = CGFloat(gapWidth)
        barChartView.reloadData()
    }
    
    // MARK: - Action
    @objc func lookAllScoreClick() {
        let vc = YXSScoreAllChildListVC.init(detailsModel: self.detailsModel ?? YXSScoreDetailsModel.init(JSON: ["": ""])!)
        self.navigationController?.pushViewController(vc)
        
    }
    
    @objc func visibleClick() {
        let vc = YXSScoreContainerVC()
        vc.detailModel = self.listModel
//        vc.detailModel = homeModel
//        vc.detailModel?.onlineCommit = model?.onlineCommit
//        vc.backClickBlock = { [weak self]()in
//            guard let weakSelf = self else {return}
//            weakSelf.refreshData()
//        }
        self.navigationController?.pushViewController(vc)
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
    
    lazy var contentBgView: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        return view
    }()
    
    lazy var headerBgImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage.init(named: "yxs_score_detailsHear")
        return imageV
    }()
    
    lazy var leftConnectionImgV: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage.init(named: "yxs_score_detailsConnect")
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
    
    lazy var rightConnectionImgV: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage.init(named: "yxs_score_detailsConnect")
        imageV.contentMode = .scaleAspectFit
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
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.top.equalTo(17)
            make.height.equalTo(20)
        }
        self.headerExmTimeLbl.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.right.equalTo(-25)
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
        view.addSubview(contentBottomView)
        contentBottomView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(SCREEN_WIDTH - 60)
            make.bottom.equalTo(-25)
            make.height.equalTo(92)
        }
        view.addSubview(barChartView)
        barChartView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(contentBottomView.snp_top).offset(-20)
            make.right.equalTo(-15)
            make.top.equalTo(60)
        }
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
    /// 发布时间
    lazy var headerExmTimeLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return lbl
    }()
    
    lazy var lookAllScoreBtn: YXSCustomImageControl = {
        let view = YXSCustomImageControl(imageSize: CGSize(width: 10, height: 17), position: YXSImagePositionType.right)
        view.locailImage = "yxs_score_rightarrow_white"
        view.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF"), night: UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF"))
        view.font = UIFont.systemFont(ofSize: 15)
        view.addTarget(self, action: #selector(lookAllScoreClick), for: .touchUpInside)
        view.title = "查看全班得分情况"
        return view
    }()
    
    lazy var visibleView: YXSCustomImageControl = {
        let visibleView = YXSCustomImageControl.init(imageSize: CGSize.init(width: 18, height: 18), position: YXSImagePositionType.left, padding: 7)
        visibleView.locailImage = "visible_white"
        visibleView.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF"), night: UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF"))
        visibleView.font = UIFont.systemFont(ofSize: 13)
        visibleView.addTarget(self, action: #selector(visibleClick), for: .touchUpInside)
        return visibleView
    }()
    
    lazy var contentBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F7F9FD")
        let lblOne = UILabel()
        lblOne.text = "班级最高分:"
        lblOne.font = UIFont.systemFont(ofSize: 15)
        lblOne.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        view.addSubview(lblOne)
        view.addSubview(self.highestScoreLbl)
        
        let lblTwo = UILabel()
        lblTwo.text = "平均分:"
        lblTwo.font = UIFont.systemFont(ofSize: 15)
        lblTwo.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        view.addSubview(lblTwo)
        view.addSubview(self.averageScoreLbl)
        view.addSubview(self.maxNumberLbl)
        
        lblOne.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(20)
            make.width.equalTo(85)
            make.height.equalTo(17)
        }
        self.highestScoreLbl.snp.makeConstraints { (make) in
            make.left.equalTo(lblOne.snp_right)
            make.centerY.equalTo(lblOne)
            make.height.equalTo(17)
        }
        
        self.averageScoreLbl.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(lblOne)
            make.height.equalTo(17)
        }
        lblTwo.snp.makeConstraints { (make) in
            make.right.equalTo(self.averageScoreLbl.snp_left)
            make.centerY.equalTo(lblOne)
            make.width.equalTo(55)
            make.height.equalTo(17)
        }

        self.maxNumberLbl.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(self.highestScoreLbl.snp_bottom).offset(10)
            make.right.equalTo(-20)
            make.height.equalTo(40)
        }
        
        return view
    }()
    
    lazy var highestScoreLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 19)
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")
        return lbl
    }()
    
    lazy var averageScoreLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 19)
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")
        return lbl
    }()
    
    lazy var maxNumberLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.numberOfLines = 2
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#222222")
        return lbl
    }()
    
    lazy var barChartView: SSWBarChartView = {
        let chartView = SSWBarChartView.init(chartType: SSWChartsType.bar)
//        chartView?.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9")
        chartView?.barCorlor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")
        chartView?.yAxisCount = 5
        chartView?.yScaleValue = 4
        chartView?.barWidth = 35
        let gapWidth = ((SCREEN_WIDTH - 90) - 35 * 5) / 6
        chartView?.gapWidth = gapWidth  //30*SCREEN_SCALE
        return chartView!
    }()
}

extension YXSScoreNumTeacherDetailsVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0{
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
