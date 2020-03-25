//
//  SLHomeworkCommitListCell.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/26.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight
/// 带私聊、打电话按钮
class SLHomeworkCommitListCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.contentView.sl_addLine(position: .bottom, color: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
        
        contentView.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightForegroundColor)
        contentView.addSubview(imgAvatar)
        contentView.addSubview(lbName)
        contentView.addSubview(btnChat)
        contentView.addSubview(btnPhone)
        
        imgAvatar.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(15)
            make.width.height.equalTo(40)
        })
        
        lbName.snp.makeConstraints({ (make) in
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
    var chatBlock: (()->())?
    var phoneBlock: (()->())?
    
    // MARK: - Setter
    var model:SLClassMemberModel? {
        didSet {
            lbName.text = self.model?.realName
            imgAvatar.sd_setImage(with: URL(string: self.model?.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
        }
    }
    
    @objc func chatClick(){
        chatBlock?()
    }
    
    @objc func phoneClick(){
        phoneBlock?()
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
    
    lazy var lbName: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNightFFFFFF)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var btnChat: SLButton = {
        let btn = SLButton()
        btn.setImage(UIImage(named: "sl_homework_chat2"), for: .normal)
        btn.addTarget(self, action: #selector(chatClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnPhone: SLButton = {
        let btn = SLButton()
        btn.setImage(UIImage(named: "sl_homework_phone"), for: .normal)
        btn.addTarget(self, action: #selector(phoneClick), for: .touchUpInside)
        return btn
    }()
    
//    lazy var lbSub: SLLabel = {
//        let lb = SLLabel()
//        lb.mixedTextColor = MixedColor(normal: 0x898F9A, night: 0x000000)
//        lb.text = ""
//        lb.font = UIFont.systemFont(ofSize: 15)
//        return lb
//    }()
//
//
//    lazy var imgRightArrow: UIImageView = {
//        let img = UIImageView()
//        img.image = UIImage(named: "sl_class_arrow")
//        return img
//    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
