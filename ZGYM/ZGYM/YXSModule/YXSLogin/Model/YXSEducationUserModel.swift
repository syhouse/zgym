//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper

@objc class YXSEducationUserModel : NSObject, NSCoding, Mappable{

	var accessToken : String?
	var hasSetPassword : Bool?
    @objc var type : String?
    @objc var account: String?
    var stage: String?
    
    var address : String?
    var avatar : String?
    var children : [YXSChildrenModel]?
    var id : Int?
    var name : String?
    var school : String?
    var vibration : String?
    var voice : String?
    var gradeIds : [Int]?
    
    var timestamp : Int?
    
    /// 家长当前选中孩子
    var currentChild: YXSChildrenModel?
    var gradeNum : String?
    
	class func newInstance(map: Map) -> Mappable?{
		return YXSEducationUserModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		accessToken <- map["accessToken"]
		hasSetPassword <- map["hasSetPassword"]
		type <- map["type"]
        account <- map["account"]
        stage <- map["stage"]
        
        address <- map["address"]
        avatar <- map["avatar"]
        children <- map["children"]
        id <- map["id"]
        name <- map["name"]
        school <- map["school"]
        vibration <- map["vibration"]
        voice <- map["voice"]
        gradeIds <- map["gradeIds"]
        timestamp <- map["timestamp"]
        gradeNum <- map["gradeNum"]
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
        accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String
        hasSetPassword = aDecoder.decodeObject(forKey: "hasSetPassword") as? Bool
        type = aDecoder.decodeObject(forKey: "type") as? String
        account = aDecoder.decodeObject(forKey: "account") as? String
        stage = aDecoder.decodeObject(forKey: "stage") as? String
        
        address = aDecoder.decodeObject(forKey: "address") as? String
        avatar = aDecoder.decodeObject(forKey: "avatar") as? String
        children = aDecoder.decodeObject(forKey: "children") as? [YXSChildrenModel]
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        school = aDecoder.decodeObject(forKey: "school") as? String
        vibration = aDecoder.decodeObject(forKey: "vibration") as? String
        voice = aDecoder.decodeObject(forKey: "voice") as? String
        gradeIds = aDecoder.decodeObject(forKey: "gradeIds") as? [Int]
        timestamp = aDecoder.decodeObject(forKey: "timestamp") as? Int
        gradeNum = aDecoder.decodeObject(forKey: "gradeNum") as? String
        
        
        currentChild = aDecoder.decodeObject(forKey: "currentChild") as? YXSChildrenModel
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if accessToken != nil{
			aCoder.encode(accessToken, forKey: "accessToken")
		}
		if hasSetPassword != nil{
			aCoder.encode(hasSetPassword, forKey: "hasSetPassword")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}
        if account != nil{
            aCoder.encode(account, forKey: "account")
        }
        if stage != nil{
            aCoder.encode(stage, forKey: "stage")
        }
        
        if address != nil{
            aCoder.encode(address, forKey: "address")
        }
        if avatar != nil{
            aCoder.encode(avatar, forKey: "avatar")
        }
        if children != nil{
            aCoder.encode(children, forKey: "children")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if school != nil{
            aCoder.encode(school, forKey: "school")
        }
        if vibration != nil{
            aCoder.encode(vibration, forKey: "vibration")
        }
        if voice != nil{
            aCoder.encode(voice, forKey: "voice")
        }
        if gradeIds != nil{
            aCoder.encode(gradeIds, forKey: "gradeIds")
        }
        if timestamp != nil{
            aCoder.encode(timestamp, forKey: "timestamp")
        }
        if gradeNum != nil{
            aCoder.encode(gradeNum, forKey: "gradeNum")
        }
        
        if currentChild != nil{
            aCoder.encode(currentChild, forKey: "currentChild")
        }
	}
}
