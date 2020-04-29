//
//  SLPunchCardDetialController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/27.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import FDFullscreenPopGesture_Bell
import NightNight
import JXCategoryView

///headerView滑出屏幕
let kHomeHeaderLeaverScreenNotification = "HomeHeaderLeaverScreenNotification"

///headerView滑进屏幕
let kHomeHeaderInScreenNotification = "HomeHeaderInScreenNotification"

var headerHeight = 64 + kSafeTopHeight + 333

class YXSPunchCardDetialController: YXSBaseTableViewController {
    // MARK: - property
    /// 是否可以滚动
    private var canScroll :Bool = true
    
    /// 子试图是否可以滚动
    private var subCanScroll :Bool = true
    
    /// 第一次请求数据更新UI
    private var isFristConfigUI :Bool = true
    
    private var punchModel: YXSPunchCardModel!
    private var childId: Int?
    private var clockInId: Int
    private var classId: Int
    public var pageController: YXSPunchCardDetialPageController!
    
    ///请求互动消息
    private var loadMessageRequest: Bool = true
    
    ///请求班级之星排行榜
    private var loadClassStartHistoryRequest: Bool = true
    private var topHistoryModel: YXSClassStarTopHistoryModel?
    
    public var messageModel: YXSPunchCardMessageTipsModel?
    
    let queue = DispatchQueue.global()
    let group = DispatchGroup()
    
    // MARK: - init
    
    /// 老师端打卡详情初始化方法
    /// - Parameters:
    ///   - clockInId: 打卡id
    ///   - classId: 班级id
    init(clockInId: Int,classId: Int) {
        self.clockInId = clockInId
        self.classId = classId
        super.init()
        tableViewIsGroup = true
        showBegainRefresh = false
        hasRefreshHeader = false
    }
    
    /// 家长端打卡详情初始化方法
    /// - Parameters:
    ///   - clockInId: 打卡id
    ///   - childId: 班级id
    ///   - classId: 孩子id
    convenience init(clockInId: Int, childId: Int?,classId: Int){
        self.init(clockInId: clockInId,classId: classId)
        self.childId = childId
        UIUtil.yxs_reduceHomeRed(serviceId: clockInId, childId: childId ?? 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - leftCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        
        yxs_initUI()
        //自定义
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMsg(_:)), name: NSNotification.Name(rawValue: kHomeHeaderInScreenNotification), object: nil)
        //家长打卡撤销
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name.init(rawValue: kOperationStudentCancelPunchCardNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMessageData), name: NSNotification.Name.init(rawValue: kChatCallRefreshPunchCardNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        YXSSSAudioListPlayer.sharedInstance.stopPlayer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func yxs_initUI(){
        self.view.addSubview(scrollview)
        self.view.addSubview(customNav)
        customNav.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }
        
        scrollview.snp.makeConstraints { (make) in
            make.top.equalTo(kSafeTopHeight + 64)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(YXSPersonDataModel.sharePerson.personRole == .TEACHER ? 0 : -60)
        }
        
        //存在缓存数据先展示
        self.punchModel = YXSCacheHelper.yxs_getCachePunchCardDetailTask(clockInId: clockInId, childrenId: childId)
        if self.punchModel.clockInId == nil{
            self.punchModel.clockInId = clockInId
            self.punchModel.childrenId = self.childId
        }
        
        configUI()
    }
    
    
    /// 第一次请求成功配置UI
    func configUI(){
        isFristConfigUI = false
        
        scrollview.addSubview(headerView)
        
        headerView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(scrollview)
        }
        
