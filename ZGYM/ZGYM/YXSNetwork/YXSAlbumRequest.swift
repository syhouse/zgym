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

/// 批量删除相册资源复制地址复制文档
let albumBatchDeleteResource = "/album/batch-delete-resource"
class YXSEducationAlbumBatchDeleteResourceRequest: YXSBaseRequset {
    init(albumId: Int, resourceIdList: [Int]){
        super.init()
        method = .post
        host = fileHost
        path = albumBatchDeleteResource
        param = [
            "albumId":albumId,
            "resourceIdList":resourceIdList]
    }
}

/// 修改相册名称或封面
let albumUpdateAlbumNameOrCover = "/album/update-name-or-cover"
class YXSEducationAlbumUpdateAlbumNameOrCoverRequest: YXSBaseRequset {
    init(id: Int, albumName: String?,coverUrl: String?){
        super.init()
        method = .post
        host = fileHost
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
class YXSEducationAlbumDeleteRequest: YXSBaseRequset {
    init(id: Int){
        super.init()
        method = .post
        host = fileHost
        path = albumDelete
        param = [
            "id":id]
    }
}


/// 获取照片评论和点赞数量
let albumQueryCommentListAndPraise = "/album/query-comment-list-and-praise"
class YXSEducationAlbumQueryCommentListAndPraiseRequest: YXSBaseRequset {
    init(albumId: Int, resourceId: Int){
        super.init()
        method = .post
        host = fileHost
        path = albumQueryCommentListAndPraise
        param = [
            "albumId":albumId,
            "resourceId":resourceId]
    }
}

///点赞|取消点赞相册资源
let albumPraiseOrCancel = "/album/praise-or-cancel"
class YXSEducationAlbumPraiseOrCancelRequest: YXSBaseRequset {
    init(albumId: Int, resourceId: Int){
        super.init()
        method = .post
        host = fileHost
        path = albumQueryCommentListAndPraise
        param = [
            "albumId":albumId,
            "resourceId":resourceId]
    }
}

//当老师有多个班级时，获取老师班级列表信息以及相册统计
let albumQueryClassList = "/album/query-class-list"
class YXSEducationAlbumQueryClassListRequest: YXSBaseRequset {
    init(stage: StageType){
        super.init()
        method = .post
        host = fileHost
        path = albumQueryClassList
        param = [
            "stage":stage.rawValue]
    }
}

//评论相册资源
let albumComment = "/album/comment"
class YXSEducationAlbumCommentRequest: YXSBaseRequset {
    init(albumId: Int, resourceId: Int,id: Int,type: String = "COMMENT",content: String){
        super.init()
        method = .post
        host = fileHost
        path = albumComment
        param = [
            "albumId":albumId,
            "resourceId":resourceId,
            "type":type,
            "content":content,
            "id":id]
    }
}
