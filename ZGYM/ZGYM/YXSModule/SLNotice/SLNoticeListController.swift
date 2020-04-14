//
//  SLNoticeListController.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/29.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//


import UIKit
import ObjectMapper
import NightNight

class SLNoticeListController: YXSCommonScreenListBaseController {
    /// 是否今日事项列表
    var isAgenda: Bool = false
    override init(classId: Int?, childId: Int?) {
        super.init(classId: classId, childId: childId)
        actionEvent = .notice
    }
    
    convenience init(isAgenda: Bool){
        self.init(classId: nil, childId: nil)
        self.isAgenda = isAgenda
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = isAgenda ? "通知待办" : "通知"
        
        selectModels = [YXSSelectModel.init(text: "全部来源", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),YXSSelectModel.init(text: "仅看我发布的", isSelect: false, paramsKey: SLCommonScreenSelectType.myPublish.rawValue)]
        
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        tableView.register(SLNoticeListCell.self, forCellReuseIdentifier: "SLNoticeListCell")
        tableView.fd_debugLogEnabled = true
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER && !isAgenda{
            rightButton.isHidden = false
        }else{
            rightButton.isHidden = true
        }
        
        let list = YXSCacheHelper.yxs_getCacheNoticeList(childrenId: self.yxs_user.curruntChild?.id, isAgent: isAgenda)
        for (index, model) in list.enumerated(){
            if index < 7{
               self.dataSource.append(model)
            }
        }
        SLLog("viewDidLoad")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SLLog("viewDidAppear")
        self.dataSource = YXSCacheHelper.yxs_getCacheNoticeList(childrenId: self.yxs_user.curruntChild?.id, isAgent: isAgenda)
        self.tableView.reloadData()
    }
    
    // MARK: -UI
    
    // MARK: -loadData
    override func yxs_refreshData() {
        self.curruntPage = 1
        loadData()
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    override func loadData(){
        var request: YXSBaseRequset!
        if isAgenda{
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                request = YXSEducationNoticePageQueryTeacherTodoRequest.init(currentPage: curruntPage)
            }else{
                request = YXSEducationNoticePageQueryChildrenTodoRequest.init(currentPage: curruntPage, childrenClassList: yxs_childrenClassList)
            }
        }else{
            let classIdList = classId == nil ? (yxs_user.gradeIds ?? []) : [classId!]
            var filterType: Int?
            switch selectType {
            case .all:
                filterType = nil
            case .myPublish:
                filterType = 0
            default:
                break
            }
            request = YXSEducationNoticePageQueryRequest.init(currentPage: curruntPage, classIdList: classIdList, userType: yxs_user.type ?? "", filterType: filterType)
        }
        request.request({ (result) in
            if self.curruntPage == 1{
                self.dataSource.removeAll()
            }
            let list = Mapper<YXSHomeListModel>().mapArray(JSONObject: result["noticeList"].object) ?? [YXSHomeListModel]()
            self.dataSource += self.yxs_dealList(list: list, childId: self.childId, isAgenda: self.isAgenda)
            self.loadMore = result["hasNext"].boolValue
            self.yxs_endingRefresh()
            self.tableView.reloadData()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
            self.yxs_endingRefresh()
        }
    }
    
    override func reloadTableView(_ indexPath: IndexPath? = nil, isScroll : Bool = false) {
        super.reloadTableView(indexPath, isScroll :isScroll)
    }
    
    // MARK: -action
    func dealCellEvent(_ cellType: YXSHomeCellEvent, indexPath: IndexPath){
        let model = dataSource[indexPath.row]
        switch cellType {
        case .showAll:
            UIUtil.yxs_loadReadData(model)
            reloadTableView(indexPath, isScroll:  !model.isShowAll)
        case .read:
            UIUtil.yxs_loadReadData(model)
            reloadTableView(indexPath)
        case .punchRemind:
            yxs_showAlert(title: "punchRemind")
        case .recall:
            UIUtil.yxs_loadRecallData(model,positon: .list){
                self.dataSource.remove(at: indexPath.row)
                self.reloadTableView()
            }
        case .noticeReceipt:
            MBProgressHUD.yxs_showLoading()
            YXSEducationNoticeCustodianCommitReceiptRequest(noticeId: model.serviceId ?? 0, childrenId: model.childrenId ?? 0, noticeCreateTime: model.createTime ?? "").request({ (json) in
                MBProgressHUD.yxs_showMessage(message: "提交成功", inView: self.navigationController?.view)
                model.commitState = 2
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationModelKey: model])
                UIUtil.yxs_reduceHomeRed(serviceId: model.serviceId ?? 0, childId: model.childrenId ?? 0)
                UIUtil.yxs_reduceAgenda(serviceId: model.serviceId ?? 0, info: [kEventKey: YXSHomeType.notice])
                self.reloadTableView()
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
            UIUtil.yxs_loadReadData(model,showLoading: false)
        default:
            break
        }
    }
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataSource[indexPath.row]
        let key = "\(model.serviceId ?? 0)\(model.isShowAll)\(YXSPersonDataModel.sharePerson.personRole.rawValue)"
        if model.isShowAll{
            if let cacheShowAllHeight = model.cacheShowAllHeight{
                return cacheShowAllHeight
            }else{
                let height = self.tableView.fd_heightForCell(withIdentifier: "SLNoticeListCell", cacheByKey: key as NSCopying) { (cell) in
                    if let cell = cell as? SLNoticeListCell{
                        cell.yxs_setCellModel(model)
                    }
                }
                model.cacheShowAllHeight = height
                YXSCacheHelper.yxs_cacheNoticeList(dataSource: self.dataSource, childrenId: self.yxs_user.curruntChild?.id, isAgent: self.isAgenda)
                return height
            }
        }else{
            if let cacheNormaHeight = model.cacheNormaHeight{
                return cacheNormaHeight
            }else{
                let height = self.tableView.fd_heightForCell(withIdentifier: "SLNoticeListCell", cacheByKey: key as NSCopying) { (cell) in
                    if let cell = cell as? SLNoticeListCell{
                        cell.yxs_setCellModel(model)
                    }
                }
                model.cacheNormaHeight = height
                YXSCacheHelper.yxs_cacheNoticeList(dataSource: self.dataSource, childrenId: self.yxs_user.curruntChild?.id, isAgent: self.isAgenda)
                return height
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SLNoticeListCell = tableView.dequeueReusableCell(withIdentifier: "SLNoticeListCell") as! SLNoticeListCell
        cell.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        let model = self.dataSource[indexPath.row]
        cell.cellBlock = {[weak self] (type: YXSHomeCellEvent) in
            guard let strongSelf = self else { return }
            strongSelf.dealCellEvent(type, indexPath: indexPath)
        }
        cell.cellLongTapEvent = {[weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.showTopAlert(indexPath: indexPath)
        }
        cell.yxs_setCellModel(model)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        UIUtil.yxs_loadReadData(model)
        reloadTableView(indexPath)
        let detailVC = SLNoticeDetailViewController.init(model: model)
        self.navigationController?.pushViewController(detailVC)
        
        if isAgenda && YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            UIUtil.yxs_reduceAgenda(serviceId: model.serviceId ?? 0, info: [kEventKey: YXSHomeType.notice])
//            self.dataSource.remove(at: indexPath.row)
//            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - getter&setter
    
}
