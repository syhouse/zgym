//
//  YXSFriendDragItem.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/16.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import Photos
import NightNight

class YXSFriendDragItem: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        
        addSubview(playerView)
        addSubview(closeButton)
        addSubview(addImageView)
        closeButton.addSubview(closeIcon)
        
        playerView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 55, height: 55))
        }
        
        addImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 28, height: 28))
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.right.top.equalTo(0)
            make.size.equalTo(CGSize.init(width: 26.5, height: 25))
        }
        closeIcon.snp.makeConstraints { (make) in
            make.top.equalTo(5.5)
            make.right.equalTo(-4)
            make.size.equalTo(CGSize.init(width: 12.2, height: 12.15))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 本地服务器item混合展示
    var model: SLPublishMediaModel? = nil{
        didSet{
            if let model = model{
                if model.isService{
                    if let bgUrl = model.showImageUrl{
                        self.sd_setImage(with: URL.init(string: bgUrl),placeholderImage: kImageDefualtImage)
                        
                    }else{
                        self.sd_setImage(with: URL.init(string: model.serviceUrl ?? ""),placeholderImage: kImageDefualtImage)
                    }
                }else{
                    if let thumbnailImage = model.thumbnailImage{
                        image = thumbnailImage
                    }else{
                        UIUtil.PHAssetToImage(model.asset){
                            (result) in
                            let newSize = result.yxs_scaleImage(image: result, imageLength: 300)
                            self.image = result.yxs_resizeImage(image: result, newSize: newSize)
                        }
                    }
                }
                if  model.type == PHAssetMediaType.video{
                    playerView.isHidden = false
                }
                closeButton.isHidden = false
            }else{
                closeButton.isHidden = true
            }
            
        }
    }
    
    var isAdd: Bool = false {
        didSet{
            if isAdd{
                closeButton.isHidden = true
                self.mixedImage = MixedImage(normal: "yxs_publish_add", night: "yxs_publish_add_night")

            }else{
                closeButton.isHidden = false
            }
        }
    }
    
    var itemRemoveBlock: ((_ model: SLPublishMediaModel) -> ())?
    
    @objc func closeClick(){
        itemRemoveBlock?(model!)
    }
    
    lazy var closeButton: YXSButton = {
        let button = YXSButton.init()

        button.setBackgroundImage(UIImage.init(named: "yxs_publish_close_bg"), for: .normal)
        button.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var playerView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_publish_play"))
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var addImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.mixedImage = MixedImage(normal: "yxs_publish_add", night: "yxs_publish_add_night")
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var closeIcon: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_publish_close"))
        return imageView
    }()
}
