//
//  UIView+GradualBackground.swift
//  ZGYM
//
//  Created by mac_hm on 2019/11/16.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import NightNight

extension UIView {
    /// 设置渐变背景颜色
    func yxs_gradualBackground(frame: CGRect, startColor: UIColor, endColor: UIColor, cornerRadius: CGFloat) {
        var tmp: CAGradientLayer!
        var shadow: CALayer?
        
        if let sublayers = self.layer.sublayers{
            for obj: CALayer in sublayers{
                if obj.name == "gradualLayer" {
                    tmp = obj as? CAGradientLayer
                    
                } else if obj.name == "shadowLayer" {
                    shadow = obj
                }
            }
        }
        
        
        if tmp == nil {
            tmp = CAGradientLayer()
            tmp.name = "gradualLayer"
        }
        
        let gl:CAGradientLayer = tmp
        gl.frame = frame
        gl.startPoint = CGPoint(x: 0.0, y: 0.5)
        gl.endPoint = CGPoint(x: 1.0, y: 0.5)
        gl.colors = [startColor.cgColor, endColor.cgColor]
        gl.locations = [0, 1.0]
        gl.cornerRadius = cornerRadius
        gl.masksToBounds = true
        
        if shadow != nil {
            self.layer.insertSublayer(gl, above: shadow)
        } else {
            self.layer.insertSublayer(gl, at: 0)
        }
    }
    
    /// 添加阴影 注意cornerRadius是当前视图的圆角值 offset阴影偏移量
    func yxs_shadow(frame: CGRect, color: UIColor = UIColor(red: 0.3, green: 0.45, blue: 0.96, alpha: 0.5), cornerRadius: CGFloat, offset: CGSize = CGSize(width: 0, height: 3)) {
        yxs_shadow(frame: frame, color: MixedColor(normal: color, night: color), cornerRadius: cornerRadius, offset: offset)
    }
    
    /// 添加阴影 MixedColor
        func yxs_shadow(frame: CGRect, color: MixedColor, cornerRadius: CGFloat, offset: CGSize = CGSize(width: 0, height: 3)) {
            var shadow: CALayer!
            
            
            for obj: CALayer in self.layer.sublayers ?? [CALayer]() {
                if obj.name == "shadowLayer" {
                    shadow = obj
                }
            }

            if shadow == nil {
                shadow = CALayer()
                shadow.name = "shadowLayer"
            }

            let subLayer: CALayer = shadow
            subLayer.frame = frame
    //        subLayer.borderWidth = 8
            subLayer.cornerRadius = cornerRadius
            subLayer.backgroundColor = UIColor.gray.withAlphaComponent(0.8).cgColor
            subLayer.mixedShadowColor = color
            subLayer.masksToBounds = false
            subLayer.shadowOffset = offset //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
            subLayer.shadowOpacity = 0.8//阴影透明度，默认0
    //        subLayer.shadowRadius = 8//阴影半径，默认3
            self.layer.insertSublayer(subLayer, at: 0)
        }
    
    /// 说明:若要实现圆角且有阴影 view.clipsToBounds=NO;再调用上面处扩展方法。
    /**
     For Example
     
         YXSButton *button = [[YXSButton alloc] init];
         [button gradualBackgroundFrame:CGRectMake(0, 0, 142, 50) startColor:UIColorHex(4CBAE8) endColor:UIColorHex(67CDD5) cornerRadius:25];
         [button shadowFrame:CGRectMake(0, 0, 142, 50) color:[UIColor grayColor] cornerRadius:25 offset:CGSizeMake(1, 2)];
         button.titleLabel.font = [UIFont systemFontOfSize:16];
         [button setTitle:@"提交" forState:UIControlStateNormal];
         [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [self addSubview:self.btnCommit];
     */
}
