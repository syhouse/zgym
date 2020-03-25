//
//  SLAgendaListModel.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/21.
//  Copyright © 2019 hnsl_mac. All rights reserved.
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

class  SLAgendaListModel : NSObject{

    var count : Int = 0
    var allCount : Int = 0
    var image: String  = ""
    var title: String  = ""
    var eventType: HomeType = .homework
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