        pageController = YXSPunchCardDetialPageController.init(punchModel: punchModel)
        scrollview.addSubview(pageController.view)
        pageController.view.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp_bottom)
            make.left.right.bottom.equalTo(scrollview)
            make.width.equalTo(scrollview)
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                make.height.equalTo(SCREEN_HEIGHT - kSafeTopHeight - 64 - kSafeBottomHeight)
            }else{
                make.height.equalTo(SCREEN_HEIGHT - kSafeTopHeight - 64 - 60 - kSafeBottomHeight)
            }
        }
        self.addChild(pageController)
        
        if YXSPersonDataModel.sharePerson.personRole == .PARENT{
            self.view.addSubview(punchCardFooter)
            punchCardFooter.snp.makeConstraints { (make) in
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(60 + kSafeBottomHeight)
            }
        }
        
        updateUI()
    }
    
    
    /// 更新 punchModel
    func updateUI(){
        self.headerView.setHeaderModel(punchModel, messageModel: messageModel)
        
        headerView.layoutIfNeeded()
        
        pageController.punchModel = punchModel

        if YXSPersonDataModel.sharePerson.personRole == .PARENT{
           if let calendarModel = punchCardFooter.calendarModel{
            if let clockInDateStatusResponseList = punchModel.clockInDateStatusResponseList{
                for model in clockInDateStatusResponseList{
                    if calendarModel.responseModel?.clockInTime == model.clockInTime{
                        if calendarModel.toDayDateCompare == .Small{
                            if  model.state == 10{
                                calendarModel.status = .beforeNotSign
                                calendarModel.text = "未"
                            }else{
                                calendarModel.status = .beforeHasSign
                            }
                        }
                    }
                }
            }
                
            }
            punchCardFooter.setFooterModel(punchModel)
        }
        
        updateHeaderHeight()
    }
    
    ///更新高度
    func updateHeaderHeight(){
        headerHeight = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var contentHeight: CGFloat = 0
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            contentHeight = SCREEN_HEIGHT - kSafeTopHeight - 64 - kSafeBottomHeight
        }else{
            contentHeight = SCREEN_HEIGHT - kSafeTopHeight - 64 - 60 - kSafeBottomHeight
        }
