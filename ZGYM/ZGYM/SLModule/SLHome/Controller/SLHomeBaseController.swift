//
//  SLHomeBaseController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/13.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLHomeBaseController: SLBaseTableViewController{
    var dataSource: [HomeSectionModel] = [HomeSectionModel]()
    var isSingleHome: Bool = false
    
    
    /// 是否是空
    var hasDataSource: Bool{
        get{
            var hasDataSource = false
            for section in dataSource{
                if section.items.count > 0{
                    hasDataSource = true
                    break
                }
            }
            return hasDataSource
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initModel()
        addNotification()
        
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kTabBottomHeight)
        }
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        
        
        tableView.sectionFooterHeight = 0.0
        tableView.register(SLNoticeListHomeCell.self, forCellReuseIdentifier: "SLNoticeListHomeCell")
        tableView.register(SLHomeworkListHomeCell.self, forCellReuseIdentifier: "SLHomeworkListHomeCell")
        tableView.register(SLHomeClassStartCell.self, forCellReuseIdentifier: "SLHomeClassStartCell")
        tableView.register(SLHomeFriendCell.self, forCellReuseIdentifier: "SLHomeFriendCell")
        tableView.register(SLHomeCell.self, forCellReuseIdentifier: "SLHomeCell")
        tableView.register(SLPunchCardListHomeCell.self, forCellReuseIdentifier: "SLPunchCardListHomeCell")
        tableView.register(SLSolitaireListHomeCell.self, forCellReuseIdentifier: "SLSolitaireListHomeCell")
        
        tableView.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 0.01))
        if SLPersonDataModel.sharePerson.personRole == .TEACHER{
            view.addSubview(publishButton)
            publishButton.snp.makeConstraints { (make) in
                make.right.equalTo(-15)
                make.bottom.equalTo(-kTabBottomHeight - 15)
                make.size.equalTo(CGSize.init(width: 51.5, height: 51.5))
            }
        }
    }
    
    func initModel(){
        for index in 0...2{
            let sectionModel = HomeSectionModel()
            if index == 1{
                sectionModel.hasSection = true
                sectionModel.showText = "今天的消息"
            }else if index == 2{
                sectionModel.hasSection = true
                sectionModel.showText = "更早消息"
            }
            sectionModel.items = [SLHomeListModel]()
            self.dataSource.append(sectionModel)
        }
    }
    // MARK: - UI
    func reloadFooterView(){
        if self.hasDataSource{
            
            if self.loadMore{
                self.tableView.tableFooterView = nil
            }else{
                self.tableFooterView.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: 66.5)
                self.tableFooterView.showEmpty(false)
                self.tableView.tableFooterView = self.tableFooterView
                
            }
        }else{
            self.tableFooterView.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: 250)
            self.tableView.tableFooterView = self.tableFooterView
            self.tableFooterView.showEmpty(true)
        }
        
    }
    
    // MARK: -loadData
    override func sl_refreshData() {
        curruntPage = 1
        loadData()
    }
    
    override func sl_loadNextPage() {
        loadData()
    }
    
    let group = DispatchGroup()
    let queue = DispatchQueue.global()
    
    func loadData(){
        
    }
    
    func homeLoadUpdateTopData(type: HomeType,id: Int = 0,createTime:String = "", isTop: Int = 0,sucess: (()->())? = nil){
        
    }
    
    func homesl_loadRecallData(model: SLHomeListModel,sucess: (()->())? = nil){
        
    }
    
    // MARK: -action
    func showTopAlert(indexPath: IndexPath){
        let SLHomeListModel = dataSource[indexPath.section].items[indexPath.row]
        SLCommonBottomAlerView.showIn(topButtonTitle: ((SLHomeListModel.isTop ?? 0)  == 1) ? "取消置顶" : "置顶") { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.homeLoadUpdateTopData(type: SLHomeListModel.type, id: SLHomeListModel.serviceId ?? 0, createTime: SLHomeListModel.createTime ?? "", isTop: (SLHomeListModel.isTop ?? 0)  == 1 ? 0 : 1){
                strongSelf.sl_refreshData()
            }
        }
    }
    
    func dealCellEvent(_ cellType: HomeCellEvent, indexPath: IndexPath){
        let model = dataSource[indexPath.section].items[indexPath.row]
        switch cellType {
        case .showAll:
            UIUtil.sl_loadReadData(model)
            self.reloadTableView(indexPath,isScroll: !model.isShowAll)
        case .read:
            UIUtil.sl_loadReadData(model)
            self.reloadTableView(indexPath)
        case .punchRemind:
            let vc = SLPunchCardMembersListViewController.init(clockInId: model.serviceId ?? 0,classId: model.classId ?? 0)
            self.navigationController?.pushViewController(vc)
        case .goPunch:
            let vc = SLPunchCardDetialController.init(clockInId: model.serviceId ?? 0,childId: model.childrenId, classId:model.classId ?? 0)
            self.navigationController?.pushViewController(vc)
        case .recall:
            homesl_loadRecallData(model: model) {
                self.dataSource[indexPath.section].items.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
        case .noticeReceipt:
            MBProgressHUD.sl_showLoading()
            SLEducationNoticeCustodianCommitReceiptRequest(noticeId: model.serviceId ?? 0, childrenId: model.childrenId ?? 0, noticeCreateTime: model.createTime ?? "").request({ (json) in
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationModelKey: model])
                UIUtil.sl_reduceAgenda(serviceId: model.serviceId ?? 0, info: [kEventKey: HomeType.notice])
                UIUtil.sl_reduceHomeRed(serviceId: model.serviceId ?? 0, childId: model.childrenId ?? 0)
                MBProgressHUD.sl_showMessage(message: "提交成功")
                model.commitState = 2
                self.reloadTableView(indexPath)
            }) { (msg, code) in
                MBProgressHUD.sl_showMessage(message: msg)
            }
            UIUtil.sl_loadReadData(model,showLoading: false)
        case .cancelStick:
            SLCommonAlertView.showAlert(title: "是否取消置顶", message: "", leftTitle: "取消", rightTitle: "确定", rightClick: {
                UIUtil.sl_loadUpdateTopData(type: model.type, id: model.serviceId ?? 0, createTime:  model.createTime ?? "", isTop: 0, positon: self.isSingleHome ? SLOperationPosition.singleHome : SLOperationPosition.home) {
                    self.sl_refreshData()
                }
            })
        default:
            break
        }
    }
    
    @objc func publishClick(){
        if SLPersonDataModel.sharePerson.personRole == .TEACHER && (sl_user.gradeIds == nil || sl_user.gradeIds!.count == 0){
            UIUtil.curruntNav().pushViewController(SLTeacherClassListViewController())
            return
        }
        SLHomePublishView.showAlert {[weak self] (event) in
            guard let strongSelf = self else { return }
            strongSelf.sl_dealPublishAction(event,classId: nil)
        }
        
    }
    
    // MARK: -private
    
    func reloadTableView(_ indexPath: IndexPath, isScroll: Bool = false){
        if !isSingleHome{
            SLCacheHelper.sl_cacheHomeList(dataSource: self.dataSource)
        }
        UIView.performWithoutAnimation {
            let cell = tableView.cellForRow(at: indexPath)
            tableView.reloadRows(at: [indexPath], with: .none)
            if isScroll{
                if let cell = cell, isScroll{
                    let rc = tableView.convert(cell.frame, to: self.view)
                    SLLog(rc)
                    //首页 底部高度  滚动有问题
                    let top = isSingleHome ? 0 : kSafeTopHeight + 64 + 49
                    if rc.minY < top{
                        //展开全文滚动滚回来
                        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition:.top)
                        var offset = self.tableView.contentOffset
                        offset.y -= top
                        self.tableView.setContentOffset(offset, animated: false)
                    }
                }
            }
        }
        
        
    }
    
    func dealSelectRow(didSelectRowAt indexPath: IndexPath, childModel: SLChildrenModel?){
        let childId = childModel?.id
        let model = dataSource[indexPath.section].items[indexPath.row]
        if SLPersonDataModel.sharePerson.personRole == .PARENT && model.isRead == 0{
            
            UIUtil.sl_loadReadData(dataSource[indexPath.section].items[indexPath.row])
            reloadTableView(indexPath)
        }
        switch model.type {
        case .homework:
            sl_pushHomeDetailVC(homeModel: model)
        case .punchCard:
            let vc = SLPunchCardDetialController.init(clockInId: model.serviceId ?? 0, childId: childModel?.id,classId: model.classId ?? 0)
            navigationController?.pushViewController(vc)
        case .solitaire:
            let vc = SLSolitaireDetailController.init(censusId: model.serviceId ?? 0, childrenId: childId ?? 0, classId: model.classId ?? 0)
            navigationController?.pushViewController(vc)
        case .notice:
            let vc = SLNoticeDetailViewController.init(model: model)
            navigationController?.pushViewController(vc)
        case .classstart:
            if let childModel = childModel{
                UIUtil.sl_reduceHomeRed(serviceId: model.serviceId ?? 0, childId: childModel.id ?? 0)
                UIUtil.curruntNav().pushViewController(SLClassStarPartentDetialController.init(childrenModel: childModel, startTime: model.startTime,endTime: model.endTime))
            }
        case .friendCicle:
            showComment(indexPath)
        default:
            break
        }
    }
    
    func removeAll(){
        for model in dataSource{
            model.items.removeAll()
        }
    }
    
    // MARK: -friendEvent
    func changePrise(_ indexPath: IndexPath){
        let SLFriendCircleModel = dataSource[indexPath.section].items[indexPath.row].friendCircleModel
        if let SLFriendCircleModel = SLFriendCircleModel{
            UIUtil.sl_changeFriendCirclePrise(SLFriendCircleModel,positon:.home) {
                self.reloadTableView(indexPath)
            }
        }
    }
    
    func showComment(_ indexPath: IndexPath){
        let SLFriendCircleModel = dataSource[indexPath.section].items[indexPath.row].friendCircleModel
        if let model = SLFriendCircleModel{
            let vc = SLFriendsCircleController.init(isDetial: true, classCircleId: model.classCircleId)
            navigationController?.pushViewController(vc)
        }
    }
    
    func goToUserInfoController(_ indexPath: IndexPath){
        let friendCircleModel = dataSource[indexPath.section].items[indexPath.row].friendCircleModel
        UIUtil.sl_reduceHomeRed(serviceId: friendCircleModel?.classCircleId ?? 0, childId: friendCircleModel?.childrenId ?? 0)
        if let model = friendCircleModel{
            let vc = SLFriendsCircleInfoController.init(userId:  model.userIdPublisher ?? 0, childId: model.childrenId ?? 0, type: model.typePublisher ?? "")
            self.navigationController?.pushViewController(vc)
        }
    }
    
    
    // MARK: - tableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = dataSource[section]
        if sectionModel.hasSection{
            return sectionModel.items.count == 0 ? 0 : 41
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.section].items[indexPath.row]
        var cell: SLHomeBaseCell!
        if model.type == .classstart{
            cell = tableView.dequeueReusableCell(withIdentifier: "SLHomeClassStartCell") as? SLHomeBaseCell
        }else if  model.type == .friendCicle{
            cell = tableView.dequeueReusableCell(withIdentifier: "SLHomeFriendCell") as? SLHomeBaseCell
            if let friendCell = cell as? SLHomeFriendCell{
                friendCell.headerBlock = {[weak self](type) in
                    guard let strongSelf = self else { return }
                    switch type {
                    case .comment:
                        strongSelf.showComment(indexPath)
                    case .praise:
                        strongSelf.changePrise(indexPath)
                    case .recall:
                        strongSelf.dealCellEvent(.recall, indexPath: indexPath)
                    case .showAll:
                        strongSelf.reloadTableView(indexPath,isScroll: !model.isShowAll)
                    case .goToUserInfo:
                        strongSelf.goToUserInfoController(indexPath)
                    case .share:
                        let SLFriendCircleModel = strongSelf.dataSource[indexPath.section].items[indexPath.row].friendCircleModel
                        UIUtil.sl_shareLink(requestModel: HMRequestShareModel.init(classCircleId: SLFriendCircleModel?.classCircleId ?? 0,classCircleType: SLFriendCircleModel?.circleType ?? HMClassCircleType.CIRCLE), shareModel: SLShareModel(way: SLShareWayType.QQSession, title: "\(SLFriendCircleModel?.namePublisher ?? "")分享了一条优成长", descriptionText: SLFriendCircleModel?.shareText ?? "", link: ""))
                        break
                    }
                }
            }
            
        }else if model.type == .notice{
            cell = tableView.dequeueReusableCell(withIdentifier: "SLNoticeListHomeCell") as? SLHomeBaseCell
        }
        else if model.type == .homework{
            cell = tableView.dequeueReusableCell(withIdentifier: "SLHomeworkListHomeCell") as? SLHomeBaseCell
        }else if model.type == .punchCard{
            cell = tableView.dequeueReusableCell(withIdentifier: "SLPunchCardListHomeCell") as? SLHomeBaseCell
        }else if model.type == .solitaire{
            cell = tableView.dequeueReusableCell(withIdentifier: "SLSolitaireListHomeCell") as? SLHomeBaseCell
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "SLHomeCell") as? SLHomeBaseCell
        }
        cell.isSingleHome = isSingleHome
        cell.sl_setCellModel(model)
        cell.cellLongTapEvent = {[weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.showTopAlert(indexPath: indexPath)
        }
        cell.cellBlock = {[weak self] (type: HomeCellEvent) in
            guard let strongSelf = self else { return }
            strongSelf.dealCellEvent(type, indexPath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SLHomeTableSectionView") as! SLHomeTableSectionView
        headerView.setSectionModel(dataSource[section])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var  identifier = "SLHomeCell"
        let model = dataSource[indexPath.section].items[indexPath.row]
        switch model.type {
        case .classstart:
            identifier = "SLHomeClassStartCell"
        case .friendCicle:
            identifier = "SLHomeFriendCell"
        case .notice:
            identifier = "SLNoticeListHomeCell"
        case .punchCard:
            identifier = "SLPunchCardListHomeCell"
        case .solitaire:
            identifier = "SLSolitaireListHomeCell"
        case .homework:
            identifier = "SLHomeworkListHomeCell"
        default:
            break
        }
        return self.tableView.fd_heightForCell(withIdentifier: identifier, cacheBy: indexPath) { (cell) in
            if let cell = cell as? SLHomeBaseCell{
                cell.sl_setCellModel(model)
            }
        }
    }
    
    // MARK: -getter&setter
    lazy var publishButton: SLButton = {
        let button = SLButton()
        button.setBackgroundImage(UIImage.init(named: "publish"), for: .normal)
        button.addTarget(self, action: #selector(publishClick), for: .touchUpInside)
        return button
    }()
    
    lazy var tableFooterView: SLHomeTableFooterView = {
        let tableFooterView = SLHomeTableFooterView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 66.5))
        return tableFooterView
    }()
}

