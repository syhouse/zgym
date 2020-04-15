//
//  YXSClassManageViewController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/21.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
/// 老师端
class YXSClassManageViewController: YXSBaseTableViewController {
    
    
    /// 禁止新成员加入
    var forbidJoin: Bool?
    var className: String! = ""
    var position: String = ""
    var gradeId: Int?
    var completionHandler:((_ className:String, _ forbidJonin:Bool)->())?
    
    private var originClassName: String?
    private var originForbidJoin: Bool?
    
    override func viewDidLoad() {
        // 是否有下拉刷新
        self.hasRefreshHeader = false
        self.showBegainRefresh = false
        
        self.fd_interactivePopDisabled = true
        
        super.viewDidLoad()
        self.title = "班级管理"
        
        self.originClassName = self.className
        self.originForbidJoin = self.forbidJoin
        
        // Do any additional setup after loading the view.
        self.tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        
        self.tableView.register(YXSClassManageTableViewCell.classForCoder(), forCellReuseIdentifier: "YXSClassManageTableViewCell")
        self.tableView.register(YXSClassManageSwitchTableViewCell.classForCoder(), forCellReuseIdentifier: "YXSClassManageSwitchTableViewCell")
        self.tableView.register(ClassManageSubTitleTableViewCell.classForCoder(), forCellReuseIdentifier: "ClassManageSubTitleTableViewCell")
        
    }
    
