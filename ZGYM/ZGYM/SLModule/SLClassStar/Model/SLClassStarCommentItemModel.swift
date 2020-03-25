//
//  SLClassStarCommentItemModel.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/5.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import Foundation
import ObjectMapper

enum ClassStarCommentItemType: String{
    case Edit
    case Add
    case Delect
    case Service//服务端
}
class SLClassStarCommentItemModel : NSObject, Mappable{
    
    var category : Int?
    var evaluationItem : String?
    var evaluationUrl : String?
    var id : Int?
    var score : Int?
    var scoreDescribe : String?
    var evaluationType : String?//考评项类别id
    
    var type : String?{//考评项类别（10 系统 20 老师的所有班级 30 当前班级）
        didSet{
            if let type = type{
                if type == "10"{
                    itemIsSystem = true
                    return
                }
            }
            itemIsSystem = false
        }
    }
    
    var itemType: ClassStarCommentItemType = .Service
    var isSelected = false
    var isShowEdit = false
    var itemIsSystem: Bool = false
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        category <- map["category"]
        evaluationItem <- map["evaluationItem"]
        evaluationUrl <- map["evaluationUrl"]
        id <- map["id"]
        score <- map["score"]
        scoreDescribe <- map["scoreDescribe"]
        type <- map["type"]
        evaluationType <- map["evaluationType"]
    }
    
    static func getYMClassStarCommentItemModel(_ style: ClassStarCommentItemType, title: String) -> SLClassStarCommentItemModel{
        let model = SLClassStarCommentItemModel.init(JSON: ["": ""])!
        model.itemType = style
        model.evaluationItem = title
        return model
        //        #F3F5F9
    }
}
