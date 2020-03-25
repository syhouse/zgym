//
//  String+SLCategory.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/4.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import Foundation

extension String {
    func sl_Date() -> Date{
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self) ?? Date()
    }
    
    func sl_DayTime() -> String{
        let date = self.sl_Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "MM.dd HH:mm"
        return formatter.string(from: date)
    }
    
    func sl_Time() -> String{
        return Date.sl_Time(date: self.sl_Date())
    }
    
    func sl_tomorrow() -> String{
        var interval = sl_Date().timeIntervalSinceNow
        interval += 24*60*60
        let dateTmp: Date = Date(timeIntervalSinceNow: interval)
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: dateTmp)
    }
    
    func sl_numberOfChars() -> Int {
        var bCount = 0
        for char in self.charactersArray {
            // 判断是否中文，是中文+2 ，不是+1
            bCount += "\(char)".lengthOfBytes(using: String.Encoding.utf8) == 3 ? 2 : 1
        }
        return bCount
    }
    
    func sl_lengtToChars(length: Int) -> String {
        var curruntLength = 0
        var characters = [Character]()
        for char in self.charactersArray {
            // 判断是否中文，是中文+2 ，不是+1
            curruntLength += "\(char)".lengthOfBytes(using: String.Encoding.utf8) == 3 ? 2 : 1
            if curruntLength > length{
                break
            }
            characters.append(char)
        }
        return String(characters)
    }
    
    // 计算文字高度
    func sl_getTextRectSize(font:UIFont,size:CGSize) -> CGRect {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect;
    }
    
    /// 获取文字宽度
    /// - Parameter textStr: 文本
    /// - Parameter font: 字体
    /// - Parameter width: 宽度
    func sl_getTextWidth(font : UIFont, height : CGFloat) -> CGFloat{
        
        let normalText : NSString = self as NSString
        
        let size = CGSize(width: 10000, height:height)//CGSizeMake(width,1000)
        
        let dic = NSDictionary(object: font, forKey : kCTFontAttributeName as! NSCopying)
        
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key:Any], context:nil).size
        
        return stringSize.width
        
    }
    
    /// 拼接视频缩略图
    func sl_getVediUrlImage(width: Int = 300, height: Int = 300) -> String {
        let str: String = ((self as NSString).replacingOccurrences(of: ".mp4", with: "_1.jpg") as String) + NSUtil.sl_imageThumbnail(width: width, height: height)
        return str;
    }
    
    
    func sl_getImageThumbnail(width: Int = 300, height: Int = 300) -> String {
        return self + NSUtil.sl_imageThumbnail(width: width, height: height);
    }
    
    
    /// 移除空格
    func removeSpace() -> String{
        var text = self
        text.removeAll(where: { (char) -> Bool in
            return char == " " || char == "\n"
        })
        return text
    }
    
    func sl_RelationshipValue() -> String{
        switch self {
        case "MOM":
            return "妈妈"
        case "DAD":
            return "爸爸"
        case "GRANDPA":
            return "爷爷"
        case "GRANDMA":
            return "奶奶"
        case "BROTHER":
            return "哥哥"
        case "SISTER":
            return "姐姐"
        case "UNCLE":
            return "叔叔"
        case "MATERNAL_AUNT":
            return "阿姨"
        case "AUNT":
            return "姑姑"
        case "FATHER_ELDER_BROTHER":
            return "伯伯"
        default:
            return ""
        }
    }
}


extension String {
    //使用正则表达式替换
    func sl_pregReplace(pattern: String, with: String,
                        options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
    
    //是否为空
    var isBlank: Bool {
        let trimmedStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedStr.isEmpty
    }
}
