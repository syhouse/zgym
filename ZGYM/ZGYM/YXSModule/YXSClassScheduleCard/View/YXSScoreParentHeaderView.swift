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
            make.height.equalTo(175)
        }
        contentView.addSubview(headerChildNameLbl)
        contentView.addSubview(headerExmTimeLbl)
        contentView.addSubview(formTable)
//        formTable.frame = CGRect(x: 15, y: 90, width: SCREEN_WIDTH - 60, height: 70)
        headerChildNameLbl.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(40)
            make.height.equalTo(20)
        }
        headerExmTimeLbl.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(headerChildNameLbl.snp_bottom).offset(4)
            make.height.equalTo(20)
        }
        formTable.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(headerExmTimeLbl.snp_bottom).offset(5)
            make.bottom.equalTo(contentView.snp_bottom).offset(-15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model: YXSScoreDetailsModel) {
        self.detailsModel = model
        avatarImageV.sd_setImage(with: URL(string: model.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
        headerChildNameLbl.text = model.childrenName
        if let dateStr = model.creationTime, dateStr.count > 0 {
            headerExmTimeLbl.text =  "考试时间：\(dateStr.yxs_Date().toString(format: .custom("yyyy/MM/dd")))"
        }
        formTable.wzb_drawList(with: formTable.bounds, line: 2, columns: 2, datas: ["语文","总分","98","98"])
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
    
    lazy var formTable: UIView = {
        let view = UIView()
        return view
    }()
    
    /// 孩子名称
    lazy var headerChildNameLbl: UILabel = {
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
