//
//  YXSFriendCircleMessageListCell.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/17.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSFriendCircleMessageListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        contentView.addSubview(nameLabel)
        contentView.addSubview(commentLabel)
        //        contentView.addSubview(userIconImage)
        contentView.addSubview(rightImage)
        //        userIconImage.snp.makeConstraints { (make) in
        //            make.left.equalTo(15)
        //            make.centerY.equalTo(contentView)
        //            make.size.equalTo(CGSize.init(width: 41, height: 41))
        //        }
        rightImage.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 48.5, height: 48.5))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(17)
        }
        commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp_bottom).offset(7)
            make.right.equalTo(-60)
        }
        
        yxs_addLine(position: .bottom, leftMargin: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///设置右边的展示图片  资源地址
    private func setRightUI(imgeUrl: String?){
        if let attachment = imgeUrl{
            if attachment.hasSuffix(kHMVedioAppendKey){
                rightImage.isHidden = false
                rightImage.yxs_setImageWithURL(url: URL.init(string: attachment.removingSuffix(kHMVedioAppendKey).yxs_getVediUrlImage()), placeholder: kImageDefualtMixedImage)
            }else{
                let images: [String] = attachment.components(separatedBy: ",")
                if images.count > 0 {
                    rightImage.isHidden = false
                    rightImage.yxs_setImageWithURL(url: URL.init(string: images.first!), placeholder: kImageDefualtMixedImage)
                }
            }
        }
    }
    
    func setCellModel(_ model: YXSFriendsMessageModel){
        nameLabel.text = model.operatorName
        let bodyColor = NightNight.theme == .normal ? kTextMainBodyColor : UIColor.white
        let grayBodyColor = NightNight.theme == .normal ? UIColor.yxs_hexToAdecimalColor(hex: "#575A60") : kNightBCC6D4
        let nameText: String = model.receiverName ?? ""
        if model.type == "COMMENT"{
            UIUtil.yxs_setLabelAttributed(commentLabel, text: ["评论:", "\(model.content ?? "")" ], colors: [grayBodyColor,grayBodyColor])
        }else if model.type == "REPLY"{
            UIUtil.yxs_setLabelAttributed(commentLabel, text: ["回复", "\(nameText):", "\(model.content ?? "")" ], colors: [grayBodyColor,bodyColor,grayBodyColor])
        }else{
            UIUtil.yxs_setLabelAttributed(commentLabel, text: ["点赞" ], colors: [grayBodyColor])
        }
        
        rightImage.isHidden = true
        setRightUI(imgeUrl: model.attachment)
    }
    
    func setCellModel(_ model: YXSPunchCardMessageModel){
        nameLabel.text = model.receiveCommentsJsonObject?.userName
        let bodyColor = NightNight.theme == .normal ? kTextMainBodyColor : UIColor.white
        let grayBodyColor = NightNight.theme == .normal ? UIColor.yxs_hexToAdecimalColor(hex: "#575A60") : kNightBCC6D4
        let nameText: String =  model.receiveCommentsJsonObject?.ruserName ?? ""
        if model.receiveCommentsJsonObject?.ruserId == nil{
            UIUtil.yxs_setLabelAttributed(commentLabel, text: ["评论:", "\(model.receiveCommentsJsonObject?.content ?? "")" ], colors: [grayBodyColor,grayBodyColor])
        }else{
            UIUtil.yxs_setLabelAttributed(commentLabel, text: ["回复", "\(nameText):", "\(model.receiveCommentsJsonObject?.content ?? "")" ], colors: [grayBodyColor,bodyColor,grayBodyColor])
        }
        rightImage.isHidden = true
        setRightUI(imgeUrl: model.imageUrl)
    }
    
    func setCellModel(_ model: YXSHomeworkMessageModel){
        nameLabel.text = model.operatorName
        let bodyColor = NightNight.theme == .normal ? kBlueColor : UIColor.white
        let grayBodyColor = NightNight.theme == .normal ? UIColor.yxs_hexToAdecimalColor(hex: "#575A60") : kNightBCC6D4
        let nameText: String = model.recipient == yxs_user.id ? "我:" :  ""
        if model.type == HomeworkMessageType.COMMENT {
            UIUtil.yxs_setLabelAttributed(commentLabel, text: ["评论", nameText, " \(model.content ?? "")" ], colors: [grayBodyColor,bodyColor,grayBodyColor])
        } else if model.type == HomeworkMessageType.REPLY {
            UIUtil.yxs_setLabelAttributed(commentLabel, text: ["回复", nameText, " \(model.content ?? "")" ], colors: [grayBodyColor,bodyColor,grayBodyColor])
        } else {
            UIUtil.yxs_setLabelAttributed(commentLabel, text: ["点赞" ], colors: [grayBodyColor])
        }
        rightImage.isHidden = true
    }
    
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return label
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4)
        return label
    }()
    
    lazy var userIconImage: UIImageView = {
        let rightImage = UIImageView()
        rightImage.cornerRadius = 20.5
        return rightImage
    }()
    lazy var rightImage: UIImageView = {
        let rightImage = UIImageView()
        rightImage.cornerRadius = 2.5
        return rightImage
    }()
}
