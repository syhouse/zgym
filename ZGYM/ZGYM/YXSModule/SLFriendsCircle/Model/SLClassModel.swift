//
//  ClassModel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/18.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import ObjectMapper

class SLClassModel: NSObject, NSCoding, Mappable {
    
    /// 班级名称
    var name: String?
    var id : Int?
    var members : Int?
    var num : String?
    
    /// 当前学生名称
    var realName: String?
    var studentId: String?
    var childrenId: Int?
    
    // Custom
    var isSelect: Bool = false
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["id"]
        members <- map["members"]
        name <- map["name"]
        num <- map["num"]
        realName <- map["realName"]
        studentId <- map["studentId"]
        childrenId <- map["childrenId"]
    }
    
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? Int
        members = aDecoder.decodeObject(forKey: "members") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        num = aDecoder.decodeObject(forKey: "num") as? String
        isSelect = aDecoder.decodeBool(forKey: "isSelect")
        realName = aDecoder.decodeObject(forKey: "realName") as? String
        studentId = aDecoder.decodeObject(forKey: "studentId") as? String
        childrenId = aDecoder.decodeObject(forKey: "childrenId") as? Int
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
        if members != nil{
            aCoder.encode(members, forKey: "members")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if num != nil{
            aCoder.encode(num, forKey: "num")
        }
        if realName != nil{
            aCoder.encode(realName, forKey: "realName")
        }
        if studentId != nil{
            aCoder.encode(studentId, forKey: "studentId")
        }
        if childrenId != nil{
            aCoder.encode(studentId, forKey: "childrenId")
        }
        aCoder.encode(isSelect, forKey: "isSelect")
    }
    
}
