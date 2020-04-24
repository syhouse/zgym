//
//  YXSPublishModel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/26.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import Photos

class YXSPublishModel: NSObject, NSCoding {
    var classs:[YXSClassModel]!
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
    var sourceDirectory = YXSCacheDirectory.HomeWork
    
    var publishLink: String!
    
    var audioModels: [SLAudioModel] = [SLAudioModel]()
    
    var localIdentifiers: [String]!
    
    
    /// 打卡天数
    var punchCardDay: YXSPunchCardDay!
    
    
    ///接龙人数
    var solitaireStudents: YXSPunchCardDay!
    
    var punchCardWeaks: [YXSPunchCardWeak]?
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
    
    /// 接龙截止日期
    var solitaireDate: Date?
    
    /// 作业截止日期
    var homeworkDate: Date? {
        didSet {
            //超过3个月为不限时
            if let date = homeworkDate {
                homeworkDateIsUnlimited = date.yxs_isDifferWithMonth(month: 3) ?? false
            }
        }
    }
    
    /// 作业截止日期是否为不限时
    var homeworkDateIsUnlimited: Bool = false
    
    /// 作业是否可见
    var homeworkAllowLook: Bool = false
    
    /// 点评是否相互可见
    var homeworkCommentAllowLook: Bool = false
    
    /// 是否允许补卡
    var isAllowPatch: Bool = true
    
    
    /// 提醒打卡时间
    var remindPanchCardTime: String!
    
    
    /// 补卡日期
    var patchCardTime: String!
    
    /// 班级总人数
    var commitUpperLimit: Int?
    
    override init() {
        super.init()
    }
    
    var medias: [SLPublishMediaModel]!
    @objc required init(coder aDecoder: NSCoder)
    {
        classs = aDecoder.decodeObject(forKey: "classs") as? [YXSClassModel]
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
        punchCardDay = aDecoder.decodeObject(forKey: "punchCardDay") as? YXSPunchCardDay
        localIdentifiers = aDecoder.decodeObject(forKey: "localIdentifiers") as? [String]
        punchCardWeaks = aDecoder.decodeObject(forKey: "punchCardWeaks") as? [YXSPunchCardWeak]
        solitaireSelects = aDecoder.decodeObject(forKey: "solitaireSelects") as? [SolitairePublishSelectModel]
        solitaireDate = aDecoder.decodeObject(forKey: "solitaireDate") as? Date
        medias = aDecoder.decodeObject(forKey: "medias") as? [SLPublishMediaModel] ?? [SLPublishMediaModel]()
        remindPanchCardTime = aDecoder.decodeObject(forKey: "remindPanchCardTime") as? String ?? "18:00"
        isAllowPatch = aDecoder.decodeBool(forKey: "isAllowPatch")
        patchCardTime = aDecoder.decodeObject(forKey: "patchCardTime") as? String
        
        homeworkDate = aDecoder.decodeObject(forKey: "homeworkDate") as? Date
        homeworkAllowLook = aDecoder.decodeBool(forKey: "homeworkAllowLook")
        homeworkCommentAllowLook = aDecoder.decodeBool(forKey: "homeworkCommentAllowLook")
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
        
        aCoder.encode(remindPanchCardTime, forKey: "remindPanchCardTime")
        aCoder.encode(isAllowPatch, forKey: "isAllowPatch")
        if patchCardTime != nil{
            aCoder.encode(patchCardTime, forKey: "patchCardTime")
        }
        
        aCoder.encode(homeworkDate, forKey: "homeworkDate")
        aCoder.encode(homeworkAllowLook, forKey: "homeworkAllowLook")
        aCoder.encode(homeworkCommentAllowLook, forKey: "homeworkCommentAllowLook")
    }
}


class SLPublishEditModel: YXSPublishModel {
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


