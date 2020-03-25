//
//  SLClassStartClassListController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/3.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//
import UIKit
import NightNight

import MBProgressHUD

class SLClassStartClassListController: SLBaseTableViewController {
    var dataSource: [SLClassStartClassModel] = [SLClassStartClassModel]()
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
        self.title = "选择班级"
        
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        tableView.register(SLClassStartClassListCell.self, forCellReuseIdentifier: "SLClassStartClassListCell")
        tableView.rowHeight = 84
        
        sl_loadData()
    }
    
    func sl_loadData() {
        SLEducationGradeListRequest().requestCollection({ (classs:[SLClassStartClassModel]) in
            self.dataSource = classs
            self.tableView.reloadData()
        }) { (msg, code) in
            self.view.makeToast("\(msg)")
        }
    }
    
    // MARK: -UI
    
    // MARK: -action
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SLClassStartClassListCell") as! SLClassStartClassListCell
        cell.selectionStyle = .none
        cell.sl_setCellModel(dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    // MARK: - getter&setter
}

