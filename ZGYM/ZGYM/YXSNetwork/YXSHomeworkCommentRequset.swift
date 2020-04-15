//
//  SLHomeworkCommentRequset.swift
//  ZGYM
//
//  Created by yihao on 2020/4/7.
//  Copyright © 2020 hmym. All rights reserved.
//  作业评论操作

import Foundation
import UIKit

// MARK: 提交作业评论或回复（家长）
let homeworkComment = "/homework/comment"
class YXSEducationHomeworkCommentRequest: YXSBaseRequset {
    init(childrenId: Int,homeworkCreateTime: String,content: String,homeworkId: Int,type: String,id: Int = 0) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkComment
        if id == 0 {
            param = ["childrenId": childrenId,
            "homeworkCreateTime": homeworkCreateTime,
            "content": content,
            "homeworkId": homeworkId,
            "type": type]
        } else {
            //评论作业时，无需传被回复的评论id
            param = ["childrenId": childrenId,
            "homeworkCreateTime": homeworkCreateTime,
            "content": content,
            "homeworkId": homeworkId,
            "type": type,
            "id":id]
        }
        
    }
}

// MARK: 删除作业评论或回复（家长）
let homeworkCommentDelete = "/homework/delete-comment"
class YXSEducationHomeworkCommentDeleteRequest: YXSBaseRequset {
    init(childrenId: Int,homeworkCreateTime: String,homeworkId: Int,id: Int = 0) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkCommentDelete
        param = ["childrenId": childrenId,
        "homeworkCreateTime": homeworkCreateTime,
        "homeworkId": homeworkId,
        "id":id]
        
    }
}

// MARK: 作业设置或取消优秀（老师）
let homeworkInTeacherChangeGood = "/homework/set-god"
class YXSEducationHomeworkInTeacherChangeGoodRequest: YXSBaseRequset {
    init(childrenId: Int,homeworkCreateTime: String,homeworkId: Int,isGood: Int = 0) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkInTeacherChangeGood
        param = ["childrenId": childrenId,
        "homeworkCreateTime": homeworkCreateTime,
        "homeworkId": homeworkId,
        "isGood":isGood]
    }
}


// MARK: 查询作业互动消息
let homeworkMessage = "/homework/query-homework-message"
class YXSEducationHomeworkMessageRequest: YXSBaseRequset {
    init(homeworkId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkMessage
        param = ["homeworkId": homeworkId]
    }
}

// MARK: 老师涂鸦作业
let homeworkPaintingRequest = "/homework/painting-homework"
class YXSEducationHomeworkPaintingRequest: YXSBaseRequset {
    init(childrenId: Int,homeworkCreateTime: String,homeworkId: Int,paintingImageUrl: String, replaceIndex: Int) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkPaintingRequest
        param = ["childrenId": childrenId,
                 "homeworkCreateTime": homeworkCreateTime,
                 "homeworkId":homeworkId,
                 "paintingImageUrl": paintingImageUrl,
                 "replaceIndex": replaceIndex]
    }
}

// MARK: 老师作业单个涂鸦撤销
let homeworkCancelPainting = "/homework/cancel-painting-homework"
class YXSEducationHomeworkCancelPaintingRequest: YXSBaseRequset {
    init(childrenId: Int,homeworkCreateTime: String,homeworkId: Int, cancelIndex: Int) {
        super.init()
        method = .post
        host = homeHost
        path = homeworkCancelPainting
        param = ["childrenId": childrenId,
        "homeworkCreateTime": homeworkCreateTime,
        "homeworkId":homeworkId,
        "cancelIndex": cancelIndex]
    }
}
