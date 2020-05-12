//
//  YXSNoticeDetailViewController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/30.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
import YBImageBrowser

class YXSNoticeDetailViewController: YXSBaseViewController {

    var homeModel:YXSHomeListModel
    init(model: YXSHomeListModel) {
        self.homeModel = model
        UIUtil.yxs_reduceHomeRed(serviceId: model.serviceId ?? 0,childId: model.childrenId ?? 0)
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
        YXSSSAudioPlayer.sharedInstance.stopVoice()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通知详情"
        setupRightBarButtonItem()

        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)

        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            self.contentView.addSubview(self.topHeaderView)
            self.contentView.addSubview(self.readCommitPanel)
            self.contentView.addSubview(self.mediaView)
            self.contentView.addSubview(self.linkView)
            self.contentView.addSubview(fileFirstView)
            self.contentView.addSubview(fileSecondView)
            self.contentView.addSubview(fileThirdView)

        } else {
            self.contentView.addSubview(self.topHeaderView)
            self.contentView.addSubview(contactTeacher)
            self.contentView.addSubview(self.mediaView)
            self.contentView.addSubview(self.linkView)
            self.contentView.addSubview(fileFirstView)
            self.contentView.addSubview(fileSecondView)
            self.contentView.addSubview(fileThirdView)
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
            let tmpStr = YXSObjcTool.shareInstance().getCompleteWebsite(url)
            var charSet = CharacterSet.urlQueryAllowed
            charSet.insert(charactersIn: "#")
            charSet.insert(charactersIn: "%")
            let newUrl = tmpStr.addingPercentEncoding(withAllowedCharacters: charSet)!
            UIApplication.shared.openURL(URL(string: newUrl)!)
        }

        layout()
        refreshData()

        NotificationCenter.default.addObserver(self, selector: #selector(homeworkCommitSuccess(obj:)), name: NSNotification.Name(rawValue: kParentSubmitSucessNotification), object: nil)
        // Do any additional setup after loading the view.
        bottomBtnView.btnCommit.addTarget(self, action: #selector(replyClick), for: .touchUpInside)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupRightBarButtonItem() {

        let btnShare = YXSButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        btnShare.setMixedImage(MixedImage(normal: "yxs_punchCard_share", night: "yxs_punchCard_share_white"), forState: .normal)
        btnShare.setMixedImage(MixedImage(normal: "yxs_punchCard_share", night: "yxs_punchCard_share_white"), forState: .highlighted)
        btnShare.addTarget(self, action: #selector(shareClick(sender:)), for: .touchUpInside)
        let navShareItem = UIBarButtonItem(customView: btnShare)
        self.navigationItem.rightBarButtonItems = [navShareItem]

    }
    
    func refreshData() {
        MBProgressHUD.yxs_showLoading(ignore: true)
        YXSEducationNoticeQueryNoticeByIdRequest(noticeId: self.homeModel.serviceId ?? 0, noticeCreateTime: self.homeModel.createTime ?? "").request({ [weak self](model: YXSHomeworkDetailModel) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            weakSelf.model = model
            if YXSPersonDataModel.sharePerson.personRole == .PARENT && weakSelf.homeModel.isRead != 1{
                /// 标记页面已读
                if !(weakSelf.model?.readList?.contains(weakSelf.homeModel.childrenId ?? 0) ?? false) {
                    let hModel = YXSHomeListModel(JSON: ["":""])
                    hModel?.serviceId = weakSelf.homeModel.serviceId
                    hModel?.childrenId = weakSelf.homeModel.childrenId
                    hModel?.createTime = weakSelf.homeModel.createTime
                    hModel?.serviceType = 0
                    UIUtil.yxs_loadReadData(hModel!)
                }
            }
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
     func layout() {
        self.scrollView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        
        self.contentView.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
        })
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            self.topHeaderView.snp.makeConstraints({ (make) in
                make.top.equalTo(33)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(50)
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
//                make.bottom.equalTo(-20)
            })
            
            fileFirstView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.linkView.snp_bottom).offset(10)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(44)
            })
            
            fileSecondView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.fileFirstView.snp_bottom).offset(10)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(44)
            })
            
            fileThirdView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.fileSecondView.snp_bottom).offset(10)
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
//                make.top.equalTo(self.topHeaderView.snp_bottom).offset(20)
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
//                make.bottom.equalTo(-20)
            })
            
            fileFirstView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.linkView.snp_bottom).offset(10)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(44)
            })
            
            fileSecondView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.fileFirstView.snp_bottom).offset(10)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(44)
            })
            
            fileThirdView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.fileSecondView.snp_bottom).offset(10)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(44)
                make.bottom.equalTo(-20)
            })
        }

    }
    
    
    // MARK: - Setter
    private var model: YXSHomeworkDetailModel? {
        didSet {

            topHeaderView.strGrade = self.model?.className
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                var teacherName = "我"
                if self.model?.teacherName != YXSPersonDataModel.sharePerson.userModel.name {
                    teacherName = self.model?.teacherName ?? ""
                }
                topHeaderView.strSubTitle = "\(teacherName) ｜ \(self.model?.createTime?.yxs_Time() ?? "")"
                
                contactTeacher.imgAvatar.sd_setImage(with: URL(string: self.model?.teacherAvatar ?? ""), placeholderImage: kImageUserIconTeacherDefualtImage)
                contactTeacher.lbTitle.text = self.model?.teacherName
                contactTeacher.lbSubTitle.text = self.model?.createTime?.yxs_Time()
                
            } else {
                contactTeacher.imgAvatar.sd_setImage(with: URL(string: self.model?.teacherAvatar ?? ""), placeholderImage: kImageUserIconTeacherDefualtImage)
                contactTeacher.lbTitle.text = self.model?.teacherName
                contactTeacher.lbSubTitle.text = self.model?.className
                contactTeacher.lbThirdTitle.text = "| \(self.model?.createTime?.yxs_Time() ?? "")"
            }
            
            
            readCommitPanel.firstValue = String(self.model?.readList?.count ?? 0)
            readCommitPanel.firstTotal = String(self.model?.memberCount ?? 0)
            
            if self.model?.onlineCommit == 1 {
                readCommitPanel.lbTitle2.text = "回执"
                readCommitPanel.secondValue = String(self.model?.committedList?.count ?? 0)
                readCommitPanel.secondTotal = String(self.model?.memberCount ?? 0)
                
                readCommitPanel.lbTitle2.isHidden = false
                readCommitPanel.lbCommit.isHidden = false
                readCommitPanel.lbTotal2.isHidden = false
                
            } else {
                readCommitPanel.lbTitle2.isHidden = true
                readCommitPanel.lbCommit.isHidden = true
                readCommitPanel.lbTotal2.isHidden = true
            }
            

            var imgs:[String]? = nil
            if self.model?.imageUrl?.count ?? 0 > 0 {
                imgs = self.model?.imageUrl?.components(separatedBy: ",")
            }
            let mediaModel = YXSMediaViewModel()//(content: self.model?.content, voiceUrl: self.model?.audioUrl, voiceDuration: self.model?.audioDuration, images: imgs)
            mediaModel.content = self.model?.content
            mediaModel.voiceUrl = self.model?.audioUrl
            mediaModel.voiceDuration = self.model?.audioDuration
            mediaModel.images = imgs
            mediaModel.videoUrl = self.model?.videoUrl
            mediaModel.bgUrl = self.model?.bgUrl
            mediaView.model = mediaModel
            mediaView.videoTouchedHandler = { [weak self](url) in
                guard let weakSelf = self else {return}
                let vc = SLVideoPlayController()
                vc.videoUrl = url
                weakSelf.navigationController?.pushViewController(vc)
            }
            linkView.strLink = self.model?.link ?? ""
            refreshLayout()
        }
    }

    /// check回执按钮显示隐藏
    func refreshLayout() {
        
        if self.model?.link == nil || self.model?.link?.count == 0 {
            linkView.isHidden = true
            self.linkView.snp.updateConstraints({ (make) in
                make.top.equalTo(self.mediaView.snp_bottom).offset(0)
                make.height.equalTo(0)
            })
            
        } else {
            linkView.isHidden = false
        }
        if self.model?.fileList.count ?? 0 > 0 {
            for index in 0..<(self.model?.fileList.count)!{
                switch index {
                case 0:
                    fileFirstView.isHidden = false
                    fileFirstView.setModel(model: (self.model?.fileList[index])!)
                    fileSecondView.isHidden = true
                    fileThirdView.isHidden = true
                    fileSecondView.snp.updateConstraints({ (make) in
                        make.top.equalTo(self.fileFirstView.snp_bottom).offset(0)
                        make.height.equalTo(0)
                    })
                    fileThirdView.snp.updateConstraints({ (make) in
                        make.top.equalTo(self.fileSecondView.snp_bottom).offset(0)
                        make.height.equalTo(0)
                    })
                case 1:
                    fileSecondView.isHidden = false
                    fileThirdView.isHidden = true
                    fileSecondView.setModel(model: (self.model?.fileList[index])!)
                    fileSecondView.snp.updateConstraints({ (make) in
                        make.top.equalTo(self.fileFirstView.snp_bottom).offset(10)
                        make.height.equalTo(44)
                    })
                    fileThirdView.snp.updateConstraints({ (make) in
                        make.top.equalTo(self.fileSecondView.snp_bottom).offset(0)
                        make.height.equalTo(0)
                    })
                case 2:
                    fileThirdView.isHidden = false
                    fileThirdView.setModel(model: (self.model?.fileList[index])!)
                    fileThirdView.snp.updateConstraints({ (make) in
                        make.top.equalTo(self.fileSecondView.snp_bottom).offset(10)
                        make.height.equalTo(44)
                    })
                default:
                    print("")
                }
            }
        } else {
            fileFirstView.isHidden = true
            fileSecondView.isHidden = true
            fileThirdView.isHidden = true
            fileFirstView.snp.updateConstraints({ (make) in
                make.top.equalTo(self.linkView.snp_bottom).offset(0)
                make.height.equalTo(0)
            })
            fileSecondView.snp.updateConstraints({ (make) in
                make.top.equalTo(self.fileFirstView.snp_bottom).offset(0)
                make.height.equalTo(0)
            })
            fileThirdView.snp.updateConstraints({ (make) in
                make.top.equalTo(self.fileSecondView.snp_bottom).offset(0)
                make.height.equalTo(0)
            })
        }
        
        
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            if self.model?.onlineCommit == 1 {
                if !isCommitted(model: self.model!) {
                    /// 未提交
                    self.scrollView.snp.remakeConstraints { (make) in
                        make.top.equalTo(0)
                        make.left.equalTo(0)
                        make.right.equalTo(0)
                        make.bottom.equalTo(self.bottomBtnView.snp_top)
                    }
                    
                    bottomBtnView.isHidden = false
                    bottomBtnView.btnCommit.setTitle("提交回执", for: .normal)
                    bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 21)
                    bottomBtnView.snp.makeConstraints({ (make) in
                        make.top.equalTo(scrollView.snp_bottom)
                        make.left.equalTo(0)
                        make.right.equalTo(0)
                        make.bottom.equalTo(0)
//                        if #available(iOS 11.0, *) {
//                            make.height.equalTo(62+34)
//
//                        } else {
                            make.height.equalTo(62)
//                        }
                    })
                } else {
                    self.scrollView.snp.remakeConstraints { (make) in
                        make.top.equalTo(0)
                        make.left.equalTo(0)
                        make.right.equalTo(0)
                        make.bottom.equalTo(self.bottomBtnView.snp_top)
                    }
                    bottomBtnView.isHidden = false
                    bottomBtnView.btnCommit.setTitle("已回执", for: .normal)
                    bottomBtnView.btnCommit.isEnabled = false
                    bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
                    bottomBtnView.snp.makeConstraints({ (make) in
                        make.top.equalTo(scrollView.snp_bottom)
                        make.left.equalTo(0)
                        make.right.equalTo(0)
                        make.bottom.equalTo(0)
                        make.height.equalTo(62)
                    })
//                    self.scrollView.snp.remakeConstraints { (make) in
//                        make.edges.equalTo(0)
//                    }
//                    bottomBtnView.isHidden = true
                }
                
            } else {
                bottomBtnView.isHidden = true
            }
        }
    }
    

    // MARK: - Action
    @objc func shareClick(sender: YXSButton) {
        let model = HMRequestShareModel(noticeId: homeModel.serviceId ?? 0, noticeCreateTime: homeModel.createTime ?? "")
        MBProgressHUD.yxs_showLoading()
        YXSEducationShareLinkRequest(model: model).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            let strUrl = json.stringValue
            let title = "\(weakSelf.model?.teacherName ?? "")布置的通知!"
            let dsc = "\(weakSelf.model?.content ?? "")"
            let shareModel = YXSShareModel(title: title, descriptionText: dsc, link: strUrl)
            YXSShareTool.showCommonShare(shareModel: shareModel)
        }) { (msg, code ) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    @objc func voiceClick() {
        
    }
    
    @objc func moreClick(sender: YXSButton) {
        sender.isEnabled = false
        let title = model?.isTop == 0 ? "置顶" : "取消置顶"
        YXSSetTopAlertView.showIn(target: self.view, topButtonTitle:title) { [weak self](btn) in
            guard let weakSelf = self else {return}
            sender.isEnabled = true
            
            if btn.titleLabel?.text == title {
                let isTop = weakSelf.model?.isTop == 0 ? 1 : 0
                UIUtil.yxs_loadUpdateTopData(type: .notice, id: weakSelf.homeModel.serviceId ?? 0, createTime: weakSelf.homeModel.createTime ?? "", isTop: isTop, positon: .detial) {
                    weakSelf.model?.isTop = isTop
                }
            }
        }
    }
    
    @objc func contactClick(sender: YXSButton) {
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            UIUtil.yxs_chatImRequest(childrenId: homeModel.childrenId ?? 0, classId: homeModel.classId ?? 0)
            
        } else {
            self.yxs_pushChatVC(imId: model?.teacherImId ?? "")
        }
    }
    
    /// 去提交
    @objc func goCommitClick(sender: YXSButton) {
        
    }
    
    @objc func alertClick(sender: YXSButton) {
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
        let vc = YXSNoticeContainerViewController()
        vc.detailModel = homeModel
        vc.detailModel?.onlineCommit = model?.onlineCommit
        vc.backClickBlock = { [weak self]()in
            guard let weakSelf = self else {return}
            weakSelf.refreshData()
        }
        self.navigationController?.pushViewController(vc)
    }
    
    /// 提交回执
    @objc func replyClick() {
        MBProgressHUD.yxs_showLoading()
        YXSEducationNoticeCustodianCommitReceiptRequest(noticeId: self.homeModel.serviceId ?? 0, childrenId: self.homeModel.childrenId ?? 0, noticeCreateTime: self.homeModel.createTime ?? "").request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            MBProgressHUD.yxs_showMessage(message: "提交成功")
            weakSelf.homeModel.commitState = 2
            weakSelf.model?.committedList?.append(weakSelf.homeModel.childrenId ?? 0)
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationModelKey: weakSelf.homeModel])
            UIUtil.yxs_reduceAgenda(serviceId: weakSelf.homeModel.serviceId ?? 0, info: [kEventKey: YXSHomeType.notice])
            weakSelf.refreshLayout()
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    func clickFileShow(model:YXSFileModel) {
        if model.fileType == "jpg" {
            let imgData = YBIBImageData()
            imgData.imageURL = URL(string: model.fileUrl ?? "")
            
            let browser: YBImageBrowser = YBImageBrowser()
            browser.dataSourceArray = [imgData]
            browser.show()
            
        } else if model.fileType == "mp4" {
            // 视频
            let videoData: YBIBVideoData = YBIBVideoData()
            videoData.videoURL = URL(string: model.fileUrl ?? "")
            
            let browser: YBImageBrowser = YBImageBrowser()
            browser.dataSourceArray = [videoData]
            browser.show()
            
        } else {
            let wk = YXSBaseWebViewController()
            wk.loadUrl = model.fileUrl
            UIUtil.curruntNav().pushViewController(wk)
        }
    }
    
    // MARK: - Other
    @objc func isCommitted(model:YXSHomeworkDetailModel) -> Bool {
        return (model.committedList?.contains(homeModel.childrenId ?? 0))!
    }

    /// 提交作业成功后 把界面盖上去
    @objc func homeworkCommitSuccess(obj:Notification?) {
        let userInfo = obj?.object as? [String: Any]
        if let model = userInfo?[kNotificationModelKey] as? YXSHomeListModel{
            if model.type == .homework {
                let vc = YXSHomeworkCommitDetailViewController()
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
    
    override func yxs_onBackClick() {
        if self.model?.onlineCommit == 0 || YXSPersonDataModel.sharePerson.personRole == .TEACHER || self.homeModel.commitState == 2 {
            super.yxs_onBackClick()
            return
        }
        if self.model?.onlineCommit == 1 {
            for sub in self.model?.committedList ?? [Int]() {
                if sub == homeModel.childrenId {
                    /// 已经提交回执了
                    super.yxs_onBackClick()
                    return
                }
            }
        }
        
        /// 回执未提交
        YXSCommonAlertView.showAlert(title: "", message: "该条通知需要回执，是否确认回执", leftTitle: "取消", leftClick: { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.navigationController?.popViewController()
            
        }, rightTitle: "回执", rightClick: {
            MBProgressHUD.yxs_showLoading()
            YXSEducationNoticeCustodianCommitReceiptRequest(noticeId: self.homeModel.serviceId ?? 0, childrenId: self.homeModel.childrenId ?? 0, noticeCreateTime: self.homeModel.createTime ?? "").request({ [weak self](json) in
                guard let weakSelf = self else {return}
                MBProgressHUD.yxs_hideHUD()
                MBProgressHUD.yxs_showMessage(message: "提交成功")
                weakSelf.homeModel.commitState = 2
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationModelKey: weakSelf.homeModel])
                UIUtil.yxs_reduceAgenda(serviceId: weakSelf.homeModel.serviceId ?? 0, info: [kEventKey: YXSHomeType.notice])
                weakSelf.bottomBtnView.isHidden = true
                weakSelf.navigationController?.popViewController()
                
            }) { [weak self](msg, code) in
                guard let weakSelf = self else {return}
                MBProgressHUD.yxs_showMessage(message: msg)
                weakSelf.navigationController?.popViewController()
            }
            
        }, superView: self.navigationController?.view)
    }
    
    // MARK: - LazyLoad
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        return scrollView
    }()

    lazy var contentView: UIView = {
        let view = UIView()
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

    lazy var mediaView: YXSMediaView = {
        let view = YXSMediaView()
        return view
    }()

    lazy var linkView: YXSLinkView = {
        let link = YXSLinkView()
        link.isHidden = true
        return link
    }()
    
    lazy var fileFirstView: YXSPublishFileView = {
        let fileView = YXSPublishFileView.init(clickCompletion: { [weak self](model) in
            guard let strongSelf = self else { return }
            strongSelf.clickFileShow(model: model)
        })
        fileView.closeImgIcon.isHidden = true
        fileView.tag = 10001
        fileView.isHidden = true
        return fileView
    }()
    lazy var fileSecondView: YXSPublishFileView = {
        let fileView = YXSPublishFileView.init(clickCompletion: { [weak self](model) in
            guard let strongSelf = self else { return }
            strongSelf.clickFileShow(model: model)
        })
        fileView.closeImgIcon.isHidden = true
        fileView.tag = 10002
        fileView.isHidden = true
        return fileView
    }()
    
    lazy var fileThirdView: YXSPublishFileView = {
        let fileView = YXSPublishFileView.init(clickCompletion: { [weak self](model) in
            guard let strongSelf = self else { return }
            strongSelf.clickFileShow(model: model)
        })
        fileView.closeImgIcon.isHidden = true
        fileView.tag = 10003
        fileView.isHidden = true
        return fileView
    }()

    lazy var contactTeacher: SLAvatarContactView = {
        let chat = SLAvatarContactView()
        chat.btnChat.setTitle("联系老师", for: .normal)
        chat.btnChat.addTarget(self, action: #selector(contactClick(sender:)), for: .touchUpInside)
        return chat
    }()

    lazy var bottomBtnView: YXSBottomBtnView = {
        let view = YXSBottomBtnView()
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
