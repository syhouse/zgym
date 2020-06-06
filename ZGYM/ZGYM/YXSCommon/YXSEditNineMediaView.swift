//
//  YXSEditNineMediaView.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/4.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import NightNight

private let kMaxImageCount = 9
class YXSEditNineMediaView: UIView{
    var updateMeida: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for index in 0 ..< kMaxImageCount{
            let imageView = YXSFriendDragItem(frame: CGRect.zero)
            imageView.tag = kImageOrginTag + index
            imageView.addTaget(target: self, selctor: #selector(imageClick))
            imageView.isHidden = true
            imageView.itemRemoveBlock = {
                [weak self] (model)in
                guard let strongSelf = self else { return }
                if let model = model as? SLPublishEditMediaModel{
                    
                    
                    strongSelf.medias?.remove(at:  strongSelf.medias?.firstIndex(of: model) ?? 0)
                    
                    var needAppendAdd = true
                    for media in strongSelf.medias ?? [SLPublishEditMediaModel](){
                        if media.isAddItem{
                            needAppendAdd = false
                            break
                        }
                    }
                    if needAppendAdd{
                        strongSelf.medias?.append(SLPublishEditMediaModel(isAddItem: true))
                    }
                    strongSelf.updateMeida?()
                }
            }
            addSubview(imageView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var edges: UIEdgeInsets = UIEdgeInsets.zero
    public var padding: CGFloat = 5
    

    public var medias: [SLPublishEditMediaModel]?{
        didSet{
            updateUI()
            
        }
    }
    
    
    
    @objc func imageClick(_ tap: UITapGestureRecognizer){
        let index = (tap.view?.tag ?? kImageOrginTag) - kImageOrginTag
        
        
        
        if let medias = medias{
            let curruntMedia = medias[index]
            if curruntMedia.isAddItem{
                ///选择资源
                YXSSelectMediaHelper.shareHelper.pushImagePickerController(mediaStyle: .onlyImage,maxCount: 9 - (medias.count - 1) )
                YXSSelectMediaHelper.shareHelper.delegate = self
                return
            }
            
            var urls = [URL]()
            var assets = [PHAsset]()
            
            for model in medias{
                if let serviceUrl = model.serviceUrl{
                    urls.append(URL.init(string: serviceUrl)!)
                }else{
                    if let asset = model.asset{
                        assets.append(asset)
                    }
                }
            }
            YXSShowBrowserHelper.showImage(urls: urls, assets: assets, currentIndex: index)
        }
    }
    
    private func addEditMedia(assets: [YXSMediaModel]){
        let addItem = SLPublishEditMediaModel(isAddItem: true)
        medias?.removeLast()
        for asset in assets{
            let editMedia = SLPublishEditMediaModel(isAddItem: false)
            editMedia.asset = asset.asset
            medias?.append(editMedia)
        }
        
        if (medias?.count ?? 0 ) < 9{
            medias?.append(addItem)
        }
        
        
        self.updateUI()
        
        updateMeida?()
    }
    
    func updateUI(){
        for index in 0 ..< kMaxImageCount{
            let imageView = viewWithTag(kImageOrginTag + index)!
            imageView.isHidden = true
            imageView.cornerRadius = 2.5
            imageView.snp.removeConstraints()
        }
        
        let rowCount: Int = 3
        
        if self.width == 0{
            assert(false, "视图宽度为空")
        }
        
        let imageWidth = (self.width - edges.left - edges.right  - CGFloat(rowCount - 1)*padding)/CGFloat(rowCount)
        let imageHeight = imageWidth
        if let imgs = medias{
            var lastView: UIView?
            for index in 0..<imgs.count{
                let model = imgs[index]
                let imageView = viewWithTag(kImageOrginTag + index) as! YXSFriendDragItem
                imageView.isHidden = false
                if model.isAddItem {
                    imageView.isAdd = true
                }else{
                    imageView.model = model
                }
                
                let row = index % rowCount
                
                imageView.snp.remakeConstraints { (make) in
                    if index == 0{
                        make.top.equalTo(0).priorityHigh()
                    }else if row == 0{
                        make.top.equalTo(lastView!.snp_bottom).offset(5)
                    }else{
                         make.top.equalTo(lastView!)
                    }
                    if index == imgs.count - 1{
                        make.bottom.equalTo(0).priorityHigh()
                    }
                    
                    if row == 0{
                        make.left.equalTo(edges.left)
                    }else{
                        make.left.equalTo(lastView!.snp_right).offset(5)
                    }
                    
                    make.size.equalTo(CGSize.init(width: imageWidth, height: imageHeight))
                }
                lastView = imageView
            }
        }
    }
}



// MARK: - YXSSelectMediaHelperDelegate
extension YXSEditNineMediaView: YXSSelectMediaHelperDelegate{
    
    func didSelectMedia(asset: YXSMediaModel) {
        addEditMedia(assets: [asset])
    }
    
    func didSelectSourceAssets(assets: [YXSMediaModel]) {
        addEditMedia(assets: assets)
    }
}
