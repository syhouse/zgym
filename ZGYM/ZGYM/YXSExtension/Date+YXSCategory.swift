//
//  Date+SLCategory.swift
//  ZGYM
//
//  Created by mac_hm on 2019/11/13.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation

extension Date {
    /// 时间转换
    static func yxs_Time(interval: TimeInterval) -> String {
        let dateTmp: Date = Date(timeIntervalSinceNow: interval / 1000)
        return yxs_Time(date: dateTmp)
    }
    
    static func yxs_Time(dateStr: String) -> String{
        return yxs_Time(date: NSUtil.yxs_string2Date(dateStr))
    }
    
    
    /// 全局列表时间 2019.03.14 12:08
    static func yxs_Time(date dateTmp: Date) -> String {
        
//        let minuteTmp: Int = Calendar.current.component(Calendar.Component.minute, from: dateTmp)
//        let minuteNow: Int = Calendar.current.component(Calendar.Component.minute, from: Date())
//        
//        let hourTmp: Int = Calendar.current.component(Calendar.Component.hour, from: dateTmp)
//        let hourNow: Int = Calendar.current.component(Calendar.Component.hour, from: Date())
//        
//        let dayTmp: Int = Calendar.current.component(Calendar.Component.day, from: dateTmp)
//        let dayNow: Int = Calendar.current.component(Calendar.Component.day, from: Date())
//        
//        let monthTmp: Int = Calendar.current.component(Calendar.Component.month, from: dateTmp)
//        let monthNow: Int = Calendar.current.component(Calendar.Component.month, from: Date())
        
        let yearTmp: Int = Calendar.current.component(Calendar.Component.year, from: dateTmp)
        let yearNow: Int = Calendar.current.component(Calendar.Component.year, from: Date())
        
//        let day: Int = dayNow - dayTmp
//        let hour: Int = hourNow - hourTmp
//        let minute: Int = minuteNow - minuteTmp
//        let month: Int = monthNow - monthTmp
        let year: Int = yearNow - yearTmp
        
        //        SLLog("TMP:\(dayTmp) \(hourTmp):\(minuteTmp)\nNow:\(dayNow) \(hourNow):\(minuteNow)")
        if year > 0 {
            let dFormatter: DateFormatter = DateFormatter()
            dFormatter.dateFormat = "YY.MM.dd"
            return dFormatter.string(from: dateTmp)
        }
        let dFormatter: DateFormatter = DateFormatter()
        dFormatter.dateFormat = "MM.dd HH:mm"
        return dFormatter.string(from: dateTmp)
//        if month > 0 {
//            let dFormatter: DateFormatter = DateFormatter()
//            dFormatter.dateFormat = "MM.dd"
//            return dFormatter.string(from: dateTmp)
//        }
//
//        if day > 2 {
//            let dFormatter: DateFormatter = DateFormatter()
//            dFormatter.dateFormat = "MM-dd"
//            return dFormatter.string(from: dateTmp)
//
//        } else if day == 2 {
//            return "前天"
//
//        } else if day == 1 {
//            return "昨天"
//
//        } else if hour > 0 {
//            return "\(hour)小时前"
//            
//        } else if minute > 2 {
//            return "\(minute)分钟前"
//
//        } else {
//            return "刚刚"
//        }
    }
    
    
    static func yxs_helloTime(interval: TimeInterval) -> String {
        let dateTmp: Date = Date.init(timeIntervalSince1970: interval / 1000)
        
        //            let minuteTmp: Int = Calendar.current.component(Calendar.Component.minute, from: dateTmp)
        let hourTmp: Int = Calendar.current.component(Calendar.Component.hour, from: dateTmp)
        
        if hourTmp >= 6 &&  hourTmp < 10{
            return "早上好"
            
        } else if hourTmp >= 10 &&  hourTmp < 12 {
            return "上午好"
            
        } else if hourTmp >= 12 &&  hourTmp < 14 {
            return "中午好"
            
        } else if hourTmp >= 14 &&  hourTmp < 18 {
            return "下午好"
            
        }
        else {
            return "晚上好"
        }
    }
    ///返回日期格式“03月23日 星期一“
    func yxs_homeTimeWeek() -> String{
        let first = self.toString(format: DateFormatType.custom("MM月dd日"))
        let week: Int = Calendar.current.component(Calendar.Component.weekday, from: self)
        var last = " "
        switch week {
        case 1:
            last += "星期天"
        case 2:
        last += "星期一"
        case 3:
        last += "星期二"
        case 4:
        last += "星期三"
        case 5:
        last += "星期四"
        case 6:
        last += "星期五"
        case 7:
        last += "星期六"
        default:
            break
        }
        return first + last
    }
    
}
