//
//  YXSHomeController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/15.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import ObjectMapper
import NightNight

///本地存储孩子的key
let kHomeChildKey = "HomeChildKey"

class YXSHomeController: YXSHomeBaseController {
    // MARK: - property
    /// 待办数量
    var yxs_agendaCount: Int = 0
    
    /// 是否正在展示引导
    var yxs_isShowGuide: Bool = false
    
    /// 高德定位
    lazy var yxs_locationManager = AMapLocationManager()
    
    /// 天气model
    var yxs_weathModel: YXSWeathModel?{
        didSet{
            self.tableHeaderView.setHeaderModel(yxs_weathModel, agendaCount: self.yxs_agendaCount)
        }
    }
    
    /// 更新时间
    var tsLastSets: [Int: Int?] = [Int: Int?]()
    
    var firstPageCacheSource: [String: [YXSHomeListModel]] = [String: [YXSHomeListModel]]()
    var lastRecordId: Int = 0
    var lastRecordTime: String? = Date().toString(format: DateFormatType.custom(kCommonDateFormatString))
    ///最近更新时间
    var tsLast: Int?{
        get{
            return tsLastSets[self.yxs_user.curruntChild?.id ?? 0] ?? nil
        }
    }
    
    
    // MARK: - init
    override init() {
        super.init()
        tableViewIsGroup = true
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - leftCycle
    override func viewDidLoad() {
        self.view.addSubview(bgImageView)
        super.viewDidLoad()
//        self.tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F4F5FC"), night: kNightBackgroundColor)
        self.tableView.mixedBackgroundColor = MixedColor(normal: UIColor.clear, night: kNightBackgroundColor)
        self.fd_prefersNavigationBarHidden = true
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kSafeTopHeight)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kTabBottomHeight)
        }
        
        yxs_initUI()
        //家长端展示红点
        if YXSPersonDataModel.sharePerson.personRole == .PARENT{
            yxs_showBadgeOnItem(index: 0, count: YXSLocalMessageHelper.shareHelper.yxs_localMessageCount())
        }else{
            self.yxs_showBadgeOnItem(index: 0, count: 0)
        }
        
        self.yxs_dataSource = YXSCacheHelper.yxs_getCacheHomeList(childrenId: yxs_user.curruntChild?.id)
        
        //引导
        ysx_showGuide()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //            showGuide()
    }
    // MARK: -UI
    
    func yxs_initUI(){
        tableHeaderView.layoutIfNeeded();
        let height = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        tableHeaderView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height )
        tableView.tableHeaderView = tableHeaderView
        tableView.register(YXSHomeTableSectionView.self, forHeaderFooterViewReuseIdentifier: "SLHomeTableSectionView")
        
        view.addSubview(yxs_homeNavView)
        yxs_homeNavView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
        }
        view.addSubview(yxs_topAgendaView)
        yxs_topAgendaView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(yxs_homeNavView.snp_bottom)
        }
    }
    
    
    // MARK: - override
    ///置顶更新
    override func yxs_homeLoadUpdateTopData(type: YXSHomeType, id: Int = 0, createTime: String = "", isTop: Int = 0, sucess: (() -> ())? = nil) {
        UIUtil.yxs_loadUpdateTopData(type: type, id: id, createTime: createTime, isTop: isTop, positon: .home, sucess: sucess)
    }
    ///撤销
    override func yxs_homeyxs_loadRecallData(model: YXSHomeListModel, sucess: (() -> ())? = nil) {
        UIUtil.yxs_loadRecallData(model, positon: .home, complete: sucess)
    }
    
    override func yxs_refreshData() {
        self.curruntPage = 1
        self.yxs_loadUserData()
    }
    
    // MARK: - refresh 不刷用户信息
    @objc func yxs_refreshListWithOutUserData() {
        self.curruntPage = 1
        self.yxs_loadData()
    }
    
    // MARK: - loadData
    @objc override func yxs_loadData(){
        if curruntPage == 1 {
            
            yxs_cheakLoadLocation()
            
            self.group.enter()
            queue.async {
                self.yxs_loadAegentCountData()
            }
        }
        
        self.group.enter()
        queue.async {
            self.yxs_loadListData()
        }
        
        
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                
                if YXSPersonDataModel.sharePerson.personRole == .PARENT{
                    for section in self.yxs_dataSource{
                        for model in section.items{
                            model.childrenId = self.yxs_user.curruntChild?.id
                        }
                    }
                }
                self.yxs_homeNavView.titleLabel.text = "\(Date.yxs_helloTime(interval: TimeInterval(self.yxs_user.timestamp ?? 0)))，\(self.yxs_user.name ?? "")"
                
                self.yxs_topAgendaView.count = self.yxs_agendaCount
                self.yxs_reloadFooterView()
                if !self.yxs_isShowGuide{
                    self.tableView.reloadData()
                    self.tableHeaderView.setHeaderModel(self.yxs_weathModel,agendaCount: self.yxs_agendaCount)
                }
                self.tableHeaderView.setHeaderModel(self.yxs_weathModel,agendaCount: self.yxs_agendaCount)
                self.yxs_endingRefresh()
                SLLog("yxs_endingRefresh")
            }
        }
    }
    func yxs_loadListData(){
        let isParent = YXSPersonDataModel.sharePerson.personRole == .PARENT
        
        //无数据
        if yxs_user.gradeIds == nil || yxs_user.gradeIds?.count == 0 || (isParent && yxs_user.curruntChild?.grade == nil){
            self.yxs_removeAll()
            self.group.leave()
            return
        }
        
        var classIdList: [Int]!
        var stage: String!
        if isParent{
            classIdList = [yxs_user.curruntChild?.classId ?? 0]
            stage = yxs_user.curruntChild?.grade?.stage ?? ""
        }else{
            classIdList = yxs_user.gradeIds ?? []
            stage = yxs_user.stage ?? ""
        }
        SLLog("YXSEducationwaterfallPageQueryV2Request_start")
        YXSEducationwaterfallPageQueryV2Request.init(currentPage: curruntPage,classIdList: classIdList,stage: stage,userType: yxs_user.type ?? "", childrenId: yxs_user.curruntChild?.id, lastRecordId: lastRecordId,lastRecordTime: lastRecordTime, tsLast: tsLast).request({ (result) in
            
            var list = Mapper<YXSHomeListModel>().mapArray(JSONObject: result["waterfallList"].object) ?? [YXSHomeListModel]()
            self.loadMore = result["hasNext"].boolValue
            if self.curruntPage == 1{
                self.tsLastSets[self.yxs_user.curruntChild?.id ?? 0] = result["tsLast"].intValue
                 self.yxs_removeAll()
                
                if list.count == 0{///没有更新 取缓存数据
                    list = self.firstPageCacheSource["\(self.yxs_user.curruntChild?.id ?? 0)"] ?? [YXSHomeListModel]()
                    self.loadMore = list.count == kPageSize ? true : false
                }else{
                    self.firstPageCacheSource["\(self.yxs_user.curruntChild?.id ?? 0)"] = list
                }
            }else{
                self.loadMore = result["hasNext"].boolValue
                self.tsLastSets[self.yxs_user.curruntChild?.id ?? 0] = nil
            }
            
            self.lastRecordId = list.last?.id ?? 0
            self.lastRecordTime = list.last?.createTime
            
            for model in list{
                //置顶
                if let isTop = model.isTop{
                    if isTop == 1 {
                        self.yxs_dataSource[0].items.append(model)
                        continue
                    }
                }
                //今天
                if NSUtil.yxs_isSameDay(NSUtil.yxs_string2Date(model.createTime ?? ""), date2: Date()){
                    self.yxs_dataSource[1].items.append(model)
                    continue
                }
                
                //更早
                self.yxs_dataSource[2].items.append(model)
            }
            YXSCacheHelper.yxs_cacheHomeList(dataSource: self.yxs_dataSource, childrenId: self.yxs_user.curruntChild?.id)
            SLLog("YXSEducationwaterfallPageQueryV2Request_end")
            self.group.leave()
        }) { (msg, code) in
            self.group.leave()
            //            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    func yxs_loadAegentCountData(){
        var request: YXSBaseRequset!
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            request = YXSEducationTodoTeacherRedPointRequest()
        }else{
            request = YXSEducationTodoChildrenRedPointRequest.init(childrenClassList: yxs_childrenClassList)
        }
        SLLog("YXSEducationTodo_start")
        request.request({ (result) in
            self.yxs_agendaCount = result["count"].intValue
            SLLog("YXSEducationTodo_end")
            self.group.leave()
        }) { (msg, code) in
            self.group.leave()
        }
    }
    
    func yxs_loadUserData(){
        UIUtil.yxs_loadUserDetailRequest({ (userModel: YXSEducationUserModel) in
            self.yxs_loadData()
        }, failureHandler: { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
            self.yxs_loadData()
            self.yxs_endingRefresh()
        }) {
            if YXSPersonDataModel.sharePerson.personRole == .PARENT{
                YXSChatHelper.sharedInstance.getSpyUnreadMessage { (list) in
                    if let list = list {
                        YXSLocalMessageHelper.shareHelper.yxs_changeLocalMessageLists(list: list)
                    }
                }
            }
        }
        
    }
    
    // MARK: - private
    @objc func yxs_lookAgendaDetial(){
        let vc = YXSAgendaListController()
        navigationController?.pushViewController(vc)
    }
    
    
    // MARK: - tableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dealSelectRow(didSelectRowAt: indexPath, childModel: yxs_user.curruntChild)
    }
    
    
    // MARK: - getter&setter
    lazy var tableHeaderView: YXSHomeTableHeaderView = {
        let tableHeaderView = YXSHomeTableHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 0))
        return tableHeaderView
    }()
    
    lazy var yxs_homeNavView: YXSHomeNavView = {
        let homeNavView = YXSHomeNavView()
        homeNavView.isHidden = true
        return homeNavView
    }()
    
    lazy var yxs_topAgendaView: YXSHomeAgendaView = {
        let topAgendaView = YXSHomeAgendaView.init(true)
        topAgendaView.isHidden = true
        topAgendaView.addTaget(target: self, selctor: #selector(yxs_lookAgendaDetial))
        return topAgendaView
    }()
    
    lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.view.frame
        imageView.mixedImage = MixedImage(normal: UIImage.init(named: "yxs_home_new_bg")!, night: UIImage.yxs_image(with: kNightForegroundColor)!)
        return imageView
    }()
}
// MARK: - scrollViewDidScroll
extension YXSHomeController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 64{
            yxs_homeNavView.isHidden = false
        }else{
            yxs_homeNavView.isHidden = true
        }
        
