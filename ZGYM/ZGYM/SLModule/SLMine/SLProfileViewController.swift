//
//  SLProfileViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/20.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import SwiftyJSON
import YBImageBrowser
import NightNight

class SLProfileViewController: SLBaseViewController, UITableViewDelegate, UITableViewDataSource, SLSelectMediaHelperDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的信息"
        // Do any additional setup after loading the view.
        
        self.tableView.register(SLProfileTableViewCell.classForCoder(), forCellReuseIdentifier: "SLProfileTableViewCell")
        self.view.addSubview(self.tableView)
        self.tableView.mixedBackgroundColor = MixedColor.init(normal: UIColor.white, night: kNightBackgroundColor)
        self.tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
    }
    
    // MARK: - Request
    @objc func requestsEditProfile(parameter:[String:String], completionHandler:(@escaping()->())) { 
        MBProgressHUD.sl_showLoading(inView: self.view)
        SLEducationUserEditRequest(parameter: parameter).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_hideHUDInView(view: weakSelf.view)
            completionHandler()
            weakSelf.tableView.reloadData()
            weakSelf.navigationController?.sl_existViewController(existClass: SLMineViewController(), complete: { (isExsit, vc) in
                vc.tableView.reloadData()
            })
            MBProgressHUD.sl_showMessage(message: "修改成功")
            NotificationCenter.default.post(name: NSNotification.Name(kMineChangeProfileNotification), object: nil)

        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_hideHUDInView(view: weakSelf.view)
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    @objc func requestUploadImage(asset: SLMediaModel) {
        MBProgressHUD.sl_showLoading(inView: self.view)
        SLUploadSourceHelper().uploadImage(mediaModel: asset, sucess: { [weak self](successUrl) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_hideHUDInView(view: weakSelf.view)
            weakSelf.requestsEditProfile(parameter: ["avatar":successUrl]) {
                weakSelf.sl_user.avatar = successUrl
                
            }
            
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: - Action
    @objc func editAvatarClick() {
        SLSelectMediaHelper.shareHelper.showSelectMedia(selectImage: true)
        SLSelectMediaHelper.shareHelper.delegate = self
    }
    
    @objc func editNameClick() {
        let vc = SLInputViewController(maxLength: 10) { [weak self](text,vc) in
            guard let weakSelf = self else {return}
            if text.count > 0 {
                weakSelf.requestsEditProfile(parameter: ["name":text]) {
                    weakSelf.sl_user.name = text
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                        vc.navigationController?.popViewController()
                    }
                }
            }
        }
        vc.title = SLPersonDataModel.sharePerson.personRole == .TEACHER ? "修改称呼" : "修改名字"
        vc.btnDone.setTitle("确认", for: .normal)
        vc.tfText.setPlaceholder(ph: "10字以内")
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func editSchoolClick() {
        let vc = SLAmapLoactionViewController()
        self.navigationController?.pushViewController(vc)
        
        vc.completionHandler = {[weak self](coordinate, name) in
            guard let weakSelf = self else {return}
            if name.count > 0 {
                weakSelf.requestsEditProfile(parameter: ["school":name]) {
                    weakSelf.sl_user.school = name
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                        vc.navigationController?.popViewController()
                    }
                }
            }
        }
    }
    
    @objc func editAddressClick() {

        SLAddressPickerView(frame: CGRect.zero, completionHandler: { [weak self](province, city, district, view) in
            guard let weakSelf = self else {return}
            let strAddress = "\(province)\(city)\(district)"
            weakSelf.requestsEditProfile(parameter: ["address":strAddress]) {
                weakSelf.sl_user.address = strAddress
                view.cancelClick(sender: nil)
            }
            
        }).showIn(target: self.view)
//        return
//        let vc = HMInpuViewController(maxLength: 10) { [weak self](text,vc) in
//            guard let weakSelf = self else {return}
//            if text.count > 0 {
//                weakSelf.requestsEditProfile(parameter: ["address":text]) {
//                    weakSelf.sl_user.address = text
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
//                        vc.navigationController?.popViewController()
//                    }
//                }
//
//            }
//        }
//        vc.title = "手动输入"
//        vc.btnDone.setTitle("确认", for: .normal)
//        vc.tfText.placeholder = "输入您所在的地区"
//        self.navigationController?.pushViewController(vc)
    }
    
    
    @objc func changeBindingPhoneClick() {
        let vc = SLPhoneAuthenticationViewController(smsType: .UPDATE_ACCOUNT) { [weak self](phone, code, sender, vc) in
            guard let weakSelf = self else {return}
            weakSelf.requestsEditProfile(parameter: ["account":phone, "smsCode":String(code)]) {
                weakSelf.sl_user.account = phone
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    vc.navigationController?.popViewController()
                }
            }
        }
        vc.title = "修改手机号"
        vc.tfAccount.setPlaceholder(ph: "请输入新的11位手机号")
        vc.tfAuthCode.setPlaceholder(ph: "请输入验证码") 
        vc.btnDone.setTitle("确认修改", for: .normal)
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func editPasswordClick() {
        let vc = SLEditPasswordViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func childrensInfoClick() {
        let vc = SLMineChildrenListViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    // MARK: - ImgSelectDelegate
    func didSelectMedia(asset: SLMediaModel) {
        requestUploadImage(asset: asset)
    }
    
    /// 选中多个图片资源
    /// - Parameter assets: models
    func didSelectSourceAssets(assets: [SLMediaModel]) {
        requestUploadImage(asset: assets.first ?? SLMediaModel())
    }
    
    // MARK: - Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArr = dataSource()[section] as! Array<Any>
        return sectionArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SLProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SLProfileTableViewCell") as! SLProfileTableViewCell
        let sectionArr = dataSource()[indexPath.section] as! Array<Any>
        let dic = sectionArr[indexPath.row] as! [String:String]
        cell.lbTitle.text = dic["title"]
        cell.lbSubTitle.text = dic["subTitle"]
        
        if dic["title"] == "头像" {
            cell.cellStyle = .ImageViews
            cell.imgAvatar.sd_setImage(with: URL(string: dic["avatar"] ?? ""), placeholderImage:SLPersonDataModel.sharePerson.personRole == .TEACHER ? kImageUserIconTeacherDefualtImage : kImageUserIconStudentDefualtImage)
            cell.avatarTap = { (avatar) in
                let browser = YBImageBrowser()
                let imgData = YBIBImageData()
                imgData.image = {return avatar}
                browser.dataSourceArray.append(imgData)
                browser.show()
            }
            
        } else {
            cell.cellStyle = .SubTitle
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.mixedBackgroundColor = MixedColor.init(normal: kTableViewBackgroundColor, night: UIColor.clear)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionArr = dataSource()[indexPath.section] as! Array<Any>
        let dic = sectionArr[indexPath.row] as! [String:String]
        
        if let action = dic["action"] {
            let sel: Selector = NSSelectorFromString(action)
            self.perform(sel)
        }
    }
    
    // MARK: - LazyLoad
    lazy var tableView: SLTableView = {
        let tb = SLTableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tb.backgroundColor = kTableViewBackgroundColor
        tb.delegate = self
        tb.dataSource = self
        return tb
    }()
    
    @objc func dataSource()-> Array<Any>{
        var arr = Array<Any>()
        var section1: [[String:String]]
        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
            section1 = [["title":"头像", "subTitle":"", "action":"editAvatarClick","avatar":self.sl_user.avatar ?? ""],["title":"称呼", "subTitle": self.sl_user.name ?? "", "action":"editNameClick"],["title":"所在学校", "subTitle":self.sl_user.school ?? "", "action":"editSchoolClick"]]
        } else {
            section1 = [["title":"名字", "subTitle": self.sl_user.name ?? "", "action":"editNameClick"],["title":"所在地区", "subTitle":self.sl_user.address ?? "", "action":"editAddressClick"],["title":"孩子信息", "subTitle":"", "action":"childrensInfoClick"]]
        }
         
        let section2 = [["title":"我的账号", "subTitle":self.sl_user.account ?? "", "action":"changeBindingPhoneClick"], ["title":"修改密码", "subTitle":"", "action":"editPasswordClick"]]
        arr.append(section1)
        arr.append(section2)
        return arr
    }
//    var dataSource: [Any] {
//        get {
//            var arr = Array<Any>()
//            var section1: [[String:String]]
//            if SLPersonDataModel.sharePerson.personRole == .TEACHER {
//                section1 = [["title":"头像", "subTitle":"", "action":"editAvatarClick"],["title":"称呼", "subTitle": self.sl_user.name ?? "", "action":"editNameClick"],["title":"所在学校", "subTitle":self.sl_user.school ?? "", "action":"editSchoolClick"]]
//            } else {
//                section1 = [["title":"称呼", "subTitle": self.sl_user.name ?? "", "action":"editNameClick"],["title":"所在地区", "subTitle":self.sl_user.address ?? "", "action":"editAddressClick"]]
//            }
//
//            let section2 = [["title":"我的账号", "subTitle":self.sl_user.account ?? "", "action":"changeBindingPhoneClick"], ["title":"修改密码", "subTitle":"", "action":"editPasswordClick"]]
//            arr.append(section1)
//            arr.append(section2)
//            return arr
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
