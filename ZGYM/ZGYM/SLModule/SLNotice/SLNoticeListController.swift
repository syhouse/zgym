//
//  SLNoticeListController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/29.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//


import UIKit
import ObjectMapper
import NightNight

class SLNoticeListController: SLCommonScreenListBaseController {
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
        
        selectModels = [SLSelectModel.init(text: "全部来源", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),SLSelectModel.init(text: "仅看我发布的", isSelect: false, paramsKey: SLCommonScreenSelectType.myPublish.rawValue)]
        
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        tableView.register(SLNoticeListCell.self, forCellReuseIdentifier: "SLNoticeListCell")
        tableView.fd_debugLogEnabled = true
        
        if SLPersonDataModel.sharePerson.personRole == .TEACHER && !isAgenda{
            rightButton.isHidden = false
        }else{
            rightButton.isHidden = true
        }
    }
    
    // MARK: -UI
    
    // MARK: -loadData
    override func sl_refreshData() {
        self.curruntPage = 1
        loadData()
    }
    
    override func sl_loadNextPage() {
        loadData()
    }
    
    override func loadData(){
        if !SLPersonDataModel.sharePerson.isNetWorkingConnect{
            self.dataSource = SLCacheHelper.sl_getCacheNoticeList()
            self.sl_endingRefresh()
            self.tableView.reloadData()
            return
        }
        
        var request: SLBaseRequset!
        if isAgenda{
            if SLPersonDataModel.sharePerson.personRole == .TEACHER{
                request = SLEducationNoticePageQueryTeacherTodoRequest.init(currentPage: curruntPage)
            }else{
                request = SLEducationNoticePageQueryChildrenTodoRequest.init(currentPage: curruntPage, childrenClassList: sl_childrenClassList)
            }
        }else{
            let classIdList = classId == nil ? (sl_user.gradeIds ?? []) : [classId!]
            var filterType: Int?
            switch selectType {
            case .all:
                filterType = nil
            case .myPublish:
                filterType = 0
            default:
                break
            }
            request = SLEducationNoticePageQueryRequest.init(currentPage: curruntPage, classIdList: classIdList, userType: sl_user.type ?? "", filterType: filterType)
        }
        request.request({ (result) in
            if self.curruntPage == 1{
                self.dataSource.removeAll()
            }
            let list = Mapper<SLHomeListModel>().mapArray(JSONObject: result["noticeList"].object) ?? [SLHomeListModel]()
            self.dataSource += self.sl_dealList(list: list, childId: self.childId, isAgenda: self.isAgenda)
            self.loadMore = result["hasNext"].boolValue
            self.sl_endingRefresh()
            SLCacheHelper.sl_cacheNoticeList(dataSource: self.dataSource)
            self.tableView.reloadData()
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
            self.sl_endingRefresh()
        }
    }
    
    override func reloadTableView(_ indexPath: IndexPath? = nil, isScroll : Bool = false) {
        super.reloadTableView(indexPath, isScroll :isScroll)
        SLCacheHelper.sl_cacheNoticeList(dataSource: self.dataSource)
    }
    
    // MARK: -action
    func dealCellEvent(_ cellType: HomeCellEvent, indexPath: IndexPath){
        let model = dataSource[indexPath.row]
        switch cellType {
        case .showAll:
            UIUtil.sl_loadReadData(model)
            reloadTableView(indexPath, isScroll:  !model.isShowAll)
        case .read:
            UIUtil.sl_loadReadData(model)
            reloadTableView(indexPath)
        case .punchRemind:
            sl_showAlert(title: "punchRemind")
        case .recall:
            UIUtil.sl_loadRecallData(model,positon: .list){
                self.dataSource.remove(at: indexPath.row)
                self.reloadTableView()
            }
        case .noticeReceipt:
            MBProgressHUD.sl_showLoading()
            SLEducationNoticeCustodianCommitReceiptRequest(noticeId: model.serviceId ?? 0, childrenId: model.childrenId ?? 0, noticeCreateTime: model.createTime ?? "").request({ (json) in
                MBProgressHUD.sl_showMessage(message: "提交成功")
                model.commitState = 2
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationModelKey: model])
                UIUtil.sl_reduceHomeRed(serviceId: model.serviceId ?? 0, childId: model.childrenId ?? 0)
                UIUtil.sl_reduceAgenda(serviceId: model.serviceId ?? 0, info: [kEventKey: HomeType.notice])
                self.reloadTableView()
            }) { (msg, code) in
                MBProgressHUD.sl_showMessage(message: msg)
            }
            UIUtil.sl_loadReadData(model,showLoading: false)
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
        return self.tableView.fd_heightForCell(withIdentifier: "SLNoticeListCell", cacheBy: indexPath) { (cell) in
            if let cell = cell as? SLNoticeListCell{
                let model = self.dataSource[indexPath.row]
                cell.sl_setCellModel(model)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SLNoticeListCell = tableView.dequeueReusableCell(withIdentifier: "SLNoticeListCell") as! SLNoticeListCell
        cell.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        let model = self.dataSource[indexPath.row]
        cell.cellBlock = {[weak self] (type: HomeCellEvent) in
            guard let strongSelf = self else { return }
            strongSelf.dealCellEvent(type, indexPath: indexPath)
        }
        cell.cellLongTapEvent = {[weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.showTopAlert(indexPath: indexPath)
        }
        cell.sl_setCellModel(model)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        UIUtil.sl_loadReadData(model)
        reloadTableView(indexPath)
        let detailVC = SLNoticeDetailViewController.init(model: model)
        self.navigationController?.pushViewController(detailVC)
        
        if isAgenda && SLPersonDataModel.sharePerson.personRole == .TEACHER{
            UIUtil.sl_reduceAgenda(serviceId: model.serviceId ?? 0, info: [kEventKey: HomeType.notice])
//            self.dataSource.remove(at: indexPath.row)
//            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - getter&setter
    
}
