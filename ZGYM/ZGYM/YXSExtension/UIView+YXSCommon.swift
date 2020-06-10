//
//  UIView+SLCommon.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/30.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

extension UIView {
     func yxs_dealHomeAction(_ action: YXSHomeHeaderActionEvent, classId: Int?, childModel: YXSChildrenModel?){
        if YXSPersonDataModel.sharePerson.personRole == .PARENT && classId == nil{
            UIUtil.currentNav().pushViewController(YXSClassAddController())
            return
        }
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER && (yxs_user.gradeIds == nil || yxs_user.gradeIds!.count == 0){
            UIUtil.currentNav().pushViewController(YXSTeacherClassListViewController())
            return
        }
        
        let childId: Int? = childModel?.id
        
        switch action{
        case .course:
            
            if YXSPersonDataModel.sharePerson.personRole == .PARENT{
                UIUtil.currentNav().pushViewController(YXSClassScheduleCardDetialController.init( nil,childrenId: childId, classId: classId))
            }else{
                var currentClassId: Int? = classId
                if yxs_user.gradeIds!.count == 1{
                    currentClassId = yxs_user.gradeIds?.first
                }
                if let currentClassId = currentClassId{
                    UIUtil.currentNav().pushViewController(YXSClassScheduleCardDetialController.init( nil,childrenId: childId, classId: currentClassId))
                }else{
                    UIUtil.currentNav().pushViewController(YXSClassScheduleCardListController.init(childId,classId: classId))
                }
                
            }
            
        case .solitaire:
            UIUtil.currentNav().pushViewController(YXSSolitaireListController(classId: classId,childId: childId))
        case .homework:
            UIUtil.currentNav().pushViewController(YXSHomeworkListController(classId: classId,childId: childId))
        case .punchCard:
            UIUtil.currentNav().pushViewController(YXSPunchCardListController(classId: classId,childId: childId))
        case .notice:
            UIUtil.currentNav().pushViewController(YXSNoticeListController(classId: classId,childId: childId))
        case .photo:
            UIUtil.currentNav().pushViewController(YXSPhotoClassListController())
        case .score:
            
            UIUtil.currentNav().pushViewController(YXSScoreListController(classId: classId ?? 0,childId: childId ?? 0))
            
        case .addressbook:
//            UIUtil.currentNav().pushViewController(YXSPhotoClassListController())
            UIUtil.currentNav().pushViewController(YXSContactController.init(classId: classId))
            break
        case .classstart:
            if YXSPersonDataModel.sharePerson.personRole == .PARENT{
                
                if let childModel = childModel{
                    UIUtil.currentNav().pushViewController(YXSClassStarPartentDetialController.init(childrenModel: childModel))
                }
            }else{
                var currentClassId: Int? = classId
                if yxs_user.gradeIds!.count == 1{
                    currentClassId = yxs_user.gradeIds?.first
                }
                if let currentClassId = currentClassId{
                    UIUtil.currentNav().pushViewController(YXSClassStarTeacherSignleClassDetialController.init(classId: currentClassId))
                }else{
                    UIUtil.currentNav().pushViewController(YXSClassStartTeacherClassListController())
                }
                
            }
        default:break
        }
    }
}

