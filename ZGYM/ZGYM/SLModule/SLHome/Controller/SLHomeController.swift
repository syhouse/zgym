//
//  SLHomeController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/15.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import ObjectMapper
let kHomeChildKey = "HomeChildKey"
let kHomeRedServiceListKey = "HomeRedServiceListKey"
class SLHomeController: SLHomeBaseController {
    var agendaCount: Int = 0
    var isShowGuide: Bool = false
    lazy var locationManager = AMapLocationManager()
    var weathModel: SLWeathModel?{
        didSet{
            self.tableHeaderView.setHeaderModel(weathModel, agendaCount: self.agendaCount)
        }
    }
    override init() {
        super.init()
        tableViewIsGroup = true
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true
        initUI()
        if SLPersonDataModel.sharePerson.personRole == .PARENT{
            sl_showBadgeOnItem(index: 0, count: SLLocalMessageHelper.shareHelper.sl_localMessageCount())
        }else{
            self.sl_showBadgeOnItem(index: 0, count: 0)
        }
        
        self.dataSource = SLCacheHelper.sl_getCacheHomeList()
        
        //引导
        showGuide()
    }
    
//        override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//            showGuide()
//        }
    // MARK: -UI
    
    func showGuide(){
        var isShowTeacherHomeGuide = UserDefaults.standard.bool(forKey: "isShowTeacherHomeGuide")
        var isShowPartentHomeGuide = UserDefaults.standard.bool(forKey: "isShowPartentHomeGuide")
//        isShowPartentHomeGuide = false
//        isShowTeacherHomeGuide = false
        if !isShowTeacherHomeGuide || !isShowPartentHomeGuide{
            self.view.layoutIfNeeded()
            let agendaFrame = self.tableHeaderView.convert(self.tableHeaderView.agendaView.frame, to: self.tabBarController!.view)
            let agendaModel = SLGuideModel.init(type: SLGuideType.mask, maskFrame: CGRect.init(x: agendaFrame.minX + 15, y: agendaFrame.minY , width: agendaFrame.width - 30, height: agendaFrame.height), maskCornerRadius: 15, imageFrame: CGRect.init(x: (SCREEN_WIDTH - 197)/2, y: agendaFrame.maxY, width: 197, height: 135.5), imageName: "sl_guide_teacher_3")
            if SLPersonDataModel.sharePerson.personRole == .TEACHER && !isShowTeacherHomeGuide{
                isShowGuide = true
                let publishFrame = self.view.convert(self.publishButton.frame, to: self.tabBarController!.view)
                let topTeacherView = SLGuideView.init(title: "您好~欢迎加入优学生！", desTitle: "在这里您可以发布作业、通知、班级之星等消息，家长即时查收。")
                let height = UIUtil.sl_getTextHeigh(textStr: topTeacherView.desLabel.text!, font: topTeacherView.desLabel.font, width: SCREEN_WIDTH - 31 - 17 - 103)
                let topTeacherModel = SLGuideModel.init(type: SLGuideType.view, view: topTeacherView, viewFrame: CGRect.init(x: 15.5, y: 173 + kSafeTopHeight, width: SCREEN_WIDTH - 31, height: height + 68),imageFrame: CGRect.init(x: (SCREEN_WIDTH - 160.5)/2, y: height + 68 + 173 + kSafeTopHeight, width: 160.5, height: 135),imageName: "sl_guide_teacher_1")
                let publishiModel = SLGuideModel.init(type: SLGuideType.mask, maskFrame: CGRect.init(x: publishFrame.minX - 10, y: publishFrame.minY - 10, width: publishFrame.width + 20, height: publishFrame.width + 20), maskCornerRadius: (publishFrame.width + 20)/2, imageFrame: CGRect.init(x: SCREEN_WIDTH - 11 - 161, y: publishFrame.maxY - (publishFrame.width + 10) - 135, width: 160.5, height: 135), imageName: "sl_guide_teacher_2")
                SLGuideViewWindow.showGuideViewWindow(items: [topTeacherModel,publishiModel,agendaModel]){
                    [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.isShowGuide = false
                    strongSelf.tableHeaderView.setHeaderModel(strongSelf.weathModel, agendaCount: strongSelf.agendaCount)
                    strongSelf.tableView.reloadData()
                }
                UserDefaults.standard.set(true, forKey: "isShowTeacherHomeGuide")
            }else if SLPersonDataModel.sharePerson.personRole == .PARENT && !isShowPartentHomeGuide{
                isShowGuide = true
                //造数据
                //                let servicechildrens = sl_user.children
                var childrens = [SLChildrenModel]()
                for _ in 0..<3{
                    let children = SLChildrenModel.init(JSON: ["":""])!
                    children.realName = "张小飞"
                    childrens.append(children)
                }
                SLPersonDataModel.sharePerson.userModel.children = childrens
                tableHeaderView.setHeaderModel(weathModel, agendaCount: 2)
                
                self.view.layoutIfNeeded()
                let topPartentView = SLGuideView.init(title: "您好~欢迎加入优学生！", desTitle: "在这里您将即时收到老师的发布作业、通知、班级之星等消息。")
                let height = UIUtil.sl_getTextHeigh(textStr: topPartentView.desLabel.text!, font: topPartentView.desLabel.font, width: SCREEN_WIDTH - 31 - 17 - 103)
                let topPartentModel = SLGuideModel.init(type: SLGuideType.view, view: topPartentView, viewFrame: CGRect.init(x: 15.5, y: 173 + kSafeTopHeight, width: SCREEN_WIDTH - 31, height: height + 68),imageFrame: CGRect.init(x: (SCREEN_WIDTH - 107.5)/2, y: height + 68 + 173 + kSafeTopHeight, width: 107.5, height: 95),imageName: "sl_guide_partent_1")
                let agendaFrame = self.tableHeaderView.convert(self.tableHeaderView.agendaView.frame, to: self.tabBarController!.view)
                let agendaModel = SLGuideModel.init(type: SLGuideType.mask, maskFrame: CGRect.init(x: agendaFrame.minX + 15, y: agendaFrame.minY , width: agendaFrame.width - 30, height: agendaFrame.height), maskCornerRadius: 15, imageFrame: CGRect.init(x: (SCREEN_WIDTH - 197)/2, y: agendaFrame.minY - 134.5, width: 197, height: 134.5), imageName: "sl_guide_partent_5")
                
                //                let childViewFrame = self.tableHeaderView.convert(self.tableHeaderView.childView.frame, to: self.tabBarController!.view)
                let childViewFrame = CGRect.init(x: 0, y: 120 + kSafeTopHeight, width: 212, height: 41)
                let childModel = SLGuideModel.init(type: SLGuideType.mask, maskFrame: CGRect.init(x: childViewFrame.minX + 4, y: childViewFrame.minY - 10 , width: childViewFrame.width , height: childViewFrame.height + 20), maskCornerRadius: 15, imageFrame: CGRect.init(x: 16.5, y: childViewFrame.maxY + 10, width: 251.5, height: 135.5), imageName: "sl_guide_partent_2")
                SLGuideViewWindow.showGuideViewWindow(items: [topPartentModel,agendaModel,childModel]){
                    [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.tableHeaderView.setHeaderModel(strongSelf.weathModel, agendaCount: strongSelf.agendaCount)
                    strongSelf.isShowGuide = false
                    strongSelf.tableView.reloadData()
                }
                UserDefaults.standard.set(true, forKey: "isShowPartentHomeGuide")
            }
            
        }
    }
    
    func initUI(){
        tableHeaderView.layoutIfNeeded();
        let height = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        tableHeaderView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height )
        tableView.tableHeaderView = tableHeaderView
        tableView.register(SLHomeTableSectionView.self, forHeaderFooterViewReuseIdentifier: "SLHomeTableSectionView")
        
        view.addSubview(homeNavView)
        homeNavView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
        }
        view.addSubview(topAgendaView)
        topAgendaView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(homeNavView.snp_bottom)
        }
    }
    
    @objc func updateAgenda(){
        var request: SLBaseRequset!
        if SLPersonDataModel.sharePerson.personRole == .TEACHER{
            request = SLEducationTodoTeacherRedPointRequest()
        }else{
            request = SLEducationTodoChildrenRedPointRequest.init(childrenClassList: sl_childrenClassList)
        }
        request.request({ (result) in
            self.agendaCount = result["count"].intValue
            self.topAgendaView.count = self.agendaCount
            self.tableHeaderView.setHeaderModel(self.weathModel, agendaCount: self.agendaCount)
        }) { (msg, code) in
        }
    }
    
    override func homeLoadUpdateTopData(type: HomeType, id: Int = 0, createTime: String = "", isTop: Int = 0, sucess: (() -> ())? = nil) {
        UIUtil.sl_loadUpdateTopData(type: type, id: id, createTime: createTime, isTop: isTop, positon: .home, sucess: sucess)
    }
    
    override func homesl_loadRecallData(model: SLHomeListModel, sucess: (() -> ())? = nil) {
        UIUtil.sl_loadRecallData(model, positon: .home, complete: sucess)
    }
    
    override func sl_refreshData() {
        self.curruntPage = 1
        self.loadUserData()
    }
    
    @objc func refreshList() {
        self.curruntPage = 1
        self.loadData()
    }
    
    // MARK: -loadData
    @objc override func loadData(){
        if curruntPage == 1 {
            
            cheakLoadLocation()
            
            self.group.enter()
            queue.async {
                self.loadAegentCountData()
            }
        }
        
        self.group.enter()
        queue.async {
            self.loadListData()
        }
        
        
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                
                if SLPersonDataModel.sharePerson.personRole == .PARENT{
                    for section in self.dataSource{
                        for model in section.items{
                            model.childrenId = self.sl_user.curruntChild?.id
                        }
                    }
                }
                self.homeNavView.titleLabel.text = "\(Date.sl_helloTime(interval: TimeInterval(self.sl_user.timestamp ?? 0)))，\(self.sl_user.name ?? "")"
                
                self.topAgendaView.count = self.agendaCount
                self.reloadFooterView()
                if !self.isShowGuide{
                    self.tableView.reloadData()
                    self.tableHeaderView.setHeaderModel(self.weathModel,agendaCount: self.agendaCount)
                }
                self.tableHeaderView.setHeaderModel(self.weathModel,agendaCount: self.agendaCount)
                self.sl_endingRefresh()
                
            }
        }
    }
    
    func loadListData(){
        //无网络
        if !SLPersonDataModel.sharePerson.isNetWorkingConnect{
            self.dataSource = SLCacheHelper.sl_getCacheHomeList()
            self.group.leave()
            return
        }
        
        let isParent = SLPersonDataModel.sharePerson.personRole == .PARENT
        
        //无数据
        if sl_user.gradeIds == nil || sl_user.gradeIds?.count == 0 || (isParent && sl_user.curruntChild?.grade == nil){
            self.removeAll()
            self.group.leave()
            return
        }
        
        var classIdList: [Int]!
        var stage: String!
        if isParent{
            classIdList = [sl_user.curruntChild?.classId ?? 0]
            stage = sl_user.curruntChild?.grade?.stage ?? ""
        }else{
            classIdList = sl_user.gradeIds ?? []
            stage = sl_user.stage ?? ""
        }
        SLEducationFWaterfallPageQueryRequest.init(currentPage: curruntPage,classIdList: classIdList,stage: stage,userType: sl_user.type ?? "", childrenId: sl_user.curruntChild?.id).request({ (result) in
            if self.curruntPage == 1{
                self.removeAll()
            }
            let list = Mapper<SLHomeListModel>().mapArray(JSONObject: result["waterfallList"].object) ?? [SLHomeListModel]()
            for model in list{
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
            SLCacheHelper.sl_cacheHomeList(dataSource: self.dataSource)
            self.group.leave()
        }) { (msg, code) in
            self.group.leave()
            //            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    func loadAegentCountData(){
        var request: SLBaseRequset!
        if SLPersonDataModel.sharePerson.personRole == .TEACHER{
            request = SLEducationTodoTeacherRedPointRequest()
        }else{
            request = SLEducationTodoChildrenRedPointRequest.init(childrenClassList: sl_childrenClassList)
        }
        request.request({ (result) in
            self.agendaCount = result["count"].intValue
            self.group.leave()
        }) { (msg, code) in
            self.group.leave()
        }
    }
    
    func loadUserData(){
        UIUtil.sl_loadUserDetailRequest({ (userModel: SLEducationUserModel) in
            self.loadData()
        }, failureHandler: { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
            self.loadData()
            self.sl_endingRefresh()
        }) {
            if SLPersonDataModel.sharePerson.personRole == .PARENT{
                SLChatHelper.sharedInstance.getSpyUnreadMessage { (list) in
                    if let list = list {
                        SLLocalMessageHelper.shareHelper.sl_changeLocalMessageLists(list: list)
                    }
                }
            }
        }
        
    }
    
    @objc func lookAgendaDetial(){
        let vc = SLAgendaListController()
        navigationController?.pushViewController(vc)
    }
    
    /// 刷新消息
    @objc func reloadMessageData(){
        UIUtil.sl_loadClassCircleMessageListData()
    }
    
    override func addNotification() {
        super.addNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAgenda), name: NSNotification.Name.init(rawValue: kHomeAgendaReducNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshList), name: NSNotification.Name.init(rawValue: kOperationUpdateToTopInSingleClassHomeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sl_refreshData), name: NSNotification.Name.init(rawValue: kDelectChildSucessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sl_refreshData), name: NSNotification.Name.init(rawValue: kCreateClassSucessNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateListForRecall(_:)), name: NSNotification.Name.init(rawValue: kOperationRecallInFriendCirleNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateListForRecall(_:)), name: NSNotification.Name.init(rawValue: kOperationPraiseInItemFriendCirleNotification), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateListForChatCall(_:)), name: NSNotification.Name.init(rawValue: kChatCallRefreshNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateListForReduceHomeCellRed(_:)), name: NSNotification.Name.init(rawValue: kHomeCellReducNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMessageData), name: NSNotification.Name.init(rawValue: kChatCallRefreshFriendsCircleNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshHeaderView), name: NSNotification.Name.init(rawValue: kMineChangeProfileNotification), object: nil)
    }
    
    
    /// 刷新头部
    /// - Parameter notification:
    @objc func refreshHeaderView(_ notification:Notification){
        self.tableHeaderView.setHeaderModel(weathModel, agendaCount: self.agendaCount)
    }
    
    @objc func updateListForChatCall(_ notification:Notification){
        let model = notification.object as? IMCustomMessageModel
        if let model = model{
            SLLocalMessageHelper.shareHelper.sl_changeLocalMessageLists(list: [model])
            
            if model.msgType == 3{
                UIUtil.sl_reduceAgenda(serviceId: model.serviceId ?? 0, info: [kEventKey: HomeType.init(rawValue: model.serviceType ?? 0) ?? .homework])
            }
        }
        loadData()
    }
    
    @objc func updateListForReduceHomeCellRed(_ notification:Notification){
        DispatchQueue.global().async {
            if let serviceId = notification.object as? Int{
                var indexSection = 0
                var indexRow = 0
                for (section,sectionModel) in self.dataSource.enumerated(){
                    for (index,model) in sectionModel.items.enumerated(){
                        if model.serviceId == serviceId{
                            indexSection = section
                            indexRow = index
                            DispatchQueue.main.async {
                                self.tableHeaderView.setHeaderModel(self.weathModel, agendaCount: self.agendaCount)
                                self.reloadTableView(IndexPath.init(row: indexRow, section: indexSection))
                            }
                            return
                        }
                    }
                }
            }
        }
    }
    
    // MARK: -public
    
    // MARK: - tableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dealSelectRow(didSelectRowAt: indexPath, childModel: sl_user.curruntChild)
    }
    
    
    // MARK: - getter&setter
    lazy var tableHeaderView: SLHomeTableHeaderView = {
        let tableHeaderView = SLHomeTableHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 0))
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
        topAgendaView.addTaget(target: self, selctor: #selector(lookAgendaDetial))
        return topAgendaView
    }()
}

