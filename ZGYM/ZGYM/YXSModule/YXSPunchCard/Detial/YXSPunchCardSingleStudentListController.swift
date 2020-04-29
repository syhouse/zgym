//
//  SLPunchCardSingleStudentListController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/31.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import JXCategoryView
import NightNight

let kYXSPunchCardSingleStudentCalendarListControllerIsShowEvent = "SLPunchCardSingleStudentCalendarListControllerIsChangeShowEvent"

enum YXSSingleStudentListType: String{
    ///全部打卡
    case all
    ///优秀打卡
    case good
    ///日历打卡
    case calendar
    ///我的打卡
    case myPunchCard
    ///单个学生打卡
    case studentPunchCardList
    ///学生打卡单个详情
    case detial
    ///单人历史优秀打卡
    case goodHistory
}
// MARK: - JXCategoryListContentViewDelegate
class YXSPunchCardSingleStudentListController: YXSPunchCardSingleStudentBaseListController,JXCategoryListContentViewDelegate{
    
    func listView() -> UIView! {
        return self.view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.snp.remakeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if canScroll == false{
            scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
        
        let offsetY = scrollView.contentOffset.y
        //        print("TableView的偏移量：\(offsetY)")
        if offsetY < 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kHomeHeaderInScreenNotification), object: nil, userInfo: [
                "canScroll": "1"
            ])
        }
        
    }
    
    override func addNotification() {
        super.addNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMsg), name: NSNotification.Name(rawValue: kHomeHeaderLeaverScreenNotification), object: nil)
    }
    
    @objc func acceptMsg(_ notification: Notification?) {
        let notificationName: String = (notification?.name)!.rawValue
        if (notificationName == kHomeHeaderLeaverScreenNotification) {
            let userInfo = notification?.userInfo
            let canScroll = userInfo?["canScroll"] as? String
            if (canScroll == "1") {
                self.canScroll = true
                tableView.showsVerticalScrollIndicator = true
            }
        } else if (notificationName == kHomeHeaderInScreenNotification) {
            //        self.tableView.contentOffset = CGPointZero;
            self.canScroll = false
            tableView.showsVerticalScrollIndicator = false
        }
    }
}

class YXSPunchCardSingleStudentBaseListController: YXSBaseTableViewController{
    public var top3Model: YXSClassStarMapTop3?{
        didSet{
            tableView.reloadData()
        }
    }
    
    // MARK: - property
    private var classId: Int
    private var clockInId: Int
    private var childrenId: Int?
    private var clockInCommitId: Int?
    private let punchCardModel: YXSPunchCardModel?
    /// 是否是我发布
    private let isMyPublish: Bool
    
    /// 列表类型
    let type: YXSSingleStudentListType
    
    
    /// 日历model
    private var calendarModel: YXSCalendarModel?
    
    /// 是否可以滚动
    fileprivate var canScroll = true
    
    private var dataSource: [YXSPunchCardCommintListModel] = [YXSPunchCardCommintListModel]()
    
    /// 当前操作的 IndexPath
    private var curruntIndexPath: IndexPath!
    
    
    /// 初始化page list vc
    init(punchCardModel: YXSPunchCardModel?, isMyPublish: Bool, type: YXSSingleStudentListType, top3Model: YXSClassStarMapTop3?) {
        self.punchCardModel = punchCardModel
        self.clockInId = punchCardModel?.clockInId ?? 0
        self.isMyPublish = isMyPublish
        self.classId = punchCardModel?.classId ?? 0
        self.childrenId = punchCardModel?.childrenId
        self.type = type
        self.top3Model = top3Model
        super.init()
        tableViewIsGroup = true
        showBegainRefresh = false
    }
    
    
    /// 单个提交详情
    /// - Parameters:
    convenience init(clockInId: Int, clockInCommitId: Int, isMyPublish: Bool, classId: Int, top3Model: YXSClassStarMapTop3?) {
        self.init(punchCardModel: nil, isMyPublish: isMyPublish, type: .detial, top3Model: top3Model)
        self.clockInCommitId = clockInCommitId
        self.clockInId = clockInId
        self.classId = classId
        self.title = "详情"
    }
    /// 指定孩子查询
    convenience init(isMyPublish: Bool, type: YXSSingleStudentListType,clockInId: Int, childrenId: Int, classId: Int, top3Model: YXSClassStarMapTop3?) {
        self.init(punchCardModel: nil, isMyPublish: isMyPublish, type: type, top3Model: top3Model)
        self.childrenId = childrenId
        self.clockInId = clockInId
        self.classId = classId
    }
    
