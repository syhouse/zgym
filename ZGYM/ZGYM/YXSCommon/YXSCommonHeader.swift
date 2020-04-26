//
//  YXSCommonHeader.swift
//  SwiftBase
//
//  Created by zgjy_mac on 2019/9/10.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

///*提*包*UI 默认为 true
public let isOldUI = false

// MARK: - 尺寸
public let IsiphoneX: Bool = UIApplication.shared.statusBarFrame.size.height > 20.0
public let kSafeTopHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height - 20.0
public let kSafeBottomHeight: CGFloat = IsiphoneX ? 34.0 : 0.0
public let SCREEN_WIDTH = UIScreen.main.bounds.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.height
public let SCREEN_SCALE = UIScreen.main.bounds.width/375.0
public let kTabBottomHeight: CGFloat = kSafeBottomHeight + 49.0

// MARK: - color
/// 正文颜色
public let kTextMainBodyColor = UIColor.yxs_hexToAdecimalColor(hex: "#222222")

/// 正文字体
public let kTextMainBodyFont = UIFont.systemFont(ofSize: 16)

/// 333333
public let kTextBlackColor = UIColor.yxs_hexToAdecimalColor(hex: "#333333")

/// 575A60
public let kTextLightBlackColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")


/// C4CDDA
public let kTextLightColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")


/// 5E88F7
public var kBlueColor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")
public let kRedColor = UIColor.yxs_hexToAdecimalColor(hex: "#F92433")
public let kYellowColor = UIColor.yxs_hexToAdecimalColor(hex: "#FFBA38")
public let kLineColor = UIColor.yxs_hexToAdecimalColor(hex: "#D6E3FD")
public let kBorderGrayColor = UIColor.yxs_hexToAdecimalColor(hex: "#D6D8DA")
public let kBackgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#f5f5f5")
public let kTableViewBackgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#f2f5f9")
public let kBlueShadowColor = UIColor.yxs_hexToAdecimalColor(hex: "#4C74F6")
public let kGrayShadowColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
public let k575A60Color = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
public let kF3F5F9Color = UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9")
public let kC1CDDBColor = UIColor.yxs_hexToAdecimalColor(hex: "#C1CDDB")
public let k000000Color = UIColor.yxs_hexToAdecimalColor(hex: "#000000")
public let k797B7EColor = UIColor.yxs_hexToAdecimalColor(hex: "#797B7E")
public let k222222Color = kTextMainBodyColor
public let kFFFDFEColor = UIColor.yxs_hexToAdecimalColor(hex: "#FFFDFE")
public let k131313Color = UIColor.yxs_hexToAdecimalColor(hex: "#131313")

///新版本主色调
public let kRedMainColor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")

/// #191A21夜间背景主色调  
public let kNightBackgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#191A21")
/// #20232F卡片 cell夜间色调  导航栏 tabbar
public let kNightForegroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#20232F")
/// #BCC6D4最浅的色调
public let kNightLightForegroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#BCC6D4")
///夜间文字颜色
public let kNight898F9A = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
public let kNight6E7075 = UIColor.yxs_hexToAdecimalColor(hex: "#6E7075")
public let kNightBBC5D3 = UIColor.yxs_hexToAdecimalColor(hex: "#BBC5D3")
public let kNight5E88F7 = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")
public let kNightBCC6D4 = UIColor.yxs_hexToAdecimalColor(hex: "#BCC6D4")
/// 夜间弹框背景色
public let kNight282C3B = UIColor.yxs_hexToAdecimalColor(hex: "#282C3B")
/// 夜间弹框按钮背景色
public let kNight383E56 = UIColor.yxs_hexToAdecimalColor(hex: "#383E56")

public let kNight20222F = UIColor.yxs_hexToAdecimalColor(hex: "#20222F")

/// 白色
public let kNightFFFFFF = UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF")
/// 夜间输入框背景颜色
public let kNight2C3144 = UIColor.yxs_hexToAdecimalColor(hex: "#2C3144")
/// 夜间私聊聊天bar背景色
public let kNight20232F = UIColor.yxs_hexToAdecimalColor(hex: "#20232F")


/// 横线颜色
public let kNight2F354B = UIColor.yxs_hexToAdecimalColor(hex: "#2F354B")

