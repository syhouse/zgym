//
//  YXSSynClassFolderCell.swift
//  ZGYM
//
//  Created by yihao on 2020/4/21.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight

class YXSSynClassFolderCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImgV)
        contentView.addSubview(contentLbl)
        iconImgV.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.width.equalTo(122)
            make.height.equalTo(68)
        }
        contentLbl.snp.makeConstraints { (make) in
            make.left.equalTo(iconImgV.snp_right).offset(19)
            make.top.bottom.equalTo(iconImgV)
            make.right.equalTo(-15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Setter
    var folderModel:YXSSynClassFolderModel?
    func setModel(model:YXSSynClassFolderModel) {
        folderModel = model
        iconImgV.sd_setImage(with: URL(string: model.coverUrl ?? ""), placeholderImage: UIImage.init(named: "yxs_synclass_foldercell_default"))
        contentLbl.text = model.resourceName
    }
    
    // MARK: - getter&setter
    lazy var iconImgV: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.layer.cornerRadius = 2.5
        imgV.layer.masksToBounds = true
        return imgV
    }()
    
    lazy var contentLbl: UILabel = {
        let contentLbl = UILabel()
        contentLbl.text = ""
        contentLbl.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNight898F9A)
        contentLbl.font = UIFont.systemFont(ofSize: 16)
        contentLbl.numberOfLines = 0
        return contentLbl
    }()
    
}
