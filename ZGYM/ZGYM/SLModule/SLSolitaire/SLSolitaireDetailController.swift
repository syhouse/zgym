//
//  SLSolitaireDetailController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/3.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper

class SLSolitaireDetailController: SLBaseTableViewController {

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
        UIUtil.sl_reduceHomeRed(serviceId: censusId, childId: childrenId )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.hasRefreshHeader = false
        self.showBegainRefresh = false
        super.viewDidLoad()
        self.title = "接龙详情"

        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
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
        self.tableView.register(SLHomeworkReadListSectionHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: "SLHomeworkReadListSectionHeader")

        
        self.tableView.register(SLDetailNormalCell.classForCoder(), forCellReuseIdentifier: "SLDetailNormalCell")
        self.tableView.register(SLDetailContactCell.classForCoder(), forCellReuseIdentifier: "SLDetailContactCell")
        self.tableView.register(SLDetailCenterTitleCell.classForCoder(), forCellReuseIdentifier: "SLDetailCenterTitleCell")
        self.tableView.register(SLDetailAllTitleCell.classForCoder(), forCellReuseIdentifier: "SLDetailAllTitleCell")
        self.tableView.register(SLDetailAllTitleCell2.classForCoder(), forCellReuseIdentifier: "SLDetailAllTitleCell2")

