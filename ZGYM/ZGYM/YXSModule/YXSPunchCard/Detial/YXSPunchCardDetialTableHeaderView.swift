//
//  SLPunchCardDetialTableHeaderView.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/26.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

enum YXSPunchCardHeaderBlockType: Int {
    ///评论
    case comment
    ///点赞
    case praise
    ///展开全文
    case showAll
    ///设置打卡优秀
    case setPunchCardGood
    ///取消设置打卡优秀
    case setUnPunchCardGood
    ///处理打卡
    case dealPunCard
    ///查看全部打卡
    case lookAllPunchCardCommint
}

class YXSPunchCardDetialTableHeaderView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier:reuseIdentifier)
        self.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -UI
    func initUI(){
        contentView.addSubview(headerImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(showAllButton)
        contentView.addSubview(nineMediaView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(commentButton)
        contentView.addSubview(praiseButton)
        
        contentView.addSubview(favView)
        contentView.addSubview(lookAllButton)
        contentView.addSubview(finishView)
        contentView.addSubview(goodControl)
        contentView.addSubview(lineView)
        contentView.addSubview(voiceView)
        contentView.addSubview(dealPunchCardBtn)
        contentView.addSubview(symbolView)
        layout()
    }
    
    
    func layout(){
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(69)
            make.top.equalTo(headerImageView).offset(2.5)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(69)
            make.top.equalTo(nameLabel.snp_bottom).offset(9)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(SCREEN_WIDTH - 30)
            make.top.equalTo(headerImageView.snp_bottom).offset(14)
        }
        
        finishView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 50.5, height: 45))
            make.right.equalTo(-111.5)
            make.top.equalTo(headerImageView)
        }
        
        goodControl.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.right.equalTo(-15)
            make.top.equalTo(headerImageView)
        }
        
        praiseButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(lookAllButton)
            make.size.equalTo(CGSize.init(width: 40, height: 25))
            make.right.equalTo(-15)
        }
        
        commentButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(lookAllButton)
            make.size.equalTo(CGSize.init(width: 36, height: 36))
            make.right.equalTo(praiseButton.snp_left).offset(-12)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }

        dealPunchCardBtn.snp.makeConstraints { (make) in
            make.top.equalTo(headerImageView).offset(-7.5)
            make.right.equalTo(-14.5)
            make.size.equalTo(CGSize.init(width: 30, height: 36.5))
        }
    }
    
    // MARK: -UIUpdate
    private func updateButtons(){
        var hasPraise = false
        if let praises = model.praises{
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
    
    private var model: YXSPunchCardCommintListModel!
    
    // MARK: - public
    ///最后一行展示线

    
    public var headerBlock: ((YXSPunchCardHeaderBlockType) -> ())?
    func setModel(_ model: YXSPunchCardCommintListModel){
        self.model = model
        
        showAllButton.isHidden = true
        favView.isHidden = true
        
        goodControl.isHidden = true
        finishView.isHidden = true
        lineView.isHidden = true
        symbolView.isHidden = true
        voiceView.isHidden = true
        
        lookAllButton.isHidden = !model.isShowLookStudentAllButton
        
        ///是否展示修改按钮
        dealPunchCardBtn.isHidden = !(YXSPersonDataModel.sharePerson.personRole == .PARENT && self.yxs_user.id == model.custodianId)
        
        updateButtons()
        voiceView.snp_removeConstraints()
        favView.snp_removeConstraints()
        
        model.isMyPublish = YXSPersonDataModel.sharePerson.personRole == .TEACHER && model.teacherId == self.yxs_user.id
        
        //其他老师&家长展示盖章
        if !model.isMyPublish && (model.excellent ?? false){
            finishView.isHidden = false
        }
        
        goodControl.isHidden = !model.isMyPublish
        goodControl.isSelected = model.excellent ?? false
        
        if model.isShowTime{
            symbolView.isHidden = false
            symbolView.snp_remakeConstraints { (make) in
                make.height.equalTo(40)
                make.left.top.right.equalTo(0)
            }
            headerImageView.snp_remakeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(symbolView.snp_bottom).offset(14.5)
                make.size.equalTo(CGSize.init(width: 41, height: 41))
            }
            symbolView.timeLabel.text = model.createTime?.date(withFormat: kCommonDateFormatString)?.toString(format: DateFormatType.custom("M.dd"))
        }else{
            lineView.isHidden = false
            headerImageView.snp_remakeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(21)
                make.size.equalTo(CGSize.init(width: 41, height: 41))
            }
        }
        headerImageView.sd_setImage(with: URL.init(string: model.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
        nameLabel.text = "\(model.realName ?? "")\((model.relationship ?? "").yxs_RelationshipValue())"
        let timeText: String? = model.patchCardTime == nil ? model.createTime : model.patchCardTime
        UIUtil.yxs_setLabelAttributed(timeLabel, text: [timeText?.yxs_Time() ?? "","  已坚持\(1)天"])
        
        UIUtil.yxs_setLabelParagraphText(contentLabel, text: model.content,removeSpace:  !model.isShowContentAll &&  model.needShowAllButton)
        contentLabel.numberOfLines = model.isShowContentAll ? 0 : 3
        
        var last: UIView = contentLabel
        var lastBottom = 10
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

        if model.hasVoice{
            voiceView.isHidden = false
            if model.hasVoice{
                voiceView.isHidden = false
                let voiceModel = YXSVoiceViewModel()
                voiceView.width = SCREEN_WIDTH - 30 - 41
                voiceModel.voiceDuration = model.audioDuration
                voiceModel.voiceUlr = model.audioUrl
                voiceView.model = voiceModel
                voiceView.snp.remakeConstraints { (make) in
                    make.top.equalTo(last.snp_bottom).offset(10)
                    make.left.equalTo(contentLabel)
                    make.right.equalTo(-15.5)
                    make.height.equalTo(36)
                }
                last = voiceView
                lastBottom = 14
            }else{
                voiceView.isHidden = true
            }
            last = voiceView
            lastBottom = 14
        }else{
            voiceView.isHidden = true
        }
        
        if model.imgs.count > 0{
            nineMediaView.isHidden = false
            nineMediaView.medias = model.imgs
            nineMediaView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(last.snp_bottom).offset(lastBottom)
            }
            last = nineMediaView
        }else{
            nineMediaView.isHidden = true
        }
        
        
        lookAllButton.snp.remakeConstraints { (make) in
            make.top.equalTo(last.snp_bottom).offset(10)
            make.left.equalTo(contentLabel)
            make.size.equalTo(CGSize.init(width: 100.5, height: 26))
            
        }
        
        var favs = [String]()
        if let prises = model.praises, prises.count > 0{
            for (_,prise) in prises.enumerated(){
                favs.append(prise.userName ?? "")
            }
            favView.snp.remakeConstraints { (make) in
                make.top.equalTo(lookAllButton.snp_bottom).offset(2.5)
                make.left.equalTo(contentLabel)
                make.width.equalTo(SCREEN_WIDTH - 30)
            }
            favView.isHidden = false
            UIUtil.yxs_setLabelParagraphText(favView.favLabel, text: favs.joined(separator: ","), font: UIFont.systemFont(ofSize: 14), lineSpacing: 6)
            
            if (model.comments?.count ?? 0) != 0{
                favView.favBgView.yxs_addRoundedCorners(corners: [.topLeft,.topRight], radii: CGSize.init(width: 2.5, height: 2.5), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 15 - 15, height: 800))
            }else{
                favView.favBgView.yxs_addRoundedCorners(corners: [.allCorners], radii: CGSize.init(width: 2.5, height: 2.5), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 15 - 15, height: 800))
            }
        }
    }
    
    // MARK: -Action
    @objc func commentClick(){
        headerBlock?(.comment)
    }
    
    @objc func praiseClick(){
        headerBlock?(.praise)
        
    }
    @objc func lookAllClick(){
        headerBlock?(.lookAllPunchCardCommint)
    }
    @objc func setGoodClick(){
        if model.excellent ?? false{
            headerBlock?(.setUnPunchCardGood)
        }else{
            headerBlock?(.setPunchCardGood)
        }
        
    }
    
    /// 头像点击
    @objc func tapClick(){
        let vc = SLFriendsCircleInfoController.init(userId:   model.custodianId ?? 0, childId: model.childrenId ?? 0, type: PersonRole.PARENT.rawValue)
        UIUtil.curruntNav().pushViewController(vc)
    }
    
    @objc func dealPunchCardBtnClick(){
        headerBlock?(.dealPunCard)
    }
    
    @objc func showAllClick(){
        model.isShowContentAll = !model.isShowContentAll
        showAllButton.isSelected = model.isShowContentAll
        headerBlock?(.showAll)
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
    lazy var lookAllButton: YXSButton = {
        let button = YXSButton()
        button.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F7F8FB")
        button.cornerRadius = 13
        button.setTitle("查看全部打卡 ", for: .normal)
        button.setTitleColor(kBlueColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(lookAllClick), for: .touchUpInside)
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
    
    lazy var dealPunchCardBtn: YXSButton = {
        let dealPunchCardBtn = YXSButton.init()
        dealPunchCardBtn.setImage(UIImage.init(named: "yxs_punchCard_list_down"), for: .normal)
        dealPunchCardBtn.addTarget(self, action: #selector(dealPunchCardBtnClick), for: .touchUpInside)
        return dealPunchCardBtn
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
    
    lazy var nineMediaView: SLNineMediaView = {
        let nineMediaView = SLNineMediaView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        nineMediaView.edges = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        return nineMediaView
    }()
    
    lazy var symbolView: SLSymbolView = {
        let symbolView = SLSymbolView()
        return symbolView
    }()
    
    lazy var finishView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_punch_good_finish"))
        return imageView
    }()
    
    lazy var goodControl: YXSCustomImageControl = {
        let goodControl = YXSCustomImageControl.init(imageSize: CGSize.init(width: 16.5, height: 19.5), position: YXSImagePositionType.left, padding: 5.5)
        goodControl.setTitle("优秀打卡", for: .normal)
        goodControl.setTitle("优秀打卡", for: .selected)
        goodControl.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#696C73"), for: .normal)
        goodControl.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#C92B1E"), for: .selected)
        goodControl.font = UIFont.boldSystemFont(ofSize: 15)
        goodControl.setImage(UIImage.init(named: "yxs_punch_good_gray"), for: .normal)
        goodControl.setImage(UIImage.init(named: "yxs_punch_good_select"), for: .selected)
        goodControl.addTarget(self, action: #selector(setGoodClick), for: .touchUpInside)
        goodControl.isSelected = false
        return goodControl
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3")
        return lineView
    }()
    

    
    lazy var voiceView: YXSVoiceView = {
        let voiceView = YXSVoiceView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 30 - 41, height: 36), complete: {
            [weak self] (url, duration)in
            guard let strongSelf = self else { return }
        })
        voiceView.minWidth = 120
        return voiceView
    }()
}


class SLSymbolView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(timeLabel)
        self.addSubview(leftView)
        self.addSubview(rightView)
        timeLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        leftView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(0).priorityHigh()
            make.right.equalTo(timeLabel.snp_left).offset(-5).priorityHigh()
            make.height.equalTo(0.5)
        }
        rightView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(0).priorityHigh()
            make.left.equalTo(timeLabel.snp_right).offset(5).priorityHigh()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var leftView: UIView = {
        let leftView = UIView()
        leftView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3")
        return leftView
    }()
    
    lazy var rightView: UIView = {
        let rightView = UIView()
        rightView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3")
        return rightView
    }()
}
