//
//  SLAlbumRequest.swift
//  ZGYM
//
//  Created by sy_mac on 2020/2/28.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import Alamofire

//当老师有多个班级时，获取老师班级列表信息以及相册统计 *
let albumQueryClassList = "/album/query-class-list"
class YXSEducationAlbumQueryClassListRequest: YXSBaseRequset {
    init(stage: StageType){
        super.init()
        method = .post
        host = fileHost
        path = albumQueryClassList
        param = ["stage":stage.rawValue]
    }
}

// MARK: -分页查询相册
let albumPagequery = "/album/page-query"
class YXSEducationAlbumPagequeryRequest: YXSBaseRequset {
    init(classId: Int, currentPage: Int,pageSize: Int = kPageSize){
        super.init()
        method = .post
        host = fileHost
        path = albumPagequery
        param = [
            "classId":classId,
            "currentPage":currentPage,
            "pageSize":pageSize]
    }
}

// MARK: -相册点赞列表
let albumQueryPraiseList = "/album/query-praise-list"
class YXSEducationAlbumQueryPraiseListRequest: YXSBaseRequset {
    init(classId: Int, resourceId: Int,albumId: Int){
        super.init()
        method = .post
        host = fileHost
        path = albumQueryPraiseList
        param = [
            "classId":classId,
            "resourceId":resourceId,
            "albumId":albumId]
    }
}


/// 创建相册
let albumCreate = "/album/create"
class YXSEducationAlbumCreateRequest: YXSBaseRequset {
    init(classId: Int, albumName: String,coverUrl: String?){
        super.init()
        method = .post
        host = fileHost
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
class YXSEducationAlbumPagequeryResourceRequest: YXSBaseRequset {
    init(classId: Int, albumId: Int, currentPage: Int,pageSize: Int = kPageSize){
        super.init()
        method = .post
        host = fileHost
        path = albumPagequeryResource
        param = [
            "albumId":albumId,
            "currentPage":currentPage,
            "pageSize":pageSize,
            "classId": classId]
    }
}


/// 班级相册资源上传
let albumUploadResource = "/album/upload-resource"
class YXSEducationAlbumUploadResourceRequest: YXSBaseRequset {
    init(classId: Int,albumId: Int, resourceList: [[String: Any]]){
        super.init()
        method = .post
        host = fileHost
        path = albumUploadResource
        param = [
            "albumId":albumId,
            "resourceList":resourceList,
            "classId": classId]
    }
}

/// 班级相册资源检查md5
let albumCheckMD5 = "/album/check-md5"
class YXSEducationAlbumCheckMD5Request: YXSBaseRequset {
    init(classId: Int,albumId: Int, md5List: [String]){
        super.init()
        method = .post
        host = fileHost
        path = albumCheckMD5
        param = [
            "albumId":albumId,
            "md5List":md5List,
            "classId": classId]
    }
}

/// 批量删除相册资源复制地址复制文档
let albumBatchDeleteResource = "/album/batch-delete-resource"
class YXSEducationAlbumBatchDeleteResourceRequest: YXSBaseRequset {
    init(classId: Int,albumId: Int, resourceIdList: [Int]){
        super.init()
        method = .post
        host = fileHost
        path = albumBatchDeleteResource
        param = [
            "classId": classId,
            "albumId": albumId,
            "resourceIdList": resourceIdList]
    }
}

/// 修改相册名称或封面
let albumUpdateAlbumNameOrCover = "/album/update-name-or-cover"
class YXSEducationAlbumUpdateAlbumNameOrCoverRequest: YXSBaseRequset {
    init(id: Int, classId: Int, albumName: String?,coverUrl: String?){
        super.init()
        method = .post
        host = fileHost
        path = albumUpdateAlbumNameOrCover
        param = [
            "id":id, "classId":classId]
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
class YXSEducationAlbumDeleteRequest: YXSBaseRequset {
    init(id: Int, classId: Int){
        super.init()
        method = .post
        host = fileHost
        path = albumDelete
        param = [
            "id":id,
            "classId":classId]
    }
}


/// 获取照片评论列表
let albumQueryCommentList = "/album/query-comment-list"
class YXSEducationAlbumQueryCommentListRequest: YXSBaseRequset {
    init(albumId: Int, classId: Int, resourceId: Int){
        super.init()
        method = .post
        host = fileHost
        path = albumQueryCommentList
        param = [
            "albumId":albumId,
            "classId":classId,
            "resourceId":resourceId]
    }
}

///点赞|取消点赞相册资源
let albumPraiseOrCancel = "/album/praise-or-cancel"
class YXSEducationAlbumPraiseOrCancelRequest: YXSBaseRequset {
    init(albumId: Int, classId: Int, resourceId: Int){
        super.init()
        method = .post
        host = fileHost
        path = albumPraiseOrCancel
        param = [
            "albumId":albumId,
            "classId":classId,
            "resourceId":resourceId]
    }
}


/// 某张图片的点赞数量
let albumQueryPraiseCommentCount = "/album/query-praise-comment-count"
class YXSEducationAlbumQueryPraiseCommentCountRequest: YXSBaseRequset {
    init(albumId: Int, classId: Int, resourceId: Int){
        super.init()
        method = .post
        host = fileHost
        path = albumQueryPraiseCommentCount
        param = [
            "albumId":albumId,
            "classId":classId,
            "resourceId":resourceId]
    }
}

//评论相册资源
let albumComment = "/album/comment"
class YXSEducationAlbumCommentRequest: YXSBaseRequset {
    init(albumId: Int, classId: Int, resourceId: Int, type: String = "COMMENT", content: String, id: Int?){
        super.init()
        method = .post
        host = fileHost
        path = albumComment
        param = [
            "albumId":albumId,
            "classId": classId,
            "resourceId": resourceId,
            "type": type,
            "content": content]
        if let id = id{
            param?["id"] = id
        }
    }
}

// MARK: - 获取相册互动消息(已完成)
let albumQueryAlbumMessage = "/album/query-album-message"
class YXSEducationQueryAlbumMessageRequest: YXSBaseRequset {
    init(classId: Int){
        super.init()
        method = .post
        host = fileHost
        path = albumQueryAlbumMessage
        param = [
        "classId": classId]
    }
}

// MARK: - 删除相册互动消息
let albumDeleteComment = "/album/delete-comment"
class YXSEducationAlbumDeleteCommentRequest: YXSBaseRequset {
    init(albumId: Int, classId: Int, resourceId: Int, id: Int){
        super.init()
        method = .post
        host = fileHost
        path = albumDeleteComment
        param = [
        "albumId":albumId,
        "classId": classId,
        "resourceId": resourceId,
        "id": id]
    }
}

// MARK: - 相册信息查询
let albumQuery = "/album/query"
class YXSEducationAlbumQueryRequest: YXSBaseRequset {
    init(classId: Int, id: Int){
        super.init()
        method = .post
        host = fileHost
        path = albumQuery
        param = [
        "classId": classId,
        "id": id]
    }
}

// MARK: - 相册撤回
let albumCancelResource = "/album/cancel-resource"
class YXSEducationAlbumCancelResourceRequest: YXSBaseRequset {
    init(classId: Int, waterfallId: Int, waterfallCreateTime: String){
        super.init()
        method = .post
        host = fileHost
        path = albumCancelResource
        param = [
        "classId": classId,
        "waterfallId": waterfallId,
        "waterfallCreateTime": waterfallCreateTime]
    }
}

