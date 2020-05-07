//
//  UIView+Animal.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/7.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
///旋转动画   暂停恢复
extension UIView {
    // 开始旋转
    func startRotating() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = NSNumber(value: 0.0)
        rotateAnimation.toValue = NSNumber(value: Double.pi * 2) // 旋转一周
        rotateAnimation.duration = 45.0 // 旋转时间20秒
        rotateAnimation.repeatCount = MAXFLOAT // 重复次数，这里用最大次数
        
        //防止动画结束后回到初始状态
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.fillMode = .forwards
        layer.add(rotateAnimation, forKey: nil)
        
    }
    
    // 停止旋转
    func stopRotating() {
        //        KKLog(@"// 停止旋转");
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0 // 停止旋转
        layer.timeOffset = pausedTime
        // 保存时间，恢复旋转需要用到
    }
    
    // 恢复旋转
    func resumeRotate() {
        if layer.timeOffset == 0 {
            startRotating()
            return
        }
        
        let pausedTime = layer.timeOffset
        layer.speed = 1.0 // 开始旋转
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime // 恢复时间
        layer.beginTime = timeSincePause
        // 从暂停的时间点开始旋转
    }
    
}
