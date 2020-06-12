//
//  YXSScoreAllChildListCell.swift
//  ZGYM
//
//  Created by yihao on 2020/6/3.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight

class YXSScoreAllChildListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        contentView.addSubview(numberImageV)
        contentView.addSubview(numberLbl)
        contentView.addSubview(avatarImageV)
        contentView.addSubview(nameLbl)
        contentView.addSubview(scoreNumLbl)
        numberImageV.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(contentView.snp_centerY).offset(3)
            make.height.equalTo(28)
            make.width.equalTo(20)
        }
        numberLbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(numberImageV.snp_centerX)
            make.centerY.equalTo(contentView.snp_centerY)
//            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        avatarImageV.snp.makeConstraints { (make) in
            make.left.equalTo(numberImageV.snp_right).offset(8)
            make.centerY.equalTo(contentView.snp_centerY)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        nameLbl.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageV.snp_right).offset(12)
            make.top.bottom.equalTo(0)
            make.right.equalTo(scoreNumLbl.snp_left).offset(-15)
        }
        scoreNumLbl.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.top.bottom.equalTo(0)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var index: Int = 0
    var model: YXSScoreChildListModel?
    func setModel(model:YXSScoreChildListModel, index: Int) {
        self.model = model
        self.index = index
        numberLbl.text = String(index)
        if index < 4 {
            numberImageV.isHidden = false
        } else {
            numberImageV.isHidden = true
        }
        avatarImageV.sd_setImage(with: URL(string: model.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
        nameLbl.text = model.childrenName
        scoreNumLbl.text = "\(model.sumScore?.cleanZero ?? "")分"
    }
    
    // MARK: - getter&setter
    lazy var numberLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.mixedTextColor = MixedColor(normal: k575A60Color, night: kNight898F9A)
        lbl.font = UIFont.systemFont(ofSize: 13)
        return lbl
    }()
    
    lazy var numberImageV: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage.init(named: "yxs_score_frontIcon")
        imgV.contentMode = .scaleAspectFit
        return imgV
    }()
    
    lazy var avatarImageV: UIImageView = {
        let imgV = UIImageView()
        imgV.layer.cornerRadius = 20
        imgV.layer.masksToBounds = true
        return imgV
    }()
    
    lazy var nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#222222"), night: kNightFFFFFF)
        lbl.font = UIFont.systemFont(ofSize: 16)
        return lbl
    }()
    
    lazy var scoreNumLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = kBlueColor
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()
}
