//
//  MBProgressHUD+Convenience.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/19.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import MBProgressHUD
    
extension MBProgressHUD {
    // MARK: - Message
    static func yxs_showMessage(message: String) {
        yxs_hideHUD()
        yxs_showMessage(message: message, inView: UIApplication.shared.keyWindow)
    }
    
    static func yxs_showMessage(message: String, afterDelay: TimeInterval = 0.89) {
        yxs_hideHUD()
        yxs_showMessage(message: message, inView: UIApplication.shared.keyWindow, afterDelay: afterDelay)
    }
    
    
    static func yxs_showMessage(message: String, inView: UIView?, afterDelay: TimeInterval = 0.89) {
        if inView == nil {
            return
        }
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: inView!, animated: true)
            hud.mode = .text
//            hud.label.text = message
            hud.detailsLabel.text = message
            hud.detailsLabel.font = UIFont.systemFont(ofSize: 16)
            hud.hide(animated: true, afterDelay: afterDelay)
        }
    }
    
    // MARK: - Loding...
    static func yxs_showLoading(ignore:Bool = false) {
        yxs_showLoading(message: "加载中...", ignore: ignore)
    }
    
    static func yxs_showLoading(message: String, ignore:Bool = false) {
//        UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
        yxs_showLoading(message: message, inView: UIApplication.shared.keyWindow, ignore: ignore)
    }
    
    static func yxs_showLoading(message: String = "加载中...", inView: UIView?, ignore:Bool = false) {
        if (inView == nil || ignore) {
            return
        }
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: inView!, animated: true)
            hud.label.text = message
            hud.mode = .indeterminate
            hud.yxs_commonSetup()
            hud.show(animated: true)

        }
    }
    
    // MARK: - Hide
    static func yxs_hideHUD() {
        yxs_hideHUDInView(view: UIApplication.shared.keyWindow ?? UIWindow())
    }
    
    static func yxs_hideHUDInView(view: UIView?) {
        if view == nil {
            return
        }
        MBProgressHUD.hide(for: view!, animated: true)
    }
    
    // MARK: - Private
    private static func yxs_hudInView(view: UIView) -> MBProgressHUD {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        return hud
    }
    
    func yxs_commonSetup() {
        self.removeFromSuperViewOnHide = true
        self.detailsLabel.font = UIFont.boldSystemFont(ofSize: 16)
    }
}

// MARK: - 上传进度
extension MBProgressHUD {
    static func yxs_showUpload(title: String = "正在上传", inView: UIView? = UIApplication.shared.keyWindow) {
        yxs_hideHUD()
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: inView!, animated: true)
            hud.mode = .customView
            hud.removeFromSuperViewOnHide = true
            hud.show(animated: true)
            hud.bezelView.style = .solidColor
            hud.bezelView.backgroundColor = UIColor.clear
            let customView = YXSUploadCustomView(frame: CGRect.init(x: 0, y: 0, width: 125, height: 158))
            customView.titleLabel.text = title
            hud.customView = customView
        }
    }
    
    static func yxs_updateUploadProgess(progess: CGFloat, inView: UIView? = UIApplication.shared.keyWindow) {
        if let inView = inView{
            for view in inView.subviews{
                if view is MBProgressHUD{
                    if let customView = (view as! MBProgressHUD).customView as? YXSUploadCustomView{
                        DispatchQueue.main.async {
                            customView.progress = progess
                        }
                        break
                    }
                }
            }
        }
    }
}

class YXSUploadCustomView: UIView{
    var progress: CGFloat = 0.0 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    override var intrinsicContentSize: CGSize{
        return self.frame.size
    }
    
    override init(frame: CGRect) {
        if frame == CGRect.zero{
            super.init(frame: CGRect.init(x: 0, y: 0, width: 125, height: 158))
        }else{
            super.init(frame: frame)
        }
        self.backgroundColor = UIColor.white
        self.cornerRadius = 15
        addSubview(titleLabel)
        addSubview(progressLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(-25.5)
        }
        progressLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(58)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let size = CGSize.init(width: 69, height: 69)
        
        let arcCenter = CGPoint(x: 28 + size.width*0.5, y: 28 + size.height*0.5)
        var radius = min(size.width, size.height)*0.5
        let startAngle: CGFloat = CGFloat((Double.pi))*1.5
        let endAngle: CGFloat = progress*CGFloat((Double.pi))*2 + startAngle

        // 外圆设置
        radius -= 3
        let restPath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: 0, endAngle: 2*CGFloat((Double.pi)) + startAngle, clockwise: true)
        
        restPath.lineWidth = 3//设置线宽
        restPath.lineCapStyle = CGLineCap.round//设置线样式
        
        UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3").set()
        restPath.stroke()
        
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        path.lineWidth = 3//设置线宽
        path.lineCapStyle = CGLineCap.round//设置线样式
        
        kBlueColor.set()

        path.stroke()
        
        progressLabel.text = "\(String.init(format: "%d", Int(progress * 100)))%"
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = kTextMainBodyColor
        label.text = "正在上传"
        return label
    }()
    
    lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#83878F")
        label.text = "0%"
        return label
    }()
}
