 //
//  SLPunchCardDetialController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/27.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import FDFullscreenPopGesture_Bell
import NightNight

class SLPunchCardDetialController: SLBaseTableViewController {
    var punchModel: SLPunchCardModel!
    var dataSource: [PunchCardPublishListModel] = [PunchCardPublishListModel]()
    var childId: Int?
    var clockInId: Int
    var classId: Int
    var calendarModel: CalendarModel?
    
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
        UIUtil.sl_reduceHomeRed(serviceId: clockInId, childId: childId ?? 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        
        view.addSubview(customNav)
        customNav.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }
        view.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#A9CBFF")
        tableView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#A9CBFF")
        tableView.isHidden = true
        
        
        tableView.estimatedRowHeight = 277.5
        tableView.register(SLPunchCardDetialCell.self, forCellReuseIdentifier: "SLPunchCardDetialCell")
        tableView.register(SLPunchCardSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "SLPunchCardSectionHeaderView")
        tableView.sectionFooterHeight = 0.0
        tableView.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 20))
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(sl_refreshData), name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: -UI
    var isFrist: Bool = true
    func updateHeaderView(){
        
        tableHeaderView.layoutIfNeeded();
        let height = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        tableHeaderView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height)
        tableView.tableHeaderView = tableHeaderView
    }
    
    override func sl_onBackClick() {
        super.sl_onBackClick()
        SLSSAudioPlayer.sharedInstance.stopVoice()
    }
    
    // MARK: -loadData
    override func sl_refreshData() {
        loadData()
    }
    
    override func sl_loadNextPage() {
        loadData()
    }
    let group = DispatchGroup()
    let queue = DispatchQueue.global()
    
    /// 是否需要刷新打卡列表数据
    var shouldReloadTaskData = true
    func loadData(){
        
        self.group.enter()
        queue.async {
            self.loadListData()
        }
        if curruntPage == 1 {
            if shouldReloadTaskData{
                self.group.enter()
                queue.async {
                    self.loadPunchCardTaskDetailData()
                }
            }
            
        }
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                self.sl_endingRefresh()
                
                if self.shouldReloadTaskData{
                    if let punchModel = self.punchModel{
                        self.tableHeaderView.setHeaderModel(punchModel)
                    }
                }else{
                    self.tableHeaderView.punchCardMainView.punchCardBottomView.setViewModel(self.punchModel, calendarModel: self.calendarModel)
                }
                self.tableView.isHidden = false
                self.updateHeaderView()
                self.tableView.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true)
                self.shouldReloadTaskData = true
            }
        }
    }
    
    func loadPunchCardTaskDetailData(){
        if !SLPersonDataModel.sharePerson.isNetWorkingConnect{
            self.punchModel = SLCacheHelper.sl_getCachePunchCardDetailTask(clockInId: clockInId, childrenId: childId)
            self.punchModel.childrenId = childId
            self.group.leave()
            return
        }
        
        var request: SLBaseRequset!
        if let childrenId = childId{
            request = SLEducationClockInParentTaskDetailRequest.init(clockInId: clockInId, childrenId: childrenId, currentPage: curruntPage)
        }else{
            request = SLEducationClockInTeacherTaskDetailRequest.init(clockInId: clockInId)
        }
        request.request({ (model: SLPunchCardModel) in
            self.punchModel = model
            self.punchModel.childrenId = self.childId
            SLCacheHelper.sl_cachePunchCardDetailTask(model: model, clockInId: self.clockInId, childrenId: self.childId)
            self.group.leave()
        }) { (msg, code) in
            self.group.leave()
        }
    }
    
    func loadListData(){
        if !SLPersonDataModel.sharePerson.isNetWorkingConnect{
            self.dataSource = SLCacheHelper.sl_getCachePunchCardDetailTaskList(clockInId: clockInId)
            self.group.leave()
            return
        }
        
        var startTime: String? = self.sl_startTime()
        var endTime:String? = startTime?.sl_tomorrow()
        if let calendarModel = calendarModel{
            startTime = calendarModel.startTime
            endTime = calendarModel.endTime
        }
        SLEducationClockInClockInParentCommitListPageRequest.init(clockInId:clockInId, currentPage: curruntPage,startTime: startTime,endTime: endTime).requestCollection({ (list:[PunchCardPublishListModel]) in
            if self.curruntPage == 1{
                self.dataSource.removeAll()
            }
            
            self.dataSource += list
            self.loadMore = list.count == kPageSize
            SLCacheHelper.sl_cachePunchCardDetailTaskList(dataSource: self.dataSource, clockInId: self.clockInId)
            self.group.leave()
        }) { (msg, code) in
            self.group.leave()
        }
    }
    
    // MARK: -action
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count > 0 ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SLPunchCardDetialCell") as! SLPunchCardDetialCell
        cell.sl_setCellModel(dataSource[indexPath.row])
        cell.isLastRow = indexPath.row == dataSource.count - 1 ? true: false
        cell.cellBlock = {
            [weak self] in
            guard let strongSelf = self else { return }
//            strongSelf.tableView.reloadRows(at: [indexPath], with: .none)
            strongSelf.tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: SLPunchCardSectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SLPunchCardSectionHeaderView") as! SLPunchCardSectionHeaderView
        return header
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56.5
    }
    
    
    // MARK: - getter&setter
    lazy var tableHeaderView: SLPunchCardDetialHeaderView = {
        let tableHeaderView = SLPunchCardDetialHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        return tableHeaderView
    }()
    
    lazy var customNav: SLCustomNav = {
        let customNav = SLCustomNav()
        return customNav
    }()
}

