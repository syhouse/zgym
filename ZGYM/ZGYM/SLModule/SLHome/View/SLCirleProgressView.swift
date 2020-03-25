//
//  SLCirleProgressView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/20.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

class SLCirleProgressView: SLButton {
    
// MARK: -设置属性
    //设置绘图线宽
    public var excircleLineWith :CGFloat = 1.5
    
    /// 前景颜色
    public var foregroundColor: UIColor = kBlueColor
    
    /// 剩余进度颜色
    public var  restColor: UIColor = UIColor.red
    
    /// 是否展示剩余进度
    public var isShowRestColor = false
    
    /// 是否展示进度文本
    public var isShowTitle = true
    
    public var progress :CGFloat = 0.0 {
        //willSet观察属性值的变化
        willSet (newValue){
            //获取当前的进度值
            currentProgress = newValue
            self.setNeedsDisplay()
            
            if isShowTitle{
                //设置进度圆显示数字样式
                let str = NSString(format: "%.0f%%", currentProgress*100)
                setTitle(str as String, for: .normal)
                setTitleColor(kBlueColor, for:.normal)
                titleLabel?.font = UIFont.systemFont(ofSize: 12)
            }
            
        }
    }
    
    //零时数据存储
    private var currentProgress :CGFloat = 0.0

    override func draw(_ rect: CGRect) {

        //        arcCenter 圆心坐标
        //         radius　　　半径
        //         startAngle　起始角度
        //         endAngle　　　结束角度
        //         clockwise　　　true:顺时针/false：逆时针
        let size = rect.size
        
        let arcCenter = CGPoint(x: size.width*0.5, y: size.height*0.5)
        var radius = min(size.width, size.height)*0.5
        let startAngle = CGFloat(-(Double.pi / 2))
        let endAngle = currentProgress*2*CGFloat(-(Double.pi)) + startAngle

        // 外圆设置
        radius -= self.excircleLineWith
        if isShowRestColor{
            let restPath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: 1*2*CGFloat(-(Double.pi)) + startAngle, clockwise: false)
            
            restPath.lineWidth = excircleLineWith//设置线宽
            restPath.lineCapStyle = CGLineCap.round//设置线样式
            
            restColor.set()
            restPath.stroke()
        }
        
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        path.lineWidth = excircleLineWith//设置线宽
        path.lineCapStyle = CGLineCap.round//设置线样式
        
        foregroundColor.set()

        path.stroke()
        
    }
    
}
