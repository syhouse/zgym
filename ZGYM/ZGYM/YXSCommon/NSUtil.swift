//
//  NSUtil.swift
//  ZGYM
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import CoreTelephony

let yxs_ArchiveFileDirectoryKey = "yxs_archiveFile"

public enum YXSCacheDirectory:String{
    case HomeWork
    case notice
    case punchCard
    case solitaire
    case friend
}

class NSUtil {
    
    //MARK:File
    static func yxs_cachePath() -> String{
        
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first ?? ""
    }
    
    
    /// yxs_archiveFile
    /// - Parameter file: fielName
    static func yxs_archiveFile(file: String) -> String{
        return yxs_cachePath(file: file, directory: yxs_ArchiveFileDirectoryKey)
    }
    
    /// audio存储地址
    /// - Parameter directory: CacheDirectory
    /// - Parameter id: 提交业务id
    static func yxs_recordCachePath(_ directory :YXSCacheDirectory, _ id: String) -> String{
        let dir = yxs_cachePath().appendingPathComponent(kMediaDirectory)
        if !isDirectoryExist(path: dir){
            do{
                try FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
            }catch{
                
            }
        }
        let str = YXSPersonDataModel.sharePerson.personRole == .PARENT ? "Parent": "Teacher"
        let dirSecend = dir.appendingPathComponent(str)
        if !isDirectoryExist(path: dirSecend){
            do{
                try FileManager.default.createDirectory(atPath: dirSecend, withIntermediateDirectories: true, attributes: nil)
            }catch{
                
            }
        }
        let dirType = dirSecend.appendingPathComponent(directory.rawValue)
        if !isDirectoryExist(path: dirType){
            do{
                try FileManager.default.createDirectory(atPath: dirType, withIntermediateDirectories: true, attributes: nil)
            }catch{
                
            }
        }
        return dirType.appendingPathComponent(id)
    }
    
    static func yxs_cachePath(file: String,directory: String = "") -> String{
        let dir = yxs_cachePath().appendingPathComponent(directory)
        if !isDirectoryExist(path: dir){
            do{
                try FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
            }catch{
                
            }
        }
        let dirString = dir as NSString
        return dirString.appendingPathComponent(file)
    }
    
    static func yxs_removeCachePathFile(file: String){
        let dir = yxs_cachePath()
        
        guard isDirectoryExist(path: dir) else {
            return
        }
        
        let filePath = (dir as NSString).appendingPathComponent(file)
        do{
            try FileManager.default.removeItem(atPath: filePath)
        }catch{
            
        }
    }
    
    static func isDirectoryCacheExist(file: String,directory: String) -> Bool{
        let dir = yxs_cachePath().appendingPathComponent(directory)
        if !isDirectoryExist(path: dir){
            return false
        }
        let filepath = dir.appendingPathComponent(file)
        if !isDirectoryExist(path: filepath){
            return false
        }
        return true
    }
    
    static func isDirectoryExist(path: String) -> Bool{
        var isDirectory = ObjCBool(false)
        return FileManager.default.fileExists(atPath: path, isDirectory: UnsafeMutablePointer<ObjCBool>(&isDirectory)) && !isDirectory.boolValue
    }
    //    MARK:Bundle
    static func BundleInfo(key: String) -> String{
        return Bundle.main.object(forInfoDictionaryKey: key) as! String
    }
    
    static func BundleName() -> String{
        return BundleInfo(key: "CFBundleName")
    }
    
    static func BundleDisplayName() -> String{
        return BundleInfo(key: "CFBundleDisplayName")
    }
    
    
// MARK: - 阿里云上传资源路径
    static func getPath(sourceType: SourceNameType,fileName: String,fileType: String) -> String{
        return "\(sourceType.rawValue)/" + "iOS/" + "\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)/" + "\(YXSPersonDataModel.sharePerson.userModel?.type ?? "")/"  + fileName + "." + fileType
    }
    /// 编译版本(6)
    static func BundleVersion() -> String{
        return BundleInfo(key: "CFBundleVersion")
    }
    

    /// 上架版本(1.0.1)
    static func BundleShortVersion() -> String{
        return BundleInfo(key: "CFBundleShortVersionString")
    }
    
    static func standardValue(key: String) -> Any?{
        return UserDefaults.standard.value(forKey: key)
    }
    