        setupRightBarButtonItem()
        sl_refreshData()
    }
    
    func setupRightBarButtonItem() {
        let btnShare = SLButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        btnShare.setMixedImage(MixedImage(normal: "sl_punchCard_share", night: "sl_punchCard_share_white"), forState: .normal)
        btnShare.setMixedImage(MixedImage(normal: "sl_punchCard_share", night: "sl_punchCard_share_white"), forState: .highlighted)
        btnShare.addTarget(self, action: #selector(sl_shareClick(sender:)), for: .touchUpInside)
        let navShareItem = UIBarButtonItem(customView: btnShare)
        
//        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
//            let btnMore = SLButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
//            btnMore.setMixedImage(MixedImage(normal: "sl_homework_more", night: "sl_homework_more_night"), forState: .normal)
//            btnMore.setMixedImage(MixedImage(normal: "sl_homework_more", night: "sl_homework_more_night"), forState: .highlighted)
//            btnMore.addTarget(self, action: #selector(sl_moreClick(sender:)), for: .touchUpInside)
//            let navItem = UIBarButtonItem(customView: btnMore)
//            self.navigationItem.rightBarButtonItems = [navItem, navShareItem]
//
//        } else {
            self.navigationItem.rightBarButtonItems = [navShareItem]
//        }
    }
    
    override func sl_refreshData() {
        
        MBProgressHUD.sl_showLoading(ignore: true)
        SLEducationCensusCensusDetailRequest(censusId: censusId ?? 0, childrenId: childrenId ?? 0).request({ [weak self](model: SLHomeworkDetailModel) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_hideHUD()
            weakSelf.detailModel = model
            
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
        
        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
            MBProgressHUD.sl_showLoading(ignore: true)
            SLEducationCensusTeacherStaffListRequest(censusId: self.censusId ?? 0).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                MBProgressHUD.sl_hideHUD()
                
                weakSelf.joinCensusResponseList = Mapper<SLClassMemberModel>().mapArray(JSONString: json["joinCensusResponseList"].rawString()!) ?? [SLClassMemberModel]()
                weakSelf.notJoinCensusResponseList = Mapper<SLClassMemberModel>().mapArray(JSONString: json["notJoinCensusResponseList"].rawString()!) ?? [SLClassMemberModel]()
                weakSelf.checkEmptyData()
                
            }) { (msg, code) in
                    MBProgressHUD.sl_showMessage(message: msg)
            }
            
        } else {
            MBProgressHUD.sl_showLoading(ignore: true)
            SLEducationCensusParentStaffListRequest(censusId: self.censusId ?? 0).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                MBProgressHUD.sl_hideHUD()
                
                weakSelf.joinCensusResponseList = Mapper<SLClassMemberModel>().mapArray(JSONString: json["joinCensusResponseList"].rawString()!) ?? [SLClassMemberModel]()
                weakSelf.notJoinCensusResponseList = Mapper<SLClassMemberModel>().mapArray(JSONString: json["notJoinCensusResponseList"].rawString()!) ?? [SLClassMemberModel]()
                weakSelf.checkEmptyData()
                
            }) { (msg, code) in
                MBProgressHUD.sl_showMessage(message: msg)
            }
        }
        
    }
    
    override func sl_onBackClick() {
        super.sl_onBackClick()
        SLSSAudioPlayer.sharedInstance.stopVoice()
    }
    
    // MARK: - Request
    @objc func reminderRequest() {
        var childrenIdList:[Int] = [Int]()
        for sub in notJoinCensusResponseList ?? [SLClassMemberModel]() {
            childrenIdList.append(sub.childrenId ?? 0)
        }
        MBProgressHUD.sl_showLoading()
        SLEducationTeacherOneTouchReminderRequest(childrenIdList: childrenIdList, classId: classId ?? 0, opFlag: 1, serviceId: censusId ?? 0, serviceType: 3, serviceCreateTime: serviceCreateTime ?? "").request({ (json) in
            MBProgressHUD.sl_showMessage(message: "通知成功")
            
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: - Setter
    var detailModel: SLHomeworkDetailModel? {
        didSet {
            tableView.reloadData()
//            self.bottomBtnView.btnCommit.layer.removeFromSuperlayer()

            if self.detailModel?.state == 100 {
                self.bottomBtnView.btnCommit.setTitle("已结束", for: .disabled)
                self.bottomBtnView.btnCommit.isEnabled = false
                self.bottomBtnView.btnCommit.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.sl_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
//                header?.btnSolitaire.setTitle("已结束", for: .disabled)
////                header?.btnSolitaire.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#C4CDDA")
//                header?.btnSolitaire.isEnabled = false
//                header?.btnSolitaire.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 50), startColor: UIColor.sl_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 25)
            }
            else if self.detailModel?.state == 10 {
                self.bottomBtnView.btnCommit.setTitle("我来接龙", for: .normal)
                self.bottomBtnView.btnCommit.isEnabled = true
                self.bottomBtnView.btnCommit.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 21)
            }
            else {
                self.bottomBtnView.btnCommit.setTitle("已提交", for: .disabled)
                self.bottomBtnView.btnCommit.isEnabled = false
                self.bottomBtnView.btnCommit.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.sl_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
            }
            if SLPersonDataModel.sharePerson.personRole == .PARENT {
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                    self.bottomBtnView.isHidden = false
//                }
            }

        }
    }
    
    var joinCensusResponseList: [SLClassMemberModel]? {
        didSet {
            /// 设置提交按钮置灰
            if SLPersonDataModel.sharePerson.personRole == .PARENT {
                for sub in self.joinCensusResponseList ?? [SLClassMemberModel]() {
                    if sub.childrenId == childrenId {
                        self.bottomBtnView.btnCommit.isEnabled = false
                        self.bottomBtnView.btnCommit.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.sl_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
                    }
                }
                self.bottomBtnView.btnCommit.isHidden = false
            }
            tableView.reloadData()
        }
    }
    
    var notJoinCensusResponseList: [SLClassMemberModel]? {
        didSet {
            tableView.reloadData()
        }
    }
//    var joinCensusResponseList:[SLClassMemberModel]?
//    var notJoinCensusResponseList:[SLClassMemberModel]?
//    var detailModel:SLHomeworkDetailModel?
    
    // MARK: - Action
    @objc func sl_solitaireClick(sender: SLButton) {
        var defaultIndex = -1
        if detailModel?.optionList?.count == 1 {
            defaultIndex = 0
        }
        SLSolitaireSelectReasonView(items: detailModel?.optionList ?? [String](), selectedIndex: defaultIndex, title: "选择", inTarget: self.view) { [weak self](view, index) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_showLoading()
            SLEducationCensusParentCommitRequest(censusId: weakSelf.censusId ?? 0, childrenId: weakSelf.childrenId ?? 0, option: weakSelf.detailModel?.optionList?[index] ?? "").request({ (json) in
                MBProgressHUD.sl_hideHUD()
                MBProgressHUD.sl_showMessage(message: "接龙成功")
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationIdKey: weakSelf.censusId ?? 0])
                UIUtil.sl_reduceAgenda(serviceId: weakSelf.censusId ?? 0, info: [kEventKey:HomeType.solitaire])
                weakSelf.sl_refreshData()
                weakSelf.navigationController?.sl_existViewController(existClass: SLSolitaireListController(classId: 0, childId: 0), complete: { (isExist, vc) in
                    vc.sl_refreshData()
                })

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.89) {
                    view.cancelClick()

                }

            }) { (msg, code) in
                MBProgressHUD.sl_showMessage(message: msg)
            }
        }
