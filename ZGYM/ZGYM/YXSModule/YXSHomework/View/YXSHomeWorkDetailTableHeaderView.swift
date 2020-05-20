//
//  YXSHomeWorkDetailTableHeaderView.swift
//  ZGYM
//
//  Created by yanlong on 2020/3/26.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import UIKit
import NightNight
import SwiftyJSON
import YBImageBrowser

/// 筛选作业类型
enum SLJopType{
    case allJobType     //全部作业
    case goodJobType    //优秀作业
    case myJobType     //我的作业
}

let kYXSHomeworkDetialHeaderViewUpdateHeaderViewEvent = "YXSHomeworkDetialHeaderViewUpdateHeaderViewEvent"

class YXSHomeWorkDetailTableHeaderView : UIView {

    var pushToBlock:(()->())?
    var contactClickBlock:(() -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
//            addSubview(topHeaderView)
            addSubview(avatarView)
            addSubview(dateView)
            addSubview(readCommitPanel)
            addSubview(contentLabel)
            addSubview(showAllControl)
            addSubview(nineMediaView)
            addSubview(voiceView)
            addSubview(linkView)
            addSubview(fileFirstView)
            addSubview(fileSecondView)
            addSubview(fileThirdView)
            addSubview(filterBtnView)
        } else {
//            addSubview(topHeaderView)
            addSubview(contactTeacher)
            addSubview(dateView)
            addSubview(contentLabel)
            addSubview(showAllControl)
            addSubview(nineMediaView)
            addSubview(voiceView)
            addSubview(linkView)
            addSubview(fileFirstView)
            addSubview(fileSecondView)
            addSubview(fileThirdView)
            addSubview(filterBtnView)
        }
        addSubview(messageView)
        self.layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            snp.remakeConstraints { (make) in
                make.width.equalTo(superview!)
                make.bottom.equalTo(filterBtnView)
            }
        }
    }

    func layout() {
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
//            topHeaderView.snp.makeConstraints({ (make) in
//                make.top.equalTo(33)
//                make.left.equalTo(15)
//                make.right.equalTo(-15)
//                make.height.equalTo(50)
//            })
            avatarView.snp.makeConstraints { (make) in
                make.top.equalTo(33)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(42)
            }
            dateView.snp.makeConstraints { (make) in
                make.top.equalTo(avatarView.snp_bottom).offset(20)
                make.left.equalTo(avatarView)
                make.right.equalTo(-15)
                make.height.equalTo(20)
            }

            readCommitPanel.snp.makeConstraints({ (make) in
                make.top.equalTo(self.dateView.snp_bottom).offset(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(60)
            })

            contentLabel.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.width.equalTo(SCREEN_WIDTH - 30)
                make.top.equalTo(readCommitPanel.snp_bottom).offset(15)
            }
            
            voiceView.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.width.equalTo(SCREEN_WIDTH - 30)
                make.top.equalTo(contentLabel.snp_bottom).offset(10)
                make.height.equalTo(36)
            }
            nineMediaView.snp.makeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(voiceView.snp_bottom).offset(10)
            }
//            mediaView.snp.makeConstraints({ (make) in
//                make.top.equalTo(self.readCommitPanel.snp_bottom).offset(20)
//                make.left.equalTo(15)
//                make.right.equalTo(-15)
//            })


            linkView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.nineMediaView.snp_bottom).offset(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(44)
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
            })

            filterBtnView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.fileThirdView.snp_bottom).offset(10)
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(70)
                make.bottom.equalTo(0)
            })
        } else {
            //            self.topHeaderView.snp.makeConstraints({ (make) in
            //                make.top.equalTo(33)
            //                make.left.equalTo(15)
            //                make.right.equalTo(-15)
            //            })

            contactTeacher.snp.makeConstraints({ (make) in
                make.top.equalTo(33)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(42)
            })
            dateView.snp.makeConstraints { (make) in
                make.top.equalTo(contactTeacher.snp_bottom).offset(20)
                make.left.equalTo(contactTeacher)
                make.right.equalTo(-15)
                make.height.equalTo(20)
            }
            contentLabel.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.width.equalTo(SCREEN_WIDTH - 30)
                make.top.equalTo(dateView.snp_bottom).offset(15)
            }
            
            voiceView.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.width.equalTo(SCREEN_WIDTH - 30)
                make.top.equalTo(contentLabel.snp_bottom).offset(10)
                make.height.equalTo(36)
            }
            nineMediaView.snp.makeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(voiceView.snp_bottom).offset(10)
            }
