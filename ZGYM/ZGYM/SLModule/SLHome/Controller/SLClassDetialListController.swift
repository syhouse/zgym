//
//  SLClassDetialListController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/21.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import ObjectMapper
import NightNight

class SLClassDetialListController: SLHomeBaseController {
    
    /// 当前班级model
    var classModel: SLClassModel
    var stage: StageType = .KINDERGARTEN
    private var rightButton: SLButton!
    /// 导航栏 右边按钮的标题
    var navRightBarButtonTitle: String? {
        didSet {
            if self.rightButton != nil {
                self.rightButton.setTitle(self.navRightBarButtonTitle, for: .normal)
            }
        }
    }
    init(classModel: SLClassModel) {
        self.classModel = classModel
        super.init()
        tableViewIsGroup = true
        self.title = classModel.name
        isSingleHome = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightButton = sl_setRightButton(title:self.navRightBarButtonTitle ?? "")
        rightButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        rightButton.setMixedTitleColor(MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4), forState: .normal)
        rightButton.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        tableHeaderView.layoutIfNeeded();
        let height = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        tableHeaderView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height )
        tableView.tableHeaderView = tableHeaderView
        tableView.estimatedRowHeight = 214
        tableView.register(SLHomeTableSectionView.self, forHeaderFooterViewReuseIdentifier: "SLHomeTableSectionView")
        
    }
    
    // MARK: -UI
    
    // MARK: -loadData
    var classDetialModel: SLClassDetailModel!
    func loadClassDetailData() {
        SLEducationGradeDetailRequest.init(gradeId: classModel.id ?? 0).request({ (model: SLClassDetailModel) in
            self.classDetialModel = model
            if let childs = self.classDetialModel.children{
                childs.first?.isSelect = true
            }
            self.stage = StageType.init(rawValue:model.stage ?? "") ?? StageType.KINDERGARTEN
            self.reloadClassDetail = true
            self.loadListData()
            self.group.leave()
        }) { (msg, code) in
            self.view.makeToast("\(msg)")
            self.group.leave()
        }
    }
    
    func loadListData(){
        group.enter()
        queue.async(group: group) {
            SLEducationFWaterfallPageQueryRequest.init(currentPage: self.curruntPage,classIdList: [self.classModel.id ?? 0],stage: self.stage.rawValue, userType: self.sl_user.type ?? "", childrenId: self.classModel.childrenId ?? 0).request({ (result) in
                if self.curruntPage == 1{
                    self.removeAll()
                }
                let list = Mapper<SLHomeListModel>().mapArray(JSONObject: result["waterfallList"].object) ?? [SLHomeListModel]()
                for model in list{
                    model.childrenId = self.classModel.childrenId
                    model.childrenRealName = self.classModel.realName
                    //置顶
                    if let isTop = model.isTop{
                        if isTop == 1 {
                            self.dataSource[0].items.append(model)
                            continue
                        }
                    }
                    //今天
                    if NSUtil.sl_isSameDay(NSUtil.sl_string2Date(model.createTime ?? ""), date2: Date()){
                        self.dataSource[1].items.append(model)
                        continue
                    }
                    //更早
                    self.dataSource[2].items.append(model)
                }
                self.loadMore = result["hasNext"].boolValue
                self.group.leave()
            }) { (msg, code) in
                self.group.leave()
            }
        }
        
    }
    
    var reloadClassDetail = true
    
    override func sl_loadNextPage() {
        loadData()
    }
    override func homeLoadUpdateTopData(type: HomeType, id: Int = 0, createTime: String = "", isTop: Int = 0, sucess: (() -> ())? = nil) {
        UIUtil.sl_loadUpdateTopData(type: type, id: id, createTime: createTime, isTop: isTop, positon: .singleHome, sucess: sucess)
    }
    
    override func homesl_loadRecallData(model: SLHomeListModel, sucess: (() -> ())? = nil) {
        UIUtil.sl_loadRecallData(model, positon: .singleHome, complete: sucess)
    }
    
    override func loadData(){
        if self.curruntPage == 1 && self.reloadClassDetail{
            group.enter()
            queue.async(group: group) {
                self.loadClassDetailData()
            }
        }else{
            self.loadListData()
        }
        
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                self.sl_endingRefresh()
                self.tableView.reloadData()
                self.reloadFooterView()
                
                if SLPersonDataModel.sharePerson.personRole == .TEACHER{
                    self.tableHeaderView.teacherView.setViewModel(self.classDetialModel)
                }else{
                    self.tableHeaderView.parentView.setViewModel(self.classDetialModel,classModel: self.classModel)
                    self.tableHeaderView.childModel = self.classDetialModel.getCurruntChild(classModel: self.classModel)
                    
                }
                //更新学段
                self.tableHeaderView.setButtonUI(stage:self.stage)
            }
        }
    }
    
    // MARK: -action
    @objc func rightClick(){
        if classDetialModel.position == "HEADMASTER" {
            if self.classDetialModel == nil{
                return
            }
            let vc = SLClassManageViewController()
            vc.className = self.classDetialModel.name ?? ""
            vc.forbidJoin = self.classDetialModel.forbidJoin == "NO" ? false:true
            vc.gradeId = self.classDetialModel.id
            vc.position = self.classDetialModel.position ?? ""
            vc.completionHandler = {[weak self](className, forbidJonin) in
                guard let weakSelf = self else {return}
                weakSelf.title = className
                weakSelf.classDetialModel.name = className
                weakSelf.classDetialModel.forbidJoin = forbidJonin == true ? "YES" : "NO"
            }
            self.navigationController?.pushViewController(vc)
            
        } else {
            let vc = SLClassInfoViewController.init(classModel: classModel)
            self.navigationController?.pushViewController(vc)
        }
    }
    
    @objc override func publishClick(){
        SLHomePublishView.showAlert {[weak self] (event) in
            guard let strongSelf = self else { return }
            strongSelf.sl_dealPublishAction(event,classId: strongSelf.classModel.id ?? 0)
        }
    }
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dealSelectRow(didSelectRowAt: indexPath, childModel: self.tableHeaderView.childModel)
    }
    
    
    // MARK: - getter&setter
    lazy var tableHeaderView: SLClassDetialTableHeaderView = {
        let tableHeaderView = SLClassDetialTableHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 350), classModel: classModel)
        return tableHeaderView
    }()
    
    lazy var homeNavView: SLHomeNavView = {
        let homeNavView = SLHomeNavView()
        homeNavView.isHidden = true
        return homeNavView
    }()
    
    lazy var topAgendaView: SLHomeAgendaView = {
        let topAgendaView = SLHomeAgendaView.init(true)
        topAgendaView.isHidden = true
        return topAgendaView
    }()
}


// MARK: -HMRouterEventProtocol
extension SLClassDetialListController: SLRouterEventProtocol{
    func sl_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYMHomeTableHeaderViewLookClassEvent:
            sl_showAlert(title: "push" + kYMHomeTableHeaderViewLookClassEvent)
        case kYMHomeTableHeaderViewScanEvent:
            sl_showAlert(title: "push" + kYMHomeTableHeaderViewScanEvent)
        case kYMClassDetialTableHeaderViewUpDateListEvent:
            reloadClassDetail = false
            sl_refreshData()
        case kYMClassDetialTableHeaderViewLookChildDetialEvent:
            //            showAlert(title: "push" + kYMClassDetialTableHeaderViewLookChildDetialEvent)
            let vc = SLClassMembersViewController()
            vc.gradeId = classModel.id ?? 0
            self.navigationController?.pushViewController(vc)
        default:
            break
        }
    }
}