//        SLSolitaireSelectReasonView(items: detailModel?.optionList ?? [String](), inTarget: self.view) { [weak self](view, index) in
//            guard let weakSelf = self else {return}
//            MBProgressHUD.sl_showLoading()
//            SLEducationCensusParentCommitRequest(censusId: weakSelf.censusId ?? 0, childrenId: weakSelf.childrenId ?? 0, option: weakSelf.detailModel?.optionList?[index] ?? "").request({ (json) in
//                MBProgressHUD.sl_hideHUD()
//                MBProgressHUD.sl_showMessage(message: "接龙成功")
//                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationIdKey: weakSelf.censusId ?? 0])
//                UIUtil.sl_reduceAgenda(serviceId: weakSelf.censusId ?? 0, info: [kEventKey:HomeType.solitaire])
//                weakSelf.sl_refreshData()
//                weakSelf.navigationController?.sl_existViewController(existClass: SLSolitaireListController(classId: 0, childId: 0), complete: { (isExist, vc) in
//                    vc.sl_refreshData()
//                })
//
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.89) {
//                    view.cancelClick()
//
//                }
//
//            }) { (msg, code) in
//                MBProgressHUD.sl_showMessage(message: msg)
//            }
//        }
    }
     
    @objc func sl_shareClick(sender: SLButton) {
        let model = HMRequestShareModel(censusId: censusId ?? 0)
        MBProgressHUD.sl_showLoading()
        SLEducationShareLinkRequest(model: model).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_hideHUD()
            let strUrl = json.stringValue
            let title = "\(weakSelf.detailModel?.teacherName ?? "")布置的接龙!"
            let dsc = "\(weakSelf.detailModel?.content ?? "")"
            let shareModel = SLShareModel(title: title, descriptionText: dsc, link: strUrl)
            SLShareTool.showCommonShare(shareModel: shareModel)
        }) { (msg, code ) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    @objc func sl_moreClick(sender: SLButton) {
        sender.isEnabled = false
        let title = detailModel?.isTop == 0 ? "置顶" : "取消置顶"
        SLSetTopAlertView.showIn(target: self.view, topButtonTitle:title) { [weak self](btn) in
            guard let weakSelf = self else {return}

            sender.isEnabled = true

            if btn.titleLabel?.text == title {
                let isTop = weakSelf.detailModel?.isTop == 0 ? 1 : 0

                UIUtil.sl_loadUpdateTopData(type: .solitaire, id: weakSelf.censusId ?? 0, createTime: weakSelf.detailModel?.createTime ?? "", isTop: isTop, positon: .detial) {
                    weakSelf.detailModel?.isTop = isTop
                }
            }
        }
    }
    
    @objc func sl_callUpClick(sender:SLButton) {
        let list: [SLClassMemberModel] = (headerSelectedIndex == 0 ? notJoinCensusResponseList : joinCensusResponseList) ?? [SLClassMemberModel]()
        let model = list[sender.tag]
        UIUtil.sl_callPhoneNumberRequest(childrenId: model.childrenId ?? 0, classId: detailModel?.classId ?? 0)
    }
    
    @objc func sl_chatClick(sender:SLButton) {
        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
            let list: [SLClassMemberModel] = (headerSelectedIndex == 0 ? notJoinCensusResponseList : joinCensusResponseList) ?? [SLClassMemberModel]()
            let model = list[sender.tag]
            UIUtil.sl_chatImRequest(childrenId: model.childrenId ?? 0, classId: detailModel?.classId ?? 0)
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
            if SLPersonDataModel.sharePerson.personRole == .TEACHER {
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

        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
            let list: [SLClassMemberModel] = (headerSelectedIndex == 0 ? notJoinCensusResponseList : joinCensusResponseList) ?? [SLClassMemberModel]()
            let cModel = list[indexPath.row]
            
            if headerSelectedIndex == 0 {
                let cell:SLDetailContactCell = tableView.dequeueReusableCell(withIdentifier: "SLDetailContactCell") as! SLDetailContactCell
                cell.lbTitle.text = childrenId == cModel.childrenId ? "我" : cModel.realName
                cell.imgAvatar.sd_setImage(with: URL(string: cModel.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
                cell.btnPhone.tag = indexPath.row
                cell.btnChat.tag = indexPath.row
                cell.btnPhone.addTarget(self, action: #selector(sl_callUpClick(sender:)), for: .touchUpInside)
                cell.btnChat.addTarget(self, action: #selector(sl_chatClick(sender:)), for: .touchUpInside)
                let cl = NightNight.theme == .night ? kNightBackgroundColor : kTableViewBackgroundColor
                cell.sl_addLine(position: .bottom, color: cl, leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
                return cell
                
            } else {
                let cell:SLDetailAllTitleCell2 = tableView.dequeueReusableCell(withIdentifier: "SLDetailAllTitleCell2") as! SLDetailAllTitleCell2
                cell.lbTitle.text = childrenId == cModel.childrenId ? "我" : cModel.realName
                cell.lbSubTitle.text = "\(cModel.commitTime?.sl_DayTime() ?? "") \(cModel.option ?? "")"
                cell.imgAvatar.sd_setImage(with: URL(string: cModel.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
                cell.btnPhone.tag = indexPath.row
                cell.btnChat.tag = indexPath.row
                cell.btnPhone.addTarget(self, action: #selector(sl_callUpClick(sender:)), for: .touchUpInside)
                cell.btnChat.addTarget(self, action: #selector(sl_chatClick(sender:)), for: .touchUpInside)
                return cell
            }
            
        } else {
            let list: [SLClassMemberModel] = (headerSelectedIndex == 0 ? joinCensusResponseList : notJoinCensusResponseList) ?? [SLClassMemberModel]()
            let cModel = list[indexPath.row]
            
            if headerSelectedIndex == 0 {
                let cell:SLDetailAllTitleCell = tableView.dequeueReusableCell(withIdentifier: "SLDetailAllTitleCell") as! SLDetailAllTitleCell
                cell.lbTitle.text = childrenId == cModel.childrenId ? "我" : cModel.realName
                cell.lbSubTitle.text = "\(cModel.option ?? "")"
                cell.lbRightTitle.text = cModel.commitTime?.sl_DayTime()//03.04
                cell.imgAvatar.sd_setImage(with: URL(string: cModel.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
                return cell
                
            } else {
                let cell:SLDetailNormalCell = tableView.dequeueReusableCell(withIdentifier: "SLDetailNormalCell") as! SLDetailNormalCell
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
            header?.avatarView.lbSubTitle.text = detailModel?.createTime?.sl_Time()//"1小时前"
            header?.dateView.title = "截止日期：\(detailModel?.endTime ?? "")"
            let mModel = SLMediaViewModel()
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
//            header?.btnSolitaire.addTarget(self, action: #selector(sl_solitaireClick(sender:)), for: .touchUpInside)
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
                let tmpStr = SLObjcTool.shareInstance().getCompleteWebsite(url)
                let newUrl = tmpStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                UIApplication.shared.openURL(URL(string: newUrl)!)
            }
            return header
        
        } else {
            let header: SLHomeworkReadListSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SLHomeworkReadListSectionHeader") as! SLHomeworkReadListSectionHeader
            
            if SLPersonDataModel.sharePerson.personRole == .TEACHER {
                header.btnTitle1.setTitle("未接龙（\(notJoinCensusResponseList?.count ?? 0)）", for: .normal)
                header.btnTitle2.setTitle("已接龙（\(joinCensusResponseList?.count ?? 0)）", for: .normal)
                
            } else {
                header.btnTitle1.setTitle("已接龙（\(joinCensusResponseList?.count ?? 0)）", for: .normal)
                header.btnTitle2.setTitle("未接龙（\(notJoinCensusResponseList?.count ?? 0)）", for: .normal)
            }

            if SLPersonDataModel.sharePerson.personRole == .TEACHER && headerSelectedIndex == 0 && notJoinCensusResponseList?.count ?? 0 > 0 && detailModel?.state != 100 {
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
//    lazy var btnSolitaire: SLButton = {
//        let btn = SLButton()
//        btn.isHidden = true
//        btn.setTitle("我来接龙", for: .normal)
//        btn.setTitle("已提交", for: .disabled)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
//        btn.cornerRadius = 25
//        btn.setMixedTitleColor(MixedColor(normal: 0xFEFEFF, night: 0xFEFEFF), forState: .normal)
//        btn.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 50), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 25)
//        btn.sl_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 50), color: UIColor.gray, cornerRadius: 25, offset: CGSize(width: 4, height: 4))
//        return btn
//    }()

    lazy var bottomBtnView: SLBottomBtnView = {
        let view = SLBottomBtnView()
        view.isHidden = true
        view.btnCommit.setTitle("我来接龙", for: .normal)
        view.btnCommit.addTarget(self, action: #selector(sl_solitaireClick(sender:)), for: .touchUpInside)
        return view
    }()

    // MARK: - Other
    @objc func checkEmptyData() {
        let list: [SLClassMemberModel]
        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
            list = (headerSelectedIndex == 0 ? notJoinCensusResponseList : joinCensusResponseList) ?? [SLClassMemberModel]()
            
        } else {
            list = (headerSelectedIndex == 0 ? joinCensusResponseList : notJoinCensusResponseList) ?? [SLClassMemberModel]()
        }

        if list.count == 0 {
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
            let imageView = UIImageView()
            imageView.mixedImage = MixedImage(normal: "sl_defultImage_nodata", night: "sl_defultImage_nodata_night")
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
        
        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
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
//        self.contentView.sl_addLine(position: .top, color: cl, leftMargin: 0, rightMargin: 0, lineHeight: 10)
        self.contentView.sl_addLine(position: .bottom, color: cl, leftMargin: 0, rightMargin: 0, lineHeight: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var avatarView: SLAvatarView = {
        let view = SLAvatarView()
        return view
    }()
    
    lazy var dateView: SLCustomImageControl = {
        let view = SLCustomImageControl(imageSize: CGSize(width: 19, height: 17), position: SLImagePositionType.left)
        view.locailImage = "sl_solitaire_calendar"
        view.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"))
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    lazy var mediaView: SLMediaView = {
        let view = SLMediaView()
        return view
    }()
    
    lazy var linkView: SLLinkView = {
        let link = SLLinkView()
        link.isHidden = true
        return link
    }()
    

}
