//
//  SLFriendCircleListController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/17.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//
import UIKit
import NightNight

class SLFriendCircleListController: SLBaseTableViewController {
    var loadSucess: (() -> ())?
    var dataSource = [SLFriendsMessageModel]()
    override init() {
        super.init()
        showBegainRefresh = false
        hasRefreshHeader = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "消息"
        
        view.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        tableView.rowHeight = 69.5
        tableView.register(SLFriendCircleMessageListCell.self, forCellReuseIdentifier: "SLFriendCircleMessageListCell")
        tableView.snp.updateConstraints { (make) in
            make.top.equalTo(10)
        }
        loadData()
    }
    
    // MARK: -UI
    // MARK: -loadData
    override func sl_refreshData() {
        self.curruntPage = 1
        loadData()
    }
    
    func loadData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SLEducationClassCircleMessageListRequest().requestCollection({ (list: [SLFriendsMessageModel]) in
            MBProgressHUD.hide(for: self.view, animated: true)
//            self.endingRefresh()
            self.dataSource = list
            self.tableView.reloadData()
            SLPersonDataModel.sharePerson.friendsTips = nil
            self.sl_showBadgeOnItem(index: 1, count: 0)
            self.loadSucess?()
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: true)
//            self.endingRefresh()
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: -action
    @objc func rightClick(){
        
        
    }
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SLFriendCircleMessageListCell") as! SLFriendCircleMessageListCell
        cell.setCellModel(dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        let vc = SLFriendsCircleController.init(isDetial: true, classCircleId: model.classCircleId)
        navigationController?.pushViewController(vc)
    }
    
    
    // MARK: - getter&setter
}


