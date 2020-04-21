//
//  YXSHomeworkCommitDetailViewController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/26.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

/// 作业已经提交时候查看详情
class YXSHomeworkCommitDetailViewController: YXSBaseViewController {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        YXSSSAudioPlayer.sharedInstance.stopVoice()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIUtil.yxs_reduceHomeRed(serviceId: homeModel?.serviceId ?? 0, childId: homeModel?.childrenId ?? 0)
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            self.title = "查看作业"
        } else {
            self.title = "作业详情"
        }
        yxs_setupRightBarButtonItem()
        
        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            contentView.addSubview(avatarHeader)
            contentView.addSubview(mediaView)
            
            contentView.addSubview(commentView)
            commentView.isHidden = true
            
            /// 点评按钮
            self.view.addSubview(bottomBtnView)
            bottomBtnView.isHidden = true
            
            avatarHeader.btnChat.setTitle("联系家长", for: .normal)
            
        } else {
            contentView.addSubview(gradeHeader)
            contentView.addSubview(avatarHeader)
            contentView.addSubview(mediaView)
            contentView.addSubview(btnOpen)
            contentView.addSubview(foldView)
            
            contentView.addSubview(commentView)
            commentView.isHidden = true
            
            avatarHeader.btnChat.setTitle("联系老师", for: .normal)
        }
        
        
        yxs_layout()
    }
    
    func yxs_layout() {
        self.scrollView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        
        self.contentView.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
        })
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            
            avatarHeader.snp.makeConstraints({ (make) in
                make.top.equalTo(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(42)
            })
            
            mediaView.snp.makeConstraints({ (make) in
                make.top.equalTo(avatarHeader.snp_bottom).offset(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
            })
            
            commentView.snp.makeConstraints({ (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(mediaView.snp_bottom).offset(11)
                make.bottom.equalTo(0)
            })
            
        } else {
            //            gradeHeader.snp.makeConstraints({ (make) in
            //                make.top.equalTo(23)
            //                make.left.equalTo(15)
            //                make.right.equalTo(-15)
            ////                make.width.height.equalTo(46)
            //            })

            avatarHeader.snp.makeConstraints({ (make) in
                //                make.top.equalTo(gradeHeader.snp_bottom).offset(20)
                make.top.equalTo(23)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(42)
            })
            
            mediaView.snp.makeConstraints({ (make) in
                make.top.equalTo(avatarHeader.snp_bottom).offset(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
            })
            
            btnOpen.snp.makeConstraints({ (make) in
                make.top.equalTo(mediaView.snp_bottom).offset(11)
                make.left.equalTo(17)
            })
            
            
            foldView.snp.makeConstraints({ (make) in
                make.top.equalTo(btnOpen.snp_bottom).offset(11)
                make.left.equalTo(0)
                make.right.equalTo(0)
            })
            
            commentView.snp.makeConstraints({ (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(foldView.snp_bottom).offset(0)
                make.bottom.equalTo(0)
            })
            
            yxs_foldLayout()
        }
    }
    
    @objc func yxs_refreshLayout() {
                
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {return}
            
        if (self.teacherModel?.remark != nil && self.teacherModel?.remark?.count != 0) || (self.teacherModel?.remarkAudioUrl != nil && self.teacherModel?.remarkAudioUrl?.count != 0){
            
            bottomBtnView.isHidden = true
            self.scrollView.snp.remakeConstraints { (make) in
                make.edges.equalTo(0)
            }
            
        } else {
            if self.homeModel?.teacherId == self.yxs_user.id {
                bottomBtnView.isHidden = false
                self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 21)
                /// 未提交
                 self.scrollView.snp.remakeConstraints { (make) in
                     make.top.equalTo(0)
                     make.left.equalTo(0)
                     make.right.equalTo(0)
                 }
                 
                 bottomBtnView.snp.makeConstraints({ (make) in
                     make.top.equalTo(scrollView.snp_bottom)
                     make.left.equalTo(0)
                     make.right.equalTo(0)
                     make.bottom.equalTo(0)
//                     if #available(iOS 11.0, *) {
//                         make.height.equalTo(62+34)
//
//                     } else {
                         make.height.equalTo(62)
//                     }
                 })
                
            }else {
                bottomBtnView.isHidden = true
                self.scrollView.snp.remakeConstraints { (make) in
                    make.edges.equalTo(0)
                }
            }
        }
    }
    
    /// 折叠
    private func yxs_foldLayout() {
        mediaView.voiceView.isHidden = true
        mediaView.imagesView.isHidden = true
        mediaView.lbContent.numberOfLines = 3
        
        btnOpen.snp.remakeConstraints({ (make) in
            make.top.equalTo(mediaView.lbContent.snp_bottom).offset(22)
            make.left.equalTo(17)
        })
    }
    
    /// 展开
    private func yxs_openLayout() {
        if teacherModel?.audioUrl == nil || teacherModel?.audioUrl?.count == 0 {
            mediaView.voiceView.isHidden = true
        } else {
            mediaView.voiceView.isHidden = false
        }
        
        mediaView.imagesView.isHidden = false
        mediaView.lbContent.numberOfLines = 0
        
        btnOpen.snp.remakeConstraints({ (make) in
            make.top.equalTo(mediaView.snp_bottom).offset(22)
            make.left.equalTo(17)
        })
    }
    
    
    func yxs_setupRightBarButtonItem() {
        
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            //            let btnMore = YXSButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
            //            btnMore.setImage(UIImage(named: "yxs_homework_more"), for: .normal)
            //            btnMore.setImage(UIImage(named: "yxs_homework_more"), for: .highlighted)
            //            btnMore.addTarget(self, action: #selector(moreClick(sender:)), for: .touchUpInside)
            //            let navItem = UIBarButtonItem(customView: btnMore)
            //            self.navigationItem.rightBarButtonItems = [navItem, navShareItem]
            //            self.navigationItem.rightBarButtonItem = navItem
            
        } else {
            let btnShare = YXSButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
            btnShare.setMixedImage(MixedImage(normal: "yxs_punchCard_share", night: "yxs_punchCard_share_white"), forState: .normal)
            btnShare.setMixedImage(MixedImage(normal: "yxs_punchCard_share", night: "yxs_punchCard_share_white"), forState: .highlighted)
            btnShare.addTarget(self, action: #selector(yxs_shareClick(sender:)), for: .touchUpInside)
            let navShareItem = UIBarButtonItem(customView: btnShare)
            self.navigationItem.rightBarButtonItem = navShareItem
        }
        
        
    }
    
    // MARK: - Request
    /// 老师发的作业内容
    func yxs_teacherHomeworkRequest(completionHandler:((_ result: YXSHomeworkDetailModel)->())?){
        if YXSPersonDataModel.sharePerson.personRole == .PARENT{
            YXSEducationHomeworkQueryHomeworkByIdRequest(childrenId: self.homeModel?.childrenId ?? 0, homeworkCreateTime: self.homeModel?.createTime ?? "", homeworkId: self.homeModel?.serviceId ?? 0).request({ [weak self](model: YXSHomeworkDetailModel) in
                guard let weakSelf = self else {return}
                completionHandler?(model)
                //                weakSelf.teacherModel = model
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
    }
    
    /// 孩子提交的作业内容
    @objc func yxs_studentHomeworkRequest(completionHandler:((_ result: YXSHomeworkDetailModel)->())?) {
        YXSEducationHomeworkQueryHomeworkCommitByIdRequest(childrenId: self.homeModel?.childrenId ?? 0, homeworkCreateTime: self.homeModel?.createTime ?? "", homeworkId: self.homeModel?.serviceId ?? 0).request({ [weak self](model: YXSHomeworkDetailModel) in
            guard let weakSelf = self else {return}
            completionHandler?(model)
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    func refreshData() {
        
        // 创建调度组
        let workingGroup = DispatchGroup()
        // 创建队列
        let workingQueue = DispatchQueue(label: "request_queue")
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            // 入组
            workingGroup.enter()
            workingQueue.async {
                // 出组
                self.yxs_studentHomeworkRequest { [weak self](sModel) in
                    guard let weakSelf = self else {return}
                    weakSelf.teacherModel = sModel
                    workingGroup.leave()
                }
            }
            
        } else {
            workingGroup.enter()
            workingQueue.async {
                self.yxs_teacherHomeworkRequest { [weak self](tModel) in
                    guard let weakSelf = self else {return}
                    weakSelf.teacherModel = tModel
                    workingGroup.leave()
                }
            }
            
            // 入组
            workingGroup.enter()
            workingQueue.async {
                // 出组
                self.yxs_studentHomeworkRequest { [weak self](sModel) in
                    guard let weakSelf = self else {return}
                    weakSelf.studentModel = sModel
                    workingGroup.leave()
                }
            }
        }
        
        
        // 调度组里的任务都执行完毕
        workingGroup.notify(queue: workingQueue) {
            DispatchQueue.main.async {
                if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                    
                } else {
                    self.foldView.isHidden = self.studentModel?.id == nil ? true : false
                    self.yxs_foldLayout()
                    self.yxs_checkOpenButtonDisable()
                }
            }
        }
    }
    
    // MARK: - Setter
    var homeModel:YXSHomeListModel? {
        didSet {
            refreshData()
        }
    }
    
    var teacherModel: YXSHomeworkDetailModel? {
        didSet {
            
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                gradeHeader.strGrade = self.teacherModel?.className
                avatarHeader.imgAvatar.sd_setImage(with: URL(string: self.teacherModel?.childHeadPortrait ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
                
                avatarHeader.lbTitle.text = YXSPersonDataModel.sharePerson.personRole == .TEACHER ? self.teacherModel?.childrenName : self.teacherModel?.teacherName
                avatarHeader.lbSubTitle.text = self.teacherModel?.createTime?.yxs_Time()
                //MMYNRA

                if (self.teacherModel?.remark != nil && self.teacherModel?.remark?.count != 0) || (self.teacherModel?.remarkAudioUrl != nil && self.teacherModel?.remarkAudioUrl?.count != 0) {
                    bottomBtnView.isHidden = true
                    commentView.isHidden = false
                    let model = YXSHomeworkDetailCommentViewModel()
                    model.isCancelButtonHidden = true
                    model.comment = self.teacherModel?.remark
                    model.time = self.teacherModel?.updateTime?.yxs_Time()
                    if self.homeModel?.teacherId == self.yxs_user.id {
                        model.isCancelButtonHidden = false
                    }else {
                        model.isCancelButtonHidden = true
                    }
                    model.audioModel = YXSVoiceViewModel()
                    model.audioModel?.voiceUlr = self.teacherModel?.remarkAudioUrl
                    model.audioModel?.voiceDuration = self.teacherModel?.remarkAudioDuration
                    commentView.model = model
                    
                }else {
                    commentView.isHidden = true
                    if self.homeModel?.teacherId == self.yxs_user.id {
                        bottomBtnView.isHidden = false
                        bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 21)
                    }else {
                        bottomBtnView.isHidden = true
                    }
                }
                yxs_refreshLayout()
                
            } else {
                avatarHeader.imgAvatar.sd_setImage(with: URL(string: self.teacherModel?.teacherAvatar ?? ""), placeholderImage: kImageUserIconTeacherDefualtImage)
                
                avatarHeader.lbTitle.text = YXSPersonDataModel.sharePerson.personRole == .TEACHER ? self.teacherModel?.childrenName : self.teacherModel?.teacherName
                avatarHeader.lbSubTitle.text = self.teacherModel?.className
                avatarHeader.lbThirdTitle.text = "| \(self.teacherModel?.createTime?.yxs_Time() ?? "")"
            }
            
            let tmodel = YXSMediaViewModel()
            tmodel.content = self.teacherModel?.content
            tmodel.voiceUrl = self.teacherModel?.audioUrl
            tmodel.voiceDuration = self.teacherModel?.audioDuration
            
            var imgs:[String]? = nil
            if self.teacherModel?.imageUrl?.count ?? 0 > 0 {
                imgs = self.teacherModel?.imageUrl?.components(separatedBy: ",")
            }
            tmodel.images = imgs
            tmodel.bgUrl = self.teacherModel?.bgUrl
            tmodel.videoUrl = self.teacherModel?.videoUrl
            mediaView.model = tmodel
        }
    }
    
    
    var studentModel: YXSHomeworkDetailModel? {
        didSet {
            let smodel = YXSMediaViewModel()
            smodel.content = self.studentModel?.content
            smodel.voiceUrl = self.studentModel?.audioUrl
            smodel.voiceDuration = self.studentModel?.audioDuration
            
            var imgs:[String]? = nil
            if self.studentModel?.imageUrl?.count ?? 0 > 0 {
                imgs = self.studentModel?.imageUrl?.components(separatedBy: ",")
            }
            smodel.images = imgs
            smodel.videoUrl = self.studentModel?.videoUrl
            smodel.bgUrl = self.studentModel?.bgUrl
            foldView.mediaView.model = smodel
            if(self.studentModel?.videoUrl != nil){
                foldView.lbDate.snp.makeConstraints({ (make) in
                    make.top.equalTo(foldView.mediaView.snp_bottom).offset(5)
                })
            }else{
                foldView.lbDate.snp.makeConstraints({ (make) in
                    make.top.equalTo(foldView.mediaView.snp_bottom).offset(5)
                })
            }
            foldView.lbStudent.text = "\(self.studentModel?.childrenName ?? "")完成的作业"
            foldView.lbDate.text = self.studentModel?.createTime?.yxs_Time()
            if(self.studentModel?.remark != nil && self.studentModel?.remark?.count != 0) || (self.studentModel?.remarkAudioUrl != nil && self.studentModel?.remarkAudioUrl?.count != 0) {
                
                foldView.btnCancel.isHidden = true
                
                bottomBtnView.isHidden = true
                commentView.isHidden = false
                let model = YXSHomeworkDetailCommentViewModel()
                model.isCancelButtonHidden = true
                model.comment = self.studentModel?.remark
                model.time = self.studentModel?.updateTime?.yxs_Time()
                
                model.audioModel = YXSVoiceViewModel()
                model.audioModel?.voiceUlr = self.studentModel?.remarkAudioUrl
                model.audioModel?.voiceDuration = self.studentModel?.remarkAudioDuration
                commentView.model = model
                
            }else{
                foldView.btnCancel.isHidden = false
                commentView.isHidden = true
                //                 if self.studentModel?.remarkAudioUrl?.count ?? 0 > 0 {
                //
                //                 }else{
                //                    foldView.lbDate.snp.makeConstraints({ (make) in
                //                            make.top.equalTo(foldView.mediaView.snp_bottom).offset(-10)
                //                    })
                //                }
                foldView.snp.makeConstraints({ (make) in
                    make.bottom.equalTo(0)
                })
            }
        }
    }
    
    
    // MARK: - Action
    @objc func yxs_shareClick(sender: YXSButton) {
        let model = HMRequestShareModel(homeworkId: homeModel?.serviceId ?? 0, homeworkCreateTime: homeModel?.createTime ?? "")
        MBProgressHUD.yxs_showLoading()
        YXSEducationShareLinkRequest(model: model).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            
            let strUrl = json.stringValue
            let title = "\(weakSelf.teacherModel?.teacherName ?? "")布置的作业!"
            let dsc = "\((weakSelf.teacherModel?.createTime ?? "").yxs_Date().toString(format: DateFormatType.custom("MM月dd日")))作业：\(weakSelf.teacherModel?.content ?? "")"

            let shareModel = YXSShareModel(title: title, descriptionText: dsc, link: strUrl)
            YXSShareTool.showCommonShare(shareModel: shareModel)
            
        }) { (msg, code ) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    /// 展开
    @objc func yxs_openClick(sender: YXSButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setTitle("收回", for: .normal)
            yxs_openLayout()
            
        } else {
            sender.setTitle("展开", for: .normal)
            yxs_foldLayout()
        }
    }
    
    @objc func yxs_contactClick(sender:YXSButton) {
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            UIUtil.yxs_chatImRequest(childrenId: homeModel?.childrenId ?? 0, classId: homeModel?.classId ?? 0)
            
        } else {
            self.yxs_pushChatVC(imId: teacherModel?.teacherImId ?? "")
        }
    }
    
    @objc func yxs_addCommentClick(sender:YXSButton) {//老师点评
        let vc = YXSHomeworkCommentController()
        vc.homeModel = homeModel
        vc.childrenIdList = [(homeModel?.childrenId ?? 0)]
        vc.isPop = true
        //点评成功后 刷新数据
        vc.commetCallBack = { () -> () in
            self.refreshData()
        }
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func yxs_deleteCommentClick(sender:YXSButton) {//老师点评撤销
        let alert = UIAlertController.init(title: "提示", message: "您是否撤回本条点评？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            MBProgressHUD.yxs_showLoading()
            YXSEducationHomeworkRemarkCancel(homeworkId: self.homeModel?.serviceId ?? 0, childrenId: self.homeModel?.childrenId ?? 0, homeworkCreateTime: self.homeModel?.createTime ?? "").request({ (json) in
                MBProgressHUD.yxs_hideHUD()
                MBProgressHUD.yxs_showMessage(message: "删除点评成功")
                //刷新页面
                if let viewControllers = self.navigationController?.viewControllers{
                    for vc in viewControllers{
                        if vc is YXSHomeworkDetailViewController{
                            let newVc = vc as? YXSHomeworkDetailViewController
                            newVc?.refreshData()
                            break
                        }
                    }
                }

                self.refreshData()
            }, failureHandler: { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            })
        }))
        alert.popoverPresentationController?.sourceView = UIUtil.curruntNav().view
        UIUtil.curruntNav().present(alert, animated: true, completion: nil)
    }
    
    @objc func yxs_deleteWorkClick(sender:YXSButton) {//学生作业撤销
        NSLog(YXSPersonDataModel.sharePerson.token,"token")
        let alert = UIAlertController.init(title: "提示", message: "您是否撤回该作业？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            MBProgressHUD.yxs_showLoading()
            YXSEducationHomeworkStudentCancelRequest(childrenId: self.homeModel?.childrenId  ?? 0, homeworkCreateTime:self.homeModel?.createTime ?? "" ,homeworkId:self.homeModel?.serviceId  ?? 0).request({ (json) in
                MBProgressHUD.yxs_hideHUD()
                MBProgressHUD.yxs_showMessage(message: "删除作业成功")
                self.homeModel?.commitState = 1
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationStudentWorkNotification), object: [kNotificationModelKey: self.homeModel])
                self.refreshData()


                //刷新页面
                //是否从详情页面进入提交页面
                var isShowDetailVC = false
                if let viewControllers = self.navigationController?.viewControllers{
                    for vc in viewControllers{
                        if vc is YXSHomeworkDetailViewController{
                            let newVc = vc as? YXSHomeworkDetailViewController
                            newVc?.refreshData()
                            isShowDetailVC = true
                            break
                        }
                    }
                }
                if isShowDetailVC {
                   self.removeFromParent()
                   self.view.removeFromSuperview()
                }
                else {
                    let vc1 = YXSHomeworkDetailViewController.init(model: self.homeModel!)
                    var currentVCs = self.navigationController?.viewControllers

                    currentVCs?.removeAll(where: { (vc) -> Bool in
                        return vc.isEqual(self)
                    })
                    currentVCs?.append(vc1)
                    self.navigationController?.setViewControllers(currentVCs!, animated: true)
                }

//                self.navigationController?.popViewController(animated: true)
            }, failureHandler: { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            })
        }))
        alert.popoverPresentationController?.sourceView = UIUtil.curruntNav().view
        UIUtil.curruntNav().present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - LazyLoad
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
//        scrollView.mixedBackgroundColor = MixedColor(normal: kF3F5F9Color, night: kNight282C3B)
        scrollView.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight282C3B)
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight282C3B)
//        view.yxs_addLine(position: .top, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
        return view
    }()
    
    lazy var avatarHeader: SLAvatarContactView = {
        let avatar = SLAvatarContactView()
        avatar.btnChat.addTarget(self, action: #selector(yxs_contactClick(sender:)), for: .touchUpInside)
        return avatar
    }()
    
    lazy var gradeHeader: HomeworkDetailTopHeader = {
        let header = HomeworkDetailTopHeader()
        return header
    }()
    
    lazy var mediaView: YXSMediaView = {
        let view = YXSMediaView()
//        view.voiceTouchedHandler = { [weak self](voiceUlr, voiceDuration) in
//            guard let weakSelf = self else {return}
//            weakSelf.stopAllVoiceAnimation(view: view.voiceView)
//        }
        view.videoTouchedHandler = { [weak self](url) in
            guard let weakSelf = self else {return}
            let vc = SLVideoPlayController()
            vc.videoUrl = url
            weakSelf.navigationController?.pushViewController(vc)
        }
        return view
    }()
    
    lazy var commentView: YXSHomeworkDetailCommentView = {
        let view = YXSHomeworkDetailCommentView()
        view.yxs_addLine(position: .top, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 1)
//        view.voiceTouchedHandler = { [weak self](voiceUlr, voiceDuration) in
//            guard let weakSelf = self else {return}
//            weakSelf.stopAllVoiceAnimation(view: view.commetAudioView)
//        }
        view.btnCancel.addTarget(self, action: #selector(yxs_deleteCommentClick(sender:)), for: .touchUpInside)
        return view
    }()
    
    lazy var bottomBtnView: YXSBottomBtnView = {
        let view = YXSBottomBtnView()
        view.isHidden = true
        view.btnCommit.setTitle("发送点评", for: .normal)
        view.btnCommit.addTarget(self, action: #selector(yxs_addCommentClick(sender:)), for: .touchUpInside)
        return view
    }()
    
    //    lazy var lbContent: YXSLabel = {
    //        let lb = YXSLabel()
    //        lb.numberOfLines = 0
    //        lb.mixedTextColor = MixedColor(normal: 0x575A60, night: 0x000000)
    //        lb.text = ""
    //        lb.font = UIFont.systemFont(ofSize: 16)
    //        return lb
    //    }()
    //
    //    lazy var voiceView: YXSVoiceView = {
    //        let vv = YXSVoiceView(frame: CGRect(x: 0, y: 0, width: 162, height: 44))
    //        return vv
    //    }()
    //
    //    lazy var thumbnailsView: YXSHomeworkThumbnailsView = {
    //        let thumbnail = YXSHomeworkThumbnailsView(leftMargin: 15, rightMargin: 15)
    //        thumbnail.images = ["1","2","3","4"]
    //        return thumbnail
    //    }()
    
    
    lazy var btnOpen: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("展开", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setMixedTitleColor(MixedColor(normal: kNight5E88F7, night: kNight898F9A), forState: .normal)
        btn.addTarget(self, action: #selector(yxs_openClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var foldView: HomeworkFoldDetailView = {
        let view = HomeworkFoldDetailView()
        view.yxs_addLine(position: .top, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 10)
        view.isHidden = true
//        view.mediaView.voiceTouchedHandler = { [weak self](voiceUlr, voiceDuration) in
//            guard let weakSelf = self else {return}
//            weakSelf.stopAllVoiceAnimation(view: view.mediaView.voiceView)
//        }
        view.mediaView.videoTouchedHandler = { [weak self](url) in
            guard let weakSelf = self else {return}
            let vc = SLVideoPlayController()
            vc.videoUrl = url
            weakSelf.navigationController?.pushViewController(vc)
        }
        view.btnCancel.addTarget(self, action: #selector(yxs_deleteWorkClick(sender:)), for: .touchUpInside)
        return view
    }()
    
    // MARK: - Other
    @objc func stopAllVoiceAnimation(view:YXSVoiceView) {
        mediaView.voiceView.stopVoiceAnimation()
        foldView.mediaView.voiceView.stopVoiceAnimation()
        commentView.commetAudioView.stopVoiceAnimation()
        
        if !YXSSSAudioPlayer.sharedInstance.isPause {
            view.startVoiceAnimation()
        }
    }
    
    @objc func yxs_checkOpenButtonDisable() {
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            if (teacherModel?.audioUrl?.count == 0 || teacherModel?.audioUrl == nil) && (mediaView.model?.images?.count == 0 || mediaView.model?.images == nil) && (mediaView.model?.videoUrl?.count == 0 || mediaView.model?.videoUrl == nil) {
                /// 无音频、图片组、视频
                
                let lbW = mediaView.lbContent.frame.size.width
                let strH = mediaView.model?.content?.yxs_getTextRectSize(font: mediaView.lbContent.font, size: CGSize(width: lbW, height: 1000)).size.height ?? 0
                let lines = Int(strH / mediaView.lbContent.font.lineHeight)
                if lines > 3 {
                    btnOpen.isHidden = false
                    
                } else {
                    btnOpen.isHidden = true
                }
            }
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

/// 折叠的View 包含内容、音频、图片、日期
class HomeworkFoldDetailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(lbStudent)
        self.addSubview(btnCancel)
        self.addSubview(mediaView)
        self.addSubview(lbDate)
        
        lbStudent.snp.makeConstraints({ (make) in
            make.left.equalTo(17.5)
            make.top.equalTo(20)
            make.height.equalTo(30)
        })
        
        btnCancel.snp.makeConstraints({ (make) in
            make.right.equalTo(-17)
            make.centerY.equalTo(lbStudent.snp.centerY)
            make.height.equalTo(30)
            make.width.equalTo(50)
        })
        
        mediaView.snp.makeConstraints({ (make) in
            make.top.equalTo(lbStudent.snp.bottom).offset(8)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        })
        
        lbDate.snp.makeConstraints({ (make) in
            make.top.equalTo(mediaView.snp_bottom).offset(8)
            make.left.equalTo(mediaView.snp_left)
            make.bottom.equalTo(-15)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var mediaView: YXSMediaView = {
        let view = YXSMediaView()
        return view
    }()
    
    
    lazy var lbStudent: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: 0x222222, night: 0xC4CDDA)
        lb.text = "张小飞完成的作业"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        return lb
    }()
    
    lazy var btnCancel: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("撤销", for:    .normal)
        btn.setMixedImage(MixedImage(normal: "yxs_homework_cancel", night: "yxs_homework_cancel"), forState: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        return btn
    }()
    
    
    lazy var lbDate: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    lazy var btnEdit: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("修改", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setMixedTitleColor(MixedColor(normal: 0x898F9A, night: 0x000000), forState: .normal)
        return btn
    }()
    
    
    //          YXSEducationHomeworkRemarkCancel(homeworkId: self.homeModel?.serviceId ?? 0, childrenId: self.homeModel?.childrenId ?? 0, homeworkCreateTime: homeModel?.createTime ?? "").request({ (json) in
    //              MBProgressHUD.yxs_hideHUD()
    //              MBProgressHUD.yxs_showMessage(message: "删除点评成功")
    //              self.refreshData()
    //          }, failureHandler: { (msg, code) in
    //              MBProgressHUD.yxs_showMessage(message: msg)
    //          })
}


