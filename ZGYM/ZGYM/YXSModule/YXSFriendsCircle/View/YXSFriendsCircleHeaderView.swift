//
//  CircleHeaderView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/13.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import SDWebImage
import YBImageBrowser
import NightNight

// MARK: - public   0 分享 1评论 2 点赞 3刷新 4撤回
enum FriendsCircleHeaderBlockType: Int {
    case share
    case comment
    case praise
    case showAll
    case recall
    case goToUserInfo
}

class YXSFriendsCircleHeaderView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    func initUI(){
        addSubview(friendCircleContentView)
        friendCircleContentView.snp.makeConstraints { (make) in
            make.edges.equalTo(0).priorityHigh()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var headerBlock: ((FriendsCircleHeaderBlockType) -> ())?
    private var model:YXSFriendCircleModel!
    func setModel(_ model: YXSFriendCircleModel){
        friendCircleContentView.setModel(model)
    }
    
    lazy var friendCircleContentView: YXSFriendsCircleContentView = {
        let friendCircleContentView = YXSFriendsCircleContentView()
        friendCircleContentView.isAutoCalculateHeight = false
        friendCircleContentView.headerBlock = {
            [weak self] (type)in
            guard let strongSelf = self else { return }
            strongSelf.headerBlock?(type)
        }
        return friendCircleContentView
    }()
}


class FriendsCircleFavView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(favBgView)
        addSubview(favUpImageView)
        favBgView.addSubview(favImageView)
        
        favBgView.addSubview(favLabel)
        favBgView.snp.makeConstraints { (make) in
            make.top.equalTo(7.5)
            make.right.left.equalTo(0).priorityHigh()
            make.bottom.equalTo(0).priorityHigh()
        }
        favUpImageView.snp.makeConstraints { (make) in
            make.left.equalTo(19)
            make.top.equalTo(0)
            make.size.equalTo(CGSize.init(width: 12, height: 7.5))
        }
        
        favImageView.snp.makeConstraints { (make) in
            make.left.equalTo(11.5)
            make.top.equalTo(9.5)
            make.size.equalTo(CGSize.init(width: 14, height: 13))
        }
        favLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(31)
            make.right.equalTo(-15)
            make.bottom.equalTo(-8).priorityHigh()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var favBgView: UIView = {
        let favBgView = UIView()
        favBgView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: UIColor.yxs_hexToAdecimalColor(hex: "#292B3A"))
        return favBgView
    }()
    
    lazy var favImageView: UIImageView = {
        let button = UIImageView.init(image: UIImage.init(named: "yxs_friend_circle_fav_prise"))
        return button
    }()
    lazy var favUpImageView: UIImageView = {
        let button = UIImageView()
        button.mixedImage = MixedImage(normal: "yxs_friend_circle_up", night: "yxs_friend_circle_up_night")
        return button
    }()
    
    lazy var favLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#696C73"), night: UIColor.white)
        label.numberOfLines = 0
        return label
    }()
}


class YXSFriendsCircleContentView: UIView{
    
    /// 内容填充计算高度
    var isAutoCalculateHeight = true
    
    /// 整体容器宽度
    var contentWidth: CGFloat
    override init(frame: CGRect) {
        var contentFrame = frame
        if frame.width == 0{
            contentFrame = CGRect.init(x: frame.minX, y: frame.minY, width: SCREEN_WIDTH, height: frame.height)
        }
        contentWidth = contentFrame.width
        super.init(frame: contentFrame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -UI
    func initUI(){
        addSubview(headerImageView)
        addSubview(nameLabel)
        addSubview(contentLabel)
        addSubview(showAllButton)
        addSubview(nineMediaView)
        addSubview(timeLabel)
        addSubview(shareButton)
        addSubview(commentButton)
        addSubview(praiseButton)
        addSubview(recallView)
        
        addSubview(favView)
        addSubview(dayLabel)
        addSubview(tagLabel)
        addSubview(teacherClassLabel)
        layout()
    }
    
    
    func layout(){
        headerImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15).priorityHigh()
            make.top.equalTo(14)
            make.size.equalTo(CGSize.init(width: 41, height: 41))
        }
        
        praiseButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeLabel)
            make.size.equalTo(CGSize.init(width: 40, height: 25))
            make.right.equalTo(-15)
        }
        
        commentButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeLabel)
            make.size.equalTo(CGSize.init(width: 36, height: 36))
            make.right.equalTo(praiseButton.snp_left).offset(-12)
        }
        
        shareButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeLabel)
            make.size.equalTo(CGSize.init(width: 36, height: 36))
            make.right.equalTo(commentButton.snp_left).offset(-12)
        }
        recallView.snp.makeConstraints { (make) in
            make.right.equalTo(-8.5)
            make.top.equalTo(nameLabel).offset(-8.5)
            make.size.equalTo(CGSize.init(width: 38, height: 38))
        }
        dayLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(headerImageView)
            make.top.equalTo(nameLabel)
        }
