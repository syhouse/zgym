//
//  YXSToolViewHandler.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/19.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import YBImageBrowser

///YB旋转工具
class YXSYBRotationToolViewHandler: YBIBToolViewHandler {
    
    override func yb_containerViewIsReadied() {
        yb_containerView?.addSubview(viewOriginButton)
        let size = yb_containerSize(yb_currentOrientation())
        viewOriginButton.center = CGPoint(x: size.width / 2.0, y: size.height - 80)
        updateViewOriginButtonSize()
    }
    
    override func yb_pageChanged() {
        viewOriginButton.isHidden = true
        let data = yb_currentData()
        if let data = data as? YXSYBRotationData{
            data.imageLoadingSucessBlock = {
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.viewOriginButton.isHidden = false
            }
        }
    }
    
    func updateViewOriginButtonSize() {
        let size = viewOriginButton.intrinsicContentSize
        viewOriginButton.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: size.width + 15, height: size.height))
    }
    
    @objc func clickViewOriginButton(){
        let data = yb_currentData()
        if let data = data as? YBIBImageData{
            let image: UIImage? = self.image(data.originImage)
            data.stopLoading()
            data.clearCache()
            data.image = {return image}
            data.imageURL = nil
            data.imagePHAsset = nil
            data.load()
        }
    }
    
    ///获取旋转后的图片
    func image(_ image: UIImage?) -> UIImage? {
        var rotate: CGFloat = 0.0
        var rect: CGRect
        var translateX: CGFloat = 0
        var translateY: CGFloat = 0
        var scaleX: CGFloat = 1.0
        var scaleY: CGFloat = 1.0
        
        if let image = image{
            rotate = .pi / 2
            rect = CGRect.init(x: 0, y: 0, width: image.size.height, height: image.size.width)
            translateX = 0
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            //做CTM变换
            context?.translateBy(x: 0.0, y: rect.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            context?.rotate(by: rotate)
            context?.translateBy(x: translateX, y: translateY)
            
            context?.scaleBy(x: scaleX, y: scaleY)
            //绘制图片
            context?.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height))
            
            let newPic = UIGraphicsGetImageFromCurrentImageContext()
            return newPic
        }
        return image
    }
    
    // MARK: - getter&setter
    lazy var viewOriginButton: UIButton = {
        let viewOriginButton = UIButton(type: .custom)
        viewOriginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        viewOriginButton.setTitleColor(UIColor.white, for: .normal)
        viewOriginButton.backgroundColor = UIColor.gray.withAlphaComponent(0.75)
        viewOriginButton.layer.cornerRadius = 5.0
        viewOriginButton.setTitle("旋转", for: .normal)
        viewOriginButton.addTarget(self, action: #selector(clickViewOriginButton), for: .touchUpInside)
        viewOriginButton.isHidden = true
        return viewOriginButton
    }()
}

///旋转data
class YXSYBRotationData: YBIBImageData{
    ///图片是否加载完成
    var imageLoadingSucessBlock: (()->())?
    override func yb_classOfCell() -> AnyClass {
        return YXSYBRotationCell.self
    }
}

///旋转自定义cell (为了拿到数据加载完成回调 显示旋转按钮)
class YXSYBRotationCell: YBIBImageCell, YBIBImageDataDelegate{
    // MARK: - private
    func hideAuxiliaryView(){
        self.yb_auxiliaryViewHandler().yb_hideLoading(withContainer: self)
        self.yb_auxiliaryViewHandler().yb_hideToast(withContainer: self)
    }
    
    func contentSizeWithContainerSize(containerSize: CGSize, imageViewFrame: CGRect) -> CGSize{
        return CGSize(width: max(containerSize.width, imageViewFrame.size.width), height: max(containerSize.height, imageViewFrame.size.height))
    }
    
