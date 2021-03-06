//
//  YXSHomeworkDetailSectionHeaderView.swift
//  ZGYM
//
//  Created by yanlong on 2020/3/30.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import UIKit
import NightNight

let kHomeworkPictureGraffitiNextEvent = "HomeworkPictureGraffitiNextEvent"

// MARK: - public   0 评论 1点赞 1 显示所有 2修改 3撤回
enum HomeworkCommentCellBlockType: Int {
    /// 评论
    case comment
    /// 点赞
    case praise
    /// 显示所有
    case showAll
    /// 修改
    case change
    /// 撤回
    case recall
    /// 查看历史优秀作业
    case lookHomeWorkGood
    /// 查看上周班级之星
    case lookLastWeakClassStart
}

class YXSHomeworkDetailSectionHeaderView: UITableViewHeaderFooterView {

    var currentSection: Int!
    var hmModel : YXSHomeworkDetailModel?
    var goodClick:((_ model:YXSHomeworkDetailModel)->())?
    var homeWorkChangeBlock:((_ sender: UIButton,_ model:YXSHomeworkDetailModel)->())?
    var reviewControlBlock:((_ model:YXSHomeworkDetailModel)->())?
    public var cellBlock: ((HomeworkCommentCellBlockType,_ model:YXSHomeworkDetailModel) -> ())?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.mixedBackgroundColor = MixedColor.init(normal: UIColor.white, night: kNightBackgroundColor)
        addSubview(imgAvatar)
        addSubview(lbName)
        addSubview(lbTime)
        addSubview(homeWorkChangeButton)
        addSubview(goodControl)
        addSubview(contentLabel)
        addSubview(showAllButton)
        addSubview(nineMediaView)
        addSubview(voiceView)

        addSubview(classStartLabelBtn)
        addSubview(goodHomeworkLabelBtn)
        addSubview(reviewControl)
        addSubview(commentButton)
        addSubview(praiseButton)
        addSubview(finishView)
        addSubview(remarkView)
        addSubview(favView)
        self.layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {
        imgAvatar.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(15)
            make.width.height.equalTo(40)
        }
        
