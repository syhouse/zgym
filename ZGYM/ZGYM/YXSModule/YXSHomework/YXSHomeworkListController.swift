//
//  YXSHomeworkListController.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/21.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import ObjectMapper
import NightNight

class YXSHomeworkListController: YXSCommonScreenListBaseController {
    
    /// 是否待办事项列表
    var isAgenda: Bool = false
    override init(classId: Int?, childId: Int?) {
        super.init(classId: classId, childId: childId)
        actionEvent = .homework
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
        
        title = isAgenda ? "作业待办" : "作业"
        self.tableView.estimatedRowHeight = 50;
        //        self.tableView.fd_debugLogEnabled = true
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        tableView.register(YXSHomeworkListCell.self, forCellReuseIdentifier: "YXSHomeworkListCell")
        
        if YXSPersonDataModel.sharePerson.personRole == .PARENT{
            selectModels = [YXSSelectModel.init(text: "全部", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),YXSSelectModel.init(text: "未完成", isSelect: false, paramsKey: SLCommonScreenSelectType.donotCommint.rawValue),YXSSelectModel.init(text: "已完成", isSelect: false, paramsKey: SLCommonScreenSelectType.didCommint.rawValue)]
        }else if classId != nil{
            selectModels = [YXSSelectModel.init(text: "全部", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),YXSSelectModel.init(text: "仅看我发布的", isSelect: false, paramsKey: SLCommonScreenSelectType.myPublish.rawValue)]
        }
        
        rightButton.isHidden = isAgenda
        
        let list = YXSCacheHelper.yxs_getCacheHomeWorkList(childrenId: self.yxs_user.curruntChild?.id, isAgent: isAgenda)
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
        self.dataSource = YXSCacheHelper.yxs_getCacheHomeWorkList(childrenId: self.yxs_user.curruntChild?.id, isAgent: isAgenda)
        self.tableView.reloadData()
    }
    
    // MARK: - loadData
    
    override func yxs_loadListData(){
        var request: YXSBaseRequset!
        if isAgenda{
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                request = YXSEducationHomeworkPageQueryTeacherTodoRequest.init(currentPage: curruntPage)
            }else{
                request = YXSEducationHomeworkPageQueryChildrenTodoRequest.init(currentPage: curruntPage, childrenClassList: yxs_childrenClassList)
            }
        }else{
            var classIdList = classId == nil ? (yxs_user.gradeIds ?? []) : [classId!]
            var filterType: Int?
            switch selectType {
            case .all:
                filterType = nil
            case .myCreateClass:
                classIdList = createListId
            case .myPublish:
                filterType = 0
            case .didCommint:
                filterType = 2
            case .donotCommint:
                filterType = 1
            default: break
            }
            request = YXSEducationHomeworkPageQueryRequest.init(currentPage: curruntPage, classIdList: classIdList, userType: yxs_user.type ?? "", childrenId:childId , filterType: filterType)
        }
        request.request({ (result) in
            if self.curruntPage == 1{
                self.dataSource.removeAll()
            }
            let list = Mapper<YXSHomeListModel>().mapArray(JSONObject: result["homeworkList"].object) ?? [YXSHomeListModel]()
            self.dataSource += self.yxs_dealList(list: list, childId: self.childId, isAgenda: self.isAgenda)
            self.loadMore = result["hasNext"].boolValue
            self.group.leave()
        }) { (msg, code) in
            self.group.leave()
        }
    }
    
    override func yxs_requestFinish(){
        self.yxs_endingRefresh()
        self.tableView.reloadData()
    }
    
    
    override func reloadTableView(_ indexPath: IndexPath? = nil, isScroll : Bool = false) {
        super.reloadTableView(indexPath,isScroll: isScroll)
    }
    
    override func addNotification() {
        super.addNotification()
        //家长撤销
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_refreshData), name: NSNotification.Name.init(rawValue: kOperationStudentWorkNotification), object: nil)
    }
    
    // MARK: - action
    func yxs_dealCellEvent(_ cellType: YXSHomeCellEvent, indexPath: IndexPath){
        let model = dataSource[indexPath.row]
        switch cellType {
        case .showAll:
            UIUtil.yxs_loadReadData(dataSource[indexPath.row])
            reloadTableView(indexPath, isScroll:  !model.isShowAll)
        case .read:
            UIUtil.yxs_loadReadData(dataSource[indexPath.row])
            reloadTableView(indexPath)
        case .punchRemind:
            yxs_showAlert(title: "punchRemind")
        case .recall:
            UIUtil.yxs_loadRecallData(dataSource[indexPath.row],positon: .list){
                self.dataSource.remove(at: indexPath.row)
                self.reloadTableView()
            }
        default:
            print("")
        }
    }
    
    // MARK: - tableViewDelegate
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
                let height = self.tableView.fd_heightForCell(withIdentifier: "YXSHomeworkListCell", cacheByKey: key as NSCopying) { (cell) in
                    if let cell = cell as? YXSHomeworkListCell{
                        cell.yxs_setCellModel(model)
                    }
                }
                model.cacheShowAllHeight = height
                YXSCacheHelper.yxs_cacheHomeWorkList(dataSource: self.dataSource, childrenId: self.yxs_user.curruntChild?.id, isAgent: self.isAgenda)
                return height
            }
        }else{
            if let cacheNormaHeight = model.cacheNormaHeight{
                return cacheNormaHeight
            }else{
                let height = self.tableView.fd_heightForCell(withIdentifier: "YXSHomeworkListCell", cacheByKey: key as NSCopying) { (cell) in
                    if let cell = cell as? YXSHomeworkListCell{
                        cell.yxs_setCellModel(model)
                    }
                }
                model.cacheNormaHeight = height
                YXSCacheHelper.yxs_cacheHomeWorkList(dataSource: self.dataSource, childrenId: self.yxs_user.curruntChild?.id, isAgent: self.isAgenda)
                return height
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: YXSHomeworkListCell = tableView.dequeueReusableCell(withIdentifier: "YXSHomeworkListCell") as! YXSHomeworkListCell
        if dataSource.count > indexPath.row {
            let model = dataSource[indexPath.row]
            
            cell.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
            cell.isAgenda = isAgenda
            cell.yxs_setCellModel(model)
            cell.cellBlock = {[weak self] (type: YXSHomeCellEvent) in
                guard let strongSelf = self else { return }
                strongSelf.yxs_dealCellEvent(type, indexPath: indexPath)
            }
            cell.cellLongTapEvent = {[weak self]  in
                guard let strongSelf = self else { return }
                strongSelf.showTopAlert(indexPath: indexPath)
            }
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource.count > indexPath.row {
            let model = dataSource[indexPath.row]
            UIUtil.yxs_loadReadData(model)
            reloadTableView(indexPath)
            
            if isAgenda && YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                UIUtil.yxs_reduceAgenda(serviceId: model.serviceId ?? 0, info:[kEventKey: YXSHomeType.homework])
                self.dataSource.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
            
            yxs_pushHomeDetailVC(homeModel: model)
        }
    }
    // MARK: - getter&setter
    
}
