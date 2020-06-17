//
//  YXSScoreLevelTeacherListCell.swift
//  ZGYM
//
//  Created by yihao on 2020/6/9.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation

class YXSScoreLevelTeacherListCell: UITableViewCell {
    override var frame: CGRect{
        didSet{
            var newFrame = frame
            newFrame.origin.x = 15
            newFrame.size.width = frame.width - 30
            super.frame = newFrame
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        contentView.backgroundColor = UIColor.white
        contentView.layer.masksToBounds = true  
        contentView.clipsToBounds = true
        contentView.addSubview(avatarImgV)
        contentView.addSubview(nameLbl)
        contentView.addSubview(rankLbl)
        avatarImgV.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.width.height.equalTo(40)
        }
        nameLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(avatarImgV.snp_centerY)
            make.left.equalTo(avatarImgV.snp_right).offset(15)
            make.right.equalTo(rankLbl.snp.left).offset(-5)
            make.height.equalTo(30)
        }
        rankLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(avatarImgV.snp_centerY)
            make.right.equalTo(-5)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
        self.yxs_addLine(position: .bottom, color: kLineColor, leftMargin: 15, rightMargin: 15, lineHeight: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: YXSScoreChildListModel?
    func setModel(model:YXSScoreChildListModel, isNeedCorners: Bool = false) {
        self.model = model
        avatarImgV.sd_setImage(with: URL(string: model.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
        nameLbl.text = model.childrenName
        rankLbl.text = model.rank
        if isNeedCorners {
//            contentView.yxs_addRoundedCorners(corners: [.bottomLeft,.bottomRight], radii: CGSize.init(width: 5, height: 5))
            self.yxs_addRoundedCorners(corners: [.bottomRight,.bottomLeft], radii: CGSize.init(width: 5, height: 5), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 15 - 15, height:60))
        } else {
            self.yxs_removeRoundedCorners()
        }
        
    }
    
    lazy var avatarImgV: UIImageView = {
        let imgV = UIImageView()
        imgV.layer.cornerRadius = 20
        imgV.layer.masksToBounds = true
        imgV.contentMode = .scaleAspectFit
        return imgV
    }()
    
    lazy var nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#212121")
        lbl.font = UIFont.systemFont(ofSize: 16)
        return lbl
    }()
    
    lazy var rankLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .right
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#5D87F7")
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()
}
