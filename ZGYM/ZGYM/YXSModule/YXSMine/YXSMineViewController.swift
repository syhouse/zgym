//
//  SLMineViewController.swift
//  HNYMEducation
//
//  Created by mac_hm on 2019/11/16.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
//import MBProgressHUD

class YXSMineViewController: YXSBaseTableViewController{//YXSBaseViewController, UITableViewDelegate, UITableViewDataSource {
    override init() {
        super.init()
        tableViewIsGroup = true
        hasRefreshHeader = false
        showBegainRefresh = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        // Do any additional setup after loading the view.
        self.view.addSubview(self.tableView)
        self.tableView.register(YXSMineTableViewCell.classForCoder(), forCellReuseIdentifier: "YXSMineTableViewCell")
        self.tableView.register(YXSMineSwitchTableViewCell.classForCoder(), forCellReuseIdentifier: "YXSMineSwitchTableViewCell")
        self.tableView.register(YXSMineTopCornerRadiusTableViewCell.classForCoder(), forCellReuseIdentifier: "YXSMineTopCornerRadiusTableViewCell")
        self.tableView.register(YXSMineBottomCornerRadiusTableViewCell.classForCoder(), forCellReuseIdentifier: "YXSMineBottomCornerRadiusTableViewCell")
        
        
        self.tableView.register(MineTableViewHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: "MineTableViewHeader")
        self.tableView.mixedBackgroundColor = MixedColor.init(normal: UIColor.clear, night: kNightBackgroundColor)
        self.tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        
//        self.tableView.tableHeaderView = headerView
        
    }
    