        finishView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 50.5, height: 45))
            make.left.equalTo(150)
            make.top.equalTo(imgAvatar).offset(-2)
        }

        goodControl.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(25)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }

        lbName.snp.makeConstraints { (make) in
            make.left.equalTo(imgAvatar.snp_right).offset(15)
            make.right.equalTo(goodControl.snp_left).offset(-10)
            make.top.equalTo(imgAvatar.snp_top)
            make.height.equalTo(20)
        }
        lbTime.snp.makeConstraints({ (make) in
            make.bottom.equalTo(imgAvatar.snp_bottom)
            make.height.equalTo(20)
            make.left.equalTo(lbName)
            make.right.equalTo(reviewControl.snp_left).offset(-10)
        })
        

        homeWorkChangeButton.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.right.equalTo(-20)
            make.width.equalTo(30)
            make.height.equalTo(16)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(SCREEN_WIDTH - 30)
            make.top.equalTo(imgAvatar.snp_bottom).offset(15)
        }
        
        classStartLabelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(reviewControl)
            make.width.equalTo(115)
            make.height.equalTo(26)
        }
        
        goodHomeworkLabelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(classStartLabelBtn.snp_right).offset(10)
            make.centerY.equalTo(reviewControl)
            make.height.equalTo(26)
        }

        praiseButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(reviewControl)
            make.width.height.equalTo(30)
        }

        commentButton.snp.makeConstraints { (make) in
            make.right.equalTo(praiseButton.snp_left).offset(-30)
            make.centerY.equalTo(reviewControl)
            make.width.height.equalTo(30)
        }

        remarkView.snp.makeConstraints { (make) in
            make.top.equalTo(reviewControl.snp_bottom).offset(15)
            make.left.equalTo(imgAvatar)
            make.width.equalTo(SCREEN_WIDTH - 30)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        ///是否显示点评
        var isShowRemark : Bool = false
        if self.model?.isRemark == 1 {
            if self.hmModel?.remarkVisible == 1 {
                isShowRemark = true
            } else {
                if self.hmModel?.isMyPublish ?? false {
                    isShowRemark = true
                } else {
                    isShowRemark = self.model?.isMySubmit ?? false
                }
            }
        }
        if isShowRemark {
            favView.y = remarkView.tz_bottom + 12.5
        } else {
            favView.y = reviewControl.tz_bottom + 12.5
        }
    }

    // MARK: - Setter
    
    func setModel(model:YXSHomeworkDetailModel) {
        self.model = model
        favView.isHidden = true
        goodControl.isHidden = true
        remarkView.isHidden = true
        voiceView.isHidden = true
        reviewControl.isHidden = true
        finishView.isHidden = true
        classStartLabelBtn.isHidden = true
        goodHomeworkLabelBtn.isHidden = true
        showAllButton.isHidden = true
        ///是否展示修改按钮
        if self.model?.isRemark == 1 || self.model?.isGood == 1{
            homeWorkChangeButton.isHidden = true
        } else {
            homeWorkChangeButton.isHidden = !(self.model?.isMySubmit ?? false)
        }
        
        updateButtons()
        voiceView.snp_removeConstraints()
        favView.snp_removeConstraints()
        finishView.isHidden = !(self.model?.isGood == 1)
//            //其他老师&家长展示盖章
//            if !(self.hmModel?.isMyPublish ?? false) && (self.model?.isGood == 1){
//                finishView.isHidden = false
//            }
        goodControl.isHidden = !(self.hmModel?.isMyPublish ?? false)
        commentButton.isHidden = self.hmModel?.isMyPublish ?? false
        praiseButton.isHidden = self.hmModel?.isMyPublish ?? false
        reviewControl.isHidden = !(self.hmModel?.isMyPublish ?? false)
        if self.model?.isGood == 1 {
            goodControl.isSelected = true
        } else {
            goodControl.isSelected = false
        }
        
        //上周班级之星显示的处理逻辑
        if let myClassStartRank = self.hmModel?.getMyClassStartRank(id: self.model?.childrenId ?? 0), myClassStartRank > 0 {
            //当前孩子在上周班级之星列表
            classStartLabelBtn.isHidden = false
            switch myClassStartRank {
            case 1:
                classStartLabelBtn.locailImage = "yxs_punch_detial_first"
                case 2:
                classStartLabelBtn.locailImage = "yxs_punch_detial_secend"
                case 3:
                classStartLabelBtn.locailImage = "yxs_punch_detial_thrid"
            default:
                break
            }
            classStartLabelBtn.snp.updateConstraints { (make) in
                make.width.equalTo(115)
            }
            goodHomeworkLabelBtn.snp.updateConstraints { (make) in
                make.left.equalTo(classStartLabelBtn.snp_right).offset(10)
            }
        } else {
            //当前孩子不在上周班级之星列表
            classStartLabelBtn.isHidden = true
            classStartLabelBtn.snp.updateConstraints { (make) in
                make.width.equalTo(0)
            }
            goodHomeworkLabelBtn.snp.updateConstraints { (make) in
                make.left.equalTo(classStartLabelBtn.snp_right).offset(0)
            }
        }
        
        // 历史优秀作业显示
        let goodCount: Int = self.hmModel?.getChildGoodCount(id: self.model?.childrenId ?? 0) ?? 0
        if  goodCount > 0 && self.model?.isShowLookGoodButton ?? true {
            goodHomeworkLabelBtn.isHidden = false
            goodHomeworkLabelBtn.title = "优秀作业+\(goodCount)"
        }
        
        imgAvatar.sd_setImage(with: URL(string: self.model?.childHeadPortrait ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
        var text = self.model?.childrenName
        for model in Relationships{
            if model.paramsKey == self.model?.relationship{
                text! += model.text
                break
            }
        }
        lbName.text = text
        lbTime.text = self.model?.createTime?.yxs_Time()
        UIUtil.yxs_setLabelParagraphText(contentLabel, text: self.model?.content)
        let paragraphStye = NSMutableParagraphStyle()
        paragraphStye.lineSpacing = kMainContentLineHeight
        paragraphStye.lineBreakMode = NSLineBreakMode.byWordWrapping
        let dic = [NSAttributedString.Key.font: kTextMainBodyFont, NSAttributedString.Key.paragraphStyle:paragraphStye]
        let height = UIUtil.yxs_getTextHeigh(textStr: self.model?.content, attributes: dic , width: SCREEN_WIDTH - 30)
        contentLabel.numberOfLines = model.isShowContentAll ? 0 : 3
        var last: UIView! = contentLabel
        var lastBottom = 10
        if height < 20 {
            contentLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
//                    make.height.equalTo(height)
                make.top.equalTo(imgAvatar.snp_bottom).offset(15)
            }
            contentLabel.sizeToFit()
        }
        else {
            contentLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(15)
                make.width.equalTo(SCREEN_WIDTH - 30)
                make.top.equalTo(imgAvatar.snp_bottom).offset(15)
            })
            if model.needShowAllButton{
                showAllButton.isHidden = false
                showAllButton.isSelected = model.isShowContentAll
                showAllButton.snp.remakeConstraints { (make) in
                    make.left.equalTo(contentLabel)
                    make.top.equalTo(contentLabel.snp_bottom).offset(9)
                    make.height.equalTo(26)
                }
                last = showAllButton
            }else{
                showAllButton.isHidden = true
                showAllButton.snp.removeConstraints()
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
                make.left.equalTo(contentLabel)
                make.width.equalTo(SCREEN_WIDTH - 30)
                make.height.equalTo(36)
            }
            last = voiceView
            lastBottom = 14
        } else {
            voiceView.isHidden = true
        }
        
        if self.model?.imgs.count ?? 0 > 0{
            nineMediaView.isHidden = false
            nineMediaView.isGraffiti = self.hmModel?.isMyPublish ?? false
            nineMediaView.medias = self.model?.imgs
            nineMediaView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(last.snp_bottom).offset(lastBottom)
            }
            last = nineMediaView
        }else{
            nineMediaView.isHidden = true
        }
        
        reviewControl.snp.remakeConstraints({ (make) in
            make.top.equalTo(last.snp_bottom).offset(10)
            make.right.equalTo(-15)
            make.width.equalTo(100)
            make.height.equalTo(26)
        })
        last = reviewControl
        
        ///是否显示点评
        var isShowRemark : Bool = false
        if self.model?.isRemark == 0 {
            isShowRemark = false
        } else {
            reviewControl.isHidden = true
            if self.hmModel?.remarkVisible == 1 {
                isShowRemark = true
            } else {
                if self.hmModel?.isMyPublish ?? false {
                    isShowRemark = true
                } else {
                    isShowRemark = self.model?.isMySubmit ?? false
                }
            }
        }
        if isShowRemark {
            remarkView.isHidden = false
            remarkView.hmModel = self.hmModel
            remarkView.model = self.model
            remarkView.layoutIfNeeded()
//                let height = remarkView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            let height = self.model?.remarkHeight ?? 0
            remarkView.snp.remakeConstraints { (make) in
                make.top.equalTo(reviewControl.snp_bottom).offset(15)
                make.left.equalTo(imgAvatar)
                make.width.equalTo(SCREEN_WIDTH - 30)
                make.height.equalTo(height)
            }
            last = remarkView
        } else {
            remarkView.snp.removeConstraints()
            remarkView.isHidden = true
        }
        
        var favs = [String]()
        if let prises = model.praiseJsonList, prises.count > 0{
            for (_,prise) in prises.enumerated(){
                favs.append(prise.userName ?? "")
            }
            favView.isHidden = false
            UIUtil.yxs_setLabelParagraphText(favView.favLabel, text: favs.joined(separator: ","), font: UIFont.systemFont(ofSize: 14), lineSpacing: 6)
            let newText = favs.joined(separator: ",")
            let paragraphStye = NSMutableParagraphStyle()
            //调整行间距
            paragraphStye.lineSpacing = 6
            paragraphStye.lineBreakMode = NSLineBreakMode.byWordWrapping
            let dic = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.paragraphStyle:paragraphStye]
            let size = UIUtil.yxs_getTextSize(textStr: newText, attributes: dic, width: SCREEN_WIDTH - 30 - 46)

            favView.frame = CGRect.init(x: 15, y: last.tz_bottom + 12.5, width: SCREEN_WIDTH - 30, height: size.height + 8 + 7.5 + 8)
            if (model.commentJsonList?.count ?? 0) != 0{
                favView.favBgView.yxs_addRoundedCorners(corners: [.topLeft,.topRight], radii: CGSize.init(width: 2.5, height: 2.5), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 15 - 15, height: 800))
            }else{
                favView.favBgView.yxs_addRoundedCorners(corners: [.allCorners], radii: CGSize.init(width: 2.5, height: 2.5), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 15 - 15, height: 800))
            }
        }
    }
    var model: YXSHomeworkDetailModel?

    // MARK: -UIUpdate
    private func updateButtons(){
        var hasPraise = false
        if let praises = model?.praiseJsonList{
            for model in praises{
                if model.isMyOperation{
                    hasPraise = true
                    break
                }
            }
        }
        
        commentButton.isHidden = false
        praiseButton.isHidden = false
        praiseButton.isSelected = hasPraise
    }
    
    // MARK: - Action
    /// 点评作业
    @objc func reviewControlClick() {
        if self.hmModel?.isExpired ?? false {
            MBProgressHUD.yxs_showMessage(message: "当前作业已过期")
        } else {
            reviewControlBlock?(self.model!)
        }
        
    }
    
    /// 设置优秀作业
    @objc func goodControlClick() {
        if self.hmModel?.isExpired ?? false {
            MBProgressHUD.yxs_showMessage(message: "当前作业已过期")
        } else {
            if goodControl.isSelected {
                let alertVC = UIAlertController.init(title: "是否确定取消该作业的优秀", message: "", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: "取消", style: .default, handler: { (action) in
                    
                }))
                alertVC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                    /// 取消优秀
                    self.goodControl.isSelected = !self.goodControl.isSelected
                    self.goodClick?(self.model!)
                    self.finishView.isHidden = !self.goodControl.isSelected
                }))
                UIUtil.currentNav().present(alertVC, animated: true, completion: nil)
            } else {
                goodControl.isSelected = !goodControl.isSelected
                goodClick?(self.model!)
                finishView.isHidden = !goodControl.isSelected
            }
            
        }
        
    }

    /// 评论
    @objc func commentClick() {
        cellBlock?(.comment,self.model!)
    }

    /// 点赞
    @objc func praiseClick() {
        self.praiseButton.isSelected = !self.praiseButton.isSelected
        cellBlock?(.praise,self.model!)
    }
    
    /// 显示全部
    @objc func showAllClick(){
        model?.isShowContentAll = !(model?.isShowContentAll ?? false)
        showAllButton.isSelected = model?.isShowContentAll ?? false
        cellBlock?(.showAll,self.model!)
    }

    /// 作业提交家长点击撤回修改
    @objc func homeWorkChangeClick(sender: UIButton) {
        homeWorkChangeBlock?(sender,self.model!)
    }
    
    /// 查看历史优秀昼夜
    @objc func lookGoodHomeWorkDetial(){
        cellBlock?(.lookHomeWorkGood,self.model!)
    }
    
    /// 查看上周班级之星
    @objc func lookClassStartDetial(){
        cellBlock?(.lookLastWeakClassStart,self.model!)
    }
    
    /// 头像点击
    @objc func tapClick(){
        let vc = YXSFriendsCircleInfoController.init(userId: model?.custodianId ?? 0, childId: model?.childrenId ?? 0, type: PersonRole.PARENT.rawValue)
        UIUtil.currentNav().pushViewController(vc)
    }

    // MARK: - LazyLoad
    lazy var imgAvatar: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.lightGray
        img.cornerRadius = 21
        img.addTaget(target: self, selctor: #selector(tapClick))
        img.image = UIImage(named: "normal")
        img.contentMode = .scaleAspectFill
        return img
    }()

    lazy var lbName: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNight898F9A)
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        lb.setContentHuggingPriority(.required, for: .horizontal)
        return lb
    }()

    lazy var lbTime: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        lb.setContentHuggingPriority(.required, for: .horizontal)
        return lb
    }()

    lazy var goodControl: YXSCustomImageControl = {
        let goodControl = YXSCustomImageControl.init(imageSize: CGSize.init(width: 16, height: 19), position: YXSImagePositionType.left, padding: 5)
        goodControl.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#696C73"), for: .normal)
        goodControl.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#C92B1E"), for: .selected)
        goodControl.setTitle("设为优秀", for: .normal)
        goodControl.setTitle("取消优秀", for: .selected)
        goodControl.font = UIFont.systemFont(ofSize: 15)
        goodControl.setImage(UIImage.init(named: "yxs_punch_good_gray"), for: .normal)
        goodControl.setImage(UIImage.init(named: "yxs_punch_good_select"), for: .selected)
        goodControl.isHidden = true
        goodControl.isSelected = false
        goodControl.addTarget(self, action: #selector(goodControlClick), for: .touchUpInside)
        return goodControl
    }()

    
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
    
    lazy var classStartLabelBtn: YXSCustomImageControl = {
        let button = YXSCustomImageControl.init(imageSize: CGSize.init(width: 18, height: 20), position: .left, padding: 3.5, insets: UIEdgeInsets.init(top: 0, left: 6.5, bottom: 0, right: 7))
        button.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F7F8FB")
        button.cornerRadius = 13
        button.setTitle("上周班级之星", for: .normal)
        button.textColor = UIColor.yxs_hexToAdecimalColor(hex: "CB3226")
        button.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(lookClassStartDetial), for: .touchUpInside)
        return button
    }()
    
    lazy var goodHomeworkLabelBtn: YXSCustomImageControl = {
        let button = YXSCustomImageControl.init(imageSize: CGSize.init(width: 18, height: 20), position: .left, padding: 3.5, insets: UIEdgeInsets.init(top: 0, left: 6.5, bottom: 0, right: 7))
        button.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F7F8FB")
        button.cornerRadius = 13
        button.setTitle("优秀作业+8", for: .normal)
        button.textColor = UIColor.yxs_hexToAdecimalColor(hex: "CB3226")
        button.locailImage = "yxs_punch_good_select"
        button.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(lookGoodHomeWorkDetial), for: .touchUpInside)
        return button
    }()
    
    lazy var finishView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_homework_good"))
        return imageView
    }()

    lazy var reviewControl: YXSCustomImageControl = {
        let reviewControl = YXSCustomImageControl.init(imageSize: CGSize.init(width: 14, height: 14), position: YXSImagePositionType.left, padding: 4, insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        reviewControl.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), for: .normal)
        reviewControl.setTitle("点评作业", for: .normal)
        reviewControl.setTitle("点评作业", for: .selected)
        reviewControl.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), for: .normal)
        reviewControl.layer.masksToBounds = true
        reviewControl.layer.cornerRadius = 15
        reviewControl.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F7F8FB")
        reviewControl.font = UIFont.systemFont(ofSize: 14)
        reviewControl.setImage(UIImage.init(named: "yxs_howework_review"), for: .normal)
        reviewControl.setImage(UIImage.init(named: "yxs_howework_review"), for: .selected)
