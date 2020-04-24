//
//  YXSHomeBaseController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/13.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSHomeBaseController: YXSBaseTableViewController{
    // MARK: - property
    var yxs_dataSource: [YXSHomeSectionModel] = [YXSHomeSectionModel]()
    
    /// 是否是单个班级首页
    var isSingleHome: Bool = false
    
    /// 是否是空
    var hasDataSource: Bool{
        get{
            var hasDataSource = false
            for section in yxs_dataSource{
                if section.items.count > 0{
                    hasDataSource = true
                    break
                }
            }
            return hasDataSource
        }
    }
    
    let group = DispatchGroup()
    
    let queue = DispatchQueue.global()

    // MARK: - leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        yxs_initModel()
        yxs_addNotification()
        
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kTabBottomHeight)
        }
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        
        
        tableView.sectionFooterHeight = 0.0
        tableView.register(SLNoticeListHomeCell.self, forCellReuseIdentifier: "SLNoticeListHomeCell")
        tableView.register(SLHomeworkListHomeCell.self, forCellReuseIdentifier: "SLHomeworkListHomeCell")
        tableView.register(YXSHomeClassStartCell.self, forCellReuseIdentifier: "SLHomeClassStartCell")
        tableView.register(YXSHomeFriendCell.self, forCellReuseIdentifier: "SLHomeFriendCell")
        tableView.register(YXSHomeBaseCell.self, forCellReuseIdentifier: "YXSHomeBaseCell")
        tableView.register(YXSPunchCardListHomeCell.self, forCellReuseIdentifier: "SLPunchCardListHomeCell")
        tableView.register(SLSolitaireListHomeCell.self, forCellReuseIdentifier: "SLSolitaireListHomeCell")
        
        tableView.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 0.01))
        //老师展示发布
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            view.addSubview(publishButton)
            publishButton.snp.makeConstraints { (make) in
                make.right.equalTo(-15)
                make.bottom.equalTo(-kTabBottomHeight - 15)
                make.size.equalTo(CGSize.init(width: 51.5, height: 51.5))
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - loadData
    override func yxs_refreshData() {
        curruntPage = 1
        yxs_loadData()
    }
    
    override func yxs_loadNextPage() {
        yxs_loadData()
    }
    
    /// 子类需重写
    public func yxs_loadData(){
        
    }
    
    /// 更新置顶请求 子类需重写
    public func yxs_homeLoadUpdateTopData(type: YXSHomeType,id: Int = 0,createTime:String = "", isTop: Int = 0,sucess: (()->())? = nil){
        
    }
    /// 撤回请求 子类需重写
    public func yxs_homeyxs_loadRecallData(model: YXSHomeListModel,sucess: (()->())? = nil){
        
    }
    
    // MARK: - public Tool
    ///清空数据
    public func yxs_removeAll(){
        for model in yxs_dataSource{
            model.items.removeAll()
        }
    }
    
    /// 刷新底部视图
    public func yxs_reloadFooterView(){
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
    
    // MARK: - private
    /// 初始化model
    private func yxs_initModel(){
        for index in 0...2{
            let sectionModel = YXSHomeSectionModel()
            if index == 1{
                sectionModel.hasSection = true
                sectionModel.showText = "今天的消息"
            }else if index == 2{
                sectionModel.hasSection = true
                sectionModel.showText = "更早消息"
            }
            sectionModel.items = [YXSHomeListModel]()
            self.yxs_dataSource.append(sectionModel)
        }
    }
    
    ///更新置顶
    private func yxs_updateTopEvent(model: YXSHomeListModel){
        self.yxs_homeLoadUpdateTopData(type: model.type, id: model.serviceId ?? 0, createTime: model.createTime ?? "", isTop: (model.isTop ?? 0)  == 1 ? 0 : 1){
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.yxs_refreshData()
        }
    }
    /// cell block
    /// - Parameters:
    ///   - cellType: 点击类型
    ///   - indexPath: 当前indexPath
    private func yxs_dealCellEvent(_ cellType: YXSHomeCellEvent, indexPath: IndexPath){
        let model = yxs_dataSource[indexPath.section].items[indexPath.row]
        switch cellType {
        case .showAll:
            UIUtil.yxs_loadReadData(model)
            self.yxs_reloadTableView(indexPath,isScroll: !model.isShowAll)
        case .read:
            UIUtil.yxs_loadReadData(model)
            self.yxs_reloadTableView(indexPath)
        case .punchRemind:
            let vc = YXSPunchCardMembersListViewController.init(clockInId: model.serviceId ?? 0,classId: model.classId ?? 0)
            self.navigationController?.pushViewController(vc)
        case .goPunch:
            let vc = YXSPunchCardDetialController.init(clockInId: model.serviceId ?? 0,childId: model.childrenId, classId:model.classId ?? 0)
            self.navigationController?.pushViewController(vc)
        case .recall:
            yxs_homeyxs_loadRecallData(model: model) {
                self.yxs_dataSource[indexPath.section].items.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
        case .noticeReceipt:
            MBProgressHUD.yxs_showLoading()
            YXSEducationNoticeCustodianCommitReceiptRequest(noticeId: model.serviceId ?? 0, childrenId: model.childrenId ?? 0, noticeCreateTime: model.createTime ?? "").request({ (json) in
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationModelKey: model])
                UIUtil.yxs_reduceAgenda(serviceId: model.serviceId ?? 0, info: [kEventKey: YXSHomeType.notice])
                UIUtil.yxs_reduceHomeRed(serviceId: model.serviceId ?? 0, childId: model.childrenId ?? 0)
                MBProgressHUD.yxs_hideHUD()
                MBProgressHUD.yxs_showMessage(message: "提交成功", inView: self.navigationController?.view)
                model.commitState = 2
                self.yxs_reloadTableView(indexPath)
            }) { (msg, code) in
                MBProgressHUD.yxs_hideHUDInView(view: self.navigationController?.view)
                MBProgressHUD.yxs_showMessage(message: msg)
            }
            UIUtil.yxs_loadReadData(model,showLoading: false)
        case .cancelStick:
            YXSCommonAlertView.showAlert(title: "是否取消置顶", message: "", leftTitle: "取消", rightTitle: "确定", rightClick: {
                [weak self] in
                guard let strongSelf = self else { return }
                UIUtil.yxs_loadUpdateTopData(type: model.type, id: model.serviceId ?? 0, createTime:  model.createTime ?? "", isTop: 0, positon: strongSelf.isSingleHome ? YXSOperationPosition.singleHome : YXSOperationPosition.home) {
                    strongSelf.yxs_refreshData()
                }
            })
            break
        default:
            break
        }
    }
    
    /// 刷新tableView
    /// - Parameters:
    ///   - indexPath: 刷新指定indexPath
    ///   - isScroll: 是否滚动到当前indexPath
    public func yxs_reloadTableView(_ indexPath: IndexPath, isScroll: Bool = false){
        if !isSingleHome{
//            YXSCacheHelper.yxs_cacheHomeList(dataSource: self.yxs_dataSource)
        }
        UIView.performWithoutAnimation {
            let cell = tableView.cellForRow(at: indexPath)
            tableView.reloadRows(at: [indexPath], with: .none)
            if isScroll{
                if let cell = cell, isScroll{
                    let rc = tableView.convert(cell.frame, to: self.view)
                    SLLog(rc)
                    //首页 底部高度  滚动有问题
                    let top:CGFloat = isSingleHome ? 0.0 : 64.0 + 49.0
                    if rc.minY < top{
                        //展开全文滚动滚回来
                        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition:.top)
                        var offset = self.tableView.contentOffset
                        offset.y -= top
                        self.tableView.setContentOffset(offset, animated: false)
                    }else if rc.minY + rc.height > self.tableView.height{
                        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition:.top)
                        var offset = self.tableView.contentOffset
                        offset.y -= top
                        self.tableView.setContentOffset(offset, animated: false)
                        
                    }
                }
            }
        }
        
        
    }
    
    /// 点击当前cell跳转
    /// - Parameters:
    ///   - indexPath: cell indexPath
    ///   - childModel: 当前孩子(家长必填)
    func dealSelectRow(didSelectRowAt indexPath: IndexPath, childModel: YXSChildrenModel?){
        let childId = childModel?.id
        
        //为什么有时候会进来导致crash
        if yxs_dataSource[indexPath.section].items.count < indexPath.row{
            return
        }
        let model = yxs_dataSource[indexPath.section].items[indexPath.row]
        ///家长身份标记已读
        if YXSPersonDataModel.sharePerson.personRole == .PARENT && model.isRead == 0{
            UIUtil.yxs_loadReadData(yxs_dataSource[indexPath.section].items[indexPath.row])
            yxs_reloadTableView(indexPath)
        }
        switch model.type {
        case .homework:
            yxs_pushHomeDetailVC(homeModel: model)
        case .punchCard:
            let vc = YXSPunchCardDetialController.init(clockInId: model.serviceId ?? 0, childId: childModel?.id,classId: model.classId ?? 0)
            navigationController?.pushViewController(vc)
        case .solitaire:
            let vc = YXSSolitaireDetailController.init(censusId: model.serviceId ?? 0, childrenId: childId ?? 0, classId: model.classId ?? 0)
            navigationController?.pushViewController(vc)
        case .notice:
            let vc = YXSNoticeDetailViewController.init(model: model)
            navigationController?.pushViewController(vc)
        case .classstart:
            if let childModel = childModel{
                UIUtil.yxs_reduceHomeRed(serviceId: model.serviceId ?? 0, childId: childModel.id ?? 0)
                UIUtil.curruntNav().pushViewController(YXSClassStarPartentDetialController.init(childrenModel: childModel, startTime: model.startTime,endTime: model.endTime))
            }
        case .friendCicle:
            yxs_showComment(indexPath)
        default:
            break
        }
    }
    
    // MARK: - action
    
    /// 展示置顶视图
    /// - Parameter indexPath: 操作当前indexPath
    private func yxs_showTopAlert(indexPath: IndexPath){
        
        let listModel = yxs_dataSource[indexPath.section].items[indexPath.row]
        YXSCommonBottomAlerView.showIn(topButtonTitle: ((listModel.isTop ?? 0)  == 1) ? "取消置顶" : "置顶") { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.yxs_updateTopEvent(model: listModel)
        }
    }
    
    /// 老师发布
    @objc func yxs_publishClick(){
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER && (yxs_user.gradeIds == nil || yxs_user.gradeIds!.count == 0){
            UIUtil.curruntNav().pushViewController(YXSTeacherClassListViewController())
            return
        }
        YXSHomePublishView.showAlert {[weak self] (event) in
            guard let strongSelf = self else { return }
            strongSelf.yxs_dealPublishAction(event,classId: nil)
        }
        
    }
    
    // MARK: - 优成长Event
    ///点赞
    private func yxs_changePrise(_ indexPath: IndexPath){
        let YXSFriendCircleModel = yxs_dataSource[indexPath.section].items[indexPath.row].friendCircleModel
        if let YXSFriendCircleModel = YXSFriendCircleModel{
            UIUtil.yxs_changeFriendCirclePrise(YXSFriendCircleModel,positon:.home) {
                self.yxs_reloadTableView(indexPath)
            }
        }
    }
    ///点评
    private func yxs_showComment(_ indexPath: IndexPath){
        let YXSFriendCircleModel = yxs_dataSource[indexPath.section].items[indexPath.row].friendCircleModel
        if let model = YXSFriendCircleModel{
            let vc = YXSFriendsCircleController.init(classCircleId: model.classCircleId)
            navigationController?.pushViewController(vc)
        }
    }
    ///点击头像去个人详情
    private func yxs_goToUserInfoController(_ indexPath: IndexPath){
        let friendCircleModel = yxs_dataSource[indexPath.section].items[indexPath.row].friendCircleModel
        UIUtil.yxs_reduceHomeRed(serviceId: friendCircleModel?.classCircleId ?? 0, childId: friendCircleModel?.childrenId ?? 0)
        if let model = friendCircleModel{
            let vc = YXSFriendsCircleInfoController.init(userId:  model.userIdPublisher ?? 0, childId: model.childrenId ?? 0, type: model.typePublisher ?? "")
            self.navigationController?.pushViewController(vc)
        }
    }
    
    
    // MARK: - tableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return yxs_dataSource.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yxs_dataSource[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = yxs_dataSource[section]
        if sectionModel.hasSection{
            return sectionModel.items.count == 0 ? 0 : 41
        }
        return 0
    }
    