// MARK: - string
public let KIMAPPID = "8779ee49bf4d328a791594f887a45d11"
public let KIMAPPSECRET = "3ef96693c787"
public let KWXAPPID = "wx9f73387249e2b572"
public let KWXUNIVERSAL_LINK = "https://call.c989.cn/open/"
public let KQQ_LINK = "https://call.c989.cn/qq_conn/1110343963"
public let KQQAPPID = "1110343963"
//call.c989.cn/.
// MARK: -key
public let kEventKey = "EventKey"
public let kValueKey = "ValueKey"
public let kNotificationModelKey = "NotificationModelKey"
public let kNotificationIdKey = "NotificationIdKey"
public let kNotificationIsCancelKey = "NotificationIsCancelKey"
public let kNotificationIsDelectKey = "NotificationIsDelectKey"
public let kMediaDirectory = "HMMediaDirectory"
public let kIsNotFirstLuanchKey = "IsNotFirstLuanchKey"
public let kAppleDeviceToken = "AppleDeviceToken"


public var kAddressbookKey = "yxs_addressbook"
public var kClassStartKey = "yxs_classstart"
public var kFoodKey = "yxs_food"
public var kPunchCardKey = "yxs_punchCard"
public var kHomeworkKey = "yxs_homework"
public var kNoticeKey = "yxs_notice"
public var kSolitaireKey = "yxs_solitaire"
public var kScoreKey = "yxs_score"
public var kCourseKey = "yxs_course"
///视频后缀
public let kHMVedioAppendKey = "_HMVideo"
//
/// 显示用户协议
public let kShowPrivacyProtocolKey = "ShowPrivacyProtocolKey"
public let kPageSize = 20
///还剩多少条数据进行预加载
public let kPreloadSize = 5
public let JGAppkey = "a0cd7307b3360d5a618fcfa1"


// MARK: - Notification
// MARK: -IM通知
/// 收到自然人推送过来的消息
public let kUserChatCallRefreshNotification = "ChatCallRefreshNotification"
/// 收到spy用户推过来的IM通知
public let kChatCallRefreshNotification = "ChatCallRefreshNotification"
/// 收到spy用户推过来的IM通知 更新朋友圈消息
public let kChatCallRefreshFriendsCircleNotification = "ChatCallRefreshFriendsCircleNotification"
/// 收到spy用户推过来的IM通知 更新朋友圈消息
public let kChatCallRefreshPunchCardNotification = "ChatCallRefreshPunchCardNotification"
/// 收到spy用户推过来的IM作业互动通知 更新作业互动消息数量
public let kChatCallRefreshHomeworkNotification = "ChatCallRefreshHomeworkNotification"

// MARK: -置顶通知
/// 单个班级首页操作置顶
public let kOperationUpdateToTopInSingleClassHomeNotification = "OperationUpdateToTopInSingleClassHomeNotification"
/// 列表操作置顶
public let kOperationUpdateToTopInItemListNotification = "OperationUpdateToTopInItemListNotification"
/// 详情页操作置顶
public let kOperationUpdateToTopInItemDetailNotification = "OperationUpdateToTopInItemDetailNotification"

// MARK: -撤销通知
/// 单个班级首页撤销
public let kOperationRecallInSingleClassHomeNotification = "OperationRecallInSingleClassHomeNotification"
/// 列表操作撤销
public let kOperationRecallInItemListNotification = "OperationRecallInItemListNotification"
/// 幼儿版首页撤销
public let kOperationRecallInHomeNotification = "OperationRecallInHomeNotification"
/// 幼儿版班级圈首页撤销
public let kOperationRecallInFriendCirleNotification = "OperationRecallInFriendCirleNotification"
/// 作业详情家长作业撤销
public let kOperationStudentWorkNotification = "OperationStudentWorkNotification"

// MARK: - 打卡通知

/// 打卡家长撤销   (通知带打卡id  后期优化 自己处理数据) 
public let kOperationStudentCancelPunchCardNotification = "OperationStudentCancelPunchCardNotification"

/// 打卡家长修改(object 为修改后的model)
public let kOperationStudentChangePunchCardNotification = "OperationStudentChangePunchCardNotification"