    // MARK: - Request
    func saveRequest(completion:@escaping ((_ className:String, _ forbidJonin:Bool)->())) {
        
        if self.forbidJoin == self.originForbidJoin && self.className == self.originClassName {
            self.navigationController?.popViewController()
            return
        }
        
        let cell: ClassManageSubTitleTableViewCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ClassManageSubTitleTableViewCell
        let swCell: YXSClassManageSwitchTableViewCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! YXSClassManageSwitchTableViewCell
        let strForbidJoin = swCell.swtJoinClass.isOn == true ? "YES":"NO"
        let className = cell.lbSubTitle.text ?? ""
        
        MBProgressHUD.yxs_showLoading()
        YXSEducationGradeUpdateRequest(dic: ["gradeId":self.gradeId ?? 0, "name":className, "forbidJoin": strForbidJoin]).request({ (json) in
            MBProgressHUD.yxs_hideHUD()
            completion(className, swCell.swtJoinClass.isOn)
            
        }) { (msg, code) in
            if code == "206" {
                //无权操作
                self.className = self.originClassName
                self.forbidJoin = self.originForbidJoin
                self.tableView.reloadData()
            }
            MBProgressHUD.yxs_hideHUD()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Action
    override func yxs_onBackClick() {
        saveRequest { [weak self](className, forbidJoin) in
            guard let weakSelf = self else {return}

            weakSelf.navigationController?.yxs_existViewController(existClass: YXSClassDetialListController(classModel: YXSClassModel.init(JSON: ["":""])!), complete: { (isExist, resultVC) in
                if isExist {
                    resultVC.title = className
                    weakSelf.completionHandler?(className, forbidJoin)
                    weakSelf.navigationController?.popViewController(animated: true)
                }
            })
            
            weakSelf.navigationController?.yxs_existViewController(existClass: YXSTeacherClassListViewController(), complete: { (isExist, resultVC) in
                if isExist {
                    resultVC.yxs_refreshData()
                }
            })
        }
    }
    
    /// 修改
    @objc func editClassNameClick() {
        let tmp: YXSInputAlertView = YXSInputAlertView.showIn(target: self.view, maxLength:20) { (text, sender) in
            
            if sender.titleLabel?.text == "确认" && text.count > 0 {
                self.className = text
                self.tableView.reloadData()
            }
        }
        
        tmp.lbTitle.text = "输入班级名称"
        tmp.tfInput.setPlaceholder(ph: "输入20字以内")
    }
    
    /// 开关
    @objc func switchChanged(sender: UISwitch) {
        self.forbidJoin = sender.isOn
    }
    
    /// 转让班级
    @objc func transferClassClick() {
        let vc = YXSTransferClassViewController()
        vc.gradeId = self.gradeId
        self.navigationController?.pushViewController(vc)
    }
    
    /// 退出班级
    @objc func signOutClassClick() {
        MBProgressHUD.yxs_showMessage(message: "请先转让再退出班级")
    }
    
    /// 推回班级列表
    func popBackToClassList() {
        for sub in self.navigationController?.viewControllers ?? [UIViewController](){
            if sub is YXSParentClassListViewController {
                let listVC: YXSParentClassListViewController = sub as! YXSParentClassListViewController
                listVC.yxs_refreshData()
                self.navigationController?.popToViewController(listVC, animated: true)
                
            } else if sub is YXSTeacherClassListViewController {
                let listVC: YXSTeacherClassListViewController = sub as! YXSTeacherClassListViewController
                listVC.yxs_refreshData()
                self.navigationController?.popToViewController(listVC, animated: true)
            }
        }
    }
    
    /// 解散班级
    @objc func dissolutionClassClick() {
        let vc = YXSPhoneAuthenticationViewController(smsType: .OPERATION_GRADE) { [weak self](account, authcode, sender, vc) in
            guard let weakSelf = self else {return}
            
            MBProgressHUD.yxs_showLoading()
            YXSEducationGradeUpdateRequest(dic: ["gradeId":weakSelf.gradeId ?? 0, "disbanded":"YES", "smsCode":String(authcode)]).request({ (json) in
                MBProgressHUD.yxs_hideHUD()
                MBProgressHUD.yxs_showMessage(message: "解散班级成功", afterDelay: 1.2)
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kQuitClassSucessNotification), object: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.2) {
                    weakSelf.popBackToClassList()
                }

            }) { (msg, code) in
                MBProgressHUD.yxs_hideHUD()
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        vc.tfAccount.text = self.yxs_user.account
        vc.tfAccount.isEnabled = false
        vc.btnDone.setTitle("确认解散班级", for: .normal)
        self.navigationController?.pushViewController(vc)
    }
    
    // MARK: - Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dic:[String:String] = self.dataSource[indexPath.section][indexPath.row]
        
        
        switch dic["type"] {
            case "SubTitleType":
                let cell: ClassManageSubTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ClassManageSubTitleTableViewCell") as! ClassManageSubTitleTableViewCell
                cell.lbTitle.text = dic["title"]
                cell.lbSubTitle.text = self.className ?? ""
                return cell
            
            case "SwitchType":
                let cell: YXSClassManageSwitchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "YXSClassManageSwitchTableViewCell") as! YXSClassManageSwitchTableViewCell
                cell.swtJoinClass.isOn = self.forbidJoin ?? false
                cell.lbTitle.text = dic["title"]
                cell.swtJoinClass.addTarget(self, action: #selector(switchChanged(sender:)), for: .valueChanged)
                return cell
            
            default:
                let cell: YXSClassManageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "YXSClassManageTableViewCell") as! YXSClassManageTableViewCell
                cell.lbTitle.text = dic["title"]
                if indexPath.row != self.dataSource[indexPath.section].count-1 {
                    cell.contentView.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#E5EAF4"), leftMargin: 15, rightMargin: 0, lineHeight: 0.5)
                }
                return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic:[String:String] = self.dataSource[indexPath.section][indexPath.row]
        if dic["action"] != nil {
            let sel = NSSelectorFromString(dic["action"]!)
            self.perform(sel)
        }
    }
    
    // MARK: - LazyLoad
    lazy var dataSource:[[[String:String]]] = {
        let arr:[[[String:String]]] = [[["title":"班级名称","type":"SubTitleType","action":"editClassNameClick"]],[["title":"禁止新成员入班","type":"SwitchType"]],[["title":"转让班级","type":"NormalType","action":"transferClassClick"],["title":"退出班级","type":"NormalType","action":"signOutClassClick"],["title":"解散班级","type":"NormalType","action":"dissolutionClassClick"]]]
        return arr
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
