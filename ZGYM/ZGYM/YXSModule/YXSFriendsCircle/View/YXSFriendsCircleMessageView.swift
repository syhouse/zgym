//
//  FriendsCircleMessageView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/17.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

let kFriendsCircleMessageViewGoMessageEvent = "FriendsCircleMessageViewGoMessageEvent"
private let maxcount: Int = 2
private let kImageViewOrginTag: Int = 101
class YXSFriendsCircleMessageView: UICollectionReusableView {
    override init(frame: CGRect){
        super.init(frame: frame)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        addSubview(controlBgView)
        controlBgView.addSubview(leftlabel)
        
        controlBgView.snp.makeConstraints { (make) in
            make.height.equalTo(31)
            make.centerX.equalTo(self)
            make.top.equalTo(11)
        }

        for index in 0 ..< maxcount{
            let rightImage = UIImageView()
            rightImage.cornerRadius = 13.5
            rightImage.tag = kImageViewOrginTag + index
            controlBgView.addSubview(rightImage)
            rightImage.contentMode = .scaleAspectFill
            rightImage.isHidden = true
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMessageTipsModel(messageModel: YXSPunchCardMessageTipsModel){
        for index in 0 ..< maxcount {
            let imageView = viewWithTag(kImageViewOrginTag + index) as! UIImageView
            imageView.isHidden = true
            imageView.snp.removeConstraints()
        }
        var last: UIView?
        for index in 0..<1{
            let rightImage = viewWithTag(kImageViewOrginTag + index) as! UIImageView

            let personRole = PersonRole.init(rawValue: messageModel.commentsUserInfo?.userType ?? "") ?? PersonRole.TEACHER
            rightImage.yxs_setImageWithURL(url: URL.init(string: messageModel.commentsUserInfo?.avatar ?? ""),placeholder: personRole == .TEACHER ? kImageUserIconTeacherDefualtMixedImage : kImageUserIconPartentDefualtMixedImage)
            
            rightImage.snp.makeConstraints { (make) in
                if index == 0{
                    make.left.equalTo(2.5)
                }else{
                    make.left.equalTo(2.5 + 13.5)
                }
                make.centerY.equalTo(controlBgView)
                make.size.equalTo(CGSize.init(width: 27, height: 27))
            }
            last = rightImage
            rightImage.isHidden = false
        }
        leftlabel.text = "\(messageModel.count ?? 0)新消息"
        leftlabel.snp.makeConstraints { (make) in
            make.left.equalTo(last!.snp_right).offset(8)
            make.centerY.equalTo(last!)
            make.right.equalTo(-7.5)
        }
    }
    
    func setMessageTipsModel(messageModel :YXSPhotoClassPhotoAlbumListMsgModel?){
        if let messageModel = messageModel{
            for index in 0 ..< maxcount {
                let imageView = viewWithTag(kImageViewOrginTag + index) as! UIImageView
                imageView.isHidden = true
                imageView.snp.removeConstraints()
            }
            var last: UIView?
            for index in 0..<1{
                let rightImage = viewWithTag(kImageViewOrginTag + index) as! UIImageView

                let personRole = PersonRole.init(rawValue: messageModel.messageUserType ?? "") ?? PersonRole.TEACHER
                rightImage.yxs_setImageWithURL(url: URL.init(string: messageModel.messageAvatar ?? ""),placeholder: personRole == .TEACHER ? kImageUserIconTeacherDefualtMixedImage : kImageUserIconPartentDefualtMixedImage)
                
                rightImage.snp.makeConstraints { (make) in
                    if index == 0{
                        make.left.equalTo(2.5)
                    }else{
                        make.left.equalTo(2.5 + 13.5)
                    }
                    make.centerY.equalTo(controlBgView)
                    make.size.equalTo(CGSize.init(width: 27, height: 27))
                }
                last = rightImage
                rightImage.isHidden = false
            }
            leftlabel.text = "\(messageModel.messageCount ?? 0)新消息"
            leftlabel.snp.makeConstraints { (make) in
                make.left.equalTo(last!.snp_right).offset(8)
                make.centerY.equalTo(last!)
                make.right.equalTo(-7.5)
            }
        }
    }
    
    func reloadData(){
        for index in 0 ..< maxcount {
            let imageView = viewWithTag(kImageViewOrginTag + index) as! UIImageView
            imageView.isHidden = true
            imageView.snp.removeConstraints()
        }
        var last: UIView?
        for index in 0..<1{
            let rightImage = viewWithTag(kImageViewOrginTag + index) as! UIImageView

            let personRole = PersonRole.init(rawValue: YXSPersonDataModel.sharePerson.friendsTips?.type ?? "") ?? PersonRole.TEACHER
            rightImage.yxs_setImageWithURL(url: URL.init(string: YXSPersonDataModel.sharePerson.friendsTips?.avatar ?? ""),placeholder: personRole == .TEACHER ? kImageUserIconTeacherDefualtMixedImage : kImageUserIconPartentDefualtMixedImage)
            
            rightImage.snp.makeConstraints { (make) in
                if index == 0{
                    make.left.equalTo(2.5)
                }else{
                    make.left.equalTo(2.5 + 13.5)
                }
                make.centerY.equalTo(controlBgView)
                make.size.equalTo(CGSize.init(width: 27, height: 27))
            }
            last = rightImage
            rightImage.isHidden = false
        }
        leftlabel.text = "\(YXSPersonDataModel.sharePerson.friendsTips?.count ?? 0)新消息"
        leftlabel.snp.makeConstraints { (make) in
            make.left.equalTo(last!.snp_right).offset(8)
            make.centerY.equalTo(last!)
            make.right.equalTo(-7.5)
        }
    }
    
    @objc func goMessage(){
        next?.yxs_routerEventWithName(eventName: kFriendsCircleMessageViewGoMessageEvent)
    }
    
    lazy var leftlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var controlBgView: UIControl = {
        let controlBgView = UIControl()
        controlBgView.addTarget(self, action: #selector(goMessage), for: .touchUpInside)
        controlBgView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#8AB0FF")
        controlBgView.cornerRadius = 15.5
        return controlBgView
    }()
}
