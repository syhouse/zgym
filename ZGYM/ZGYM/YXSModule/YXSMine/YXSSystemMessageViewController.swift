//
//  SLSystemMessageViewController.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/20.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

class YXSSystemMessageViewController: YXSBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "系统通知"
        // Do any additional setup after loading the view.
        self.tableView.register(YXSSystemMessageTableViewCell.classForCoder(), forCellReuseIdentifier: "YXSSystemMessageTableViewCell")
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        headerView.backgroundColor = kTableViewBackgroundColor
        self.tableView.tableHeaderView = headerView
    }
    
    override func yxs_refreshData() {
        yxs_endingRefresh()
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:YXSSystemMessageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "YXSSystemMessageTableViewCell") as! YXSSystemMessageTableViewCell
        cell.lbTitle.text = "这里是消息这里是消息这里是消息这里是消息这里是消息这里是消息这里是消息这里是消息这里是消息这里是消息这里是消息这里是消息这里是消息这里是消息这里是消息这里是消息"
        
        cell.lbDate.text = Date.yxs_Time(interval: -180*1000)
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
