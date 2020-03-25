//
//  SLPublishModel.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/26.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import Photos

class SLPublishModel: NSObject, NSCoding {
    var classs:[SLClassModel]!
    //发布内容文本
    var publishText: String?
    //主题文本
    var subjectText: String?
    
    //是否置顶
    var isTop: Bool = false
    
    //是否需要家长在线提交
    var isPartentSetUp: Bool = false
    //是否需要回执
    var needReceipt: Bool = false
    
    //是否可以评论
    var noComment: Bool = false
     ///发布资源类型
    var publishSource = [PublishSource]()
    //是否是朋友圈发布
    var isFriendCiclePublish: Bool = false
    
    //缓存文件类型
    var sourceDirectory = SLCacheDirectory.HomeWork
    
    var publishLink: String!
    
    var audioModels: [SLAudioModel] = [SLAudioModel]()
    
    var localIdentifiers: [String]!
    
    
    /// 打卡天数
    var punchCardDay: PunchCardDay!
    
    
    ///接龙人数
    var solitaireStudents: PunchCardDay!
    
    var punchCardWeaks: [PunchCardWeak]?
    var periodList: [Int]{
        get{
            var list = [Int]()
            if let punchCardWeaks = punchCardWeaks{
                
                for model in punchCardWeaks{
                    list.append(model.paramsKey)
                }
            }
            return list
        }
    }
    
    var solitaireSelects:[SolitairePublishSelectModel]?
    var solitaireDate: Date?
    
    /// 班级总人数
    var commitUpperLimit: Int?
    
    override init() {
        super.init()
    }
    
    var medias: [SLPublishMediaModel]!
    @objc required init(coder aDecoder: NSCoder)
    {
        classs = aDecoder.decodeObject(forKey: "classs") as? [SLClassModel]
        publishText = aDecoder.decodeObject(forKey: "publishText") as? String
        subjectText = aDecoder.decodeObject(forKey: "subjectText") as? String
        isTop = aDecoder.decodeBool(forKey: "isTop")
        isPartentSetUp = aDecoder.decodeBool(forKey: "isPartentSetUp")
        needReceipt = aDecoder.decodeBool(forKey: "needReceipt")
        noComment = aDecoder.decodeBool(forKey: "noComment")
        isFriendCiclePublish = aDecoder.decodeBool(forKey: "isFriendCiclePublish")
        
        
        
        let sources = aDecoder.decodeObject(forKey: "publishSource") as? [Int] ?? [Int]()
        publishSource = [PublishSource]()
        for item in sources{
            publishSource.append(PublishSource.init(rawValue: item) ?? .none)
        }
        publishLink = aDecoder.decodeObject(forKey: "publishLink") as? String
       
        audioModels = aDecoder.decodeObject(forKey: "audioModels") as? [SLAudioModel] ?? [SLAudioModel]()
        punchCardDay = aDecoder.decodeObject(forKey: "punchCardDay") as? PunchCardDay
        localIdentifiers = aDecoder.decodeObject(forKey: "localIdentifiers") as? [String]
        punchCardWeaks = aDecoder.decodeObject(forKey: "punchCardWeaks") as? [PunchCardWeak]
        solitaireSelects = aDecoder.decodeObject(forKey: "solitaireSelects") as? [SolitairePublishSelectModel]
        solitaireDate = aDecoder.decodeObject(forKey: "solitaireDate") as? Date
        medias = aDecoder.decodeObject(forKey: "medias") as? [SLPublishMediaModel] ?? [SLPublishMediaModel]()

    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if classs != nil{
            aCoder.encode(classs, forKey: "classs")
        }
        if publishText != nil{
            aCoder.encode(publishText, forKey: "publishText")
        }
        if subjectText != nil{
            aCoder.encode(subjectText, forKey: "subjectText")
        }
        
        aCoder.encode(isTop, forKey: "isTop")
        aCoder.encode(isPartentSetUp, forKey: "isPartentSetUp")
        aCoder.encode(needReceipt, forKey: "needReceipt")
        aCoder.encode(noComment, forKey: "noComment")
        aCoder.encode(isFriendCiclePublish, forKey: "isFriendCiclePublish")
        
        var sources = [Int]()
        for item in publishSource{
            sources.append(item.rawValue)
        }
        aCoder.encode(sources, forKey: "publishSource")
        if publishLink != nil{
            aCoder.encode(publishLink, forKey: "publishLink")
        }
        aCoder.encode(audioModels, forKey: "audioModels")
        if punchCardDay != nil{
            aCoder.encode(punchCardDay, forKey: "punchCardDay")
        }
        if localIdentifiers != nil{
            aCoder.encode(localIdentifiers, forKey: "localIdentifiers")
        }
        if punchCardWeaks != nil{
            aCoder.encode(punchCardWeaks, forKey: "punchCardWeaks")
        }
        if solitaireDate != nil{
            aCoder.encode(solitaireDate, forKey: "solitaireDate")
        }
        if solitaireSelects != nil{
            aCoder.encode(solitaireSelects, forKey: "solitaireSelects")
        }
        if medias != nil{
            aCoder.encode(medias, forKey: "medias")
        }
    }
}


class SLPublishEditModel: SLPublishModel {
    var bgUrl: String?
    var videoUrl: String?
    var imageUrl: String?
    override init() {
        super.init()
    }
    
    @objc required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
//        solitaireDate = aDecoder.decodeObject(forKey: "solitaireDate") as? Date
        

    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc override func encode(with aCoder: NSCoder)
    {
        super.encode(with: aCoder)
//        if solitaireSelects != nil{
//            aCoder.encode(solitaireSelects, forKey: "solitaireSelects")
//        }
    }
}


