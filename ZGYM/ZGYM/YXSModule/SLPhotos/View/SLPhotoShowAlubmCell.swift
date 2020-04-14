//
//  SLPhotoShowAlubmCell.swift
//  HNYMEducation
//
//  Created by sy_mac on 2020/3/12.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit

class SLPhotoShowAlubmCell: UICollectionViewCell {
    var isEdit: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(playerButton)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        playerButton.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
    }
    
    var model: SLPhotoAlbumsDetailListModel!
    func setCellModel(_ model: SLPhotoAlbumsDetailListModel){
        self.model = model
        playerButton.isHidden = model.resourceType == 1 ? false : true
        if model.resourceType == 1{
            imageView.sd_setImage(with: URL.init(string: model.bgUrl ?? ""), placeholderImage: UIImage.init(named: "yxs_photo_nocover"))
        }else{
            imageView.sd_setImage(with: URL.init(string: model.resourceUrl ?? ""), placeholderImage: UIImage.init(named: "yxs_photo_nocover"))
        }
    }
    
    @objc func playerClick(){
        UIUtil.pushOpenVideo(url: model.resourceUrl ?? "")
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var playerButton: YXSButton = {
        let btn = YXSButton()
        btn.addTarget(self, action: #selector(playerClick), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(named: "yxs_publish_play"), for: .normal)
        btn.isHidden = true
        return btn
    }()
}
