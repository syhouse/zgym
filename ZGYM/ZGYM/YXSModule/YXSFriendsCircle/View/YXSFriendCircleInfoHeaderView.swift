//
//  YXSFriendCircleInfoHeaderView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/17.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

let kFriendCircleInfoHeaderDetialEvent = "FriendCircleInfoHeaderDetialEvent"
class YXSFriendCircleInfoHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightForegroundColor)
        addSubview(headerImageSection)
        addSubview(nameSection)
        addSubview(friendSection)
        
        headerImageSection.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        nameSection.snp.makeConstraints { (make) in
            make.top.equalTo(headerImageSection.snp_bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        friendSection.snp.makeConstraints { (make) in
            make.top.equalTo(nameSection.snp_bottom).offset(10)
            make.left.right.equalTo(0)
            make.height.equalTo(79)
            make.bottom.equalTo(-10)
        }
        friendSection.addTarget(self, action: #selector(goToFriendDetial), for: .touchUpInside)
    }
    
    
    @objc func imageClick(){
        if model.avatar?.count ?? 0 > 0 {
            YXSShowBrowserHelper.showImage(urls: [URL.init(string: model.avatar ?? "")!], curruntIndex: nil)
        } else  {
            YXSShowBrowserHelper.showImage(images: [self.headerImageSection.rightImage.image], curruntIndex: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model:YXSFriendCircleUserInfoModel!
    func setHeaderModel(_ model: YXSFriendCircleUserInfoModel){
        self.model = model
        var images = [String]()
        headerImageSection.isHidden = true
        if let attachment = model.attachment{
            if attachment.hasSuffix(kHMVedioAppendKey){
                images = [attachment.removingSuffix(kHMVedioAppendKey).yxs_getVediUrlImage()]
            }else{
                images = attachment.components(separatedBy: ",")
            }
            friendSection.setImages(images: images)
        }
        if (PersonRole.init(rawValue: model.type ?? "") ?? PersonRole.TEACHER) == PersonRole.PARENT{
            nameSection.snp.remakeConstraints { (make) in
                make.top.equalTo(10)
                make.left.right.equalTo(0)
                make.height.equalTo(49)
            }
        }else{
            headerImageSection.isHidden = false
            headerImageSection.rightImage.sd_setImage(with: URL.init(string: model.avatar ?? ""),placeholderImage: (PersonRole.init(rawValue: model.type ?? "") ?? PersonRole.TEACHER == .TEACHER) ? kImageUserIconTeacherDefualtImage : kImageUserIconStudentDefualtImage, completed: nil)
        }
        nameSection.rightLabel.text = model.name
        nameSection.leftlabel.text = model.type == PersonRole.TEACHER.rawValue ? "老师名字" : "家长名字"
    }
    
    @objc func goToFriendDetial(){
        next?.yxs_routerEventWithName(eventName: kFriendCircleInfoHeaderDetialEvent)
    }
    
    lazy var headerImageSection: YXSCommonSection = {
        let section = YXSCommonSection.init(type: YXSCommonSectionType.onlyRightImage)
        section.leftlabel.text = "头像"
        section.rightImage.contentMode = .scaleAspectFill
        section.rightImage.addTaget(target: self, selctor: #selector(imageClick))
        return section
    }()
    
    lazy var nameSection: YXSCommonSection = {
        let section = YXSCommonSection.init(type: YXSCommonSectionType.onlyRightTitle)
        section.leftlabel.text = "家长名字"
        return section
    }()
    lazy var friendSection: FriendCircleImagesView = {
        let section = FriendCircleImagesView()
        section.leftlabel.text = "优成长"
        return section
    }()
}

private let maxcount: Int = 4
private let kImageViewOrginTag: Int = 101
class FriendCircleImagesView: UIControl {
    var imageWidth = 48.5
    override init(frame: CGRect){
        super.init(frame: CGRect.zero)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        addSubview(leftlabel)
        addSubview(arrowImage)
        
        
        leftlabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(self)
        }
        arrowImage.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.size.equalTo(CGSize.init(width: 13.4, height: 13.4))
            make.centerY.equalTo(self)
        }
        
        for index in 0 ..< maxcount{
            let rightImage = UIImageView()
            rightImage.cornerRadius = 2.5
            rightImage.tag = kImageViewOrginTag + index
            addSubview(rightImage)
            rightImage.isHidden = true
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImages(images: [String]){
        var last: UIView!
        let count = (images.count >= maxcount) ? maxcount : images.count
        for index in 0 ..< count {
            
            let rightImage = viewWithTag(kImageViewOrginTag + index) as! UIImageView
            rightImage.sd_setImage(with: URL.init(string: images[index]),placeholderImage: kImageDefualtImage, completed: nil)
            rightImage.snp.makeConstraints { (make) in
                if index == 0{
                    make.right.equalTo(arrowImage.snp_left).offset(-11)
                }else{
                    make.right.equalTo(last.snp_left).offset(-7)
                }
                make.centerY.equalTo(arrowImage)
                make.size.equalTo(CGSize.init(width: imageWidth, height: imageWidth))
            }
            rightImage.isHidden = false
            last = rightImage
        }
    }
    
    func setImages(images: [UIImage?]){
        var last: UIView!
        let count = (images.count >= maxcount) ? maxcount : images.count
        for index in 0 ..< count {
            
            let rightImage = viewWithTag(kImageViewOrginTag + index) as! UIImageView
            rightImage.image = images[index]
            rightImage.snp.makeConstraints { (make) in
                if index == 0{
                    make.right.equalTo(arrowImage.snp_left).offset(-11)
                }else{
                    make.right.equalTo(last.snp_left).offset(-7)
                }
                make.centerY.equalTo(arrowImage)
                make.size.equalTo(CGSize.init(width: imageWidth, height: imageWidth))
            }
            rightImage.isHidden = false
            last = rightImage
        }
    }
    
    lazy var leftlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white)
        return label
    }()
    
    lazy var arrowImage: UIImageView = {
        let arrowImage = UIImageView.init(image: UIImage.init(named: "arrow_gray"))
        return arrowImage
    }()
}