//        if scrollView.contentOffset.y > tableHeaderView.yxs_agendaView.y - 64{
//            yxs_topAgendaView.isHidden = false
//        }else{
//            yxs_topAgendaView.isHidden = true
//        }
        
    }
}

// MARK: - HMRouterEventProtocol
extension YXSHomeController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSHomeTableHeaderViewLookClassEvent:
            if YXSPersonDataModel.sharePerson.personRole == .PARENT && self.yxs_user.curruntChild?.grade?.id == nil{
                UIUtil.curruntNav().pushViewController(YXSClassAddController())
                return
            }
            let vc:UIViewController = YXSPersonDataModel.sharePerson.personRole == .PARENT ? YXSParentClassListViewController(): YXSTeacherClassListViewController()
            navigationController?.pushViewController(vc)
        case kYXSHomeTableHeaderViewScanEvent:
            let vc = YXSScanViewController()
            navigationController?.pushViewController(vc)
        case kYXSHomeTableHeaderViewAgendaClassEvent:
            yxs_lookAgendaDetial()
        case kYXSHomeChildViewUpdateEvent:
            ///先清除缓存记录
             lastRecordId = 0
             lastRecordTime = Date().toString(format: DateFormatType.custom(kCommonDateFormatString))
             self.yxs_dataSource = YXSCacheHelper.yxs_getCacheHomeList(childrenId: yxs_user.curruntChild?.id)
             self.tableView.reloadData()
             
            yxs_refreshData()
        case kYXSHomeTableHeaderViewReloadLocationEvent:
            yxs_cheakLocationAlert()
        case kYXSHomeChildViewAddChild:
            UIUtil.curruntNav().pushViewController(YXSClassAddController())
        case kYXSHomeTableHeaderViewPublishEvent:
            yxs_publishClick()
        default:
            break
        }
    }
}


