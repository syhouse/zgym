//
//  YXSSelectAccessoryCell.swift
//  ZGYM
//
//  Created by yihao on 2020/4/27.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight

class YXSSelectAccessoryCell: YXSBaseTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.yxs_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor))
        
//        insertSubview(btnSelect, belowSubview: contentView)
//        btnSelect.snp.makeConstraints({ (make) in
//            make.top.equalTo(0)
//            make.left.equalTo(0)
//            make.bottom.equalTo(0)
//            make.width.equalTo(self.snp_height)
//        })
        contentView.addSubview(btnSelect)
        contentView.addSubview(imgIcon)
        contentView.addSubview(lbTitle)
        contentView.addSubview(lbSubTitle)
        contentView.addSubview(lbTime)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        btnSelect.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.snp_height)
        }
        imgIcon.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.width.height.equalTo(40)
            make.left.equalTo(btnSelect.snp_right)
        }
        lbTitle.snp.makeConstraints { (make) in
            make
        }
        
    }
    
    // MARK: - LazyLoad
    lazy var imgIcon: UIImageView = {
        let img = UIImageView()
        return img
    }()
        
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: k131313Color, night: kNightFFFFFF)
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    lazy var lbSubTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    lazy var lbTime: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    lazy var btnSelect: YXSButton = {
        let btn = YXSButton()
        btn.isUserInteractionEnabled = false
        btn.setImage(UIImage(named: "yxs_photo_edit_unselect"), for: .normal)
        btn.setImage(UIImage(named: "yxs_photo_edit_select"), for: .selected)
        return btn
    }()
}
