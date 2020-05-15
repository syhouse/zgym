//
//  YXSPunchCardListController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/21.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import ObjectMapper
import NightNight

class YXSPunchCardListController: YXSCommonScreenListBaseController {
    /// 是否今日事项列表
    private var isAgenda: Bool = false
    
    private var yxs_punchCardDataSource = [YXSPunchCardModel]()
    
    // MARK: - init
    override init(classId: Int?, childId: Int?) {
        super.init(classId: classId, childId: childId)
        actionEvent  = .punchCard
    }
    
    convenience init(isAgenda: Bool){
        self.init(classId: nil, childId: nil)
        self.isAgenda = isAgenda
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = isAgenda ? "打卡待办" : "打卡"
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        
        if YXSPersonDataModel.sharePerson.personRole == .PARENT{
            selectModels = [YXSSelectModel.init(text: "全部", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),YXSSelectModel.init(text: "进行中", isSelect: false, paramsKey: SLCommonScreenSelectType.underway.rawValue),YXSSelectModel.init(text: "已结束", isSelect: false, paramsKey: SLCommonScreenSelectType.finish.rawValue)]
        }else{
            selectModels = [YXSSelectModel.init(text: "全部", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),YXSSelectModel.init(text: "进行中", isSelect: false, paramsKey: SLCommonScreenSelectType.underway.rawValue),YXSSelectModel.init(text: "已结束", isSelect: false, paramsKey: SLCommonScreenSelectType.finish.rawValue),YXSSelectModel.init(text: "我发布的", isSelect: false, paramsKey: SLCommonScreenSelectType.myPublish.rawValue)]
        }
        
        rightButton.isHidden = isAgenda
        
        self.yxs_punchCardDataSource = YXSCacheHelper.yxs_getCachePunchCardList(childrenId: self.yxs_user.currentChild?.id, isAgent: isAgenda)
    }
    
    override func yxs_updateList(_ notification: Notification) {
        let userInfo = notification.object as? [String: Any]
        if let id = userInfo?[kNotificationIdKey] as? Int{
            for (row,model) in yxs_punchCardDataSource.enumerated(){
                if model.clockInId == id{
                    model.state = 20
                    reloadTableView(IndexPath.init(row: row, section: 0))
                    break
                }
            }
        }
    }
    
    
    // MARK: -loadData
    override func yxs_refreshData() {
        self.currentPage = 1
        loadData()
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    //老师    打卡状态（0 全部 30 进行中（已打卡或者不需要打卡） 40 我发布的 100 已结束:按照打卡的结束时间 ）
    // 家长 打卡状态（0 全部 10 未打卡 20 进行中（已打卡或者不需要打卡） 100 已结束:按照打卡的结束时间 ）
    override func loadData(){
        var request: YXSBaseRequset!
        if isAgenda{
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                request = YXSEducationClockInTeacherTodoRequest.init(currentPage: currentPage)
            }else{
                request = YXSEducationClockInParentTodoRequest.init(currentPage: currentPage)
            }
        }else{
            var state: Int = 0
            switch selectType {
            case .all:
                state = 0
            case .myPublish:
                state = 40
            case .finish:
                state = 100
            case .underway:
                state = YXSPersonDataModel.sharePerson.personRole == .TEACHER ? 30 : 20
            default:
                break
            }
            if YXSPersonDataModel.sharePerson.personRole == .PARENT{
                request = YXSEducationClockInParentTaskListRequest.init(state: state, childrenId: childId ?? 0, currentPage: currentPage)
            }else{
                request = YXSEducationClockInTeacherTaskListRequest.init(state: state, classId: classId, currentPage: currentPage,stage: YXSPersonDataModel.sharePerson.personStage)
            }
        }
        request.requestCollection({ (list: [YXSPunchCardModel]) in
            self.yxs_endingRefresh()
            if self.currentPage == 1{
                self.yxs_punchCardDataSource.removeAll()
            }
            self.yxs_punchCardDataSource += self.yxs_dealList(list: list, childId: self.childId, isAgenda: self.isAgenda)
            self.loadMore = list.count >= kPageSize
            YXSCacheHelper.yxs_cachePunchCardList(dataSource: self.yxs_punchCardDataSource,childrenId: self.yxs_user.currentChild?.id, isAgent: self.isAgenda)
            self.tableView.reloadData()
        }) { (msg, code) in
            self.yxs_endingRefresh()
        }
        
    }
    
