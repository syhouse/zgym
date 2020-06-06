//
//  YXSSolitaireReplyListController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/5.
//  Copyright © 2020 zgym. All rights reserved.
//
import UIKit
import JXCategoryView
import NightNight

class YXSSolitaireReplyListController: YXSBaseTableViewController, JXCategoryListContentViewDelegate {
    
    var sectionHeader: YXSHomeworkReadListSectionHeader?
    var selectedListDataIndex: Int = 0
    
    var classId: Int
    var serviceId: Int
    var createTime: String
    var serviceType: Int
    init(classId: Int, serviceId: Int, createTime: String, serviceType: Int) {
        self.classId = classId
        self.serviceId = serviceId
        self.createTime = createTime
        self.serviceType = serviceType
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
//        self.title = "提交"
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
        let headerModel = HomeworkReadCommitListHeaderViewModel()
        if firstListModel?.count ?? 0 > 0 {
            headerModel.percent = CGFloat(firstListModel?.count ?? 0) / CGFloat((firstListModel?.count ?? 0) + (secondListModel?.count ?? 0))
        } else {
            headerModel.percent = 0
        }
        
        headerModel.title = "提交"
        headerModel.fristTitle = "已提交"
        headerModel.secondTitle = "未提交"
        tableHeaderView.model = headerModel
        
        yxs_checkEmptyData()
        tableView.reloadData()
        
    }
    
    // MARK: - Request
    @objc func yxs_reminderRequest() {
        var childrenIdList:[Int] = [Int]()
        for sub in secondListModel ?? [YXSClassMemberModel]() {
            childrenIdList.append(sub.childrenId ?? 0)
        }
        MBProgressHUD.yxs_showLoading()
        YXSEducationTeacherOneTouchReminderRequest(childrenIdList: childrenIdList, classId: classId , opFlag: 1, serviceId: serviceId, serviceType: serviceType, serviceCreateTime: createTime).request({ (json) in
            MBProgressHUD.yxs_showMessage(message: "通知成功")
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
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
    
    // MARK: - Action
    @objc func yxs_callUpClick(sender:YXSButton) {
        let currentModel: [YXSClassMemberModel]? = selectedListDataIndex == 0 ? secondListModel : firstListModel
        let model:YXSClassMemberModel = currentModel?[sender.tag] ?? YXSClassMemberModel(JSON: ["":""])!
        UIUtil.yxs_callPhoneNumberRequest(childrenId: model.childrenId ?? 0, classId: classId)
    }
    
    @objc func yxs_chatClick(sender:YXSButton) {
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            let currentModel: [YXSClassMemberModel]? = selectedListDataIndex == 0 ? secondListModel : firstListModel
            let model:YXSClassMemberModel = currentModel?[sender.tag] ?? YXSClassMemberModel(JSON: ["":""])!
            UIUtil.yxs_chatImRequest(childrenId: model.childrenId ?? 0, classId: classId)
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
            cell.btnChat.addTarget(self, action: #selector(yxs_chatClick(sender:)), for: .touchUpInside)
            cell.model = currentModel?[indexPath.row]
            return cell
            
//        } else {
//            let cell:YXSHomeworkReadListCell = tableView.dequeueReusableCell(withIdentifier: "YXSHomeworkReadListCell") as! YXSHomeworkReadListCell
//            cell.lbSub.isHidden = true
//            cell.imgRightArrow.isHidden = true
//            cell.model = currentModel?[indexPath.row]
//            return cell
//        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YXSHomeworkReadListSectionHeader") as? YXSHomeworkReadListSectionHeader
        sectionHeader?.btnTitle1.setTitle("未交（\(secondListModel?.count ?? 0)）", for: .normal)
        sectionHeader?.btnTitle2.setTitle("已交（\(firstListModel?.count ?? 0)）", for: .normal)
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER && selectedListDataIndex == 0 && secondListModel?.count ?? 0 > 0{
            sectionHeader?.btnAlert.isHidden = false
            
        } else {
            sectionHeader?.btnAlert.isHidden = true
        }
        
        sectionHeader?.selectedBlock = {[weak self](index) in
            guard let weakSelf = self else {return}
            weakSelf.selectedListDataIndex = index
            weakSelf.yxs_checkEmptyData()
            weakSelf.tableView.reloadData()
        }
        
        sectionHeader?.alertClick = {[weak self](sender) in
            guard let weakSelf = self else {return}
            weakSelf.yxs_reminderRequest()
        }
        return sectionHeader
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - LazyLoad
    lazy var tableHeaderView: HomeworkReadCommitListHeaderView = {
        let header = HomeworkReadCommitListHeaderView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 211))
        return header
    }()
    
    // MARK: - Other
    @objc func yxs_checkEmptyData() {
        let currentModel: [YXSClassMemberModel]? = selectedListDataIndex == 0 ? secondListModel : firstListModel
        tableView.tableFooterView = (currentModel?.count == 0 || currentModel == nil) ? tableFooterView : nil
    }
    
    lazy var tableFooterView: UIView = {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
        let imageView = UIImageView()
        imageView.mixedImage = MixedImage(normal: "yxs_defultImage_nodata", night: "yxs_defultImage_nodata_night")
        imageView.contentMode = .scaleAspectFit
        footer.addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        return footer
    }()
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
