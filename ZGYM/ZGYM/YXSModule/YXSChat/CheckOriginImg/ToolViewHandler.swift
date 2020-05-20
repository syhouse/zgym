//
//  ToolViewHandler.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/5/19.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import YBImageBrowser
import SDWebImage

/// 查看原图
class ToolViewHandler: YBIBToolViewHandler {

    /**
    容器视图准备好了，可进行子视图的添加和布局
    */
    override func yb_containerViewIsReadied() {
        yb_containerView?.addSubview(viewOriginButton)
        let size = yb_containerSize(yb_currentOrientation())
        viewOriginButton.center = CGPoint(x: size.width/2.0, y: size.height-80)
    }
    
    /**
     隐藏视图

     @param hide 是否隐藏
     */
    override func yb_hide(_ hide: Bool) {
        let data = yb_currentData() as? YBIBImageData
        if hide || data?.extraData == nil {
            viewOriginButton.isHidden = true
        } else {
            viewOriginButton.isHidden = false
        }
    }
    

    override func yb_pageChanged() {
        // 拿到当前的数据对象（此案例都是图片）
        let data = yb_currentData() as? YBIBImageData
        // 有原图就显示按钮
        viewOriginButton.isHidden = data?.extraData == nil
        viewOriginButton.setTitle("查看原图", for: .normal)
        updateViewOriginButtonSize()
    }

    override func yb_orientationDidChanged(with orientation: UIDeviceOrientation) {
        // 旋转的效果自行处理了
    }
        
    // MARK: - Action
    @objc func downloadOriginImage(msgData: TUIImageMessageCellData) {
        msgData.downloadImage(.TImage_Type_Origin)
        msgData.addObserver(self, forKeyPath: "originImage", options: [.new, .old], context: nil)
        msgData.addObserver(self, forKeyPath: "originProgress", options: [.new, .old], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "originImage" {
            if object is TUIImageMessageCellData {
                let msgData = object as! TUIImageMessageCellData
                
                let data = yb_currentData() as? YBIBImageData
                //隐藏按钮
                self.viewOriginButton.isHidden = true
                //终止处理数据
                data?.stopLoading()
                //清除缓存
                data?.clearCache()
                //清除原图地址
                data?.extraData = nil
                //清除之前的图片数据
                data?.imageData = nil
                //赋值新的数据
                data?.image = {
                    return msgData.originImage
                }
                //重载
                data?.load()
            }
            
        } else if keyPath == "originProgress" {
            let msgData = object as! TUIImageMessageCellData
            let progress = msgData.originProgress
            self.viewOriginButton.setTitle("\(progress)%", for: .normal)
            if progress >= 100 {
                self.viewOriginButton.isHidden = true
            }
        }
    }
    
    @objc func clickViewOriginButton(button:UIButton) {
        let data = yb_currentData() as? YBIBImageData
        if let msgData = data?.extraData {
            if data?.extraData is TUIImageMessageCellData {
                downloadOriginImage(msgData: data?.extraData as! TUIImageMessageCellData)
            }
        }
        return
        let originURL = data?.extraData as? URL
        //下载
        SDWebImageDownloader.shared.downloadImage(with: originURL, options: [.lowPriority, .avoidDecodeImage], progress: { (receivedSize, expectedSize, targetURL) in
            DispatchQueue.main.async {
                
                let progress = receivedSize * 1 / (expectedSize > 0 ? expectedSize : 0)
                let text = "\(progress * 100)%"
                self.viewOriginButton.setTitle(text, for: .normal)
                self.updateViewOriginButtonSize()
            }
            
        }) { (image, imageData, error, finished) in
            if error != nil {
                self.yb_containerView?.ybib_showForkToast("下载失败")
                return
            }
            //隐藏按钮
            self.viewOriginButton.isHidden = true
            //终止处理数据
            data?.stopLoading()
            //清除缓存
            data?.clearCache()
            //清除原图地址
            data?.extraData = nil
            //清除之前的图片数据
            data?.imageData = nil
            //赋值新的数据
            data?.imageData = {
                return imageData
            }
            //重载
            data?.load()
        }
    }
    
    // MARK: -  private
    func updateViewOriginButtonSize() {
        let size = viewOriginButton.intrinsicContentSize
        viewOriginButton.bounds = CGRect(x: 0, y: 0, width: size.width + 15, height: size.height)
    }
    
    // MARK: - LazyLoad
    lazy var viewOriginButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.gray.withAlphaComponent(0.75)
        btn.cornerRadius = 5.0
        btn.addTarget(self, action: #selector(clickViewOriginButton(button:)), for: .touchUpInside)
        return btn
    }()
}
