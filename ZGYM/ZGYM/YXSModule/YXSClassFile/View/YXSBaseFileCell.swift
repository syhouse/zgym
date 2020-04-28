//
//  YXSBaseFileCell.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/1.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

class YXSBaseFileCell: YXSBaseTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.yxs_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor))
        
//        contentView.addSubview(panelView)
//        panelView.snp.makeConstraints({ (make) in
//            make.edges.equalTo(0)
//        })
        
        insertSubview(btnSelect, belowSubview: contentView)
        btnSelect.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.snp_height)
        })
    }
    
    override func layoutSubviews() {
        btnSelect.isSelected = self.model?.isSelected ?? false
        
        if self.model?.isEditing == true {
            self.contentView.snp.remakeConstraints({ (make) in
                make.top.equalTo(0)
                make.left.equalTo(50)
                make.right.equalTo(0)
                make.bottom.equalTo(0)
            })

        } else {
            self.contentView.snp.remakeConstraints({ (make) in
                make.top.equalTo(0)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(0)
            })
        }
    }
    
    var model: YXSBaseFileModel? {
        didSet {
            
        }
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

    // MARK: - LazyLoad
//    lazy var panelView: UIView = {
//        let view = UIView()
//        return view
//    }()
    
    lazy var iconBgView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#FAC068")
        return view
    }()
    
    lazy var imgIcon: UIImageView = {
        let img = UIImageView()
//        view.backgroundColor = UIColor.hexToAdecimalColor(hex: "#F3F5F9")
        return img
    }()
    
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: k131313Color, night: kNightFFFFFF)
        lb.lineBreakMode = .byTruncatingMiddle
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    lazy var imgRightArrow: UIImageView = {
        let img = UIImageView()
//        view.backgroundColor = UIColor.hexToAdecimalColor(hex: "#F3F5F9")
        return img
    }()
    
    lazy var btnSelect: YXSButton = {
        let btn = YXSButton()
        btn.isUserInteractionEnabled = false
        btn.setImage(UIImage(named: "yxs_photo_edit_unselect"), for: .normal)
        btn.setImage(UIImage(named: "yxs_photo_edit_select"), for: .selected)
//        btn.addTarget(self, action: #selector(cellSelectClick(sender:)), for: .touchUpInside)
        return btn
    }()
}
