//
//  SLGuideViewWindow.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/24.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit

enum SLGuideType{
    case mask  //遮罩
    case view  //视图
}

class SLGuideModel: NSObject{
    var view: UIView!
    var viewFrame: CGRect!
    var maskFrame: CGRect!
    var imageFrame: CGRect!
    var imageName: String!
    var maskCornerRadius: CGFloat!
    var type: SLGuideType
    
    
    /// 遮罩model
    /// - Parameters:
    ///   - type: 指引类型
    ///   - maskFrame: 遮罩frame
    ///   - maskCornerRadius:  遮罩圆角
    ///   - imageFrame: 指引图frame
    ///   - imageName: 指引图Name
    init(type: SLGuideType,maskFrame: CGRect,maskCornerRadius: CGFloat,imageFrame: CGRect,imageName: String){
        self.type = type
        self.maskFrame = maskFrame
        self.imageFrame = imageFrame
        self.imageName = imageName
        self.maskCornerRadius = maskCornerRadius
        super.init()
    }
    
    
    /// ViewModel
    /// - Parameters:
    ///   - type: 指引类型
    ///   - view: 自定义指引View
    ///   - viewFrame: 指引viewFrame
    ///   - imageFrame: 指引图frame
    ///   - imageName: 指引图Name
    convenience init(type: SLGuideType,view: UIView,viewFrame: CGRect,imageFrame: CGRect,imageName: String){
        self.init(type: type, maskFrame: CGRect.zero,maskCornerRadius: 0, imageFrame: imageFrame, imageName: imageName)
        self.view = view
        self.viewFrame = viewFrame
    }
}


/// 指引弹出Window
class SLGuideViewWindow: UIControl{
    private var items:[SLGuideModel]
    private var sucess: (()->())?
    
    /// 类方法创建
    /// - Parameters:
    ///   - items: 每个指引model
    ///   - onView: window的父视图
    ///   - sucess: 指引完成回调
    static func showGuideViewWindow(items:[SLGuideModel],onView: UIView = UIUtil.RootController().view,sucess:(()->())? = nil){
        let view = SLGuideViewWindow.init(items: items, onView: onView)
        view.sucess = sucess
        view.beginAnimation()
    }
    
    private init(items:[SLGuideModel],onView: UIView = UIUtil.RootController().view){
        self.items = items
        super.init(frame: onView.bounds)
        self.backgroundColor = UIColor.clear
        
        self.fillLayer.path      = self.overlayPath.cgPath;
        self.fillLayer.fillRule  = CAShapeLayerFillRule.evenOdd;
        self.fillLayer.fillColor = UIColor.init(white: 0, alpha: 0.7).cgColor;
        
        self.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        onView.addSubview(self)
        
        setUI(model: items.first)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI(model:SLGuideModel?){
        if let model = model{
            self.removeSubviews()
            if model.type == .view{
                addSubview(model.view)
                model.view.frame = model.viewFrame
            }else{
                overlayPath = self.getOverlayPath()
                let transparentPath = UIBezierPath.init(roundedRect: model.maskFrame, cornerRadius: model.maskCornerRadius)
                overlayPath.append(transparentPath)
                self.fillLayer.path      = self.overlayPath.cgPath;
            }
            let imageView = UIImageView.init(image: UIImage.init(named: model.imageName))
            addSubview(imageView)
            imageView.frame = model.imageFrame
            
            items.remove(at: 0)
        }else{
            dismiss()
        }
    }
    
    private func beginAnimation() {
        self.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        })
    }
    
    
    
    // MARK: -event
    @objc private func dismiss(){
        if items.count == 0{
            sucess?()
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            }) { finished in
                self.removeFromSuperview()
            }
        }else{
            setUI(model: items.first)
        }
    }
    
    // MARK: - 遮罩相关
    @objc private func getOverlayPath() ->UIBezierPath{
        let overlayPath = UIBezierPath.init(rect: self.bounds)
        overlayPath.usesEvenOddFillRule = true
        return overlayPath
    }
    
    private lazy var overlayPath: UIBezierPath = {
        return getOverlayPath()
    }()
    
    private lazy var fillLayer: CAShapeLayer = {
        let fillLayer = CAShapeLayer()
        fillLayer.frame = self.bounds
        self.layer.addSublayer(fillLayer)
        return fillLayer
    }()
}
