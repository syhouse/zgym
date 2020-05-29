//
//  YXSSolitaireModel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/16.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import ObjectMapper


class YXSSolitaireModel : NSObject,NSCopying, NSCoding, Mappable{
    func copy(with zone: NSZone? = nil) -> Any {
        let theCopyObj = YXSSolitaireModel.init(JSON: self.toJSON())!
        return theCopyObj
    }
    
    var censusId : Int?
    var classId : Int?
    var className : String?
    var committedSum : Int?
    var content : String?
    var endTime : String?
    var isTop : Int?
    // 老师 接龙状态（0 全部 10 正在接龙 100 已结束:按照接龙的结束时间 ）
    //家长 0 全部 10 未接 20 已接龙 100 已结束:按照接龙的结束时间）
    var state : Int?
    var teacherId : Int?
    var myPublish : Bool?
    var teacherName : String?
    var createTime : String?
    
    var childrenId : Int?
    var commitUpperLimit : Int?
    var isShowAll: Bool = false
    
    var needShowAllButton: Bool = false
    // MARK: - 高度缓存
     ///缓存高度
     var height: CGFloat{
         get{
             if frameModel == nil{
                 confingHeight()
             }
             
             //bg容器顶部高度
            var height: CGFloat = 14
             
            height += 45.5


             if needShowAllButton{
                 height += 25 + 9
             }
  
             if self.isShowAll{
                 height += frameModel.contentIsShowAllHeight
                 
             }else{
                 height += frameModel.contentHeight
             }
             
             
             ///底部高度
             height += 90.5
            
            //?
             height += 14
             return height
         }
     }
     
     /// frameModel
     var frameModel:YXSFriendsCircleFrameModel!

     var contentLabelWidth : CGFloat{
         return SCREEN_WIDTH - 30 - (15 + 18)
     }
    
    func confingHeight(){

        frameModel = YXSFriendsCircleFrameModel()
        let paragraphStye = NSMutableParagraphStyle()
        //调整行间距
        paragraphStye.lineSpacing = kMainContentLineHeight
        paragraphStye.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedString.Key.paragraphStyle:paragraphStye, NSAttributedString.Key.font: kTextMainBodyFont]
        frameModel.contentIsShowAllHeight = UIUtil.yxs_getTextHeigh(textStr: content?.listReplaceSpaceAndReturn() ?? "", attributes: attributes , width: contentLabelWidth)
        frameModel.contentHeight = UIUtil.yxs_getTextHeigh(textStr: content?.listReplaceSpaceAndReturn() ?? "", attributes: attributes,width: contentLabelWidth, numberOfLines: 2) + 1
        needShowAllButton = frameModel.contentIsShowAllHeight > 50  ? true : false
    }
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        censusId <- map["censusId"]
        classId <- map["classId"]
        className <- map["className"]
        committedSum <- map["committedSum"]
        content <- map["content"]
        endTime <- map["endTime"]
        isTop <- map["isTop"]
        state <- map["state"]
        teacherId <- map["teacherId"]
        myPublish <- map["myPublish"]
        teacherName <- map["teacherName"]
        childrenId <- map["childrenId"]
        commitUpperLimit <- map["commitUpperLimit"]
        createTime <- map["createTime"]
        
        confingHeight()
        
    }
    
    @objc required init(coder aDecoder: NSCoder)
    {
        censusId = aDecoder.decodeObject(forKey: "censusId") as? Int
        classId = aDecoder.decodeObject(forKey: "classId") as? Int
        className = aDecoder.decodeObject(forKey: "className") as? String
        committedSum = aDecoder.decodeObject(forKey: "committedSum") as? Int
        content = aDecoder.decodeObject(forKey: "content") as? String
        createTime = aDecoder.decodeObject(forKey: "createTime") as? String
        endTime = aDecoder.decodeObject(forKey: "endTime") as? String
        isTop = aDecoder.decodeObject(forKey: "isTop") as? Int
        myPublish = aDecoder.decodeObject(forKey: "myPublish") as? Bool
        state = aDecoder.decodeObject(forKey: "state") as? Int
        teacherId = aDecoder.decodeObject(forKey: "teacherId") as? Int
        teacherName = aDecoder.decodeObject(forKey: "teacherName") as? String
        commitUpperLimit = aDecoder.decodeObject(forKey: "commitUpperLimit") as? Int
        frameModel = aDecoder.decodeObject(forKey: "frameModel") as? YXSFriendsCircleFrameModel
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if censusId != nil{
            aCoder.encode(censusId, forKey: "censusId")
        }
        if classId != nil{
            aCoder.encode(classId, forKey: "classId")
        }
        if className != nil{
            aCoder.encode(className, forKey: "className")
        }
        if committedSum != nil{
            aCoder.encode(committedSum, forKey: "committedSum")
        }
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if endTime != nil{
            aCoder.encode(endTime, forKey: "endTime")
        }
        if isTop != nil{
            aCoder.encode(isTop, forKey: "isTop")
        }
        if myPublish != nil{
            aCoder.encode(myPublish, forKey: "myPublish")
        }
        if state != nil{
            aCoder.encode(state, forKey: "state")
        }
        if teacherId != nil{
            aCoder.encode(teacherId, forKey: "teacherId")
        }
        if teacherName != nil{
            aCoder.encode(teacherName, forKey: "teacherName")
        }
        if commitUpperLimit != nil{
            aCoder.encode(commitUpperLimit, forKey: "commitUpperLimit")
        }
        if frameModel != nil{
            aCoder.encode(frameModel, forKey: "frameModel")
        }

    }
    
}

