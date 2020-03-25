//
//  ChildrenModel.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/22.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import Foundation
import ObjectMapper


class SLChildrenModel : NSObject, NSCoding, Mappable{
    
    var avatar : String?
    var id : Int?
    var realName : String?
    var studentId : String?
    var userId : Int?
    var grade : Grade?
    
    var stage: StageType{
        get{
            StageType.init(rawValue: grade?.stage ?? "") ?? .KINDERGARTEN
        }
    }
    
    var classId: Int?{
        get{
            return grade?.id
        }
    }
    var headmaster : Bool?
    var isSelect: Bool = false
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        avatar <- map["avatar"]
        id <- map["id"]
        realName <- map["realName"]
        studentId <- map["studentId"]
        userId <- map["userId"]
        grade <- map["grade"]
        headmaster <- map["headmaster"]
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        avatar = aDecoder.decodeObject(forKey: "avatar") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        realName = aDecoder.decodeObject(forKey: "realName") as? String
        studentId = aDecoder.decodeObject(forKey: "studentId") as? String
        userId = aDecoder.decodeObject(forKey: "userId") as? Int
        grade = aDecoder.decodeObject(forKey: "grade") as? Grade
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
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if realName != nil{
            aCoder.encode(realName, forKey: "realName")
        }
        if studentId != nil{
            aCoder.encode(studentId, forKey: "studentId")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "userId")
        }
        if grade != nil{
            aCoder.encode(grade, forKey: "grade")
        }
        
    }
}




class Grade : NSObject, NSCoding, Mappable{
    
    var id : Int?
    var name : String?
    var num : String?
    var school : String?
    var stage : String?
    
    private override init(){}
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        id <- map["id"]
        name <- map["name"]
        num <- map["num"]
        school <- map["school"]
        stage <- map["stage"]
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        num = aDecoder.decodeObject(forKey: "num") as? String
        school = aDecoder.decodeObject(forKey: "school") as? String
        stage = aDecoder.decodeObject(forKey: "stage") as? String
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
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if num != nil{
            aCoder.encode(num, forKey: "num")
        }
        if school != nil{
            aCoder.encode(school, forKey: "school")
        }
        if stage != nil{
            aCoder.encode(stage, forKey: "stage")
        }
    }
    
}
