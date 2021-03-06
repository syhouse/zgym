//
//  SLGlobalJumpManager.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/2/26.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

class YXSGlobalJumpManager: NSObject {
    
    /// 防重复点击
    var hasJumpEnd: Bool = true
    
    static let sharedInstance: YXSGlobalJumpManager = {
        let instance = YXSGlobalJumpManager()
        // setup code
        return instance
    }()
    
    @objc func yxs_jumpBy(model: IMCustomMessageModel, fromViewControllter: UIViewController? = nil) {
        let inNavigationController = UIUtil.RootController()
        if !(inNavigationController is YXSBaseTabBarController) {
            return
        }
        
        if model.serviceType == nil {
            return
        }
        
        if !hasJumpEnd {
            return
        }
        
        hasJumpEnd = false
        let tabBar: YXSBaseTabBarController = inNavigationController as! YXSBaseTabBarController
        
        let serviceType: Int = model.serviceType ?? 0
        let serviceId: Int = model.serviceId ?? 0
        let classId: Int = model.classId ?? 0
        let createTime: String = model.createTime ?? ""
        var childrenId: Int = model.childrenId ?? getChildID(classId: classId)
        
        
        if serviceType == 666 {
            /// 跳私聊
            getVisibleVC(inTabBarController: tabBar, index: 3)
            hasJumpEnd = true
            return
        }
        
        /// 判断是否退班
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            if !(yxs_user.gradeIds?.contains(classId) ?? false) {
                MBProgressHUD.yxs_showMessage(message: "查看失败，当前老师已退出班级")
                hasJumpEnd = true
                return
            }
            
        } else if serviceType != 101 {
            if !checkClassIncludesChildren(childrenId: childrenId, classId: classId) {
                hasJumpEnd = true
                return
            }
        }
        
