//
//  SLTransferClassViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/22.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLTransferClassViewController: SLBaseTableViewController {

    var gradeId: Int?
    var dataSource: [SLTransferItemModel] = [SLTransferItemModel]()
    var currentItem: SLTransferItemModel?
    let btnTransfer = SLButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "班级转让"
        // Do any additional setup after loading the view.
        
        self.tableView.register(SLTransferClassTableViewCell.classForCoder(), forCellReuseIdentifier: "SLTransferClassTableViewCell")
        
        btnTransfer.isHidden = true
        btnTransfer.setTitle("转让", for: .normal)
        btnTransfer.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btnTransfer.setTitleColor(UIColor.sl_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        btnTransfer.addTarget(self, action: #selector(transferClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btnTransfer)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    // MARK: - Request
    override func sl_refreshData() {
        SLEducationGradeOptionalTeacherListRequest(gradeId: self.gradeId ?? 0).requestCollection({[weak self] (list:[SLTransferItemModel]) in
            guard let weakSelf = self else {return}
            weakSelf.sl_endingRefresh()
            weakSelf.dataSource = list
            weakSelf.btnTransfer.isHidden = list.count > 0 ? false : true
            weakSelf.tableView.reloadData()
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            weakSelf.sl_endingRefresh()
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: - Action
    @objc func transferClick(sender: SLButton) {
        if currentItem == nil {
            MBProgressHUD.sl_showMessage(message: "请选择一个老师")
            return
        }
        
        let vc = SLPhoneAuthenticationViewController(smsType: .OPERATION_GRADE) { [weak self](phone, authCode, sender, vc) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_showLoading()
            SLEducationGradeTransferRequest(gradeId: weakSelf.gradeId ?? 0, teacherId: weakSelf.currentItem?.id ?? 0, smsCode: String(authCode)).request({ (json) in
                MBProgressHUD.sl_hideHUD()
                MBProgressHUD.sl_showMessage(message: "转让班级成功", afterDelay: 1.2)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.2) {
                    weakSelf.popBackToClassDetail()
                }
                
            }) { (msg, code) in
                MBProgressHUD.sl_showMessage(message: msg)
            }
        }
        vc.btnDone.setTitle("确认转让班级", for: .normal)
        vc.tfAccount.text = self.sl_user.account
        vc.tfAccount.isEnabled = false
        self.navigationController?.pushViewController(vc)
    }

    /// 推回班级详情
    func popBackToClassDetail() {
        self.navigationController?.sl_existViewController(existClass: SLTeacherClassListViewController(), complete: { (isExist, resultVC) in
            if isExist {
                resultVC.sl_refreshData()
            }
        })
        
        self.navigationController?.sl_existViewController(existClass: SLClassDetialListController(classModel: SLClassModel.init(JSON: ["":""])!), complete: { (isExist, resultVC) in
            if isExist {
                resultVC.navRightBarButtonTitle = "班级信息"
                self.navigationController?.popToViewController(resultVC, animated: true)
            }
        })
    }
    
//    /// 推回班级列表
//    func popBackToClassList() {
//        for sub in self.navigationController?.viewControllers ?? [UIViewController](){
//            if sub is SLParentClassListViewController {
//                let listVC: SLParentClassListViewController = sub as! SLParentClassListViewController
//                listVC.refreshData()
//                self.navigationController?.popToViewController(listVC, animated: true)
//                
//            } else if sub is SLTeacherClassListViewController {
//                let listVC: SLTeacherClassListViewController = sub as! SLTeacherClassListViewController
//                listVC.refreshData()
//                self.navigationController?.popToViewController(listVC, animated: true)
//            }
//        }
//    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model =  self.dataSource[indexPath.row]
        
        let cell: SLTransferClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SLTransferClassTableViewCell") as! SLTransferClassTableViewCell
        cell.model = model
//        cell.lbTitle.text = model.name ?? "老师A"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header:UIView = UIView()
        header.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for item in self.dataSource {
            item.isSelected = false
        }
        
        let selectedModel = self.dataSource[indexPath.row]
        selectedModel.isSelected = true
        self.currentItem = selectedModel
        tableView.reloadData()
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
