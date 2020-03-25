//
//  SLHomeworkDetailViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/25.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight
import YYText


/// 作业未提交时候查看详情
class SLHomeworkDetailViewController: SLBaseViewController {
    
    var homeModel:SLHomeListModel
    //    var btnCommit: SLButton?
    init(model: SLHomeListModel) {
        self.homeModel = model
        UIUtil.sl_reduceHomeRed(serviceId: model.serviceId ?? 0,childId: model.childrenId ?? 0)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SLSSAudioPlayer.sharedInstance.stopVoice()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "作业详情"
        // Do any additional setup after loading the view.
        setupRightBarButtonItem()
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        
        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
            self.contentView.addSubview(self.topHeaderView)
            self.contentView.addSubview(self.readCommitPanel)
            self.contentView.addSubview(self.mediaView)
            self.contentView.addSubview(self.linkView)
            
        } else {
            self.contentView.addSubview(self.topHeaderView)
            self.contentView.addSubview(contactTeacher)
            self.contentView.addSubview(self.mediaView)
            self.contentView.addSubview(self.linkView)
            self.view.addSubview(bottomBtnView)
        }
        
        mediaView.voiceTouchedHandler = { [weak self](url, duration) in
            guard let weakSelf = self else {return}
            weakSelf.voiceClick()
        }
        mediaView.videoTouchedHandler = { [weak self](url) in
            guard let weakSelf = self else {return}
            let vc = SLVideoPlayController()
            vc.videoUrl = url
            weakSelf.navigationController?.pushViewController(vc)
        }
        mediaView.imageTouchedHandler = {[weak self] (imageView, index) in
            guard let weakSelf = self else {return}
        }
        
        linkView.block = { [weak self](url) in
            guard let weakSelf = self else {return}
            let tmpStr = SLObjcTool.shareInstance().getCompleteWebsite(url)
            let newUrl = tmpStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            UIApplication.shared.openURL(URL(string: newUrl)!)
        }
        
