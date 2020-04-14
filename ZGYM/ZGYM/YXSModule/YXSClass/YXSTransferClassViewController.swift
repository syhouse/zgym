//
//  YXSTransferClassViewController.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/22.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSTransferClassViewController: YXSBaseTableViewController {

    var gradeId: Int?
    var dataSource: [YXSTransferItemModel] = [YXSTransferItemModel]()
    var currentItem: YXSTransferItemModel?
    let btnTransfer = YXSButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "班级转让"
        // Do any additional setup after loading the view.
        
        self.tableView.register(YXSTransferClassTableViewCell.classForCoder(), forCellReuseIdentifier: "YXSTransferClassTableViewCell")
        
        btnTransfer.isHidden = true
        btnTransfer.setTitle("转让", for: .normal)
        btnTransfer.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btnTransfer.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        btnTransfer.addTarget(self, action: #selector(transferClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btnTransfer)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    // MARK: - Request
    override func yxs_refreshData() {
        YXSEducationGradeOptionalTeacherListRequest(gradeId: self.gradeId ?? 0).requestCollection({[weak self] (list:[YXSTransferItemModel]) in
            guard let weakSelf = self else {return}
            weakSelf.yxs_endingRefresh()
            weakSelf.dataSource = list
            weakSelf.btnTransfer.isHidden = list.count > 0 ? false : true
            weakSelf.tableView.reloadData()
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            weakSelf.yxs_endingRefresh()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Action
    @objc func transferClick(sender: YXSButton) {
        if currentItem == nil {
            MBProgressHUD.yxs_showMessage(message: "请选择一个老师")
            return
        }
        
        let vc = YXSPhoneAuthenticationViewController(smsType: .OPERATION_GRADE) { [weak self](phone, authCode, sender, vc) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_showLoading()
            YXSEducationGradeTransferRequest(gradeId: weakSelf.gradeId ?? 0, teacherId: weakSelf.currentItem?.id ?? 0, smsCode: String(authCode)).request({ (json) in
                MBProgressHUD.yxs_hideHUD()
                MBProgressHUD.yxs_showMessage(message: "转让班级成功", afterDelay: 1.2)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.2) {
                    weakSelf.popBackToClassDetail()
                }
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        vc.btnDone.setTitle("确认转让班级", for: .normal)
        vc.tfAccount.text = self.yxs_user.account
        vc.tfAccount.isEnabled = false
        self.navigationController?.pushViewController(vc)
    }

    /// 推回班级详情
    func popBackToClassDetail() {
        self.navigationController?.yxs_existViewController(existClass: YXSTeacherClassListViewController(), complete: { (isExist, resultVC) in
            if isExist {
                resultVC.yxs_refreshData()
            }
        })
        
        self.navigationController?.yxs_existViewController(existClass: YXSClassDetialListController(classModel: SLClassModel.init(JSON: ["":""])!), complete: { (isExist, resultVC) in
            if isExist {
                resultVC.navRightBarButtonTitle = "班级信息"
                self.navigationController?.popToViewController(resultVC, animated: true)
            }
        })
    }
    
//    /// 推回班级列表
//    func popBackToClassList() {
//        for sub in self.navigationController?.viewControllers ?? [UIViewController](){
//            if sub is YXSParentClassListViewController {
//                let listVC: YXSParentClassListViewController = sub as! YXSParentClassListViewController
//                listVC.refreshData()
//                self.navigationController?.popToViewController(listVC, animated: true)
//                
//            } else if sub is YXSTeacherClassListViewController {
//                let listVC: YXSTeacherClassListViewController = sub as! YXSTeacherClassListViewController
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
        
        let cell: YXSTransferClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "YXSTransferClassTableViewCell") as! YXSTransferClassTableViewCell
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
        header.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
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
