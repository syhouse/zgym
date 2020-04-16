//
//  YXSMyCollectVC.swift
//  
//
//  Created by yihao on 2020/4/14.
//

import Foundation
import NightNight

class YXSMyCollectVC: YXSBaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
    }
    
    override func yxs_refreshData() {
        yxs_endingRefresh()
    }
    
    // MARK: - UITableViewDataSource，UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        cell.textLabel?.text = "宝宝听"
//        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.yxs_addLine(position: LinePosition.top, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
        }
        cell.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = YXSMyCollectDetailsVC()
        self.navigationController?.pushViewController(vc)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "取消收藏"
    }
    
}
