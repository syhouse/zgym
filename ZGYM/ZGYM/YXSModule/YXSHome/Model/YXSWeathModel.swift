//
//  YXSWeathModel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/24.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import ObjectMapper


class YXSWeathModel : NSObject,NSCoding , Mappable{
    var air : String?
    var airLevel : String?
    var airPm25 : String?
    var airTips : String?
    var city : String?
    var cityEn : String?
    var cityid : String?
    var country : String?
    var countryEn : String?
    var date : String?
    var humidity : String?
    var pressure : String?
    var tem : String?
    var tem1 : String?
    var tem2 : String?
    var updateTime : String?
    var visibility : String?
    var wea : String?
    var weaImg : String?
    var week : String?
    var win : String?
    var winMeter : String?
    var winSpeed : String?
    
    
    /// 天气请求时间
    var curruntRequestData: Date?
    
    /// 天气请求时间
    var isToDay: Bool{
        get {
            return curruntRequestData == nil ? false : NSUtil.yxs_isSameDay(curruntRequestData ?? Date(), date2: Date())
        }
    }
    
    ///天气请求失败
    var loadFailure: Bool = false
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        air <- map["air"]
        airLevel <- map["air_level"]
        airPm25 <- map["air_pm25"]
        airTips <- map["air_tips"]
        city <- map["city"]
        cityEn <- map["cityEn"]
        cityid <- map["cityid"]
        country <- map["country"]
        countryEn <- map["countryEn"]
        date <- map["date"]
        humidity <- map["humidity"]
        pressure <- map["pressure"]
        tem <- map["tem"]
        tem1 <- map["tem1"]
        tem2 <- map["tem2"]
        updateTime <- map["update_time"]
        visibility <- map["visibility"]
        wea <- map["wea"]
        weaImg <- map["wea_img"]
        week <- map["week"]
        win <- map["win"]
        winMeter <- map["win_meter"]
        winSpeed <- map["win_speed"]
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        air = aDecoder.decodeObject(forKey: "air") as? String
        airLevel = aDecoder.decodeObject(forKey: "air_level") as? String
        airPm25 = aDecoder.decodeObject(forKey: "air_pm25") as? String
        airTips = aDecoder.decodeObject(forKey: "air_tips") as? String
        city = aDecoder.decodeObject(forKey: "city") as? String
        cityEn = aDecoder.decodeObject(forKey: "cityEn") as? String
        cityid = aDecoder.decodeObject(forKey: "cityid") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
        countryEn = aDecoder.decodeObject(forKey: "countryEn") as? String
        date = aDecoder.decodeObject(forKey: "date") as? String
        humidity = aDecoder.decodeObject(forKey: "humidity") as? String
        pressure = aDecoder.decodeObject(forKey: "pressure") as? String
        tem = aDecoder.decodeObject(forKey: "tem") as? String
        tem1 = aDecoder.decodeObject(forKey: "tem1") as? String
        tem2 = aDecoder.decodeObject(forKey: "tem2") as? String
        updateTime = aDecoder.decodeObject(forKey: "update_time") as? String
        visibility = aDecoder.decodeObject(forKey: "visibility") as? String
        wea = aDecoder.decodeObject(forKey: "wea") as? String
        weaImg = aDecoder.decodeObject(forKey: "wea_img") as? String
        week = aDecoder.decodeObject(forKey: "week") as? String
        win = aDecoder.decodeObject(forKey: "win") as? String
        winMeter = aDecoder.decodeObject(forKey: "win_meter") as? String
        winSpeed = aDecoder.decodeObject(forKey: "win_speed") as? String
        curruntRequestData = aDecoder.decodeObject(forKey: "curruntRequestData") as? Date
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if air != nil{
            aCoder.encode(air, forKey: "air")
        }
        if airLevel != nil{
            aCoder.encode(airLevel, forKey: "air_level")
        }
        if airPm25 != nil{
            aCoder.encode(airPm25, forKey: "air_pm25")
        }
        if airTips != nil{
            aCoder.encode(airTips, forKey: "air_tips")
        }
        if city != nil{
            aCoder.encode(city, forKey: "city")
        }
        if cityEn != nil{
            aCoder.encode(cityEn, forKey: "cityEn")
        }
        if cityid != nil{
            aCoder.encode(cityid, forKey: "cityid")
        }
        if country != nil{
            aCoder.encode(country, forKey: "country")
        }
        if countryEn != nil{
            aCoder.encode(countryEn, forKey: "countryEn")
        }
        if date != nil{
            aCoder.encode(date, forKey: "date")
        }
        if humidity != nil{
            aCoder.encode(humidity, forKey: "humidity")
        }
        if pressure != nil{
            aCoder.encode(pressure, forKey: "pressure")
        }
        if tem != nil{
            aCoder.encode(tem, forKey: "tem")
        }
        if tem1 != nil{
            aCoder.encode(tem1, forKey: "tem1")
        }
        if tem2 != nil{
            aCoder.encode(tem2, forKey: "tem2")
        }
        if updateTime != nil{
            aCoder.encode(updateTime, forKey: "update_time")
        }
        if visibility != nil{
            aCoder.encode(visibility, forKey: "visibility")
        }
        if wea != nil{
            aCoder.encode(wea, forKey: "wea")
        }
        if weaImg != nil{
            aCoder.encode(weaImg, forKey: "wea_img")
        }
        if week != nil{
            aCoder.encode(week, forKey: "week")
        }
        if win != nil{
            aCoder.encode(win, forKey: "win")
        }
        if winMeter != nil{
            aCoder.encode(winMeter, forKey: "win_meter")
        }
        if winSpeed != nil{
            aCoder.encode(winSpeed, forKey: "win_speed")
        }
        if curruntRequestData != nil{
            aCoder.encode(curruntRequestData, forKey: "curruntRequestData")
        }
    }
}
