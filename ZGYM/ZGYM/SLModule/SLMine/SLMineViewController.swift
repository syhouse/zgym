//
//  SLMineViewController.swift
//  ZGYM
//
//  Created by mac_hm on 2019/11/16.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight
//import MBProgressHUD

class SLMineViewController: SLBaseTableViewController{//SLBaseViewController, UITableViewDelegate, UITableViewDataSource {
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
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        // Do any additional setup after loading the view.
        self.view.addSubview(self.tableView)
        self.tableView.register(SLMineTableViewCell.classForCoder(), forCellReuseIdentifier: "SLMineTableViewCell")
        self.tableView.register(SLMineSwitchTableViewCell.classForCoder(), forCellReuseIdentifier: "SLMineSwitchTableViewCell")
        self.tableView.register(SLMineTopCornerRadiusTableViewCell.classForCoder(), forCellReuseIdentifier: "SLMineTopCornerRadiusTableViewCell")
        self.tableView.register(SLMineBottomCornerRadiusTableViewCell.classForCoder(), forCellReuseIdentifier: "SLMineBottomCornerRadiusTableViewCell")
        
        
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
    @objc func editClick(sender: SLButton) {
        self.navigationController?.pushViewController(SLProfileViewController())
    }
    
    @objc func avatarClick(sender: SLButton) {
        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
            
        } else {
            let vc = SLMineChildrenListViewController()
            self.navigationController?.pushViewController(vc)
        }
    }
    
    /// 切换学段
    @objc func changeStage(sender: SLButton) {
        
        var selectedIndex: Int = 0
        if self.sl_user.stage == "KINDERGARTEN" {
            selectedIndex = 0
        } else if self.sl_user.stage == "PRIMARY_SCHOOL" {
            selectedIndex = 1
        } else {
            selectedIndex = 2
        }
        
        let alert = SLSolitaireSelectReasonView(items: ["幼儿园","小学","中学"], selectedIndex: selectedIndex, inTarget: self.view) { (view, index) in
            if selectedIndex == index {
                view.cancelClick(sender: SLButton())
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
            
            MBProgressHUD.sl_showLoading()
            SLEducationUserSwitchStageRequest(stage:stage).request({ (json) in
                MBProgressHUD.sl_hideHUD()
                MBProgressHUD.sl_showMessage(message: "修改成功")
                view.cancelClick(sender: SLButton())
                UIUtil.sl_loadUserDetailRequest({ (user) in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMineChangeStageNotification), object: nil)
                    self.sl_showTabRoot()
                    
                }) { (msg, code) in
                    MBProgressHUD.sl_showMessage(message: msg)
                }
                
            }) { (msg, code) in
                MBProgressHUD.sl_showMessage(message: msg)
            }
        }
        alert.lbTitle.text = "选择学段"
    }
    
    @objc func commentClick() {
        let vc = SLMineCommentViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func questionClick() {
        let vc = SLBaseWebViewController()
        vc.title = "常见问题"
        if SLPersonDataModel.sharePerson.personRole == .TEACHER { 
            vc.loadUrl = "http://www.ym698.com/lscj"
        
        } else {
            vc.loadUrl = "http://www.ym698.com/jzcj/"
        }
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func systemMessageClick() {
        self.navigationController?.pushViewController(SLSystemMessageViewController())
    }
    
    @objc func classListClick() {
        if SLPersonDataModel.sharePerson.personRole == .PARENT {
            self.navigationController?.pushViewController(SLParentClassListViewController())
        } else {
            self.navigationController?.pushViewController(SLTeacherClassListViewController())
        }
    }
    
    @objc func settingClick() {
        self.navigationController?.pushViewController(SLSettingViewController())
    }
    
    @objc func themeClick(sender:UISwitch) {
        UIUtil.changeTheme()
        NotificationCenter.default.post(name: NSNotification.Name(kThemeChangeNotification), object: nil)
    }
    
    @objc func feedbackClick() {
        let vc = SLMineFeedbackViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func privacyPolicyClick() {
        let vc = SLBaseWebViewController()
        vc.loadUrl = "\(sericeType.getH5Url())yszc.html"
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func recommendClick() {
        let strUrl = "https://edu-pro.ym698.com:50009/down/"
        let title = "优教育，优成长"
        let dsc = "我正在使用“优学生”APP进行家校沟通，赶快一起参与进来吧~"
        let shareModel = SLShareModel(title: title, descriptionText: dsc, link: strUrl)
        SLShareTool.showCommonShare(shareModel: shareModel)
    }
    
    // MARK: - loadData
    func loadUserData(){
        UIUtil.sl_loadUserDetailRequest({ [weak self](userModel: SLEducationUserModel) in
            guard let weakSelf = self else {return}
            if !SLChatHelper.sharedInstance.isLogin() {
                SLChatHelper.load()
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
        
        var cell:SLMineTableViewCell!
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "SLMineTableViewCell") as? SLMineTableViewCell
            cell.bgView.cornerRadius = 5
            
        } else if indexPath.section == 1 {
            let swtCell: SLMineSwitchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SLMineSwitchTableViewCell") as! SLMineSwitchTableViewCell
            swtCell.swt.isOn = NightNight.theme == .night ? true : false
            swtCell.bgView.cornerRadius = 5
            swtCell.swt.addTarget(self, action: #selector((themeClick(sender:))), for: .valueChanged)
            cell = swtCell
            
        } else {
            if indexPath.row == 0 {
                let firstCell: SLMineTopCornerRadiusTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SLMineTopCornerRadiusTableViewCell") as! SLMineTopCornerRadiusTableViewCell
                firstCell.bgView.sl_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor))
                cell = firstCell
                
            } else if indexPath.row == sectionArr.count-1 {
                let lastCell: SLMineBottomCornerRadiusTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SLMineBottomCornerRadiusTableViewCell") as! SLMineBottomCornerRadiusTableViewCell
                cell = lastCell
                
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "SLMineTableViewCell") as? SLMineTableViewCell
                cell.bgView.sl_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor))
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
////        ["title":"系统通知", "imgName":"sl_mine_notice", "action":"systemMessageClick"],
//        arr = [["title":"常见问题", "imgName":"sl_mine_question", "action":"questionClick"], ["title":"设置", "imgName":"sl_mine_setting", "action":"settingClick"],["title":"夜间模式", "imgName":"sl_mine_theme", "action":""]]
////        arr = [["title":"问题反馈", "imgName":"sl_mine_feedback", "action":"feedbackClick"], ["title":"隐私政策", "imgName":"sl_mine_privacy", "action":"privacyPolicyClick"], ["title":"设置", "imgName":"sl_mine_setting", "action":"settingClick"]]
//
//        return arr
//    }()
  
    
    lazy var dataSource: Array<Any> = {
        var arr: [[String: String]]!
//        ["title":"系统通知", "imgName":"sl_mine_notice", "action":"systemMessageClick"],
        var section1 = [["title":"我的班级", "imgName":"sl_mine_house", "action":"classListClick"]]
        
        var section2 = [["title":"夜间模式", "imgName":"sl_mine_theme", "action":""]]
        
        var section3 = [["title":"常见问题", "imgName":"sl_mine_question", "action":"questionClick"],["title":"推荐优学生", "imgName":"sl_mine_recommend", "action":"recommendClick"],["title":"设置", "imgName":"sl_mine_setting", "action":"settingClick"]]
//        arr = [["title":"常见问题", "imgName":"sl_mine_question", "action":"questionClick"], ["title":"设置", "imgName":"sl_mine_setting", "action":"settingClick"],["title":"夜间模式", "imgName":"sl_mine_theme", "action":""]]
//        arr = [["title":"问题反馈", "imgName":"sl_mine_feedback", "action":"feedbackClick"], ["title":"隐私政策", "imgName":"sl_mine_privacy", "action":"privacyPolicyClick"], ["title":"设置", "imgName":"sl_mine_setting", "action":"settingClick"]]
        return [section1, section2, section3]
        
    }()
    
//    lazy var headerView: SLMineHeaderView = {
//        let view = SLMineHeaderView()
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
        
//        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
//            self.contentView.sl_addLine(position: .bottom, color: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 10)
//        }
    }
    
    func refreshData() {
        infoView.refreshData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var infoView: SLMineHeaderView = {
        let view = SLMineHeaderView()
        return view
    }()
    
    
}