    //请求个人信息
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserData()
    }
    
    
    func layout() {
        
    }
    
    // MARK: - Action
    @objc func editClick(sender: YXSButton) {
        self.navigationController?.pushViewController(YXSProfileViewController())
    }
    
    @objc func avatarClick(sender: YXSButton) {
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            
        } else {
            let vc = YXSMineChildrenListViewController()
            self.navigationController?.pushViewController(vc)
        }
    }
    
    /// 切换学段
    @objc func changeStage(sender: YXSButton) {
        
        var selectedIndex: Int = 0
        if self.yxs_user.stage == "KINDERGARTEN" {
            selectedIndex = 0
        } else if self.yxs_user.stage == "PRIMARY_SCHOOL" {
            selectedIndex = 1
        } else {
            selectedIndex = 2
        }
        
        let alert = SLSolitaireSelectReasonView(items: ["幼儿园","小学","中学"], selectedIndex: selectedIndex, inTarget: self.view) { (view, index) in
            if selectedIndex == index {
                view.cancelClick(sender: YXSButton())
                return
            }
            var stage: StageType = .MIDDLE_SCHOOL
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
                MBProgressHUD.yxs_showMessage(message: "修改成功")
                view.cancelClick(sender: YXSButton())
                UIUtil.yxs_loadUserDetailRequest({ (user) in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMineChangeStageNotification), object: nil)
                    self.yxs_showTabRoot()
                    
                }) { (msg, code) in
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        alert.lbTitle.text = "选择学段"
    }
    
    @objc func commentClick() {
        let vc = YXSMineCommentViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func questionClick() {
        let vc = YXSBaseWebViewController()
        vc.title = "常见问题"
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER { 
            vc.loadUrl = "http://www.ym698.com/lscj"
        
        } else {
            vc.loadUrl = "http://www.ym698.com/jzcj/"
        }
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func systemMessageClick() {
        self.navigationController?.pushViewController(YXSSystemMessageViewController())
    }
    
    @objc func classListClick() {
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            self.navigationController?.pushViewController(YXSParentClassListViewController())
        } else {
            self.navigationController?.pushViewController(YXSTeacherClassListViewController())
        }
    }
    
    @objc func settingClick() {
        self.navigationController?.pushViewController(YXSSettingViewController())
    }
    
    @objc func themeClick(sender:UISwitch) {
        UIUtil.changeTheme()
        NotificationCenter.default.post(name: NSNotification.Name(kThemeChangeNotification), object: nil)
    }
    
    @objc func feedbackClick() {
        let vc = YXSMineFeedbackViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func privacyPolicyClick() {
        let vc = YXSBaseWebViewController()
        vc.loadUrl = "\(sericeType.getH5Url())yszc.html"
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func recommendClick() {
        let strUrl = "https://edu-pro.ym698.com:50009/down/"
        let title = "优教育，优成长"
        let dsc = "我正在使用“优学业”APP进行家校沟通，赶快一起参与进来吧~"
        let shareModel = YXSShareModel(title: title, descriptionText: dsc, link: strUrl)
        YXSShareTool.showCommonShare(shareModel: shareModel)
    }
    
    @objc func classFileClick() {
        /// 班级文件
        let vc = SLClassFileViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func fileBagClick() {
        /// 老师-书包
        let vc = YXSSatchelFileViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    /// 我的收藏
    @objc func myCollectClick() {
        let vc = YXSMyCollectVC()
        self.navigationController?.pushViewController(vc)
    }
    
    // MARK: - loadData
    func loadUserData(){
        UIUtil.yxs_loadUserDetailRequest({ [weak self](userModel: YXSEducationUserModel) in
            guard let weakSelf = self else {return}
            if !YXSChatHelper.sharedInstance.isLogin() {
                YXSChatHelper.load()
            }
            weakSelf.tableView.reloadData()
            
        }) { (msg, code) in
        }
    }
    
    // MARK: - Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArr = dataSource[section] as! Array<Any>
        return sectionArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionArr = dataSource[indexPath.section] as! Array<Any>
        let dic = sectionArr[indexPath.row] as! [String:String]
        
        var cell:YXSMineTableViewCell!
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "YXSMineTableViewCell") as? YXSMineTableViewCell
            cell.bgView.cornerRadius = 5
            
        } else if indexPath.section == 1 {
            let swtCell: YXSMineSwitchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "YXSMineSwitchTableViewCell") as! YXSMineSwitchTableViewCell
            swtCell.swt.isOn = NightNight.theme == .night ? true : false
            swtCell.bgView.cornerRadius = 5
            swtCell.swt.addTarget(self, action: #selector((themeClick(sender:))), for: .valueChanged)
            cell = swtCell
            
        } else {
            if indexPath.row == 0 {
                let firstCell: YXSMineTopCornerRadiusTableViewCell = tableView.dequeueReusableCell(withIdentifier: "YXSMineTopCornerRadiusTableViewCell") as! YXSMineTopCornerRadiusTableViewCell
                firstCell.bgView.yxs_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor))
                cell = firstCell
                
            } else if indexPath.row == sectionArr.count-1 {
                let lastCell: YXSMineBottomCornerRadiusTableViewCell = tableView.dequeueReusableCell(withIdentifier: "YXSMineBottomCornerRadiusTableViewCell") as! YXSMineBottomCornerRadiusTableViewCell
                cell = lastCell
                
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "YXSMineTableViewCell") as? YXSMineTableViewCell
                cell.bgView.yxs_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor))
            }
        }
        
        cell.lbTitle.text = dic["title"]
        let imgName = dic["imgName"] ?? ""
        cell.imgView.mixedImage = MixedImage(normal: UIImage(named: imgName+"_white")!, night: UIImage(named: imgName)!)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 168
