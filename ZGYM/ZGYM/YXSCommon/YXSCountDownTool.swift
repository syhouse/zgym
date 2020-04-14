//
//  YXSCountDownTool.swift
//  SwiftBase
//
//  Created by zgjy_mac on 2019/9/10.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

enum YXSCountDownType{
    case normal
    case day
}
//d倒计时工具
class YXSCountDownTool: NSObject {
    private var timer: DispatchSource!
    
    /// 是否倒计时完成
    var isFinish: Bool = true
    
    /// 距离结束剩余时间(s)
    public func yxs_startCountDown(residueTime: Int, complete:@escaping (Int, Bool) ->()) {
        let curruntDate = Date()

        let timestamp: TimeInterval  = curruntDate.timeIntervalSince1970 + Double(residueTime)
        yxs_startCountDown(timestamp: timestamp, complete: complete)
    }
    /// 结束时间戳
    public func yxs_startCountDown(timestamp: TimeInterval, complete:@escaping (Int, Bool) ->()) {
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global()) as? DispatchSource
        
        self.timer?.schedule(wallDeadline: DispatchWallTime.now(), repeating: .milliseconds(100))
        self.timer?.setEventHandler(handler: {
            let time = timestamp - Date().timeIntervalSince1970
            
            self.isFinish = time > 0 ? false : true
            if self.isFinish{
                self.timer?.cancel()
            }
            
            DispatchQueue.main.async(execute: {
                complete(Int(time),self.isFinish)
            })
        })
        self.timer?.resume()
    }
    
    /// 计时进行时间
    public var keepTime: Int = 0
    
    /// 开始计时
    /// - Parameter complete: 计时回调
    public func yxs_startKeepTime(complete:((Int) ->())? = nil) {
        let curruntDate = Date()
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global()) as? DispatchSource
        self.timer?.schedule(wallDeadline: DispatchWallTime.now(), repeating: .milliseconds(100))
        self.timer?.setEventHandler(handler: {
            self.keepTime = Int(Date().timeIntervalSince1970 - curruntDate.timeIntervalSince1970)
            complete?(self.keepTime)
        })
        self.timer?.resume()
    }
    
    /// 取消计时
    public func yxs_cancelTimer(){
        self.timer?.cancel()
    }
    
    /*
     /// 展示倒计时展示字符串
      /// - Parameters:
      ///   - timestamp: 时间戳
      ///   - complete: 倒计时回调
      public func yxs_startCountDown(timestamp: TimeInterval, complete:@escaping (String, Bool) ->()) {
          self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global()) as? DispatchSource
          
          self.timer?.schedule(wallDeadline: DispatchWallTime.now(), repeating: .milliseconds(100))
          self.timer?.setEventHandler(handler: {
              let time = timestamp - Date().timeIntervalSince1970
              
              let isFinish = time > 0 ? false : true
              if isFinish{
                  self.timer?.cancel()
              }
              var countTime = "00:00"
              if time > 0 {
                  let day = Int(time) / (60 * 60 * 24)
                  let hour = Int(time) % (60 * 60 * 24)
                  let mu = Int(time) % (60 * 60 * 24) % (60 * 60) / 60
                  let secend = Int(time) % (60 * 60 * 24) % (60 * 60) % 60
                  countTime = String(format: "%ld%ld小时%02ld分%02ld秒", day, hour, mu, secend)
              }
              DispatchQueue.main.async(execute: {
                  complete(countTime,isFinish)
              })
          })
          self.timer?.resume()
      }
     */
    
}
