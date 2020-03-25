//
//  FriendCircleRequset.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/17.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

// MARK: - 班级圈API
//MARK: -发布班级圈【选择班级】

let classOptionalGradeList = "/class/circle/optional/grade/list"
class SLEducationClassOptionalGradeListRequest: SLBaseRequset {
    override init() {
        super.init()
        method = .post
        path = classOptionalGradeList
    }
}

//MARK: -撤回班级圈
let classCircleCancel = "/class/circle/cancel"
class SLEducationClassCircleCancelRequest: SLBaseRequset {
    init(classCircleId: Int) {
        super.init()
        method = .post
        path = classCircleCancel
        param = ["classCircleId": classCircleId]
    }
}
//MARK: -点赞或取消点赞班级圈
let classCirclePraiseUpdate = "/class/circle/praise/save/or/cancel"

/// 点赞或取消点赞班级圈
class SLEducationClassCirclePraiseUpdateRequest: SLBaseRequset {
    init(classCircleId: Int) {
        super.init()
        method = .post
        path = classCirclePraiseUpdate
        param = ["classCircleId": classCircleId,
                 "classCircleType": "CIRCLE"]
    }
}

//MARK: -评论班级圈
let classCircleCommentSave = "/class/circle/comment/save"
//类型（COMMENT评论 REPLY回复）
enum FriendCircleComment: String{
    case COMMENT
    case REPLY
}
//COMMENT评论 REPLY回复
class SLEducationClassCircleCommentSaveRequest: SLBaseRequset {
    init(classCircleId: Int,type: FriendCircleComment,content: String, id: Int?) {
        super.init()
        method = .post
        path = classCircleCommentSave
        param = ["classCircleId": classCircleId,
                 "type":type.rawValue,
                 "content": content,
                 "classCircleType": "CIRCLE"]
        if let id = id {
            param?["id"] = id
        }
    }
}

//MARK: -取消评论班级圈
let classCircleCommentCancel = "/class/circle/comment/cancel"
//id 评论id
class SLEducationClassCircleCommentCancelRequest: SLBaseRequset {
    init(classCircleId: Int,id: Int) {
        super.init()
        method = .post
        path = classCircleCommentCancel
        param = ["classCircleId": classCircleId,
                 "id":id]
    }
}


//MARK: -按条件分页查询班级圈

let classCircleTimeAxisPage = "/class/circle/time/axis/page"
//自己发布的（YES是 NO否）  typePublisher 发布者身份 PARENT家长 TEACHER老师
class SLEducationClassCircleTimeAxisPageRequest: SLBaseRequset {
    init(current: Int,size: Int = kPageSize,own: Bool? = nil,typePublisher: PersonRole? = nil,gradeId: Int? = nil,userIdPublisher:Int? = nil) {
        super.init()
        method = .post
        path = classCircleTimeAxisPage
        param = ["current": current,
                 "size": size]
        if let own = own{
            param?["own"] = own ? "YES" : "NO"
        }
        if let typePublisher = typePublisher{
            param?["typePublisher"] = typePublisher.rawValue
        }
        if let gradeId = gradeId{
            param?["gradeId"] = gradeId
        }
        if let userIdPublisher = userIdPublisher{
            param?["userIdPublisher"] = userIdPublisher
        }
    }
}


// MARK: -发布班级圈
let classCirclePublish = "/class/circle/publish"
//禁止评论（YES是 NO否）
enum NoComment: String {
    case YES
    case NO
}

class SLEducationClassCirclePublishRequest: SLBaseRequset {
//    附件：图片（多张以","隔开，最多9张）或短视频  短视频 追加_HMVedio
    init(gradeIds: [Int], content:String , noComment: NoComment = .NO,attachment: String? = nil,childrenId: Int? = nil) {
        super.init()
        method = .post
        path = classCirclePublish
        param = ["gradeIds":gradeIds,
                 "content":content,
                 "noComment": noComment.rawValue]
        if let attachment = attachment{
            param?["attachment"] = attachment
        }
        if let childrenId = childrenId{
            param?["childrenId"] = childrenId
        }
    }
}

// MARK: -班级圈个人信息
let classCircleUserInfo = "/class/circle/user/info"
class SLEducationClassCircleUserInfoRequest: SLBaseRequset {
    init(id: Int, type: String) {
        super.init()
        method = .post
        path = classCircleUserInfo
        param = ["id":id,
                 "type":type]
    }
}

// MARK: -班级圈消息列表
let classCircleMessageList = "/class/circle/message/list"
class SLEducationClassCircleMessageListRequest: SLBaseRequset {
    override init() {
        super.init()
        method = .post
        path = classCircleMessageList
    }
}

// MARK: -班级圈消息互动提示
let classCircleMessageTips = "/class/circle/message/tips"
class SLEducationClassCircleMessageTipsRequest: SLBaseRequset {
    override init(){
        super.init()
        method = .post
        path = classCircleMessageTips
    }
}

// MARK: -班级圈详情
let classCircleTimeAxisDetail = "/class/circle/time/axis/detail"
class SLEducationClassCircleTimeAxisDetailRequest: SLBaseRequset {
    init(classCircleId: Int){
        super.init()
        method = .post
        path = classCircleTimeAxisDetail
        param = [
        "classCircleId":classCircleId,
        "classCircleType": "CIRCLE"]
    }
}
