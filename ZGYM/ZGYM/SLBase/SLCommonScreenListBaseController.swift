//
//  SLCommonScreenListController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/28.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import ObjectMapper
import NightNight

enum SLCommonScreenSelectType: String{
    case all
    case myCreateClass
    case myPublish
    case didCommint
    case donotCommint
    
    case underway//进行中
    case finish
}

class SLCommonScreenListBaseController: SLBaseTableViewController{
    var dataSource: [SLHomeListModel] = [SLHomeListModel]()
    var createClassList:[SLClassModel]?
    
    var classId: Int?
    var childId: Int?
    var rightButton: SLButton!
    var actionEvent: SLHomeActionEvent = .homework
    init(classId: Int?, childId: Int?) {
        self.classId = classId
        self.childId = childId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var createListId:[Int]{
        get{
            var list = [Int]()
            if let createClassList = createClassList{
                for model in createClassList{
                    list.append(model.id ?? 0)
                }
            }
            return list
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        rightButton = sl_setRightButton(mixedImage: MixedImage(normal: "sl_screening", night: "sl_screening_night"))
        rightButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -40)
        rightButton.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        
        addNotification()
        
        if SLPersonDataModel.sharePerson.personRole == .TEACHER{
            view.addSubview(publishButton)
            publishButton.snp.makeConstraints { (make) in
                make.right.equalTo(-15)
                make.bottom.equalTo(-kTabBottomHeight - 15)
                make.size.equalTo(CGSize.init(width: 51.5, height: 51.5))
            }
        }
    }
    
    lazy var selectModels:[SLSelectModel] = {
        var selectModels = [SLSelectModel.init(text: "全部来源", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),SLSelectModel.init(text: "仅看我发布的", isSelect: false, paramsKey: SLCommonScreenSelectType.myPublish.rawValue)]
        if classId != nil{
            selectModels.insert(SLSelectModel.init(text: "我创建的班级", isSelect: false, paramsKey: SLCommonScreenSelectType.myCreateClass.rawValue), at: 1)
        }
        return selectModels
    }()
    
    var selectType: SLCommonScreenSelectType = .all
    
    // MARK: - action
    @objc func rightClick(){
        SLHomeListSelectView.showAlert(offset: CGPoint.init(x: 8, y: 58 + kSafeTopHeight), selects: selectModels) { [weak self](selectModel,selectModels) in
            guard let strongSelf = self else { return }
            strongSelf.selectModels = selectModels
            strongSelf.selectType = SLCommonScreenSelectType.init(rawValue: selectModel.paramsKey) ?? .all
            strongSelf.updateUI()
        }
    }
    
    func updateUI(){
        loadData()
    }
    
    @objc func publishClick(){
        if SLPersonDataModel.sharePerson.personRole == .TEACHER && (sl_user.gradeIds == nil || sl_user.gradeIds!.count == 0){
            UIUtil.curruntNav().pushViewController(SLTeacherClassListViewController())
            return
        }
        sl_dealPublishAction(actionEvent,classId: classId)
    }
    
    func showTopAlert(indexPath: IndexPath){
        let homeListModel = dataSource[indexPath.row]
        SLCommonBottomAlerView.showIn(topButtonTitle: ((homeListModel.isTop ?? 0)  == 1) ? "取消置顶" : "置顶") {
            UIUtil.sl_loadUpdateTopData(type: homeListModel.type,id: homeListModel.serviceId ?? 0, createTime: homeListModel.createTime ?? "", isTop: (homeListModel.isTop ?? 0) == 1 ? 0 : 1,positon: .list){
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.sl_refreshData()
            }
        }
    }
    
    
    /// 刷新tableview
    /// - Parameter indexPath: 刷新指定行
    func reloadTableView(_ indexPath: IndexPath? = nil, isScroll : Bool = false){
        //        none
        if let indexPath = indexPath{
            UIView.performWithoutAnimation {
                let cell = self.tableView.cellForRow(at: indexPath)
                tableView.reloadRows(at: [indexPath], with: .none)
                if let cell = cell, isScroll{
                    let rc = self.tableView.convert(cell.frame, to: self.view)
                    SLLog(rc)
                    //展开全文滚动滚回来
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition:.top)
                }
            }
            
        }else{
            tableView.reloadData()
        }
    }
    
    func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sl_refreshData), name: NSNotification.Name.init(rawValue: kHomeAgendaReducNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sl_updateList), name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sl_refreshData), name: NSNotification.Name.init(rawValue: kTeacherPublishSucessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sl_refreshData), name: NSNotification.Name.init(rawValue: kOperationUpdateToTopInItemDetailNotification), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func sl_refreshData() {
        self.curruntPage = 1
        loadData()
    }
    
    override func sl_loadNextPage() {
        loadData()
    }
    
    let group = DispatchGroup()
    let queue = DispatchQueue.global()
    
    func loadData(){
        
        self.group.enter()
        queue.async {
            self.sl_loadListData()
        }
        
        if curruntPage == 1 {
            self.group.enter()
            queue.async {
                self.loadClassListData()
            }
        }
        
        
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                self.sl_requestFinish()
            }
        }
    }
    
    // MARK: -loaddata
    func loadClassListData(){
        SLEducationGradeListRequest().request({ (json) in
            self.createClassList = Mapper<SLClassModel>().mapArray(JSONString: json["listCreate"].rawString()!) ?? [SLClassModel]()
            self.group.leave()
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
            self.group.leave()
        }
    }
    func sl_loadListData(){
        
    }
    
    func sl_requestFinish(){
        
    }
    
    @objc func sl_updateList(_ notification:Notification){
        let userInfo = notification.object as? [String: Any]
        if let notificationModel = userInfo?[kNotificationModelKey] as? SLHomeListModel{
            for (row,model) in dataSource.enumerated(){
                if model.serviceId == notificationModel.serviceId{
                    model.commitState = 2
                    if model.type == .solitaire{
                        model.remarkList?.append(model.childrenId ?? 0)
                        if model.commitCount == model.commitUpperLimit{
                            model.state = 100
                        }
                    }else if model.type == .punchCard{//打卡更新剩余人数
                        //                        model.surplusClockInDayCount = (model.surplusClockInDayCount ?? 0) - 1
                    }
                    
                    reloadTableView(IndexPath.init(row: row, section: 0))
                    break
                }
            }
        }
    }
    // MARK: -列表为空
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return showEmptyDataSource
    }
    
    lazy var publishButton: SLButton = {
        let button = SLButton()
        button.setBackgroundImage(UIImage.init(named: "publish"), for: .normal)
        button.addTarget(self, action: #selector(publishClick), for: .touchUpInside)
        return button
    }()
}
