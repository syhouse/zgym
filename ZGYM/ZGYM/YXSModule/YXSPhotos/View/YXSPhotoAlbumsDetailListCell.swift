//
//  YXSPhotoAlbumsDetailListCell.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/7.
//  Copyright © 2020 hmym. All rights reserved.
//


import UIKit

/// 相片/视频 Cell
class YXSPhotoAlbumsDetailListCell: UICollectionViewCell {
    var isEdit: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(btnSelect)
        contentView.addSubview(playerImageView)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        btnSelect.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 17, height: 17))
            make.right.equalTo(-6.5)
            make.top.equalTo(7.5)
        }
        playerImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 23, height: 23))
            make.left.equalTo(12.5)
            make.bottom.equalTo(-6)
        }
    }
    
    func setCellModel(_ model: YXSPhotoAlbumsDetailListModel){
        btnSelect.isHidden = !isEdit
        btnSelect.isSelected = model.isSelected
        playerImageView.isHidden = true
        if model.resourceType == 1{
            imageView.sd_setImage(with: URL.init(string: (model.bgUrl ?? "").yxs_getImageThumbnail()), placeholderImage: UIImage.init(named: "yxs_photo_nocover"))
            playerImageView.isHidden = false
        }else{
            imageView.sd_setImage(with: URL.init(string: (model.resourceUrl ?? "").yxs_getImageThumbnail()), placeholderImage: UIImage.init(named: "yxs_photo_nocover"))
        }
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var btnSelect: YXSButton = {
        let btn = YXSButton()
        btn.setBackgroundImage(UIImage(named: "yxs_cell_unselect"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "yxs_cell_select"), for: .selected)
        return btn
    }()
    
    
    lazy var playerImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "yxs_photo_play"))
        return view
    }()
    
}
