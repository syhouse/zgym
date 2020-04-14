//
//  SLProfileTableViewCell.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/20.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

enum ProfileCellStyle {
    case SubTitle
    case ImageViews
}
class YXSProfileTableViewCell: YXSBaseTableViewCell {
    
    var avatarTap:((_ avatar:UIImage)->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

//        cellStyle = .SubTitle
        self.contentView.yxs_addLine(position: LinePosition.bottom, color: kLineColor, leftMargin: 15, rightMargin: 0, lineHeight: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cellStyle: ProfileCellStyle? {
        didSet {
            if self.cellStyle == ProfileCellStyle.SubTitle {
                createSubTitleStyle()
            } else {
                createImageViewStyle()
            }
        }
    }
    
    func createSubTitleStyle() {
        self.contentView.addSubview(self.lbTitle)
        self.contentView.addSubview(self.lbSubTitle)
        self.contentView.addSubview(self.imgRightArrow)
        
        self.lbTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(self.contentView.snp_left).offset(15)
//            make.right.equalTo(self.lbSubTitle.snp_left).offset(10)
        })
        
        self.lbSubTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(self.lbTitle.snp_right).offset(10)
//            make.right.equalTo(self.imgAvatar.snp_left).offset(10)
        })
        
        self.imgRightArrow.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(self.lbSubTitle.snp_right).offset(10)
            make.right.equalTo(self.contentView.snp_right).offset(-10)
        })
    }
    
    func createImageViewStyle() {
        self.contentView.addSubview(self.lbTitle)
        self.contentView.addSubview(self.imgRightArrow)
        self.contentView.addSubview(self.imgAvatar)
        
        self.lbTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(self.contentView.snp_left).offset(15)
        })
        
        self.imgAvatar.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.right.equalTo(self.imgRightArrow.snp_left).offset(-12)
            make.width.height.equalTo(42)
        })
        
        self.imgRightArrow.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.right.equalTo(self.contentView.snp_right).offset(-15)
        })
    }
    
    
    @objc func avatarClick() {
        avatarTap?(imgAvatar.image!)
    }
    
    // MARK: - LazyLoad
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: 0x575A60, night: 0xFFFFFF)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbSubTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return lb
    }()
    
    
    lazy var imgAvatar: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.cornerRadius = 21
        img.contentMode = .scaleAspectFill
        img.isUserInteractionEnabled = true
        let gestrue = UITapGestureRecognizer(target: self, action: #selector(avatarClick))
        img.addGestureRecognizer(gestrue)
        return img
    }()
        
    lazy var imgRightArrow: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "arrow_gray")
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
