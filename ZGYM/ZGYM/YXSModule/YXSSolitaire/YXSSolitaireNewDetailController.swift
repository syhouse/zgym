//
//  YXSSolitaireNewDetailController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/2.
//  Copyright © 2020 zgym. All rights reserved.
//
import UIKit
import NightNight
import ObjectMapper

class YXSSolitaireNewDetailController: YXSBaseTableViewController {
    
    var headerSelectedIndex: Int = 0
    var censusId: Int?
    var classId: Int?
    var childrenId: Int?
    var serviceCreateTime: String?
    var header: YXSSolitaireNewDetailHeaderView?
    
    var sectionDataRequestSucess: Bool = false
    
    ///家长采集题目model
    var solitaireGatherHoldersModel: YXSSolitaireGatherHoldersModel?
    ///家长采集题目数组
    var solitairePartentCollectorItems = [YXSSolitaireQuestionModel]()
    
//    var censusCommitGatherResponseList
    ///家长当前提交的id
    var censusCommitId: Int?
    
    var lastOffset: CGPoint = CGPoint(x: 0, y: 0)
    
    init(censusId: Int = 0, childrenId: Int = 0, classId: Int, serviceCreateTime: String = "") {
        super.init()
        self.censusId = censusId
        self.childrenId = childrenId
        self.classId = classId
        self.serviceCreateTime = serviceCreateTime
        UIUtil.yxs_reduceHomeRed(serviceId: censusId, childId: childrenId )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        YXSSSAudioPlayer.sharedInstance.stopVoice()
    }
    
    override func viewDidLoad() {
        self.hasRefreshHeader = false
        self.showBegainRefresh = false
        super.viewDidLoad()
        self.title = "接龙详情"
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
        } else {
            self.view.addSubview(bottomBtnView)
            //            bottomBtnView.isHidden = false
            bottomBtnView.snp.makeConstraints({ (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(0)
                make.height.equalTo(62)
            })
            self.tableView.snp.remakeConstraints { (make) in
                make.top.equalTo(0)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(self.bottomBtnView.snp_top)
            }
        }
        // Do any additional setup after loading the view.
        self.tableView.register(YXSSolitaireNewDetailHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "YXSSolitaireNewDetailHeaderView")
        self.tableView.register(YXSHomeworkReadListSectionHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: "YXSHomeworkReadListSectionHeader")
        self.tableView.register(YXSSolitaireCollectorSectionHeader.self, forHeaderFooterViewReuseIdentifier: "YXSSolitaireCollectorSectionHeader")
        self.tableView.estimatedRowHeight = 60
        
        self.tableView.register(YXSDetailNormalCell.classForCoder(), forCellReuseIdentifier: "YXSDetailNormalCell")
        self.tableView.register(YXSDetailNormalRecallCell.classForCoder(), forCellReuseIdentifier: "YXSDetailNormalRecallCell")
        self.tableView.register(YXSDetailContactCell.classForCoder(), forCellReuseIdentifier: "YXSDetailContactCell")
        self.tableView.register(YXSDetailCenterTitleCell.classForCoder(), forCellReuseIdentifier: "YXSDetailCenterTitleCell")
        self.tableView.register(YXSDetailSubTitleBottomCell.classForCoder(), forCellReuseIdentifier: "YXSDetailSubTitleBottomCell")
        self.tableView.register(YXSDetailAllTitleCell2.classForCoder(), forCellReuseIdentifier: "YXSDetailAllTitleCell2")
        self.tableView.register(YXSSolitaireCollectorPartentDetialCell.self, forCellReuseIdentifier: "YXSSolitaireCollectorPartentDetialCell")
        
        
        setupRightBarButtonItem()
        self.detailModel = YXSCacheHelper.yxs_getCacheSolitaireDetailTask(censusId: censusId ?? 0, childrenId: childrenId ?? 0)
        self.censusPartakeResponseList = YXSCacheHelper.yxs_getCacheSolitaireJoinStaffListTask(censusId: censusId ?? 0)
        self.censusNoPartakeResponseList = YXSCacheHelper.yxs_getCacheSolitaireNotJoinStaffListTask(censusId: censusId ?? 0)
        yxs_refreshData()
        
    }
    