// MARK: - 通知
extension SLHomeBaseController{
    @objc func addNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(sl_refreshData), name: NSNotification.Name.init(rawValue: kAddClassSucessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sl_refreshData), name: NSNotification.Name.init(rawValue: kQuitClassSucessNotification), object: nil)
        
        //置顶通知
        NotificationCenter.default.addObserver(self, selector: #selector(sl_refreshData), name: NSNotification.Name.init(rawValue: kOperationUpdateToTopInItemListNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sl_refreshData), name: NSNotification.Name.init(rawValue: kOperationUpdateToTopInItemDetailNotification), object: nil)
        
        //撤销通知
        NotificationCenter.default.addObserver(self, selector: #selector(updateListForRecall), name: NSNotification.Name.init(rawValue: kOperationRecallInSingleClassHomeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateListForRecall), name: NSNotification.Name.init(rawValue: kOperationRecallInItemListNotification), object: nil)
        
        //点赞通知
        NotificationCenter.default.addObserver(self, selector: #selector(updateListForPraise), name: NSNotification.Name.init(rawValue: kOperationPraiseInItemListNotification), object: nil)
        
        //发布成功
        NotificationCenter.default.addObserver(self, selector: #selector(sl_refreshData), name: NSNotification.Name.init(rawValue: kTeacherPublishSucessNotification), object: nil)
        
        //家长提交成功
        NotificationCenter.default.addObserver(self, selector: #selector(updateListForCommint), name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: nil)
        //家长阅读成功
        NotificationCenter.default.addObserver(self, selector: #selector(updateListForRead), name: NSNotification.Name.init(rawValue: kParentReadSucessNotification), object: nil)
        
        //家长撤销
        NotificationCenter.default.addObserver(self, selector: #selector(sl_refreshData), name: NSNotification.Name.init(rawValue: kOperationStudentWorkNotification), object: nil)
        
    }
    
    @objc func updateListForPraise(_ notification:Notification){
        let userInfo = notification.object as? [String: Any]
        if let isCancel = userInfo?[kNotificationIsCancelKey] as? Bool,let praiseModel = userInfo?[kNotificationModelKey] as? SLFriendsPraiseModel,let classCircleId = userInfo?[kNotificationIdKey] as? Int{
            for (section,sectionModel) in dataSource.enumerated(){
                for (row,model) in sectionModel.items.enumerated(){
                    if let SLFriendCircleModel = model.friendCircleModel{
                        if SLFriendCircleModel.classCircleId == classCircleId{
                            if isCancel{
                                if var praiseList = SLFriendCircleModel.praises{
                                    for praise in praiseList{
                                        if praiseModel.userId == praise.userId && praiseModel.userType == praise.userType{
                                            praiseList.remove(at: praiseList.firstIndex(of: praise) ?? 0)
                                            SLFriendCircleModel.praises = praiseList
                                            reloadTableView(IndexPath.init(row: row, section: section))
                                            break
                                        }
                                    }
                                }
                                
                                
                            }else{
                                if var praises = SLFriendCircleModel.praises{
                                    praises.append(praiseModel)
                                    SLFriendCircleModel.praises = praises
                                }else{
                                    SLFriendCircleModel.praises = [praiseModel]
                                }
                                reloadTableView(IndexPath.init(row: row, section: section))
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func updateListForRecall(_ notification:Notification){
        let userInfo = notification.object as? [String: Any]
        if let serviceId = userInfo?[kNotificationIdKey] as? Int{
            for (section,sectionModel) in dataSource.enumerated(){
                for (row,model) in sectionModel.items.enumerated(){
                    if model.serviceId == serviceId{
                        dataSource[section].items.remove(at: row)
                        tableView.reloadData()
                        break
                    }
                }
            }
        }
    }
    
    @objc func updateListForRead(_ notification:Notification){
        let userInfo = notification.object as? [String: Any]
        if let notificationModel = userInfo?[kNotificationModelKey] as? SLHomeListModel{
            for (section,sectionModel) in dataSource.enumerated(){
                for (row,model) in sectionModel.items.enumerated(){
                    if model.serviceId == notificationModel.serviceId{
                        model.isRead = 1
                        reloadTableView(IndexPath.init(row: row, section: section))
                        break
                    }
                }
            }
        }
    }
    
    @objc func updateListForCommint(_ notification:Notification){
        let userInfo = notification.object as? [String: Any]
        if let notificationModel = userInfo?[kNotificationModelKey] as? SLHomeListModel{
            for (section,sectionModel) in dataSource.enumerated(){
                for (row,model) in sectionModel.items.enumerated(){
                    if model.serviceId == notificationModel.serviceId{
                        model.commitState = 2
                        reloadTableView(IndexPath.init(row: row, section: section))
                        break
                    }
                }
            }
        }else if let id = userInfo?[kNotificationIdKey] as? Int{
            for (section,sectionModel) in dataSource.enumerated(){
                for (row,model) in sectionModel.items.enumerated(){
                    if model.serviceId == id{
                        model.commitState = 2
                        if model.type == .solitaire{
                            model.remarkList?.append(model.childrenId ?? 0)
                            if model.commitCount == model.commitUpperLimit{
                                model.state = 100
                            }
                        }else if model.type == .punchCard{//打卡更新剩余人数
                            //                            model.surplusClockInDayCount = (model.surplusClockInDayCount ?? 0) - 1
                        }
                        
                        reloadTableView(IndexPath.init(row: row, section: section))
                        break
                    }
                }
            }
        }
        else{
            sl_refreshData()
        }
    }
}
