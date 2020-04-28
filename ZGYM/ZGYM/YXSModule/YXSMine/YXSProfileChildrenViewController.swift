//
//  SLProfileChildrenViewController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/9.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSProfileChildrenViewController: YXSProfileViewController {
    var sucess: ((_ studentId: String?) ->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "孩子详情"
        
        // Do any additional setup after loading the view.
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 84))
        let btnDelete = YXSButton()
        btnDelete.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightForegroundColor)
        btnDelete.setImage(UIImage(named: "yxs_mine_delete"), for: .normal)
        btnDelete.setTitle("删除孩子", for: .normal)
        btnDelete.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btnDelete.setMixedTitleColor(MixedColor(normal: 0xEC9590, night: 0xEC9590), forState: .normal)
        btnDelete.addTarget(self, action: #selector(deleteClick(sender:)), for: .touchUpInside)
        footerView.addSubview(btnDelete)
        btnDelete.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(50)
        })
        
        self.tableView.tableFooterView = footerView
        
    }
    
    
    // MARK: - Request
    @objc override func requestsEditProfile(parameter:[String:String], completionHandler:(@escaping()->())) {
        MBProgressHUD.yxs_showLoading()
        var dic = parameter
        dic["id"] = String(model?.id ?? 0)
        YXSEducationChildrenUpdateRequest(parameter: dic).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            completionHandler()
            weakSelf.tableView.reloadData()
            weakSelf.navigationController?.yxs_existViewController(existClass: YXSProfileChildrenViewController(), complete: { (isExsit, vc) in
                vc.tableView.reloadData()
            })
            
            weakSelf.navigationController?.yxs_existViewController(existClass: YXSMineChildrenListViewController(), complete: { (isExsit, vc) in
                vc.tableView.reloadData()
            })
            
            MBProgressHUD.yxs_showMessage(message: "修改成功")
            weakSelf.sucess?(weakSelf.model?.studentId)
            
            NotificationCenter.default.post(name: NSNotification.Name(kMineChangeProfileNotification), object: nil)
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    @objc override func requestUploadImage(asset: YXSMediaModel) {
        MBProgressHUD.yxs_showLoading()
        YXSUploadSourceHelper().uploadImage(mediaModel: asset, sucess: { [weak self](successUrl) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            weakSelf.requestsEditProfile(parameter: ["avatar":successUrl]) {
                weakSelf.model?.avatar = successUrl
            }

        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }

    
    // MARK: - Setter
    var model: YXSChildrenModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Action
    override func editAvatarClick() {
        YXSSelectMediaHelper.shareHelper.showSelectMedia(selectImage: true)
        YXSSelectMediaHelper.shareHelper.delegate = self
    }
    
    override func editNameClick() {
        let vc = YXSInputViewController(maxLength: 10) { [weak self](text,vc) in
            guard let weakSelf = self else {return}
            if text.count > 0 {
                weakSelf.requestsEditProfile(parameter: ["realName":text]) {
                    weakSelf.model?.realName = text
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                        vc.navigationController?.popViewController()
                    }
                }
            }
        }
        vc.title = "修改称呼"
        vc.btnDone.setTitle("确认", for: .normal)
        vc.tfText.setPlaceholder(ph: "10字以内")
        vc.tfText.text = self.model?.realName
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func editStudentIdClick() {
        let vc = YXSInputViewController(maxLength: 10) { [weak self](text,vc) in
            guard let weakSelf = self else {return}
            if text.count > 0 {
                weakSelf.requestsEditProfile(parameter: ["studentId":text]) {
                    weakSelf.model?.studentId = text
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                        vc.navigationController?.popViewController()
                    }
                }
            }
        }
        vc.title = "修改学号"
        vc.btnDone.setTitle("确认", for: .normal)
        vc.tfText.setPlaceholder(ph: "10字以内")
        vc.tfText.text = self.model?.studentId
        self.navigationController?.pushViewController(vc)
    }
    
//    override func editAddressClick() {
//
//    }
//
//    func editClassClick() {
//
//    }
    
    @objc func deleteClick(sender: YXSButton) {
        let view = YXSConfirmationAlertView.showIn(target: self.view) { [weak self](sender, view) in
            guard let weakSelf = self else {return}
            
            if sender.titleLabel?.text == "确认" {
                MBProgressHUD.yxs_showLoading()
                YXSEducationChildrenDeleteRequest(id: weakSelf.model?.id ?? 0).request({ (json) in
                    MBProgressHUD.yxs_hideHUD()
                    weakSelf.navigationController?.yxs_existViewController(existClass: YXSMineChildrenListViewController(), complete: { (isExist, vc) in
                        vc.yxs_refreshData()
                    })
                    
                    weakSelf.navigationController?.yxs_existViewController(existClass: YXSMineViewController(), complete: { (isExist, vc) in
                        vc.yxs_refreshData()
                    })
                    view.close()
                    weakSelf.navigationController?.popViewController()
                    
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kDelectChildSucessNotification), object: nil)
                    
                }) { (msg, code) in
                    let errorModel = YXSClassAddErrorModel.init(JSONString: msg)
                    if let errorModel = errorModel{
                        if errorModel.account != self?.yxs_user.account{
                            let left = errorModel.account!.mySubString(to: 3)
                            let right = errorModel.account!.mySubString(from: 7)
                            MBProgressHUD.yxs_showMessage(message: "当前已有家长\("\(left)****\(right)")绑定该孩子，暂不可删除")
                            return
                        }else if errorModel.gradeId != nil{
                            MBProgressHUD.yxs_showMessage(message: "暂不可删除，请先退出班级")
                        }
                    }else{
                        MBProgressHUD.yxs_showMessage(message: msg)
                    }
                    
                }
            }
        }
        view.lbContent.text = "您确认要删除[\(model?.realName ?? "")]该孩子吗?"
    }
    
    
    // MARK: - ImgSelectDelegate
    override func didSelectMedia(asset: YXSMediaModel) {
        requestUploadImage(asset: asset)
    }
    
    /// 选中多个图片资源
    /// - Parameter assets: models
    override func didSelectSourceAssets(assets: [YXSMediaModel]) {
        requestUploadImage(asset: assets.first ?? YXSMediaModel())
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:YXSProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "YXSProfileTableViewCell") as! YXSProfileTableViewCell
        let sectionArr = dataSource()[indexPath.section] as! Array<Any>
        let dic = sectionArr[indexPath.row] as! [String:String]
        cell.lbTitle.text = dic["title"]
        cell.lbSubTitle.text = dic["subTitle"]
        
        if dic["title"] == "头像" {
            cell.cellStyle = .ImageViews
            cell.imgAvatar.isUserInteractionEnabled = false
            cell.imgAvatar.sd_setImage(with: URL(string: dic["avatar"] ?? ""), placeholderImage:kImageUserIconStudentDefualtImage)
            
        } else {
            cell.cellStyle = .SubTitle
            
        }
        return cell
    }
    
    
    override func dataSource() -> Array<Any> {
        var arr = Array<Any>()
        var section1: [[String:String]]
        section1 = [["title":"头像", "subTitle":"", "action":"editAvatarClick", "avatar":self.model?.avatar ?? ""],["title":"名字", "subTitle": self.model?.realName ?? "", "action":"editNameClick"], ["title":"学号", "subTitle":self.model?.studentId ?? "", "action":"editStudentIdClick"]]

        
//        let section2 = [["title":"学号", "subTitle":self.model?.studentId ?? "", "action":""]]
//        let section2 = [["title":"学号", "subTitle":self.model?.studentId ?? "", "action":""], ["title":"所在地区", "subTitle": self.yxs_user.address ?? ""], ["title":"所在班级", "subTitle":self.yxs_user.school ?? "", "action":"editClassClick"]]
        arr.append(section1)
//        arr.append(section2)
        return arr
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
