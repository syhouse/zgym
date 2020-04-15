//
//  ChatTableViewCell.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/21.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSContactCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
//        backgroundColor = UIColor.white
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        self.contentView.addSubview(self.imgAvatar)
        let container = UIView()
        container.addSubview(lbName)
        container.addSubview(lbDescription)
        self.contentView.addSubview(container)
        self.contentView.addSubview(self.btnPhone)
        
        self.imgAvatar.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.left.equalTo(15)
            make.width.height.equalTo(40)
        })

        
        container.snp.makeConstraints({ (make) in
            make.centerY.equalTo(snp_centerY)
            make.left.equalTo(imgAvatar.snp_right).offset(13)
            make.right.equalTo(btnPhone.snp_left).offset(-13)
        })
        
        lbName.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        })
        
        lbDescription.snp.makeConstraints({ (make) in
            make.top.equalTo(lbName.snp_bottom).offset(5)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        })
        
        btnPhone.snp.makeConstraints({ (make) in
            make.centerY.equalTo(snp_centerY)
            make.width.height.equalTo(60)
            make.right.equalTo(-2)
        })
        
        self.yxs_addLine(position: LinePosition.bottom, color: kLineColor, leftMargin: 68, rightMargin: 0, lineHeight: 0.5)
    }
    
    var model: YXSContactModel? {
        didSet {
            ///Custom设置默认头像
            let img = (self.model?.imId?.contains("TEACHER"))! ? kImageUserIconTeacherDefualtImage : kImageUserIconPartentDefualtImage
            imgAvatar.sd_setImage(with: URL(string: self.model?.imAvatar ?? ""), placeholderImage: img)
            if self.model?.imNick?.count ?? 0 > 0 {
                let arr = self.model?.imNick?.components(separatedBy: "&")
                lbDescription.text =  arr?.first ?? ""
                lbName.text = arr?.last ?? ""
            }
            
            if (self.model?.imId?.contains("TEACHER") ?? false) {
                if self.model?.position == "HEADMASTER" {
                    lbDescription.isHidden = false
                    lbDescription.text = "班主任"
                    
                    lbName.snp.remakeConstraints({ (make) in
                        make.top.equalTo(0)
                        make.left.equalTo(0)
                        make.right.equalTo(0)
                    })
                    
                    lbDescription.snp.remakeConstraints({ (make) in
                        make.top.equalTo(lbName.snp_bottom).offset(5)
                        make.left.equalTo(0)
                        make.right.equalTo(0)
                        make.bottom.equalTo(0)
                    })
                    
                } else {
                    lbDescription.isHidden = true
                    lbName.snp.remakeConstraints({ (make) in
                        make.centerY.equalTo(snp_centerY)
                        make.left.equalTo(0)
                        make.right.equalTo(0)
                    })
                }
                

                
            } else {
                lbDescription.isHidden = false
                lbName.snp.remakeConstraints({ (make) in
                    make.top.equalTo(0)
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                })
                
                lbDescription.snp.remakeConstraints({ (make) in
                    make.top.equalTo(lbName.snp_bottom).offset(5)
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                    make.bottom.equalTo(0)
                })
            }
        }
    }
    
    // MARK: - Action
    @objc func yxs_callUpClick() {
        self.yxs_callUp(mobile: model?.account ?? "")
    }
    
    // MARK: - LazyLoad
    lazy var imgAvatar: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 20
        img.image = YXSPersonDataModel.sharePerson.personRole == .TEACHER ? kImageUserIconStudentDefualtImage : kImageUserIconTeacherDefualtImage
        img.contentMode = .scaleAspectFill
        return img
    }()
    
//    lazy var lbCorner: YXSLabel = {
//        let lb = YXSLabel()
//        lb.clipsToBounds = true
//        lb.layer.cornerRadius = 4
//        lb.textAlignment = .center
//        lb.mixedTextColor = MixedColor(normal: 0xFFFFFF, night: 0x000000)
//        lb.backgroundColor = UIColor.red
//        lb.text = ""
//        lb.font = UIFont.systemFont(ofSize: 12)
//        return lb
//    }()
    
    lazy var lbName: YXSLabel = {
        let lb = YXSLabel()
//        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        lb.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightFFFFFF)
        lb.text = "Name"
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbDescription: YXSLabel = {
        let lb = YXSLabel()
//        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.text = "Description"
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    lazy var btnPhone: YXSButton = {
        let btn = YXSButton()
        btn.setImage(UIImage(named: "yxs_homework_phone"), for: .normal)
        btn.addTarget(self, action: #selector(yxs_callUpClick), for: .touchUpInside)
        return btn
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
