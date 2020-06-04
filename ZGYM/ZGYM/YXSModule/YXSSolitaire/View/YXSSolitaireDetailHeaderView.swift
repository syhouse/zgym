//
//  YXSSolitaireDetailHeaderView.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/2.
//  Copyright © 2020 zgym. All rights reserved.
//

import NightNight
import UIKit

class YXSSolitaireDetailHeaderView: UITableViewHeaderFooterView {

    var videoTouchedBlock:((_ videoUlr: String)->())?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightForegroundColor)
        
        self.contentView.addSubview(avatarView)
        self.contentView.addSubview(mediaView)
        self.contentView.addSubview(linkView)
        self.contentView.addSubview(dateView)

        mediaView.videoTouchedHandler = { [weak self](url) in
            guard let weakSelf = self else {return}
            weakSelf.videoTouchedBlock?(url)
        }

        
        avatarView.snp.makeConstraints({ (make) in
            make.top.equalTo(17)
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
            mediaView.snp.makeConstraints({ (make) in
                make.top.equalTo(dateView.snp_bottom).offset(19)
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
    
    

}
