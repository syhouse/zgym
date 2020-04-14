//
//  YXSPOITableViewCell.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/16.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

class YXSPOITableViewCell: YXSBaseTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        contentView.addSubview(lbTitle)
        contentView.addSubview(lbSubTitle)
        contentView.addSubview(imgMark)
        
        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView.snp_top).offset(20);
            make.left.equalTo(contentView.snp_left).offset(15);
            make.right.equalTo(imgMark.snp_left);
        })
        
        lbSubTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle.snp_bottom).offset(10)
            make.left.equalTo(lbTitle.snp_left)
            make.right.equalTo(lbTitle.snp_right)
        })

        imgMark.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp_centerY)
            make.right.equalTo(contentView.snp_right).offset(-10)
            make.width.height.equalTo(20)
        })
        
        contentView.yxs_addLine(position: .bottom, color: kLineColor, leftMargin: 15, rightMargin: 0, lineHeight: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: AMapPOI? {
        didSet {
            lbTitle.text = self.model?.name
            lbSubTitle.text = "\(self.model?.province ?? "")\(self.model?.city ?? "")\(self.model?.district ?? "")\(self.model?.address ?? "")"
        }
    }
    
    
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbSubTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    lazy var imgMark: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.image = UIImage(named: "yxs_chose_selected")
        return view
    }()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
