//
//  YXSHomeworkUncommetListCell.swift
//  HNYMEducation
//
//  Created by apple on 2020/2/28.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

class YXSHomeworkUncommetListCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.contentView.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
        
        contentView.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightForegroundColor)
        contentView.addSubview(imgAvatar)
        contentView.addSubview(lbName)
        contentView.addSubview(btnSelect)
        
        btnSelect.snp.makeConstraints({ (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.width.height.equalTo(40)
        })
        
        imgAvatar.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(btnSelect.snp_right).offset(5)
            make.width.height.equalTo(40)
        })
        
        lbName.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(imgAvatar.snp_right).offset(13)
        })

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var selectBlock: (()->())?
    
    // MARK: - Setter
    var model:YXSClassMemberModel? {
        didSet {
            lbName.text = self.model?.realName
            imgAvatar.sd_setImage(with: URL(string: self.model?.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
        }
    }
    
    @objc func selectClick(){
        btnSelect.isSelected = !btnSelect.isSelected
        selectBlock?()
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
        lb.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNightFFFFFF)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    lazy var btnSelect: YXSButton = {
        let btn = YXSButton()
        btn.setImage(UIImage(named: "yxs_chose_normal"), for: .normal)
        btn.setImage(UIImage(named: "yxs_chose_selected"), for: .selected)
        btn.addTarget(self, action: #selector(selectClick), for: .touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        return btn
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
