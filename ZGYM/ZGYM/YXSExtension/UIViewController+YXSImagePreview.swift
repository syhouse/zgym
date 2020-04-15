//
//  UIViewController+Preview.swift
//  ZGYM
//
//  Created by mac_hm on 2019/11/11.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func yxs_showPreviewImage() {
        let previewVC: ImagePreviewViewController = ImagePreviewViewController()
        previewVC.modalPresentationStyle = .fullScreen
        self.present(previewVC, animated: true, completion: nil)
    }
}

class ImagePreviewViewController: UIViewController, UIScrollViewDelegate {
    
    var x: CGFloat?
    var y: CGFloat?
    var w: CGFloat?
    var h: CGFloat?
    var image: UIImage?
    var imageView: UIImageView?
    var scrollView: UIScrollView?
    
    override func viewDidLoad() {
        
        imageView = UIImageView()
        if (image != nil) {
            imageView?.image = image
        } else {
            image = UIImage(named: "PreviewImage")
            imageView?.image = image
        }

        imageView?.isUserInteractionEnabled = false
        imageView?.contentMode = .scaleAspectFit
        
        scrollView = UIScrollView()
        scrollView?.backgroundColor = UIColor.black
        scrollView?.delegate = self
        scrollView?.frame = self.view.frame
        scrollView?.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0)
        scrollView?.minimumZoomScale = 1.0
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.addSubview(imageView!)
        
        self.view.addSubview(scrollView!)
        
        let oneTapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(oneTapEvent(ges:)))
        scrollView?.addGestureRecognizer(oneTapGes)
        
        let doubleTapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapEvent(ges:)))
        doubleTapGes.numberOfTapsRequired = 2
        doubleTapGes.cancelsTouchesInView = false
        scrollView?.addGestureRecognizer(doubleTapGes)
        
        
        self.scrollView?.panGestureRecognizer.require(toFail: doubleTapGes)
        self.scrollView?.pinchGestureRecognizer?.require(toFail: doubleTapGes)
        
        self.scrollView?.panGestureRecognizer.require(toFail: oneTapGes)
        self.scrollView?.pinchGestureRecognizer?.require(toFail: oneTapGes)
        
        oneTapGes.require(toFail: doubleTapGes)
        
        let imageW: CGFloat = (self.image?.size.width)!
        let imageH: CGFloat = (self.image?.size.height)!
        
        if UIScreen.main.bounds.size.height/UIScreen.main.bounds.size.width >= imageH/imageW {
            x = 0
            w = UIScreen.main.bounds.size.width
            h = UIScreen.main.bounds.size.width/imageW*imageH
            y = (UIScreen.main.bounds.size.height - h!)/2
            scrollView?.maximumZoomScale = 2
            
        } else {
            w = UIScreen.main.bounds.size.height/imageH*imageW
            h = UIScreen.main.bounds.size.height
            x = (UIScreen.main.bounds.size.width - w!)/2
            scrollView?.maximumZoomScale = UIScreen.main.bounds.size.width / w! > 2 ? UIScreen.main.bounds.size.width / w! : 2
            y = 0
        }
        self.imageView?.frame = CGRect(x: 0, y: 0, width: w!, height: h!)
        
        zoomImageToScreen()
    }
    
    // MARK: - Action
    @objc func oneTapEvent(ges: UITapGestureRecognizer) {
        scrollView?.zoomScale = 1.0
        scrollView?.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.imageView?.frame = CGRect(x: 0, y: 0, width: self.w!, height: self.h!)
            
        }) { (finished) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func doubleTapEvent(ges: UITapGestureRecognizer) {
        if self.scrollView!.zoomScale > CGFloat(1.5) {
            zoomImageToScreen()
            
        } else {
            let point: CGPoint = ges.location(in: imageView)
            zoomRectForScale(scale: 2, center: point)
        }
    }
    
    
    // MARK: - Zoom Scale
    func zoomImageToScreen() {

        
        self.scrollView?.setZoomScale(1.0, animated: true)
        
        SLLog(">>>>1\nimgX:\(String(describing: imageView?.bounds.origin.x))\nimgY:\(String(describing: imageView?.bounds.origin.y))\nimgW:\(String(describing: imageView?.bounds.size.width))\nimgH:\(String(describing: imageView?.bounds.size.height))\nscX:\(String(describing: scrollView?.contentOffset.x))\nscY:\(String(describing: scrollView?.contentOffset.y))\nscW:\(String(describing: scrollView?.contentSize.width))\nscH:\(String(describing: scrollView?.contentSize.height))\nScale:\(String(describing: scrollView?.zoomScale))")
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) {
        var rect: CGRect = CGRect()
        rect.size.height = (scrollView?.frame.size.height)! / scale
        rect.size.width = (scrollView?.frame.size.width)! / scale
        rect.origin.x = center.x - (rect.size.width / scale)
        rect.origin.y = center.y - (rect.size.height / scale)
        scrollView?.zoom(to: rect, animated: true)
        
        SLLog(">>>>2\nimgX:\(String(describing: imageView?.bounds.origin.x))\nimgY:\(String(describing: imageView?.bounds.origin.y))\nimgW:\(String(describing: imageView?.bounds.size.width))\nimgH:\(String(describing: imageView?.bounds.size.height))\nscX:\(String(describing: scrollView?.contentOffset.x))\nscY:\(String(describing: scrollView?.contentOffset.y))\nscW:\(String(describing: scrollView?.contentSize.width))\nscH:\(String(describing: scrollView?.contentSize.height))\nScale:\(String(describing: scrollView?.zoomScale))")
        
        SLLog("ZoomRect\nX:\(String(describing: rect.origin.x))\nY:\(String(describing: rect.origin.y))\nW:\(String(describing: rect.size.width))\nH:\(String(describing: rect.size.height))")
    }
    
    
    // MARK: - Delegate
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        let top: CGFloat = (UIScreen.main.bounds.size.height - h! * scrollView.zoomScale) / 2
//        let left: CGFloat = (UIScreen.main.bounds.size.width - w! * scrollView.zoomScale) / 2
//
//        scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
//        scrollView.contentSize = CGSize(width: w!*scrollView.zoomScale, height: h!*scrollView.zoomScale)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
