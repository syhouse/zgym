//
//  YXSPhotoAlbumsListCell.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/2.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
/// 相册封面
class YXSPhotoAlbumsListCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(createLabel)
        contentView.addSubview(redView)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        imageView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.width.height.equalTo((SCREEN_WIDTH - CGFloat(15*2) - CGFloat(2*6))/3)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp_bottom).offset(12)
            make.left.right.equalTo(imageView)
        }
        countLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(9)
            make.left.right.equalTo(imageView)
        }
        createLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(imageView.snp_bottom).offset(-24.5)
            make.centerX.equalTo(imageView)
        }
        redView.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.top.equalTo(0)
            make.size.equalTo(CGSize.init(width: 26, height: 29))
        }
    }
    
    func setCellModel(_ model: YXSPhotoAlbumsModel){
        createLabel.isHidden = true
        
        titleLabel.isHidden = true
        countLabel.isHidden = true
        
        if model.id == nil {
            /// 新建相册
            redView.isHidden = true
        } else {
            redView.isHidden = false
        }
        
        if model.isSystemCreateItem{
            imageView.image = UIImage.init(named: "yxs_photo_new_ablum")
            createLabel.isHidden = false
        }else{
            
            imageView.sd_setImage(with: URL.init(string: model.coverUrl ?? ""), placeholderImage: UIImage.init(named: "yxs_photo_nocover"))
            titleLabel.isHidden = false
            countLabel.isHidden = false
            titleLabel.text = model.albumName
            countLabel.text = "\(model.resourceCount ?? 0)张"
        }
    }
    
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var redView: UIImageView = {
        let redView = UIImageView()
        redView.image = UIImage.init(named: "home_new_read")
        return redView
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = kTextBlackColor
        return view
    }()
    
       lazy var countLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return view
    }()
    
    lazy var createLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#B2B9C6")
        view.text = "新建相册"
        return view
    }()
}
