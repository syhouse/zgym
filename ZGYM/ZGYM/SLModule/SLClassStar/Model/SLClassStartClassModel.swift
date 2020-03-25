//
//  SLClassStartClassModel.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/5.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//
import Foundation
import ObjectMapper

//   @ApiModelProperty(value = "日期过滤类型（D今日 W 本周 M 本月 Y 本年）")
//    private String dateType;
enum DateType: String{
    case D
    case W
    case M
    case Y
}

class SLClassStartClassModel : NSObject, Mappable{
    
    var averageScore : String?
    var classChildrenSum : Int?
    var classId : Int?
    var className : String?
    var classNo : String?
    var improveScore : Int?
    var praiseScore : Int?
    var score : Int?  //得分
    var stage : String?
    
    var stageType: StageType{
        get{
            StageType.init(rawValue: stage ?? "") ?? .KINDERGARTEN
        }
    }
    //是否有评论
    var hasComment: Bool{
        get{
            return averageScore == nil ? false : true
        }
    }
    var dateType: DateType = .W
    var dateText:String{
        get{
            NSUtil.sl_getDateText(dateType: dateType)
        }
    }
    var topStudent: ClassStarBestModel?
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        averageScore <- map["averageScore"]
        classChildrenSum <- map["classChildrenSum"]
        classId <- map["classId"]
        className <- map["className"]
        classNo <- map["classNo"]
        improveScore <- map["improveScore"]
        praiseScore <- map["praiseScore"]
        score <- map["score"]
        stage <- map["stage"]
    }
}
