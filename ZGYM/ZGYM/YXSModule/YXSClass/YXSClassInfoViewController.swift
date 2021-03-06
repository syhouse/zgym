//
//  YXSClassInfoViewController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/22.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight


/// 家长端
class YXSClassInfoViewController: YXSBaseTableViewController {
    let classModel: YXSClassModel
    private var smsCode: String!
    init(classModel: YXSClassModel) {
        self.classModel = classModel
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        self.hasRefreshHeader = false
        self.showBegainRefresh = false
        //        self.tableViewIsGroup = true
        
        super.viewDidLoad()
        self.title = "班级信息"
        // Do any additional setup after loading the view.
        self.tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        self.tableView.register(YXSClassManageTableViewCell.classForCoder(), forCellReuseIdentifier: "YXSClassManageTableViewCell")
        self.tableView.register(ClassManageSubTitleTableViewCell.classForCoder(), forCellReuseIdentifier: "ClassManageSubTitleTableViewCell")
    }
    
    
    // MARK: - Action
    /// 退出班级
    @objc func signOutClassClick() {
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            let vc = YXSPhoneAuthenticationViewController(smsType: .OPERATION_GRADE) { [weak self](account, authcode, sender, vc) in
                guard let weakSelf = self else {return}
                weakSelf.quitClassRequest(gradeId:weakSelf.classModel.id ?? 0, childrenIds: nil, smsCode: authcode) {
                    MBProgressHUD.yxs_showMessage(message: "退出班级成功", afterDelay: 1.2)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.2) {
                        weakSelf.popBackToClassList()
                    }
                }
            }
            vc.tfAccount.text = self.yxs_user.account
            vc.tfAccount.isEnabled = false
            self.navigationController?.pushViewController(vc)
            
        } else {
            YXSCommonAlertView.showAlert(title: "提示", message: "您是否退出该班级？", leftTitle: "取消", rightTitle: "确定", rightClick: {
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.pushPhoneAuthentication()
            })
        }
        
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
    
    func pushPhoneAuthentication(){
        let vc = YXSPhoneAuthenticationViewController(smsType: .OPERATION_GRADE) { [weak self](account, authcode, sender, vc) in
            guard let strongSelf = self else { return }
            strongSelf.quitClassRequest(gradeId:strongSelf.classModel.id ?? 0 , childrenIds: [strongSelf.classModel.childrenId ?? 0], smsCode: authcode) {
                MBProgressHUD.yxs_showMessage(message: "退出班级成功", afterDelay: 1.2)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.2) {
                    strongSelf.popBackToClassList()
                }
            }
        }
        vc.tfAccount.text = self.yxs_user.account
        vc.tfAccount.isEnabled = false
        navigationController?.pushViewController(vc)
    }
    
    // MARK: - Request
    @objc func quitClassRequest(gradeId:Int, childrenIds:[Int]?, smsCode:Int, completionHandler:(()->())?) {
        MBProgressHUD.yxs_showLoading()
        YXSEducationGradeQuitRequest(gradeId: gradeId, childrenIds: childrenIds, smsCode: smsCode).request({ (json) in
            MBProgressHUD.yxs_hideHUD()
            completionHandler?()
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kQuitClassSucessNotification), object: nil)
            
        }) { (msg, code) in
            MBProgressHUD.yxs_hideHUD()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    @objc func childrenListRequest(completionHandler:((_ list:[YXSChildrenModel])->())?) {
        MBProgressHUD.yxs_showLoading()
        YXSEducationGradeOptionalChildrenListRequest(gradeId: classModel.id ?? 0).requestCollection({ (list:[YXSChildrenModel]) in
            MBProgressHUD.yxs_hideHUD()
            completionHandler?(list)
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
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
            cell.imgRightArrow.isHidden = true
            cell.lbTitle.text = dic["title"]
            cell.lbSubTitle.text = self.classModel.name//"海军班"
            return cell
            
        default:
            let cell: YXSClassManageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "YXSClassManageTableViewCell") as! YXSClassManageTableViewCell
            cell.lbTitle.text = dic["title"]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header:UIView = UIView()
        header.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor)
        return header
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
        let arr:[[[String:String]]] = [[["title":"班级名称","type":"SubTitleType"]],[["title":"退出班级","type":"Normal","action":"signOutClassClick"]]]
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
