//
//  SLHomeworkCommitListViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/26.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import JXCategoryView
import NightNight

class SLHomeworkCommitListViewController: SLBaseTableViewController, JXCategoryListContentViewDelegate {
    
    var sectionHeader: SLHomeworkReadListSectionHeader?
    var selectedListDataIndex: Int = 0
    var homeListModel: SLHomeListModel?
    
    override func viewDidLoad() {
        //是否一创建就刷新
        self.showBegainRefresh = false
        self.hasRefreshHeader = false
        
        super.viewDidLoad()
        self.title = "提交"
        // Do any additional setup after loading the view.
        self.tableView.register(SLHomeworkReadListSectionHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: "SLHomeworkReadListSectionHeader")
        self.tableView.register(SLHomeworkReadListCell.classForCoder(), forCellReuseIdentifier: "SLHomeworkReadListCell")
        self.tableView.register(SLHomeworkCommitListCell.classForCoder(), forCellReuseIdentifier: "SLHomeworkCommitListCell")
        self.tableView.tableHeaderView = tableHeaderView
        //        checkEmptyData()
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
        
        headerModel.title = "提交"
        headerModel.fristTitle = "已提交"
        headerModel.secondTitle = "未提交"
        tableHeaderView.model = headerModel
        tableView.reloadData()
        sl_checkEmptyData()
    }
    
