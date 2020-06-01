//
//  YXSSolitaireTemplateDetialModel.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/29.
//  Copyright © 2020 zgym. All rights reserved.
//
import Foundation
import ObjectMapper


class YXSSolitaireTemplateDetialModel : NSObject, NSCoding, Mappable{
    var audioDuration : Int?
    var audioUrl : String?
    var bgUrl : String?
    var content : String?
    var createTime : String?
    var icon : String?
    var id : Int?
    var imageUrl : String?
    var jsonData : String?{
        didSet{
            gatherHoldersModel = YXSSolitaireGatherHoldersModel.init(JSONString: jsonData ?? "")
            
        }
    }
    var name : String?
    var options : String?
    var title : String?
    ///1老版本接龙  2新版本接龙报名 3新版本接龙采集 (1普通(old) 2普通(new) 3调查卷)
    var type : Int?
    var videoUrl : String?
    
    var gatherHoldersModel: YXSSolitaireGatherHoldersModel?
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        audioDuration <- map["audioDuration"]
        audioUrl <- map["audioUrl"]
        bgUrl <- map["bgUrl"]
        content <- map["content"]
        createTime <- map["createTime"]
        icon <- map["icon"]
        id <- map["id"]
        imageUrl <- map["imageUrl"]
        jsonData <- map["jsonData"]
        name <- map["name"]
        options <- map["options"]
        title <- map["title"]
        type <- map["type"]
        videoUrl <- map["videoUrl"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        audioDuration = aDecoder.decodeObject(forKey: "audioDuration") as? Int
        audioUrl = aDecoder.decodeObject(forKey: "audioUrl") as? String
        bgUrl = aDecoder.decodeObject(forKey: "bgUrl") as? String
        content = aDecoder.decodeObject(forKey: "content") as? String
        createTime = aDecoder.decodeObject(forKey: "createTime") as? String
        icon = aDecoder.decodeObject(forKey: "icon") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? String
        jsonData = aDecoder.decodeObject(forKey: "jsonData") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        options = aDecoder.decodeObject(forKey: "options") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        type = aDecoder.decodeObject(forKey: "type") as? Int
        videoUrl = aDecoder.decodeObject(forKey: "videoUrl") as? String
        gatherHoldersModel = aDecoder.decodeObject(forKey: "gatherHoldersModel") as? YXSSolitaireGatherHoldersModel
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if audioDuration != nil{
            aCoder.encode(audioDuration, forKey: "audioDuration")
        }
        if audioUrl != nil{
            aCoder.encode(audioUrl, forKey: "audioUrl")
        }
        if bgUrl != nil{
            aCoder.encode(bgUrl, forKey: "bgUrl")
        }
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if icon != nil{
            aCoder.encode(icon, forKey: "icon")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if imageUrl != nil{
            aCoder.encode(imageUrl, forKey: "imageUrl")
        }
        if jsonData != nil{
            aCoder.encode(jsonData, forKey: "jsonData")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if options != nil{
            aCoder.encode(options, forKey: "options")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if videoUrl != nil{
            aCoder.encode(videoUrl, forKey: "videoUrl")
        }
        if gatherHoldersModel != nil{
            aCoder.encode(gatherHoldersModel, forKey: "gatherHoldersModel")
        }
    }
}



class YXSSolitaireGatherHoldersModel : NSObject, NSCoding, Mappable{
    var gatherHolders : [YXSGatherHolder]?
    var gatherId : Int?
    
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        gatherHolders <- map["gatherHolders"]
        gatherId <- map["gatherId"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        gatherHolders = aDecoder.decodeObject(forKey: "gatherHolders") as? [YXSGatherHolder]
        gatherId = aDecoder.decodeObject(forKey: "gatherId") as? Int
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if gatherHolders != nil{
            aCoder.encode(gatherHolders, forKey: "gatherHolders")
        }
        if gatherId != nil{
            aCoder.encode(gatherId, forKey: "gatherId")
        }
        
    }
    
}


class YXSGatherHolder : NSObject, NSCoding, Mappable{
    
    var gatherHolderItemJson : String?{
        didSet{
            gatherHolderItem = YXSGatherHolderItem.init(JSONString: gatherHolderItemJson ?? "")
        }
    }
    
    
    var gatherType : String?
    
    var gatherHolderItem: YXSGatherHolderItem?
    
    var questionType: YXSQuestionType{
        get{
            return YXSQuestionType.init(rawValue: gatherType ?? "") ?? YXSQuestionType.single
        }
    }
    
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        gatherHolderItemJson <- map["gatherHolderItemJson"]
        gatherType <- map["gatherType"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        gatherHolderItemJson = aDecoder.decodeObject(forKey: "gatherHolderItemJson") as? String
        gatherType = aDecoder.decodeObject(forKey: "gatherType") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if gatherHolderItemJson != nil{
            aCoder.encode(gatherHolderItemJson, forKey: "gatherHolderItemJson")
        }
        if gatherType != nil{
            aCoder.encode(gatherType, forKey: "gatherType")
        }
        
    }
    
}

class YXSGatherHolderItem : NSObject, NSCoding, Mappable{
    
    var censusTopicOptionItems : [YXSGatherHolderOptionItem]?
    var gatherType : String?
    var isRequired : Bool?
    var topicTitle : String?
    
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        censusTopicOptionItems <- map["censusTopicOptionItems"]
        gatherType <- map["gatherType"]
        isRequired <- map["isRequired"]
        topicTitle <- map["topicTitle"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        censusTopicOptionItems = aDecoder.decodeObject(forKey: "censusTopicOptionItems") as? [YXSGatherHolderOptionItem]
        gatherType = aDecoder.decodeObject(forKey: "gatherType") as? String
        isRequired = aDecoder.decodeObject(forKey: "isRequired") as? Bool
        topicTitle = aDecoder.decodeObject(forKey: "topicTitle") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if censusTopicOptionItems != nil{
            aCoder.encode(censusTopicOptionItems, forKey: "censusTopicOptionItems")
        }
        if gatherType != nil{
            aCoder.encode(gatherType, forKey: "gatherType")
        }
        if isRequired != nil{
            aCoder.encode(isRequired, forKey: "isRequired")
        }
        if topicTitle != nil{
            aCoder.encode(topicTitle, forKey: "topicTitle")
        }
        
    }
    
}

class YXSGatherHolderOptionItem : NSObject, NSCoding, Mappable{
    var gatherType : String?
    
    var optionContext: String?
    
    var optionImage: String?
    
    var optionName: String?
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        gatherType <- map["gatherType"]
        optionContext <- map["optionContext"]
        optionImage <- map["optionImage"]
        optionName <- map["optionName"]
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        optionName = aDecoder.decodeObject(forKey: "optionName") as? String
        optionContext = aDecoder.decodeObject(forKey: "optionContext") as? String
        gatherType = aDecoder.decodeObject(forKey: "gatherType") as? String
        optionImage = aDecoder.decodeObject(forKey: "optionImage") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if optionImage != nil{
            aCoder.encode(optionImage, forKey: "optionImage")
        }
        if optionName != nil{
            aCoder.encode(optionName, forKey: "optionName")
        }
        if optionContext != nil{
            aCoder.encode(optionContext, forKey: "optionContext")
        }
        if gatherType != nil{
            aCoder.encode(gatherType, forKey: "gatherType")
        }
        
    }
    
}