    func updateImageLayout(orientation: UIDeviceOrientation,previousImageSize: CGSize){
        if let data = self.yb_cellData as? YBIBImageData{
            let imageType = self.imageScrollView.imageType
            let imageSize: CGSize = data.originImage.size
            
            let containerSize = self.yb_containerSize(orientation)
            let imageViewFrame = data.layout.yb_imageViewFrame(withContainerSize: containerSize, imageSize: imageSize, orientation: orientation)
            let contentSize = self.contentSizeWithContainerSize(containerSize: containerSize, imageViewFrame: imageViewFrame)
            let maxZoomScale = imageType == .thumb ? 1 : data.layout.yb_maximumZoomScale(withContainerSize: containerSize, imageSize: imageSize, orientation: orientation)
            self.imageScrollView.zoomScale = 1
            self.imageScrollView.contentSize = contentSize
            self.imageScrollView.minimumZoomScale = 1
            self.imageScrollView.maximumZoomScale = maxZoomScale
            var scale: CGFloat = 0.0
            if previousImageSize.width > 0 && previousImageSize.height > 0{
                scale = imageSize.width / imageSize.height - previousImageSize.width / previousImageSize.height;
            }
            if abs(scale) <= 0.001{
                self.imageScrollView.imageView.frame = imageViewFrame
            }else{
                UIView.animate(withDuration: 0.25) {
                    self.imageScrollView.imageView.frame = imageViewFrame
                }
            }
        }
        
    }
    
    // MARK: - YBIBImageDataDelegate
    func yb_imageData(_ data: YBIBImageData, startLoadingWith status: YBIBImageLoadingStatus) {
        switch status {
        case .decoding:
            if self.imageScrollView.imageView.image == nil{
                self.yb_auxiliaryViewHandler().yb_showLoading(withContainer: self)
            }
        case .processing:
            if self.imageScrollView.imageView.image == nil{
                self.yb_auxiliaryViewHandler().yb_showLoading(withContainer: self)
            }
        case .compressing:
            if self.imageScrollView.imageView.image == nil{
                self.yb_auxiliaryViewHandler().yb_showLoading(withContainer: self)
            }
        case .readingPHAsset:
            if self.imageScrollView.imageView.image == nil{
                self.yb_auxiliaryViewHandler().yb_showLoading(withContainer: self)
            }
        case .none:
            self.hideAuxiliaryView()
        default:
            break
        }
    }
    
    func yb_imageData(_ data: YBIBImageData, readyFor image: UIImage) {
        self.yb_auxiliaryViewHandler().yb_hideLoading(withContainer: self)
        if let data = data as? YXSYBRotationData{
            data.imageLoadingSucessBlock?()
        }
        
        
        if self.imageScrollView.imageView.image == image {
            return
        }
        
        let size = image.size
        self.imageScrollView.setImage(image, type: .original)
        self.updateImageLayout(orientation: self.yb_currentOrientation(), previousImageSize: size)
    }
    
    
    func yb_imageData(_ data: YBIBImageData, readyForThumbImage image: UIImage) {
        
    }
    
    func yb_imageData(_ data: YBIBImageData, readyForCompressedImage image: UIImage) {
        
    }
    
    func yb_imageData(_ data: YBIBImageData, downloadProgress progress: CGFloat) {
        self.yb_auxiliaryViewHandler().yb_showLoading(withContainer: self, progress: progress)
    }
    
    func yb_imageIsInvalid(for data: YBIBImageData) {
        self.yb_auxiliaryViewHandler().yb_hideLoading(withContainer: self)
        let imageIsInvalid = YBIBCopywriter.shared().imageIsInvalid
        
        if self.imageScrollView.imageView.image != nil{
            self.yb_auxiliaryViewHandler().yb_showIncorrectToast(withContainer: self, text: imageIsInvalid)
        } else {
            self.yb_auxiliaryViewHandler().yb_showLoading(withContainer: self, text: imageIsInvalid)
        }
    }
    
    func yb_imageDownloadFailed(for data: YBIBImageData) {
        if self.imageScrollView.imageView.image != nil{
            self.yb_auxiliaryViewHandler().yb_hideLoading(withContainer: self)
            self.yb_auxiliaryViewHandler().yb_showIncorrectToast(withContainer: self, text: YBIBCopywriter.shared().downloadFailed)
        } else {
            self.yb_auxiliaryViewHandler().yb_showLoading(withContainer: self, text: YBIBCopywriter.shared().downloadFailed)
        }
    }
}
