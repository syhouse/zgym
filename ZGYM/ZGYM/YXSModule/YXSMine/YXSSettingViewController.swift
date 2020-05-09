//
//  SLSettingViewController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/20.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
import MBProgressHUD
import SDWebImage

class YXSSettingViewController: YXSBaseViewController, UITableViewDelegate, UITableViewDataSource {

    var cacheSize : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let videoSize = SLVideoPlayController.getVideoCacheSize()
        cacheSize = String(format:"%.2f", cacheFileSize() + videoSize)

        self.title = "设置"
        // Do any additional setup after loading the view.
        self.tableView.register(YXSSettingTableViewCell.classForCoder(), forCellReuseIdentifier: "YXSSettingTableViewCell")
        let footer:SettingFooterView = SettingFooterView()
        let role = YXSPersonDataModel.sharePerson.personRole == .TEACHER ? "切换家长身份" : "切换老师身份"
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
    func yxs_choseTypeRequest(name:String, userType:PersonRole, stage: StageType, completionHandler:(()->())?) {

        MBProgressHUD.yxs_showLoading()
        YXSEducationUserChooseTypeRequest.init(name: name, userType: userType, stage: stage).request({ [weak self](json) in
//            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
//            weakSelf.yxs_user.name = name
//            weakSelf.yxs_user.type = userType.rawValue
//            weakSelf.yxs_user.stage = stage.rawValue
            
            completionHandler?()
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
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
                    MBProgressHUD.yxs_showMessage(message: "清理完成")
                }
            } else {
                SLVideoPlayController.clearVideoCache()
                self.tableView.reloadData()
                MBProgressHUD.yxs_showMessage(message: "清理完成")
            }
            
            YXSCacheHelper.removeAllCacheArchiverFile()
        } else {
            MBProgressHUD.yxs_showMessage(message: "当前不需要清理哦~")
        }
    }
    
    @objc func newMessageClick() {
        let vc = YXSMineMessageNoticeViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func aboutClick() {
        let vc = YXSMineAboutViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func feedbackClick() {
        let vc = YXSMineFeedbackViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func checkVersionClick() {
        //先不请求接口
        YXSVersionUpdateManager.sharedInstance.model = nil
        YXSVersionUpdateManager.sharedInstance.hasNewVersion { (hasNew) in
            if hasNew {
                YXSVersionUpdateManager.sharedInstance.checkUpdate()

            } else {
                MBProgressHUD.yxs_showMessage(message: "当前是最新版本")
            }
        }
//        MBProgressHUD.yxs_showMessage(message: "当前是最新版本")
    }
    
    @objc func privacyPolicyClick() {
        let vc = YXSBaseWebViewController()
        vc.loadUrl = "\(sericeType.getH5Url())yszc.html"
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func changeRoleClick(sender: YXSButton) {
        let alert = YXSConfirmationAlertView.showIn(target: self.view) { [weak self](sender, view) in
            guard let weakSelf = self else {return}
            if sender.titleLabel?.text == "确认" {
                weakSelf.changeRole()
                view.close()
            } else {
                /// 取消
            }
        }
        alert.lbTitle.text = ""
        alert.lbContent.text = YXSPersonDataModel.sharePerson.personRole == .TEACHER ? "切换为家长身份" : "切换为老师身份"
    }
    
    @objc func changeRole() {
        MBProgressHUD.yxs_showLoading()
        let type = YXSPersonDataModel.sharePerson.personRole == .PARENT ? PersonRole.TEACHER : PersonRole.PARENT
        YXSEducationUserSwitchTypeRequest.init(userType: type).request({ [weak self](model: YXSClassQueryResultModel) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()

            UIUtil.yxs_loadUserDetailRequest({ (user) in
                /// 身份切换发通知
                NotificationCenter.default.post(name: Notification.Name(kMineChangeRoleNotification), object: nil)
                weakSelf.yxs_showTabRoot()
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            if code == "205" {
                /// 用户切换身份后没有填写信息跳转填写信息
                weakSelf.pushToChoseNameStage(role: type)
            } else {
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
    }
    
    @objc func logoutClick(sender: YXSButton) {
        if !yxs_user.hasSetPassword! {
            let tmp: YXSInputAlertView = YXSInputAlertView.showIn(target: self.view, maxLength: 15) { (text, sender) in
                if sender.titleLabel?.text == "确认" && text.count > 0 {
                    if text.isPassword {
                        MBProgressHUD.yxs_showLoading()
                        YXSEducationUserSetPasswordRequest(password: text).request({ (json) in
                            MBProgressHUD.yxs_hideHUD()
                            YXSPersonDataModel.sharePerson.userLogout()

                        }) { (msg, code) in
                            MBProgressHUD.yxs_showMessage(message: msg)
                        }
                        
                    } else {
                        MBProgressHUD.yxs_showMessage(message: "请输入6位以上数字字母密码")
                    }
                    
                } else if sender.titleLabel?.text == "确认" {
                    MBProgressHUD.yxs_showMessage(message: "密码不能为空", inView: self.view)
                }
            }
            tmp.lbTitle.text = "密码设置"
            tmp.tfInput.setPlaceholder(ph: "请输入6位以上数字字母组合")
            
        } else {
            let alert = YXSConfirmationAlertView.showIn(target: self.view) { (sender, view) in
                if sender.titleLabel?.text == "确认" {
                    YXSPersonDataModel.sharePerson.userLogout()
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
        let choseNS = YXSChoseNameStageController(role: role) { [weak self](name, index, vc) in
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
            weakSelf.yxs_choseTypeRequest(name: name, userType: role, stage: stage) { [weak self]() in
                weakSelf.changeRole()
            }
        }
        self.navigationController?.pushViewController(choseNS)
    }
    
    func choseStage(completionHandler:((_ stage:StageType)->())?) {
        let alert = YXSSolitaireSelectReasonView(items: ["幼儿园","小学","中学"], selectedIndex: 0, inTarget: self.view) { [weak self](view, index) in
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
            
            MBProgressHUD.yxs_showLoading()
            YXSEducationUserSwitchStageRequest(stage:stage).request({ (json) in
                
                MBProgressHUD.yxs_hideHUD()
                view.cancelClick(sender: YXSButton())
                weakSelf.yxs_user.stage = stage.rawValue
                completionHandler?(stage)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMineChangeStageNotification), object: nil)
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
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
        let cell: YXSSettingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "YXSSettingTableViewCell") as! YXSSettingTableViewCell
        
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
        let section2 = [["title":"关于优学业", "subTitle":"", "action":"aboutClick"], ["title":"问题反馈", "subTitle":"", "action":"feedbackClick"], ["title":"检查版本更新", "subTitle":"", "action":"checkVersionClick"], ["title":"隐私政策", "subTitle":"", "action":"privacyPolicyClick"]]
//        let section2 = [["title":"关于优学业", "subTitle":"", "action":"aboutClick"],  ["title":"检查版本更新", "subTitle":"", "action":"checkVersionClick"]]
        arr.append(section1)
        arr.append(section2)
        return arr
    }
    
    lazy var tableView: YXSTableView = {
        let tableView = YXSTableView(frame:self.view.frame, style:.plain)
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
    
    lazy var btnChangeRole: YXSButton = {
        let btn = YXSButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 265, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 25)
        btn.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 265, height: 49), color: kBlueShadowColor, cornerRadius: 24, offset: CGSize(width: 2, height: 2))
        btn.setMixedTitleColor(MixedColor(normal: 0xFFFFFF, night: 0xFFFFFF), forState: .normal)
        return btn
    }()
    
    lazy var btnLogout: YXSButton = {
        let btn = YXSButton()
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
