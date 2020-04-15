//
//  SLPhotoShowAlbumItemController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/16.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import JXCategoryView

class SLPhotoShowAlbumItemController:YXSBaseViewController, JXCategoryListContentViewDelegate {
    var model: SLPhotoAlbumsDetailListModel{
        didSet{
            playerButton.isHidden = model.resourceType == 1 ? false : true
            if model.resourceType == 1{
                imageView.sd_setImage(with: URL.init(string: model.bgUrl ?? ""), placeholderImage: UIImage.init(named: "yxs_photo_nocover"))
            }else{
                imageView.sd_setImage(with: URL.init(string: model.resourceUrl ?? ""), placeholderImage: UIImage.init(named: "yxs_photo_nocover"))
            }
        }
    }
    init(model: SLPhotoAlbumsDetailListModel) {
        self.model = model
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        self.view.addSubview(imageView)
        self.view.addSubview(playerButton)
        layout()
        
        playerButton.isHidden = model.resourceType == 1 ? false : true
        if model.resourceType == 1{
            imageView.sd_setImage(with: URL.init(string: model.bgUrl ?? ""), placeholderImage: UIImage.init(named: "yxs_photo_nocover"))
        }else{
            imageView.sd_setImage(with: URL.init(string: model.resourceUrl ?? ""), placeholderImage: UIImage.init(named: "yxs_photo_nocover"))
        }
    }
    
    func listView() -> UIView! {
        return self.view
    }
    
    var isEdit: Bool = false
    
    func layout() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        playerButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
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
