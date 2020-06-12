//
//  YXSSolitaireReadListController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/5.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import JXCategoryView

class YXSSolitaireReadListController: YXSBaseTableViewController, JXCategoryListContentViewDelegate {
    ///是否展示一键提醒
    var showRemind: Bool = true
    var selectedListDataIndex: Int = 0
    
    var classId: Int
    var serviceId: Int
    var createTime: String
    var serviceType: Int
    var callbackRequestParameter: [String: Any]?
    init(classId: Int, serviceId: Int, createTime: String, serviceType: Int, callbackRequestParameter: [String: Any]?) {
        self.classId = classId
        self.serviceId = serviceId
        self.createTime = createTime
        self.serviceType = serviceType
        self.callbackRequestParameter = callbackRequestParameter
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        //是否一创建就刷新
        self.showBegainRefresh = false
        self.hasRefreshHeader = false
        
        super.viewDidLoad()
        self.title = "阅读"
        // Do any additional setup after loading the view.
        self.tableView.register(YXSHomeworkReadListSectionHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: "YXSHomeworkReadListSectionHeader")
        self.tableView.register(YXSHomeworkReadListCell.classForCoder(), forCellReuseIdentifier: "YXSHomeworkReadListCell")
        self.tableView.register(YXSHomeworkCommitListCell.classForCoder(), forCellReuseIdentifier: "SLHomeworkCommitListCell")
        self.tableView.tableHeaderView = tableHeaderView
    }
    
    func listView() -> UIView! {
        return self.view
    }
    
    override func yxs_refreshData() {
        
        tableView.reloadData()

        let headerModel = HomeworkReadCommitListHeaderViewModel()
        if firstListModel?.count ?? 0 > 0 {
            headerModel.percent = CGFloat(firstListModel?.count ?? 0) / CGFloat((firstListModel?.count ?? 0) + (secondListModel?.count ?? 0))
        } else {
            headerModel.percent = 0
        }
        
        headerModel.title = "阅读"
        headerModel.fristTitle = "已阅"
        headerModel.secondTitle = "未阅"
        tableHeaderView.model = headerModel
    }
    
    // MARK: - Request
    @objc func yxs_reminderRequest() {
        var childrenIdList:[Int] = [Int]()
        for sub in secondListModel ?? [YXSClassMemberModel]() {
            childrenIdList.append(sub.childrenId ?? 0)
        }
        MBProgressHUD.yxs_showLoading()
        YXSEducationTeacherOneTouchReminderRequest(childrenIdList: childrenIdList, classId: classId, opFlag: 0, serviceId: serviceId , serviceType: serviceType, serviceCreateTime: createTime ,callbackRequestParameter: callbackRequestParameter).request({ (json) in
            MBProgressHUD.yxs_showMessage(message: "通知成功")
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Action
    @objc func yxs_callUpClick(sender:YXSButton) {
        let currentModel: [YXSClassMemberModel]? = selectedListDataIndex == 0 ? secondListModel : firstListModel
        let model:YXSClassMemberModel = currentModel?[sender.tag] ?? YXSClassMemberModel(JSON: ["":""])!
        UIUtil.yxs_callPhoneNumberRequest(childrenId: model.childrenId ?? 0, classId: classId)
    }
    
    @objc func chatClick(sender:YXSButton) {
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            let currentModel: [YXSClassMemberModel]? = selectedListDataIndex == 0 ? secondListModel : firstListModel
            let model:YXSClassMemberModel = currentModel?[sender.tag] ?? YXSClassMemberModel(JSON: ["":""])!
            UIUtil.yxs_chatImRequest(childrenId: model.childrenId ?? 0, classId: classId)
        }
    }
    
    // MARK: - Setter
    var firstListModel: [YXSClassMemberModel]? {
        didSet {
        }
    }
    
    var secondListModel: [YXSClassMemberModel]? {
        didSet {
        }
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentModel: [YXSClassMemberModel]? = selectedListDataIndex == 0 ? secondListModel : firstListModel
        return currentModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentModel: [YXSClassMemberModel]? = selectedListDataIndex == 0 ? secondListModel : firstListModel
        
        //        if selectedListDataIndex == 0 {
        let cell:YXSHomeworkCommitListCell = tableView.dequeueReusableCell(withIdentifier: "SLHomeworkCommitListCell") as! YXSHomeworkCommitListCell
        cell.btnChat.tag = indexPath.row
        cell.btnPhone.tag = indexPath.row
        cell.btnPhone.addTarget(self, action: #selector(yxs_callUpClick(sender:)), for: .touchUpInside)
        cell.btnChat.addTarget(self, action: #selector(chatClick(sender:)), for: .touchUpInside)
        cell.model = currentModel?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YXSHomeworkReadListSectionHeader") as? YXSHomeworkReadListSectionHeader
        
        sectionHeader?.btnTitle1.setTitle("未阅（\(secondListModel?.count ?? 0)）", for: .normal)
        sectionHeader?.btnTitle2.setTitle("已阅（\(firstListModel?.count ?? 0)）", for: .normal)
        if (YXSPersonDataModel.sharePerson.personRole == .TEACHER && selectedListDataIndex == 0 && secondListModel?.count ?? 0 > 0 ) && showRemind{
            sectionHeader?.btnAlert.isHidden = false
        } else {
            sectionHeader?.btnAlert.isHidden = true
        }

        sectionHeader?.selectedBlock = {[weak self](index) in
            guard let weakSelf = self else {return}
            weakSelf.selectedListDataIndex = index
            weakSelf.tableView.reloadData()
        }
        
        sectionHeader?.alertClick = {[weak self](index) in
            guard let weakSelf = self else {return}
            weakSelf.yxs_reminderRequest()
        }
        return sectionHeader
    }
    
    // MARK: - LazyLoad
    lazy var tableHeaderView: HomeworkReadCommitListHeaderView = {
        let header = HomeworkReadCommitListHeaderView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 211))
        return header
    }()
}
