//
//  SLClassStarSignleClassDetialController.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/3.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

/// 教师单个班级之星页面
class SLClassStarSignleClassDetialController: SLClassStarSignleClassCommonController {
    var classId: Int = 0
    
    var classModel: SLClassStartClassModel?
    var dataSource: [SLClassStarHistoryModel] = [SLClassStarHistoryModel]()
    // MARK: - init
    init(classModel: SLClassStartClassModel?) {
        self.classModel = classModel
        super.init()
        tableViewIsGroup = true
        showBegainRefresh = false
        hasRefreshHeader = false
        
        classId = classModel?.classId ?? 0
    }
    /// 不经过班级列表直接进入单个班级详情页 需要班级id
    convenience init(classId: Int) {
        self.init(classModel: nil)
        self.classId = classId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(publishButton)
        publishButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.bottom.equalTo(-kTabBottomHeight - 15)
            make.size.equalTo(CGSize.init(width: 51.5, height: 51.5))
        }
        
        tableView.rowHeight = 69
        tableView.register(SLClassStarTeacherSingleCell.self, forCellReuseIdentifier: "SLClassStarTeacherSingleCell")
        tableView.register(SLClassStarTeacherSingleHeaderView.self, forHeaderFooterViewReuseIdentifier: "SLClassStarTeacherSingleHeaderView")
        tableView.register(SLClassStarTeacherSingleFooterView.self, forHeaderFooterViewReuseIdentifier: "SLClassStarTeacherSingleFooterView")
        tableView.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 20))
        
        
        if let classModel = classModel{
            customNav.title = classModel.className ?? ""
            initHeaderView()
            tableHeaderView.setHeaderModel(classModel)
            if classModel.hasComment{
                loadData()
            }else{
                updateUI()
            }
        }else{
            loadClassTopData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadClassTopData), name: NSNotification.Name.init(rawValue: kUpdateClassStarScoreNotification), object: nil)
    }
    
    func initHeaderView(){
        tableHeaderView.layoutIfNeeded();
        let height = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        tableHeaderView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height )
        tableView.tableHeaderView = tableHeaderView
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func yxs_refreshData() {
        curruntPage = 1
        loadData()
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    override func uploadData(){
        curruntPage = 1
        classModel?.dateType = DateType.init(rawValue: selectModel.paramsKey) ?? DateType.W
        self.tableHeaderView.setHeaderModel(self.classModel)
        loadClassTopData()
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    // MARK: -UI
    func updateUI(){
        publishButton.isHidden = !(classModel?.hasComment ?? false)
        self.tableHeaderView.setHeaderModel(self.classModel)
        updateFooterViewUI()
        self.tableView.reloadData()
    }
    
    /// 是否展示尾部点评按钮
    var showComment: Bool = false
    func updateFooterViewUI(){
        if let classModel = classModel,classModel.hasComment{
            tableView.estimatedSectionFooterHeight = 0
            showComment = false
        }
        else{
            tableView.estimatedSectionFooterHeight = 275
            showComment = true
        }
    }
    // MARK: -loadData
    @objc func loadClassTopData() {
        YXSEducationClassStarTeacherClassTopRequest.init(classId: classId, dateType: classModel?.dateType ?? DateType.W).requestCollection({ (classs:[SLClassStartClassModel]) in
            let model = classs.first
            if let  model = model{
                if let classModel = self.classModel{
                    model.dateType = classModel.dateType
                }
                self.classModel = model
                self.initHeaderView()
                if model.hasComment{
                    self.loadData()
                }else{
                    self.updateUI()
                }
                self.tableHeaderView.setHeaderModel(self.classModel)
                self.customNav.title = model.className ?? ""
                
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast("\(msg)")
        }
    }
    
    
    let queue = DispatchQueue.global()
    let group = DispatchGroup()
    override func loadData() {
        if curruntPage == 1{
            group.enter()
            queue.async {
                self.loadBestData()
            }
        }
        
        group.enter()
        queue.async {
            self.loadListData()
        }
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                self.yxs_endingRefresh()
                MBProgressHUD.hide(for: self.view, animated: true)
                self.updateUI()
            }
        }
    }
    
    
    
    func loadBestData(){
        YXSEducationClassStarChildrenBestRequest.init(classId: classId, dateType: classModel?.dateType ?? DateType.W).request({ (topModel:ClassStarBestModel) in
            self.classModel?.topStudent = topModel
            self.group.leave()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
            self.group.leave()
        }
    }
    
    func loadListData(){
        YXSEducationClassStarTeacherEvaluationHistoryListPageRequest.init(classId: classId, currentPage: curruntPage,dateType: classModel?.dateType ?? DateType.W).requestCollection({ (list:[SLClassStarHistoryModel]) in
            if self.curruntPage == 1{
                self.dataSource.removeAll()
            }
            self.dataSource += list
            self.loadMore = list.count == kPageSize
            self.group.leave()
        }) { (msg, code) in
            self.group.leave()
        }
    }
    // MARK: -action
    @objc func yxs_publishClick(){
        let vc = SLClassStarTeacherPublishCommentController.init(model: classModel!)
        navigationController?.pushViewController(vc)
    }
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SLClassStarTeacherSingleCell") as! SLClassStarTeacherSingleCell
        cell.showChildName = true
        cell.yxs_setCellModel(dataSource[indexPath.row])
        cell.isLastRow = indexPath.row == dataSource.count - 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource.count == 0 ? 0 : 56.5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: SLClassStarTeacherSingleHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SLClassStarTeacherSingleHeaderView") as! SLClassStarTeacherSingleHeaderView
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer: SLClassStarTeacherSingleFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SLClassStarTeacherSingleFooterView") as! SLClassStarTeacherSingleFooterView
        footer.setFooterModel(classModel)
        footer.showComment = showComment
        return footer
    }
    
    // MARK: - getter&setter
    lazy var tableHeaderView: SLClassStarTeacherDetialHeaderView = {
        let tableHeaderView = SLClassStarTeacherDetialHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0),stage: classModel?.stageType ?? StageType.KINDERGARTEN)
        return tableHeaderView
    }()
    
    lazy var publishButton: YXSButton = {
        let button = YXSButton()
        button.setBackgroundImage(UIImage.init(named: "publish"), for: .normal)
        button.addTarget(self, action: #selector(yxs_publishClick), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
}


// MARK: -HMRouterEventProtocol
extension SLClassStarSignleClassDetialController{
    override func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        super.yxs_user_routerEventWithName(eventName: eventName, info: info)
        switch eventName {
        case KClassStarTeacherSingleFooterCommentEvent:
            yxs_publishClick()
        case kYXSClassStarTeacherDetialHeaderViewLookDetialEvent:
            let vc = SLClassStarDetailListController.init(classModel: classModel!)
            navigationController?.pushViewController(vc)
        default:
            break
        }
    }
}


