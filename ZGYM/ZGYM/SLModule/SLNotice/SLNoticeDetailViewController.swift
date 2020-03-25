//
//  SLNoticeDetailViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/30.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLNoticeDetailViewController: SLHomeworkDetailViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通知详情"
        
        // Do any additional setup after loading the view.
        bottomBtnView.btnCommit.addTarget(self, action: #selector(replyClick), for: .touchUpInside)
    }
    
    override func setupRightBarButtonItem() {

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
    
    override func refreshData() {
        MBProgressHUD.sl_showLoading(ignore: true)
        SLEducationNoticeQueryNoticeByIdRequest(noticeId: self.homeModel.serviceId ?? 0, noticeCreateTime: self.homeModel.createTime ?? "").request({ [weak self](model: SLHomeworkDetailModel) in
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
                    hModel?.serviceType = 0
                    UIUtil.sl_loadReadData(hModel!)
                }
            }
//            /// 标记页面已读
//            if SLPersonDataModel.sharePerson.personRole == .PARENT && homeModel.isRead != 1{
//                let model = SLHomeListModel(JSON: ["":""])
//                model?.serviceId = homeModel.serviceId
//                model?.childrenId = homeModel.childrenId
//                model?.createTime = homeModel.createTime
//                model?.serviceType = 0
//                UIUtil.sl_loadReadData(model!)
//            }
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    override func layout() {
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
                make.bottom.equalTo(-20)
            })
        }

    }
    
    
    // MARK: - Setter
    private var model: SLHomeworkDetailModel? {
        didSet {

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
            let mediaModel = SLMediaViewModel()//(content: self.model?.content, voiceUrl: self.model?.audioUrl, voiceDuration: self.model?.audioDuration, images: imgs)
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
    override func refreshLayout() {
        
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
                    bottomBtnView.btnCommit.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 21)
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
                    bottomBtnView.btnCommit.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.sl_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
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
    @objc override func shareClick(sender: SLButton) {
        let model = HMRequestShareModel(noticeId: homeModel.serviceId ?? 0, noticeCreateTime: homeModel.createTime ?? "")
        MBProgressHUD.sl_showLoading()
        SLEducationShareLinkRequest(model: model).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_hideHUD()
            let strUrl = json.stringValue
            let title = "\(weakSelf.model?.teacherName ?? "")布置的通知!"
            let dsc = "\(weakSelf.model?.content ?? "")"
            let shareModel = SLShareModel(title: title, descriptionText: dsc, link: strUrl)
            SLShareTool.showCommonShare(shareModel: shareModel)
        }) { (msg, code ) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    @objc override func voiceClick() {
        
    }
    
    @objc override func moreClick(sender: SLButton) {
        sender.isEnabled = false
        let title = model?.isTop == 0 ? "置顶" : "取消置顶"
        SLSetTopAlertView.showIn(target: self.view, topButtonTitle:title) { [weak self](btn) in
            guard let weakSelf = self else {return}
            sender.isEnabled = true
            
            if btn.titleLabel?.text == title {
                let isTop = weakSelf.model?.isTop == 0 ? 1 : 0
                UIUtil.sl_loadUpdateTopData(type: .notice, id: weakSelf.homeModel.serviceId ?? 0, createTime: weakSelf.homeModel.createTime ?? "", isTop: isTop, positon: .detial) {
                    weakSelf.model?.isTop = isTop
                }
            }
        }
    }
    
    override func contactClick(sender: SLButton) {
        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
            UIUtil.sl_chatImRequest(childrenId: homeModel.childrenId ?? 0, classId: homeModel.classId ?? 0)
            
        } else {
            self.sl_pushChatVC(imId: model?.teacherImId ?? "")
        }
    }
    
    /// 去提交
    @objc override func goCommitClick(sender: SLButton) {
        
    }
    
    override func alertClick(sender: SLButton) {
        pushToContainer()
    }
    /// 阅读
    @objc override func readListClick() {
        pushToContainer()
    }
    
    /// 提交
    @objc override func commitListClick() {
        pushToContainer()
    }
    
    @objc override func pushToContainer() {
        let vc = SLNoticeContainerViewController()
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
        MBProgressHUD.sl_showLoading()
        SLEducationNoticeCustodianCommitReceiptRequest(noticeId: self.homeModel.serviceId ?? 0, childrenId: self.homeModel.childrenId ?? 0, noticeCreateTime: self.homeModel.createTime ?? "").request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_hideHUD()
            MBProgressHUD.sl_showMessage(message: "提交成功")
            weakSelf.homeModel.commitState = 2
            weakSelf.model?.committedList?.append(weakSelf.homeModel.childrenId ?? 0)
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationModelKey: weakSelf.homeModel])
            UIUtil.sl_reduceAgenda(serviceId: weakSelf.homeModel.serviceId ?? 0, info: [kEventKey: HomeType.notice])
            weakSelf.refreshLayout()
            
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: - Other
    @objc func isCommitted(model:SLHomeworkDetailModel) -> Bool {
        return (model.committedList?.contains(homeModel.childrenId ?? 0))!
    }
    
    override func sl_onBackClick() {
        if self.model?.onlineCommit == 0 || SLPersonDataModel.sharePerson.personRole == .TEACHER || self.homeModel.commitState == 2 {
            super.sl_onBackClick()
            return
        }
        if self.model?.onlineCommit == 1 {
            for sub in self.model?.committedList ?? [Int]() {
                if sub == homeModel.childrenId {
                    /// 已经提交回执了
                    super.sl_onBackClick()
                    return
                }
            }
        }
        
        /// 回执未提交
        SLCommonAlertView.showAlert(title: "", message: "该条通知需要回执，是否确认回执", leftTitle: "取消", leftClick: { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.navigationController?.popViewController()
            
        }, rightTitle: "回执", rightClick: {
            MBProgressHUD.sl_showLoading()
            SLEducationNoticeCustodianCommitReceiptRequest(noticeId: self.homeModel.serviceId ?? 0, childrenId: self.homeModel.childrenId ?? 0, noticeCreateTime: self.homeModel.createTime ?? "").request({ [weak self](json) in
                guard let weakSelf = self else {return}
                MBProgressHUD.sl_hideHUD()
                MBProgressHUD.sl_showMessage(message: "提交成功")
                weakSelf.homeModel.commitState = 2
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationModelKey: weakSelf.homeModel])
                UIUtil.sl_reduceAgenda(serviceId: weakSelf.homeModel.serviceId ?? 0, info: [kEventKey: HomeType.notice])
                weakSelf.bottomBtnView.isHidden = true
                weakSelf.navigationController?.popViewController()
                
            }) { [weak self](msg, code) in
                guard let weakSelf = self else {return}
                MBProgressHUD.sl_showMessage(message: msg)
                weakSelf.navigationController?.popViewController()
            }
            
        }, superView: self.navigationController?.view)
    }
    
    // MARK: - LazyLoad
//    lazy var btnReply: SLButton = {
//        let btn = SLButton()
//        btn.setTitle("提交回执", for: .normal)
//        btn.setTitle("已提交回执", for: .disabled)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        btn.setImage(UIImage(named: "sl_notice_reply"), for: .normal)
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
//        btn.setMixedTitleColor(MixedColor(normal: kNight5E88F7, night: kNight898F9A), forState: .normal)
//        btn.addTarget(self, action: #selector(replyClick), for: .touchUpInside)
//        return btn
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
