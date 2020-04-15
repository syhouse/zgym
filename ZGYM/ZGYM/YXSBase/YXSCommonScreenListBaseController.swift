//
//  SLCommonScreenListController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/28.
//  Copyright © 2019 zgjy_mac. All rights reserved.
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

    case toReview   //待点评
    case haveComments//已点评

    case change   //修改
    case recall  //撤回
}

class YXSCommonScreenListBaseController: YXSBaseTableViewController{
    var dataSource: [YXSHomeListModel] = [YXSHomeListModel]()
    var createClassList:[SLClassModel]?
    
    var classId: Int?
    var childId: Int?
    var rightButton: YXSButton!
    var actionEvent: YXSHomeHeaderActionEvent = .homework
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
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        rightButton = yxs_setRightButton(mixedImage: MixedImage(normal: "yxs_screening", night: "yxs_screening_night"))
        rightButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -40)
        rightButton.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        
        addNotification()
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            view.addSubview(publishButton)
            publishButton.snp.makeConstraints { (make) in
                make.right.equalTo(-15)
                make.bottom.equalTo(-kTabBottomHeight - 15)
                make.size.equalTo(CGSize.init(width: 51.5, height: 51.5))
            }
        }
    }
    
    lazy var selectModels:[YXSSelectModel] = {
        var selectModels = [YXSSelectModel.init(text: "全部来源", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),YXSSelectModel.init(text: "仅看我发布的", isSelect: false, paramsKey: SLCommonScreenSelectType.myPublish.rawValue)]
        if classId != nil{
            selectModels.insert(YXSSelectModel.init(text: "我创建的班级", isSelect: false, paramsKey: SLCommonScreenSelectType.myCreateClass.rawValue), at: 1)
        }
        return selectModels
    }()
    
    var selectType: SLCommonScreenSelectType = .all
    
    // MARK: - action
    @objc func rightClick(){
        YXSHomeListSelectView.showAlert(offset: CGPoint.init(x: 8, y: 58 + kSafeTopHeight), selects: selectModels) { [weak self](selectModel,selectModels) in
            guard let strongSelf = self else { return }
            strongSelf.selectModels = selectModels
            strongSelf.selectType = SLCommonScreenSelectType.init(rawValue: selectModel.paramsKey) ?? .all
            strongSelf.updateUI()
            strongSelf.tableView.scrollToTop()
        }
    }
    
    func updateUI(){
        loadData()
    }
    
    @objc func yxs_publishClick(){
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER && (yxs_user.gradeIds == nil || yxs_user.gradeIds!.count == 0){
            UIUtil.curruntNav().pushViewController(YXSTeacherClassListViewController())
            return
        }
        yxs_dealPublishAction(actionEvent,classId: classId)
    }
    
    func showTopAlert(indexPath: IndexPath){
        let homeListModel = dataSource[indexPath.row]
        YXSCommonBottomAlerView.showIn(topButtonTitle: ((homeListModel.isTop ?? 0)  == 1) ? "取消置顶" : "置顶") {
            UIUtil.yxs_loadUpdateTopData(type: homeListModel.type,id: homeListModel.serviceId ?? 0, createTime: homeListModel.createTime ?? "", isTop: (homeListModel.isTop ?? 0) == 1 ? 0 : 1,positon: .list){
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.yxs_refreshData()
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
//                    SLLog(rc)
                    if rc.minY < 0{
                        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition:.top)
                    }else if rc.minY + rc.height > self.tableView.height{//为什么不在屏幕显示 rc.minY不是负的
                        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition:.top)
                    }
                }
            }
            
        }else{
            tableView.reloadData()
        }
    }
    
    func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_refreshData), name: NSNotification.Name.init(rawValue: kHomeAgendaReducNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_updateList), name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_refreshData), name: NSNotification.Name.init(rawValue: kTeacherPublishSucessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_refreshData), name: NSNotification.Name.init(rawValue: kOperationUpdateToTopInItemDetailNotification), object: nil)
        
        //家长打卡撤销
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_refreshData), name: NSNotification.Name.init(rawValue: kOperationStudentCancelPunchCardNotification), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func yxs_refreshData() {
        self.curruntPage = 1
        loadData()
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    let group = DispatchGroup()
    let queue = DispatchQueue.global()
    
    func loadData(){
        
        self.group.enter()
        queue.async {
            self.yxs_loadListData()
        }
        
        if curruntPage == 1 {
            self.group.enter()
            queue.async {
                self.loadClassListData()
            }
        }
        
        
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                self.yxs_requestFinish()
            }
        }
    }
    
    // MARK: -loaddata
    func loadClassListData(){
        YXSEducationGradeListRequest().request({ (json) in
            self.createClassList = Mapper<SLClassModel>().mapArray(JSONString: json["listCreate"].rawString()!) ?? [SLClassModel]()
            self.group.leave()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
            self.group.leave()
        }
    }
    func yxs_loadListData(){
        
    }
    
    func yxs_requestFinish(){
        
    }
    
    @objc func yxs_updateList(_ notification:Notification){
        let userInfo = notification.object as? [String: Any]
        if let notificationModel = userInfo?[kNotificationModelKey] as? YXSHomeListModel{
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
    
    lazy var publishButton: YXSButton = {
        let button = YXSButton()
        button.setBackgroundImage(UIImage.init(named: "publish"), for: .normal)
        button.addTarget(self, action: #selector(yxs_publishClick), for: .touchUpInside)
        return button
    }()
}
