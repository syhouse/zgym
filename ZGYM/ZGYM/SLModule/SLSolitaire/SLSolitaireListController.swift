//
//  SLSolitaireListController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/21.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLSolitaireListController: SLCommonScreenListBaseController {
    /// 是否今日事项列表
    var isAgenda: Bool = false
    override init(classId: Int?, childId: Int?) {
        super.init(classId: classId, childId: childId)
        actionEvent = .solitaire
    }
    
    convenience init(isAgenda: Bool){
        self.init(classId: nil, childId: nil)
        self.isAgenda = isAgenda
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    var solitaireLists: [SLSolitaireModel] = [SLSolitaireModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = isAgenda ? "接龙待办" : "接龙"
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        tableView.estimatedRowHeight = 159
        
        
        if SLPersonDataModel.sharePerson.personRole == .PARENT{
            selectModels = [SLSelectModel.init(text: "全部", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),SLSelectModel.init(text: "未接", isSelect: false, paramsKey: SLCommonScreenSelectType.donotCommint.rawValue),SLSelectModel.init(text: "已接", isSelect: false, paramsKey: SLCommonScreenSelectType.didCommint.rawValue),SLSelectModel.init(text: "已结束", isSelect: false, paramsKey: SLCommonScreenSelectType.finish.rawValue)]
        }else{
            
            selectModels = [SLSelectModel.init(text: "全部", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),SLSelectModel.init(text: "进行中", isSelect: false, paramsKey: SLCommonScreenSelectType.underway.rawValue),SLSelectModel.init(text: "已结束", isSelect: false, paramsKey: SLCommonScreenSelectType.finish.rawValue)]
        }
        rightButton.isHidden = isAgenda ? true : false
    }
    
    // MARK: -UI
    override func showTopAlert(indexPath: IndexPath){
        let listModel = solitaireLists[indexPath.row]
        SLCommonBottomAlerView.showIn( topButtonTitle: ((listModel.isTop ?? 0)  == 1) ? "取消置顶" : "置顶") {
            UIUtil.sl_loadUpdateTopData(type: .solitaire, id: listModel.censusId ?? 0, createTime: "", isTop: ((listModel.isTop ?? 0)  == 1) ? 0 : 1,positon: .list){
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.sl_refreshData()
            }
        }

    }
    
    override func sl_updateList(_ notification: Notification) {
        let userInfo = notification.object as? [String: Any]
        if let id = userInfo?[kNotificationIdKey] as? Int{
            for (row,model) in solitaireLists.enumerated(){
                if model.censusId == id{
                    model.state = 20
                    reloadTableView(IndexPath.init(row: row, section: 0))
                    break
                }
            }
        }
    }
    
    // MARK: -loadData
    override func sl_refreshData() {
        self.curruntPage = 1
        loadData()
    }
    
    override func sl_loadNextPage() {
        loadData()
    }
    
    
    //家长 接龙状态（0 全部 10 未接 20 已接龙 100 已结束:按照接龙的结束时间）
    // 老师 接龙状态（0 全部 10 正在接龙 100 已结束:按照接龙的结束时间 ）
    override func loadData(){
        if !SLPersonDataModel.sharePerson.isNetWorkingConnect{
            self.solitaireLists = SLCacheHelper.sl_getCacheSolitaireList()
            self.sl_endingRefresh()
            self.tableView.reloadData()
            return
        }
        
        var request: SLBaseRequset!
        if isAgenda{
            if SLPersonDataModel.sharePerson.personRole == .TEACHER{
                request = SLEducationCensusTeacherTodoTodoRequest.init(currentPage: curruntPage)
            }else{
                request = SLEducationCensusParentTodoRequest.init(currentPage: curruntPage)
            }
        }else{
            var state: Int = 0
            switch selectType {
            case .all:
                state = 0
            case .finish:
                state = 100
            case .underway:
                state = 10
            case .didCommint:
                state = 20
            case .donotCommint:
                state = 10
            default:
                break
            }
            if SLPersonDataModel.sharePerson.personRole == .PARENT{
                request = SLEducationCensusParentCensusListRequest.init(currentPage: curruntPage, state: state, childrenId: childId ?? 0)
            }else{
                request = SLEducationCensusTeacherCensusListRequest.init(currentPage: curruntPage, state: state, classId: classId,stage: SLPersonDataModel.sharePerson.personStage)
            }
        }
        
        request.requestCollection({ (list: [SLSolitaireModel]) in
            if self.curruntPage == 1{
                self.solitaireLists.removeAll()
            }
            
            self.solitaireLists += self.sl_dealList(list: list, childId: self.childId, isAgenda: self.isAgenda)
            
            self.loadMore = list.count == kPageSize
            self.sl_endingRefresh()
            SLCacheHelper.sl_cacheSolitaireList(dataSource: self.solitaireLists)
            self.tableView.reloadData()
        }) { (msg, code) in
            self.sl_endingRefresh()
        }
        
    }
    
    // MARK: -action
    func dealCellEvent(_ cellType: HomeCellEvent, indexPath: IndexPath){
        let model = solitaireLists[indexPath.row]
        switch cellType {
        case .showAll:
            reloadTableView(indexPath, isScroll:  !model.isShowAll)
        case .recall:
            UIUtil.sl_loadRecallData(.solitaire, id: solitaireLists[indexPath.row].censusId ?? 0,positon: .list) {
                self.solitaireLists.remove(at: indexPath.row)
                self.reloadTableView()
            }
        default:
            break
        }
    }
    
    // MARK: -private
        override func reloadTableView(_ indexPath: IndexPath? = nil, isScroll : Bool = false) {
        super.reloadTableView(indexPath,isScroll: isScroll)
        SLCacheHelper.sl_cacheSolitaireList(dataSource: self.solitaireLists)
    }
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solitaireLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = solitaireLists[indexPath.row]
        var cell: SLSolitaireListCell! = tableView.dequeueReusableCell(withIdentifier: "SolitaireList") as? SLSolitaireListCell
        if cell == nil{
            cell = SLSolitaireListCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "SolitaireList", isShowTag: false)
        }
        cell.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
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
        let model = solitaireLists[indexPath.row]
        let vc = SLSolitaireDetailController(censusId: model.censusId ?? 0, childrenId: model.childrenId ?? 0, classId: model.classId ?? 0)
        self.navigationController?.pushViewController(vc)
        if isAgenda && SLPersonDataModel.sharePerson.personRole == .TEACHER{
            UIUtil.sl_reduceAgenda(serviceId: model.censusId ?? 0, info: [kEventKey:HomeType.solitaire])
//            self.dataSource.remove(at: indexPath.row)
//            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - getter&setter
    
}