//        scrollview.contentSize = CGSize.init(width: 0, height: headerHeight + contentHeight)
    }
    
    // MARK: - public
    
    /// 日历vc切换日历
    /// - Parameter calendarModel: l日历model
    public func selectCalendarModel(_ calendarModel: YXSCalendarModel?, isCurruntCalendarVC: Bool = true){
        if YXSPersonDataModel.sharePerson.personRole == .PARENT{
            punchCardFooter.isCurruntCalendarVC = true
            punchCardFooter.calendarModel = calendarModel
        }
    }
    
    // MARK: - loadData
    @objc func loadData(){
        group.enter()
        queue.async {
            DispatchQueue.main.async {
                  self.yxs_loadTaskData()
              }
            
        }
        
        if loadClassStartHistoryRequest{
            group.enter()
            DispatchQueue.main.async {
                self.yxs_loadClassStarTopHistoryData()
            }
        }
        
        if loadMessageRequest{
            group.enter()
            DispatchQueue.main.async {
                self.yxs_loadMessageData()
            }
        }
        
        group.notify(queue: queue){
            DispatchQueue.main.async {
                self.isFristConfigUI ? self.configUI() : self.updateUI()
                YXSCacheHelper.yxs_cachePunchCardDetailTask(model: self.punchModel, clockInId: self.clockInId, childrenId: self.childId)
                self.loadMessageRequest = false
            }
        }
    }
    
    @objc func yxs_loadTaskData(){
        if !YXSPersonDataModel.sharePerson.isNetWorkingConnect{
            self.punchModel = YXSCacheHelper.yxs_getCachePunchCardDetailTask(clockInId: clockInId, childrenId: childId)
            self.punchModel.childrenId = childId
            return
        }
        
        var request: YXSBaseRequset!
        if let childrenId = childId{
            request = YXSEducationClockInParentTaskDetailRequest.init(clockInId: clockInId, childrenId: childrenId, currentPage: curruntPage)
        }else{
            request = YXSEducationClockInTeacherTaskDetailRequest.init(clockInId: clockInId)
        }
        request.request({ (model: YXSPunchCardModel) in
            self.punchModel = model
            if YXSPersonDataModel.sharePerson.personRole == .PARENT{
                self.punchModel.classId = self.classId
            }
            self.punchModel.childrenId = self.childId
            self.group.leave()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
            self.group.leave()
        }
    }
    
    @objc func yxs_loadClassStarTopHistoryData(){
        YXSEducationClassStarTopHistoryRequest.init(classId: classId).request({ (topHistoryModel: YXSClassStarTopHistoryModel) in
            self.loadClassStartHistoryRequest = false
            self.topHistoryModel = topHistoryModel
            self.group.leave()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
            self.group.leave()
        }
    }
    
    @objc func yxs_loadMessageData(){
        YXSEducationClockInUnreadNoticeCountRequest.init(clockInId: clockInId).request({ (model: YXSPunchCardMessageTipsModel) in
            self.messageModel = model
            self.group.leave()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
            self.group.leave()
        }
    }
    
    
    // MARK: - private
    func yxs_pushPublishVC(patchTime: String?, patchTimes: [String]?){
        var vc: YXSPunchCardPublishController!
        if let patchTime = patchTime{
            vc = YXSPunchCardPublishController.init(patchCardTime: patchTime, punchCardModel: punchModel)
        }else if let patchTimes = patchTimes{
            vc = YXSPunchCardPublishController.init(patchCardTimeList: patchTimes, punchCardModel: punchModel)
        }else{
            vc = YXSPunchCardPublishController.init(punchCardModel: punchModel)
        }
        self.navigationController?.pushViewController(vc)
        vc.punchCardComplete = {[weak self](requestModel, shareModel)
            in
            guard let strongSelf = self else { return }
            YXSPunchCardShareView.showAlert(shareModel: shareModel) {(image) in
                YXSShareTool.showCommonShare(shareModel: YXSShareModel.init(image: image))
            }
            //从日历跳转过去的打卡
            if patchTime != nil{
                strongSelf.punchCardFooter.isCurruntCalendarVC = true
            }
            
            strongSelf.loadData()
        }
    }
    
    
    
    // MARK: -getter
    lazy var headerView: YXSPunchCardDetialHeaderView = {
        let headerView = YXSPunchCardDetialHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        return headerView
    }()
    
    lazy var scrollview: YXSArtScrollView = {
        let view = YXSArtScrollView()
        view.delegate = self
        if #available(iOS 11.0, *){
            view.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        return view
    }()
    
    lazy var customNav: YXSCustomNav = {
        let customNav = YXSCustomNav()
        customNav.title = "打卡任务"
        customNav.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        customNav.backImageButton.setMixedImage(MixedImage(normal: "back", night: "yxs_back_white"), forState: .normal)
        customNav.titleLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        customNav.shareButton.setMixedImage(MixedImage(normal: "yxs_punchCard_share", night: "yxs_punchCard_share_white"), forState: .normal)
        customNav.titleLabel.snp.remakeConstraints { (make) in
            make.centerY.equalTo(customNav.backImageButton)
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.height.equalTo(44)
        }
        return customNav
    }()
    
    private lazy var punchCardFooter: YXSGoToPunchCardFooterView = {
        let view = YXSGoToPunchCardFooterView()
        view.footerBlock = {
            [weak self](type, patchTime) in
            guard let strongSelf = self else { return }
            
            switch type{
            case .goPunchCard:
                strongSelf.yxs_pushPublishVC(patchTime: nil,patchTimes: nil)
            case .goPatchSelectDay:
                var patchTimes = [String]()
                if let clockInDateStatusResponseList = strongSelf.punchModel.clockInDateStatusResponseList{
                    for model in clockInDateStatusResponseList{
                        if model.state == 10 && strongSelf.yxs_isToDay(compareDate: model.clockInTime?.date(withFormat: kCommonDateFormatString)) == .Big{
                            patchTimes.append(model.clockInTime ?? "")
                        }
                    }
                }
                
                strongSelf.yxs_pushPublishVC(patchTime: nil,patchTimes: patchTimes)
            case .goPatchAppointDay:
                strongSelf.yxs_pushPublishVC(patchTime: patchTime,patchTimes: nil)
            }
            
            
        }
        return view
    }()
}

extension YXSPunchCardDetialController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxOffsetY: CGFloat = headerHeight
        let offsetY = scrollView.contentOffset.y
        SLLog("offsetY=\(offsetY)")
        if offsetY >= maxOffsetY{
            scrollView.contentOffset = CGPoint(x: 0, y: maxOffsetY)
            //          print("滑动到顶端")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kHomeHeaderLeaverScreenNotification), object: nil, userInfo: [
                "canScroll": "1"
            ])
            if subCanScroll{
                canScroll = false
            }
            scrollView.showsVerticalScrollIndicator = false

            customNav.titleLabel.textAlignment = .left
            customNav.title = punchModel.title ?? ""
            
            scrollview.isScrollEnabled = false
        } else {
            customNav.titleLabel.textAlignment = .center
            customNav.title = "打卡任务"
            scrollView.showsVerticalScrollIndicator = true
            if canScroll == false {
                print("_canScroll:===\(canScroll)")
                scrollView.contentOffset = CGPoint(x: 0, y: maxOffsetY)
            }
        }
    }
    
    
    // MARK: - scrollView
    @objc func acceptMsg(_ notification: Notification?) {
        let userInfo = notification?.userInfo
        let canScroll = userInfo?["canScroll"] as? String
        if (canScroll == "1") {
            self.canScroll = true
            scrollview.isScrollEnabled = true
        }
        
        let subCanScroll = userInfo?["subCanScroll"] as? String
        if (subCanScroll == "0") {
            self.subCanScroll = false
        }
    }
    
    /// 刷新消息
    @objc func reloadMessageData(){
        YXSEducationClockInUnreadNoticeCountRequest.init(clockInId: clockInId).request({ (model: YXSPunchCardMessageTipsModel) in
            self.messageModel = model
            self.headerView.setHeaderModel(self.punchModel, messageModel: model)
            
            self.updateHeaderHeight()
        }) { (msg, code) in
        }
        
    }
}

