//
//  SLPunchCardListController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/21.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import ObjectMapper
import NightNight

class SLPunchCardListController: SLCommonScreenListBaseController {
    /// 是否今日事项列表
    var isAgenda: Bool = false
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
    // MARK: -leftCycle
    var punchCardDataSource = [SLPunchCardModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = isAgenda ? "打卡待办" : "打卡"
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        tableView.estimatedRowHeight = 177
        
        if SLPersonDataModel.sharePerson.personRole == .PARENT{
            selectModels = [SLSelectModel.init(text: "全部", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),SLSelectModel.init(text: "进行中", isSelect: false, paramsKey: SLCommonScreenSelectType.underway.rawValue),SLSelectModel.init(text: "已结束", isSelect: false, paramsKey: SLCommonScreenSelectType.finish.rawValue)]
        }else{
            selectModels = [SLSelectModel.init(text: "全部", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),SLSelectModel.init(text: "进行中", isSelect: false, paramsKey: SLCommonScreenSelectType.underway.rawValue),SLSelectModel.init(text: "已结束", isSelect: false, paramsKey: SLCommonScreenSelectType.finish.rawValue),SLSelectModel.init(text: "我发布的", isSelect: false, paramsKey: SLCommonScreenSelectType.myPublish.rawValue)]
        }
        
        rightButton.isHidden = isAgenda
    }
    
    override func sl_updateList(_ notification: Notification) {
        let userInfo = notification.object as? [String: Any]
        if let id = userInfo?[kNotificationIdKey] as? Int{
            for (row,model) in punchCardDataSource.enumerated(){
                if model.clockInId == id{
                    model.state = 20
                    reloadTableView(IndexPath.init(row: row, section: 0))
                    break
                }
            }
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
    //老师    打卡状态（0 全部 30 进行中（已打卡或者不需要打卡） 40 我发布的 100 已结束:按照打卡的结束时间 ）
    // 家长 打卡状态（0 全部 10 未打卡 20 进行中（已打卡或者不需要打卡） 100 已结束:按照打卡的结束时间 ）
    override func loadData(){
        if !SLPersonDataModel.sharePerson.isNetWorkingConnect{
            self.punchCardDataSource = SLCacheHelper.sl_getCachePunchCardList()
            self.sl_endingRefresh()
            self.tableView.reloadData()
            return
        }
        var request: SLBaseRequset!
        if isAgenda{
            if SLPersonDataModel.sharePerson.personRole == .TEACHER{
                request = SLEducationClockInTeacherTodoRequest.init(currentPage: curruntPage)
            }else{
                request = SLEducationClockInParentTodoRequest.init(currentPage: curruntPage)
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
                state = SLPersonDataModel.sharePerson.personRole == .TEACHER ? 30 : 20
            default:
                break
            }
            if SLPersonDataModel.sharePerson.personRole == .PARENT{
                request = SLEducationClockInParentTaskListRequest.init(state: state, childrenId: childId ?? 0, currentPage: curruntPage)
            }else{
                request = SLEducationClockInTeacherTaskListRequest.init(state: state, classId: classId, currentPage: curruntPage,stage: SLPersonDataModel.sharePerson.personStage)
            }
        }
        request.requestCollection({ (list: [SLPunchCardModel]) in
            if self.curruntPage == 1{
                self.punchCardDataSource.removeAll()
            }
            self.punchCardDataSource += self.sl_dealList(list: list, childId: self.childId, isAgenda: self.isAgenda)
            self.loadMore = list.count == kPageSize
            self.sl_endingRefresh()
            SLCacheHelper.sl_cachePunchCardList(dataSource: self.punchCardDataSource)
            self.tableView.reloadData()
        }) { (msg, code) in
            self.sl_endingRefresh()
        }
        
    }
    
    override func reloadTableView(_ indexPath: IndexPath? = nil, isScroll : Bool = false) {
        super.reloadTableView(indexPath,isScroll: isScroll)
        SLCacheHelper.sl_cachePunchCardList(dataSource: self.punchCardDataSource)
    }
    
    // MARK: -action
    func dealCellEvent(_ cellType: HomeCellEvent, indexPath: IndexPath){
        let model = punchCardDataSource[indexPath.row]
        switch cellType {
        case .showAll:
            reloadTableView(indexPath)
        case .read:
            reloadTableView(indexPath)
        case .punchRemind:
            let vc = SLPunchCardMembersListViewController.init(clockInId: model.clockInId ?? 0,classId: punchCardDataSource[indexPath.row].classId ?? 0 ,punchM: model)
            self.navigationController?.pushViewController(vc)
        case .goPunch:
            let vc = SLPunchCardDetialController.init(clockInId: model.clockInId ?? 0,childId: childId,classId:model.classId ?? 0)
            self.navigationController?.pushViewController(vc)
        case .recall:
            UIUtil.sl_loadRecallData(.punchCard, id: model.clockInId ?? 0,positon: .list) {
                self.punchCardDataSource.remove(at: indexPath.row)
                self.reloadTableView()
            }
        default:
            break
        }
    }
    
    // MARK: -private
    override func showTopAlert(indexPath: IndexPath){
        let listModel = punchCardDataSource[indexPath.row]
        SLCommonBottomAlerView.showIn(topButtonTitle: ((listModel.isTop ?? 0)  == 1) ? "取消置顶" : "置顶") {
            UIUtil.sl_loadUpdateTopData(type: .punchCard, id: listModel.clockInId ?? 0, createTime: "", isTop: ((listModel.isTop ?? 0)  == 1) ? 0 : 1,positon: .list){
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.sl_refreshData()
            }
        }
    }
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return punchCardDataSource.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = punchCardDataSource[indexPath.row]
        var cell: SLPunchCardListCell! = tableView.dequeueReusableCell(withIdentifier: "PunchCardList") as? SLPunchCardListCell
        if cell == nil{
            cell = SLPunchCardListCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "PunchCardList", isShowTag: false)
        }
        cell.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        cell.isAgenda = isAgenda
        cell.sl_setCellModel(model)
        cell.cellBlock = {[weak self] (type: HomeCellEvent) in
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
        let model = punchCardDataSource[indexPath.row]
        let vc = SLPunchCardDetialController.init(clockInId: model.clockInId ?? 0, childId: model.childrenId,classId: model.classId ?? 0)
        navigationController?.pushViewController(vc)
        if isAgenda && SLPersonDataModel.sharePerson.personRole == .TEACHER{
            UIUtil.sl_reduceAgenda(serviceId: model.clockInId ?? 0, info: [kEventKey: HomeType.punchCard])
//            self.dataSource.remove(at: indexPath.row)
//            self.tableView.reloadData()
        }
    }
    
    // MARK: - getter&setter
    
}
