//
//  YXSFileClassListViewController.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/22.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit

/// 班级列表（当用户有多个班级时候呈现）
class YXSFileClassListViewController: YXSBaseTableViewController {

    var dataSource: [YXSClassModel] = [YXSClassModel]()
    
    init(dataSource:[YXSClassModel]) {
        super.init()
        self.dataSource = dataSource
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        // 是否有下拉刷新
        hasRefreshHeader = false
        //是否一创建就刷新
        showBegainRefresh = false
        
        super.viewDidLoad()
        title = "班级列表"
        
        // Do any additional setup after loading the view.
        tableView.register(YXSFileClassListCell.classForCoder(), forCellReuseIdentifier: "YXSFileClassListCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSFileClassListCell") as! YXSFileClassListCell
        cell.selectionStyle = .none
        cell.model = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let classModel = dataSource[indexPath.row]
        let vc = YXSClassFileViewController(classId: classModel.id ?? 0, parentFolderId: -1)
        navigationController?.pushViewController(vc)
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
