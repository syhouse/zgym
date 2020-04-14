//
//  SLRequset.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/18.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import Alamofire

// MARK: - 最新版本
let versionManageLatest = "/version/manage/latest"
class YXSEducationVersionManageLatestRequest: YXSBaseRequset {
    override init() {
        super.init()
        method = .post
        path = versionManageLatest
        param = ["platform":"IOS"]
    }
}

// MARK: - 腾讯IM用户签名
let tencentImUserSign = "/tencent/im/user/sign"
class YXSEducationTencentImUserSignRequest: YXSBaseRequset {
    override init() {
        super.init()
        method = .post
        path = tencentImUserSign
    }
}

// MARK: - 用户API
// MARK: -编辑个人信息
let userEdit = "/user/edit"
class YXSEducationUserEditRequest: YXSBaseRequset {
    init(parameter:[String:String]) {
        super.init()
        method = .post
        path = userEdit
        param = parameter
//        param = ["avatar": avatar,
//                 "name": name,
//                 "school": school,
//                 "address": address,
//                 "account": account,
//                 "password": password,
//                 "smsCode": smsCode]
    }
}
//class YXSEducationUserEditRequest: HMBaseRequset {
//    init(avatar: String,name: String, school: String, address: String, account: String, password: String, smsCode: String) {
//        super.init()
//        method = .post
//        path = userEdit
//        param = ["avatar": avatar,
//                 "name": name,
//                 "school": school,
//                 "address": address,
//                 "account": account,
//                 "password": password,
//                 "smsCode": smsCode]
//    }
//}


let smsSend = "/sms/send"
enum SMSType: String { //短信模板 REGISTER注册 LOGIN登录 FORGET_PASSWORD忘记密码 OPERATION_GRADE操作班级 UPDATE_ACCOUNT修改账号
    /// 登录
    case LOGIN
    /// 注册
    case REGISTER
    case FORGET_PASSWORD
    case OPERATION_GRADE
    case UPDATE_ACCOUNT
}
// MARK: -发送短信验证码
class YXSEducationSmsSendRequest: YXSBaseRequset {
    init(account: String,smsTemplate: SMSType = SMSType.LOGIN) {
        super.init()
        method = .post
        path = smsSend
        param = ["account": account,
                 "smsTemplate": smsTemplate.rawValue]
    }
}

// MARK: -短信验证码登录
let userLoginSmsSend = "/user/login/sms/code"
class YXSEducationUserLoginSmsSendRequest: YXSBaseRequset {
    init(account: String,smsCode: String) {
        super.init()
        method = .post
        path = userLoginSmsSend
        param = ["account": account,
                 "smsCode": smsCode,
                 "endpoint": "IOS"]
        //        destinationJsonPaths = ["data", "list"]
    }
}

// MARK: -用户注册
let userRegister = "/user/register"
class YXSEducationUserRegisterRequest: YXSBaseRequset {
    init(account: String, smsCode: String, password: String, confirmPassword: String) {
        super.init()
        method = .post
        path = userRegister
        param = ["account":account, "smsCode":smsCode, "password":password, "confirmPassword":confirmPassword]
    }
}



// MARK: -密码登录
let userLoginPassword = "/user/login/password"
class YXSEducationUserLoginPasswordRequest: YXSBaseRequset {
    init(account: String, password: String) {
        super.init()
        method = .post
        path = userLoginPassword
        param = ["account": account, "password": password, "endpoint": "IOS"]
    }
}

// MARK: -忘记密码
let userForgetPassword = "/user/forget/password"
class YXSEducationUserForgetPasswordRequest: YXSBaseRequset {
    init(account: String, smsCode: String, password: String) {
        super.init()
        method = .post
        path = userForgetPassword
        param = ["account":account, "smsCode":smsCode, "password":password]
    }
}

// MARK: -选择身份
//用户类型（PARENT家长 TEACHER老师） 所在学段（KINDERGARTEN幼儿园 PRIMARY_SCHOOL小学 MIDDLE_SCHOOL中学）
let userChooseType = "/user/choose/type"
class YXSEducationUserChooseTypeRequest: YXSBaseRequset {
    init(name: String, userType: PersonRole = PersonRole.PARENT, stage: StageType?) {
        super.init()
        method = .post
        path = userChooseType
        if stage == nil {
            param = ["name":name, "type":userType.rawValue]
        } else {
            param = ["name":name, "type":userType.rawValue, "stage":stage!.rawValue]
        }
        
    }
}



// MARK: -切换学段
let userSwitchStage = "/user/switch/stage"
class YXSEducationUserSwitchStageRequest: YXSBaseRequset {
    init(stage: StageType = StageType.MIDDLE_SCHOOL) {
        super.init()
        method = .post
        path = userSwitchStage
        param = ["stage":stage.rawValue]
    }
}