        switch serviceType {
        case 0:
            /// 通知
            let model = YXSHomeListModel(JSON: ["":""])
            model?.serviceId = serviceId
            model?.createTime = createTime
            model?.classId = classId
            model?.childrenId = childrenId
            model?.serviceType = serviceType
            let vc = YXSNoticeDetailViewController.init(model: model!)
            let visibleVC = fromViewControllter ?? getVisibleVC(inTabBarController: tabBar, index: 0)
            visibleVC?.navigationController?.pushViewController(vc)
            hasJumpEnd = true
            break
        case 1:
            /// 作业（先请求根据数据决定跳那个vc）
            let visibleVC = fromViewControllter ?? getVisibleVC(inTabBarController: tabBar, index: 0)
            requestHomeworkDetail(childrenId: childrenId, homeworkCreateTime: createTime, homeworkId: serviceId) { [weak self](model) in
                guard let weakSelf = self else {return}
                visibleVC?.yxs_pushHomeDetailVC(homeModel: model,selectChildrenId: childrenId)
                weakSelf.hasJumpEnd = true
            }
            break
        case 2:
            /// 打卡
            let vc = YXSPunchCardDetialController(clockInId: serviceId, childId: childrenId, classId: classId)
            let visibleVC = fromViewControllter ?? getVisibleVC(inTabBarController: tabBar, index: 0)
            visibleVC?.navigationController?.pushViewController(vc)
            hasJumpEnd = true
            break
        case 3:
            /// 接龙
            var vc: UIViewController!
            if model.callbackRequestParameter?.type == 1{
                vc = YXSSolitaireDetailController(censusId: serviceId, childrenId: childrenId, classId: classId, serviceCreateTime: createTime)
            }else{
                vc = YXSSolitaireNewDetailController(censusId: serviceId, childrenId: childrenId, classId: classId, serviceCreateTime: createTime)
            }
            let visibleVC = fromViewControllter ?? getVisibleVC(inTabBarController: tabBar, index: 0)
            visibleVC?.navigationController?.pushViewController(vc)
            hasJumpEnd = true
            break
        case 4:
            /// 成绩
            if model.childrenId ?? 0 == 0 {
                childrenId = self.yxs_user.currentChild?.id ?? 0
            }
            
            let scoreModel = YXSScoreListModel.init(JSON: ["":""])!
            scoreModel.examId = serviceId
            scoreModel.classId = classId
            scoreModel.creationTime = createTime
            if YXSPersonDataModel.sharePerson.personRole == .PARENT {
                /// 标记页面已读
                YXSEducationScoreChildDetailsRequset.init(examId: serviceId, childrenId: childrenId).request({ (json) in
                    
                    let detailsModel = Mapper<YXSScoreDetailsModel>().map(JSONObject:json.object) ?? YXSScoreDetailsModel.init(JSON: ["": ""])!
                    if !(detailsModel.isRead ?? false) {
                        let listModel = YXSHomeListModel.init(JSON: ["":""])
                        listModel?.childrenId = childrenId
                        listModel?.serviceId = serviceId
                        listModel?.isRead = 0
                        listModel?.serviceType = 4
                        UIUtil.yxs_loadReadData(listModel!)
                    }
                }) { (msg, code) in
                    
                }
            } 
            let visibleVC = fromViewControllter ?? getVisibleVC(inTabBarController: tabBar, index: 0)
            if let strategy = model.callbackRequestParameter?.calculativeStrategy, strategy == 10 {
                /// 分数制
                if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                    let detail = YXSScoreNumTeacherDetailsVC.init(model: scoreModel)
                    visibleVC?.navigationController?.pushViewController(detail)
                } else {
                    
                    let detail = YXSScoreNumParentDetailsVC.init(model: scoreModel)
                    detail.examId = serviceId
                    detail.childrenId = childrenId
                    visibleVC?.navigationController?.pushViewController(detail)
                }
            } else {
                /// 等级制
                if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                    let detail = YXSScoreLevelTeacherDetailsVC.init(model: scoreModel)
                    visibleVC?.navigationController?.pushViewController(detail)
                    
                } else {
                    let detail = YXSScoreLevelParentDetailsVC.init(model: scoreModel)
                    detail.examId = serviceId
                    detail.childrenId = childrenId
                    visibleVC?.navigationController?.pushViewController(detail)
                }
            }
            hasJumpEnd = true
            break
        case 5:
            /// 优成长
            break
        case 6:
            /// 班级之星
            var vc: UIViewController
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                vc = YXSClassStarSignleClassStudentDetialController.init(childreId: childrenId, classId: classId,stage: StageType.init(rawValue: model.stage ?? "") ?? StageType.KINDERGARTEN)
                
            }else{
                let chilrModel = getChildModel(classId: classId, childId: childrenId)
                if let chilrModel = chilrModel{
                    vc = YXSClassStarPartentDetialController.init(childrenModel: chilrModel)
                }else{
                    MBProgressHUD.yxs_showMessage(message: "当前孩子已不在班级")
                    return
                }
                
            }
            let visibleVC = fromViewControllter ?? getVisibleVC(inTabBarController: tabBar, index: 0)
            visibleVC?.navigationController?.pushViewController(vc)
            hasJumpEnd = true
            break
        case 7:
            ///班级相册
            let vc = YXSPhotoAlbumDetialListController(classId: classId, albumsId: model.serviceId ?? 0)
            let visibleVC = fromViewControllter ?? getVisibleVC(inTabBarController: tabBar, index: 0)
            visibleVC?.navigationController?.pushViewController(vc)
            hasJumpEnd = true
        case 666:
            //                            getVisibleVC(inTabBarController: tabBar, index: 2)
            //                            hasJumpEnd = true
            break
        case 100:
            //打卡 优化 判断当前vc是不是YXSPunchCardSingleStudentBaseListController 并且clockInId和clockInCommitId一致 一致的话刷新当前页面
            let visibleVC = fromViewControllter ?? getVisibleVC(inTabBarController: tabBar, index: 0)
            let vc = YXSPunchCardSingleStudentBaseListController.init(clockInId: model.callbackRequestParameter?.clockInId ?? 0, clockInCommitId: model.callbackRequestParameter?.clockInCommitId ?? 0, isMyPublish: false, classId: model.classId ?? 0, topHistoryModel: nil, operationChildrenId: childrenId)
            visibleVC?.navigationController?.pushViewController(vc)
            hasJumpEnd = true
            break
            
        case 101:
            //家长的作业的评论回复
            let visibleVC = fromViewControllter ?? getVisibleVC(inTabBarController: tabBar, index: 0)
            let detailModel = YXSHomeworkDetailModel(JSON: ["":""])
            let messageModel = YXSHomeworkMessageModel(JSON: ["":""])
            messageModel?.childrenId = childrenId
            let homeModel = YXSHomeListModel(JSON: ["":""])
            homeModel?.createTime = createTime
            homeModel?.serviceId = serviceId
            let vc = YXSHomeworkMessageVC(deModel: detailModel!, model: homeModel!, messageModel: messageModel!)
            visibleVC?.navigationController?.pushViewController(vc)
            hasJumpEnd = true
            break

        default:
            hasJumpEnd = true
            break
        }
        
        hasJumpEnd = true
    }
    
    // MARK: - Other
    func requestHomeworkDetail(childrenId: Int, homeworkCreateTime: String, homeworkId: Int, _ completion:@escaping ((YXSHomeListModel)->())) {
        YXSEducationHomeworkQueryHomeworkByIdRequest(childrenId: childrenId, homeworkCreateTime: homeworkCreateTime, homeworkId: homeworkId).request({ (result: YXSHomeworkDetailModel) in
            if (result.committedList?.contains(childrenId) ?? false) {
                /// 已提交
                let model = YXSHomeListModel(JSON: ["":""])
                model?.childrenId = childrenId
                model?.createTime = homeworkCreateTime
                model?.serviceId = homeworkId
                model?.commitState = 2
                model?.serviceType = 1
                model?.teacherId = result.teacherId
                model?.classId = result.classId
                model?.className = result.className
                completion(model!)
                
            } else {
                /// 未提交
                let model = YXSHomeListModel(JSON: ["":""])
                model?.childrenId = childrenId
                model?.createTime = homeworkCreateTime
                model?.serviceId = homeworkId
                model?.commitState = 1
                model?.classId = result.classId
                model?.className = result.className
                model?.serviceType = 1
                model?.teacherId = result.teacherId
                completion(model!)
            }
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    /// 检测墓碑推送跳转详情
    @objc func checkPushJump() {
        if (YXSChatHelper.sharedInstance.isLogin()) {
            let obj = UserDefaults.standard.value(forKey: "kReceiveRemoteNotification")
            
            if !(obj is [AnyHashable : Any]) {
                return
            }
            UserDefaults.standard.removeObject(forKey: "kReceiveRemoteNotification")
            UserDefaults.standard.synchronize()
            
            let userInfo = obj as! [AnyHashable : Any]
            if userInfo["ext"] is String {
                let strDic:String = userInfo["ext"] as! String
                let data = strDic.data(using: String.Encoding.utf8)
                let dic = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any]
                let model = Mapper<IMCustomMessageModel>().map(JSONObject:dic) ?? IMCustomMessageModel.init(JSON: ["": ""])!
                YXSGlobalJumpManager.sharedInstance.yxs_jumpBy(model: model)
                
            } else {
                if userInfo["ext"] == nil {
                    /// 私聊c2c
                    let model = IMCustomMessageModel.init(JSON: ["": ""])!
                    model.serviceType = 666
                    YXSGlobalJumpManager.sharedInstance.yxs_jumpBy(model: model)
                }
            }
        }
    }
    
    /// 判断孩子是否在当前班级
    @objc func checkClassIncludesChildren(childrenId: Int, classId: Int) -> Bool {
        for sub in yxs_user.children ?? [] {
            if sub.id == childrenId && sub.classId == classId {
                return true
            }
        }
        MBProgressHUD.yxs_showMessage(message: "查看失败，当前孩子已退出班级")
        return false
    }
    
    @objc func getChildID(classId: Int)-> Int {
        var childrenId: Int = 0
        
        if let childrens = self.yxs_user.children {
            for sub: YXSChildrenModel in childrens {
                if sub.classId == classId {
                    childrenId = sub.id ?? 0
                    break
                }
            }
        }
        return childrenId
    }
    
    @objc func getChildModel(classId: Int, childId: Int)-> YXSChildrenModel? {
        if let childrens = self.yxs_user.children {
            for sub: YXSChildrenModel in childrens {
                if sub.classId == classId  && childId == sub.id{
                    return sub
                }
            }
        }
        return nil
    }
    
    @objc func getVisibleVC(inTabBarController:YXSBaseTabBarController, index:Int)-> UIViewController? {
        
        inTabBarController.selectedIndex = index
        let nav = inTabBarController.selectedViewController
        if nav is YXSRootNavController {
            let rootNav: YXSRootNavController = nav as! YXSRootNavController
            let vc = rootNav.visibleViewController
            return vc
            
        } else {
            return nil
        }
    }
    
}