    /// 指定孩子历史优秀
    convenience init(isMyPublish: Bool, childrenId: Int, classId: Int, top3Model: YXSClassStarMapTop3?) {
        self.init(punchCardModel: nil, isMyPublish: isMyPublish, type: .goodHistory, top3Model: top3Model)
        self.childrenId = childrenId
        self.classId = classId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if type == .calendar{
            let detialVc = UIUtil.TopViewController() as? YXSPunchCardDetialController
            detialVc?.selectCalendarModel(calendarModel, isCurruntCalendarVC: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if type == .calendar{
            let detialVc = UIUtil.TopViewController() as? YXSPunchCardDetialController
            detialVc?.selectCalendarModel(calendarModel, isCurruntCalendarVC: false)
        }
        
        YXSSSAudioListPlayer.sharedInstance.stopPlayer()
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        tableView.register(YXSPunchCardSingleStudentListCell.self, forCellReuseIdentifier: "SLPunchCardSingleStudentListCell")
        tableView.register(YXSPunchCardDetialTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "SLPunchCardDetialTableHeaderView")
        tableView.register(YXSPunchCardDetialTableFooterView.self, forHeaderFooterViewReuseIdentifier: "SLPunchCardDetialTableFooterView")
        
        if let punchCardModel = punchCardModel, type == .calendar{
            headerView.setHeaderModel(punchCardModel)
            tableView.tableHeaderView = headerView
        }
        
        loadData()
        
        addNotification()
        
        self.dataSource = YXSCacheHelper.yxs_getCachePunchCardTaskStudentCommintList(clockInId: clockInId, childrenId:childrenId, type: type)
        
        if top3Model == nil{
            yxs_loadClassStarTopHistoryData()
        }
    }
    
    // MARK: - UI
    
    // MARK: -更新日历的头部视图
    ///更新日历的头部视图
    public func updateHeader(punchCardModel: YXSPunchCardModel){
        headerView.setHeaderModel(punchCardModel)
        
        //选中之前的日历cell
        if let calendarModel = calendarModel{
            for model in self.headerView.punchCalendarView.showCalendars{
                if model.endTime == calendarModel.endTime{
                    model.isSelect = true
                }else{
                    model.isSelect = false
                }
            }
            self.headerView.punchCalendarView.reloadData()
        }
    }
    
    // MARK: - loadData
    override func yxs_refreshData() {
        curruntPage = 1
        loadData()
        
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    
    func loadData(){
        if type == .detial{
            YXSEducationClockInSingleCommitDetailRequest.init(clockInId: clockInId, clockInCommitId: clockInCommitId ?? 0).request({ (model: YXSPunchCardCommintListModel) in
                self.yxs_endingRefresh()
                if self.curruntPage == 1{
                    self.dataSource.removeAll()
                }
                model.isMyPublish = self.isMyPublish
                self.childrenId = model.childrenId
                self.dataSource = [model]
                self.dealIsShowTime()
                self.reloadTableView()
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
                self.yxs_endingRefresh()
                self.reloadTableView()
            }
            
        }else{
            var request: YXSBaseRequset!
            switch type {
            case .all:
                if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                    request = YXSEducationClockInTeacherAllCommentsListRequest.init(clockInId: clockInId, currentPage: curruntPage)
                }else{
                    request = YXSEducationClockInParentAllCommentsListRequest.init(clockInId: clockInId, currentPage: curruntPage)
                }
            case .good:
                request = YXSEducationClockInExcellentCommentsListRequest.init(clockInId: clockInId, currentPage: curruntPage)
            case .myPunchCard:
                
                request = YXSEducationClockInParentMyCommentsListRequest.init(clockInId: clockInId, currentPage: curruntPage, childrenId: childrenId ?? 0)
            case .calendar:
                var endTime = yxs_startTime().yxs_tomorrow()
                var startTime = yxs_startTime()
                if let calendarModel = calendarModel{
                    startTime = calendarModel.startTime ?? ""
                    endTime = calendarModel.endTime
                }
                request = YXSEducationClockInCalendarCommentsListRequest.init(clockInId: clockInId, currentPage: curruntPage, endTime: endTime, startTime: startTime)
            case .studentPunchCardList:
                request = YXSEducationClockInSingleChildCommitListPageRequest.init(childrenId: childrenId ?? 0, clockInId: clockInId, currentPage: curruntPage)
            case .goodHistory:
                request = YXSEducationClockInMyExcellentCommentsListRequest.init(childrenId: childrenId ?? 0, classId: classId, currentPage: curruntPage)
            default:
                break
            }
            
            request.requestCollection({ (list:[YXSPunchCardCommintListModel]) in
                self.yxs_endingRefresh()
                if self.curruntPage == 1{
                    self.dataSource.removeAll()
                }
                for model in list{
                    model.isMyPublish = self.isMyPublish
                }
                self.dataSource += list
                self.dealIsShowTime()
                self.loadMore = list.count >= kPageSize
                self.reloadTableView()
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
                self.yxs_endingRefresh()
                self.reloadTableView()
            }
        }
        
    }
    
    @objc func yxs_loadClassStarTopHistoryData(){
        YXSEducationClassStarTopHistoryRequest.init(classId: classId).request({ (top3Model: YXSClassStarMapTop3) in
            self.top3Model = top3Model
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: -action
    
    // MARK: -private
    func dealIsShowTime(){
        for (index,model) in self.dataSource.enumerated(){
            model.isShowTime = false
            if index > 0{
                let beforeModel = self.dataSource[index - 1]
                if self.yxs_isToDay(model.createTime?.date(withFormat: kCommonDateFormatString) ?? Date(), compareDate: beforeModel.createTime?.date(withFormat: kCommonDateFormatString) ?? Date()) != .Today{
                    model.isShowTime = true
                }
            }
        }
    }
    
    // MARK: - public
    // MARK:刷新  打卡或者修改打卡
    /// 刷新  打卡或者修改打卡
    public var refreshBlock: ((_ changePunchCardModel: YXSPunchCardCommintListModel?,_ curruntType: YXSSingleStudentListType)->())?
    
    // MARK:修改打卡刷新当前列表数据
    ///修改打卡刷新当前列表数据
    public func refreshData(changePunchCardModel: YXSPunchCardCommintListModel){
        for (index, model) in self.dataSource.enumerated(){
            if model.clockInCommitId == changePunchCardModel.clockInCommitId{
                self.dataSource[index] = changePunchCardModel
                reloadTableView(section: index, scroll: false)
                break
            }
        }
    }
    
    // MARK: - tableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = dataSource[section]
        var commentsCount = (dataSource[section].comments?.count ?? 0)
        if model.isNeeedShowCommentAllButton && !model.isShowCommentAll{
            commentsCount = 3
        }
        return  commentsCount + 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SLPunchCardSingleStudentListCell") as! YXSPunchCardSingleStudentListCell
        cell.selectionStyle = .none
        let comments = dataSource[indexPath.section].comments
        if let comments = comments{
            if indexPath.row < comments.count{
                cell.contentView.isHidden = false
                cell.yxs_setCellModel(comments[indexPath.row])
                cell.commentBlock = {
                    [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.curruntIndexPath = indexPath
                    strongSelf.showComment(comments[indexPath.row], section: indexPath.section)
                }
                cell.cellLongTapEvent = {
                    [weak self](point) in
                    guard let strongSelf = self else { return }
                    strongSelf.curruntIndexPath = indexPath
                    strongSelf.showDelectComment(comments[indexPath.row], point, section: indexPath.section)
                }
                
                //                cell.isMyPublish = dataSource[indexPath.section].isMyPublish
                cell.isNeedCorners = indexPath.row == comments.count - 1
            }else{
                cell.contentView.isHidden = true
            }
        }else{
            cell.contentView.isHidden = true
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight: CGFloat = 0
        
        //是否是最后一行 需要补偿高度
        var isLastRow = false
        
        let model = dataSource[indexPath.section]
        if let comments = model.comments{
            var commentsCount = comments.count
            if model.isNeeedShowCommentAllButton && !model.isShowCommentAll{
                commentsCount = 3
                isLastRow = true
            }
            if indexPath.row < commentsCount{
                let commetModel = comments[indexPath.row]
                cellHeight = commetModel.cellHeight
                if indexPath.row == comments.count - 1{
                    isLastRow = true
                }
                
                if isLastRow{
                    cellHeight += 8.0
                }
            }
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let model = dataSource[section]
        return model.isNeeedShowCommentAllButton ? 40.0 : 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let model = dataSource[section]
        if section == dataSource.count - 1{
            SLLog("sectionHeight = \(model.headerHeight) ---->>>>>")
        }
        return model.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = dataSource[section]
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SLPunchCardDetialTableHeaderView") as! YXSPunchCardDetialTableHeaderView
        model.top3Model = top3Model
        model.isShowLookStudentAllButton = !(type == .myPunchCard || type == .studentPunchCardList)
        model.isShowLookGoodButton = type != .goodHistory
        headerView.setModel(model, type: self.type)
        headerView.headerBlock = {[weak self](type) in
            guard let strongSelf = self else { return }
            switch type {
            case .comment:
                strongSelf.showComment(section:section)
            case .praise:
                strongSelf.changePrise(section)
            case .showAll:
                strongSelf.showAllRefresh(section: section, isScroll: !model.isShowContentAll)
            case .setPunchCardGood:
                strongSelf.setPunchCardGoodEvent(section)
            case .dealPunCard:
                strongSelf.dealPunchCardEvent(section)
            case .setUnPunchCardGood:
                strongSelf.setUnPunchCardGoodEvent(section)
            case .lookAllPunchCardCommint:
                strongSelf.lookStudentAllPunchCardCommintEvent(section)
            case .lookPunchCardGood:
                strongSelf.lookPunchCardGoodEvent(section)
            case .lookLastWeakClassStart:
                strongSelf.lookClassStartRankEvent(section)
            }
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let model = dataSource[section]
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SLPunchCardDetialTableFooterView") as! YXSPunchCardDetialTableFooterView
        footerView.setFooterModel(model)
        footerView.footerBlock = {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.reloadTableView(section: section, scroll: false)
        }
        footerView.isLastSection = section == dataSource.count - 1
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - getter&setter
    lazy var headerView: YXSPunchCardSingleStudentListHeaderView = {
        let height = CGFloat(46.0 + 7.0 + 30.0 + 10.0 + 180.0)
        let headerView = YXSPunchCardSingleStudentListHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: height))
        return headerView
    }()
    
    // MARK: -列表为空
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return showEmptyDataSource
    }
    
    override func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return type == .calendar ? 140 : -80
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - YXSRouterEventProtocol
extension YXSPunchCardSingleStudentBaseListController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?){
        switch eventName {
        case kYXSPunchCalendarViewCellEventClick:
            calendarModel = info?[kEventKey] as? YXSCalendarModel
            yxs_refreshData()
            let detialVc = UIUtil.TopViewController() as? YXSPunchCardDetialController
            detialVc?.selectCalendarModel(calendarModel)
        default:
            break
        }
    }
}

extension YXSPunchCardSingleStudentBaseListController{
    // MARK: - 修改打卡
    func dealPunchCardEvent(_ section: Int){
        let model = dataSource[section]
        let headerView = self.tableView.headerView(forSection: section)
        if let headerView  = headerView as? YXSPunchCardDetialTableHeaderView{
            let selectFrame = headerView.convert(headerView.dealPunchCardBtn.frame, to: self.tabBarController?.view)
            var y: CGFloat =  selectFrame.maxY - 4
            let selectHeight: CGFloat = 2*35 + kSafeBottomHeight
            if SCREEN_HEIGHT - y < selectHeight {
                y = SCREEN_HEIGHT - selectHeight
            }
            
            let selects = (model.excellent ?? false) ? [YXSSelectModel.init(text: "撤回", isSelect: false, paramsKey: "10")] : [YXSSelectModel.init(text: "修改", isSelect: true, paramsKey: "20"),YXSSelectModel.init(text: "撤回", isSelect: false, paramsKey: "10")]
            YXSBaseSelectView.showAlert(offset: CGPoint.init(x: 14.5, y: y), selects:  selects) { [weak self](index, selectTypeModels) in
                guard let strongSelf = self else { return }
                if selects[index].paramsKey == "10"{
                    strongSelf.dealPunchRecallEvent(section)
                }else{
                    strongSelf.pushPublishController(model: model)
                }
                strongSelf.fd_interactivePopDisabled = false
            }
        }
    }
    
    func pushPublishController(model: YXSPunchCardCommintListModel){
        let vc = YXSPunchCardPublishController.init(changePunchCardModel: model)
        navigationController?.pushViewController(vc)
    }
    
    // MARK: - 撤回打卡
    func dealPunchRecallEvent(_ section: Int){
        YXSCommonAlertView.showAlert(title: "确定撤回打卡?", rightClick: {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loadCancelData(section)
        })
    }
    

    // MARK: - 删除评论
    func showDelectComment(_ commentModel: YXSPunchCardCommentModel,_ point: CGPoint, section: Int){
        var pointInView = point
        if let curruntIndexPath = self.curruntIndexPath{
            let cell = self.tableView.cellForRow(at: curruntIndexPath)
            if let listCell  = cell as? YXSPunchCardSingleStudentListCell{
                let rc = listCell.convert(listCell.comentLabel.frame, to: UIUtil.curruntNav().view)
                pointInView.y = rc.minY + 14.0
            }
        }
        YXSFriendsCircleDelectCommentView.showAlert(pointInView) {
            [weak self]in
            guard let strongSelf = self else { return }
            strongSelf.loadDelectCommentData(section, commentModel: commentModel)
        }
    }
    
    // MARK: - 去评论
    func showComment(_ commentModel: YXSPunchCardCommentModel? = nil, section: Int){
        if commentModel?.isMyComment ?? false{
            return
        }
        let tips = commentModel == nil ? "评论：" : "回复\(commentModel!.showUserName ?? "")："
        let alter = YXSFriendsCommentAlert.showAlert(tips) { [weak self](content) in
            guard let strongSelf = self else { return }
            strongSelf.loadCommentData(section, content: content!, commentModel: commentModel)
            
        }
        alter.textMaxCount = 400
    }
    
    func setPunchCardGoodEvent(_ section: Int){
            let model = dataSource[section]
            if self.type == .calendar || self.type == .studentPunchCardList{
                model.excellent = true
            }else{
                 self.dataSource.remove(at: section)
            }
            self.dealIsShowTime()
            self.reloadTableView()
            
            YXSEducationClockInTeacherApprovalRequest.init(clockInId: model.clockInId ?? 0, clockInCommitId: model.clockInCommitId ?? 0).request({ (result) in
                if self.type == .studentPunchCardList{
                    self.navigationController?.yxs_existViewController(existClass: YXSPunchCardDetialController.self, complete: { (vc) in
                        vc.pageController.yxs_punchCardRefresh(type: nil)
                    })
                }else{
                    self.refreshBlock?(nil,self.type)
                }
            }) { (msg, code) in
                //            friendCircleModel.isOnRequsetPraise = false
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        func setUnPunchCardGoodEvent(_ section: Int){
            let model = dataSource[section]
            if self.type == .calendar || self.type == .studentPunchCardList{
                model.excellent = false
            }else{
                 self.dataSource.remove(at: section)
            }
            self.reloadTableView()
            self.dealIsShowTime()
            
            YXSEducationClockInTeacherApprovalRequest.init(clockInId: model.clockInId ?? 0, clockInCommitId: model.clockInCommitId ?? 0).request({ (result) in
                if self.type == .studentPunchCardList{
                    self.navigationController?.yxs_existViewController(existClass: YXSPunchCardDetialController.self, complete: { (vc) in
                        vc.pageController.yxs_punchCardRefresh(type: nil)
                    })
                }else{
                    self.refreshBlock?(nil,self.type)
                }
                
            }) { (msg, code) in
                //            friendCircleModel.isOnRequsetPraise = false
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        
        func lookStudentAllPunchCardCommintEvent(_ section: Int){
            let model = dataSource[section]
            let vc = YXSPunchCardSingleStudentBaseListController.init(isMyPublish: isMyPublish, type: .studentPunchCardList, clockInId: model.clockInId ?? 0, childrenId: model.childrenId ?? 0, classId: classId, top3Model: top3Model)
            vc.title = model.realName
            UIUtil.curruntNav().pushViewController(vc)
        }
        
        func lookPunchCardGoodEvent(_ section: Int){
            let model = dataSource[section]
            let vc = YXSPunchCardSingleStudentBaseListController.init(isMyPublish: isMyPublish, childrenId: model.childrenId ?? 0, classId: classId, top3Model: top3Model)
            vc.title = "\(model.realName ?? "")"
            UIUtil.curruntNav().pushViewController(vc)
        }
        
        func lookClassStartRankEvent(_ section: Int){
            let model = dataSource[section]
    //        let vc = YXSPunchCardSingleStudentBaseListController.init(isMyPublish: isMyPublish, type: .studentPunchCardList, clockInId: model.clockInId ?? 0, childrenId: model.childrenId ?? 0)
    //        vc.title = model.realName
    //        UIUtil.curruntNav().pushViewController(vc)
        }
    
    // MARK: - loadEventData
    func loadCancelData(_ section: Int = 0){
        let listModel = dataSource[section]
        MBProgressHUD.yxs_showLoading()
        YXSEducationClockInParentCancelCardRequest.init(clockInId: listModel.clockInId ?? 0, clockInCommitId: listModel.clockInCommitId ?? 0).request({ (result) in
            MBProgressHUD.yxs_hideHUD()
            self.dataSource.remove(at: section)
            self.dealIsShowTime()
            self.reloadTableView()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kOperationStudentCancelPunchCardNotification), object: [kNotificationIdKey: listModel.clockInId ?? 0])
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    func loadDelectCommentData(_ section: Int = 0,commentModel: YXSPunchCardCommentModel){
        let listModel = dataSource[section]
        
        var requset: YXSBaseRequset!
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            requset = YXSEducationClockInTeacherDeleteCommentsRequest.init(clockInId: listModel.clockInId ?? 0, clockInCommitId: listModel.clockInCommitId ?? 0, clockInCommentsId: commentModel.id ?? 0)
        }else{
            requset = YXSEducationClockInParentDeleteCommentsRequest.init(clockInId: listModel.clockInId ?? 0, clockInCommitId: listModel.clockInCommitId ?? 0, clockInCommentsId: commentModel.id ?? 0)
        }
        requset.request({ (result) in
            if let curruntIndexPath  = self.curruntIndexPath{
                listModel.comments?.remove(at: curruntIndexPath.row)
            }
            self.reloadTableView(section: section, scroll: false)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
    }
    
    func loadCommentData(_ section: Int = 0,content: String,commentModel: YXSPunchCardCommentModel?){
        let listModel = dataSource[section]
        
        var requset: YXSBaseRequset!
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            if let commentModel = commentModel{
                requset = YXSEducationClockInTeacherReplyCommentsRequest.init(clockInId: listModel.clockInId ?? 0, clockInCommitId: listModel.clockInCommitId ?? 0,content: content, clockInCommentsId: commentModel.id ?? 0)
            }else{
                requset = YXSEducationClockInTeacherReplyClockContentRequest.init(clockInId: listModel.clockInId ?? 0, clockInCommitId: listModel.clockInCommitId ?? 0,content: content)
            }
        }else{
            if let commentModel = commentModel{
                requset = YXSEducationClockInParentReplyCommentsRequest.init(clockInId: listModel.clockInId ?? 0, clockInCommitId: listModel.clockInCommitId ?? 0,content: content, childrenId: self.yxs_user.curruntChild?.id ?? 0, clockInCommentsId:  commentModel.id ?? 0)
                
            }else{
                requset = YXSEducationClockInParentReplyClockContentRequest.init(clockInId: listModel.clockInId ?? 0, clockInCommitId: listModel.clockInCommitId ?? 0,content: content, childrenId: self.yxs_user.curruntChild?.id ?? 0)
            }
        }
        requset.request({ (model:YXSPunchCardCommentModel) in
            if listModel.comments != nil {
                listModel.comments?.append(model)
            }else{
                listModel.comments = [model]
            }
            self.reloadTableViewToScrollComment(section: section)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
    }
    
    
    
    // MARK: - 点赞
    func changePrise(_ section: Int){
        
        let model = dataSource[section]
        if YXSPersonDataModel.sharePerson.isNetWorkingConnect == false{
            //            friendCircleModel.isOnRequsetPraise = false
            MBProgressHUD.yxs_showMessage(message: "网络不给力，请检查网络")
            return
        }
        var praiseModel: YXSFriendsPraiseModel! = nil
        if let  praises = model.praises{
            for model in praises{
                if model.isMyOperation{
                    praiseModel = model
                    break
                }
            }
        }
        let isCancelPraise = praiseModel == nil ? false : true
        if isCancelPraise {
            model.praises!.remove(at: model.praises!.firstIndex(of: praiseModel!) ?? 0)
        }else{
            let result:YXSFriendsPraiseModel = YXSFriendsPraiseModel.init(JSON: ["":""])!
            result.userType = YXSPersonDataModel.sharePerson.personRole.rawValue
            result.userId = YXSPersonDataModel.sharePerson.userModel.id
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                result.userName = YXSPersonDataModel.sharePerson.userModel.name
            }else{
                result.userName = "\(self.yxs_user.curruntChild?.realName ?? "")的\((self.yxs_user.curruntChild?.grade?.relationship ?? "").yxs_RelationshipValue())"
                
            }
            if model.praises == nil{
                model.praises = [result]
            }else{
                model.praises!.append(result)
            }
            praiseModel = result
        }
        reloadTableView(section: section)
        
        
        var requset: YXSBaseRequset!
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            requset = YXSEducationClockInTeacherPraiseCommentsRequest.init(clockInId: model.clockInId ?? 0, clockInCommitId: model.clockInCommitId ?? 0)
        }else{
            requset = YXSEducationClockInParentPraiseCommentsRequest.init(clockInId: model.clockInId ?? 0, clockInCommitId: model.clockInCommitId ?? 0, childrenId: self.yxs_user.curruntChild?.id ?? 0)
        }
        
        requset.request({ (result:YXSFriendsPraiseModel) in
            
        }) { (msg, code) in
            //            friendCircleModel.isOnRequsetPraise = false
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: -底层刷新UI
    //    _ section: Int
    func reloadTableView(section: Int? = nil, scroll: Bool = false){
        YXSCacheHelper.yxs_cachePunchCardTaskStudentCommintList(dataSource: self.dataSource, clockInId: clockInId, childrenId: childrenId, type: type)
        
        UIView.performWithoutAnimation {
            if let section = section{
                let offset = tableView.contentOffset
                tableView.reloadSections(IndexSet.init(arrayLiteral: section), with: UITableView.RowAnimation.none)
//                if !scroll{//为什会会跳动 why
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
//                        self.tableView.setContentOffset(offset, animated: false)
//                    }
//                }
            }else{
                tableView.reloadData()
            }
        }
        
        if let section = section,scroll{
            tableView.selectRow(at: IndexPath.init(row: 0, section: section), animated: false, scrollPosition: .top)
        }
    }
    
    // MARK: -点评滚动居中
    /// 点评滚动居中
    /// - Parameter section: section
    func reloadTableViewToScrollComment(section: Int){
        //                none
        YXSCacheHelper.yxs_cachePunchCardTaskStudentCommintList(dataSource: self.dataSource, clockInId: clockInId, childrenId: childrenId, type: type)
        let model = self.dataSource[section]
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet.init(arrayLiteral: section), with: UITableView.RowAnimation.none)
            let count: Int? = model.comments?.count
            //是否需要点评滚动居中 (当前处于收起点评状态不滚动)
            if let count = count,count > 0 && !(model.isNeeedShowCommentAllButton && !model.isShowCommentAll){
                tableView.selectRow(at: IndexPath.init(row: count - 1, section: section), animated: false, scrollPosition: .middle)
            }
        }
        
    }
    
    // MARK: -点击展开刷新
    /// 点击展开刷新
    /// - Parameters:
    ///   - section: section
    ///   - isScroll: 是否滚动
    func showAllRefresh(section: Int, isScroll: Bool = false){
        var scroll = false
        let headerView = tableView.headerView(forSection: section)
        if let headerView = headerView, isScroll{
            let rc = tableView.convert(headerView.frame, to: self.view)
            SLLog(rc)
            if rc.minY < 0{
                scroll = true
            }
        }
        
        reloadTableView(section:section,scroll: scroll)
    }
}

// MARK: - Notification
extension YXSPunchCardSingleStudentBaseListController{
    @objc func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_ :)),name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changePunchCardModelEvent), name: NSNotification.Name(rawValue: kOperationStudentChangePunchCardNotification), object: nil)
    }
    
    @objc func changePunchCardModelEvent(_ notification:Notification){
        let model = notification.object as? YXSPunchCardCommintListModel
        if let model = model{
            refreshData(changePunchCardModel: model)
        }
    }
    
    @objc func keyBoardWillShow(_ notification:Notification){
        DispatchQueue.main.async {
            let user_info = notification.userInfo
            let keyboardRect = (user_info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            if let curruntIndexPath = self.curruntIndexPath{
                let cell = self.tableView.cellForRow(at: curruntIndexPath)
                if let listCell  = cell as? YXSPunchCardSingleStudentListCell{
                    
                    let rc = listCell.convert(listCell.comentLabel.frame, to: self.view)
                    
                    let offsetY = (SCREEN_HEIGHT - rc.maxY) - (keyboardRect.height + 40.0) - rc.height
                    var contentSet = self.tableView.contentOffset
                    contentSet.y -= offsetY
                    if contentSet.y >= 0 {
                        self.tableView.setContentOffset(contentSet, animated: true)
                    }
                }
            }
        }
    }
}
