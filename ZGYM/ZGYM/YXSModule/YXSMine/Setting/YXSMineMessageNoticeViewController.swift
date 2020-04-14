//
//  YXSMineMessageNoticeViewController.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/10.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

class YXSMineMessageNoticeViewController: YXSBaseTableViewController {

    override func viewDidLoad() {
        self.hasRefreshHeader = false
        self.showBegainRefresh = false
        super.viewDidLoad()
        self.title = "新消息通知"
        // Do any additional setup after loading the view.
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        headerView.backgroundColor = kTableViewBackgroundColor
        self.tableView.tableHeaderView = headerView
        self.tableView.register(YXSClassManageSwitchTableViewCell.classForCoder(), forCellReuseIdentifier: "YXSClassManageSwitchTableViewCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: YXSClassManageSwitchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "YXSClassManageSwitchTableViewCell") as! YXSClassManageSwitchTableViewCell
        cell.contentView.yxs_addLine(position: .bottom, color: kLineColor, leftMargin: 15, rightMargin: 0, lineHeight: 0.5)
        cell.lbTitle.text = indexPath.row == 0 ? "新消息声音提醒":"新消息振动提醒"
//        cell.swtJoinClass.addTarget(self, action: #selector(switchChanged(sender:)), for: .valueChanged)
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
