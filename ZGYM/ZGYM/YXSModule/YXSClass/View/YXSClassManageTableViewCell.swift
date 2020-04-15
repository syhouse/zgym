//
//  SLClassManageTableViewCell.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/21.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSBaseClassManageTableViewCell: YXSBaseTableViewCell {//UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.lbTitle)
        self.contentView.addSubview(self.imgRightArrow)
        
        self.lbTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(15)
        })
        
        self.imgRightArrow.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.right.equalTo(-15)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LazyLoad
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNight898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbSubTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var imgRightArrow: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "yxs_class_arrow")
        return img
    }()
    
    lazy var swtJoinClass: UISwitch = {
        let swt = UISwitch(frame: CGRect(x: 0, y: 0, width: 43, height: 22))
        swt.onTintColor = kRedMainColor
        
        return swt
    }()
}

class YXSClassManageTableViewCell: YXSBaseClassManageTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        self.contentView.addLine(position: LinePosition.bottom, color: UIColor.gray, leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YXSClassManageSwitchTableViewCell: YXSBaseClassManageTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.imgRightArrow.isHidden = true
        
        self.contentView.addSubview(self.swtJoinClass)
        self.swtJoinClass.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.right.equalTo(self.imgRightArrow.snp_right).offset(-15)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ClassManageSubTitleTableViewCell: YXSBaseClassManageTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.lbTitle.contentCompressionResistancePriority(for: NSLayoutConstraint.Axis.horizontal)
        self.lbTitle.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
        
        self.contentView.addSubview(self.lbSubTitle)
        self.lbSubTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(self.lbTitle.snp_right).offset(13)
            make.right.equalTo(self.imgRightArrow.snp_right).offset(-13)
        })
        self.lbSubTitle.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
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

}
