//
//  SLBaseDetailViewCell.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/3.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

/// 头像+标题和副标题居中+打电话+私聊
class SLDetailAllTitleCell2: SLBaseDetailViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let panel = UIView()
        panel.addSubview(lbTitle)
        panel.addSubview(lbSubTitle)
        contentView.addSubview(panel)
        contentView.addSubview(btnChat)
        contentView.addSubview(btnPhone)
        
        panel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(imgAvatar.snp_right).offset(13)
        })
        
        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
        })
        
        lbSubTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle.snp_bottom).offset(5)
            make.bottom.equalTo(0)
            make.left.equalTo(imgAvatar.snp_right).offset(13)
        })
        
        btnPhone.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.right.equalTo(-15)
            make.width.height.equalTo(22)
        })
        
        btnChat.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.right.equalTo(btnPhone.snp_left).offset(-20)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 头像+标题和副标题居中+右标题
class SLDetailAllTitleCell: SLBaseDetailViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let panel = UIView()
        panel.addSubview(lbTitle)
        panel.addSubview(lbSubTitle)
        contentView.addSubview(panel)
        contentView.addSubview(lbRightTitle)
        
        panel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(imgAvatar.snp_right).offset(13)
        })
        
        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
        })
        
        lbSubTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle.snp_bottom).offset(5)
            make.bottom.equalTo(0)
            make.left.equalTo(imgAvatar.snp_right).offset(13)
        })
        
        lbRightTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp_centerY)
            make.right.equalTo(contentView.snp_right).offset(-18)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 头像+居中标题+右标题
class SLDetailCenterTitleCell: SLBaseDetailViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(lbRightTitle)
        
        lbTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(imgAvatar.snp_right).offset(13)
        })
        lbRightTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp_centerY)
            make.right.equalTo(contentView.snp_right).offset(-18)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 头像和居中标题 打电话+私聊
class SLDetailContactCell: SLBaseDetailViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        //        self.contentView.backgroundColor = UIColor.white
        contentView.addSubview(btnChat)
        contentView.addSubview(btnPhone)
        
        imgAvatar.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(15)
            make.width.height.equalTo(40)
        })
        
        lbTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(imgAvatar.snp_right).offset(13)
        })
        
        btnPhone.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.right.equalTo(-15)
            make.width.height.equalTo(22)
        })
        
        btnChat.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.right.equalTo(btnPhone.snp_left).offset(-20)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 头像和居中标题 右箭头+右标题
class SLDetailRightArrowCell: SLDetailNormalCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        contentView.addSubview(lbSubTitle)
        contentView.addSubview(imgRightArrow)
        
        lbTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(imgAvatar.snp_right).offset(13)
        })
        
        imgRightArrow.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.right.equalTo(-15)
        })
        
        lbRightTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.right.equalTo(imgRightArrow.snp_left).offset(-12)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 头像和居中标题
class SLDetailNormalCell: SLBaseDetailViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(imgAvatar)
        self.contentView.addSubview(lbTitle)
        
        lbTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(imgAvatar.snp_right).offset(13)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


/// 基类
class SLBaseDetailViewCell: SLBaseTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(imgAvatar)
        self.contentView.addSubview(lbTitle)
        
        imgAvatar.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(15)
            make.width.height.equalTo(40)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LazyLoad
    lazy var imgAvatar: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.lightGray
        img.clipsToBounds = true
        img.cornerRadius = 20
        img.image = UIImage(named: "normal")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var lbTitle: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNightFFFFFF)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbSubTitle: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    lazy var lbRightTitle: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    lazy var imgRightArrow: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "sl_class_arrow")
        return img
    }()
    
    
    lazy var btnChat: SLButton = {
        let btn = SLButton()
        btn.setImage(UIImage(named: "sl_homework_chat2"), for: .normal)
        return btn
    }()
    
    lazy var btnPhone: SLButton = {
        let btn = SLButton()
        btn.setImage(UIImage(named: "sl_homework_phone"), for: .normal)
        return btn
    }()
    
    
    // MARK: -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
