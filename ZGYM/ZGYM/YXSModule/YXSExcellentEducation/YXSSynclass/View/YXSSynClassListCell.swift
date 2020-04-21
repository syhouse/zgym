//
//  YXSSynClassListCell.swift
//  ZGYM
//
//  Created by yihao on 2020/4/20.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight

class YXSSynClassListCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImgV)
        contentView.addSubview(nameLbl)
        contentView.addSubview(playImgV)
        contentView.addSubview(playnumLbl)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout(){
        iconImgV.snp.makeConstraints { (make) in
            make.left.top.equalTo(15)
            make.width.height.equalTo(63)
        }
        nameLbl.snp.makeConstraints { (make) in
            make.left.equalTo(iconImgV.snp_right).offset(19)
            make.top.equalTo(iconImgV).offset(5)
            make.right.equalTo(-15)
            make.height.equalTo(17)
        }
        playImgV.snp.makeConstraints { (make) in
            make.left.equalTo(nameLbl)
            make.bottom.equalTo(iconImgV).offset(-5)
            make.width.height.equalTo(14)
        }
        playnumLbl.snp.makeConstraints { (make) in
            make.left.equalTo(playImgV.snp_right).offset(5)
            make.bottom.equalTo(playImgV)
            make.right.equalTo(-15)
            make.height.equalTo(14)
        }
    }
    
    // MARK: - Setter
    var listModel:YXSSynClassListModel?
    func setModel(model:YXSSynClassListModel) {
        listModel = model
        var iconImageStr = ""
        if model.subject == .CHINESE {
            iconImageStr = "yxs_synclass_chinese_Icon"
        } else if model.subject == .MATHEMATICS {
            iconImageStr = "yxs_synclass_math_Icon"
        } else if model.subject == .FOREIGN_LANGUAGES {
            iconImageStr = "yxs_synclass_english_Icon"
        }
        
        iconImgV.sd_setImage(with: URL(string: model.coverUrl ?? ""), placeholderImage: UIImage.init(named: iconImageStr))
        nameLbl.text = model.folderName
        playnumLbl.text = "播放:\(model.playCount ?? 0)"
    }
    
    // MARK: - getter&setter
    lazy var iconImgV: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        return imgV
    }()
    
    lazy var nameLbl: UILabel = {
        let nameLbl = UILabel()
        nameLbl.text = ""
        nameLbl.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNight898F9A)
        nameLbl.font = UIFont.systemFont(ofSize: 16)
        return nameLbl
    }()
    
    lazy var playImgV: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage.init(named: "yxs_synclass_play")
        return imgV
    }()
    
    lazy var playnumLbl: UILabel = {
        let lbl = UILabel()
        lbl.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNight898F9A)
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.text = "播放：0"
        return lbl
    }()
    
}