extension SLPunchCardDetialController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > kSafeTopHeight + 64{
            customNav.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
            customNav.backImageButton.setMixedImage(MixedImage(normal: "back", night: "sl_back_white"), forState: .normal)
            customNav.titleLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
            customNav.shareButton.setMixedImage(MixedImage(normal: "sl_punchCard_share", night: "sl_punchCard_share_white"), forState: .normal)
            customNav.moreButton.setMixedImage(MixedImage(normal: "sl_homework_more", night: "sl_invite_more"), forState: .normal)
        }else{
            customNav.mixedBackgroundColor = MixedColor(normal: UIColor.clear, night: UIColor.clear)
            customNav.backImageButton.setMixedImage(MixedImage(normal: "back", night: "back"), forState: .normal)
            customNav.titleLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kTextMainBodyColor)
            customNav.shareButton.setMixedImage(MixedImage(normal: "sl_punchCard_share", night: "sl_punchCard_share"), forState: .normal)
            customNav.moreButton.setMixedImage(MixedImage(normal: "sl_homework_more", night: "sl_homework_more"), forState: .normal)
                
        }
    }
}

// MARK: -HMRouterEventProtocol
extension SLPunchCardDetialController: SLRouterEventProtocol{
    func sl_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kHMCustomNavBackEvent:
            sl_onBackClick()
        case kHMCustomNavShareEvent:
            let requestModel: HMRequestShareModel = HMRequestShareModel.init(clockInId: punchModel.clockInId ?? 0, childrenId: childId)
            let isTeacher = SLPersonDataModel.sharePerson.personRole == .TEACHER
            UIUtil.sl_shareLink(requestModel: requestModel, shareModel: SLShareModel.init(title: isTeacher ? "打卡任务" : "我在优学生坚持打卡\(punchModel.clockInDayCount ?? 0)天", descriptionText: punchModel.title ?? "", link: ""))

        case kHMCustomNavMoreEvent:
            SLCommonBottomAlerView.showIn(topButtonTitle: ((punchModel.isTop ?? 0)  == 1) ? "取消置顶" : "置顶") { [weak self] in
                guard let strongSelf = self else { return }
                let isTop = ((strongSelf.punchModel.isTop ?? 0)  == 1) ? 0 : 1
                UIUtil.sl_loadUpdateTopData(type: .punchCard, id: strongSelf.punchModel.clockInId ?? 0, createTime: "", isTop: isTop,positon: .detial){
                    strongSelf.punchModel.isTop = isTop
                }
            }
        case kSLPunchCardDetialHeaderViewUpdateHeaderViewEvent:
            updateHeaderView()
        case kSLPunchCardMainViewLookPunchDeitalEvent:
            let vc = SLPunchCardStatisticsController.init(punchCardModel: punchModel)
            navigationController?.pushViewController(vc)
        case kSLPunchCardDetialHeaderViewRemindEvent:
            let vc = SLPunchCardMembersListViewController.init(clockInId: punchModel.clockInId ?? 0,classId: classId ,punchM: punchModel)
            self.navigationController?.pushViewController(vc)
        case kSLPunchCardDetialHeaderViewSignEvent:
            let vc = SLPunchCardPublishController.init(punchModel)
            vc.punchCardComplete = {(requestModel, shareModel) in
                SLPunchCardShareView.showAlert(shareModel: shareModel) {(image) in
                    SLShareTool.showCommonShare(shareModel: SLShareModel.init(image: image))
                }
            }
            self.navigationController?.pushViewController(vc)
        case kSLPunchCalendarViewCellEventClick:
            shouldReloadTaskData = false
            calendarModel = info?[kEventKey] as? CalendarModel
            sl_refreshData()
        default:
            break
        }
    }
}




