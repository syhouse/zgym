//
//  YXSMyCollectAlbumCell.swift
//  HNYMEducation
//
//  Created by yihao on 2020/4/14.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import NightNight

class YXSMyCollectAlbumCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        contentView.addSubview(headIcon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(countLabel)
        
        headIcon.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.width.height.equalTo(63)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.left.equalTo(headIcon.snp_right).offset(20)
            make.right.equalTo(-15)
            make.height.equalTo(18)
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-25)
            make.height.equalTo(18)
            make.left.equalTo(nameLabel)
            make.right.equalTo(-15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model:YXSMyCollectModel) {
        headIcon.sd_setImage(with: URL(string: model.albumIconUrl ?? ""), placeholderImage: UIImage.init(named: "yxs_logo"))
        nameLabel.text = model.albumName
        countLabel.text = "共\(model.albumSongs ?? 0)首"
    }
    
    // MARK: -getter&setter
    lazy var nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#222222"), night: kNightBCC6D4)
        return label
    }()
    
    lazy var headIcon: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage.init(named: "yxs_logo")
        return imgV
    }()
    
    lazy var countLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        return label
    }()
}
