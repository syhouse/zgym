//
//  SLClassStarChildrenModel.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/9.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//
import Foundation
import ObjectMapper


class SLClassStarChildrenModel : NSObject, NSCoding, Mappable{

    var avatar : String?
    var childrenId : Int?
    var childrenName : String?
    var firstName : String?
    var improveScore : Int?
    var praiseScore : Int?
    var score : Int?
    var studentId : String?
    var topNo : Int?
    var topPercent : String?
    
    var stageType: StageType!
    var averageScore : String?
    
    var hasImproveComment: Bool{
        get{
            if let improveScore = improveScore,improveScore != 0{
                return true
            }
            return false
        }
    }
    var hasPraiseComment: Bool{
        get{
            if let praiseScore = praiseScore,praiseScore != 0{
                return true
            }
            return false
        }
    }
    var isSelect : Bool = false
    ///是否编辑多选
    var isEdit : Bool = false
    
    ///是否是全班
    var isAllChildren : Bool = false
    
    ///是否展示评分动画
    var isShowScoreAnimal: Bool = false
    
    ///评分值
    var scoreAnimalValue: Int = 0
    
    var dateType: DateType = .W
    var dateText:String{
        get{
            NSUtil.sl_getDateText(dateType: dateType)
        }
    }

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        avatar <- map["avatar"]
        childrenId <- map["childrenId"]
        childrenName <- map["childrenName"]
        firstName <- map["firstName"]
        improveScore <- map["improveScore"]
        praiseScore <- map["praiseScore"]
        score <- map["score"]
        studentId <- map["studentId"]
        topNo <- map["topNo"]
        averageScore <- map["averageScore"]
        topPercent <- map["topPercent"]
    }
    
    @objc required init(coder aDecoder: NSCoder)
        {

            avatar = aDecoder.decodeObject(forKey: "avatar") as? String
            childrenId = aDecoder.decodeObject(forKey: "childrenId") as? Int
            childrenName = aDecoder.decodeObject(forKey: "childrenName") as? String
            firstName = aDecoder.decodeObject(forKey: "firstName") as? String
            improveScore = aDecoder.decodeObject(forKey: "improveScore") as? Int
            praiseScore = aDecoder.decodeObject(forKey: "praiseScore") as? Int
            score = aDecoder.decodeObject(forKey: "score") as? Int
            studentId = aDecoder.decodeObject(forKey: "studentId") as? String
            topNo = aDecoder.decodeObject(forKey: "topNo") as? Int
            topPercent = aDecoder.decodeObject(forKey: "topPercent") as? String
            stageType = aDecoder.decodeObject(forKey: "stageType") as? StageType
            averageScore = aDecoder.decodeObject(forKey: "averageScore") as? String
        }
        
        /**
         * NSCoding required method.
         * Encodes mode properties into the decoder
         */
        @objc func encode(with aCoder: NSCoder)
        {
            if avatar != nil{
                aCoder.encode(avatar, forKey: "avatar")
            }
            if childrenId != nil{
                aCoder.encode(childrenId, forKey: "childrenId")
            }
            if childrenName != nil{
                aCoder.encode(childrenName, forKey: "childrenName")
            }
            if firstName != nil{
                aCoder.encode(firstName, forKey: "firstName")
            }
            if improveScore != nil{
                aCoder.encode(improveScore, forKey: "improveScore")
            }
            if praiseScore != nil{
                aCoder.encode(praiseScore, forKey: "praiseScore")
            }
            if score != nil{
                aCoder.encode(score, forKey: "score")
            }
            if studentId != nil{
                aCoder.encode(studentId, forKey: "studentId")
            }
            if topNo != nil{
                aCoder.encode(topNo, forKey: "topNo")
            }
            if topPercent != nil{
                aCoder.encode(topPercent, forKey: "topPercent")
            }
            if stageType != nil{
                aCoder.encode(stageType, forKey: "stageType")
            }
            if averageScore != nil{
                aCoder.encode(averageScore, forKey: "averageScore")
            }
        }
}
