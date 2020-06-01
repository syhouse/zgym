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
        self.scrollView.addSubview(contentView)
        self.scrollView.addSubview(lookAllScoreBtn)
        self.scrollView.addSubview(visibleView)
        self.scrollView.addSubview(leftConnectionImgV)
        self.scrollView.addSubview(rightConnectionImgV)
        
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
            make.height.equalTo(570*SCREEN_SCALE) //370
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
        }
    }
    
    // MARK: -loadData
    func loadData(){
        YXSEducationScoreTeacherDetailsRequest.init(examId: listModel?.examId ?? 0).request({ (json) in
            print("123")
            let model = Mapper<YXSScoreDetailsModel>().map(JSONObject:json.object) ?? YXSScoreDetailsModel.init(JSON: ["": ""])!
            self.detailsModel = model
            self.headerClassNameLbl.text = model.className ?? ""
            if let dateStr = model.creationTime, dateStr.count > 0 {
                self.headerExmTimeLbl.text = "考试时间：\(dateStr.yxs_Date().toString(format: .custom("yyyy/MM/dd")))"
            }
            self.highestScoreLbl.text = "\(String(model.highestScore ?? 0))分"
            self.averageScoreLbl.text = "\(String(model.averageScore ?? 0))分"
            self.maxNumberLbl.text = "999-999分，共99人"
            UIUtil.yxs_setLabelAttributed(self.visibleView.textLabel, text: [String(model.readNumber ?? 0), "/\(model.number ?? 0)"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF"), UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF")])
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
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
    
    lazy var lookAllScoreBtn: YXSCustomImageControl = {
        let view = YXSCustomImageControl(imageSize: CGSize(width: 10, height: 17), position: YXSImagePositionType.right)
        view.locailImage = "yxs_score_rightarrow_white"
        view.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF"), night: UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF"))
        view.font = UIFont.systemFont(ofSize: 15)
        view.title = "查看全班得分情况"
        return view
    }()
    
    lazy var visibleView: YXSCustomImageControl = {
        let visibleView = YXSCustomImageControl.init(imageSize: CGSize.init(width: 18, height: 18), position: YXSImagePositionType.left, padding: 7)
        visibleView.font = UIFont.systemFont(ofSize: 13)
        visibleView.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF"), night: UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF"))
        visibleView.locailImage = "visible_white"
        visibleView.isUserInteractionEnabled = false
        return visibleView
    }()
    
    lazy var contentBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F7F9FD")
        let lblOne = UILabel()
        lblOne.text = "班级最高分:"
        lblOne.font = UIFont.systemFont(ofSize: 15)
        lblOne.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#222222")
        view.addSubview(lblOne)
        view.addSubview(self.highestScoreLbl)
        
        let lblTwo = UILabel()
        lblTwo.text = "平均分:"
        lblTwo.font = UIFont.systemFont(ofSize: 15)
        lblTwo.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#222222")
        view.addSubview(lblTwo)
        view.addSubview(self.averageScoreLbl)
        
        let lblThree = UILabel()
        lblThree.text = "人数最多的分段是:"
        lblThree.font = UIFont.systemFont(ofSize: 15)
        lblThree.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#222222")
        view.addSubview(lblThree)
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
        lblThree.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(-20)
            make.width.equalTo(130)
            make.height.equalTo(17)
        }
        self.maxNumberLbl.snp.makeConstraints { (make) in
            make.left.equalTo(lblThree.snp_right)
            make.centerY.equalTo(lblThree)
            make.right.equalTo(-20)
            make.height.equalTo(17)
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
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#222222")
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