//    ///处理预加载数据
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if loadMore{
//            var totalCount = 0
//            for items in self.yxs_dataSource{
//                totalCount += items.items.count
//            }
//            var curruntCounts = 0
//            for index in 0...indexPath.section{
//                if index < indexPath.section{
//                    curruntCounts += yxs_dataSource[index].items.count
//                }else{
//                    curruntCounts += indexPath.row + 1
//                }
//
//            }
//
//            if curruntCounts >= totalCount - kPreloadSize{
//                if !isSingleHome{///单个详情页 tableview 会滑动跳到底部
////                    tableView.mj_footer?.beginRefreshing()
//                }
//            }
//        }
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if yxs_dataSource.count > indexPath.section {
            if yxs_dataSource[indexPath.section].items.count > indexPath.row {
                let model = yxs_dataSource[indexPath.section].items[indexPath.row]
                var cell: YXSHomeBaseCell!
                if model.type == .classstart{
                    cell = tableView.dequeueReusableCell(withIdentifier: "SLHomeClassStartCell") as? YXSHomeBaseCell
                }else if  model.type == .friendCicle{
                    cell = tableView.dequeueReusableCell(withIdentifier: "SLHomeFriendCell") as? YXSHomeBaseCell
                    if let friendCell = cell as? YXSHomeFriendCell{
                        friendCell.headerBlock = {[weak self](type) in
                            guard let strongSelf = self else { return }
                            switch type {
                            case .comment:
                                strongSelf.yxs_showComment(indexPath)
                            case .praise:
                                strongSelf.yxs_changePrise(indexPath)
                            case .recall:
                                strongSelf.yxs_dealCellEvent(.recall, indexPath: indexPath)
                            case .showAll:
                                strongSelf.yxs_reloadTableView(indexPath,isScroll: !model.isShowAll)
                            case .goToUserInfo:
                                strongSelf.yxs_goToUserInfoController(indexPath)
                            case .share:
                                let YXSFriendCircleModel = strongSelf.yxs_dataSource[indexPath.section].items[indexPath.row].friendCircleModel
                                UIUtil.yxs_shareLink(requestModel: HMRequestShareModel.init(classCircleId: YXSFriendCircleModel?.classCircleId ?? 0,classCircleType: YXSFriendCircleModel?.circleType ?? HMClassCircleType.CIRCLE), shareModel: YXSShareModel(way: YXSShareWayType.QQSession, title: "\(YXSFriendCircleModel?.namePublisher ?? "")分享了一条优成长", descriptionText: YXSFriendCircleModel?.shareText ?? "", link: ""))
                            }
                        }
                    }
                    
                }else if model.type == .notice{
                    cell = tableView.dequeueReusableCell(withIdentifier: "SLNoticeListHomeCell") as? YXSHomeBaseCell
                }
                else if model.type == .homework{
                    cell = tableView.dequeueReusableCell(withIdentifier: "SLHomeworkListHomeCell") as? YXSHomeBaseCell
                }else if model.type == .punchCard{
                    cell = tableView.dequeueReusableCell(withIdentifier: "SLPunchCardListHomeCell") as? YXSHomeBaseCell
                }else if model.type == .solitaire{
                    cell = tableView.dequeueReusableCell(withIdentifier: "SLSolitaireListHomeCell") as? YXSHomeBaseCell
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: "YXSHomeBaseCell") as? YXSHomeBaseCell
                }
                cell.isSingleHome = isSingleHome
                cell.yxs_setCellModel(model)
                cell.cellLongTapEvent = {[weak self]  in
                    guard let strongSelf = self else { return }
                    strongSelf.yxs_showTopAlert(indexPath: indexPath)
                }
                cell.cellBlock = {[weak self] (type: YXSHomeCellEvent) in
                    guard let strongSelf = self else { return }
                    strongSelf.yxs_dealCellEvent(type, indexPath: indexPath)
                }
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SLHomeTableSectionView") as! YXSHomeTableSectionView
        headerView.setSectionModel(yxs_dataSource[section])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = yxs_dataSource[indexPath.section].items[indexPath.row]
        model.isShowTag = true
        return model.height
    }
    
    // MARK: - getter&setter
    lazy var publishButton: YXSButton = {
        let button = YXSButton()
        button.setBackgroundImage(UIImage.init(named: "publish"), for: .normal)
        button.addTarget(self, action: #selector(yxs_publishClick), for: .touchUpInside)
        return button
    }()
    
    lazy var tableFooterView: YXSHomeTableFooterView = {
        let tableFooterView = YXSHomeTableFooterView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 66.5))
        return tableFooterView
    }()
}

