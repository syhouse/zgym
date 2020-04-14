//
//    ClassMember.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class YXSClassMemberModel : NSObject, NSCoding, Mappable{
    required init?(map: Map) {}
    
    var avatar : String?
    var childrenId : Int?
    var name : String?
    var position : String?
    var realName : String?
    var relationship : String?
    var userId : Int?
    var subject : String?

    /// 接龙模块用
    var censusCommitId : Int?
    var censusId : Int?
    
    var classId : Int?
    var className : String?
    var commitTime : String?
    var custodianId : Int?
    var option : String?
    
    var studentId : String?

    var isRemark : Bool?

    //发布作业的老师id
    var teacherId : Int?
    
    func mapping(map: Map)
    {
        avatar <- map["avatar"]
        childrenId <- map["childrenId"]
        name <- map["name"]
        position <- map["position"]
        realName <- map["realName"]
        relationship <- map["relationship"]
        userId <- map["userId"]
        subject <- map["subject"]
        
        censusCommitId <- map["censusCommitId"]
        censusId <- map["censusId"]
        classId <- map["classId"]
        className <- map["className"]
        commitTime <- map["commitTime"]
        custodianId <- map["custodianId"]
        option <- map["option"]
        studentId <- map["studentId"]
        isRemark <- map["isRemark"]
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         avatar = aDecoder.decodeObject(forKey: "avatar") as? String
         childrenId = aDecoder.decodeObject(forKey: "childrenId") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String
         position = aDecoder.decodeObject(forKey: "position") as? String
         realName = aDecoder.decodeObject(forKey: "realName") as? String
         relationship = aDecoder.decodeObject(forKey: "relationship") as? String
         userId = aDecoder.decodeObject(forKey: "userId") as? Int
         subject = aDecoder.decodeObject(forKey: "subject") as? String
        
        censusCommitId = aDecoder.decodeObject(forKey: "censusCommitId") as? Int
        censusId = aDecoder.decodeObject(forKey: "censusId") as? Int
        classId = aDecoder.decodeObject(forKey: "classId") as? Int
        className = aDecoder.decodeObject(forKey: "className") as? String
        commitTime = aDecoder.decodeObject(forKey: "commitTime") as? String
        custodianId = aDecoder.decodeObject(forKey: "custodianId") as? Int
        option = aDecoder.decodeObject(forKey: "option") as? String
        studentId = aDecoder.decodeObject(forKey: "studentId") as? String
        isRemark = aDecoder.decodeObject(forKey: "isRemark") as? Bool
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
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if position != nil{
            aCoder.encode(position, forKey: "position")
        }
        if realName != nil{
            aCoder.encode(realName, forKey: "realName")
        }
        if relationship != nil{
            aCoder.encode(relationship, forKey: "relationship")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "userId")
        }
        if subject != nil{
            aCoder.encode(subject, forKey: "subject")
        }
        
        if censusCommitId != nil{
            aCoder.encode(censusCommitId, forKey: "censusCommitId")
        }
        if censusId != nil{
            aCoder.encode(censusId, forKey: "censusId")
        }
        if classId != nil{
            aCoder.encode(classId, forKey: "classId")
        }
        if className != nil{
            aCoder.encode(className, forKey: "className")
        }
        if commitTime != nil{
            aCoder.encode(commitTime, forKey: "commitTime")
        }
        if custodianId != nil{
            aCoder.encode(custodianId, forKey: "custodianId")
        }
        if option != nil{
            aCoder.encode(option, forKey: "option")
        }
        if studentId != nil{
            aCoder.encode(studentId, forKey: "studentId")
        }
        
        if isRemark != nil{
            aCoder.encode(isRemark, forKey: "isRemark")
        }

    }

}
