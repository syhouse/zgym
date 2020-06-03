//
//  YXSChildContentListCell.swift
//  ZGYM
//
//  Created by yihao on 2020/4/24.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight

class YXSChildContentListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        contentView.addSubview(titleLbl)
        contentView.addSubview(timeLbl)
        contentView.addSubview(coverImgV)
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout(){
        titleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(coverImgV.snp_left).offset(-27)
            make.top.equalTo(20)
        }
        timeLbl.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLbl)
            make.top.equalTo(titleLbl.snp_bottom).offset(20)
            make.height.equalTo(15)
            make.bottom.equalTo(-20)
        }
        coverImgV.snp.makeConstraints { (make) in
            make.top.equalTo(19)
            make.right.equalTo(-15)
            make.width.height.equalTo(86)
        }
    }
    
    func setModel(model:YXSChildContentHomeListModel) {
        coverImgV.sd_setImage(with: URL(string: model.cover ?? ""), placeholderImage: UIImage.init(named: "yxs_synclass_foldercell_default"), options: .refreshCached, completed: nil)
        titleLbl.text = model.title
        timeLbl.text = model.publishTime?.yxs_Date(format: "yyyy-MM-dd HH:mm").toString(format: DateFormatType.custom("MM.dd HH:mm"))
    }
    
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNightFFFFFF)
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    lazy var timeLbl: UILabel = {
        let lbl = UILabel()
        lbl.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lbl.font = UIFont.systemFont(ofSize: 13)
        return lbl
    }()
    
    lazy var coverImgV: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFit
        return imgV
    }()
    
}
