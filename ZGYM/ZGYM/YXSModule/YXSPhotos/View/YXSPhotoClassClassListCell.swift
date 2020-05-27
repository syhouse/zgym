//
//  YXSPhotoClassListController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/2/27.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper

import MBProgressHUD

/// 班级相册班级Cell
class YXSPhotoClassClassListCell: SLClassBaseListCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        bgView.addSubview(photoCountButton)
        photoCountButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.right.equalTo(-44)
            make.size.equalTo(CGSize.init(width: 65, height: 20))
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var model: YXSPhotoClassListCellModel? {
        didSet {
            nameLabel.text = self.model?.className//self.model.name
            numberLabel.text = "班级号：\(self.model?.classNo ?? "")"
            memberLabel.text = "成员：\(self.model?.classChildrenSum ?? 0)"
            if self.model?.albumCount ?? 0 > 0 {
                photoCountButton.isEnabled = true
                photoCountButton.setTitle("\(self.model?.albumCount ?? 0)个相册", for: .normal)
                
            } else {
                photoCountButton.isEnabled = false
                photoCountButton.setTitle("暂无相册", for: .disabled)
            }
        }
    }
    
//    var model:YXSClassModel!
//    func yxs_setCellModel(_ model: YXSClassModel){
//        self.model = model
//        nameLabel.text = model.name
//        numberLabel.text = "班级号：\(model.num ?? "")"
//        memberLabel.text = "成员：\(model.members ?? 0)"
//
////        button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), for: .disabled)
//    }
    
    lazy var photoCountButton: UIButton = {
        let button = UIButton.init()
        button.setMixedTitleColor(MixedColor(normal: kNight5E88F7, night: kNight5E88F7), forState: .normal)
        button.setMixedTitleColor(MixedColor(normal: kNight898F9A, night: kNight898F9A), forState: .disabled)
        button.setTitle("暂无相册", for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setBackgroundImage(UIImage.yxs_image(with: UIColor.yxs_hexToAdecimalColor(hex: "#E1EBFE")), for: .normal)
        button.setBackgroundImage(UIImage.yxs_image(with: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0")), for: .disabled)
        button.cornerRadius = 10.0
        button.isUserInteractionEnabled = false
        button.isEnabled = false
        return button
    }()
    
}
