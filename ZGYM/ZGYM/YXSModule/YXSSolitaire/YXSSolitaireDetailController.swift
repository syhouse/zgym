//
//  YXSSolitaireDetailController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/3.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper

class YXSSolitaireDetailController: YXSBaseTableViewController {

    var headerSelectedIndex: Int = 0
    var censusId: Int?
    var classId: Int?
    var childrenId: Int?
    var serviceCreateTime: String?
    var header: SolitaireDetailHeaderView?
    
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
        self.tableView.register(SolitaireDetailHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "SolitaireDetailHeaderView")
        self.tableView.register(YXSHomeworkReadListSectionHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: "YXSHomeworkReadListSectionHeader")

        
        self.tableView.register(YXSDetailNormalCell.classForCoder(), forCellReuseIdentifier: "YXSDetailNormalCell")
        self.tableView.register(YXSDetailContactCell.classForCoder(), forCellReuseIdentifier: "YXSDetailContactCell")
        self.tableView.register(YXSDetailCenterTitleCell.classForCoder(), forCellReuseIdentifier: "YXSDetailCenterTitleCell")
        self.tableView.register(YXSDetailAllTitleCell.classForCoder(), forCellReuseIdentifier: "YXSDetailAllTitleCell")
        self.tableView.register(YXSDetailAllTitleCell2.classForCoder(), forCellReuseIdentifier: "YXSDetailAllTitleCell2")

        setupRightBarButtonItem()
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
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            MBProgressHUD.yxs_showLoading(ignore: true)
            YXSEducationCensusTeacherStaffListRequest(censusId: self.censusId ?? 0).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                MBProgressHUD.yxs_hideHUD()
                
