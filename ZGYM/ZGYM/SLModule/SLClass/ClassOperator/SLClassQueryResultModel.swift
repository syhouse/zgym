//
//	SLClassQueryResultModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class SLClassQueryResultModel : NSObject, Mappable{

	var creator : Int?
    var disbanded : String?
    var forbidJoin : String?
    var headmasterId : Int?
    var headmasterName : String?
    var id : Int?
    var joined : Bool?
    var members : Int?
    var name : String?
    var num : String?
    var school : String?
    var stage : String?
    var teachers : Int?

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        creator <- map["creator"]
        disbanded <- map["disbanded"]
        forbidJoin <- map["forbidJoin"]
        headmasterId <- map["headmasterId"]
        headmasterName <- map["headmasterName"]
        id <- map["id"]
        joined <- map["joined"]
        members <- map["members"]
        name <- map["name"]
        num <- map["num"]
        school <- map["school"]
        stage <- map["stage"]
        teachers <- map["teachers"]
        
    }
}
