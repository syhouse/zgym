//
//  SLHomeworkListController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/21.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import ObjectMapper
import NightNight

class SLHomeworkListController: SLCommonScreenListBaseController {
    
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
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        tableView.estimatedRowHeight = 177
        tableView.register(SLHomeworkListCell.self, forCellReuseIdentifier: "SLHomeworkListCell")
        
        if SLPersonDataModel.sharePerson.personRole == .PARENT{
            selectModels = [SLSelectModel.init(text: "全部", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),SLSelectModel.init(text: "未完成", isSelect: false, paramsKey: SLCommonScreenSelectType.donotCommint.rawValue),SLSelectModel.init(text: "已完成", isSelect: false, paramsKey: SLCommonScreenSelectType.didCommint.rawValue)]
        }else if classId != nil{
            selectModels = [SLSelectModel.init(text: "全部", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),SLSelectModel.init(text: "仅看我发布的", isSelect: false, paramsKey: SLCommonScreenSelectType.myPublish.rawValue)]
        }
        
        rightButton.isHidden = isAgenda
    }
    
    // MARK: - loadData
    
    override func sl_loadListData(){
        if !SLPersonDataModel.sharePerson.isNetWorkingConnect{
            self.dataSource = SLCacheHelper.sl_getCacheHomeWorkList()
            self.group.leave()
            return
        }
        var request: SLBaseRequset!
        if isAgenda{
            if SLPersonDataModel.sharePerson.personRole == .TEACHER{
                request = SLEducationHomeworkPageQueryTeacherTodoRequest.init(currentPage: curruntPage)
            }else{
                request = SLEducationHomeworkPageQueryChildrenTodoRequest.init(currentPage: curruntPage, childrenClassList: sl_childrenClassList)
            }
        }else{
            var classIdList = classId == nil ? (sl_user.gradeIds ?? []) : [classId!]
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
            request = SLEducationHomeworkPageQueryRequest.init(currentPage: curruntPage, classIdList: classIdList, userType: sl_user.type ?? "", childrenId:childId , filterType: filterType)
        }
        request.request({ (result) in
            if self.curruntPage == 1{
                self.dataSource.removeAll()
            }
            let list = Mapper<SLHomeListModel>().mapArray(JSONObject: result["homeworkList"].object) ?? [SLHomeListModel]()
            self.dataSource += self.sl_dealList(list: list, childId: self.childId, isAgenda: self.isAgenda)
            SLCacheHelper.sl_cacheHomeWorkList(dataSource: self.dataSource)
            self.loadMore = result["hasNext"].boolValue
            self.group.leave()
        }) { (msg, code) in
            self.group.leave()
        }
    }
    
    override func sl_requestFinish(){
        self.sl_endingRefresh()
        self.tableView.reloadData()
    }

    
    override func reloadTableView(_ indexPath: IndexPath? = nil, isScroll : Bool = false) {
        super.reloadTableView(indexPath,isScroll: isScroll)
        SLCacheHelper.sl_cacheHomeWorkList(dataSource: self.dataSource)
    }
    
    override func addNotification() {
        super.addNotification()
        //家长撤销
        NotificationCenter.default.addObserver(self, selector: #selector(sl_refreshData), name: NSNotification.Name.init(rawValue: kOperationStudentWorkNotification), object: nil)
    }
    
    // MARK: - action
    func sl_dealCellEvent(_ cellType: HomeCellEvent, indexPath: IndexPath){
        let model = dataSource[indexPath.row]
        switch cellType {
        case .showAll:
            UIUtil.sl_loadReadData(dataSource[indexPath.row])
            reloadTableView(indexPath, isScroll:  !model.isShowAll)
        case .read:
            UIUtil.sl_loadReadData(dataSource[indexPath.row])
            reloadTableView(indexPath)
        case .punchRemind:
            sl_showAlert(title: "punchRemind")
        case .recall:
            UIUtil.sl_loadRecallData(dataSource[indexPath.row],positon: .list){
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        let cell: SLHomeworkListCell = tableView.dequeueReusableCell(withIdentifier: "SLHomeworkListCell") as! SLHomeworkListCell
        cell.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        cell.isAgenda = isAgenda
        cell.sl_setCellModel(model)
        cell.cellBlock = {[weak self] (type: HomeCellEvent) in
            guard let strongSelf = self else { return }
            strongSelf.sl_dealCellEvent(type, indexPath: indexPath)
        }
        cell.cellLongTapEvent = {[weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.showTopAlert(indexPath: indexPath)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        UIUtil.sl_loadReadData(model)
        reloadTableView(indexPath)
        
        if isAgenda && SLPersonDataModel.sharePerson.personRole == .TEACHER{
            UIUtil.sl_reduceAgenda(serviceId: model.serviceId ?? 0, info:[kEventKey: HomeType.homework])
            self.dataSource.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        
        sl_pushHomeDetailVC(homeModel: model)
    }
    // MARK: - getter&setter
    
}
