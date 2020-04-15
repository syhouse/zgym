//
//  SLAgendaListModel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/21.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import ObjectMapper

class  AgendaRedModel : NSObject, Mappable{

    var count : Int?
    var allCount : Int?
    var serviceType : Int?

    required init?(map: Map){}
    private override init(){}
    func mapping(map: Map)
    {
        count <- map["count"]
        allCount <- map["allCount"]
        serviceType <- map["serviceType"]
    }
}

class  YXSAgendaListModel : NSObject{

    var count : Int = 0
    var allCount : Int = 0
    var image: String  = ""
    var title: String  = ""
    var eventType: YXSHomeType = .homework
    var desTitle:String{
        get{
            if allCount > 0{
                return "\(allCount)项任务进行中"
            }else{
                return ""
            }
        }
    }

}
