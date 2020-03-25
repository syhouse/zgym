//
//  SLClassStarPartentDetialController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/10.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//


import UIKit
import NightNight
//保存记录 本地孩子

private let kChildIdKey = "ChildIdKey"
private let kClassIdKey = "ClassIdKey"
class SLClassStarPartentDetialController: SLClassStarSignleClassCommonController {
    var dataSource: [SLClassStarHistoryModel] = [SLClassStarHistoryModel]()
    var teacherLists: [SLClassStartTeacherModel] = [SLClassStartTeacherModel]()
    var partentModel: SLClassStarPartentModel!
    
    var isEmptyUI: Bool = false
    
    var selectTypeModels:[SLSelectModel] = [SLSelectModel.init(text: "全部", isSelect: true, paramsKey: ""),SLSelectModel.init(text: "表扬", isSelect: false, paramsKey: "10"),SLSelectModel.init(text: "待改进", isSelect: false, paramsKey: "20")]
    var selectTypeModel:SLSelectModel = SLSelectModel.init(text: "全部", isSelect: true, paramsKey: "")

    var startTime: String?
    var endTime: String?
    /// 初始化
    /// - Parameter childrenModel: 初始化需要孩子model 用户数据里面找
    init(childrenModel: SLChildrenModel, startTime: String? = nil, endTime: String? = nil) {
        self.childrenModel = childrenModel
        self.startTime = startTime
        self.endTime = endTime
        super.init()
        tableViewIsGroup = true
        showBegainRefresh = false
        hasRefreshHeader = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var childrenModel: SLChildrenModel
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customNav.title = "\(childrenModel.realName ?? "")的班级表现"
        
        tableView.register(SLClassStarTeacherSingleCell.self, forCellReuseIdentifier: "SLClassStarTeacherSingleCell")
        tableView.register(ClassStarTeacherRemindCell.self, forCellReuseIdentifier: "ClassStarTeacherRemindCell")
        tableView.register(SLClassStarTeacherSingleHeaderView.self, forHeaderFooterViewReuseIdentifier: "SLClassStarTeacherSingleHeaderView")
        tableView.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 20))
        tableView.sectionHeaderHeight = 0
        
        loadClassChildrensData()
    }
    
    // MARK: -UI
    func updateUI(){
        if isEmptyUI{
            tableView.rowHeight = 64
            
            tableHeaderEmptyView.setHeaderModel(childrenModel, dateType: self.dateType)
            view.backgroundColor = UIColor.white
            tableView.backgroundColor = UIColor.white
            tableView.sectionHeaderHeight = 0
            
            rightControl.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: UIColor.sl_hexToAdecimalColor(hex: "#575A60"))
            rightControl.mixedImage = MixedImage(normal: "sl_punchCard_down", night: "sl_punchCard_down")
            customNav.backImageButton.setMixedImage(MixedImage(normal: "back", night: "back"), forState: .normal)
            customNav.titleLabel.isHidden = true
            customNav.mixedBackgroundColor = MixedColor(normal: UIColor.clear, night: UIColor.clear)
            tableView.tableHeaderView = tableHeaderEmptyView

        }else{
            tableView.rowHeight = 69
            view.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#D1E4FF")
            tableView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#D1E4FF")
            tableView.sectionHeaderHeight = 56
            rightControl.mixedTextColor = MixedColor(normal: UIColor.white, night: UIColor.white)
            rightControl.mixedImage = MixedImage(normal: "sl_classstar_down", night: "sl_classstar_down")
            customNav.backImageButton.setMixedImage(MixedImage(normal: "sl_back_white", night: "sl_back_white"), forState: .normal)
            customNav.titleLabel.isHidden = false
            customNav.mixedBackgroundColor = MixedColor(normal: UIColor.clear, night: UIColor.clear)
            tableHeaderView.setHeaderModel(partentModel, dateType: dateType, startTime: startTime, endTime: endTime)
            
            let height = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            tableHeaderView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height)
            tableView.tableHeaderView = tableHeaderView
            
        }
    }
    
    func showSelectView(){
        let headerView = self.tableView.headerView(forSection: 0)
        if let headerView  = headerView as? SLClassStarTeacherSingleHeaderView{
            let selectFrame = headerView.convert(headerView.selectButton.frame, to: self.tabBarController?.view)
            var y: CGFloat =  selectFrame.maxY
            let selectHeight: CGFloat = CGFloat(selectTypeModels.count * 44) + kSafeBottomHeight + 10
            if SCREEN_HEIGHT - y < selectHeight {
                y = SCREEN_HEIGHT - selectHeight
            }
            SLHomeListSelectView.showAlert(offset: CGPoint.init(x: 24, y: y), selects: selectTypeModels) { [weak self](selectTypeModel, selectTypeModels) in
                guard let strongSelf = self else { return }
                strongSelf.selectTypeModels = selectTypeModels
                strongSelf.selectTypeModel = selectTypeModel
                strongSelf.curruntPage = 1
                MBProgressHUD.showAdded(to: strongSelf.view, animated: true)
                strongSelf.loadListData()
            }
        }
    }
    
    // MARK: -loadData
    
    override func sl_loadNextPage() {
        loadListData()
    }
    
    override func uploadData() {
        curruntPage = 1
        startTime = nil
        endTime = nil
        loadClassChildrensData()
    }
    var dateType: DateType{
        get{
            return DateType.init(rawValue: selectModel.paramsKey) ?? DateType.W
        }
    }
    func loadClassChildrensData(){
        let curruntType = startTime == nil ? self.dateType : nil
        SLEducationClassStarParentClassChildrenTopRequest.init(childrenId: childrenModel.id ?? 0,classId: childrenModel.classId ?? 0, dateType: curruntType, startTime: startTime, endTime: endTime).request({ (partentModel: SLClassStarPartentModel) in
            self.partentModel = partentModel
            MBProgressHUD.hide(for: self.view, animated: true)
            if self.partentModel.mapTop3?.first == nil{
                //空白UI
                self.isEmptyUI = true
                self.loadTeacherListData()
            }else{
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.isEmptyUI = false
                self.loadListData()
            }
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func loadListData(){
        let curruntType = startTime == nil ? self.dateType : nil
        SLEducationClassStarTeacherEvaluationHistoryListPageRequest.init(category: Int(selectTypeModel.paramsKey),childrenId:childrenModel.id ?? 0,classId: childrenModel.classId ?? 0, currentPage: curruntPage,dateType: curruntType, startTime: startTime, endTime: endTime).requestCollection({ (list:[SLClassStarHistoryModel]) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if self.curruntPage == 1{
                self.dataSource.removeAll()
            }
            self.dataSource += list
            self.sl_endingRefresh()
            self.updateUI()
            self.tableView.reloadData()
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: true)
            MBProgressHUD.sl_showMessage(message: msg)
            self.sl_endingRefresh()
        }
    }
    
    func loadTeacherListData(){
        SLEducationTeacherTeacherBaseInfoRequest.init(childrenId: childrenModel.id ?? 0, classId: childrenModel.classId ?? 0).requestCollection({ (items:[SLClassStartTeacherModel]) in
             MBProgressHUD.hide(for: self.view, animated: true)
            self.teacherLists = items
            self.updateUI()
            self.tableView.reloadData()
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func loadReminderRequest(teacherLists: [SLClassStartTeacherModel]){
        UIUtil.sl_loadClassStartReminderRequest(teacherLists: teacherLists,childrenId: childrenModel.id ?? 0, classId: childrenModel.classId ?? 0)
    }
    
    // MARK: -action
    
    // MARK: -private
    
    
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isEmptyUI ? teacherLists.count :  dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isEmptyUI{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClassStarTeacherRemindCell") as! ClassStarTeacherRemindCell
            cell.sl_setCellModel(teacherLists[indexPath.row])
            cell.cellBlock = {
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.loadReminderRequest(teacherLists: [strongSelf.teacherLists[indexPath.row]])
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SLClassStarTeacherSingleCell") as! SLClassStarTeacherSingleCell
            cell.sl_setCellModel(dataSource[indexPath.row])
            cell.isLastRow = indexPath.row == dataSource.count - 1
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: SLClassStarTeacherSingleHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SLClassStarTeacherSingleHeaderView") as! SLClassStarTeacherSingleHeaderView
        header.selectButton.isHidden = false
        return header
        
    }
    
    // MARK: - getter&setter
    lazy var tableHeaderView: SLClassStartPartentDetailStudentHeaderView = {
        let tableHeaderView = SLClassStartPartentDetailStudentHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0), stage: childrenModel.stage)
        tableHeaderView.childrenModel = childrenModel
        return tableHeaderView
    }()
    lazy var tableHeaderEmptyView: SLClassStartTeacherDetailStudentEmptyHeaderView = {
        let tableHeaderEmptyView = SLClassStartTeacherDetailStudentEmptyHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        return tableHeaderEmptyView
    }()
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > kSafeTopHeight + 64{
            customNav.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
            customNav.backImageButton.setMixedImage(MixedImage(normal: "back", night: "sl_back_white"), forState: .normal)
            customNav.titleLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
            rightControl.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white)
            rightControl.mixedImage = MixedImage(normal: "sl_classstar_down_gray", night: "sl_classstar_down")
        }else{
            customNav.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: UIColor.clear)
            customNav.backImageButton.setMixedImage(MixedImage(normal: "back", night: isEmptyUI ? "back" : "sl_back_white"), forState: .normal)
            customNav.titleLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
            
            rightControl.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: isEmptyUI ? UIColor.sl_hexToAdecimalColor(hex: "#575A60") : UIColor.white)
            rightControl.mixedImage = MixedImage(normal: "sl_classstar_down_gray", night: isEmptyUI ? "sl_classstar_down_gray" : "sl_classstar_down")
        }
    }
    
}

// MARK: -HMRouterEventProtocol
extension SLClassStarPartentDetialController{
    override func sl_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        super.sl_user_routerEventWithName(eventName: eventName, info: info)
        switch eventName {
        case kYMClassStartTeacherDetailStudentEmptyHeaderViewRemindEvent:
            loadReminderRequest(teacherLists: teacherLists)
            case kYMClassStarTeacherSingleHeaderViewSelectEvent:
            showSelectView()
        default:
            break
        }
    }
}