extension SLHomeController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > kSafeTopHeight + 64{
            homeNavView.isHidden = false
        }else{
            homeNavView.isHidden = true
        }
        
        if scrollView.contentOffset.y > tableHeaderView.agendaView.y - (kSafeTopHeight + 64){
            topAgendaView.isHidden = false
        }else{
            topAgendaView.isHidden = true
        }
        
    }
}

// MARK: -HMRouterEventProtocol
extension SLHomeController: SLRouterEventProtocol{
    func sl_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYMHomeTableHeaderViewLookClassEvent:
            if SLPersonDataModel.sharePerson.personRole == .PARENT && self.sl_user.curruntChild?.grade?.id == nil{
                UIUtil.curruntNav().pushViewController(SLClassAddController())
                return
            }
            let vc:UIViewController = SLPersonDataModel.sharePerson.personRole == .PARENT ? SLParentClassListViewController(): SLTeacherClassListViewController()
            navigationController?.pushViewController(vc)
        case kYMHomeTableHeaderViewScanEvent:
            let vc = SLScanViewController()
            navigationController?.pushViewController(vc)
        case kYMHomeTableHeaderViewAgendaClassEvent:
            lookAgendaDetial()
        case kYMHomeChildViewUpdateEvent:
            sl_refreshData()
        case kYMHomeTableHeaderViewReloadLocationEvent:
            cheakLocationAlert()
        case kYMHomeChildViewAddChild:
            UIUtil.curruntNav().pushViewController(SLClassAddController())
        case kYMHomeTableHeaderViewPublishEvent:
            publishClick()
        default:
            break
        }
    }
}


