//
//  YXSSolitaireListController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/21.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSSolitaireListController: YXSCommonScreenListBaseController {
    
    override init(classId: Int?, childId: Int?) {
        super.init(classId: classId, childId: childId)
        actionEvent = .solitaire
        
        SLLog("init")
    }
    
    convenience init(isAgenda: Bool){
        self.init(classId: nil, childId: nil)
        self.isAgenda = isAgenda
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    var solitaireLists: [YXSSolitaireModel] = [YXSSolitaireModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = isAgenda ? "接龙待办" : "接龙"
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        
        
        if YXSPersonDataModel.sharePerson.personRole == .PARENT{
            selectModels = [YXSSelectModel.init(text: "全部", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),YXSSelectModel.init(text: "未接", isSelect: false, paramsKey: SLCommonScreenSelectType.donotCommint.rawValue),YXSSelectModel.init(text: "已接", isSelect: false, paramsKey: SLCommonScreenSelectType.didCommint.rawValue),YXSSelectModel.init(text: "已结束", isSelect: false, paramsKey: SLCommonScreenSelectType.finish.rawValue)]
        }else{
            
            selectModels = [YXSSelectModel.init(text: "全部", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),YXSSelectModel.init(text: "进行中", isSelect: false, paramsKey: SLCommonScreenSelectType.underway.rawValue),YXSSelectModel.init(text: "已结束", isSelect: false, paramsKey: SLCommonScreenSelectType.finish.rawValue)]
        }
        rightButton.isHidden = isAgenda ? true : false
        
        tableView.register(YXSSolitaireListCell.self, forCellReuseIdentifier: "YXSSolitaireListCell")
        
        ///后期优化主线程时间 1.高度计算  2.截止日期 时间  ....
        self.solitaireLists = YXSCacheHelper.yxs_getCacheSolitaireList(childrenId: self.yxs_user.currentChild?.id, isAgent: isAgenda)
    }
    
    
    // MARK: -UI
    override func showTopAlert(indexPath: IndexPath){
        let listModel = solitaireLists[indexPath.row]
        YXSCommonBottomAlerView.showIn( topButtonTitle: ((listModel.isTop ?? 0)  == 1) ? "取消置顶" : "置顶") {
            UIUtil.yxs_loadUpdateTopData(type: .solitaire, id: listModel.censusId ?? 0, createTime: "", isTop: ((listModel.isTop ?? 0)  == 1) ? 0 : 1,positon: .list){
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.yxs_refreshData()
            }
        }
        
    }
    
    override func yxs_updateList(_ notification: Notification) {
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
    override func yxs_refreshData() {
        self.currentPage = 1
        loadData()
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    
    //家长 接龙状态（0 全部 10 未接 20 已接龙 100 已结束:按照接龙的结束时间）
    // 老师 接龙状态（0 全部 10 正在接龙 100 已结束:按照接龙的结束时间 ）
    override func loadData(){
        
        var request: YXSBaseRequset!
        if isAgenda{
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                request = YXSEducationCensusTeacherTodoTodoRequest.init(currentPage: currentPage)
            }else{
                request = YXSEducationCensusParentTodoRequest.init(currentPage: currentPage)
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
            if YXSPersonDataModel.sharePerson.personRole == .PARENT{
                request = YXSEducationCensusParentCensusListRequest.init(currentPage: currentPage, state: state, childrenId: childId ?? 0)
            }else{
                request = YXSEducationCensusTeacherCensusListRequest.init(currentPage: currentPage, state: state, classId: classId,stage: YXSPersonDataModel.sharePerson.personStage)
            }
        }
        
        request.requestCollection({ (list: [YXSSolitaireModel]) in
            self.yxs_endingRefresh()
            if self.currentPage == 1{
                self.solitaireLists.removeAll()
            }
            
            self.solitaireLists += self.yxs_dealList(list: list, childId: self.childId, isAgenda: self.isAgenda)
            
            self.loadMore = list.count >= kPageSize
            self.tableView.reloadData()
            YXSCacheHelper.yxs_cacheSolitaireList(dataSource: self.solitaireLists, childrenId: self.yxs_user.currentChild?.id, isAgent: self.isAgenda)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
            self.yxs_endingRefresh()
        }
        
    }
    
    // MARK: -action
    func dealCellEvent(_ cellType: YXSHomeCellEvent, indexPath: IndexPath){
        let model = solitaireLists[indexPath.row]
        switch cellType {
        case .showAll:
            reloadTableView(indexPath, isScroll:  !model.isShowAll)
        case .recall:
            UIUtil.yxs_loadRecallData(YXSRecallModel.init(serviceId: solitaireLists[indexPath.row].censusId, createTime: nil, homeType: .solitaire),positon: .list) {
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
        YXSCacheHelper.yxs_cacheSolitaireList(dataSource: self.solitaireLists, childrenId: self.yxs_user.currentChild?.id, isAgent: isAgenda)
    }
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solitaireLists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.solitaireLists[indexPath.row]
        return model.height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = solitaireLists[indexPath.row]
        let cell: YXSSolitaireListCell = tableView.dequeueReusableCell(withIdentifier: "YXSSolitaireListCell") as! YXSSolitaireListCell
        cell.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        cell.yxs_setCellModel(model)
        cell.cellBlock = {[weak self] (type: YXSHomeCellEvent) in
            guard let strongSelf = self else { return }
            strongSelf.dealCellEvent(type, indexPath: indexPath)
        }
        //        cell.cellLongTapEvent = {[weak self]  in
        //            guard let strongSelf = self else { return }
        //            strongSelf.showTopAlert(indexPath: indexPath)
        //        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = solitaireLists[indexPath.row]
        if model.type == 1{
            let vc = YXSSolitaireDetailController.init(censusId: model.censusId ?? 0, childrenId: model.childrenId ?? 0, classId: model.classId ?? 0)
            navigationController?.pushViewController(vc)
        }else{
            let vc = YXSSolitaireNewDetailController.init(censusId: model.censusId ?? 0, childrenId: model.childrenId ?? 0, classId: model.classId ?? 0)
            navigationController?.pushViewController(vc)
        }
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            UIUtil.yxs_reduceAgenda(serviceId: model.censusId ?? 0, info: [kEventKey:YXSHomeType.solitaire])
            if isAgenda {
                //            self.dataSource.remove(at: indexPath.row)
                //            self.tableView.reloadData()
            }
            
        }
    }
    
    //    ///处理预加载数据
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        if loadMore{
    //            if indexPath.row + 1 >= solitaireLists.count - kPreloadSize{
    //                tableView.mj_footer?.beginRefreshing()
    //            }
    //        }
    //    }
    
    
    // MARK: - getter&setter
    
}
