//
//  YXSHomeBaseCell.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/19.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

//通知、作业、打卡、接龙、成绩  班级之星的评价
enum YXSHomeType: Int{
    ///通知
    case notice = 0
    ///作业
    case homework
    ///打卡
    case punchCard
    ///接龙
    case solitaire
    ///班级之星
    case classstart
    ///朋友圈
    case friendCicle
    ///成绩
    case score
    ///优期刊
    case periodical
    
    ///相册
    case photo
}

public enum YXSHomeCellEvent: Int{
    ///展开收起
    case showAll
    ///已读
    case read
    ///打卡提醒
    case punchRemind
    ///去打卡
    case goPunch
    ///接龙
    case solitaire
    ///成绩
    case score
    ///班级之星
    case classstart
    ///撤销
    case recall
    ///去接龙
    case goSolitaire
    ///通知回执
    case noticeReceipt
    ///取消置顶
    case cancelStick
    ///push相册资源列表
    case goPhotoLists
}


class YXSHomeBaseCell: UITableViewCell {
    // MARK: - public
    /// 是否是单个班级首页
    public var isSingleHome: Bool?{
        didSet{
            contentView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        }
    }
    
    /// 是否首页瀑布流  展示标签  可以操作置顶
    public var isWaterfallCell: Bool = false
    
    /// 是否置顶
    public var isTop: Bool = false{
        didSet{
            stickView.isHidden = isTop ? false : true
            if isWaterfallCell{
                topTimeLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(69)
                    make.centerY.equalTo(tagLabel)
                }
            }else{
                topTimeLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(15)
                    make.top.equalTo(19)
                }
            }
            
        }
    }
    
    /// 首页的列表model
    public var model: YXSHomeListModel!
    
    /// cell点击block
    public var cellBlock: ((_ homeEvent: YXSHomeCellEvent) -> ())?
    
    /// cell长按block
    public var cellLongTapEvent: (() -> ())?
    
    // MARK: - public func
    
    /// 初始化子类通用的约束
    public func initCommonUI(){
        if isWaterfallCell{
            bgContainView.addSubview(tagLabel)
            tagLabel.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(19)
                make.height.equalTo(19)
            }
            
            bgContainView.addSubview(redView)
            redView.snp.makeConstraints { (make) in
                make.right.equalTo(-15)
                make.top.equalTo(0)
                make.size.equalTo(CGSize.init(width: 26, height: 29))
            }
            
            recallView.snp.makeConstraints { (make) in
                make.right.equalTo(-4.5)
                make.centerY.equalTo(tagLabel)
                make.size.equalTo(CGSize.init(width: 38, height: 38))
            }
            bgContainView.addSubview(stickView)
            stickView.snp.makeConstraints { (make) in
                make.right.equalTo(recallView.snp_left).offset(-5)
                make.centerY.equalTo(tagLabel)
                make.size.equalTo(CGSize.init(width: 30, height: 30))
            }
        }
