//
//  SLOSSAuthModel.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/28.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

import Foundation
import ObjectMapper


class SLOSSAuthModel : NSObject, Mappable{

    var accessKeyId : String?
    var accessKeySecret : String?
    var bucket : String?
    var cdnEndpoint : String?
    var endpoint : String?
    var expiration : String?
    var securityToken : String?

    required init?(map: Map){}

    func mapping(map: Map)
    {
        accessKeyId <- map["accessKeyId"]
        accessKeySecret <- map["accessKeySecret"]
        bucket <- map["bucket"]
        cdnEndpoint <- map["cdnEndpoint"]
        endpoint <- map["endpoint"]
        expiration <- map["expiration"]
        securityToken <- map["securityToken"]
    }
        
    
}