//        reviewControl.isHidden = true
        reviewControl.addTarget(self, action: #selector(reviewControlClick), for: .touchUpInside)
        reviewControl.isSelected = false
        return reviewControl
    }()

    lazy var commentButton: YXSButton = {
        let button = YXSButton.init()
        button.setImage(UIImage.init(named: "yxs_friend_circle_comment"), for: .normal)
        button.addTarget(self, action: #selector(commentClick), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        return button
    }()

    lazy var praiseButton: YXSButton = {
        let button = YXSButton.init()
        button.setImage(UIImage.init(named: "yxs_friend_circle_prise_select"), for: .selected)
        button.setImage(UIImage.init(named: "yxs_friend_circle_prise_nomal"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.addTarget(self, action: #selector(praiseClick), for: .touchUpInside)
        return button
    }()

    lazy var favView: FriendsCircleFavView = {
        let favView = FriendsCircleFavView()
        favView.isHidden = true
        favView.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), lineHeight: 0.5)
        return favView
    }()


    lazy var remarkView: SLHomeworkCommentDetailRemarkView = {
        let remarkView = SLHomeworkCommentDetailRemarkView()
        remarkView.isHidden = true
        remarkView.yxs_addLine(position: .top, color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), lineHeight: 0.5)
        return remarkView
    }()

    lazy var homeWorkChangeButton: YXSButton = {
        let button = YXSButton.init()
        button.setImage(UIImage.init(named: "yxs_howework_recall_up"), for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(homeWorkChangeClick(sender:)), for: .touchUpInside)
        return button
    }()

    lazy var showAllButton: UIButton = {
        let button = UIButton.init()
        button.setTitleColor(kBlueColor, for: .normal)
        button.setTitle("全文", for: .normal)
        button.setTitle("收起", for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(showAllClick), for: .touchUpInside)
        return button
    }()
}

