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
    
    
    /// 返回一个日期，是在当前时间往后n年的日期
    /// - Parameter years: 需要增加的时间（年）
    /// - Returns: 增加后日期
    func yxs_dateByAddingYears(years:Int) -> Date? {
        let calendar = Calendar.current
        var components = DateComponents.init()
        components.year = years
        return calendar.date(byAdding: components, to: self) ?? nil
    }
    
    /// 返回一个日期，是在当前时间往后n月的日期
    /// - Parameter Months: 需要增加的时间（月）
    /// - Returns: 增加后日期
    func yxs_dateByAddingMonths(months:Int) -> Date? {
        let calendar = Calendar.current
        var components = DateComponents.init()
        components.month = months
        return calendar.date(byAdding: components, to: self) ?? nil
    }
    
    /// 返回一个日期，是在当前时间往后n周的日期
    /// - Parameter Weeks: 需要增加的时间（周）
    /// - Returns: 增加后日期
    func yxs_dateByAddingWeeks(weeks:Int) -> Date? {
        let calendar = Calendar.current
        var components = DateComponents.init()
        components.weekOfYear = weeks
        return calendar.date(byAdding: components, to: self) ?? nil
    }
    
    /// 返回一个日期，是在当前时间往后n天的日期
    /// - Parameter Days: 需要增加的时间（天）
    /// - Returns: 增加后日期
    func yxs_dateByAddingDays(days:Int) -> Date? {
        let calendar = Calendar.current
        var components = DateComponents.init()
        components.day = days
        return calendar.date(byAdding: components, to: self) ?? nil
    }
    
    
    /// 返回一个日期，是在当前时间往后n时的日期
    /// - Parameter hour: 需要增加的时间（时）
    /// - Returns: 增加后日期
    func yxs_dateByDeleteHour(hour:Int) -> Date? {
        let calendar = Calendar.current
        var components = DateComponents.init()
        components.hour = hour
        return calendar.date(byAdding: components, to: self) ?? nil
    }
    
    /// 与当前时间的月份差是否超过传入的值  传入的时间  比 当前时间 大
    /// - Returns: 相差的月数 正值为大于当前日期 负值为小于当前日期
    func yxs_isDifferWithMonth(month: Int) -> Bool? {
        let calendar = Calendar.current
        let cmps = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day,Calendar.Component.hour,Calendar.Component.minute,Calendar.Component.second], from: Date(), to: self)
        if cmps.year ?? 0 > 0 {
            return true
        } else if cmps.month ?? 0 > month {
            return true
        } else if cmps.month ?? 0 == month {
            // 相差的月份 等于 月份时，如果天 时 分 秒 超出，就算 大于相差的月份
            if cmps.day ?? 0 > 0 || cmps.hour ?? 0 > 0 || cmps.minute ?? 0 > 0 || cmps.second ?? 0 > 0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    /// 与当前时间比较大小
    func yxs_CompareDiffer() -> Bool? {
        let calendar = Calendar.current
        let cmps = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day,Calendar.Component.hour,Calendar.Component.minute,Calendar.Component.second], from: Date(), to: self)
        if cmps.year ?? 0 > 0 {
            return true
        } else if cmps.month ?? 0 > 0 {
            return true
        } else if cmps.day ?? 0 > 0 {
            return true
        } else if cmps.hour ?? 0 > 0 {
            return true
        } else if cmps.minute ?? 0 > 0 {
            return true
        } else if cmps.second ?? 0 > 0 {
            return true
        } else {
            return false
        }
    }
    
}