// MARK: -点赞更新通知
/// 列表操作点赞
public let kOperationPraiseInItemListNotification = "OperationPraiseInItemListNotification"
///  幼儿版首页点赞操作
public let kOperationPraiseInItemHomeNotification = "OperationPraiseInItemHomeNotification"
///  幼儿版班级圈首页点赞操作
public let kOperationPraiseInItemFriendCirleNotification = "OperationPraiseInItemFriendCirleNotification"

// MARK: -评论更新通知
/// 列表操作评论
public let kOperationCommentInItemListNotification = "OperationCommentInItemListNotification"
///  幼儿版首页评论操作
public let kOperationCommentInItemHomeNotification = "OperationCommentInItemHomeNotification"
///  幼儿版班级圈首页评论操作
public let kOperationCommentInItemFriendCirleNotification = "OperationCommentInItemFriendCirleNotification"


// MARK: -发布提交阅读

/// 老师发布成功(通知 打卡 接龙 作业 幼儿版朋友圈 成绩)
public let kTeacherPublishSucessNotification = "TeacherPublishSucessNotification"

/// 家长提交成功(通知 打卡 接龙 作业 )
public let kParentSubmitSucessNotification = "ParentSubmitSucessNotification"

/// 家长阅读成功(通知 作业 )
public let kParentReadSucessNotification = "ParentReadSucessNotification"

// MARK: -用户相关

/// 我的-切换学段成功
public let kMineChangeStageNotification = "MineChangeStageNotification"
/// 我的-切换身份成功
public let kMineChangeRoleNotification = "MineChangeRoleNotification"
/// 我的-修改用户信息成功(老师、家长、孩子)
public let kMineChangeProfileNotification = "MineChangeProfileNotification"

// MARK: -class相关
/// 加入班级成功
public let kAddClassSucessNotification = "kAddClassSucessNotification"
/// 退出班级成功
public let kQuitClassSucessNotification = "kQuitClassSucessNotification"
/// 创建班级成功
public let kCreateClassSucessNotification = "CreateClassSucessNotification"
/// 删除孩子成功
public let kDelectChildSucessNotification = "DelectChildSucessNotification"

// MARK: -其他
public let kUpdateClassStarScoreNotification = "UpdateClassStarScoreNotification"
/// 待办红点
public let kHomeAgendaReducNotification = "HomeAgendaReducNotification"
/// 首页红点
public let kHomeCellReducNotification = "HomeCellReducNotification"
/// 主题切换
public let kThemeChangeNotification = "ThemeChangeNotification"

// MARK: - 静态变量

/// 通用时间格式
public var kCommonDateFormatString = "yyyy-MM-dd HH:mm:ss"


/// 主要内容行间距(作业、通知、接龙、打卡首页与详情的行间距,优成长)
public let kMainContentLineHeight: CGFloat = 8

/// 视频拍摄时长
public let kVedioLength: Int = 15

public var kImageDefualtImage = UIImage.init(named: "defultImage")

public var kImageUserIconPartentDefualtImage = UIImage.init(named: "yxs_defult_partent")
public var kImageUserIconTeacherDefualtImage = UIImage.init(named: "yxs_defult_teacher")
public var kImageUserIconStudentDefualtImage = UIImage.init(named: "yxs_defult_student")

public let kImageDefualtMixedImage = MixedImage(normal: "defultImage", night: "defultImage_night")
public let kImageUserIconPartentDefualtMixedImage = MixedImage(normal: "yxs_defult_partent", night: "yxs_defult_partent_night")
public let kImageUserIconTeacherDefualtMixedImage = MixedImage(normal: "yxs_defult_teacher", night: "yxs_defult_teacher_night")
public let kImageUserIconStudentDefualtMixedImage = MixedImage(normal: "yxs_defult_student", night: "yxs_defult_student_night")

// MARK: - log
/// Log信息
public func SLLog <T>(_ message : T, file : String = #file, method: String = #function, lineNumber : Int = #line) {
    if isDebug{
        print(yxs_getLogTimeNow()+"[\((file as NSString).lastPathComponent.replacingOccurrences(of:".swift", with:"")):\(lineNumber)]:[\(method)]\n **START PRINT**\n \(message)\n **END PRINT**")
    }
    
}

///是否为debug模式
public var isDebug: Bool {
    get {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}
public func yxs_getLogTimeNow()-> String{
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return dateFormatter.string(from: Date())
    
}