    override func reloadTableView(_ indexPath: IndexPath? = nil, isScroll : Bool = false) {
        super.reloadTableView(indexPath,isScroll: isScroll)
        YXSCacheHelper.yxs_cachePunchCardList(dataSource: self.yxs_punchCardDataSource,childrenId: self.yxs_user.currentChild?.id, isAgent: isAgenda)
    }
    
    // MARK: -action
    func dealCellEvent(_ cellType: YXSHomeCellEvent, indexPath: IndexPath){
        let model = yxs_punchCardDataSource[indexPath.row]
        switch cellType {
        case .showAll:
            reloadTableView(indexPath)
        case .read:
            reloadTableView(indexPath)
        case .punchRemind:
            let vc = YXSPunchCardMembersListViewController.init(clockInId: model.clockInId ?? 0,classId: yxs_punchCardDataSource[indexPath.row].classId ?? 0 ,punchM: model)
            self.navigationController?.pushViewController(vc)
        case .goPunch:
            let vc = YXSPunchCardDetialController.init(clockInId: model.clockInId ?? 0,childId: childId,classId:model.classId ?? 0)
            self.navigationController?.pushViewController(vc)
        case .recall:
            UIUtil.yxs_loadRecallData(.punchCard, id: model.clockInId ?? 0,positon: .list) {
                self.yxs_punchCardDataSource.remove(at: indexPath.row)
                self.reloadTableView()
            }
        default:
            break
        }
    }
    
    // MARK: -private
    override func showTopAlert(indexPath: IndexPath){
        let listModel = yxs_punchCardDataSource[indexPath.row]
        YXSCommonBottomAlerView.showIn(topButtonTitle: ((listModel.isTop ?? 0)  == 1) ? "取消置顶" : "置顶") {
            UIUtil.yxs_loadUpdateTopData(type: .punchCard, id: listModel.clockInId ?? 0, createTime: "", isTop: ((listModel.isTop ?? 0)  == 1) ? 0 : 1,positon: .list){
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.yxs_refreshData()
            }
        }
    }
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yxs_punchCardDataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = yxs_punchCardDataSource[indexPath.row]
        return model.height
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = yxs_punchCardDataSource[indexPath.row]
        var cell: YXSPunchCardListCell! = tableView.dequeueReusableCell(withIdentifier: "PunchCardList") as? YXSPunchCardListCell
        if cell == nil{
            cell = YXSPunchCardListCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "PunchCardList", isShowTag: false)
        }
        cell.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        cell.isAgenda = isAgenda
        cell.yxs_setCellModel(model)
        cell.cellBlock = {[weak self] (type: YXSHomeCellEvent) in
            guard let strongSelf = self else { return }
            strongSelf.dealCellEvent(type, indexPath: indexPath)
        }
        cell.cellLongTapEvent = {[weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.showTopAlert(indexPath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = yxs_punchCardDataSource[indexPath.row]
        let vc = YXSPunchCardDetialController.init(clockInId: model.clockInId ?? 0, childId: model.childrenId,classId: model.classId ?? 0)
        navigationController?.pushViewController(vc)
        if isAgenda && YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            UIUtil.yxs_reduceAgenda(serviceId: model.clockInId ?? 0, info: [kEventKey: YXSHomeType.punchCard])
//            self.dataSource.remove(at: indexPath.row)
//            self.tableView.reloadData()
        }
    }
    
//    ///处理预加载数据
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if loadMore{
//            if indexPath.row + 1 >= yxs_punchCardDataSource.count - kPreloadSize{
//                tableView.mj_footer?.beginRefreshing()
//            }
//        }
//    }
    
    // MARK: - getter&setter
    
}

// MARK: - other func
extension YXSPunchCardListController{
    func yxs_dealPunchCardListUI() {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "PunchCardList"
    }
    
    func yxs_changePunchCardListUI(_ cancelled: Bool) {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "PunchCardList"
    }
    
    func yxs_addPunchCardListUI() {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "PunchCardList"
    }
}