// MARK: - AMapLocationManager 定位天气相关
extension YXSHomeController{
    func yxs_loadWeatherData(city: String){
        YXSEducationFWeatherCurrentRequest.init(city: city).request({ (model:YXSWeathModel) in
            self.tableHeaderView.yxs_dayLabel.isUserInteractionEnabled = false
            self.yxs_weathModel = model
            model.curruntRequestData = Date()
            NSKeyedArchiver.archiveRootObject(model, toFile: NSUtil.yxs_archiveFile(file: "weatherModel"))
        }) { (msg, code) in
            
        }
    }
    
    func yxs_setWeathFailurModel(){
        tableHeaderView.yxs_dayLabel.isUserInteractionEnabled = true
        let model = YXSWeathModel.init(JSON: ["" : ""])
        model?.loadFailure = true
        self.yxs_weathModel = model
    }
    
    func yxs_cheakLocationAlert(){
        YXSLAuthorityTool.yxs_openLocationServiceWithBlock(true) { (open) in
            if open{
                self.yxs_loadLocation()
            }
        }
    }
    
    func yxs_cheakLoadLocation(){
        YXSLAuthorityTool.yxs_openLocationServiceWithBlock(false) { (open) in
            if open{
                self.yxs_loadLocation()
            }else{
                self.yxs_setWeathFailurModel()
            }
        }
    }
    