    func setupRightBarButtonItem() {
        let btnShare = YXSButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        btnShare.setMixedImage(MixedImage(normal: "yxs_punchCard_share", night: "yxs_punchCard_share_white"), forState: .normal)
        btnShare.setMixedImage(MixedImage(normal: "yxs_punchCard_share", night: "yxs_punchCard_share_white"), forState: .highlighted)
        btnShare.addTarget(self, action: #selector(yxs_shareClick(sender:)), for: .touchUpInside)
        let navShareItem = UIBarButtonItem(customView: btnShare)
        
        //        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
        //            let btnMore = YXSButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        //            btnMore.setMixedImage(MixedImage(normal: "yxs_homework_more", night: "yxs_homework_more_night"), forState: .normal)
        //            btnMore.setMixedImage(MixedImage(normal: "yxs_homework_more", night: "yxs_homework_more_night"), forState: .highlighted)
        //            btnMore.addTarget(self, action: #selector(yxs_moreClick(sender:)), for: .touchUpInside)
        //            let navItem = UIBarButtonItem(customView: btnMore)
        //            self.navigationItem.rightBarButtonItems = [navItem, navShareItem]
        //
        //        } else {
        self.navigationItem.rightBarButtonItems = [navShareItem]
        //        }
    }
    
    override func yxs_refreshData() {
        
        MBProgressHUD.yxs_showLoading(ignore: true)
        YXSEducationCensusCensusDetailRequest(censusId: censusId ?? 0, childrenId: childrenId ?? 0).request({ [weak self](model: YXSHomeworkDetailModel) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            weakSelf.detailModel = model
            YXSCacheHelper.yxs_cacheSolitaireDetailTask(model: model, censusId: weakSelf.censusId ?? 0, childrenId: weakSelf.childrenId ?? 0)
            
            MBProgressHUD.yxs_showLoading(ignore: true)
            
            if model.type == 2{
                YXSEducationCensusPartakeOrNoPartakeRequest(censusId: weakSelf.censusId ?? 0).request({ [weak self](json) in
                    guard let strongSelf = self else {return}
                    MBProgressHUD.yxs_hideHUD()
                    strongSelf.sectionDataRequestSucess = true
                    strongSelf.censusPartakeResponseList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["censusPartakeResponseList"].rawString()!) ?? [YXSClassMemberModel]()
                    strongSelf.censusNoPartakeResponseList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["censusNoPartakeResponseList"].rawString()!) ?? [YXSClassMemberModel]()
                    //                YXSCacheHelper.yxs_cacheSolitaireJoinStaffListTask(dataSource: strongSelf.censusPartakeResponseList ?? [YXSClassMemberModel](), censusId: weakSelf.censusId ?? 0)
                    //                YXSCacheHelper.yxs_cacheSolitaireNotJoinStaffListTask(dataSource: strongSelf.censusNoPartakeResponseList ?? [YXSClassMemberModel](), censusId: weakSelf.censusId ?? 0)
                    strongSelf.checkEmptyData()
                    
                }) { (msg, code) in
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
            }else{
                YXSEducationCensusParentGatherDetailRequest(censusId: weakSelf.censusId ?? 0, childrenId: weakSelf.childrenId ?? 0).request({ [weak self](json) in
                    guard let strongSelf = self else {return}
                    MBProgressHUD.yxs_hideHUD()
                    strongSelf.sectionDataRequestSucess = true
                    strongSelf.solitaireGatherHoldersModel = Mapper<YXSSolitaireGatherHoldersModel>().map(JSONString: json["censusGatherJsonData"].rawString()!)
                    strongSelf.configPartentCollectorData()
                    strongSelf.tableView.reloadData()
                    
                }) { (msg, code) in
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
            }
            
            
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
        
        
    }
    
    // MARK: - Request
    @objc func reminderRequest() {
        var childrenIdList:[Int] = [Int]()
        for sub in censusNoPartakeResponseList ?? [YXSClassMemberModel]() {
            childrenIdList.append(sub.childrenId ?? 0)
        }
        MBProgressHUD.yxs_showLoading()
        YXSEducationTeacherOneTouchReminderRequest(childrenIdList: childrenIdList, classId: classId ?? 0, opFlag: 1, serviceId: censusId ?? 0, serviceType: 3, serviceCreateTime: serviceCreateTime ?? "").request({ (json) in
            MBProgressHUD.yxs_showMessage(message: "通知成功")
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    @objc func recallRequest(){
        MBProgressHUD.yxs_showLoading()
        YXSEducationCensusParentWithdrawCommitRequest.init(censusId: censusId ?? 0, censusCommitId: censusCommitId ?? 0, childrenId: childrenId ?? 0).request({ (result) in
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationStudentCancelSolitaireNotification), object: [kNotificationIdKey: self.censusId ?? 0])
            self.yxs_refreshData()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Setter
    var detailModel: YXSHomeworkDetailModel? {
        didSet {
            tableView.reloadData()
            
            if self.detailModel?.state == 100 {
                self.bottomBtnView.btnCommit.setTitle("已结束", for: .disabled)
                self.bottomBtnView.btnCommit.isEnabled = false
                self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
            }
            else if self.detailModel?.state == 10 {
                self.bottomBtnView.btnCommit.setTitle("我来接龙", for: .normal)
                self.bottomBtnView.btnCommit.isEnabled = true
                self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 21)
            }
            else {
                if detailModel?.type == 3{
                    self.bottomBtnView.btnCommit.setTitle("已接龙,重新提交", for: .normal)
                    self.bottomBtnView.btnCommit.isEnabled = true
                    self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 21)
                }else{
                    self.bottomBtnView.btnCommit.setTitle("已接龙", for: .normal)
                    self.bottomBtnView.btnCommit.isEnabled = false
                    self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
                }
            }
            if YXSPersonDataModel.sharePerson.personRole == .PARENT {
                self.bottomBtnView.isHidden = false
            }
            
        }
    }
    
    var censusPartakeResponseList: [YXSClassMemberModel]? {
        didSet {
            /// 设置提交按钮置灰
            if YXSPersonDataModel.sharePerson.personRole == .PARENT {
                
            }
            tableView.reloadData()
        }
        
        //        for sub in self.joinCensusResponseList ?? [YXSClassMemberModel]() {
        //            if sub.childrenId == childrenId {
        //                self.bottomBtnView.btnCommit.isEnabled = false
        //                self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
        //            }
        //        }
        //        self.bottomBtnView.btnCommit.isHidden = false
    }
    
    var censusNoPartakeResponseList: [YXSClassMemberModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Action
    @objc func yxs_solitaireClick(sender: YXSButton) {
        var optionLists = [YXSSelectModel]()
        if let optionList = detailModel?.optionList{
            for item in optionList{
                optionLists.append(YXSSelectModel.init(text: item))
            }
            
        }
        YXSSolitaireSelectApplyView(items: optionLists, inTarget: self.view) {  [weak self] (view, index, remark) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_showLoading()
            
            var request: YXSBaseRequset!
            var message = ""
            if weakSelf.detailModel?.state == 20{
                request = YXSEducationCensusParentPartakeCommitRequest(censusId: weakSelf.censusId ?? 0, childrenId: weakSelf.childrenId ?? 0, option: weakSelf.detailModel?.optionList?[index] ?? "", remark: remark)
                message = "接龙成功"
            }else{
                request = YXSEducationCensusParentCommitRequest(censusId: weakSelf.censusId ?? 0, childrenId: weakSelf.childrenId ?? 0, option: weakSelf.detailModel?.optionList?[index] ?? "", remark: remark)
                message = "修改成功"
            }
            
            request.request({ (json) in
                MBProgressHUD.yxs_hideHUD()
                MBProgressHUD.yxs_showMessage(message: message)
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationIdKey: weakSelf.censusId ?? 0])
                UIUtil.yxs_reduceAgenda(serviceId: weakSelf.censusId ?? 0, info: [kEventKey:YXSHomeType.solitaire])
                weakSelf.yxs_refreshData()
                weakSelf.navigationController?.yxs_existViewController(existClass: YXSSolitaireListController(classId: 0, childId: 0), complete: { (isExist, vc) in
                    if vc != nil {
                        vc!.yxs_refreshData()
                    }
                })
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.01) {
                    view.cancelClick()
                }
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
    }
    
    @objc func yxs_shareClick(sender: YXSButton) {
        let model = HMRequestShareModel(censusId: censusId ?? 0)
        MBProgressHUD.yxs_showLoading()
        YXSEducationShareLinkRequest(model: model).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            let strUrl = json.stringValue
            let title = "\(weakSelf.detailModel?.teacherName ?? "")布置的接龙!"
            let dsc = "\(weakSelf.detailModel?.content ?? "")"
            let shareModel = YXSShareModel(title: title, descriptionText: dsc, link: strUrl)
            YXSShareTool.showCommonShare(shareModel: shareModel)
        }) { (msg, code ) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    @objc func yxs_moreClick(sender: YXSButton) {
        sender.isEnabled = false
        let title = detailModel?.isTop == 0 ? "置顶" : "取消置顶"
        YXSSetTopAlertView.showIn(target: self.view, topButtonTitle:title) { [weak self](btn) in
            guard let weakSelf = self else {return}
            
            sender.isEnabled = true
            
            if btn.titleLabel?.text == title {
                let isTop = weakSelf.detailModel?.isTop == 0 ? 1 : 0
                
                UIUtil.yxs_loadUpdateTopData(type: .solitaire, id: weakSelf.censusId ?? 0, createTime: weakSelf.detailModel?.createTime ?? "", isTop: isTop, positon: .detial) {
                    weakSelf.detailModel?.isTop = isTop
                }
            }
        }
    }
    
    @objc func yxs_callUpClick(sender:YXSButton) {
        let list: [YXSClassMemberModel] = (headerSelectedIndex == 0 ? censusNoPartakeResponseList : censusPartakeResponseList) ?? [YXSClassMemberModel]()
        let model = list[sender.tag]
        UIUtil.yxs_callPhoneNumberRequest(childrenId: model.childrenId ?? 0, classId: detailModel?.classId ?? 0)
    }
    
    @objc func yxs_chatClick(sender:YXSButton) {
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            let list: [YXSClassMemberModel] = (headerSelectedIndex == 0 ? censusNoPartakeResponseList : censusPartakeResponseList) ?? [YXSClassMemberModel]()
            let model = list[sender.tag]
            UIUtil.yxs_chatImRequest(childrenId: model.childrenId ?? 0, classId: detailModel?.classId ?? 0)
        }
    }
    
    @objc func recallClick(){
        //        YXSCommonAlertView.showAlert(title: "确定撤回打卡?", rightClick: {
        //            [weak self] in
        //            guard let strongSelf = self else { return }
        //            strongSelf.loadCancelData(section)
        //        })
        YXSCommonAlertView.showAlert(title: "请确认", message: "您是否取消接龙？", rightClick: {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.recallRequest()
        })
    }
    
    lazy var bottomBtnView: YXSBottomBtnView = {
        let view = YXSBottomBtnView()
        view.isHidden = true
        view.btnCommit.setTitle("我来接龙", for: .normal)
        view.btnCommit.addTarget(self, action: #selector(yxs_solitaireClick(sender:)), for: .touchUpInside)
        return view
    }()
    
    // MARK: - Other
    @objc func checkEmptyData() {
        let list: [YXSClassMemberModel]
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            list = (headerSelectedIndex == 0 ? censusNoPartakeResponseList : censusPartakeResponseList) ?? [YXSClassMemberModel]()
            
        } else {
            list = (headerSelectedIndex == 0 ? censusPartakeResponseList : censusNoPartakeResponseList) ?? [YXSClassMemberModel]()
        }
        
        if list.count == 0 {
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
            let imageView = UIImageView()
            imageView.mixedImage = MixedImage(normal: "yxs_defultImage_nodata", night: "yxs_defultImage_nodata_night")
            imageView.contentMode = .scaleAspectFit
            footer.addSubview(imageView)
            imageView.snp.makeConstraints({ (make) in
                make.edges.equalTo(0)
            })
            tableView.tableFooterView = footer
            
        } else {
            tableView.tableFooterView = nil
        }
    }
    
    // MARK: - tableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionDataRequestSucess ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
            
        } else {
            if detailModel?.type == 2{
                return (headerSelectedIndex == 0 ? censusPartakeResponseList?.count : censusNoPartakeResponseList?.count) ?? 0
            }else{
                return solitairePartentCollectorItems.count
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            let list: [YXSClassMemberModel] = (headerSelectedIndex == 0 ? censusNoPartakeResponseList : censusPartakeResponseList) ?? [YXSClassMemberModel]()
            let cModel = list[indexPath.row]
            
            if headerSelectedIndex == 0 {
                let cell:YXSDetailContactCell = tableView.dequeueReusableCell(withIdentifier: "YXSDetailContactCell") as! YXSDetailContactCell
                cell.lbTitle.text = childrenId == cModel.childrenId ? "我" : cModel.realName
                cell.imgAvatar.sd_setImage(with: URL(string: cModel.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
                cell.btnPhone.tag = indexPath.row
                cell.btnChat.tag = indexPath.row
                cell.btnPhone.addTarget(self, action: #selector(yxs_callUpClick(sender:)), for: .touchUpInside)
                cell.btnChat.addTarget(self, action: #selector(yxs_chatClick(sender:)), for: .touchUpInside)
                let cl = NightNight.theme == .night ? kNightBackgroundColor : kTableViewBackgroundColor
                cell.yxs_addLine(position: .bottom, color: cl, leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
                return cell
                
            } else {
                let cell:YXSDetailAllTitleCell2 = tableView.dequeueReusableCell(withIdentifier: "YXSDetailAllTitleCell2") as! YXSDetailAllTitleCell2
                cell.lbTitle.text = childrenId == cModel.childrenId ? "我" : cModel.realName
                cell.lbSubTitle.text = "\(cModel.commitTime?.yxs_DayTime() ?? "") \(cModel.option ?? "")"
                cell.imgAvatar.sd_setImage(with: URL(string: cModel.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
                cell.btnPhone.tag = indexPath.row
                cell.btnChat.tag = indexPath.row
                cell.btnPhone.addTarget(self, action: #selector(yxs_callUpClick(sender:)), for: .touchUpInside)
                cell.btnChat.addTarget(self, action: #selector(yxs_chatClick(sender:)), for: .touchUpInside)
                let cl = NightNight.theme == .night ? kNightBackgroundColor : kTableViewBackgroundColor
                cell.yxs_addLine(position: .bottom, color: cl, leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
                return cell
            }
            
        } else {
            if detailModel?.type == 2{
                let list: [YXSClassMemberModel] = (headerSelectedIndex == 0 ? censusPartakeResponseList : censusNoPartakeResponseList) ?? [YXSClassMemberModel]()
                let cModel = list[indexPath.row]
                
                let isShowRecall = cModel.childrenId == childrenId
                if isShowRecall{
                    censusCommitId = cModel.censusCommitId
                }
                
                if headerSelectedIndex == 0 {
                    let cell:YXSDetailSubTitleBottomCell = tableView.dequeueReusableCell(withIdentifier: "YXSDetailSubTitleBottomCell") as! YXSDetailSubTitleBottomCell
                    cell.lbTitle.text = childrenId == cModel.childrenId ? "我" : cModel.realName
                    cell.imgAvatar.sd_setImage(with: URL(string: cModel.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
                    cell.recallView.addTarget(self, action: #selector(recallClick), for: .touchUpInside)
                    cell.recallView.isHidden = !isShowRecall
                    cell.setRemarkTitle(remark: cModel.remark)
                    return cell
                    
                } else {
                    let cell:YXSDetailNormalRecallCell = tableView.dequeueReusableCell(withIdentifier: "YXSDetailNormalRecallCell") as! YXSDetailNormalRecallCell
                    cell.lbTitle.text = childrenId == cModel.childrenId ? "我" : cModel.realName
                    cell.imgAvatar.sd_setImage(with: URL(string: cModel.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
                    cell.recallView.addTarget(self, action: #selector(recallClick), for: .touchUpInside)
                    cell.recallView.isHidden = !isShowRecall
                    return cell
                }
            }else{
                let model = solitairePartentCollectorItems[indexPath.row]
                let cell:YXSSolitaireCollectorPartentDetialCell = tableView.dequeueReusableCell(withIdentifier: "YXSSolitaireCollectorPartentDetialCell") as! YXSSolitaireCollectorPartentDetialCell
                cell.setCellModel(model, index: indexPath.row)
                cell.refreshCell = {
                    [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.tableView.reloadData()
                }
                return cell
            }
            
        }
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YXSSolitaireNewDetailHeaderView") as? YXSSolitaireNewDetailHeaderView
            header?.avatarView.imgAvatar.sd_setImage(with: URL(string: detailModel?.teacherAvatar ?? ""), placeholderImage: kImageUserIconTeacherDefualtImage)
            header?.titleLabel.text = detailModel?.title
            header?.avatarView.lbTitle.text = detailModel?.teacherName//"王老师"
            header?.avatarView.lbSubTitle.text = detailModel?.createTime?.yxs_Time()//"1小时前"
            header?.dateView.title = "截止日期：\(detailModel?.endTime ?? "")"
            let mModel = YXSMediaViewModel()
            mModel.content = detailModel?.content
            mModel.voiceUrl = detailModel?.audioUrl
            mModel.voiceDuration = detailModel?.audioDuration
            var imgs:[String]? = nil
            if self.detailModel?.imageUrl?.count ?? 0 > 0 {
                imgs = self.detailModel?.imageUrl?.components(separatedBy: ",")
            }
            mModel.images = imgs
            mModel.videoUrl = detailModel?.videoUrl
            mModel.bgUrl = detailModel?.bgUrl
            header?.mediaView.model = mModel
            //            header?.btnSolitaire.addTarget(self, action: #selector(yxs_solitaireClick(sender:)), for: .touchUpInside)
            header?.videoTouchedBlock = { [weak self](url) in
                guard let weakSelf = self else {return}
                let vc = SLVideoPlayController()
                vc.videoUrl = url
                weakSelf.navigationController?.pushViewController(vc)
            }
            header?.linkView.strLink = detailModel?.link ?? ""
            if detailModel?.link == nil || detailModel?.link?.count == 0 {
                header?.linkView.isHidden = true
                header?.linkView.snp.updateConstraints({ (make) in
                    make.height.equalTo(0)
                })
                
            } else {
                header?.linkView.isHidden = false
                header?.linkView.snp.updateConstraints({ (make) in
                    make.height.equalTo(44)
                })
            }
            header?.linkView.block = { (url) in
                if url.count > 0 {
                    let tmpStr = YXSObjcTool.shareInstance().getCompleteWebsite(url)
                    if tmpStr.count > 0 {
                        var charSet = CharacterSet.urlQueryAllowed
                        charSet.insert(charactersIn: "#")
                        charSet.insert(charactersIn: "%")
                        let newUrl = tmpStr.addingPercentEncoding(withAllowedCharacters: charSet)!
                        UIApplication.shared.openURL(URL(string: newUrl)!)
                    } else {
                        MBProgressHUD.yxs_showMessage(message: "无法打开该链接")
                    }
                } else {
                    MBProgressHUD.yxs_showMessage(message: "无法打开该链接")
                }
            }
            return header
            
        } else {
            if detailModel?.type == 2{
                let header: YXSHomeworkReadListSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YXSHomeworkReadListSectionHeader") as! YXSHomeworkReadListSectionHeader
                
                header.btnTitle1.setTitle("参加\(censusPartakeResponseList?.count ?? 0)人", for: .normal)
                header.btnTitle2.setTitle("不参加\(censusNoPartakeResponseList?.count ?? 0)人", for: .normal)
                
                if YXSPersonDataModel.sharePerson.personRole == .TEACHER && headerSelectedIndex == 0 && censusNoPartakeResponseList?.count ?? 0 > 0 && detailModel?.state != 100 {
                    header.btnAlert.isHidden = false
                    
                } else {
                    header.btnAlert.isHidden = true
                }
                
                header.selectedIndex = headerSelectedIndex
                
                header.selectedBlock = {[weak self](index) in
                    guard let weakSelf = self else {return}
                    weakSelf.headerSelectedIndex = index
                    weakSelf.tableView.reloadData()
                    weakSelf.checkEmptyData()
                }
                
                header.alertClick = {[weak self](view) in
                    guard let weakSelf = self else {return}
                    weakSelf.reminderRequest()
                }
                return header
            }else{
                let header: YXSSolitaireCollectorSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YXSSolitaireCollectorSectionHeader") as! YXSSolitaireCollectorSectionHeader
                return header
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }


}

// MARK: - config data
extension YXSSolitaireNewDetailController{
    func configPartentCollectorData(){
        if let solitaireGatherHoldersModel = solitaireGatherHoldersModel{
            if let holders = solitaireGatherHoldersModel.gatherHolders{
                var solitaireQuestions = [YXSSolitaireQuestionModel]()
                for holder in holders{
                    let questionModel = YXSSolitaireQuestionModel(questionType: holder.questionType)
                    questionModel.questionStemText = holder.gatherHolderItem?.topicTitle
                    questionModel.isNecessary = holder.gatherHolderItem?.isRequired ?? false
                    if let optionItems = holder.gatherHolderItem?.censusTopicOptionItems{
                        var optionModels = [SolitairePublishNewSelectModel]()
                        for (index, optionItem) in optionItems.enumerated(){
                            let solitaireselectModel = SolitairePublishNewSelectModel()
                            solitaireselectModel.index = index
                            solitaireselectModel.title = optionItem.optionContext
                            let mediaModel = SLPublishMediaModel()
                            mediaModel.serviceUrl = optionItem.optionImage
                            solitaireselectModel.mediaModel = mediaModel
                            optionModels.append(solitaireselectModel)
                        }
                        questionModel.solitaireSelects = optionModels
                    }
                    solitaireQuestions.append(questionModel)
                }
                solitairePartentCollectorItems = solitaireQuestions
            }
        }
    }
    
}