extension YXSHomeworkDetailSectionHeaderView: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kHomeworkPictureGraffitiEvent:
            if info != nil {
                let model = info!["imgModel"]
                let index = info!["imgIndex"] as? Int
                if model is YXSFriendsMediaModel {
                    next?.yxs_routerEventWithName(eventName: kHomeworkPictureGraffitiNextEvent, info: ["imgModel":model!,"imgIndex":index ?? 0,"hmModel":self.model!,"currentSection":self.currentSection ?? 0])
                }
            }
        default:
            print("")
        }
    }
}

/// 点评视图
class SLHomeworkCommentDetailRemarkView: UIView {

    var hmModel : YXSHomeworkDetailModel?
    var remarkChangeBlock:((_ sender: UIButton,_ model:YXSHomeworkDetailModel)->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(remarkNameLbl)
        addSubview(remarkStatusLbl)
        addSubview(remarkTimeLbl)
        addSubview(remarkChangeButton)
        addSubview(remarkContentLabel)
        addSubview(remarkVoiceView)
        self.layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {
        remarkNameLbl.frame = CGRect.init(x: 0, y: 15, width: 100, height: 20)
        remarkStatusLbl.frame = CGRect.init(x: remarkNameLbl.tz_right + 5, y: 15, width: 65, height: 20)
        remarkTimeLbl.frame = CGRect.init(x: 0, y: 43, width: SCREEN_WIDTH - 30 - 30, height: 15)
        remarkChangeButton.frame = CGRect.init(x: SCREEN_WIDTH - 30 - 30, y: 15, width: 30, height: 16)
        remarkContentLabel.frame = CGRect.init(x: 0, y: remarkTimeLbl.tz_bottom + 10, width: SCREEN_WIDTH - 30, height: 20)
        remarkVoiceView.frame = CGRect.init(x: 0, y: remarkContentLabel.tz_bottom + 10, width: SCREEN_WIDTH - 30, height: 36)
    }

    func updateUI() {
        remarkNameLbl.sizeToFit()
        remarkStatusLbl.x = remarkNameLbl.tz_right + 5
        if self.model?.remark?.count ?? 0 > 0 {
            let paragraphStye = NSMutableParagraphStyle()
            paragraphStye.lineSpacing = kMainContentLineHeight
            paragraphStye.lineBreakMode = NSLineBreakMode.byWordWrapping
            let dic = [NSAttributedString.Key.font: kTextMainBodyFont, NSAttributedString.Key.paragraphStyle:paragraphStye]
            let size = UIUtil.yxs_getTextSize(textStr: self.model?.remark, attributes: dic, width: SCREEN_WIDTH - 30)
            if size.height < 20 {
                remarkContentLabel.frame = CGRect.init(x: 0, y: remarkTimeLbl.tz_bottom + 10, width: size.width, height: size.height)
            }
            else {
                remarkContentLabel.frame = CGRect.init(x: 0, y: remarkTimeLbl.tz_bottom + 10, width: SCREEN_WIDTH - 30, height: size.height)
            }
        } else {
            remarkContentLabel.frame = CGRect.init(x: 0, y: remarkTimeLbl.tz_bottom, width: SCREEN_WIDTH - 30, height: 0)
        }
        
        if remarkVoiceView.isHidden {
            remarkVoiceView.frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
        } else {
            remarkVoiceView.frame = CGRect.init(x: 0, y: remarkContentLabel.tz_bottom + 10, width: SCREEN_WIDTH - 30, height: 36)
        }
        
    }
    
    var model: YXSHomeworkDetailModel? {
        didSet {
            remarkVoiceView.isHidden = true
            remarkContentLabel.isHidden = true
            remarkNameLbl.text = self.hmModel?.teacherName
            remarkTimeLbl.text = self.model?.remarkTime?.yxs_Time()
            if (self.model?.remark ?? "").count > 0 {
                remarkContentLabel.isHidden = false
                UIUtil.yxs_setLabelParagraphText(remarkContentLabel, text: self.model?.remark)
            }
            remarkChangeButton.isHidden = !(self.hmModel?.isMyPublish ?? false)
            
            if (self.model?.remarkAudioUrl ?? "").count > 0 {
                remarkVoiceView.id = "remark\(self.model?.id ?? 0)"
                remarkVoiceView.isHidden = false
                let voiceModel = YXSVoiceViewModel()
                remarkVoiceView.width = SCREEN_WIDTH - 30 - 41
                voiceModel.voiceDuration = self.model?.remarkAudioDuration
                voiceModel.voiceUlr = self.model?.remarkAudioUrl
                remarkVoiceView.model = voiceModel
            }
            self.updateUI()
        }
    }

    @objc func remarkChangeClick(sender:YXSButton) {
        remarkChangeBlock?(sender,self.model!)
    }

    lazy var remarkNameLbl: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNight898F9A)
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()

    lazy var remarkStatusLbl: YXSLabel = {
        let lb = YXSLabel()
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.text = "已点评"
        lb.layer.cornerRadius = 10
        lb.layer.masksToBounds = true
        lb.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F38781")
        return lb
    }()

    lazy var remarkTimeLbl: YXSLabel = {
        let lb = YXSLabel()
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        lb.setContentHuggingPriority(.required, for: .horizontal)
        return lb
    }()

    lazy var remarkChangeButton: YXSButton = {
        let button = YXSButton.init()
        button.setImage(UIImage.init(named: "yxs_howework_recall_up"), for: .normal)
        button.addTarget(self, action: #selector(remarkChangeClick(sender:)), for: .touchUpInside)
        return button
    }()

    lazy var remarkContentLabel: YXSEventCopyLabel = {
        let label = YXSEventCopyLabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.numberOfLines = 0
        return label
    }()
    
    
    lazy var remarkVoiceView: YXSListVoiceView = {
        let voiceView = YXSListVoiceView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 30 - 41, height: 36), complete: {
            [weak self] (url, duration)in
            guard let strongSelf = self else { return }
        })
        return voiceView
    }()

}