//            mediaView.snp.makeConstraints({ (make) in
//                make.top.equalTo(self.dateView.snp_bottom).offset(40)
//                make.left.equalTo(15)
//                make.right.equalTo(-15)
//            })
//
            linkView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.nineMediaView.snp_bottom).offset(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(44)
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
            })
            
            filterBtnView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.fileThirdView.snp_bottom).offset(10)
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(70)
                make.bottom.equalTo(0)
            })
        }

    }

    // MARK: - Setter
    var messageModel: YXSPunchCardMessageTipsModel? {
        didSet {
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                if let messageModel = messageModel,messageModel.count ?? 0 > 0{
                    messageView.snp.remakeConstraints { (make) in
                        make.left.right.top.equalTo(0).priorityHigh()
                        make.height.equalTo(42.5)
                    }
                    avatarView.snp.remakeConstraints({ (make) in
                        make.top.equalTo(messageView.snp_bottom).offset(0)
                        make.left.equalTo(15)
                        make.right.equalTo(-15)
                        make.height.equalTo(42)
                    })
                    messageView.isHidden = false
                    messageView.setMessageTipsModel(messageModel: messageModel)
                } else {
                    avatarView.snp.remakeConstraints({ (make) in
                        make.top.equalTo(33)
                        make.left.equalTo(15)
                        make.right.equalTo(-15)
                        make.height.equalTo(42)
                    })
                    messageView.isHidden = true
                }
            } else {
                if let messageModel = messageModel,messageModel.count ?? 0 > 0{
                    messageView.snp.remakeConstraints { (make) in
                        make.left.right.top.equalTo(0).priorityHigh()
                        make.height.equalTo(42.5)
                    }
                    contactTeacher.snp.remakeConstraints({ (make) in
                        make.top.equalTo(messageView.snp_bottom).offset(0)
                        make.left.equalTo(15)
                        make.right.equalTo(-15)
                        make.height.equalTo(42)
                    })
                    messageView.isHidden = false
                    messageView.setMessageTipsModel(messageModel: messageModel)
                } else {
                    contactTeacher.snp.remakeConstraints({ (make) in
                        make.top.equalTo(33)
                        make.left.equalTo(15)
                        make.right.equalTo(-15)
                        make.height.equalTo(42)
                    })
                    messageView.isHidden = true
                }
            }
        }
    }
    func setModel(model:YXSHomeworkDetailModel) {
        self.model = model
        var messagemodel:YXSPunchCardMessageTipsModel? = YXSPunchCardMessageTipsModel.init(JSONString: "{\"count\":0}")
        messagemodel?.count = self.model?.messageCount
        messagemodel?.commentsUserInfo?.avatar = self.model?.messageAvatar
        messagemodel?.commentsUserInfo?.userType = self.model?.messageUserType
        self.messageModel = messagemodel
        filterBtnView.model = self.model

        if model.endTime?.count ?? 0 > 0 {
            dateView.isHidden = false
            if self.model?.endTimeIsUnlimited ?? false {
                dateView.title = "截止日期：不限时"
            } else {
                let endDateStr = self.model?.endTime?.yxs_Date().toString(format: .custom("yyyy-MM-dd HH:mm"))
                dateView.title = "截止日期：\(endDateStr ?? "")"
            }
        } else {
            dateView.isHidden = true
        }
        
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            if model.createTime?.count ?? 0 > 0 {
                var teacherName = "我"
                if self.model?.teacherName != YXSPersonDataModel.sharePerson.userModel.name {
                    teacherName = self.model?.teacherName ?? ""
                }
                avatarView.imgAvatar.sd_setImage(with: URL(string: self.model?.teacherAvatar ?? ""), placeholderImage: kImageUserIconTeacherDefualtImage)
                avatarView.lbTitle.text = "\(teacherName) ｜ \(self.model?.createTime?.yxs_Time() ?? "")"
                avatarView.lbSubTitle.text = self.model?.className
                avatarView.isHidden = false
            } else {
                avatarView.isHidden = true
            }
        } else {
            if model.createTime?.count ?? 0 > 0 {
                contactTeacher.isHidden = false
                contactTeacher.imgAvatar.sd_setImage(with: URL(string: self.model?.teacherAvatar ?? ""), placeholderImage: kImageUserIconTeacherDefualtImage)
                contactTeacher.lbTitle.text = self.model?.teacherName
                contactTeacher.lbSubTitle.text = self.model?.className
                contactTeacher.lbThirdTitle.text = "| \(self.model?.createTime?.yxs_Time() ?? "")"
            } else {
                contactTeacher.isHidden = true
            }
            
        }


        readCommitPanel.firstValue = String(self.model?.readList?.count ?? 0)
        readCommitPanel.firstTotal = String(self.model?.memberCount ?? 0)

        if self.model?.onlineCommit == 1 {
            readCommitPanel.lbTitle2.text = "提交"
            readCommitPanel.secondValue = String(self.model?.committedList?.count ?? 0)
            readCommitPanel.secondTotal = String(self.model?.memberCount ?? 0)
            readCommitPanel.lbTitle2.isHidden = false
            readCommitPanel.lbCommit.isHidden = false
            readCommitPanel.lbTotal2.isHidden = false
            filterBtnView.isHidden = false
        } else {
            readCommitPanel.lbTitle2.isHidden = true
            readCommitPanel.lbCommit.isHidden = true
            readCommitPanel.lbTotal2.isHidden = true
            filterBtnView.isHidden = true
        }

        var last:UIView = contentLabel
        UIUtil.yxs_setLabelParagraphText(contentLabel, text: self.model?.content)
        let paragraphStye = NSMutableParagraphStyle()
        paragraphStye.lineSpacing = kMainContentLineHeight
        paragraphStye.lineBreakMode = NSLineBreakMode.byWordWrapping
        let dic = [NSAttributedString.Key.font: kTextMainBodyFont, NSAttributedString.Key.paragraphStyle:paragraphStye]
        let height = UIUtil.yxs_getTextHeigh(textStr: self.model?.content, attributes: dic , width: SCREEN_WIDTH - 30)
        contentLabel.numberOfLines = model.isShowContentAll ? 0 : 3
        if height < 20 {
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                contentLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(15)
                    make.top.equalTo(readCommitPanel.snp_bottom).offset(15)
                }
            } else {
                contentLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(15)
                    make.top.equalTo(dateView.snp_bottom).offset(15)
                }
            }
            
            contentLabel.sizeToFit()
        }
        else {
            model.confingHeight()
            if model.needShowAllButton{
                showAllControl.isHidden = false
                showAllControl.isSelected = model.isShowContentAll
                showAllControl.snp.remakeConstraints { (make) in
                    make.left.equalTo(contentLabel)
                    make.top.equalTo(contentLabel.snp_bottom).offset(9)
                    make.height.equalTo(26)
                }
                last = showAllControl
            } else {
                showAllControl.isHidden = true
                showAllControl.snp.removeConstraints()
            }
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                contentLabel.snp.remakeConstraints({ (make) in
                    make.left.equalTo(15)
                    make.width.equalTo(SCREEN_WIDTH - 30)
                    make.top.equalTo(readCommitPanel.snp_bottom).offset(15)
                })
            } else {
                contentLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(15)
                    make.width.equalTo(SCREEN_WIDTH - 30)
                    make.top.equalTo(dateView.snp_bottom).offset(15)
                }
            }
            
        }
        
        if self.model?.hasVoice ?? false {
            voiceView.isHidden = false
            voiceView.id = "\(self.model?.id ?? 0)"
            let voiceModel = YXSVoiceViewModel()
            voiceView.width = SCREEN_WIDTH - 30 - 41
            voiceModel.voiceDuration = self.model?.audioDuration
            voiceModel.voiceUlr = self.model?.audioUrl
            voiceView.model = voiceModel
            voiceView.snp.remakeConstraints { (make) in
                make.top.equalTo(last.snp_bottom).offset(10)
                make.left.equalTo(15)
                make.width.equalTo(SCREEN_WIDTH - 30)
                make.height.equalTo(36)
            }
        } else {
            voiceView.isHidden = true
            voiceView.snp.remakeConstraints { (make) in
                make.height.equalTo(0)
                make.left.equalTo(15)
                make.width.equalTo(SCREEN_WIDTH - 30)
                make.top.equalTo(last.snp_bottom).offset(0)
            }
        }

        if self.model?.imgs.count ?? 0 > 0{
            nineMediaView.isHidden = false
            nineMediaView.medias = self.model?.imgs
            nineMediaView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(voiceView.snp_bottom).offset(10)
            }
        }else{
            nineMediaView.isHidden = true
            nineMediaView.snp.updateConstraints { (make) in
                make.top.equalTo(voiceView.snp_bottom).offset(0)
            }
        }

