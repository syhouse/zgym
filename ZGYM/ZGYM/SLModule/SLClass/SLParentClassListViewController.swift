//
//  SLParentClassListViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/20.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper

class SLParentClassListViewController: SLBaseTableViewController {

    var dataSource: [SLClassModel] = [SLClassModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "班级列表"
        self.tableView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        self.tableView.register(SLParentClassListTableViewCell.classForCoder(), forCellReuseIdentifier: "SLParentClassListTableViewCell")
        
        let btnAdd = SLButton()
        btnAdd.setTitle("添加班级", for: .normal)
        btnAdd.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btnAdd.setMixedTitleColor(MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: kNight898F9A), forState: .normal)
        btnAdd.addTarget(self, action: #selector(addClassClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btnAdd)
        self.navigationItem.rightBarButtonItem = barButton
        
        
    }
    

    override func sl_refreshData() {
        loadData()
    }
    
    // MARK: - Request
    func loadData() {
        SLEducationGradeListRequest().request({ (json) in
            self.dataSource = Mapper<SLClassModel>().mapArray(JSONString: json["listJoin"].rawString()!) ?? [SLClassModel]()
            
            self.tableView.reloadData()
            self.sl_endingRefresh()
            
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
            self.sl_endingRefresh()
        }
    }
    
    // MARK: - Action
    @objc func addClassClick(sender: SLButton) {
        let vc = SLClassAddController()
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
        let cell:SLParentClassListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SLParentClassListTableViewCell") as! SLParentClassListTableViewCell
        
        let model = self.dataSource[indexPath.row]
        cell.lbTitle.text = model.name//"一年级3班"
        cell.lbClassNumber.text = "班级号：\(model.num!)"
        cell.lbStudentCount.text = "成员：\(model.members ?? 0)"
        cell.lbName.text = model.realName ?? "章小飞"
        cell.lbStudentNumber.text = "学号：\(model.studentId ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: SLClassModel = self.dataSource[indexPath.row]
        let vc = SLClassDetialListController.init(classModel: model)
        vc.navRightBarButtonTitle = "班级信息"
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
