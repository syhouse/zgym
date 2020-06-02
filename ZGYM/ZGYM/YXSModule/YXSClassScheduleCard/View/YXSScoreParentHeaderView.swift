//
//  YXSScoreParentHeaderView.swift
//  ZGYM
//
//  Created by yihao on 2020/6/1.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight

class YXSScoreParentHeaderView: UIView {
    
    var detailsModel: YXSScoreDetailsModel?
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        addSubview(contentView)
        addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(10)
            make.size.equalTo(CGSize(width: 80, height: 70))
        }
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(avatarView.snp_top).offset(35)
            make.bottom.equalTo(0)
            make.height.equalTo(250)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model: YXSScoreDetailsModel) {
        self.detailsModel = model
        avatarImageV.sd_setImage(with: URL(string: ""), placeholderImage: kImageUserIconStudentDefualtImage)
    }
    
    lazy var avatarView: UIView = {
        let view = UIView()
        let backgroundImageV = UIImageView()
        backgroundImageV.image = UIImage.init(named: "yxs_score_avatar_bg")
        view.addSubview(backgroundImageV)
        backgroundImageV.contentMode = .scaleAspectFit
        backgroundImageV.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        view.addSubview(avatarImageV)
        avatarImageV.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(7)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        
        return view
    }()
    
    lazy var avatarImageV: UIImageView = {
        let imgV = UIImageView()
        imgV.layer.cornerRadius = 25
        imgV.layer.masksToBounds = true
        imgV.contentMode = .scaleAspectFit
        return imgV
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    /// 孩子名称
    lazy var headerClassNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#222222")
        return lbl
    }()
    /// 考试时间
    lazy var headerExmTimeLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return lbl
    }()
}