//        let mediaModel = YXSMediaViewModel()//(content: self.model?.content, voiceUrl: self.model?.audioUrl, voiceDuration: self.model?.audioDuration, images: imgs)
//        mediaModel.content = self.model?.content
//        mediaModel.voiceUrl = self.model?.audioUrl
//        mediaModel.voiceDuration = self.model?.audioDuration
//        mediaModel.images = imgs
//        mediaModel.bgUrl = self.model?.bgUrl
//        mediaModel.videoUrl = self.model?.videoUrl
//        mediaView.voiceView.id = "\(self.model?.id ?? 0)"
//        mediaView.layoutIfNeeded();
//        mediaView.model = mediaModel
//        mediaView.layoutIfNeeded();
//        let height = mediaView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
//            mediaView.snp.remakeConstraints({ (make) in
//                make.top.equalTo(self.readCommitPanel.snp_bottom).offset(20)
//                make.left.equalTo(15)
//                make.right.equalTo(-15)
//                make.height.equalTo(height)
//            })
//        } else {
//            mediaView.snp.makeConstraints({ (make) in
//                make.top.equalTo(self.dateView.snp_bottom).offset(20)
//                make.left.equalTo(15)
//                make.right.equalTo(-15)
//                make.height.equalTo(height)
//            })
//        }

        linkView.strLink = self.model?.link ?? ""
        if self.model?.link == nil || self.model?.link?.count == 0 {
            linkView.isHidden = true
            linkView.snp.updateConstraints({ (make) in
                make.top.equalTo(self.nineMediaView.snp_bottom).offset(0)
                make.height.equalTo(0)
            })
        } else {
            linkView.isHidden = false
            linkView.snp.remakeConstraints({ (make) in
                make.top.equalTo(self.nineMediaView.snp_bottom).offset(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(44)
            })
        }
        
        if self.model?.fileList.count ?? 0 > 0 {
            for index in 0..<(self.model?.fileList.count)!{
                switch index {
                case 0:
                    fileFirstView.isHidden = false
                    fileFirstView.setModel(model: (self.model?.fileList[index])!)
                    fileSecondView.isHidden = true
                    fileThirdView.isHidden = true
                    fileFirstView.snp.updateConstraints({ (make) in
                        make.top.equalTo(self.linkView.snp_bottom).offset(10)
                        make.height.equalTo(44)
                    })
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
        
        
        if self.model?.onlineCommit == 0 {
            filterBtnView.snp.updateConstraints { (make) in
                make.height.equalTo(1)
            }
        }
        superview?.layoutIfNeeded()
    }
    var model: YXSHomeworkDetailModel?

    // MARK: - Action
    /// 阅读
    @objc func readListClick() {
        pushToBlock?()
    }

    /// 提交
    @objc func commitListClick() {
        pushToBlock?()
    }

    @objc func alertClick(sender: YXSButton) {
        pushToBlock?()
    }

    @objc func contactClick(sender:YXSButton) {
        contactClickBlock?()
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
            UIUtil.currentNav().pushViewController(wk)
        }
    }
    
    @objc func showAllClick(){
        self.model?.isShowContentAll = !(self.model?.isShowContentAll ?? false)
        showAllControl.isSelected = self.model?.isShowContentAll ?? false
        setModel(model: self.model!)
        yxs_routerEventWithName(eventName:kYXSHomeworkDetialHeaderViewUpdateHeaderViewEvent,info: ["isShow":self.model?.isShowContentAll ?? false])
    }

    // MARK: - LazyLoad
    /// 一年级3班  我 ｜ 2019/11/13 14:30
//    lazy var topHeaderView: HomeworkDetailTopHeader = {
//        let header = HomeworkDetailTopHeader()
//        return header
//    }()

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

//    lazy var mediaView: YXSMediaView = {
//        let view = YXSMediaView()
//        view.voiceMax = 300.0
//        return view
//    }()
    
    lazy var contentLabel: YXSEventCopyLabel = {
        let label = YXSEventCopyLabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var nineMediaView: YXSNineMediaView = {
        let nineMediaView = YXSNineMediaView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        nineMediaView.edges = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        return nineMediaView
    }()
    
    lazy var voiceView: YXSListVoiceView = {
        let voiceView = YXSListVoiceView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 36), complete: {
            [weak self] (url, duration)in
            guard let strongSelf = self else { return }
        })
        return voiceView
    }()

    lazy var linkView: YXSLinkView = {
        let link = YXSLinkView()
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
        chat.isHidden = true
        return chat
    }()
    
    lazy var avatarView: YXSAvatarView = {
        let view = YXSAvatarView.init(style: .TitleSubTitle)
        view.isHidden = true
        return view
    }()

    lazy var dateView: YXSCustomImageControl = {
        let view = YXSCustomImageControl(imageSize: CGSize(width: 19, height: 17), position: YXSImagePositionType.left)
        view.locailImage = "yxs_solitaire_calendar"
        view.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        view.font = UIFont.systemFont(ofSize: 14)
        view.isHidden = true
        return view
    }()
    
    lazy var filterBtnView: HomeworkDetailFilterBtnView = {
        let filterView = HomeworkDetailFilterBtnView()
        filterView.isHidden = true
        let cl = NightNight.theme == .night ? kNightBackgroundColor : kTableViewBackgroundColor
        filterView.yxs_addLine(position: .top, color: cl, leftMargin: 0, rightMargin: 0, lineHeight: 10)
        filterView.yxs_addLine(position: .bottom, color: cl, leftMargin: 0, rightMargin: 0, lineHeight: 1)
        return filterView
    }()
    
    lazy var messageView: YXSFriendsCircleMessageView = {
        let messageView = YXSFriendsCircleMessageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 42.5))
        messageView.isHidden = true
        return messageView
    }()
    
    lazy var showAllControl: YXSCustomImageControl = {
        let showAllControl = YXSCustomImageControl.init(imageSize: CGSize.init(width: 14, height: 14), position: YXSImagePositionType.right, padding: 5.5)
        showAllControl.mixedTextColor = MixedColor(normal: kBlueColor, night: kBlueColor)
        showAllControl.setTitle("展开", for: .normal)
        showAllControl.setTitle("收起", for: .selected)
        showAllControl.font = UIFont.boldSystemFont(ofSize: 14)
        showAllControl.setImage(UIImage.init(named: "down_gray"), for: .normal)
        showAllControl.setImage(UIImage.init(named: "up_gray"), for: .selected)
        showAllControl.addTarget(self, action: #selector(showAllClick), for: .touchUpInside)
        showAllControl.isSelected = false
        showAllControl.isHidden = true
        return showAllControl
    }()
}

