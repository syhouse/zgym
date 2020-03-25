//
//	SLClassDetailModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class SLClassDetailModel : NSObject, Mappable{

	var creator : Int?
	var disbanded : String?
	var forbidJoin : String?
	var id : Int?
	var members : Int?
	var name : String?
	var num : String?
	var school : String?
    var headmaster : Bool?
    var position: String?
    var children : [SLChildrenModel]?
    var teachers : Int?
    var stage : String?
    
    func getCurruntChild(classModel: SLClassModel) -> SLChildrenModel?{
        var children: SLChildrenModel?
        if let childrens = self.children{
            for model in childrens{
                if model.id == classModel.childrenId{
                    children = model
                    let grade = Grade.init(JSON: ["" : ""])
                    grade?.id = id
                    grade?.name = name
                    children?.grade = grade
                    break
                }
            }
        }
        return children
    }
    
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		creator <- map["creator"]
		disbanded <- map["disbanded"]
		forbidJoin <- map["forbidJoin"]
		id <- map["id"]
		members <- map["members"]
		name <- map["name"]
		num <- map["num"]
		school <- map["school"]
		children <- map["children"]
        teachers <- map["teachers"]
        headmaster <- map["headmaster"]
        position <- map["position"]
        stage <- map["stage"]
	}
}

