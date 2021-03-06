//
//  YXSAgendaListController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/21.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

private var images = [kPunchCardKey,kSolitaireKey,kNoticeKey]
private var titles = ["打卡任务","接龙","通知"]
private var serviceIds = [2,3,0]
private var events = [YXSHomeType.punchCard,YXSHomeType.solitaire,YXSHomeType.notice]
class YXSAgendaListController: YXSBaseTableViewController {
    // MARK: - property
    var yxs_dataSource: [YXSAgendaListModel] = [YXSAgendaListModel]()
    
    // MARK: - init
    override init() {
        super.init()
        showBegainRefresh = false
        hasRefreshHeader = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER && YXSPersonDataModel.sharePerson.personStage == .KINDERGARTEN{
            images = [kPunchCardKey,kSolitaireKey,kNoticeKey]
            titles = ["打卡任务","接龙","通知"]
            serviceIds = [2,3,0]
            events = [YXSHomeType.punchCard,YXSHomeType.solitaire,YXSHomeType.notice]
        }else{
            images = [kPunchCardKey,kHomeworkKey,kSolitaireKey,kNoticeKey]
            titles = ["打卡任务","作业","接龙","通知"]
            serviceIds = [2,1,3,0]
            events = [YXSHomeType.punchCard,.homework,YXSHomeType.solitaire,YXSHomeType.notice]
        }
        
        
        title = "待办事项"
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        tableView.register(YXSAgendaListCell.self, forCellReuseIdentifier: "YXSAgendaListCell")
        tableView.rowHeight = 87
        
        yxs_loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_updateAgenda), name: NSNotification.Name.init(rawValue: kHomeAgendaReducNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: -loadData
    override func yxs_refreshData() {
        self.currentPage = 1
        yxs_loadData()
    }
    
    func yxs_loadData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var request: YXSBaseRequset!
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            request = YXSEducationTodoTeacherRedPointGroupRequest()
        }else{
            request = YXSEducationTodoChildrenRedPointGroupRequest.init(childrenClassList: yxs_childrenClassList)
        }
        
        request.requestCollection({ (list:[AgendaRedModel]) in
            MBProgressHUD.hide(for: self.view, animated: false)
            //            0:通知,1:作业,2:打卡,3:接龙,4:成绩,5:班级圈
            for index in 0..<images.count{
                let model = YXSAgendaListModel()
                model.image = images[index]
                model.title = titles[index]
                model.eventType = events[index]
                for redModel in list{
                    if serviceIds[index] == redModel.serviceType{
                        model.count = redModel.count ?? 0
                        break
                    }
                }
                self.yxs_dataSource.append(model)
            }
            self.tableView.reloadData()
            
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: false)
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
    }
    
    // MARK: -action
    
    
    // MARK: - private
    func reloadTableView(_ indexPath: IndexPath){
        //        none
        UIView.performWithoutAnimation {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    ///通知更新待办
    @objc func yxs_updateAgenda(_ notification:Notification){
        let userInfo = notification.object as? [String: Any]
        if let userInfo = userInfo{
            if let type =  userInfo[kEventKey] as? YXSHomeType{
                for model in yxs_dataSource{
                    if model.eventType == type{
                        model.count -= 1
                        break
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yxs_dataSource.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = yxs_dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSAgendaListCell") as! YXSAgendaListCell
        cell.yxs_setCellModel(model)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listModel = yxs_dataSource[indexPath.row]
//        ///老师身份展示所有数量
//        if YXSPersonDataModel.sharePerson.personRole != .TEACHER && listModel.eventType == .punchCard {
//            if listModel.allCount == 0{
//                
//            }
//            
//            ///家长身份展示今日待办数量
//        }else if listModel.count == 0{
//            return
//        }
        switch listModel.eventType {
        case .homework:
            let vc = YXSHomeworkListController.init(isAgenda: true)
            navigationController?.pushViewController(vc)
            break
        case .notice:
            let vc = YXSNoticeListController.init(isAgenda: true)
            navigationController?.pushViewController(vc)
            break
        case .solitaire:
            let vc = YXSSolitaireListController.init(isAgenda: true)
            navigationController?.pushViewController(vc)
            break
        case .punchCard:
            let vc = YXSPunchCardListController.init(isAgenda: true)
            navigationController?.pushViewController(vc)
            break
        default:
            break
        }
    }
}