class HomeworkDetailFilterBtnView : UIView {

    var jobTypeChankBlock:((_ index:Int)->())?
    var jobStatusChankBlock:((_ sender: UIButton) -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(allBtn)
        addSubview(goodBtn)
        addSubview(myBtn)
        addSubview(filterBtn)
        self.layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {
        allBtn.snp.makeConstraints { (make) in
            make.left.equalTo(18)
            make.top.equalTo(20)
            make.height.equalTo(40)
            make.width.equalTo(90)
        }

        goodBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.allBtn.snp_right).offset(10)
            make.top.equalTo(20)
            make.height.equalTo(40)
            make.width.equalTo(90)
        }

        myBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.goodBtn.snp_right).offset(10)
            make.top.equalTo(20)
            make.height.equalTo(40)
            make.width.equalTo(90)
        }

        filterBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-18)
            make.top.equalTo(20)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
    }

    var model: YXSHomeworkDetailModel? {
        didSet {
            if self.model?.onlineCommit == 0 {
                self.allBtn.isHidden = true
                self.goodBtn.isHidden = true
                self.myBtn.isHidden = true
                self.filterBtn.isHidden = true
                self.allBtn.snp.removeConstraints()
                self.goodBtn.snp.removeConstraints()
                self.myBtn.snp.removeConstraints()
                self.filterBtn.snp.removeConstraints()
            } else {
                if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                    self.myBtn.isHidden = true
                    self.myBtn.snp.removeConstraints()
                } else {
                    if self.model?.homeworkVisible == 0 {
                        self.allBtn.isHidden = true
                        goodBtn.snp.remakeConstraints { (make) in
                            make.left.equalTo(18)
                            make.top.equalTo(20)
                            make.height.equalTo(40)
                            make.width.equalTo(90)
                        }
                        goodBtn.isSelected = true
                        goodBtn.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#698DF6"), leftMargin: 20, rightMargin: 20, lineHeight: 2)
                        allBtn.yxs_removeLine()
                        myBtn.yxs_removeLine()
                        allBtn.isSelected = false
                        myBtn.isSelected = false
                        self.filterBtn.isHidden = true
                    }
//                    self.filterBtn.isHidden = true
                }
            }
        }
    }

    /// 作业类型筛选按钮点击
    @objc func jobTypeClick(sender: UIButton) {
        switch sender.tag {
        case 10001:
            allBtn.yxs_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#698DF6"), night: UIColor.yxs_hexToAdecimalColor(hex: "#698DF6")), leftMargin: 20, rightMargin: 20, lineHeight: 2)
            goodBtn.yxs_removeLine()
            myBtn.yxs_removeLine()
            goodBtn.isSelected = false
            myBtn.isSelected = false
            filterBtn.isHidden = false
            break
        case 10002:
            goodBtn.yxs_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#698DF6"), night: UIColor.yxs_hexToAdecimalColor(hex: "#698DF6")), leftMargin: 20, rightMargin: 20, lineHeight: 2)
            allBtn.yxs_removeLine()
            myBtn.yxs_removeLine()
            allBtn.isSelected = false
            myBtn.isSelected = false
            filterBtn.isHidden = true
            break
        case 10003:
            myBtn.yxs_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#698DF6"), night: UIColor.yxs_hexToAdecimalColor(hex: "#698DF6")), leftMargin: 20, rightMargin: 20, lineHeight: 2)
            allBtn.yxs_removeLine()
            goodBtn.yxs_removeLine()
            allBtn.isSelected = false
            goodBtn.isSelected = false
            filterBtn.isHidden = true
            break
        default:
            break
        }
        sender.isSelected =  true

        jobTypeChankBlock?(sender.tag)
    }

    /// 老师身份 作业状态筛选按钮点击  全部/未点评/已点评
    @objc func jobStatusClick(sender: UIButton) {
        jobStatusChankBlock?(sender)
    }

    /// 全部作业按钮
    lazy private var allBtn: UIButton = {
        let button = UIButton.init()
        button.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#979799"), night: UIColor.yxs_hexToAdecimalColor(hex: "#565656")), forState: .normal)
        button.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#565656"), night: UIColor.white), forState: .selected)
        button.isSelected = true
        button.yxs_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#698DF6"), night: UIColor.yxs_hexToAdecimalColor(hex: "#698DF6")), leftMargin: 20, rightMargin: 20, lineHeight: 2)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("全部作业", for: .normal)
        button.tag = 10001
        button.addTarget(self, action: #selector(jobTypeClick(sender:)), for: .touchUpInside)
        return button
    }()


    /// 优秀作业按钮
    lazy private var goodBtn: UIButton = {
        let button = UIButton.init()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#979799"), night: UIColor.yxs_hexToAdecimalColor(hex: "#565656")), forState: .normal)
        button.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#565656"), night: UIColor.white), forState: .selected)
        button.setTitle("优秀作业", for: .normal)
        button.tag = 10002
        button.addTarget(self, action: #selector(jobTypeClick(sender:)), for: .touchUpInside)
        return button
    }()


    /// 我的作业按钮
    lazy private var myBtn: UIButton = {
        let button = UIButton.init()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#979799"), night: UIColor.yxs_hexToAdecimalColor(hex: "#565656")), forState: .normal)
        button.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#565656"), night: UIColor.white), forState: .selected)
//        button.setBackgroundImage(UIImage.yxs_image(with: UIColor.yxs_hexToAdecimalColor(hex: "#219BD5")), for: .selected)
//        button.setBackgroundImage(UIImage.yxs_image(with: UIColor.yxs_hexToAdecimalColor(hex: "#CCCCCC")), for: .normal)
        button.setTitle("我的作业", for: .normal)
        button.tag = 10003
        button.addTarget(self, action: #selector(jobTypeClick(sender:)), for: .touchUpInside)
        return button
    }()

    /// 筛选按钮
    lazy private var filterBtn: UIButton = {
        let button = UIButton.init()
        button.setMixedImage(MixedImage(normal: "yxs_screening", night: "yxs_screening_night"), forState: .normal)
        button.addTarget(self, action: #selector(jobStatusClick(sender:)), for: .touchUpInside)
        return button
    }()

}