    // MARK: - Request
    @objc func sl_reminderRequest() {
        var childrenIdList:[Int] = [Int]()
        for sub in secondListModel ?? [SLClassMemberModel]() {
            childrenIdList.append(sub.childrenId ?? 0)
        }
        MBProgressHUD.sl_showLoading()
        SLEducationTeacherOneTouchReminderRequest(childrenIdList: childrenIdList, classId: homeListModel?.classId ?? 0, opFlag: 1, serviceId: homeListModel?.serviceId ?? 0, serviceType: 1, serviceCreateTime: homeListModel?.createTime ?? "").request({ (json) in
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
            var uncommeList:[SLClassMemberModel] = [SLClassMemberModel]()
            for sub in firstListModel ?? [SLClassMemberModel]() {
                if sub.isRemark == false {
                    uncommeList.append(sub)
                }
                sub.teacherId = homeListModel?.teacherId
            }
            self.uncommeListModel = uncommeList
        }
    }
    
    
    var uncommeListModel: [SLClassMemberModel]? {
        didSet {
        }
    }
    
    // MARK: - Action
    @objc func sl_callUpClick(sender:SLButton) {
        let model:SLClassMemberModel = secondListModel?[sender.tag] ?? SLClassMemberModel(JSON: ["":""])!
        UIUtil.sl_callPhoneNumberRequest(childrenId: model.childrenId ?? 0, classId: homeListModel?.classId ?? 0)
    }
    
    @objc func sl_chatClick(sender:SLButton) {
        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
            let model:SLClassMemberModel = secondListModel?[sender.tag] ?? SLClassMemberModel(JSON: ["":""])!
            UIUtil.sl_chatImRequest(childrenId: model.childrenId ?? 0, classId: homeListModel?.classId ?? 0)
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
        
        if selectedListDataIndex == 0 {
            let cell:SLHomeworkCommitListCell = tableView.dequeueReusableCell(withIdentifier: "SLHomeworkCommitListCell") as! SLHomeworkCommitListCell
            cell.btnChat.tag = indexPath.row
            cell.btnPhone.tag = indexPath.row
            cell.btnPhone.addTarget(self, action: #selector(sl_callUpClick(sender:)), for: .touchUpInside)
            cell.btnChat.addTarget(self, action: #selector(sl_chatClick(sender:)), for: .touchUpInside)
            cell.model = currentModel?[indexPath.row]
            return cell
            
        } else {
            let cell:SLHomeworkReadListCell = tableView.dequeueReusableCell(withIdentifier: "SLHomeworkReadListCell") as! SLHomeworkReadListCell
            cell.model = currentModel?[indexPath.row]
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if homeListModel?.teacherId == self.sl_user.id {
            if selectedListDataIndex != 0 {
               return 120
            } else {
                return 64
            }

        }else {
            return 64
        }
//        return 60
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SLHomeworkReadListSectionHeader") as? SLHomeworkReadListSectionHeader
        sectionHeader?.btnTitle1.setTitle("未交（\(secondListModel?.count ?? 0)）", for: .normal)
        sectionHeader?.btnTitle2.setTitle("已交（\(firstListModel?.count ?? 0)）", for: .normal)
        
        if SLPersonDataModel.sharePerson.personRole == .TEACHER && selectedListDataIndex == 0 && secondListModel?.count ?? 0 > 0 {
            sectionHeader?.btnAlert.isHidden = false
            sectionHeader?.unCommentView.isHidden = true
        } else {
            sectionHeader?.btnAlert.isHidden = true
            if homeListModel?.teacherId != self.sl_user.id {
                sectionHeader?.unCommentView.isHidden = true
                sectionHeader?.hiddenComment(isHidden: true)
            }else {
                sectionHeader?.unCommentView.isHidden = false
                sectionHeader?.lbComment.text = "未点评（\(self.uncommeListModel?.count ?? 0)）"
                sectionHeader?.hiddenComment(isHidden: false)
                if self.uncommeListModel?.count == 0 {
                    sectionHeader?.btnComment.isHidden = true
                }
            }
        }
        
        sectionHeader?.selectedBlock = {[weak self](index) in
            guard let weakSelf = self else {return}
            weakSelf.selectedListDataIndex = index
            weakSelf.tableView.reloadData()
            weakSelf.sl_checkEmptyData()
        }
        
        sectionHeader?.alertClick = {[weak self](sender) in
            guard let weakSelf = self else {return}
            weakSelf.sl_reminderRequest()
        }
        
        //批量点评
        sectionHeader?.commentClick = {[weak self](sender) in
            guard let weakSelf = self else {return}
            let vc = SLHomeworkBatchRemarkController()
            vc.homeModel = weakSelf.homeListModel
            vc.uncommeListModel = weakSelf.uncommeListModel
            weakSelf.navigationController?.pushViewController(vc)
        }
        
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedListDataIndex == 0 {
            ///打电话、私信
            
        } else {
            let cell:SLHomeworkReadListCell = tableView.cellForRow(at: indexPath) as! SLHomeworkReadListCell
            
            let vc = SLHomeworkCommitDetailViewController()
            homeListModel?.childrenId = cell.model?.childrenId
            vc.homeModel = self.homeListModel//model
            self.navigationController?.pushViewController(vc)
        }
    }
    
    // MARK: - LazyLoad
    lazy var tableHeaderView: HomeworkReadCommitListHeaderView = {
        let header = HomeworkReadCommitListHeaderView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 211))
        return header
    }()
    
    // MARK: - Other
    @objc func sl_checkEmptyData() {
        let currentModel: [SLClassMemberModel]? = selectedListDataIndex == 0 ? secondListModel : firstListModel
        //
        //        if currentModel?.count == 0 || currentModel == nil{
        //
        //            let footer = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
        //            let imageView = UIImageView.init(image: UIImage.init(named: "sl_defultImage_nodata"))
        //            imageView.contentMode = .scaleAspectFit
        //            footer.addSubview(imageView)
        //            imageView.snp.makeConstraints({ (make) in
        //                make.edges.equalTo(0)
        //            })
        //
        //            tableView.tableFooterView = footer
        
        
        tableView.tableFooterView = (currentModel?.count == 0 || currentModel == nil) ? tableFooterView : nil
        
        //
        //        } else {
        //            tableView.tableFooterView = nil
        //        }
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
    
    //    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
    //        return true
    //    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
