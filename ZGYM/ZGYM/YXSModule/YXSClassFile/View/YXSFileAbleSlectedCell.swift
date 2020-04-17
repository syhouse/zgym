//
//  YXSFileAbleSlectedCell.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/1.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

/// 从书包选择的Cell
class YXSFileAbleSlectedCell: YXSBaseFileCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(btnSelect)
        
        contentView.addSubview(titlesContainer)
        titlesContainer.addSubview(lbTitle)
        titlesContainer.addSubview(lbSubTitle)
        
        contentView.addSubview(lbThirdTitle)
        contentView.addSubview(iconBgView)
        iconBgView.addSubview(imgIcon)
        
        layout()
    }
    
    @objc func layout() {
        btnSelect.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp_centerY)
            make.left.equalTo(15)
            make.width.height.equalTo(17)
        })
        
        iconBgView.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.left.equalTo(btnSelect.snp_right).offset(17)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(40)
        })
        
        imgIcon.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        
        titlesContainer.snp.makeConstraints({ (make) in
            make.left.equalTo(iconBgView.snp_right).offset(19)
            make.centerY.equalTo(contentView.snp_centerY)
            make.right.equalTo(-17)
        })
        
        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        })
        
        lbSubTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle.snp_bottom).offset(8)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        })
        
        lbThirdTitle.snp.makeConstraints({ (make) in
            make.right.equalTo(-17)
            make.bottom.equalTo(titlesContainer.snp_bottom)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Action
    @objc func cellSelectClick(sender: YXSButton) {
        sender.isSelected = !sender.isSelected
    }
    
    // MARK: - LazyLoad
    lazy var lbSubTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    lazy var lbThirdTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    lazy var titlesContainer: UIView = {
        let view = UIView()
        return view
    }()
    
//    lazy var btnSelect: YXSButton = {
//        let btn = YXSButton()
//        btn.setImage(UIImage(named: "yxs_photo_edit_unselect"), for: .normal)
//        btn.setImage(UIImage(named: "yxs_photo_edit_select"), for: .selected)
//        btn.addTarget(self, action: #selector(cellSelectClick(sender:)), for: .touchUpInside)
//        return btn
//    }()

}