    static func saveStandardValue(key: String, value: Any?){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    
    /// 字符串转date
    /// - Parameters:
    ///   - string: 字符串
    ///   - dateFormat: 日期格式
    static func yxs_string2Date(_ string:String, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        return date ?? Date()
    }
    
    
    /// 是否是同一天
    /// - Parameters:
    ///   - date1: date1
    ///   - date2: date2
    static func yxs_isSameDay(_ date1: Date, date2: Date) -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let curruntStr = dateFormatter.string(from: date1)
        let curruntYear = String(curruntStr.split(separator: "-").first ?? "")
        let curruntMonth = String(curruntStr.split(separator: "-")[1] )
        let curruntDay = String(curruntStr.split(separator: "-").last ?? "")
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayStr = dateFormatter.string(from: date2)
        let todayYear = String(todayStr.split(separator: "-").first ?? "")
        let todayMonth = String(todayStr.split(separator: "-")[1] )
        let todayDay = String(todayStr.split(separator: "-").last ?? "")
        
        if curruntYear != todayYear || curruntMonth != todayMonth || curruntDay != todayDay{
            return false
        }
        return true
    }
    
    
    /// 缩略图
    /// - Parameters:
    ///   - width: h宽度
    ///   - height: 高度
    static func yxs_imageThumbnail( width: Int, height: Int) -> String {
        return "?x-oss-process=image/resize,m_fill,h_\(height),w_\(width),limit_0"
    }
    
    
    /// 班级之星周期字符串
    /// - Parameter dateType: 日期格式
    static func yxs_timePeriodText(dateType: DateType) -> String{
        
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.year, .month, .day, .weekday], from: Date())
        let day = comp.day
        let month = comp.month
        let year = comp.year
        // 获取今天是周几
        let weekDay: Int? = comp.weekday
        switch dateType {
        case .D:
            return "\(month ?? 0)月\(day ?? 0)日"
        case .W:
            var time:Int = 0
            if weekDay == 1{
                time = 24*60*60*6
            }else{
                time = 24*60*60*(Int(weekDay ?? 2) - 2)
            }
            let preDate: Date = Date.init(timeInterval:  TimeInterval.init(-time), since: Date())
            let precomp = calendar.dateComponents([.year, .month, .day, .weekday], from: preDate)
            let precompday = precomp.day
            let premonth = precomp.month
            
            return "\(premonth ?? 0)月\(precompday ?? 0)日" + "-" + "\(month ?? 0)月\(day ?? 0)日"
        case .M:
            return "\(month ?? 0)月\(1)日" + "-" + "\(month ?? 0)月\(day ?? 0)日"
        case .Y:
            return "\(year ?? 0)年"
        }
    }
    
    static func yxs_timeDayText(dateType: DateType) -> (x: String, y: String){
        
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.year, .month, .day, .weekday], from: Date())
        let day = comp.day
        let month = comp.month
        let year = comp.year
        // 获取今天是周几
        let weekDay: Int? = comp.weekday
        switch dateType {
        case .D:
            return ("\(year ?? 0)年\(month ?? 0)月\(day ?? 0)日", "\(year ?? 0)年\(month ?? 0)月\(day ?? 0)日")
        case .W:
            var time:Int = 0
            if weekDay == 1{
                time = 24*60*60*6
            }else{
                time = 24*60*60*(Int(weekDay ?? 2) - 2)
            }
            let preDate: Date = Date.init(timeInterval:  TimeInterval.init(-time), since: Date())
            let precomp = calendar.dateComponents([.year, .month, .day, .weekday], from: preDate)
            let precompday = precomp.day
            let premonth = precomp.month
//            + "-"
            return ("\(year ?? 0)-\(premonth ?? 0)-\(precompday ?? 0) 00:00:00",  "\(year ?? 0)-\(month ?? 0)-\(day ?? 0) 23:59:59")
        case .M:
            return  ( ("\(year ?? 0)-\(month ?? 0)-\(1)  00:00:00"),  ("\(year ?? 0)-\(month ?? 0)-\(day ?? 0) 23:59:59"))
        case .Y:
            return (("\(year ?? 0)-01-01  00:00:00" ), ("\(year ?? 0)-12-31 23:59:59" ) )
        }
    }
    
    
    /// 班级之星日期字符串
    /// - Parameter dateType: 日期格式
    static func yxs_getDateText(dateType: DateType) -> String{
        switch dateType {
            case .D:
            return "今日"
        case .W:
            return "本周"
        case .M:
            return "本月"
        case .Y:
            return "年度"
        }
    }
    
    
    /// 链接编码
    /// - Parameter url: 中文链接
    static func yxs_urlAllowedCharacters(url: String) -> String{
        return url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}


