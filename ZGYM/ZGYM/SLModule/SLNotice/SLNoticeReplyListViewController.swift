//
//  SLNoticeReplyListViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/2.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import JXCategoryView
import NightNight

class SLNoticeReplyListViewController: SLBaseTableViewController, JXCategoryListContentViewDelegate {
    
    var sectionHeader: SLHomeworkReadListSectionHeader?
    var selectedListDataIndex: Int = 0
    var SLHomeListModel: SLHomeListModel?
    
    override func viewDidLoad() {
        //是否一创建就刷新
        self.showBegainRefresh = false
        self.hasRefreshHeader = false
        
        super.viewDidLoad()
//        self.title = "提交"
        // Do any additional setup after loading the view.
        self.tableView.register(SLHomeworkReadListSectionHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: "SLHomeworkReadListSectionHeader")
        self.tableView.register(SLHomeworkReadListCell.classForCoder(), forCellReuseIdentifier: "SLHomeworkReadListCell")
        self.tableView.register(SLHomeworkCommitListCell.classForCoder(), forCellReuseIdentifier: "SLHomeworkCommitListCell")
        self.tableView.tableHeaderView = tableHeaderView
    }
    
    func listView() -> UIView! {
        return self.view
    }
    
    
    override func sl_refreshData() {
        let headerModel = HomeworkReadCommitListHeaderViewModel()
        if firstListModel?.count ?? 0 > 0 {
            headerModel.percent = CGFloat(firstListModel?.count ?? 0) / CGFloat((firstListModel?.count ?? 0) + (secondListModel?.count ?? 0))
        } else {
            headerModel.percent = 0
        }
        
        headerModel.title = "回执"
        headerModel.fristTitle = "已回执"
        headerModel.secondTitle = "未回执"
        tableHeaderView.model = headerModel
        
        sl_checkEmptyData()
        tableView.reloadData()
        
    }
    
    // MARK: - Request
    @objc func sl_reminderRequest() {
        var childrenIdList:[Int] = [Int]()
        for sub in secondListModel ?? [SLClassMemberModel]() {
            childrenIdList.append(sub.childrenId ?? 0)
        }
        MBProgressHUD.sl_showLoading()
        SLEducationTeacherOneTouchReminderRequest(childrenIdList: childrenIdList, classId: SLHomeListModel?.classId ?? 0, opFlag: 1, serviceId: SLHomeListModel?.serviceId ?? 0, serviceType: 0, serviceCreateTime: SLHomeListModel?.createTime ?? "").request({ (json) in
            MBProgressHUD.sl_showMessage(message: "通知成功")
            
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: - Setter
    var firstListModel: [SLClassMemberModel]? {
        didSet {
        }
    }
    
    var secondListModel: [SLClassMemberModel]? {
        didSet {
        }
    }
    
    // MARK: - Action
    @objc func sl_callUpClick(sender:SLButton) {
        let currentModel: [SLClassMemberModel]? = selectedListDataIndex == 0 ? secondListModel : firstListModel
        let model:SLClassMemberModel = currentModel?[sender.tag] ?? SLClassMemberModel(JSON: ["":""])!
        UIUtil.sl_callPhoneNumberRequest(childrenId: model.childrenId ?? 0, classId: SLHomeListModel?.classId ?? 0)
    }
    
    @objc func sl_chatClick(sender:SLButton) {
        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
            let currentModel: [SLClassMemberModel]? = selectedListDataIndex == 0 ? secondListModel : firstListModel
            let model:SLClassMemberModel = currentModel?[sender.tag] ?? SLClassMemberModel(JSON: ["":""])!
            UIUtil.sl_chatImRequest(childrenId: model.childrenId ?? 0, classId: SLHomeListModel?.classId ?? 0)
        }
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentModel: [SLClassMemberModel]? = selectedListDataIndex == 0 ? secondListModel : firstListModel
        return currentModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentModel: [SLClassMemberModel]? = selectedListDataIndex == 0 ? secondListModel : firstListModel
        
//        if selectedListDataIndex == 0 {
            let cell:SLHomeworkCommitListCell = tableView.dequeueReusableCell(withIdentifier: "SLHomeworkCommitListCell") as! SLHomeworkCommitListCell
            cell.btnChat.tag = indexPath.row
            cell.btnPhone.tag = indexPath.row
            cell.btnPhone.addTarget(self, action: #selector(sl_callUpClick(sender:)), for: .touchUpInside)
            cell.btnChat.addTarget(self, action: #selector(sl_chatClick(sender:)), for: .touchUpInside)
            cell.model = currentModel?[indexPath.row]
            return cell
            
//        } else {
//            let cell:SLHomeworkReadListCell = tableView.dequeueReusableCell(withIdentifier: "SLHomeworkReadListCell") as! SLHomeworkReadListCell
//            cell.lbSub.isHidden = true
//            cell.imgRightArrow.isHidden = true
//            cell.model = currentModel?[indexPath.row]
//            return cell
//        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SLHomeworkReadListSectionHeader") as? SLHomeworkReadListSectionHeader
        sectionHeader?.btnTitle1.setTitle("未回执（\(secondListModel?.count ?? 0)）", for: .normal)
        sectionHeader?.btnTitle2.setTitle("已回执（\(firstListModel?.count ?? 0)）", for: .normal)
        if SLPersonDataModel.sharePerson.personRole == .TEACHER && selectedListDataIndex == 0 && secondListModel?.count ?? 0 > 0{
            sectionHeader?.btnAlert.isHidden = false
            
        } else {
            sectionHeader?.btnAlert.isHidden = true
        }
        
        sectionHeader?.selectedBlock = {[weak self](index) in
            guard let weakSelf = self else {return}
            weakSelf.selectedListDataIndex = index
            weakSelf.sl_checkEmptyData()
            weakSelf.tableView.reloadData()
        }
        
        sectionHeader?.alertClick = {[weak self](sender) in
            guard let weakSelf = self else {return}
            weakSelf.sl_reminderRequest()
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
    @objc func sl_checkEmptyData() {
        let currentModel: [SLClassMemberModel]? = selectedListDataIndex == 0 ? secondListModel : firstListModel
        tableView.tableFooterView = (currentModel?.count == 0 || currentModel == nil) ? tableFooterView : nil
    }
    
    lazy var tableFooterView: UIView = {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
        let imageView = UIImageView()
        imageView.mixedImage = MixedImage(normal: "sl_defultImage_nodata", night: "sl_defultImage_nodata_night")
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
