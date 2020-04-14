//
//  YXSTransferClassTableViewCell.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/22.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSTransferClassTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        
        self.contentView.addSubview(self.lbTitle)
        self.contentView.addSubview(self.btnChose)
        
        self.lbTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(15)
        })
        
        self.btnChose.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.right.equalTo(-15)
            make.width.height.equalTo(17)
        })
        
        self.contentView.yxs_addLine(position: LinePosition.bottom, color: UIColor.gray, leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
    }
    
    var model: YXSTransferItemModel? {
        didSet {
            self.lbTitle.text = self.model?.name
            self.btnChose.isSelected = self.model?.isSelected ?? false
        }
    }
    
    // MARK: - Action
    @objc func choseClick(sender: YXSButton) {
        sender.isSelected = !sender.isSelected
    }
    
    // MARK: - LazyLoad
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNight898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var btnChose: YXSButton = {
        let btn = YXSButton()
        btn.isUserInteractionEnabled = false
        btn.setImage(UIImage(named: "yxs_chose_normal"), for: .normal)
        btn.setImage(UIImage(named: "yxs_chose_selected"), for: .selected)
        btn.addTarget(self, action: #selector(choseClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
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

}
