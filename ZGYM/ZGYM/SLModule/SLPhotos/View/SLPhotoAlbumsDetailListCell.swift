//
//  SLPhotoAlbumsDetailListCell.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/7.
//  Copyright © 2020 hmym. All rights reserved.
//


import UIKit

class SLPhotoAlbumsDetailListCell: UICollectionViewCell {
    var isEdit: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(btnSelect)
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
    }
    
    func setCellModel(_ model: SLPhotoAlbumsDetailListModel){
        btnSelect.isHidden = !isEdit
        btnSelect.isSelected = model.isSelected
        if model.resourceType == 1{
            imageView.sd_setImage(with: URL.init(string: (model.bgUrl ?? "").sl_getImageThumbnail()), placeholderImage: UIImage.init(named: "sl_photo_nocover"))
        }else{
            imageView.sd_setImage(with: URL.init(string: (model.resourceUrl ?? "").sl_getImageThumbnail()), placeholderImage: UIImage.init(named: "sl_photo_nocover"))
        }
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var btnSelect: SLButton = {
        let btn = SLButton()
        btn.setBackgroundImage(UIImage(named: "sl_cell_unselect"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "sl_cell_select"), for: .selected)
        return btn
    }()
}
