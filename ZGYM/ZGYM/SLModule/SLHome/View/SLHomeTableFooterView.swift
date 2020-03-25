//
//  SLHomeTableFooterView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/21.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLHomeTableFooterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(midView)
        addSubview(leftLine)
        addSubview(rightLine)
        addSubview(emptyView)
        
        midView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(22)
            make.height.equalTo(22.5)
//            make.bottom.equalTo(-22)
        }
        leftLine.snp.makeConstraints { (make) in
            make.right.equalTo(midView.snp_left).offset(-4)
            make.centerY.equalTo(midView)
            make.size.equalTo(CGSize.init(width: 60, height: 0.5))
        }
        
        rightLine.snp.makeConstraints { (make) in
            make.left.equalTo(midView.snp_right).offset(4)
            make.centerY.equalTo(midView)
            make.size.equalTo(CGSize.init(width: 60, height: 0.5))
        }
        
        emptyView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        emptyView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showEmpty(_ isEmpty: Bool){
        emptyView.isHidden = true
        rightLine.isHidden = true
        leftLine.isHidden = true
        midView.isHidden = true
        if isEmpty{
            emptyView.isHidden = false
        }else{
            rightLine.isHidden = false
            leftLine.isHidden = false
            midView.isHidden = false
        }
    }
    
//    func sl_drawDashLine(_ lineView:UIView,strokeColor: UIColor, lineWidth: CGFloat = 1, lineLength: CGFloat = 2, lineSpacing: CGFloat = 2) {
//            let shapeLayer = CAShapeLayer()
//            shapeLayer.bounds = lineView.bounds
//            shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
//            shapeLayer.fillColor = UIColor.blue.cgColor
//            shapeLayer.strokeColor = strokeColor.cgColor
//
//            shapeLayer.lineWidth = lineWidth
//            shapeLayer.lineJoin = CAShapeLayerLineJoin.round
//
//            //每一段虚线长度 和 每两段虚线之间的间隔
//        shapeLayer.lineDashPattern = [NSNumber.init(value: lineLength), NSNumber.init(value: lineLength)]
//
//            let path = CGMutablePath()
//    //        let y = lineView.layer.bounds.height - lineWidth
//            let x = lineView.layer.bounds.width - lineWidth
//            path.move(to: CGPoint(x: x, y: 0))
//            path.addLine(to: CGPoint(x: x, y: lineView.layer.bounds.height))
//            shapeLayer.path = path
//            lineView.layer.addSublayer(shapeLayer)
//        }
//
    lazy var midView: SLCustomImageControl = {
        let midView = SLCustomImageControl.init(imageSize: CGSize.init(width: 27.5, height: 22.5), position: .left, padding: 5)
        midView.title = "我是有底线滴"
        midView.locailImage = "home_footer"
        midView.textColor = UIColor.sl_hexToAdecimalColor(hex: "#C4CDDA")
        midView.font = UIFont.systemFont(ofSize: 13)
        return midView
    }()
    
    lazy var leftLine: UIView = {
       let leftLine = UIView()
        leftLine.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#C4CDD9")
        return leftLine
    }()
    
    lazy var rightLine: UIView = {
       let rightLine = UIView()
        rightLine.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#C4CDD9")
        return rightLine
    }()
    
    lazy var emptyView: UIImageView = {
        let imageView = UIImageView()
        imageView.mixedImage = MixedImage(normal: "sl_defultImage_nodata", night: "sl_defultImage_nodata_night")
        return imageView
    }()
}