// MARK: - 通知
extension YXSHomeBaseController{
    @objc func yxs_addNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_refreshData), name: NSNotification.Name.init(rawValue: kAddClassSucessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_refreshData), name: NSNotification.Name.init(rawValue: kQuitClassSucessNotification), object: nil)
        
        //置顶通知
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_refreshData), name: NSNotification.Name.init(rawValue: kOperationUpdateToTopInItemListNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_refreshData), name: NSNotification.Name.init(rawValue: kOperationUpdateToTopInItemDetailNotification), object: nil)
        
        //撤销通知
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_updateListForRecall), name: NSNotification.Name.init(rawValue: kOperationRecallInSingleClassHomeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_updateListForRecall), name: NSNotification.Name.init(rawValue: kOperationRecallInItemListNotification), object: nil)
        
        //点赞通知
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_updateListForPraise), name: NSNotification.Name.init(rawValue: kOperationPraiseInItemListNotification), object: nil)
        
        //发布成功
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_refreshData), name: NSNotification.Name.init(rawValue: kTeacherPublishSucessNotification), object: nil)
        
        //家长提交成功
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_updateListForCommint), name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: nil)
        //家长阅读成功
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_updateListForRead), name: NSNotification.Name.init(rawValue: kParentReadSucessNotification), object: nil)
        
        //家长撤销
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_refreshData), name: NSNotification.Name.init(rawValue: kOperationStudentWorkNotification), object: nil)
        
        //家长打卡撤销
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_refreshData), name: NSNotification.Name.init(rawValue: kOperationStudentCancelPunchCardNotification), object: nil)
        
    }
    
    ///点赞刷新
    @objc func yxs_updateListForPraise(_ notification:Notification){
        let userInfo = notification.object as? [String: Any]
        if let isCancel = userInfo?[kNotificationIsCancelKey] as? Bool,let praiseModel = userInfo?[kNotificationModelKey] as? YXSFriendsPraiseModel,let classCircleId = userInfo?[kNotificationIdKey] as? Int{
            for (section,sectionModel) in yxs_dataSource.enumerated(){
                for (row,model) in sectionModel.items.enumerated(){
                    if let YXSFriendCircleModel = model.friendCircleModel{
                        if YXSFriendCircleModel.classCircleId == classCircleId{
                            if isCancel{
                                if var praiseList = YXSFriendCircleModel.praises{
                                    for praise in praiseList{
                                        if praiseModel.userId == praise.userId && praiseModel.userType == praise.userType{
                                            praiseList.remove(at: praiseList.firstIndex(of: praise) ?? 0)
                                            YXSFriendCircleModel.praises = praiseList
                                            yxs_reloadTableView(IndexPath.init(row: row, section: section))
                                            break
                                        }
                                    }
                                }
                                
                                
                            }else{
                                if var praises = YXSFriendCircleModel.praises{
                                    praises.append(praiseModel)
                                    YXSFriendCircleModel.praises = praises
                                }else{
                                    YXSFriendCircleModel.praises = [praiseModel]
                                }
                                yxs_reloadTableView(IndexPath.init(row: row, section: section))
                            }
                        }
                    }
                }
            }
        }
    }
    ///老师撤销刷新
    @objc func yxs_updateListForRecall(_ notification:Notification){
        let userInfo = notification.object as? [String: Any]
        if let serviceId = userInfo?[kNotificationIdKey] as? Int{
            for (section,sectionModel) in yxs_dataSource.enumerated(){
                for (row,model) in sectionModel.items.enumerated(){
                    if model.serviceId == serviceId{
                        yxs_dataSource[section].items.remove(at: row)
                        tableView.reloadData()
                        break
                    }
                }
            }
        }
    }
    
    ///阅读成功刷新
    @objc func yxs_updateListForRead(_ notification:Notification){
        let userInfo = notification.object as? [String: Any]
        if let notificationModel = userInfo?[kNotificationModelKey] as? YXSHomeListModel{
            for (section,sectionModel) in yxs_dataSource.enumerated(){
                for (row,model) in sectionModel.items.enumerated(){
                    if model.serviceId == notificationModel.serviceId{
                        model.isRead = 1
                        yxs_reloadTableView(IndexPath.init(row: row, section: section))
                        break
                    }
                }
            }
        }
    }
    
    ///提交成功刷新
    @objc func yxs_updateListForCommint(_ notification:Notification){
        let userInfo = notification.object as? [String: Any]
        if let notificationModel = userInfo?[kNotificationModelKey] as? YXSHomeListModel{
            for (section,sectionModel) in yxs_dataSource.enumerated(){
                for (row,model) in sectionModel.items.enumerated(){
                    if model.serviceId == notificationModel.serviceId{
                        model.commitState = 2
                        yxs_reloadTableView(IndexPath.init(row: row, section: section))
                        break
                    }
                }
            }
        }else if let id = userInfo?[kNotificationIdKey] as? Int{
            for (section,sectionModel) in yxs_dataSource.enumerated(){
                for (row,model) in sectionModel.items.enumerated(){
                    if model.serviceId == id{
                        model.commitState = 2
                        if model.type == .solitaire{
                            model.remarkList?.append(model.childrenId ?? 0)
                            if model.commitCount == model.commitUpperLimit{
                                model.state = 100
                            }
                        }else if model.type == .punchCard{//打卡更新剩余人数
                        }
                        
                        yxs_reloadTableView(IndexPath.init(row: row, section: section))
                        break
                    }
                }
            }
        }
        else{
            yxs_refreshData()
        }
    }
}


// MARK: - other func
extension YXSHomeBaseController{
    func yxs_dealHomeBaseRootUI() {
        let button = UIButton.init()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("homeBase", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor(red: 250 / 255.0, green: 48 / 255.0, blue: 48 / 255.0, alpha: 0.4).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 12)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 15
    }
    
    func yxs_changeHomeBaseUI(_ cancelled: Bool) {
        let button = UIButton.init()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("homeBase", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor(red: 250 / 255.0, green: 48 / 255.0, blue: 48 / 255.0, alpha: 0.4).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 12)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 15
    }
    
    func yxs_addHomeBaseUI() {
        let button = UIButton.init()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("homeBase", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor(red: 250 / 255.0, green: 48 / 255.0, blue: 48 / 255.0, alpha: 0.4).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 12)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 15
    }
}