// MARK: - 设置密码
let userSetPassword = "/user/set/password"
class YXSEducationUserSetPasswordRequest: YXSBaseRequset {
    init(password: String) {
        super.init()
        method = .post
        path = userSetPassword
        param = ["password":password]
    }
}

// MARK: -切换身份
let userSwitchType = "/user/switch/type"
class YXSEducationUserSwitchTypeRequest: YXSBaseRequset {
    init(userType: PersonRole = PersonRole.PARENT) {
        super.init()
        method = .post
        path = userSwitchType
        param = ["userType":userType.rawValue]
    }
}


// MARK: - 班级API
// MARK: -创建班级
let gradeCreate = "/grade/create"
class YXSEducationGradeCreateRequest: YXSBaseRequset {
    init(name: String,school: String?, subject: String,stage:StageType) {
        super.init()
        method = .post
        path = gradeCreate
        param = ["name": name,
                 "stage": stage.rawValue,
                 "subject": subject]
        if let school = school{
            param?["school"] = school
        }
    }
}

// MARK: -班级列表
let gradeList = "/grade/list"
class YXSEducationGradeListRequest: YXSBaseRequset {
    override init() {
        super.init()
        isLoadCache = true
        method = .post
        path = gradeList
        destinationJsonPaths = ["listCreate"]
    }
}

// MARK: -查询班级
let gradeQuery = "/grade/query"
class YXSEducationGradeQueryRequest: YXSBaseRequset {
    init(num: String) {
        super.init()
        method = .post
        path = gradeQuery
        param = ["num": num]
    }
}


// MARK: -退出班级
let gradeQuit = "/grade/quit"
class YXSEducationGradeQuitRequest: YXSBaseRequset {
    init(gradeId: Int, childrenIds: [Int]?,smsCode:Int) {
        super.init()
        method = .post
        path = gradeQuit
        param = ["gradeId": gradeId,
                 "smsCode":smsCode]
        if childrenIds == childrenIds {
            param?["childrenIds"] = childrenIds
        }
    }
}

// MARK: -请出班级
let gradeOut = "/grade/out"
class YXSEducationGradeOutRequest: YXSBaseRequset {
    init(gradeId: Int, uid: Int,childrenId:Int) {
        super.init()
        method = .post
        path = gradeOut
        param = ["gradeId": gradeId, "uid":uid,"childrenId": childrenId]
        
    }
}

// MARK: -退出班级【孩子列表】
let gradeOptionalChildrenList = "/grade/optional/children/list"
class YXSEducationGradeOptionalChildrenListRequest: YXSBaseRequset {
    init(gradeId: Int) {
        super.init()
        method = .post
        path = gradeOptionalChildrenList
        param = ["gradeId": gradeId]
    }
}

// MARK: -班级详情
let gradeDetail = "/grade/detail"
class YXSEducationGradeDetailRequest: YXSBaseRequset {
    init(gradeId: Int) {
        super.init()
        method = .post
        path = gradeDetail
        param = ["gradeId": gradeId]
    }
}

// MARK: -修改班级（修改班级名称、禁止新成员入班、解散班级）
let gradeUpdate = "/grade/update"
class YXSEducationGradeUpdateRequest: YXSBaseRequset {
    init(dic:[String: Any]) {
        super.init()
        method = .post
        path = gradeUpdate
        param = dic//["gradeId": gradeId]
    }
}


// MARK: -转让班级【老师列表】
let gradeOptionalTeacherList = "/grade/optional/teacher/list"
class YXSEducationGradeOptionalTeacherListRequest: YXSBaseRequset {
    init(gradeId: Int) {
        super.init()
        method = .post
        path = gradeOptionalTeacherList
        param = ["gradeId": gradeId]
        //        destinationJsonPaths = ["listJoin"]
    }
}

// MARK: -转让班级
let gradeTransfer = "/grade/transfer"
class YXSEducationGradeTransferRequest: YXSBaseRequset {
    init(gradeId: Int, teacherId: Int, smsCode: String) {
        super.init()
        method = .post
        path = gradeTransfer
        param = ["gradeId": gradeId, "teacherId":teacherId, "smsCode":smsCode]
        //        destinationJsonPaths = ["listJoin"]
    }
}

// MARK: - 班级成员API
// MARK: -班级成员
let gradeMemberDetail = "/grade/member/detail"
class YXSEducationGradeMemberDetailRequest: YXSBaseRequset {
    init(gradeId: Int) {
        super.init()
        method = .post
        path = gradeMemberDetail
        param = ["gradeId": gradeId]
    }
}