//MARK:设备
extension NSUtil{
    /// 手机型号
    static func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4 Mobile"
        case "iPhone4,1":                               return "iPhone 4S Mobile"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5 Mobile"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c Mobile"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s Mobile"
        case "iPhone7,2":                               return "iPhone 6 Mobile"
        case "iPhone7,1":                               return "iPhone 6 Plus Mobile"
        case "iPhone8,1":                               return "iPhone 6s Mobile"
        case "iPhone8,2":                               return "iPhone 6s Plus Mobile"
        case "iPhone9,1":                               return "iPhone 7 (CDMA) Mobile"
        case "iPhone9,3":                               return "iPhone 7 (GSM) Mobile"
        case "iPhone9,2":                               return "iPhone 7 Plus (CDMA) Mobile"
        case "iPhone9,4":                               return "iPhone 7 Plus (GSM) Mobile"
            
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8 Mobile"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus Mobile"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X Mobile"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
            
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    static func getImsi() -> String? {
        let info = CTTelephonyNetworkInfo()
        if let carrier = info.subscriberCellularProvider {
            return "\(carrier.mobileCountryCode ?? "")\(carrier.mobileNetworkCode ?? "")"
        }
        return nil
    }
    
    // 根据网址请求 获取IP地址, 如传 www.baidu.com
    static func getIPAddressFromDNSQuery(url: String) -> String? {
        let host = CFHostCreateWithName(nil, url as CFString).takeRetainedValue()
        CFHostStartInfoResolution(host, .addresses, nil)
        var success: DarwinBoolean =  false
        if let address = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?, let theAddress = address.firstObject as? NSData {
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if getnameinfo(theAddress.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theAddress.length), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                let numAddress = String(cString: hostname)
                return numAddress
            }
            return nil
        }

        return nil
    }

//        static func getNetworkType() -> String?{
//            let info = CTTelephonyNetworkInfo()
//            if let carrier = info.subscriberCellularProvider {
//                if let currentRadioTech = info.currentRadioAccessTechnology{
//                    /// 运营商名字 + 数据业务信息
//                    let tmp = "\(carrier.carrierName ?? ""):\(currentRadioTech)"
//                    tmp.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
//                    return tmp
//                }
//                 return nil
//
//            }
//            return nil
//        }
//    
//    /// 设备运营商IP（联通/移动/电信的运营商给的移动IP）
//    static func deviceIP() -> String? {
//        var addresses = [String]()
//        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
//        if getifaddrs(&ifaddr) == 0 {
//            var ptr = ifaddr
//            while (ptr != nil) {
//                let flags = Int32(ptr!.pointee.ifa_flags)
//                var addr = ptr!.pointee.ifa_addr.pointee
//                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
//                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
//                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
//                            if let address = String(validatingUTF8:hostname) {
//                                addresses.append(address)
//                            }
//                        }
//                    }
//                }
//                ptr = ptr!.pointee.ifa_next
//            }
//            freeifaddrs(ifaddr)
//        }
//        return addresses.first
//    }
//
//    /// WiFi获得的IP 192.168.xx.xx
//    static func wifiIP() -> String? {
//        var address: String?
//        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
//        guard getifaddrs(&ifaddr) == 0 else {
//            return nil
//        }
//        guard let firstAddr = ifaddr else {
//            return nil
//        }
//
//        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
//            let interface = ifptr.pointee
//            // Check for IPV4 or IPV6 interface
//            let addrFamily = interface.ifa_addr.pointee.sa_family
//            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
//                // Check interface name
//                let name = String(cString: interface.ifa_name)
//                if name == "en0" {
//                    // Convert interface address to a human readable string
//                    var addr = interface.ifa_addr.pointee
//                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                    getnameinfo(&addr,socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
//                    address = String(cString: hostName)
//                }
//            }
//        }
//
//        freeifaddrs(ifaddr)
//        return address
//    }
}