//
//        } else {
//            return 10
//        }
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header: MineTableViewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MineTableViewHeader") as! MineTableViewHeader
            header.refreshData()
            header.infoView.btnEdit.addTarget(self, action: #selector(editClick(sender:)), for: .touchUpInside)
            header.infoView.btnAvatar.addTarget(self, action: #selector(avatarClick(sender:)), for: .touchUpInside)
            header.infoView.imgStackingView.addTarget(self, action: #selector(avatarClick(sender:)), for: .touchUpInside)
//            header.infoView.btnChildren.addTaget(target: self, selctor: #selector(avatarClick(sender:)))
//            header.infoView.btnChangeStage.addTarget(self, action: #selector(changeStage(sender:)), for: .touchUpInside)
//            header.infoView.btnMyClass.addTarget(self, action: #selector(classListClick), for: .touchUpInside)
//            header.infoView.btnMyClass2.addTarget(self, action: #selector(classListClick), for: .touchUpInside)
//            header.infoView.btnMyComment.addTarget(self, action: #selector(commentClick), for: .touchUpInside)
            return header
            
        } else {
            let view = UIView()
            let blankView = UIView()
            view.addSubview(blankView)
            blankView.snp.makeConstraints({ (make) in
                make.edges.equalTo(0)
                make.height.equalTo(10)
            })
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionArr = dataSource[indexPath.section] as! Array<Any>
        let dic = sectionArr[indexPath.row] as! [String:String]
        let action = dic["action"] ?? ""
        if action.count > 0 {
            let sel: Selector = NSSelectorFromString(action)
            self.perform(sel)
        }
    }
    
    
    // MARK: - LazyLoad
//    lazy var dataSource: [[String:String]] = {
//        var arr: [[String: String]]!
////        ["title":"系统通知", "imgName":"yxs_mine_notice", "action":"systemMessageClick"],
//        arr = [["title":"常见问题", "imgName":"yxs_mine_question", "action":"questionClick"], ["title":"设置", "imgName":"yxs_mine_setting", "action":"settingClick"],["title":"夜间模式", "imgName":"yxs_mine_theme", "action":""]]
////        arr = [["title":"问题反馈", "imgName":"yxs_mine_feedback", "action":"feedbackClick"], ["title":"隐私政策", "imgName":"yxs_mine_privacy", "action":"privacyPolicyClick"], ["title":"设置", "imgName":"yxs_mine_setting", "action":"settingClick"]]
//
//        return arr
//    }()
  
    
    lazy var dataSource: Array<Any> = {
        var arr: [[String: String]]!
//        ["title":"系统通知", "imgName":"yxs_mine_notice", "action":"systemMessageClick"],
        var section1 = [["title":"我的班级", "imgName":"yxs_mine_house", "action":"classListClick"]]
        
        var section2 = [["title":"夜间模式", "imgName":"yxs_mine_theme", "action":""]]
        
        #if DEBUG
        var section3 = [["title":"常见问题", "imgName":"yxs_mine_question", "action":"questionClick"],["title":"推荐优学业", "imgName":"yxs_mine_recommend", "action":"recommendClick"],["title":"设置", "imgName":"yxs_mine_setting", "action":"settingClick"],["title":"班级文件", "imgName":"yxs_mine_setting", "action":"classFileClick"],["title":"书包", "imgName":"yxs_mine_setting", "action":"fileBagClick"],["title":"我的收藏", "imgName":"yxs_mine_setting", "action":"myCollectClick"]]
        #else
        var section3 = [["title":"常见问题", "imgName":"yxs_mine_question", "action":"questionClick"],["title":"推荐优学业", "imgName":"yxs_mine_recommend", "action":"recommendClick"],["title":"设置", "imgName":"yxs_mine_setting", "action":"settingClick"]]
        #endif
        
//        arr = [["title":"常见问题", "imgName":"yxs_mine_question", "action":"questionClick"], ["title":"设置", "imgName":"yxs_mine_setting", "action":"settingClick"],["title":"夜间模式", "imgName":"yxs_mine_theme", "action":""]]
//        arr = [["title":"问题反馈", "imgName":"yxs_mine_feedback", "action":"feedbackClick"], ["title":"隐私政策", "imgName":"yxs_mine_privacy", "action":"privacyPolicyClick"], ["title":"设置", "imgName":"yxs_mine_setting", "action":"settingClick"]]
        return [section1, section2, section3]
        
    }()
    
//    lazy var headerView: YXSMineHeaderView = {
//        let view = YXSMineHeaderView()
//        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 127)
//        return view
//    }()
}

// MARK: -
class MineTableViewHeader: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.addSubview(infoView)
        infoView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        
//        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
//            self.contentView.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 10)
//        }
    }
    
    func refreshData() {
        infoView.refreshData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var infoView: YXSMineHeaderView = {
        let view = YXSMineHeaderView()
        return view
    }()
    
    
}
