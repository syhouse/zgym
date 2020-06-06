//
//  YXSSolitaireNewDetailHeaderView.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/2.
//  Copyright © 2020 zgym. All rights reserved.
//

//
//  YXSSolitaireDetailHeaderView.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/2.
//  Copyright © 2020 zgym. All rights reserved.
//

import NightNight
import UIKit

class YXSSolitaireNewDetailHeaderView: UITableViewHeaderFooterView {

    var videoTouchedBlock:((_ videoUlr: String)->())?

    var pushToContainerBlock: (()->())?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightForegroundColor)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(avatarView)
        self.contentView.addSubview(mediaView)
        self.contentView.addSubview(linkView)
        self.contentView.addSubview(dateView)

        mediaView.videoTouchedHandler = { [weak self](url) in
            guard let weakSelf = self else {return}
            weakSelf.videoTouchedBlock?(url)
        }

        titleLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(17)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        })
        avatarView.snp.makeConstraints({ (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(20)
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
            self.contentView.addSubview(readCommitPanel)
            readCommitPanel.snp.makeConstraints({ (make) in
                make.top.equalTo(self.dateView.snp_bottom).offset(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(60)
            })

            mediaView.snp.makeConstraints({ (make) in
                make.top.equalTo(readCommitPanel.snp_bottom).offset(17.5)
                make.left.equalTo(15)
                make.right.equalTo(-15)
            })
            
            linkView.snp.makeConstraints({ (make) in
                make.top.equalTo(mediaView.snp_bottom).offset(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(44)
                make.bottom.equalTo(-27)
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
    var detailModel: YXSSolitaireDetailModel?
    func setHeaderViewModel(detailModel: YXSSolitaireDetailModel?){
        self.detailModel = detailModel
        avatarView.imgAvatar.sd_setImage(with: URL(string: detailModel?.teacherAvatar ?? ""), placeholderImage: kImageUserIconTeacherDefualtImage)
        titleLabel.text = detailModel?.title
        avatarView.lbTitle.text = detailModel?.teacherName//"王老师"
        avatarView.lbSubTitle.text = detailModel?.createTime?.yxs_Time()//"1小时前"
        dateView.title = "截止日期：\(detailModel?.endTime ?? "")"
        let mModel = YXSMediaViewModel()
        mModel.content = detailModel?.content
        mModel.voiceUrl = detailModel?.audioUrl
        mModel.voiceDuration = detailModel?.audioDuration
        var imgs:[String]? = nil
        if detailModel?.imageUrl?.count ?? 0 > 0 {
            imgs = detailModel?.imageUrl?.components(separatedBy: ",")
        }
        mModel.images = imgs
        mModel.videoUrl = detailModel?.videoUrl
        mModel.bgUrl = detailModel?.bgUrl
        mediaView.model = mModel

        readCommitPanel.firstValue = String(detailModel?.readCount ?? 0)
        readCommitPanel.firstTotal = String(detailModel?.classChildrenCount ?? 0)
        
        readCommitPanel.secondValue = String(detailModel?.commitCount ?? 0)
        readCommitPanel.secondTotal = String(detailModel?.classChildrenCount ?? 0)
        
        linkView.strLink = detailModel?.link ?? ""
        if detailModel?.link == nil || detailModel?.link?.count == 0 {
            linkView.isHidden = true
            linkView.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            
        } else {
            linkView.isHidden = false
            linkView.snp.updateConstraints({ (make) in
                make.height.equalTo(44)
            })
        }
        linkView.block = { (url) in
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
    }
    
    // MARK: - action
    
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
        pushToContainerBlock?()
    }
    
    // MARK: - getter&setter
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
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return label
    }()

}
