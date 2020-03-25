//
//  SLSettingViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/20.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight
import MBProgressHUD
import SDWebImage

class SLSettingViewController: SLBaseViewController, UITableViewDelegate, UITableViewDataSource {

    var cacheSize : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let videoSize = SLVideoPlayController.getVideoCacheSize()
        cacheSize = String(format:"%.2f", cacheFileSize() + videoSize)

        self.title = "设置"
        // Do any additional setup after loading the view.
        self.tableView.register(SLSettingTableViewCell.classForCoder(), forCellReuseIdentifier: "SLSettingTableViewCell")
        let footer:SettingFooterView = SettingFooterView()
        let role = SLPersonDataModel.sharePerson.personRole == .TEACHER ? "切换家长身份" : "切换老师身份"
        footer.btnChangeRole.setTitle(role, for: .normal)
        footer.btnChangeRole.addTarget(self, action: #selector(changeRoleClick(sender:)), for: .touchUpInside)
        footer.btnLogout.addTarget(self, action: #selector(logoutClick(sender:)), for: .touchUpInside)
        
        footer.layoutIfNeeded();
        let height = footer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        footer.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height )
        self.tableView.tableFooterView = footer
        self.tableView.mixedBackgroundColor = MixedColor.init(normal: UIColor.white, night: kNightBackgroundColor)
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
    }
    
