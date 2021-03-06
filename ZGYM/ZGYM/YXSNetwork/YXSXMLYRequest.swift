//
//  YXSXMLYRequest.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/11.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import SwiftyJSON

class YXSXMLYRequest: NSObject {
    ///请求路径
    var path: String = ""
    ///请求参数
    var param: Parameters?
    ///ObjectMapper 路径
    var destinationJsonPaths = [String]()
    
    func request(_ completion: ((JSON) -> ())?,
                 failureHandler: ((String, String) -> ())?) {
        
        XMReqMgr.sharedInstance()?.requestXMData(withPath: path, params: param, completionHandler: { (result, error) in
            if let error = error{
                failureHandler?(error.error_desc,error.error_code)
            }else{
                completion?(JSON(result ?? ""))
            }
        })
    }
    
    /**
     请求 数据 返回 model
     
     - parameter completion:     成功 返回值
     - parameter result:         遵循 Mappable
     - parameter failureHandler: 失败 返回
     - parameter err_code:       错误码
     */
    func request<T: Mappable>(_ completion: ((T) -> ())?,
                              failureHandler: ((String, String) -> ())?) {
        
        XMReqMgr.sharedInstance()?.requestXMData(withPath: path, params: param, completionHandler: { (result, error) in
            if let error = error{
                failureHandler?(error.error_desc,error.error_code)
            }else{
                let resultJson = JSON(result ?? "")
                var resultJsonModel = resultJson
                var resultModel: T = T.init(JSON: ["": ""])!
                
                for key in self.destinationJsonPaths{
                    resultJsonModel = resultJsonModel[key]
                }
                resultModel = Mapper<T>().map(JSONObject:resultJsonModel.object) ?? T.init(JSON: ["": ""])!
                completion?(resultModel)
            }
        })
    }
    
    /**
     请求 数据 返回 固定格式
     - parameter completion:     成功 返回值
     - parameter result:         遵循 Mappable
     - parameter failureHandler: 失败 返回
     - parameter err_code:       错误码
     */
    func requestCollection<T: Mappable>(_ completion: (([T], _ total_count: Int) -> ())?,
                                        failureHandler: ((String, String) -> ())?) {
        XMReqMgr.sharedInstance()?.requestXMData(withPath: path, params: param, completionHandler: { (result, error) in
            if let error = error{
                failureHandler?(error.error_desc,error.error_code)
            }else{
                var resultModel: [T] = [T]()
                let resultJson = JSON(result ?? "")
                var resultJsonModels = resultJson
                
                for key in self.destinationJsonPaths{
                    resultJsonModels = resultJsonModels[key]
                }
                
                resultModel = Mapper<T>().mapArray(JSONObject: resultJsonModels.object) ?? [T]()
                completion?(resultModel, resultJson["total_count"].intValue)
            }
        })
    }
}

// MARK: 焦点图列表  我的运营素材-焦点图
let operation_banners = "/operation/banners"
///焦点图列表
class YXSEducationXMLYOperationBannersRequest: YXSXMLYRequest {
    init(page: Int,pageSize: Int = kPageSize) {
        super.init()
        path = operation_banners
        destinationJsonPaths = ["banners"]
        param = ["page": page,
                 "count": pageSize,
                 "scope": 2]
        
        
    }
}

// MARK: 听单目录  【我的运营素材-听单】
let operation_columns = "/operation/columns"
///听单目录
class YXSEducationXMLYOperationColumnsRequest: YXSXMLYRequest {
    init(page: Int,pageSize: Int = kPageSize) {
        super.init()
        path = operation_columns
        destinationJsonPaths = ["columns"]
        param = ["page": page,
                 "count": pageSize]
        
        
    }
}


// MARK: 听单列表  【我的运营素材-听单】
let browse_column_content = "/operation/browse_column_content"
///听单列表
class YXSEducationXMLYOperationColumnsListRequest: YXSXMLYRequest {
    ///id 听单id
    init(page: Int,pageSize: Int = kPageSize, id: Int) {
        super.init()
        path = browse_column_content
        destinationJsonPaths = ["values"]
        param = ["page": page,
                 "count": pageSize,
                 "id": id]
    }
}

// MARK: 专辑详情  【我的运营素材-听单】(点播api)

//album_id    Int    是    专辑ID
//sort    String    否    返回结果排序方式： "asc" - 喜马拉雅正序，"desc" - 喜马拉雅倒序，"time_asc" - 发布时间升序，"time_desc" - 发布时间降序，默认为"asc"
//page    Int    否    返回第几页，从1开始，默认为1
//count    Int    否    每页大小，范围为[1,200]，默认为20

let albumsBrowse = "/albums/browse"
///专辑详情
class YXSEducationXMLYAlbumsBrowseDetialRequest: YXSXMLYRequest {
    ///id 听单id
    init(album_id: Int, page: Int,pageSize: Int = kPageSize) {
        super.init()
        path = albumsBrowse
        param = ["album_id": album_id,
                 "page": page,
        "count": pageSize]
    }
}

///批量获取声音信息
let tracksGetBatch = "/tracks/get_batch"
class YXSEducationXMLYTracksGetBatchRequest: YXSXMLYRequest {
    ///id 声音id
    init(ids: String) {
        super.init()
        path = tracksGetBatch
        param = ["ids": ids]
    }
}
