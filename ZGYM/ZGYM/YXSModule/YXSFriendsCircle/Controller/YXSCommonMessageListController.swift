//
//  SLFriendCircleListController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/17.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//
import UIKit
import NightNight

enum YXSFriendMessageListType {
    case friends
    case punchCard  //打卡
    case homeWork   //作业
}

class YXSCommonMessageListController: YXSBaseTableViewController {
    var loadSucess: (() -> ())?
    var dataSource = [YXSFriendsMessageModel]()
    var punchCardSource = [YXSPunchCardMessageModel]()
    var homeworkSource = [YXSHomeworkMessageModel]()
    let type:YXSFriendMessageListType

    /// 默认朋友圈消息详情
    init(type: YXSFriendMessageListType = .friends) {
        self.type = type
        super.init()
        showBegainRefresh = false
        hasRefreshHeader = false
    }
    
    var hmModel: YXSHomeListModel?
    var deModel: YXSHomeworkDetailModel?
    /// 作业消息详情
    /// - Parameters:
    ///   - hmModel: 老师发布的作业list模型
    ///   - deModel: 老师发布的作业详情模型
    convenience init(hmModel: YXSHomeListModel, deModel: YXSHomeworkDetailModel) {
        self.init(type: .homeWork)
        self.hmModel = hmModel
        self.deModel = deModel
    }
    
    var clockId: Int?
    var classId: Int?
    var childId: Int?
    var topHistoryModel: YXSClassStarTopHistoryModel?
    var isMyPublish: Bool = false
    /// 打卡消息详情
    /// - Parameters:
    ///   - clockId: 打卡id
    convenience init(clockId: Int,childId: Int, classId: Int,isMyPublish: Bool, topHistoryModel: YXSClassStarTopHistoryModel?) {
        self.init(type: .punchCard)
        self.clockId = clockId
        self.classId = classId
        self.childId = childId
        self.isMyPublish = isMyPublish
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "消息"
        
        view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        tableView.rowHeight = 69.5
        tableView.register(YXSFriendCircleMessageListCell.self, forCellReuseIdentifier: "YXSFriendCircleMessageListCell")
        tableView.snp.updateConstraints { (make) in
            make.top.equalTo(10)
        }
        loadData()
    }
    
    // MARK: -UI
    // MARK: -loadData
    override func yxs_refreshData() {
        self.currentPage = 1
        loadData()
    }
    
    func loadData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        switch type {
        case .punchCard:
            YXSEducationClockInUnreadNoticeListRequest(clockInId: clockId ?? 0).requestCollection({ (list: [YXSPunchCardMessageModel]) in
                MBProgressHUD.hide(for: self.view, animated: true)
                self.punchCardSource = list
                self.tableView.reloadData()
                self.navigationController?.yxs_existViewController(existClass: YXSPunchCardDetialController.self, complete: { (vc) in
                    vc.messageModel = nil
                })
                YXSPersonDataModel.sharePerson.friendsTips = nil
                self.loadSucess?()
            }) { (msg, code) in
                MBProgressHUD.hide(for: self.view, animated: true)
                //            self.endingRefresh()
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        case .friends:
            YXSEducationClassCircleMessageListRequest().requestCollection({ (list: [YXSFriendsMessageModel]) in
                MBProgressHUD.hide(for: self.view, animated: true)
                self.dataSource = list
                self.tableView.reloadData()
                YXSPersonDataModel.sharePerson.friendsTips = nil
//                self.yxs_showBadgeOnItem(index: 1, count: 0)
                self.loadSucess?()
            }) { (msg, code) in
                MBProgressHUD.hide(for: self.view, animated: true)
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        case .homeWork:
            YXSEducationHomeworkMessageRequest(homeworkId: hmModel?.serviceId ?? 0).requestCollection({ (list: [YXSHomeworkMessageModel]) in
                MBProgressHUD.hide(for: self.view, animated: true)
                self.homeworkSource = list
                self.tableView.reloadData()
                self.navigationController?.yxs_existViewController(existClass: YXSHomeworkDetailViewController.self, complete: { (vc) in
                    vc.model?.messageCount = 0
                    vc.model?.messageAvatar = ""
                    vc.model?.messageUserType = ""
                })
                YXSPersonDataModel.sharePerson.friendsTips = nil
                self.loadSucess?()
            }) { (msg, code) in
                MBProgressHUD.hide(for: self.view, animated: true)
                //            self.endingRefresh()
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        
    }
    
    // MARK: -action
    @objc func rightClick(){
        
        
    }
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case .punchCard:
            return punchCardSource.count
        case .friends:
            return dataSource.count
        case .homeWork:
            return homeworkSource.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSFriendCircleMessageListCell") as! YXSFriendCircleMessageListCell
        
        switch type {
        case .punchCard:
            cell.setCellModel(punchCardSource[indexPath.row])
        case .friends:
            cell.setCellModel(dataSource[indexPath.row])
        case .homeWork:
            cell.setCellModel(homeworkSource[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var vc: UIViewController!
        switch type {
        case .punchCard:
            let model = punchCardSource[indexPath.row]
            vc = YXSPunchCardSingleStudentBaseListController.init(clockInId: clockId ?? 0, clockInCommitId: model.clockInCommitId ?? 0, isMyPublish: isMyPublish, classId: classId ?? 0, topHistoryModel: topHistoryModel, operationChildrenId: childId ?? (self.yxs_user.currentChild?.id ?? 0))
        case .friends:
            let model = dataSource[indexPath.row]
            vc = YXSFriendsCircleController.init(classCircleId: model.classCircleId)
        case .homeWork:
            let model = homeworkSource[indexPath.row]
            vc = YXSHomeworkMessageVC.init(deModel: self.deModel!, model: self.hmModel!, messageModel: model)
        }
        navigationController?.pushViewController(vc)
    }
    
    
    // MARK: - getter&setter
}