    func yxs_loadLocation(){
        let weatherModel = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "weatherModel")) as? YXSWeathModel ?? YXSWeathModel.init(JSON: ["": ""])
        if weatherModel?.isToDay ?? false{
            self.yxs_weathModel = weatherModel
            return
        }
        
        
        yxs_locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        yxs_locationManager.locationTimeout = 2
        yxs_locationManager.reGeocodeTimeout = 2
        yxs_locationManager.requestLocation(withReGeocode: true, completionBlock: { [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            guard let strongSelf = self else { return }
            if let error = error {
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    MBProgressHUD.yxs_showMessage(message: "定位失败")
                    strongSelf.yxs_setWeathFailurModel()
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
                    strongSelf.yxs_setWeathFailurModel()
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }
            
            if let reGeocode = reGeocode {
                strongSelf.yxs_loadWeatherData(city: reGeocode.city?.removingSuffix("市") ?? "")
            }else{
                strongSelf.yxs_setWeathFailurModel()
            }
        })
    }
}

// MARK: - Notification
extension YXSHomeController{
    override func yxs_addNotification() {
        super.yxs_addNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAgenda), name: NSNotification.Name.init(rawValue: kHomeAgendaReducNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_refreshListWithOutUserData), name: NSNotification.Name.init(rawValue: kOperationUpdateToTopInSingleClassHomeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_refreshData), name: NSNotification.Name.init(rawValue: kDelectChildSucessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_refreshData), name: NSNotification.Name.init(rawValue: kCreateClassSucessNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_updateListForRecall(_:)), name: NSNotification.Name.init(rawValue: kOperationRecallInFriendCirleNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_updateListForRecall(_:)), name: NSNotification.Name.init(rawValue: kOperationPraiseInItemFriendCirleNotification), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateListForChatCall(_:)), name: NSNotification.Name.init(rawValue: kChatCallRefreshNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateListForReduceHomeCellRed(_:)), name: NSNotification.Name.init(rawValue: kHomeCellReducNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMessageData), name: NSNotification.Name.init(rawValue: kChatCallRefreshFriendsCircleNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshHeaderView), name: NSNotification.Name.init(rawValue: kMineChangeProfileNotification), object: nil)
    }
    
    
    /// - Parameter notification:
    @objc func refreshHeaderView(_ notification:Notification){
        self.tableHeaderView.setHeaderModel(yxs_weathModel, agendaCount: self.yxs_agendaCount)
    }
    
    @objc func updateListForChatCall(_ notification:Notification){
        let model = notification.object as? IMCustomMessageModel
        if let model = model{
            YXSLocalMessageHelper.shareHelper.yxs_changeLocalMessageLists(list: [model])
            
            if model.msgType == 3{
                UIUtil.yxs_reduceAgenda(serviceId: model.serviceId ?? 0, info: [kEventKey: YXSHomeType.init(rawValue: model.serviceType ?? 0) ?? .homework])
            }
        }
        yxs_loadData()
    }
    
    @objc func updateListForReduceHomeCellRed(_ notification:Notification){
        DispatchQueue.global().async {
            if let serviceId = notification.object as? Int{
                var indexSection = 0
                var indexRow = 0
                for (section,sectionModel) in self.yxs_dataSource.enumerated(){
                    for (index,model) in sectionModel.items.enumerated(){
                        if model.serviceId == serviceId{
                            indexSection = section
                            indexRow = index
                            DispatchQueue.main.async {
                                self.tableHeaderView.setHeaderModel(self.yxs_weathModel, agendaCount: self.yxs_agendaCount)
                                self.yxs_reloadTableView(IndexPath.init(row: indexRow, section: indexSection))
                            }
                            return
                        }
                    }
                }
            }
        }
    }
    
    /// 更新待办
    @objc func updateAgenda(){
//        var request: YXSBaseRequset!
//        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
//            request = YXSEducationTodoTeacherRedPointRequest()
//        }else{
//            request = YXSEducationTodoChildrenRedPointRequest.init(childrenClassList: yxs_childrenClassList)
//        }
//        request.request({ (result) in
//            self.yxs_agendaCount = result["count"].intValue
//            self.yxs_topAgendaView.count = self.yxs_agendaCount
//            self.tableHeaderView.setHeaderModel(self.yxs_weathModel, agendaCount: self.yxs_agendaCount)
//        }) { (msg, code) in
//        }
    }
    
    /// 刷新消息
    @objc func reloadMessageData(){
        UIUtil.yxs_loadClassCircleMessageListData()
    }
}