//        tagLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    /// 子类继承
    /// - Parameter model: 首页的列表model
    public func yxs_setCellModel(_ model: YXSHomeListModel){
        
    }
    
    @objc public func longTap(_ longTap: UILongPressGestureRecognizer){
        if longTap.state == UIGestureRecognizer.State.began{
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER && isWaterfallCell{
                cellLongTapEvent?()
            }
        }
    }
    
    public func setSourceViewData(){
        sourceView.yxs_bgView.isHidden = true
        sourceView.vedioImage.isHidden = true
        if model.sourceType == 0{
            return
        }
        if model.sourceType == 4{
            sourceView.vedioImage.isHidden = false
            sourceView.yxs_setImageWithURL(url: URL.init(string: (model.bgUrl ?? "").yxs_getImageThumbnail()), placeholder: kImageDefualtMixedImage)
        }else if model.sourceType == 1{
            sourceView.image = UIImage.init(named: "audio_defult")
        }else{
            if model.sourceType == 3{
                sourceView.yxs_iconImage.image = UIImage.init(named: "audio")
                sourceView.yxs_label.text = "音频"
                sourceView.yxs_bgView.isHidden = false
            }
            sourceView.yxs_setImageWithURL(url: URL.init(string: (model.bgUrl ?? "").yxs_getImageThumbnail()), placeholder: kImageDefualtMixedImage)
        }
    }
    
    public func setTagUI(_ text: String?, backgroundColor: UIColor?, textColor: UIColor){
        tagLabel.text = text
        tagLabel.textColor = textColor
        tagLabel.mixedBackgroundColor =  MixedColor(normal: backgroundColor ?? UIColor.white, night: UIColor.yxs_hexToAdecimalColor(hex: "#2E303D"))
    }
    
    public func changeReadUI(_ isRead: Int?){
        if model.onlineCommit == 1{
            readButton.setTitle("回执", for: .normal)
            readButton.setTitle("已回执", for: .disabled)
        }else{
            readButton.setTitle("阅", for: .normal)
            readButton.setTitle("已阅", for: .disabled)
        }
        readButton.isEnabled = !((model.onlineCommit == 1 && model.commitState == 2) || (model.onlineCommit == 0 && model.isRead == 1))
        
        if model.onlineCommit == 1 && model.type == .homework{
            readButton.isHidden = true
        }else{
            readButton.isHidden = false
        }
        
        if readButton.isEnabled {
            readButton.mixedBackgroundColor = MixedColor(normal: kRedMainColor, night: kRedMainColor)
            readButton.cornerRadius = 14.5
            readButton.yxs_setIconInLeftWithSpacing(0)
        }else{
            readButton.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: UIColor.clear)
            readButton.cornerRadius = 0
            readButton.yxs_setIconInLeftWithSpacing(7)
        }
        
        readButton.snp.remakeConstraints { (make) in
            make.size.equalTo(model.readButtonSize)
            make.right.equalTo(-15)
            if model.isShowAll{
                //                make.top.equalTo(fromLabel.snp_bottom).offset(7.5)
                make.centerY.equalTo(classLabel)
            }else{
                if model.hasSource{
                    make.top.equalTo(sourceView.snp_bottom).offset(12.5)
                }else{
                    make.centerY.equalTo(classLabel)
                }
            }
        }
    }
    
    @objc public func showAllClick(){
        
    }
    
    @objc  public func yxs_recallClick(){
        
    }
    
    @objc public func stickClick(){
        if model != nil{
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER && model.teacherId == yxs_user.id{
                cellBlock?(.cancelStick)
            }
        }
        
    }
    
    @objc  public func readClick(){
        cellBlock?(.read)
    }
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        //        contentView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9")
        
        let longTap = UILongPressGestureRecognizer.init(target: self, action: #selector(longTap(_:)))
        contentView.addGestureRecognizer(longTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - getter&setter
    lazy var bgContainView: UIView = {
        let bgContainView = UIView()
        bgContainView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        bgContainView.cornerRadius = 4
        return bgContainView
    }()
    
    lazy var tagLabel: YXSPaddingLabel = {
        let label = YXSPaddingLabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textInsets = UIEdgeInsets.init(top: 0, left: 9, bottom: 0, right: 9)
        label.cornerRadius = 9.5
        label.clipsToBounds = true
        return label
    }()
    
    lazy var redView: UIImageView = {
        let redView = UIImageView()
        redView.image = UIImage.init(named: "home_new_read")
        return redView
    }()
    
    lazy var sourceView: YXSHomeSourceView = {
        let sourceView = YXSHomeSourceView()
        sourceView.clipsToBounds = true
        sourceView.cornerRadius = 2.5
        return sourceView
    }()
    
    
    lazy var readButton: YXSButton = {
        let button = YXSButton.init()
        button.setMixedTitleColor(MixedColor(normal: UIColor.white, night: UIColor.white), forState: .normal)
        button.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white), forState: .disabled)
        button.setImage(UIImage.init(named: "has_red"), for: .disabled)
        button.setImage(nil, for: .normal)
        button.setTitle("阅", for: .normal)
        button.setTitle("已阅", for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(readClick), for: .touchUpInside)
        return button
    }()
    
    lazy var nameTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var topTimeLabel: UILabel = {
        let label = UILabel()
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var classLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var showAllControl: YXSCustomImageControl = {
        let showAllControl = YXSCustomImageControl.init(imageSize: CGSize.init(width: 14, height: 14), position: YXSImagePositionType.right, padding: 5.5)
        showAllControl.mixedTextColor = MixedColor(normal: kRedMainColor, night: kRedMainColor)
        showAllControl.setTitle("查看全文", for: .normal)
        showAllControl.setTitle("收起", for: .selected)
        showAllControl.font = UIFont.boldSystemFont(ofSize: 14)
        showAllControl.setImage(UIImage.init(named: "down_gray"), for: .normal)
        showAllControl.setImage(UIImage.init(named: "up_gray"), for: .selected)
        showAllControl.addTarget(self, action: #selector(showAllClick), for: .touchUpInside)
        return showAllControl
    }()
    
    lazy var recallView: YXSButton = {
        let button = YXSButton()
        button.setImage(UIImage.init(named: "recall"), for: .normal)
        button.addTarget(self, action: #selector(yxs_recallClick), for: .touchUpInside)
        button.yxs_touchInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()
    
    lazy var stickView: YXSButton = {
        let button = YXSButton()
        button.setImage(UIImage.init(named: "Stick"), for: .normal)
        button.addTarget(self, action: #selector(stickClick), for: .touchUpInside)
        return button
    }()
}
