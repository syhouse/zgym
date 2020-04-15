//
//  YXSHomeworkReadListCell.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/25.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
/// 带副标题、右箭头
class YXSHomeworkReadListCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
        
        contentView.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightForegroundColor)
        contentView.addSubview(imgAvatar)
        contentView.addSubview(lbName)
        contentView.addSubview(lbSub)
        contentView.addSubview(imgRightArrow)
        
        imgAvatar.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(15)
            make.width.height.equalTo(40)
        })
        
        lbName.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(imgAvatar.snp_right).offset(13)
        })
        
        self.imgRightArrow.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.right.equalTo(-15)
        })
        
        lbSub.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.right.equalTo(imgRightArrow.snp_left).offset(-12)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setter
    var model: YXSClassMemberModel? {
        didSet {
            lbName.text = self.model?.realName
            imgAvatar.sd_setImage(with: URL(string: self.model?.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
            if self.model?.teacherId != yxs_user.id {
                self.lbSub.text = "去查看"
            }
            else {
                if self.model?.isRemark == true {
                    self.lbSub.text = "已点评"
                }else {
                    self.lbSub.text = "去点评"
                }
            }

//            self.lbSub.text = "去查看"
        }
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
    
    lazy var lbName: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNightFFFFFF)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbSub: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    
    lazy var imgRightArrow: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "yxs_class_arrow")
        return img
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