        layout()
        refreshData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(homeworkCommitSuccess(obj:)), name: NSNotification.Name(rawValue: kParentSubmitSucessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(homeworkUndoSuccess(obj:)), name: NSNotification.Name.init(rawValue: kOperationStudentWorkNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupRightBarButtonItem() {
        let btnShare = SLButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        btnShare.setMixedImage(MixedImage(normal: "sl_punchCard_share", night: "sl_punchCard_share_white"), forState: .normal)
        btnShare.setMixedImage(MixedImage(normal: "sl_punchCard_share", night: "sl_punchCard_share_white"), forState: .highlighted)
        btnShare.addTarget(self, action: #selector(shareClick(sender:)), for: .touchUpInside)
        let navShareItem = UIBarButtonItem(customView: btnShare)
        
//        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
//            let btnMore = SLButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
//            btnMore.setMixedImage(MixedImage(normal: "sl_homework_more", night: "sl_homework_more_night"), forState: .normal)
//            btnMore.setMixedImage(MixedImage(normal: "sl_homework_more", night: "sl_homework_more_night"), forState: .highlighted)
//            btnMore.addTarget(self, action: #selector(moreClick(sender:)), for: .touchUpInside)
//            let navItem = UIBarButtonItem(customView: btnMore)
//            self.navigationItem.rightBarButtonItems = [navItem, navShareItem]
//
//        } else {
            self.navigationItem.rightBarButtonItems = [navShareItem]
//        }
        
        
    }
    
    func layout() {
        self.scrollView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        
        self.contentView.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
        })
        
        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
            self.topHeaderView.snp.makeConstraints({ (make) in
                make.top.equalTo(33)
                make.left.equalTo(15)
                make.right.equalTo(-15)
            })
            
            self.readCommitPanel.snp.makeConstraints({ (make) in
                make.top.equalTo(self.topHeaderView.snp_bottom).offset(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(60)
            })
            
            self.mediaView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.readCommitPanel.snp_bottom).offset(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
            })
            
            
            self.linkView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.mediaView.snp_bottom).offset(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(44)
                make.bottom.equalTo(-20)
            })
            
        } else {
            //            self.topHeaderView.snp.makeConstraints({ (make) in
            //                make.top.equalTo(33)
            //                make.left.equalTo(15)
            //                make.right.equalTo(-15)
            //            })
            
            self.contactTeacher.snp.makeConstraints({ (make) in
                make.top.equalTo(33)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(42)
            })
            
            self.mediaView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.contactTeacher.snp_bottom).offset(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
            })
            
            self.linkView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.mediaView.snp_bottom).offset(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(44)
                make.bottom.equalTo(-(20 + 10 + kSafeBottomHeight))
            })
        }
        
    }
    
    @objc func refreshLayout() {
        
        if self.model?.link == nil || self.model?.link?.count == 0 {
            linkView.isHidden = true
            self.linkView.snp.updateConstraints({ (make) in
                make.top.equalTo(self.mediaView.snp_bottom).offset(0)
                make.height.equalTo(0)
            })
            
        } else {
            linkView.isHidden = false
        }
        
        
        if SLPersonDataModel.sharePerson.personRole == .PARENT {
            
            if self.model?.onlineCommit == 1 && homeModel.commitState == 1 {
                /// 未提交
                self.scrollView.snp.remakeConstraints { (make) in
                    make.top.equalTo(0)
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                    make.bottom.equalTo(self.bottomBtnView.snp_top)
                }
                
                bottomBtnView.isHidden = false
                bottomBtnView.snp.makeConstraints({ (make) in
//                    make.top.equalTo(scrollView.snp_bottom)
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                    make.bottom.equalTo(0)
//                    if #available(iOS 11.0, *) {
//                        make.height.equalTo(62+34)
//
//                    } else {
                        make.height.equalTo(62)
//                    }
                })
                self.bottomBtnView.btnCommit.setTitle("去提交", for: .normal)
                self.bottomBtnView.btnCommit.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 21)
            } else {
                /// 已提交
                bottomBtnView.isHidden = true
            }
        }
    }
    
    // MARK: - Request
    @objc func refreshData() {
        MBProgressHUD.sl_showLoading(ignore: true)
        SLEducationHomeworkQueryHomeworkByIdRequest(childrenId: homeModel.childrenId ?? 0, homeworkCreateTime: homeModel.createTime ?? "", homeworkId: homeModel.serviceId ?? 0).request({ [weak self](model: SLHomeworkDetailModel) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_hideHUD()
            weakSelf.model = model
            if SLPersonDataModel.sharePerson.personRole == .PARENT && weakSelf.homeModel.isRead != 1{
                /// 标记页面已读
                if !(weakSelf.model?.readList?.contains(weakSelf.homeModel.childrenId ?? 0) ?? false) {
                    let hModel = SLHomeListModel(JSON: ["":""])
                    hModel?.serviceId = weakSelf.homeModel.serviceId
                    hModel?.childrenId = weakSelf.homeModel.childrenId
                    hModel?.createTime = weakSelf.homeModel.createTime
                    hModel?.serviceType = 1
                    UIUtil.sl_loadReadData(hModel!)
                }
            }
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: - Setter
    private var model: SLHomeworkDetailModel? {
        didSet {
            checkHomeworkCommited()
            
            topHeaderView.strGrade = self.model?.className
            
            if SLPersonDataModel.sharePerson.personRole == .TEACHER {
                var teacherName = "我"
                if self.model?.teacherName != SLPersonDataModel.sharePerson.userModel.name {
                    teacherName = self.model?.teacherName ?? ""
                }
                topHeaderView.strSubTitle = "\(teacherName) ｜ \(self.model?.createTime?.sl_Time() ?? "")"
                
                contactTeacher.imgAvatar.sd_setImage(with: URL(string: self.model?.teacherAvatar ?? ""), placeholderImage: kImageUserIconTeacherDefualtImage)
                contactTeacher.lbTitle.text = self.model?.teacherName
                contactTeacher.lbSubTitle.text = self.model?.createTime?.sl_Time()
                
            } else {
                contactTeacher.imgAvatar.sd_setImage(with: URL(string: self.model?.teacherAvatar ?? ""), placeholderImage: kImageUserIconTeacherDefualtImage)
                contactTeacher.lbTitle.text = self.model?.teacherName
                contactTeacher.lbSubTitle.text = self.model?.className
                contactTeacher.lbThirdTitle.text = "| \(self.model?.createTime?.sl_Time() ?? "")"
            }
            
            
            readCommitPanel.firstValue = String(self.model?.readList?.count ?? 0)
            readCommitPanel.firstTotal = String(self.model?.memberCount ?? 0)
            
            if self.model?.onlineCommit == 1 {
                readCommitPanel.lbTitle2.text = "提交"
                readCommitPanel.secondValue = String(self.model?.committedList?.count ?? 0)
                readCommitPanel.secondTotal = String(self.model?.memberCount ?? 0)
            } else {
                readCommitPanel.lbTitle2.isHidden = true
                readCommitPanel.lbCommit.isHidden = true
                readCommitPanel.lbTotal2.isHidden = true
            }
            
            
            var imgs:[String]? = nil
            if self.model?.imageUrl?.count ?? 0 > 0 {
                imgs = self.model?.imageUrl?.components(separatedBy: ",")
            }
            
            let mediaModel = SLMediaViewModel()//(content: self.model?.content, voiceUrl: self.model?.audioUrl, voiceDuration: self.model?.audioDuration, images: imgs)
            mediaModel.content = self.model?.content
            mediaModel.voiceUrl = self.model?.audioUrl
            mediaModel.voiceDuration = self.model?.audioDuration
            mediaModel.images = imgs
            mediaModel.bgUrl = self.model?.bgUrl
            mediaModel.videoUrl = self.model?.videoUrl
            mediaView.model = mediaModel
            mediaView.videoTouchedHandler = { [weak self](url) in
                guard let weakSelf = self else {return}
                let vc = SLVideoPlayController()
                vc.videoUrl = url
                weakSelf.navigationController?.pushViewController(vc)
            }
            linkView.strLink = self.model?.link ?? ""
            if self.model?.link == nil || self.model?.link?.count == 0 {
                linkView.isHidden = true
            } else {
                linkView.isHidden = false
            }
            
            refreshLayout()
        }
    }
    
    
    // MARK: - Action
    @objc func shareClick(sender: SLButton) {
        let model = HMRequestShareModel(homeworkId: homeModel.serviceId ?? 0, homeworkCreateTime: homeModel.createTime ?? "")
        MBProgressHUD.sl_showLoading()
        SLEducationShareLinkRequest(model: model).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_hideHUD()
            
            let strUrl = json.stringValue
            let title = "\(weakSelf.model?.teacherName ?? "")布置的作业!"
            let dsc = "\((weakSelf.model?.createTime ?? "").sl_Date().toString(format: DateFormatType.custom("MM月dd日")))作业：\(weakSelf.model?.content ?? "")"
            
            let shareModel = SLShareModel(title: title, descriptionText: dsc, link: strUrl)
            SLShareTool.showCommonShare(shareModel: shareModel)
            
        }) { (msg, code ) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    @objc func voiceClick() {
        
    }
    
    @objc func moreClick(sender: SLButton) {
        sender.isEnabled = false
        let title = model?.isTop == 0 ? "置顶" : "取消置顶"
        SLSetTopAlertView.showIn(target: self.view, topButtonTitle:title) { [weak self](btn) in
            guard let weakSelf = self else {return}
            
            sender.isEnabled = true
            
            if btn.titleLabel?.text == title {
                let isTop = weakSelf.model?.isTop == 0 ? 1 : 0
                
                UIUtil.sl_loadUpdateTopData(type: .homework, id: weakSelf.homeModel.serviceId ?? 0, createTime: weakSelf.model?.createTime ?? "", isTop: isTop, positon: .detial) {
                    weakSelf.model?.isTop = isTop
                }
            }
        }
    }
    
    @objc func contactClick(sender:SLButton) {
        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
            UIUtil.sl_chatImRequest(childrenId: homeModel.childrenId ?? 0, classId: model?.classId ?? 0)
            
        } else {
            self.sl_pushChatVC(imId: model?.teacherImId ?? "")
        }
    }
    
    /// 去提交
    @objc func goCommitClick(sender: SLButton) {
        let vc = SLHomeworkPublishController.init(homeModel)
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func alertClick(sender: SLButton) {
        pushToContainer()
    }
    
    /// 阅读
    @objc func readListClick() {
        pushToContainer()
    }
    
    /// 提交
    @objc func commitListClick() {
        pushToContainer()
    }
    
    @objc func pushToContainer() {
        let vc = SLHomeworkContainerViewController()
        vc.detailModel = self.homeModel
        vc.detailModel?.onlineCommit = model?.onlineCommit
        vc.backClickBlock = { [weak self]()in
            guard let weakSelf = self else {return}
            weakSelf.refreshData()
        }
        self.navigationController?.pushViewController(vc)
    }
    
    // MARK: - Other
    /// 检查推送进来 作业是否有提交 有提交则盖界面上来
    @objc func checkHomeworkCommited() {
        //        if (model?.committedList?.contains(homeModel.childrenId ?? 0) ?? false) {
        //            /// 已提交
        //            let notif = Notification(name: Notification.Name(rawValue: kParentSubmitSucessNotification), object: nil, userInfo: [kNotificationModelKey:homeModel])
        //            homeworkCommitSuccess(obj: notif)
        //            return
        //        }
    }


    /// 家长撤回作业成功通知
    @objc func homeworkUndoSuccess(obj:Notification?) {
        let userInfo = obj?.object as? [String: Any]
        if let model = userInfo?[kNotificationModelKey] as? SLHomeListModel{
            if model.type == .homework {
                /// 刷新按钮
                homeModel.commitState = 1
                refreshLayout()
            }
        }
    }

    /// 提交作业成功后 把界面盖上去
    @objc func homeworkCommitSuccess(obj:Notification?) {
        let userInfo = obj?.object as? [String: Any]
        if let model = userInfo?[kNotificationModelKey] as? SLHomeListModel{
            if model.type == .homework {
                let vc = SLHomeworkCommitDetailViewController()
                vc.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.view.frame.size.height)
                //                vc.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                homeModel.commitState = 2
                vc.homeModel = homeModel
                vc.view.tag = 110
                self.view.addSubview(vc.view)
                self.addChild(vc)
                
                /// 刷新按钮
                refreshLayout()
            }
        }
    }
    
    override func sl_onBackClick() {
        if SLPersonDataModel.sharePerson.personRole == .PARENT && self.model?.onlineCommit == 1 && homeModel.commitState == 1{
            /// 未提交
            SLCommonAlertView.showAlert(title: "", message: "当前作业需要提交,是否提交作业", leftTitle: "退出", leftClick: { [weak self] in
                guard let weakSelf = self else {return}
                weakSelf.navigationController?.popViewController()
                
                }, rightTitle: "去提交", rightClick: { [weak self] in
                    guard let weakSelf = self else {return}
                    let vc = SLHomeworkPublishController.init(weakSelf.homeModel)
                    weakSelf.navigationController?.pushViewController(vc)
                    
                }, superView: self.navigationController?.view)
            
        } else {
            super.sl_onBackClick()
        }
    }
    
    // MARK: - LazyLoad
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
//        if NightNight.theme != .night {
//            view.sl_addLine(position: .top, color: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 10)
//        }
        return view
    }()
    
    /// 一年级3班  我 ｜ 2019/11/13 14:30
    lazy var topHeaderView: HomeworkDetailTopHeader = {
        let header = HomeworkDetailTopHeader()
        return header
    }()
    
    /// 阅读 2/40  提交 13/40  去提醒
    lazy var readCommitPanel: HomeworkDetailReadCommitView = {
        let view = HomeworkDetailReadCommitView()
        view.lbTitle1.text = "阅读"
        view.lbTitle1.addTaget(target: self, selctor: #selector(readListClick))
        view.lbRead.addTaget(target: self, selctor: #selector(readListClick))
        view.lbTotal1.addTaget(target: self, selctor: #selector(readListClick))
        
        view.lbTitle2.text = "提交"
        view.lbTitle2.addTaget(target: self, selctor: #selector(commitListClick))
        view.lbCommit.addTaget(target: self, selctor: #selector(commitListClick))
        view.lbTotal2.addTaget(target: self, selctor: #selector(commitListClick))
        view.btnAlert.addTarget(self, action: #selector(alertClick(sender:)), for: .touchUpInside)
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
    
    lazy var contactTeacher: SLAvatarContactView = {
        let chat = SLAvatarContactView()
        chat.btnChat.setTitle("联系老师", for: .normal)
        chat.btnChat.addTarget(self, action: #selector(contactClick(sender:)), for: .touchUpInside)
        return chat
    }()
    
    //    lazy var btnCommit: SLButton = {
    //        let btn = SLButton()
    //        btn.isHidden = true
    //        btn.setTitle("去提交", for: .normal)
    //        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
    //        btn.setMixedTitleColor(MixedColor(normal: 0xFFFFFF, night: 0xFFFFFF), forState: .normal)
    //        btn.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 54, height: 42), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 15)
    //        btn.sl_shadow(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 54, height: 42), color: UIColor.gray, cornerRadius: 15, offset: CGSize(width: 4, height: 4))
    //        btn.layer.cornerRadius = 15
    //        btn.addTarget(self, action: #selector(goCommitClick(sender:)), for: .touchUpInside)
    //        return btn
    //    }()
    
    
    lazy var bottomBtnView: SLBottomBtnView = {
        let view = SLBottomBtnView()
        view.isHidden = true
        view.btnCommit.addTarget(self, action: #selector(goCommitClick(sender:)), for: .touchUpInside)
        return view
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

/// 一年级3班  我 ｜ 2019/11/13 14:30
class HomeworkDetailTopHeader: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(lbGrade)
        self.addSubview(lbName)
        //        self.addSubview(lbDate)
        
        self.lbGrade.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(17)
        })
//        lbGrade.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
//        lbGrade.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        
        self.lbName.snp.makeConstraints({ (make) in
//            make.centerY.equalTo(self.lbGrade.snp_centerY)
            make.right.equalTo(0)
            make.top.equalTo(self.lbGrade.snp_bottom).offset(15)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
        })
        lbName.setContentHuggingPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        lbName.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
        
        //        self.lbDate.snp.makeConstraints({ (make) in
        //            make.centerY.equalTo(self.lbGrade.snp_centerY)
        //            make.left.equalTo(self.lbName.snp_right).offset(20)
        //        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var strSubTitle: String? {
        didSet {
            lbName.text = self.strSubTitle
        }
    }
    
    var strGrade: String? {
        didSet {
            lbGrade.text = self.strGrade
        }
    }
    
    lazy private var lbGrade: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNightFFFFFF)
        lb.font = UIFont.systemFont(ofSize: 18)
        return lb
    }()
    
    lazy private var lbName: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    //    lazy var lbDate: SLLabel = {
    //        let lb = SLLabel()
    //        lb.mixedTextColor = MixedColor(normal: 0x898F9A, night: 0x000000)
    //        lb.text = ""
    //        lb.font = UIFont.systemFont(ofSize: 15)
    //        return lb
    //    }()
}

/// 阅读 14/40  提交 20/40   去提醒
class HomeworkDetailReadCommitView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.mixedBackgroundColor = MixedColor(normal: kF3F5F9Color, night: kNight282C3B)

        self.cornerRadius = 5
        self.clipsToBounds = true
        
        self.addSubview(self.lbTitle1)
        self.addSubview(self.lbRead)
        self.addSubview(self.lbTotal1)
        
        self.addSubview(self.lbTitle2)
        self.addSubview(self.lbCommit)
        self.addSubview(self.lbTotal2)
        
        self.addSubview(self.btnAlert)
        
        self.lbTitle1.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(self.snp_left).offset(13)
        })
        
        self.lbRead.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(lbTitle1.snp_right).offset(10)
        })
        
        self.lbTotal1.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(lbRead.snp_right).offset(0)
        })
        
        self.lbTitle2.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(lbTotal1.snp_right).offset(30)
        })
        
        self.lbCommit.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(lbTitle2.snp_right).offset(10)
        })
        
        self.lbTotal2.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(lbCommit.snp_right).offset(0)
        })
        
        self.btnAlert.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(self.snp_right).offset(-13)
            make.width.equalTo(79)
            make.height.equalTo(30)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var firstValue: String? {
        didSet {
            lbRead.text = self.firstValue
        }
    }
    
    var secondValue: String? {
        didSet {
            lbCommit.text = self.secondValue
        }
    }
    
    var firstTotal: String? {
        didSet {
            lbTotal1.text = "/\(self.firstTotal ?? "")"
        }
    }
    
    var secondTotal: String? {
        didSet {
            lbTotal2.text = "/\(self.secondTotal ?? "")"
        }
    }
    
    lazy var lbTitle1: SLLabel = {
        let lb = SLLabel()
        //        lb.text = "阅读"
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNightBCC6D4)
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbTitle2: SLLabel = {
        let lb = SLLabel()
        //        lb.text = "提交"
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNightBCC6D4)
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbRead: SLLabel = {
        let lb = SLLabel()
        lb.text = "0"
        lb.mixedTextColor = MixedColor(normal: kNight5E88F7, night: kNight5E88F7)
        lb.font = UIFont.systemFont(ofSize: 19)
        //        lb.addTaget(target: self, selctor: #selector(readListClick))
        return lb
    }()
    
    lazy var lbCommit: SLLabel = {
        let lb = SLLabel()
        lb.text = "0"
        lb.mixedTextColor = MixedColor(normal: kNight5E88F7, night: kNight5E88F7)
        lb.font = UIFont.systemFont(ofSize: 19)
        //        lb.addTaget(target: self, selctor: #selector(commitListClick))
        return lb
    }()
    
    lazy var lbTotal1: SLLabel = {
        let lb = SLLabel()
        lb.text = "/0"
        lb.mixedTextColor = MixedColor(normal: kC1CDDBColor, night: kNightBCC6D4)
        lb.font = UIFont.systemFont(ofSize: 19)
        return lb
    }()
    
    lazy var lbTotal2: SLLabel = {
        let lb = SLLabel()
        lb.text = "/0"
        lb.mixedTextColor = MixedColor(normal: kC1CDDBColor, night: kNightBCC6D4)
        lb.font = UIFont.systemFont(ofSize: 19)
        return lb
    }()
    
    lazy var btnAlert: SLButton = {
        let btn = SLButton()
        btn.setTitle("去提醒", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setMixedTitleColor(MixedColor(normal: kNight5E88F7, night: kNight5E88F7), forState: .normal)
        btn.layer.mixedBorderColor = MixedColor(normal: kNight5E88F7, night: kNight5E88F7)
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 16
        //        btn.addTarget(self, action: #selector(alertClick(sender:)), for: .touchUpInside)
        return btn
    }()
}
