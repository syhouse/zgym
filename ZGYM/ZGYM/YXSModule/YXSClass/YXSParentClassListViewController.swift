//
//  YXSParentClassListViewController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/20.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper

class YXSParentClassListViewController: YXSBaseTableViewController {

    var dataSource: [YXSClassModel] = [YXSClassModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "班级列表"
        self.tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        self.tableView.register(YXSParentClassListTableViewCell.classForCoder(), forCellReuseIdentifier: "YXSParentClassListTableViewCell")
        
        let btnAdd = YXSButton()
        btnAdd.setTitle("添加班级", for: .normal)
        btnAdd.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btnAdd.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNight898F9A), forState: .normal)
        btnAdd.addTarget(self, action: #selector(addClassClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btnAdd)
        self.navigationItem.rightBarButtonItem = barButton
        
        
    }
    

    override func yxs_refreshData() {
        loadData()
    }
    
    // MARK: - Request
    func loadData() {
        YXSEducationGradeListRequest().request({ (json) in
            self.dataSource = Mapper<YXSClassModel>().mapArray(JSONString: json["listJoin"].rawString()!) ?? [YXSClassModel]()
            
            self.tableView.reloadData()
            self.yxs_endingRefresh()
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
            self.yxs_endingRefresh()
        }
    }
    
    // MARK: - Action
    @objc func addClassClick(sender: YXSButton) {
        let vc = YXSClassAddController()
        self.navigationController?.pushViewController(vc)
    }
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 114
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:YXSParentClassListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "YXSParentClassListTableViewCell") as! YXSParentClassListTableViewCell
        
        let model = self.dataSource[indexPath.row]
        cell.lbTitle.text = model.name//"一年级3班"
        cell.lbClassNumber.text = "班级号：\(model.num!)"
        cell.lbStudentCount.text = "成员：\(model.members ?? 0)"
        cell.lbName.text = model.realName ?? "章小飞"
        cell.lbStudentNumber.text = "学号：\(model.studentId ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: YXSClassModel = self.dataSource[indexPath.row]
//        let vc = YXSClassDetialListController.init(classModel: model)
//        vc.navRightBarButtonTitle = "班级信息"
//        navigationController?.pushViewController(vc)
        
        let vc = YXSClassInfoViewController.init(classModel: model)
        self.navigationController?.pushViewController(vc)
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
