//
//  UIView+Animal.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/27.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

extension CALayer {
    func yxs_circleCircleAnimal(size: CGSize, _ duration:CFTimeInterval = 3, _ repeatCount: Float = 100){
        let arcCenter = CGPoint(x: size.width*0.5, y: size.height*0.5)
        let radius = min(size.width, size.height)*0.5 - self.frame.height/2
        let pathAnimal = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: CGFloat(-(Double.pi / 2)), endAngle: CGFloat((Double.pi / 2)*3), clockwise: true)
        let keyFrameAni = CAKeyframeAnimation(keyPath: "position")
        keyFrameAni.repeatCount = repeatCount
        keyFrameAni.path = pathAnimal.cgPath
        keyFrameAni.duration = duration
        keyFrameAni.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        keyFrameAni.beginTime = CACurrentMediaTime() + 0.5
        self.add(keyFrameAni, forKey: "keyFrameAnimation")
        
        
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        // 2.设置动画属性
        rotationAnim.fromValue = 0 // 开始角度
        rotationAnim.toValue = CGFloat((Double.pi / 2)*4) // 结束角度
        rotationAnim.repeatCount = repeatCount // 重复次数
        rotationAnim.duration = duration
        rotationAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        rotationAnim.autoreverses = false // 动画完成后自动重新开始,默认为NO
        rotationAnim.beginTime = CACurrentMediaTime() + 0.5
        rotationAnim.isRemovedOnCompletion = false //默认是true，切换到其他控制器再回来，动画效果会消失，需要设置成false，动画就不会停了
        self.add(rotationAnim, forKey: nil) // 给需要旋转的view增加动画
    }
}