// MARK: -YXSRouterEventProtocol
extension YXSPunchCardDetialController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?){
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        case kYXSCustomNavShareEvent:
            let requestModel: HMRequestShareModel = HMRequestShareModel.init(clockInId: punchModel.clockInId ?? 0, childrenId: childId)
            let isTeacher = YXSPersonDataModel.sharePerson.personRole == .TEACHER
            UIUtil.yxs_shareLink(requestModel: requestModel, shareModel: YXSShareModel.init(title: isTeacher ? "打卡任务" : "我在优学业坚持打卡\(punchModel.clockInDayCount ?? 0)天", descriptionText: punchModel.title ?? "", link: ""))
        case kYXSPunchCardDetialHeaderViewUpdateHeaderViewEvent:
            self.updateHeaderHeight()
        case kYXSPunchCardDetialHeaderViewRemindEvent:
            let vc = YXSPunchCardMembersListViewController.init(clockInId: punchModel.clockInId ?? 0,classId: classId ,punchM: punchModel)
            self.navigationController?.pushViewController(vc)
        case kYXSPunchCardDetialHeaderViewRankEvent:
            let vc = YXSPunchCardStatisticsController.init(punchCardModel: punchModel)
            vc.title = "打卡排行榜"
            self.navigationController?.pushViewController(vc)
        case kFriendsCircleMessageViewGoMessageEvent:
            let vc = YXSCommonMessageListController.init(clockId: punchModel.clockInId ?? 0, classId: punchModel.classId ?? 0,  isMyPublish: punchModel.promulgator ?? false, topHistoryModel: topHistoryModel)
            vc.loadSucess = {
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.headerView.setHeaderModel(strongSelf.punchModel, messageModel: strongSelf.messageModel)
            }
            self.navigationController?.pushViewController(vc)
        default:
            print("")
        }
    }
}

class YXSArtScrollView: UIScrollView{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}