// MARK: - 引导视图展示
extension YXSHomeController{
    func ysx_showGuide(){
        var isShowTeacherHomeGuide = UserDefaults.standard.bool(forKey: "isShowTeacherHomeGuide")
        var isShowPartentHomeGuide = UserDefaults.standard.bool(forKey: "isShowPartentHomeGuide")
        //        isShowPartentHomeGuide = false
        //        isShowTeacherHomeGuide = false
        if !isShowTeacherHomeGuide || !isShowPartentHomeGuide{
            self.view.layoutIfNeeded()
//            let agendaFrame = self.tableHeaderView.convert(self.tableHeaderView.yxs_agendaView.frame, to: self.tabBarController!.view)
//            let agendaModel = YXSGuideModel.init(type: SLGuideType.mask, maskFrame: CGRect.init(x: agendaFrame.minX + 15, y: agendaFrame.minY , width: agendaFrame.width - 30, height: agendaFrame.height), maskCornerRadius: 15, imageFrame: CGRect.init(x: (SCREEN_WIDTH - 197)/2, y: agendaFrame.maxY, width: 197, height: 135.5), imageName: "yxs_guide_teacher_3")
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER && !isShowTeacherHomeGuide{
                yxs_isShowGuide = true
                let publishFrame = self.view.convert(self.publishButton.frame, to: self.tabBarController!.view)
                let topTeacherView = YXSGuideView.init(title: "您好~欢迎加入优学业！", desTitle: "在这里您可以发布作业、通知、班级之星等消息，家长即时查收。")
                let height = UIUtil.yxs_getTextHeigh(textStr: topTeacherView.desLabel.text!, font: topTeacherView.desLabel.font, width: SCREEN_WIDTH - 31 - 17 - 103)
                let topTeacherModel = YXSGuideModel.init(type: SLGuideType.view, view: topTeacherView, viewFrame: CGRect.init(x: 15.5, y: 173 + kSafeTopHeight, width: SCREEN_WIDTH - 31, height: height + 68),imageFrame: CGRect.init(x: (SCREEN_WIDTH - 160.5)/2, y: height + 68 + 173 + kSafeTopHeight, width: 160.5, height: 135),imageName: "yxs_guide_teacher_1")
                let publishiModel = YXSGuideModel.init(type: SLGuideType.mask, maskFrame: CGRect.init(x: publishFrame.minX - 10, y: publishFrame.minY - 10, width: publishFrame.width + 20, height: publishFrame.width + 20), maskCornerRadius: (publishFrame.width + 20)/2, imageFrame: CGRect.init(x: SCREEN_WIDTH - 11 - 161, y: publishFrame.maxY - (publishFrame.width + 10) - 135, width: 160.5, height: 135), imageName: "yxs_guide_teacher_2")
//                topTeacherModel,publishiModel,agendaModel
                YXSGuideViewWindow.showGuideViewWindow(items: [topTeacherModel,publishiModel]){
                    [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.yxs_isShowGuide = false
                    strongSelf.tableHeaderView.setHeaderModel(strongSelf.yxs_weathModel, agendaCount: strongSelf.yxs_agendaCount)
                    strongSelf.tableView.reloadData()
                }
                UserDefaults.standard.set(true, forKey: "isShowTeacherHomeGuide")
            }else if YXSPersonDataModel.sharePerson.personRole == .PARENT && !isShowPartentHomeGuide{
                yxs_isShowGuide = true
                //造数据
                //                let servicechildrens = yxs_user.children
                var childrens = [YXSChildrenModel]()
                for _ in 0..<3{
                    let children = YXSChildrenModel.init(JSON: ["":""])!
                    children.realName = "张小飞"
                    childrens.append(children)
                }
                YXSPersonDataModel.sharePerson.userModel.children = childrens
                tableHeaderView.setHeaderModel(yxs_weathModel, agendaCount: 2)
                
                self.view.layoutIfNeeded()
                let topPartentView = YXSGuideView.init(title: "您好~欢迎加入优学业！", desTitle: "在这里您将即时收到老师的发布作业、通知、班级之星等消息。")
                let height = UIUtil.yxs_getTextHeigh(textStr: topPartentView.desLabel.text!, font: topPartentView.desLabel.font, width: SCREEN_WIDTH - 31 - 17 - 103)
                let topPartentModel = YXSGuideModel.init(type: SLGuideType.view, view: topPartentView, viewFrame: CGRect.init(x: 15.5, y: 173 + kSafeTopHeight, width: SCREEN_WIDTH - 31, height: height + 68),imageFrame: CGRect.init(x: (SCREEN_WIDTH - 107.5)/2, y: height + 68 + 173 + kSafeTopHeight, width: 107.5, height: 95),imageName: "yxs_guide_partent_1")
//                let agendaFrame = self.tableHeaderView.convert(self.tableHeaderView.yxs_agendaView.frame, to: self.tabBarController!.view)
//                let agendaModel = YXSGuideModel.init(type: SLGuideType.mask, maskFrame: CGRect.init(x: agendaFrame.minX + 15, y: agendaFrame.minY , width: agendaFrame.width - 30, height: agendaFrame.height), maskCornerRadius: 15, imageFrame: CGRect.init(x: (SCREEN_WIDTH - 197)/2, y: agendaFrame.minY - 134.5, width: 197, height: 134.5), imageName: "yxs_guide_partent_5")
                
                //                let childViewFrame = self.tableHeaderView.convert(self.tableHeaderView.childView.frame, to: self.tabBarController!.view)
                let childViewFrame = CGRect.init(x: 0, y: 120 + kSafeTopHeight, width: 212, height: 41)
                let childModel = YXSGuideModel.init(type: SLGuideType.mask, maskFrame: CGRect.init(x: childViewFrame.minX + 4, y: childViewFrame.minY - 10 , width: childViewFrame.width , height: childViewFrame.height + 20), maskCornerRadius: 15, imageFrame: CGRect.init(x: 16.5, y: childViewFrame.maxY + 10, width: 251.5, height: 135.5), imageName: "yxs_guide_partent_2")
//                topPartentModel,agendaModel,childModel
                YXSGuideViewWindow.showGuideViewWindow(items: [topPartentModel,childModel]){
                    [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.tableHeaderView.setHeaderModel(strongSelf.yxs_weathModel, agendaCount: strongSelf.yxs_agendaCount)
                    strongSelf.yxs_isShowGuide = false
                    strongSelf.tableView.reloadData()
                }
                UserDefaults.standard.set(true, forKey: "isShowPartentHomeGuide")
            }
            
        }
    }
}

// MARK: - other func
extension YXSHomeController{
    func yxs_dealRootUI() {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "aaaaa"
    }
    
    func yxs_changeUI(_ cancelled: Bool) {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "ccccccc"
    }
    
    func yxs_addUI() {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "测试"
    }
}