// MARK: -AMapLocationManager
extension SLHomeController{
    func loadWeatherData(city: String){
        SLEducationFWeatherCurrentRequest.init(city: city).request({ (model:SLWeathModel) in
            self.tableHeaderView.dayLabel.isUserInteractionEnabled = false
            self.weathModel = model
            model.curruntRequestData = Date()
            NSKeyedArchiver.archiveRootObject(model, toFile: NSUtil.sl_archiveFile(file: "weatherModel"))
        }) { (msg, code) in
            
        }
    }
    
    func setWeathFailurModel(){
        tableHeaderView.dayLabel.isUserInteractionEnabled = true
        let model = SLWeathModel.init(JSON: ["" : ""])
        model?.loadFailure = true
        self.weathModel = model
    }
    
    func cheakLocationAlert(){
        SLAuthorityTool.sl_openLocationServiceWithBlock(true) { (open) in
            if open{
                self.loadLocation()
            }
        }
    }
    
    func cheakLoadLocation(){
        SLAuthorityTool.sl_openLocationServiceWithBlock(false) { (open) in
            if open{
                self.loadLocation()
            }else{
                self.setWeathFailurModel()
            }
        }
    }
    
    func loadLocation(){
        let weatherModel = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.sl_archiveFile(file: "weatherModel")) as? SLWeathModel ?? SLWeathModel.init(JSON: ["": ""])
        if weatherModel?.isToDay ?? false{
            self.weathModel = weatherModel
            return
        }
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.locationTimeout = 2
        locationManager.reGeocodeTimeout = 2
        locationManager.requestLocation(withReGeocode: true, completionBlock: { [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            guard let strongSelf = self else { return }
            if let error = error {
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    MBProgressHUD.sl_showMessage(message: "定位失败")
                    strongSelf.setWeathFailurModel()
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                    strongSelf.setWeathFailurModel()
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }
            
            if let reGeocode = reGeocode {
                strongSelf.loadWeatherData(city: reGeocode.city?.removingSuffix("市") ?? "")
            }else{
                strongSelf.setWeathFailurModel()
            }
        })
    }
}