                weakSelf.joinCensusResponseList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["joinCensusResponseList"].rawString()!) ?? [YXSClassMemberModel]()
                weakSelf.notJoinCensusResponseList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["notJoinCensusResponseList"].rawString()!) ?? [YXSClassMemberModel]()
                weakSelf.checkEmptyData()
                
            }) { (msg, code) in
                    MBProgressHUD.yxs_showMessage(message: msg)
            }
            
        } else {
            MBProgressHUD.yxs_showLoading(ignore: true)
            YXSEducationCensusParentStaffListRequest(censusId: self.censusId ?? 0).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                MBProgressHUD.yxs_hideHUD()
                
                weakSelf.joinCensusResponseList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["joinCensusResponseList"].rawString()!) ?? [YXSClassMemberModel]()
                weakSelf.notJoinCensusResponseList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["notJoinCensusResponseList"].rawString()!) ?? [YXSClassMemberModel]()
                weakSelf.checkEmptyData()
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        
    }
    
    override func yxs_onBackClick() {
        super.yxs_onBackClick()
        YXSSSAudioPlayer.sharedInstance.stopVoice()
    }
    
    // MARK: - Request
    @objc func reminderRequest() {
        var childrenIdList:[Int] = [Int]()
        for sub in notJoinCensusResponseList ?? [YXSClassMemberModel]() {
            childrenIdList.append(sub.childrenId ?? 0)
        }
        MBProgressHUD.yxs_showLoading()
        YXSEducationTeacherOneTouchReminderRequest(childrenIdList: childrenIdList, classId: classId ?? 0, opFlag: 1, serviceId: censusId ?? 0, serviceType: 3, serviceCreateTime: serviceCreateTime ?? "").request({ (json) in
            MBProgressHUD.yxs_showMessage(message: "通知成功")
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Setter
    var detailModel: YXSHomeworkDetailModel? {
        didSet {
            tableView.reloadData()
//            self.bottomBtnView.btnCommit.layer.removeFromSuperlayer()

            if self.detailModel?.state == 100 {
                self.bottomBtnView.btnCommit.setTitle("已结束", for: .disabled)
                self.bottomBtnView.btnCommit.isEnabled = false
                self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
//                header?.btnSolitaire.setTitle("已结束", for: .disabled)
////                header?.btnSolitaire.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
//                header?.btnSolitaire.isEnabled = false
//                header?.btnSolitaire.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 50), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 25)
            }
            else if self.detailModel?.state == 10 {
                self.bottomBtnView.btnCommit.setTitle("我来接龙", for: .normal)
                self.bottomBtnView.btnCommit.isEnabled = true
                self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 21)
            }
            else {
                self.bottomBtnView.btnCommit.setTitle("已提交", for: .disabled)
                self.bottomBtnView.btnCommit.isEnabled = false
                self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
            }
            if YXSPersonDataModel.sharePerson.personRole == .PARENT {
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                    self.bottomBtnView.isHidden = false
//                }
            }

        }
    }
    
    var joinCensusResponseList: [YXSClassMemberModel]? {
        didSet {
            /// 设置提交按钮置灰
            if YXSPersonDataModel.sharePerson.personRole == .PARENT {
                for sub in self.joinCensusResponseList ?? [YXSClassMemberModel]() {
                    if sub.childrenId == childrenId {
                        self.bottomBtnView.btnCommit.isEnabled = false
                        self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
                    }
                }
                self.bottomBtnView.btnCommit.isHidden = false
            }
            tableView.reloadData()
        }
    }
    
    var notJoinCensusResponseList: [YXSClassMemberModel]? {
        didSet {
            tableView.reloadData()
        }
    }
//    var joinCensusResponseList:[YXSClassMemberModel]?
//    var notJoinCensusResponseList:[YXSClassMemberModel]?
//    var detailModel:YXSHomeworkDetailModel?
    
    // MARK: - Action
    @objc func yxs_solitaireClick(sender: YXSButton) {
        var defaultIndex = -1
        if detailModel?.optionList?.count == 1 {
            defaultIndex = 0
        }
        YXSSolitaireSelectReasonView(items: detailModel?.optionList ?? [String](), selectedIndex: defaultIndex, title: "选择", inTarget: self.view) { [weak self](view, index) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_showLoading()
            YXSEducationCensusParentCommitRequest(censusId: weakSelf.censusId ?? 0, childrenId: weakSelf.childrenId ?? 0, option: weakSelf.detailModel?.optionList?[index] ?? "").request({ (json) in
                MBProgressHUD.yxs_hideHUD()
                MBProgressHUD.yxs_showMessage(message: "接龙成功")
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationIdKey: weakSelf.censusId ?? 0])
                UIUtil.yxs_reduceAgenda(serviceId: weakSelf.censusId ?? 0, info: [kEventKey:YXSHomeType.solitaire])
                weakSelf.yxs_refreshData()
                weakSelf.navigationController?.yxs_existViewController(existClass: YXSSolitaireListController(classId: 0, childId: 0), complete: { (isExist, vc) in
                    vc.yxs_refreshData()
                })

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.01) {
                    view.cancelClick()
                }

            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
//        YXSSolitaireSelectReasonView(items: detailModel?.optionList ?? [String](), inTarget: self.view) { [weak self](view, index) in
//            guard let weakSelf = self else {return}
//            MBProgressHUD.yxs_showLoading()
//            YXSEducationCensusParentCommitRequest(censusId: weakSelf.censusId ?? 0, childrenId: weakSelf.childrenId ?? 0, option: weakSelf.detailModel?.optionList?[index] ?? "").request({ (json) in
//                MBProgressHUD.yxs_hideHUD()
//                MBProgressHUD.yxs_showMessage(message: "接龙成功")
//                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationIdKey: weakSelf.censusId ?? 0])
//                UIUtil.yxs_reduceAgenda(serviceId: weakSelf.censusId ?? 0, info: [kEventKey:HomeType.solitaire])
//                weakSelf.yxs_refreshData()
//                weakSelf.navigationController?.yxs_existViewController(existClass: YXSSolitaireListController(classId: 0, childId: 0), complete: { (isExist, vc) in
//                    vc.yxs_refreshData()
//                })
//
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.89) {
//                    view.cancelClick()
//
//                }
//
//            }) { (msg, code) in
//                MBProgressHUD.yxs_showMessage(message: msg)
//            }
//        }
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
        let list: [YXSClassMemberModel] = (headerSelectedIndex == 0 ? notJoinCensusResponseList : joinCensusResponseList) ?? [YXSClassMemberModel]()
        let model = list[sender.tag]
        UIUtil.yxs_callPhoneNumberRequest(childrenId: model.childrenId ?? 0, classId: detailModel?.classId ?? 0)
    }
    
    @objc func yxs_chatClick(sender:YXSButton) {
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            let list: [YXSClassMemberModel] = (headerSelectedIndex == 0 ? notJoinCensusResponseList : joinCensusResponseList) ?? [YXSClassMemberModel]()
            let model = list[sender.tag]
            UIUtil.yxs_chatImRequest(childrenId: model.childrenId ?? 0, classId: detailModel?.classId ?? 0)
        }
    }
    
     // MARK: - Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
            
        } else {
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                return (headerSelectedIndex == 0 ? notJoinCensusResponseList?.count : joinCensusResponseList?.count) ?? 0
                
            } else {
                return (headerSelectedIndex == 0 ? joinCensusResponseList?.count : notJoinCensusResponseList?.count) ?? 0
            }

        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            let list: [YXSClassMemberModel] = (headerSelectedIndex == 0 ? notJoinCensusResponseList : joinCensusResponseList) ?? [YXSClassMemberModel]()
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
            let list: [YXSClassMemberModel] = (headerSelectedIndex == 0 ? joinCensusResponseList : notJoinCensusResponseList) ?? [YXSClassMemberModel]()
            let cModel = list[indexPath.row]
            
            if headerSelectedIndex == 0 {
                let cell:YXSDetailAllTitleCell = tableView.dequeueReusableCell(withIdentifier: "YXSDetailAllTitleCell") as! YXSDetailAllTitleCell
                cell.lbTitle.text = childrenId == cModel.childrenId ? "我" : cModel.realName
                cell.lbSubTitle.text = "\(cModel.option ?? "")"
                cell.lbRightTitle.text = cModel.commitTime?.yxs_DayTime()//03.04
                cell.imgAvatar.sd_setImage(with: URL(string: cModel.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
                return cell
                
            } else {
                let cell:YXSDetailNormalCell = tableView.dequeueReusableCell(withIdentifier: "YXSDetailNormalCell") as! YXSDetailNormalCell
                cell.lbTitle.text = childrenId == cModel.childrenId ? "我" : cModel.realName
                cell.imgAvatar.sd_setImage(with: URL(string: cModel.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
                return cell
            }
        }
    }

    var lastOffset: CGPoint = CGPoint(x: 0, y: 0)
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SolitaireDetailHeaderView") as! SolitaireDetailHeaderView
            header?.avatarView.imgAvatar.sd_setImage(with: URL(string: detailModel?.teacherAvatar ?? ""), placeholderImage: kImageUserIconTeacherDefualtImage)
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
            header?.linkView.block = { [weak self](url) in
                guard let weakSelf = self else {return}
                let tmpStr = YXSObjcTool.shareInstance().getCompleteWebsite(url)
                let newUrl = tmpStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                UIApplication.shared.openURL(URL(string: newUrl)!)
            }
            return header
        
        } else {
            let header: YXSHomeworkReadListSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YXSHomeworkReadListSectionHeader") as! YXSHomeworkReadListSectionHeader
            
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                header.btnTitle1.setTitle("未接龙（\(notJoinCensusResponseList?.count ?? 0)）", for: .normal)
                header.btnTitle2.setTitle("已接龙（\(joinCensusResponseList?.count ?? 0)）", for: .normal)
                
            } else {
                header.btnTitle1.setTitle("已接龙（\(joinCensusResponseList?.count ?? 0)）", for: .normal)
                header.btnTitle2.setTitle("未接龙（\(notJoinCensusResponseList?.count ?? 0)）", for: .normal)
            }

            if YXSPersonDataModel.sharePerson.personRole == .TEACHER && headerSelectedIndex == 0 && notJoinCensusResponseList?.count ?? 0 > 0 && detailModel?.state != 100 {
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
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    
//    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
//        return true
//    }
    // MARK: - LazyLoad
//    lazy var btnSolitaire: YXSButton = {
//        let btn = YXSButton()
//        btn.isHidden = true
//        btn.setTitle("我来接龙", for: .normal)
//        btn.setTitle("已提交", for: .disabled)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
//        btn.cornerRadius = 25
//        btn.setMixedTitleColor(MixedColor(normal: 0xFEFEFF, night: 0xFEFEFF), forState: .normal)
//        btn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 50), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 25)
//        btn.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 50), color: UIColor.gray, cornerRadius: 25, offset: CGSize(width: 4, height: 4))
//        return btn
//    }()

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
            list = (headerSelectedIndex == 0 ? notJoinCensusResponseList : joinCensusResponseList) ?? [YXSClassMemberModel]()
            
        } else {
            list = (headerSelectedIndex == 0 ? joinCensusResponseList : notJoinCensusResponseList) ?? [YXSClassMemberModel]()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class SolitaireDetailHeaderView: UITableViewHeaderFooterView {

    var videoTouchedBlock:((_ videoUlr: String)->())?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightForegroundColor)
        
        self.contentView.addSubview(avatarView)
        self.contentView.addSubview(mediaView)
        self.contentView.addSubview(linkView)
        self.contentView.addSubview(dateView)

        mediaView.videoTouchedHandler = { [weak self](url) in
            guard let weakSelf = self else {return}
            weakSelf.videoTouchedBlock?(url)
        }

        
        avatarView.snp.makeConstraints({ (make) in
            make.top.equalTo(17)
            make.left.equalTo(15)
            make.right.equalTo(0)
            make.height.equalTo(42)
        })
        
        dateView.snp.makeConstraints({ (make) in
            make.top.equalTo(avatarView.snp_bottom).offset(15)
            make.left.equalTo(15)
            make.height.equalTo(20)
            make.right.equalTo(-15)
        })
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            mediaView.snp.makeConstraints({ (make) in
                make.top.equalTo(dateView.snp_bottom).offset(19)
                make.left.equalTo(15)
                make.right.equalTo(-15)
            })
            
            linkView.snp.makeConstraints({ (make) in
                make.top.equalTo(mediaView.snp_bottom).offset(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(44)
                make.bottom.equalTo(-23)
            })
            
        } else {
            mediaView.snp.makeConstraints({ (make) in
                make.top.equalTo(dateView.snp_bottom).offset(19)
                make.left.equalTo(15)
                make.right.equalTo(-15)
            })
            
            self.linkView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.mediaView.snp_bottom).offset(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(44)
                make.bottom.equalTo(-27)
            })
            
//            btnSolitaire.snp.makeConstraints({ (make) in
//                make.top.equalTo(linkView.snp_bottom).offset(53)
//                make.centerX.equalTo(self.contentView.snp_centerX)
//                make.width.equalTo(318)
//                make.height.equalTo(50)
//                make.bottom.equalTo(-27)
//            })
        }
        
        let cl = NightNight.theme == .night ? kNightBackgroundColor : kTableViewBackgroundColor
//        self.contentView.yxs_addLine(position: .top, color: cl, leftMargin: 0, rightMargin: 0, lineHeight: 10)
        self.contentView.yxs_addLine(position: .bottom, color: cl, leftMargin: 0, rightMargin: 0, lineHeight: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var avatarView: YXSAvatarView = {
        let view = YXSAvatarView()
        return view
    }()
    
    lazy var dateView: YXSCustomImageControl = {
        let view = YXSCustomImageControl(imageSize: CGSize(width: 19, height: 17), position: YXSImagePositionType.left)
        view.locailImage = "yxs_solitaire_calendar"
        view.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    lazy var mediaView: YXSMediaView = {
        let view = YXSMediaView()
        return view
    }()
    
    lazy var linkView: YXSLinkView = {
        let link = YXSLinkView()
        link.isHidden = true
        return link
    }()
    

}
