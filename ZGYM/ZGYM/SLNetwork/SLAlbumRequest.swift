//
//  SLAlbumRequest.swift
//  ZGYM
//
//  Created by sy_mac on 2020/2/28.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import Alamofire

// MARK: -分页查询相册
let albumPagequery = "/album/page-query"
class SLEducationAlbumPagequeryRequest: SLBaseRequset {
    init(classId: Int, currentPage: Int,pageSize: Int = kPageSize){
        super.init()
        method = .post
        host = homeHost
        path = albumPagequery
        param = [
        "classId":classId,
        "currentPage":currentPage,
        "pageSize":pageSize]
    }
}


/// 创建相册
let albumCreate = "/album/create"
class SLEducationAlbumCreateRequest: SLBaseRequset {
    init(classId: Int, albumName: String,coverUrl: String?){
        super.init()
        method = .post
        host = homeHost
        path = albumCreate
        param = [
        "classId":classId,
        "albumName":albumName]
        if let coverUrl = coverUrl{
            param?["coverUrl"] = coverUrl
        }
    }
}


/// 班级相册资源分页查询
let albumPagequeryResource = "/album/page-query-resource"
class SLEducationAlbumPagequeryResourceRequest: SLBaseRequset {
    init(albumId: Int, currentPage: Int,pageSize: Int = kPageSize){
        super.init()
        method = .post
        host = homeHost
        path = albumPagequeryResource
        param = [
        "albumId":albumId,
        "currentPage":currentPage,
        "pageSize":pageSize]
    }
}


/// 班级相册资源上传
let albumUploadResource = "/album/upload-resource"
class SLEducationAlbumUploadResourceRequest: SLBaseRequset {
    init(albumId: Int, resourceList: [[String: Any]]){
        super.init()
        method = .post
        host = homeHost
        path = albumUploadResource
        param = [
        "albumId":albumId,
        "resourceList":resourceList]
    }
}

/// 批量删除相册资源复制地址复制文档
let albumBatchDeleteResource = "/album/batch-delete-resource"
class SLEducationAlbumBatchDeleteResourceRequest: SLBaseRequset {
    init(albumId: Int, resourceIdList: [Int]){
        super.init()
        method = .post
        host = homeHost
        path = albumBatchDeleteResource
        param = [
        "albumId":albumId,
        "resourceIdList":resourceIdList]
    }
}

/// 修改相册名称或封面
let albumUpdateAlbumNameOrCover = "/album/update-name-or-cover"
class SLEducationAlbumUpdateAlbumNameOrCoverRequest: SLBaseRequset {
    init(id: Int, albumName: String?,coverUrl: String?){
        super.init()
        method = .post
        host = homeHost
        path = albumUpdateAlbumNameOrCover
        param = [
        "id":id]
        if let albumName = albumName{
            param?["albumName"] = albumName
        }
        if let coverUrl = coverUrl{
            param?["coverUrl"] = coverUrl
        }
    }
}

/// 删除相册
let albumDelete = "/album/delete"
class SLEducationAlbumDeleteRequest: SLBaseRequset {
    init(id: Int){
        super.init()
        method = .post
        host = homeHost
        path = albumDelete
        param = [
        "id":id]
    }
}
