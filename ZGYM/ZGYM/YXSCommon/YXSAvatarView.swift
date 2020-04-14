//
//  YXSAvatarView.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/3.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

enum YXSAvatarViewStyle {
    /// 仅标题
    case TitleOnly
    /// 标题+副标题
    case TitleSubTitle
}

/// 头像+标题+副标题
class YXSAvatarView: UIView {
//    private var avatarH:CGFloat = 42
    private var style:YXSAvatarViewStyle = .TitleOnly
    
    init(style:YXSAvatarViewStyle = .TitleSubTitle) {
        super.init(frame: CGRect.zero)
        self.style = style
        
        self.addSubview(imgAvatar)
        self.addSubview(lbTitle)
        
        switch style {
        case .TitleSubTitle:
            self.addSubview(lbSubTitle)
            self.addSubview(lbThirdTitle)
            
        default:
            break
        }
        
        layout()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    func layout() {
        
        imgAvatar.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(imgAvatar.snp_height)
        })
        
        switch self.style {
        case .TitleSubTitle:
            lbTitle.snp.makeConstraints({ (make) in
                make.top.equalTo(imgAvatar.snp_top).offset(3)
                make.left.equalTo(imgAvatar.snp_right).offset(13)
            })
            
            lbSubTitle.snp.makeConstraints({ (make) in
                make.bottom.equalTo(imgAvatar.snp_bottom).offset(-2)
                make.left.equalTo(imgAvatar.snp_right).offset(13)
            })
            lbSubTitle.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
            
            lbThirdTitle.snp.makeConstraints({ (make) in
                make.bottom.equalTo(imgAvatar.snp_bottom).offset(-2)
                make.left.equalTo(lbSubTitle.snp_right).offset(13)
                make.right.equalTo(-10)
            })
            lbThirdTitle.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
            
        default:
            /// TitleOnly
            lbTitle.snp.makeConstraints({ (make) in
                make.centerY.equalTo(imgAvatar.snp_centerY)
                make.left.equalTo(imgAvatar.snp_right).offset(13)
            })
            break
        }
    }
    
    // MARK: - LazyLoad
    lazy var imgAvatar: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.lightGray
        img.cornerRadius = 21
        img.image = UIImage(named: "normal")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNight898F9A)
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbSubTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    lazy var lbThirdTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
//        lb.text = "2019/11/13 14:30"
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
}


import UIKit
import NightNight

/// 头像+标题+副标题+圆角按钮
class SLAvatarContactView: YXSAvatarView {
    init() {
        super.init(style: .TitleSubTitle)
    }
    
    override func layout() {
        self.addSubview(btnChat)
        imgAvatar.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(imgAvatar.snp_height)
        })
        

        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(imgAvatar.snp_top).offset(3)
            make.left.equalTo(imgAvatar.snp_right).offset(13)
        })
        
        lbSubTitle.snp.makeConstraints({ (make) in
            make.bottom.equalTo(imgAvatar.snp_bottom).offset(-2)
            make.left.equalTo(imgAvatar.snp_right).offset(13)
            make.right.equalTo(btnChat.snp_left).offset(-5)
        })
        lbSubTitle.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        lbSubTitle.setContentHuggingPriority(.required, for: .horizontal)

        lbTitle.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        lbTitle.setContentHuggingPriority(.required, for: .horizontal)

        lbThirdTitle.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
        lbThirdTitle.setContentHuggingPriority(.defaultLow, for: .horizontal)

        

        btnChat.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(lbThirdTitle.snp_right).offset(10)
            make.right.equalTo(0)
            make.width.equalTo(85)
            make.height.equalTo(34)
        })
        lbThirdTitle.snp.makeConstraints({ (make) in
                    make.top.equalTo(imgAvatar.snp_top).offset(3)
                    make.left.equalTo(lbTitle.snp_right).offset(3)
                    make.right.equalTo(btnChat.snp_left).offset(-5)
        //            make.right.equalTo(-10)
                })
    }

//    lazy var avatarView: YXSAvatarView = {
//        let view = YXSAvatarView(style: .TitleSubTitle)
//        return view
//    }()
//
    lazy var btnChat: YXSButton = {
        let btn = YXSButton()
//        UIFont.boldSystemFont(ofSize: 15)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.setMixedTitleColor(MixedColor(normal: kNight898F9A, night: kNight898F9A), forState: .normal)
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.mixedBorderColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        btn.layer.cornerRadius = 17
        return btn
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