//        teacherClassLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    // MARK: -UIUpdate
    func updateButtons(){
        var hasPraise = false
        if let praises = model.praises{
            for model in praises{
                if model.isMyOperation{
                    hasPraise = true
                    break
                }
            }
        }
        
        shareButton.isHidden = false
        commentButton.isHidden = false
        praiseButton.isHidden = false
        
        praiseButton.isSelected = hasPraise
        
        if (NoComment.init(rawValue: model.noComment ?? "") ?? NoComment.YES) == .YES{
            commentButton.isHidden = true
            shareButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(timeLabel)
                make.size.equalTo(CGSize.init(width: 36, height: 36))
                make.right.equalTo(praiseButton.snp_left).offset(-12).priorityHigh()
            }
        }else{
            commentButton.isHidden = false
            commentButton.snp.remakeConstraints { (make) in
                make.centerY.equalTo(timeLabel)
                make.size.equalTo(CGSize.init(width: 36, height: 36))
                make.right.equalTo(praiseButton.snp_left).offset(-12).priorityHigh()
            }
            
            shareButton.snp.remakeConstraints { (make) in
                make.centerY.equalTo(timeLabel)
                make.size.equalTo(CGSize.init(width: 36, height: 36))
                make.right.equalTo(commentButton.snp_left).offset(-12).priorityHigh()
            }
        }
        
        if model.circleType == .HELPER{
            shareButton.isHidden = true
            commentButton.isHidden = true
            praiseButton.isHidden = true
        }
    }
    
    public var headerBlock: ((FriendsCircleHeaderBlockType) -> ())?
    var model:YXSFriendCircleModel!
    
    func setModel(_ model: YXSFriendCircleModel){
        self.model = model
        
        showAllButton.isHidden = true
        favView.isHidden = true
        
        teacherClassLabel.isHidden = true
        tagLabel.isHidden = true
        teacherClassLabel.snp_removeConstraints()
        updateButtons()
        
        favView.snp_removeConstraints()
        if model.circleType == .CIRCLE{
            if (PersonRole.init(rawValue:model.typePublisher ?? "") ?? PersonRole.TEACHER) == .TEACHER{
                nameLabel.text = model.namePublisher
                headerImageView.yxs_setImageWithURL(url: URL.init(string: model.avatarPublisher ?? ""), placeholder: kImageUserIconTeacherDefualtMixedImage)
                teacherClassLabel.isHidden = false
                tagLabel.isHidden = false
                teacherClassLabel.text = model.gradeName ?? ""
                
                tagLabel.snp_remakeConstraints { (make) in
                    make.height.equalTo(16)
                    make.left.equalTo(nameLabel.snp_right).offset(4.5)
                    make.centerY.equalTo(nameLabel)
                    make.width.equalTo(36.5)
                }

                nameLabel.sizeToFit()
                nameLabel.snp_remakeConstraints { (make) in
                    make.left.equalTo(YXSFriendsConfigHelper.helper.contentLeftMargin).priorityHigh()
                    make.top.equalTo(YXSFriendsConfigHelper.helper.nameLabelTopPadding)
                    make.width.equalTo(nameLabel.width)
                }
                
                teacherClassLabel.snp_remakeConstraints { (make) in
                    make.centerY.equalTo(tagLabel)
                    make.left.equalTo(tagLabel.snp_right).offset(13)
                    make.width.equalTo(contentWidth - YXSFriendsConfigHelper.helper.contentLeftMargin - nameLabel.width - 4.5 - 36.5 - 13 - (model.isMyPublish ? 30 : 15))
                }
            }else{
                headerImageView.yxs_setImageWithURL(url: URL.init(string: model.childrenAvatar ?? ""), placeholder: kImageUserIconStudentDefualtMixedImage)
                UIUtil.yxs_setLabelAttributed(nameLabel, text: ["\(model.childrenRealName ?? "")\((model.relationship ?? "").yxs_RelationshipValue())","   \(model.gradeName ?? "")"], colors: [ MixedColor(normal: kTextMainBodyColor, night: UIColor.white),  MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#4B4E54"), night: kNightBCC6D4)], fonts: [UIFont.boldSystemFont(ofSize: 16),UIFont.systemFont(ofSize: 14)])
                
                nameLabel.snp_remakeConstraints { (make) in
                    make.left.equalTo(YXSFriendsConfigHelper.helper.contentLeftMargin).priorityHigh()
                    make.top.equalTo(YXSFriendsConfigHelper.helper.nameLabelTopPadding)
                    make.width.equalTo(contentWidth - YXSFriendsConfigHelper.helper.contentLeftMargin - (model.isMyPublish ? 30 : 15))
                }
                
            }
            
            
        }else{
            nameLabel.text = "优学业官方助手"
            headerImageView.sd_setImage(with: URL.init(string:  "https://zx-ustudent.oss-cn-hangzhou.aliyuncs.com/ustudent-helper/class-circle/20200103/icon/icon-216.png"), placeholderImage: UIImage.init(named: "yxs_logo"), completed: nil)
            
            nameLabel.snp_remakeConstraints { (make) in
                make.left.equalTo(YXSFriendsConfigHelper.helper.contentLeftMargin)
                make.top.equalTo(YXSFriendsConfigHelper.helper.nameLabelTopPadding)
            }
        }
        
        
        if model.isShowDay{
            headerImageView.isHidden = true
            dayLabel.isHidden = false
            let formatter = DateFormatter()
            formatter.locale = Locale.init(identifier: "zh_CN")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatter.date(from: model.createTime ?? "") ?? Date()
            let yearTmp: Int = Calendar.current.component(Calendar.Component.year, from: date)
            let yearNow: Int = Calendar.current.component(Calendar.Component.year, from: Date())
            let mounthTmp: Int = Calendar.current.component(Calendar.Component.month, from: date)
            let mounthNow: Int = Calendar.current.component(Calendar.Component.month, from: Date())
            
            let dayTmp: Int = Calendar.current.component(Calendar.Component.day, from: date)
            let dayNow: Int = Calendar.current.component(Calendar.Component.day, from: Date())
            
            let textColor = NightNight.theme == .night ? kNightBCC6D4 : UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
            if yearTmp == yearNow && mounthTmp == mounthNow && dayNow == dayTmp{
                UIUtil.yxs_setLabelAttributed(dayLabel, text: ["今天"], colors: [textColor], fonts: [UIFont.boldSystemFont(ofSize: 18)])
                
            }else if  yearTmp == yearNow && mounthTmp == mounthNow && dayNow - dayTmp == 1{
                UIUtil.yxs_setLabelAttributed(dayLabel, text: ["昨天"], colors: [textColor], fonts: [UIFont.boldSystemFont(ofSize: 18)])
            }else if  yearTmp == yearNow {
                UIUtil.yxs_setLabelAttributed(dayLabel, text: ["\(dayTmp)","\(mounthTmp)月"], colors: [textColor,textColor], fonts: [UIFont.systemFont(ofSize: 18),UIFont.systemFont(ofSize: 12)])
            }else{
                UIUtil.yxs_setLabelAttributed(dayLabel, text: ["\(dayTmp)","\n\(mounthTmp)月", "\n\(yearTmp)年"], colors: [textColor,textColor,textColor], fonts: [UIFont.systemFont(ofSize: 18),UIFont.systemFont(ofSize: 12),UIFont.systemFont(ofSize: 12)])
            }
        }else{
            headerImageView.isHidden = false
            dayLabel.isHidden = true
        }
        
        recallView.isHidden = !(model.userIdPublisher == yxs_user.id && model.typePublisher == yxs_user.type)
        
        var needShowAllButton = false
        if model.frameModel != nil{
            
            needShowAllButton = model.needShowAllButton
        }else{
            let paragraphStye = NSMutableParagraphStyle()
            //调整行间距
            paragraphStye.lineSpacing = kMainContentLineHeight
            paragraphStye.lineBreakMode = .byWordWrapping
            let attributes = [NSAttributedString.Key.paragraphStyle:paragraphStye, NSAttributedString.Key.font: kTextMainBodyFont]
            let height = UIUtil.yxs_getTextHeigh(textStr: model.content ?? "", attributes: attributes, width: self.width - YXSFriendsConfigHelper.helper.contentLeftMargin - 28) + 1
            needShowAllButton = height > (kTextMainBodyFont.pointSize * 3 + kMainContentLineHeight * 4)  ? true : false
        }
        
        UIUtil.yxs_setLabelParagraphText(contentLabel, text: model.content,removeSpace:  !model.isShowAll && needShowAllButton)
        contentLabel.preferredMaxLayoutWidth = self.width - YXSFriendsConfigHelper.helper.contentLeftMargin - 28

        if needShowAllButton{
            showAllButton.isSelected = model.isShowAll
            showAllButton.isHidden = false
            showAllButton.snp.remakeConstraints { (make) in
                make.top.equalTo(contentLabel.snp_bottom).offset(9)
                make.left.equalTo(nameLabel)
                make.height.equalTo(25)
            }
        }
        
        contentLabel.numberOfLines = model.isShowAll ? 0 : 3
        if isAutoCalculateHeight{
            contentLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(nameLabel)
                make.top.equalTo(nameLabel.snp_bottom).offset(YXSFriendsConfigHelper.helper.contentTopToNameLPadding)
                make.right.equalTo(-28)
            }
        }else{
//            if model.frameModel != nil{
//                let helper = YXSFriendsConfigHelper.helper
//                contentLabel.frame = CGRect.init(x: helper.contentLeftMargin, y: helper.nameLabelTopPadding + 16 + helper.contentTopToNameLPadding, width: helper.contentWidth, height:model.isShowAll ? model.frameModel.contentIsShowAllHeight : model.frameModel.contentHeight)
//            }
            contentLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(nameLabel)
                make.top.equalTo(nameLabel.snp_bottom).offset(YXSFriendsConfigHelper.helper.contentTopToNameLPadding)
                make.right.equalTo(-28)
            }
        }
        
        
        timeLabel.text = Date.yxs_Time(dateStr: model.createTime ?? "")
        
        var hasPrises: Bool = false
        var favs = [String]()
        if let prises = model.praises, prises.count > 0{
            hasPrises = true
            for (_,prise) in prises.enumerated(){
                favs.append(prise.userName ?? "")
            }
            favView.snp.remakeConstraints { (make) in
                make.top.equalTo(timeLabel.snp_bottom).offset(12.5)
                make.left.equalTo(nameLabel)
                make.right.equalTo(-15)
                if isAutoCalculateHeight{
                    make.bottom.equalTo(0).priorityHigh()
                }
            }
            favView.isHidden = false
            UIUtil.yxs_setLabelParagraphText(favView.favLabel, text: favs.joined(separator: ","), font: UIFont.systemFont(ofSize: 14), lineSpacing: 6)
            
            if (model.comments?.count ?? 0) != 0{
                favView.favBgView.yxs_addRoundedCorners(corners: [.topLeft,.topRight], radii: CGSize.init(width: 2.5, height: 2.5), rect: CGRect.init(x: 0, y: 0, width: self.width - YXSFriendsConfigHelper.helper.contentLeftMargin - 15, height: 800))
            }else{
                favView.favBgView.yxs_addRoundedCorners(corners: [.allCorners], radii: CGSize.init(width: 2.5, height: 2.5), rect: CGRect.init(x: 0, y: 0, width: self.width - YXSFriendsConfigHelper.helper.contentLeftMargin - 15, height: 800))
            }
        }
        
        nineMediaView.medias = model.imgs
        nineMediaView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(needShowAllButton ? showAllButton.snp_bottom : contentLabel.snp_bottom).offset(10)
        }
        
        timeLabel.snp.remakeConstraints { (make) in
            if  model.imgs?.count ?? 0 > 0 {
                make.top.equalTo(nineMediaView.snp_bottom).offset(15)
            }else{
                make.top.equalTo(needShowAllButton ? showAllButton.snp_bottom : contentLabel.snp_bottom).offset(15)
            }
            make.left.equalTo(nameLabel)
            if !hasPrises && isAutoCalculateHeight{
                make.bottom.equalTo(-12.5).priorityHigh()
            }
            
        }
    }
    
    // MARK: -Action
    @objc func shareClick(){
        headerBlock?(.share)
    }
    
    @objc func commentClick(){
        headerBlock?(.comment)
    }
    
    @objc func praiseClick(){
        headerBlock?(.praise)
        
    }
    @objc func recallClick(){
        headerBlock?(.recall)
    }
    @objc func tapClick(){
        if model.circleType == .CIRCLE{
            headerBlock?(.goToUserInfo)
        }
    }
    
    @objc func showAllClick(){
        model.isShowAll = !model.isShowAll
        showAllButton.isSelected = model.isShowAll
        headerBlock?(.showAll)
        //        setModel(model)
    }
    
    // MARK: -getter&setter
    lazy var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.cornerRadius = 20.5
        imageView.addTaget(target: self, selctor: #selector(tapClick))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return label
    }()
    
    lazy var contentLabel: YXSEventCopyLabel = {
        let label = YXSEventCopyLabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.numberOfLines = 3
        return label
    }()
    
    lazy var timeLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return label
    }()
    
    lazy var recallView: YXSButton = {
        let button = YXSButton()
        button.setImage(UIImage.init(named: "recall"), for: .normal)
        button.addTarget(self, action: #selector(recallClick), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton: YXSButton = {
        let button = YXSButton.init()
        button.setImage(UIImage.init(named: "yxs_friend_circle_share"), for: .normal)
        button.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
        return button
    }()
    
    lazy var commentButton: YXSButton = {
        let button = YXSButton.init()
        button.setImage(UIImage.init(named: "yxs_friend_circle_comment"), for: .normal)
        button.addTarget(self, action: #selector(commentClick), for: .touchUpInside)
        return button
    }()
    
    lazy var praiseButton: YXSButton = {
        let button = YXSButton.init()
        button.setImage(UIImage.init(named: "yxs_friend_circle_prise_select"), for: .selected)
        button.setImage(UIImage.init(named: "yxs_friend_circle_prise_nomal"), for: .normal)
        button.addTarget(self, action: #selector(praiseClick), for: .touchUpInside)
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
    
    lazy var favView: FriendsCircleFavView = {
        let favView = FriendsCircleFavView()
        favView.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), lineHeight: 0.5)
        return favView
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return label
    }()
    
    lazy var nineMediaView: YXSNineMediaView = {
        let nineMediaView = YXSNineMediaView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 0))
        nineMediaView.edges = UIEdgeInsets.init(top: 0, left: YXSFriendsConfigHelper.helper.contentLeftMargin, bottom: 0, right: 15)
        return nineMediaView
    }()
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.cornerRadius = 8
        label.text = "老师"
        label.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F38781")
        label.textColor = UIColor.white
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var teacherClassLabel: UILabel = {
        let label = UILabel()
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#4B4E54"), night: kNightBCC6D4)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
}
