//
//  SLHomeBaseCell.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/19.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight


public enum HomeCellEvent: Int{
    case showAll
    case read
    case punchRemind
    case goPunch
    case solitaire
    case score
    case classstart
    case recall
    case goSolitaire //去接龙
    case noticeReceipt//通知回执
    case cancelStick//取消置顶
}


class SLHomeBaseCell: UITableViewCell {
    var isSingleHome: Bool?{
        didSet{
            contentView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        }
    }
    
    
    
    /// 是否展示标签
    var isShowTag: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        //        contentView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9")
        
        let longTap = UILongPressGestureRecognizer.init(target: self, action: #selector(longTap(_:)))
        contentView.addGestureRecognizer(longTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func initCommonUI(){
        if isShowTag{
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
    }
    
    var model: SLHomeListModel!
    var cellBlock: ((_ homeEvent: HomeCellEvent) -> ())?
    var cellLongTapEvent: (() -> ())?
    
    func sl_setCellModel(_ model: SLHomeListModel){
        
    }
    
    
    /// 是否置顶
    var isTop: Bool = false{
        didSet{
            stickView.isHidden = isTop ? false : true
            if isShowTag{
                nameTimeLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(tagLabel.snp_right).offset(11)
                    make.centerY.equalTo(tagLabel)
                    make.right.equalTo(stickView.isHidden ? -45 : -75)
                }
            }else{
                nameTimeLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(15)
                    make.top.equalTo(19)
                    make.right.equalTo(-45)
                }
            }
            
        }
    }
    
    // MARK: -action
    @objc func longTap(_ longTap: UILongPressGestureRecognizer){
        if longTap.state == UIGestureRecognizer.State.began{
            if SLPersonDataModel.sharePerson.personRole == .TEACHER{
                cellLongTapEvent?()
            }
        }
    }
    
    @objc func readClick(){
        cellBlock?(.read)
    }
    
    func setSourceViewData(){
        sourceView.bgView.isHidden = true
        if model.sourceType == 0{
            return
        }
        if model.sourceType == 4{
            sourceView.bgView.isHidden = false
            sourceView.iconImage.image = UIImage.init(named: "vedio")
            sourceView.label.text = "视频"
            sourceView.sl_setImageWithURL(url: URL.init(string: (model.bgUrl ?? "").sl_getVediUrlImage()), placeholder: kImageDefualtMixedImage)
        }else if model.sourceType == 1{
            sourceView.image = UIImage.init(named: "audio_defult")
        }else{
            if model.sourceType == 3{
                sourceView.iconImage.image = UIImage.init(named: "audio")
                sourceView.label.text = "音频"
                sourceView.bgView.isHidden = false
            }
            sourceView.sl_setImageWithURL(url: URL.init(string: (model.bgUrl ?? "").sl_getVediUrlImage()), placeholder: kImageDefualtMixedImage)
        }
    }
    
    // MARK: -setTool
    func setTagUI(_ text: String?, backgroundColor: UIColor?, textColor: UIColor){
        tagLabel.text = text
        tagLabel.textColor = textColor
        tagLabel.mixedBackgroundColor =  MixedColor(normal: backgroundColor ?? UIColor.white, night: UIColor.sl_hexToAdecimalColor(hex: "#2E303D"))
    }
    
    func changeReadUI(_ isRead: Int?){
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
            readButton.mixedBackgroundColor = MixedColor(normal: kBlueColor, night: kBlueColor)
            readButton.cornerRadius = 14.5
            readButton.sl_setIconInLeftWithSpacing(0)
        }else{
            readButton.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: UIColor.clear)
            readButton.cornerRadius = 0
            readButton.sl_setIconInLeftWithSpacing(7)
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
    
    @objc func showAllClick(){
        
    }
    
    @objc func sl_recallClick(){
        
    }
    
    @objc func stickClick(){
        if model != nil{
            if SLPersonDataModel.sharePerson.personRole == .TEACHER && model.teacherId == sl_user.id{
                cellBlock?(.cancelStick)
            }
        }
        
    }
    
    // MARK: -getter&setter
    lazy var bgContainView: UIView = {
        let bgContainView = UIView()
        bgContainView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        bgContainView.cornerRadius = 4
        return bgContainView
    }()
    
    lazy var tagLabel: SLPaddingLabel = {
        let label = SLPaddingLabel()
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
    
    lazy var sourceView: SLHomeSourceView = {
        let sourceView = SLHomeSourceView()
        sourceView.clipsToBounds = true
        sourceView.cornerRadius = 2.5
        return sourceView
    }()
    
    
    lazy var readButton: SLButton = {
        let button = SLButton.init()
        button.setMixedTitleColor(MixedColor(normal: UIColor.white, night: UIColor.white), forState: .normal)
        button.setMixedTitleColor(MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white), forState: .disabled)
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
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#898F9A")
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var classLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#898F9A")
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var showAllControl: SLCustomImageControl = {
        let showAllControl = SLCustomImageControl.init(imageSize: CGSize.init(width: 14, height: 14), position: SLImagePositionType.right, padding: 5.5)
        showAllControl.mixedTextColor = MixedColor(normal: kBlueColor, night: kBlueColor)
        showAllControl.setTitle("查看全文", for: .normal)
        showAllControl.setTitle("收起", for: .selected)
        showAllControl.font = UIFont.boldSystemFont(ofSize: 14)
        showAllControl.setImage(UIImage.init(named: "down_gray"), for: .normal)
        showAllControl.setImage(UIImage.init(named: "up_gray"), for: .selected)
        showAllControl.addTarget(self, action: #selector(showAllClick), for: .touchUpInside)
        return showAllControl
    }()
    
    lazy var recallView: SLButton = {
        let button = SLButton()
        button.setImage(UIImage.init(named: "recall"), for: .normal)
        button.addTarget(self, action: #selector(sl_recallClick), for: .touchUpInside)
        return button
    }()
    
    lazy var stickView: SLButton = {
        let button = SLButton()
        button.setImage(UIImage.init(named: "Stick"), for: .normal)
        button.addTarget(self, action: #selector(stickClick), for: .touchUpInside)
        return button
    }()
}