    // MARK: - Request
    func sl_choseTypeRequest(name:String, userType:PersonRole, stage: StageType, completionHandler:(()->())?) {

        MBProgressHUD.sl_showLoading()
        SLEducationUserChooseTypeRequest.init(name: name, userType: userType, stage: stage).request({ [weak self](json) in
//            guard let weakSelf = self else {return}
            MBProgressHUD.sl_hideHUD()
//            weakSelf.sl_user.name = name
//            weakSelf.sl_user.type = userType.rawValue
//            weakSelf.sl_user.stage = stage.rawValue
            
            completionHandler?()
            
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: - Action
    @objc func clearCacheClick() {
        let dou : Double = Double(cacheSize)!
        if (CGFloat(dou) > 0.0) {
            if (cacheFileSize() > 0.0) {
                SDImageCache.shared.clearDisk {
                    SLVideoPlayController.clearVideoCache()
                    self.cacheSize = "0.00"
                    self.tableView.reloadData()
                    MBProgressHUD.sl_showMessage(message: "清理完成")
                }
            } else {
                SLVideoPlayController.clearVideoCache()
                self.tableView.reloadData()
                MBProgressHUD.sl_showMessage(message: "清理完成")
            }
            
            SLCacheHelper.removeAllCacheArchiverFile()
        } else {
            MBProgressHUD.sl_showMessage(message: "当前不需要清理哦~")
        }
    }
    
    @objc func newMessageClick() {
        let vc = SLMineMessageNoticeViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func aboutClick() {
        let vc = SLMineAboutViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func feedbackClick() {
        let vc = SLMineFeedbackViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func checkVersionClick() {
        //先不请求接口
        SLVersionUpdateManager.sharedInstance.model = nil
        SLVersionUpdateManager.sharedInstance.hasNewVersion { (hasNew) in
            if hasNew {
                SLVersionUpdateManager.sharedInstance.checkUpdate()

            } else {
                MBProgressHUD.sl_showMessage(message: "当前是最新版本")
            }
        }
//        MBProgressHUD.sl_showMessage(message: "当前是最新版本")
    }
    
    @objc func privacyPolicyClick() {
        let vc = SLBaseWebViewController()
        vc.loadUrl = "\(sericeType.getH5Url())yszc.html"
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func changeRoleClick(sender: SLButton) {
        let alert = SLConfirmationAlertView.showIn(target: self.view) { [weak self](sender, view) in
            guard let weakSelf = self else {return}
            if sender.titleLabel?.text == "确认" {
                weakSelf.changeRole()
                view.close()
            } else {
                /// 取消
            }
        }
        alert.lbTitle.text = ""
        alert.lbContent.text = SLPersonDataModel.sharePerson.personRole == .TEACHER ? "切换为家长身份" : "切换为老师身份"
    }
    
    @objc func changeRole() {
        MBProgressHUD.sl_showLoading()
        let type = SLPersonDataModel.sharePerson.personRole == .PARENT ? PersonRole.TEACHER : PersonRole.PARENT
        SLEducationUserSwitchTypeRequest.init(userType: type).request({ [weak self](model: SLClassQueryResultModel) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_hideHUD()

            UIUtil.sl_loadUserDetailRequest({ (user) in
                /// 身份切换发通知
                NotificationCenter.default.post(name: Notification.Name(kMineChangeRoleNotification), object: nil)
                weakSelf.sl_showTabRoot()
                
            }) { (msg, code) in
                MBProgressHUD.sl_showMessage(message: msg)
            }
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_hideHUD()
            if code == "205" {
                /// 用户切换身份后没有填写信息跳转填写信息
                weakSelf.pushToChoseNameStage(role: type)
            } else {
                MBProgressHUD.sl_showMessage(message: msg)
            }
        }
    }
    
    @objc func logoutClick(sender: SLButton) {
        if !sl_user.hasSetPassword! {
            let tmp: SLInputAlertView = SLInputAlertView.showIn(target: self.view) { (text, sender) in
                if sender.titleLabel?.text == "确认" && text.count > 0 {
                    MBProgressHUD.sl_showLoading()
                    SLEducationUserSetPasswordRequest(password: text).request({ (json) in
                        MBProgressHUD.sl_hideHUD()
                        SLPersonDataModel.sharePerson.userLogout()

                    }) { (msg, code) in
                        MBProgressHUD.sl_showMessage(message: msg)
                    }
                } else if sender.titleLabel?.text == "确认" {
                    MBProgressHUD.sl_showMessage(message: "密码不能为空", inView: self.view)
                }
            }
            tmp.lbTitle.text = "密码设置"
            tmp.tfInput.setPlaceholder(ph: "请输入6位以上数字字母组合")
            
        } else {
            let alert = SLConfirmationAlertView.showIn(target: self.view) { (sender, view) in
                if sender.titleLabel?.text == "确认" {
                    SLPersonDataModel.sharePerson.userLogout()
                    view.close()
                } else {
                    /// 取消
                }
            }
            alert.lbContent.text = "确定退出登录?"
        }
    }
    
    // MARK: - Other
    func pushToChoseNameStage(role: PersonRole) {
        let choseNS = SLChoseNameStageController(role: role) { [weak self](name, index, vc) in
            guard let weakSelf = self else {return}
            var stage: StageType = .KINDERGARTEN
            switch index {
            case 0:
                stage = .KINDERGARTEN
            case 1:
                stage = .PRIMARY_SCHOOL
            default:
                stage = .MIDDLE_SCHOOL
                
            }
            weakSelf.sl_choseTypeRequest(name: name, userType: role, stage: stage) { [weak self]() in
                weakSelf.changeRole()
            }
        }
        self.navigationController?.pushViewController(choseNS)
    }
    
    func choseStage(completionHandler:((_ stage:StageType)->())?) {
        let alert = SLSolitaireSelectReasonView(items: ["幼儿园","小学","中学"], selectedIndex: 0, inTarget: self.view) { [weak self](view, index) in
            guard let weakSelf = self else {return}

            var stage: StageType = .KINDERGARTEN
            switch index {
            case 0:
                stage = .KINDERGARTEN
            case 1:
                stage = .PRIMARY_SCHOOL
            default:
                stage = .MIDDLE_SCHOOL
            }
            
            MBProgressHUD.sl_showLoading()
            SLEducationUserSwitchStageRequest(stage:stage).request({ (json) in
                
                MBProgressHUD.sl_hideHUD()
                view.cancelClick(sender: SLButton())
                weakSelf.sl_user.stage = stage.rawValue
                completionHandler?(stage)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMineChangeStageNotification), object: nil)
                
            }) { (msg, code) in
                MBProgressHUD.sl_showMessage(message: msg)
            }
        }
        
        alert.lbTitle.text = "选择学段"
        alert.btnLeft.isHidden = true
        alert.btnRight.snp.remakeConstraints { (make) in
            make.height.equalTo(56)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(alert.tableView.snp_bottom).offset(21)
            make.right.equalTo(0)
            make.left.equalTo(0)
        }
    }
    
    // MARK: - Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArr = dataSource()[section] as! Array<Any>
        return sectionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionArr = dataSource()[indexPath.section] as! Array<Any>
        let dic = sectionArr[indexPath.row] as! [String:String]
        let cell: SLSettingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SLSettingTableViewCell") as! SLSettingTableViewCell
        
        cell.lbTitle.text = dic["title"]
        cell.lbSubTitle.text = dic["subTitle"]
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionArr = dataSource()[indexPath.section] as! Array<Any>
        let dic = sectionArr[indexPath.row] as! [String:String]
        if let action = dic["action"] {
            let sel: Selector = NSSelectorFromString(action)
            self.perform(sel)
        }
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
    

    // MARK: - Acion
    /// 缓存大小
    func cacheFileSize()-> CGFloat {
//        CGFloat fileSize = [SDImageCache sharedImageCache].getSize;
        let fileSize = SDImageCache.shared.totalDiskSize()
        return CGFloat(fileSize)/( 1024.0 * 1024.0);
    }

    
    // MARK: - LazyLoad
    
    @objc func dataSource()-> Array<Any>{
        var arr = Array<Any>()
        var section1: [[String:String]]
        section1 = [["title":"清除缓存", "subTitle":"\(cacheSize)MB", "action":"clearCacheClick"]]
        //[["title":"清除缓存", "subTitle":"\(cache)MB", "action":"clearCacheClick"] ,"title":"新消息通知", "subTitle":"", "action":"newMessageClick"]
        let section2 = [["title":"关于优学生", "subTitle":"", "action":"aboutClick"], ["title":"问题反馈", "subTitle":"", "action":"feedbackClick"], ["title":"检查版本更新", "subTitle":"", "action":"checkVersionClick"], ["title":"隐私政策", "subTitle":"", "action":"privacyPolicyClick"]]
//        let section2 = [["title":"关于优学生", "subTitle":"", "action":"aboutClick"],  ["title":"检查版本更新", "subTitle":"", "action":"checkVersionClick"]]
        arr.append(section1)
        arr.append(section2)
        return arr
    }
    
    lazy var tableView: SLTableView = {
        let tableView = SLTableView(frame:self.view.frame, style:.plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

//    lazy var cacheSize: String = {
//        let videoSize = SLVideoPlayController.getVideoCacheSize()
//        let cacheSize = String(format:"%.2f", cacheFileSize() + videoSize)
//        return cacheSize
//    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class SettingFooterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.btnChangeRole)
        self.addSubview(self.btnLogout)

        self.btnChangeRole.snp.makeConstraints({ (make) in
            make.top.equalTo(112)
            make.centerX.equalTo(snp_centerX)
            make.width.equalTo(265)
            make.height.equalTo(49)
        })

        self.btnLogout.snp.makeConstraints({ (make) in
            make.top.equalTo(self.btnChangeRole.snp_bottom).offset(20)
            make.centerX.equalTo(snp_centerX)
            make.width.equalTo(btnChangeRole.snp_width)
            make.height.equalTo(49)
            make.bottom.equalTo(-20)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var btnChangeRole: SLButton = {
        let btn = SLButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: 265, height: 49), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 25)
        btn.sl_shadow(frame: CGRect(x: 0, y: 0, width: 265, height: 49), color: kBlueShadowColor, cornerRadius: 24, offset: CGSize(width: 2, height: 2))
        btn.setMixedTitleColor(MixedColor(normal: 0xFFFFFF, night: 0xFFFFFF), forState: .normal)
        return btn
    }()
    
    lazy var btnLogout: SLButton = {
        let btn = SLButton()
        btn.setTitle("退出登录", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.mixedBackgroundColor = MixedColor(normal: 0xFFFFFF, night: 0x20232F)
        btn.setMixedTitleColor(MixedColor(normal: 0x5E88F7, night: 0x5E88F7), forState: .normal)
        btn.layer.borderWidth = 1
        btn.layer.mixedBorderColor = MixedColor(normal: 0xE6EAF3, night: 0x20232F)
        btn.layer.cornerRadius = 25
        return btn
    }()
}
