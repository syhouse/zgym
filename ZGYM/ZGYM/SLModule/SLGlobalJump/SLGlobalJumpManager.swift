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

class SLGlobalJumpManager: NSObject {
    
    /// 防重复点击
    var hasJumpEnd: Bool = true
    
    static let sharedInstance: SLGlobalJumpManager = {
        let instance = SLGlobalJumpManager()
        // setup code
        return instance
    }()
    
    @objc func jumpBy(model: IMCustomMessageModel, fromViewControllter: UIViewController? = nil) {
        let inNavigationController = UIUtil.RootController()
        if !(inNavigationController is SLBaseTabBarController) {
            return
        }
        
        if model.serviceType == nil {
            return
        }
        
        if !hasJumpEnd {
            return
        }
        
        hasJumpEnd = false
        let tabBar: SLBaseTabBarController = inNavigationController as! SLBaseTabBarController

        let serviceType: Int = model.serviceType ?? 0
        let serviceId: Int = model.serviceId ?? 0
        let classId: Int = model.classId ?? 0
        let createTime: String = model.createTime ?? ""
        let childrenId: Int = model.childrenId ?? getChildID(classId: classId)
        
        switch serviceType {
                        case 0:
                            /// 通知
                            let model = SLHomeListModel(JSON: ["":""])
                            model?.serviceId = serviceId
                            model?.createTime = createTime
                            model?.classId = classId
                            model?.childrenId = childrenId
                            model?.serviceType = serviceType
                            let vc = SLNoticeDetailViewController.init(model: model!)
                            let visibleVC = fromViewControllter ?? getVisibleVC(inTabBarController: tabBar, index: 0)
                            visibleVC?.navigationController?.pushViewController(vc)
                            hasJumpEnd = true
                            break
                        case 1:
                            /// 作业（先请求根据数据决定跳那个vc）
                            let visibleVC = fromViewControllter ?? getVisibleVC(inTabBarController: tabBar, index: 0)
                            requestHomeworkDetail(childrenId: childrenId, homeworkCreateTime: createTime, homeworkId: serviceId) { [weak self](model) in
                                guard let weakSelf = self else {return}
                                visibleVC?.sl_pushHomeDetailVC(homeModel: model)
                                weakSelf.hasJumpEnd = true
                            }
                            break
                        case 2:
                            /// 打卡
                            let vc = SLPunchCardDetialController(clockInId: serviceId, childId: childrenId, classId: classId)
                            let visibleVC = fromViewControllter ?? getVisibleVC(inTabBarController: tabBar, index: 0)
                            visibleVC?.navigationController?.pushViewController(vc)
                            hasJumpEnd = true
                            break
                        case 3:
                            /// 接龙
                            let vc = SLSolitaireDetailController(censusId: serviceId, childrenId: childrenId, classId: classId, serviceCreateTime: createTime)
                            let visibleVC = fromViewControllter ?? getVisibleVC(inTabBarController: tabBar, index: 0)
                            visibleVC?.navigationController?.pushViewController(vc)
                            hasJumpEnd = true
                            break
                        case 4:
                            /// 成绩
                            break
                        case 5:
                            /// 优成长
                            break
                        case 6:
                            /// 班级之星
                            let model = SLClassStartClassModel(JSON: ["":""])
                            model?.classId = classId
                            var vc: UIViewController
                            if SLPersonDataModel.sharePerson.personRole == .TEACHER{
                                vc = SLClassStarSignleClassStudentDetialController.init(childreId: childrenId, classId: classId,stage: StageType.init(rawValue: model?.stage ?? "") ?? StageType.KINDERGARTEN)
                                
                            }else{
                                let chilrModel = getChildModel(classId: classId, childId: childrenId)
                                if let chilrModel = chilrModel{
                                    vc = SLClassStarPartentDetialController.init(childrenModel: chilrModel)
                                }else{
                                    MBProgressHUD.sl_showMessage(message: "当前孩子已不在班级")
                                    return
                                }
                                
                            }
                            let visibleVC = fromViewControllter ?? getVisibleVC(inTabBarController: tabBar, index: 0)
                            visibleVC?.navigationController?.pushViewController(vc)
                            hasJumpEnd = true
                            break
                        case 666:
                            getVisibleVC(inTabBarController: tabBar, index: 2)
                            hasJumpEnd = true
                            break
                        default:
                            hasJumpEnd = true
                            break
                    }
    }
    
    // MARK: - Other
    func requestHomeworkDetail(childrenId: Int, homeworkCreateTime: String, homeworkId: Int, _ completion:@escaping ((SLHomeListModel)->())) {
        SLEducationHomeworkQueryHomeworkByIdRequest(childrenId: childrenId, homeworkCreateTime: homeworkCreateTime, homeworkId: homeworkId).request({ (result: SLHomeworkDetailModel) in
            if (result.committedList?.contains(childrenId) ?? false) {
                /// 已提交
                let model = SLHomeListModel(JSON: ["":""])
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
                let model = SLHomeListModel(JSON: ["":""])
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
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    /// 检测墓碑推送跳转详情
    @objc func checkPushJump() {
        if (SLChatHelper.sharedInstance.isLogin()) {
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
                SLGlobalJumpManager.sharedInstance.jumpBy(model: model)

            } else {
                if userInfo["ext"] == nil {
                    /// 私聊c2c
                   let model = IMCustomMessageModel.init(JSON: ["": ""])!
                    model.serviceType = 666
                    SLGlobalJumpManager.sharedInstance.jumpBy(model: model)
                }
            }
        }
    }
    
    @objc func getChildID(classId: Int)-> Int {
        var childrenId: Int = 0
        
        if let childrens = self.sl_user.children {
            for sub: SLChildrenModel in childrens {
                if sub.classId == classId {
                    childrenId = sub.id ?? 0
                    break
                }
            }
        }
        return childrenId
    }
    
    @objc func getChildModel(classId: Int, childId: Int)-> SLChildrenModel? {
        if let childrens = self.sl_user.children {
            for sub: SLChildrenModel in childrens {
                if sub.classId == classId  && childId == sub.id{
                    return sub
                }
            }
        }
        return nil
    }
    
    @objc func getVisibleVC(inTabBarController:SLBaseTabBarController, index:Int)-> UIViewController? {
        
        inTabBarController.selectedIndex = index
        let nav = inTabBarController.selectedViewController
        if nav is SLRootNavController {
            let rootNav: SLRootNavController = nav as! SLRootNavController
            let vc = rootNav.visibleViewController
            return vc
            
        } else {
            return nil
        }
    }

}