// MARK: -加入班级
let gradeMemberJoin = "/grade/member/join"
class YXSEducationGradeMemberJoinRequest: YXSBaseRequset {
    init(gradeId: Int,position:PersonRole,subject: String = "",childrenId: Int? = nil,relationship: String = "",realName: String = "",studentId:String = "",avatar: String? = nil) {
        super.init()
        method = .post
        path = gradeMemberJoin
        param = ["gradeId": gradeId]
        
        param?["position"] = position.rawValue
        
        if position == PersonRole.TEACHER{
            param?["subject"] = subject
        }else{
            if let childrenId = childrenId{
                param?["childrenId"] = childrenId
                param?["relationship"] = relationship
            }
            else{
                param?["relationship"] = relationship
                param?["realName"] = realName
                param?["studentId"] = studentId
            }
        }
        if let avatar = avatar{
            param?["avatar"] = avatar
        }
        
    }
}

// MARK: -可加入班级的孩子
let gradeMemberChildrenList = "/grade/member/optional/children/list"
class YXSEducationGradeMemberChildrenListRequest: YXSBaseRequset {
    init(gradeId: Int) {
        super.init()
        method = .post
        path = gradeMemberChildrenList
        param = ["gradeId": gradeId]
    }
}

// MARK: - 获取阿里云OSS授权token
let ossAuthToken = "/oss/auth/token"
class YXSEducationOssAuthTokenRequest: YXSBaseRequset {
    override init() {
        super.init()
        host = ossHost
        method = .post
        path = ossAuthToken
    }
}

// MARK: - 孩子API
// MARK: -我的孩子
let childrenList = "/children/list"
class YXSEducationChildrenListRequest: YXSBaseRequset {
    override init() {
        super.init()
        method = .post
//        host = homeHost
        path = childrenList
        
    }
}

// MARK: -删除孩子
let childrenDelete = "/children/delete"
class YXSEducationChildrenDeleteRequest: YXSBaseRequset {
    init(id: Int) {
        super.init()
        method = .post
//        host = homeHost
        path = childrenDelete
        param = ["id":id]
    }
}

// MARK: -修改孩子
let childrenUpdate = "/children/update"
class YXSEducationChildrenUpdateRequest: YXSBaseRequset {
    init(parameter: [String:String]) {
        super.init()
        method = .post
        path = childrenUpdate
        param = parameter
    }
}

// MARK: - 问题反馈API
// MARK: -提交问题反馈
let feedbackSubmit = "/feedback/submit"
class YXSEducationFeedbackSubmitRequest: YXSBaseRequset {
    init(content: String) {
        super.init()
        method = .post
        path = feedbackSubmit
        param = ["content":content]
    }
}

// MARK: - 提交用户投诉
let complaintSubmit = "/complaint/submit"
class YXSEducationComplaintSubmitRequest: YXSBaseRequset {
    init(respondentId: Int, respondentType: String, type: String, content: String, screenshots: String) {
        super.init()
        method = .post
        path = complaintSubmit
        param = ["respondentId":respondentId, "respondentType":respondentType, "type":type, "content":content]
        if screenshots.count > 0 {
            param?["screenshots"] = screenshots
        }
    }
}



// MARK: - 获取分享链接
// MARK: -提交问题反馈
let shareLink = "/share/link"
class YXSEducationShareLinkRequest: YXSBaseRequset {
    init(model: HMRequestShareModel) {
        super.init()
        method = .post
        path = shareLink
        param = ["shareType":model.type.rawValue]
        if let gradeNum = model.gradeNum{
            param?["gradeNum"] = gradeNum
        }
        if let gradeName = model.gradeName{
            param?["gradeName"] = gradeName
        }
        if let headmasterName = model.headmasterName{
            param?["headmasterName"] = headmasterName
        }
        if let classCircleId = model.classCircleId{
            param?["classCircleId"] = classCircleId
        }
        if let classCircleType = model.classCircleType{
            param?["classCircleType"] = classCircleType.rawValue
        }
        if let homeworkId = model.homeworkId{
            param?["homeworkId"] = homeworkId
        }
        if let homeworkCreateTime = model.homeworkCreateTime{
            param?["homeworkCreateTime"] = homeworkCreateTime
        }
        if let clockInId = model.clockInId{
            param?["clockInId"] = clockInId
        }
        if let childrenId = model.childrenId{
            param?["childrenId"] = childrenId
        }
        if let noticeId = model.noticeId {
            param?["noticeId"] = noticeId
        }
        if let noticeCreateTime = model.noticeCreateTime {
            param?["noticeCreateTime"] = noticeCreateTime
        }
        if let censusId = model.censusId {
            param?["censusId"] = censusId
        }
        if let classId = model.classId {
            param?["classId"] = classId
        }
        if let dateType = model.dateType {
            param?["dateType"] = dateType
        }
        if let startTime = model.startTime {
            param?["startTime"] = startTime
        }
        if let endTime = model.endTime {
            param?["endTime"] = endTime
        }
    }
}


