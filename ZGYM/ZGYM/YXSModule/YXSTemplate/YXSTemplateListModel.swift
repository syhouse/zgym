//
//	YXSTemplateListModel.swift

import Foundation 
import ObjectMapper

///标签or模版  没有tabId的是模版
class YXSTemplateListModel : NSObject, NSCoding, Mappable{
    var id : Int?
    var isRecommend : Int?
    var serviceType : Int?
    var tabId : Int?
    var title : String?
    var isSelected: Bool = false
    var icon: String?
    var tabName: String?
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["id"]
        isRecommend <- map["isRecommend"]
        serviceType <- map["serviceType"]
        tabId <- map["tabId"]
        title <- map["title"]
        icon <- map["icon"]
        tabName <- map["tabName"]
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? Int
        isRecommend = aDecoder.decodeObject(forKey: "isRecommend") as? Int
        serviceType = aDecoder.decodeObject(forKey: "serviceType") as? Int
        tabId = aDecoder.decodeObject(forKey: "tabId") as? Int
        title = aDecoder.decodeObject(forKey: "title") as? String
        isSelected = aDecoder.decodeBool(forKey: "isSelected")
        icon = aDecoder.decodeObject(forKey: "icon") as? String
        tabName = aDecoder.decodeObject(forKey: "tabName") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isRecommend != nil{
            aCoder.encode(isRecommend, forKey: "isRecommend")
        }
        if serviceType != nil{
            aCoder.encode(serviceType, forKey: "serviceType")
        }
        if tabId != nil{
            aCoder.encode(tabId, forKey: "tabId")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if icon != nil{
            aCoder.encode(icon, forKey: "icon")
        }
        if tabName != nil{
            aCoder.encode(tabName, forKey: "tabName")
        }
        aCoder.encode(isSelected, forKey: "isSelected")
    }
    
}
