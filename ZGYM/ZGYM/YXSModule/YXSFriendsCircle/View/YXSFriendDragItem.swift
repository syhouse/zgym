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

class YXSFriendDragItem: YXSSinglImage {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(closeButton)
        closeButton.addSubview(closeIcon)
    
        closeButton.snp.makeConstraints { (make) in
            make.right.top.equalTo(0)
            make.size.equalTo(CGSize.init(width: 26.5, height: 25))
        }
        closeIcon.snp.makeConstraints { (make) in
            make.top.equalTo(5.5)
            make.right.equalTo(-4)
            make.size.equalTo(CGSize.init(width: 12.2, height: 12.15))
        }
        
        closeButtonView = closeButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var closeButton: YXSButton = {
        let button = YXSButton.init()
        button.setBackgroundImage(UIImage.init(named: "yxs_publish_close_bg"), for: .normal)
        button.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    private lazy var closeIcon: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_publish_close"))
        return imageView
    }()
}

class YXSQuestionItem: YXSSinglImage {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(closeButton)
    
        closeButton.snp.makeConstraints { (make) in
            make.right.top.equalTo(0)
            make.size.equalTo(CGSize.init(width: 19, height: 19))
        }
        
        closeButtonView = closeButton
        
        defultImage = UIImage(named: "yxs_solitaire_question_defult")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var closeButton: YXSButton = {
        let button = YXSButton.init()
        button.setBackgroundImage(UIImage.init(named: "yxs_solitaire_image_delect"), for: .normal)
        button.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        button.isHidden = true
        button.yxs_touchInsets = UIEdgeInsets(top: 5, left: 3, bottom: 3, right: 5)
        return button
    }()
}



class YXSSinglImage: UIImageView {
    ///默认图片
    public var defultImage: UIImage? = kImageDefualtImage{
        didSet{
            self.image = defultImage
        }
    }
    
    public var closeButtonView: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        
        addSubview(playerView)
        addSubview(addImageView)
        
        playerView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 55, height: 55))
        }
        
        addImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 28, height: 28))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 本地服务器item混合展示
    public var model: SLPublishMediaModel? = nil{
        didSet{
            if let model = model{
                if model.isService{
                    self.sd_setImage(with: URL.init(string: model.serviceUrl ?? ""),placeholderImage: defultImage)
                }else{
                    self.image = defultImage
                    model.getThumbnailImage { [weak self](thumbnailImage) in
                        guard let strongSelf = self else { return }
                        strongSelf.image = thumbnailImage
                    }
                    
                }
                if  model.type == PHAssetMediaType.video{
                    playerView.isHidden = false
                }
                closeButtonView?.isHidden = false
            }else{
                closeButtonView?.isHidden = true
            }
            
        }
    }
    
    public var isAdd: Bool = false {
        didSet{
            if isAdd{
                closeButtonView?.isHidden = true
                self.mixedImage = MixedImage(normal: "yxs_publish_add", night: "yxs_publish_add_night")

            }else{
                closeButtonView?.isHidden = false
            }
        }
    }
    
    public var itemRemoveBlock: ((_ model: SLPublishMediaModel) -> ())?
    
    @objc func closeClick(){
        closeButtonView?.isHidden = true
        itemRemoveBlock?(model!)
    }
        
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
}
