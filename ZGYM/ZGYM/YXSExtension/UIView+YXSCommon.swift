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
            UIUtil.curruntNav().pushViewController(YXSClassAddController())
            return
        }
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER && (yxs_user.gradeIds == nil || yxs_user.gradeIds!.count == 0){
            UIUtil.curruntNav().pushViewController(YXSTeacherClassListViewController())
            return
        }
        
        let childId: Int? = childModel?.id
        
        switch action{
        case .course:
            
            if YXSPersonDataModel.sharePerson.personRole == .PARENT{
                UIUtil.curruntNav().pushViewController(YXSClassScheduleCardDetialController.init( nil,childrenId: childId, classId: classId))
            }else{
                var curruntClassId: Int? = classId
                if yxs_user.gradeIds!.count == 1{
                    curruntClassId = yxs_user.gradeIds?.first
                }
                if let curruntClassId = curruntClassId{
                    UIUtil.curruntNav().pushViewController(YXSClassScheduleCardDetialController.init( nil,childrenId: childId, classId: curruntClassId))
                }else{
                    UIUtil.curruntNav().pushViewController(YXSClassScheduleCardListController.init(childId,classId: classId))
                }
                
            }
            
        case .solitaire:
            UIUtil.curruntNav().pushViewController(SLSolitaireListController(classId: classId,childId: childId))
        case .homework:
            UIUtil.curruntNav().pushViewController(YXSHomeworkListController(classId: classId,childId: childId))
        case .punchCard:
            UIUtil.curruntNav().pushViewController(YXSPunchCardListController(classId: classId,childId: childId))
        case .notice:
            UIUtil.curruntNav().pushViewController(SLNoticeListController(classId: classId,childId: childId))
        case .photo:
            UIUtil.curruntNav().pushViewController(SLPhotoClassListController())
        case .score:
            UIUtil.curruntNav().pushViewController(YXSScoreDetialController())
            
        case .addressbook:
            UIUtil.curruntNav().pushViewController(YXSContactController.init(classId: classId))
            break
        case .classstart:
            if YXSPersonDataModel.sharePerson.personRole == .PARENT{
                
                if let childModel = childModel{
                    UIUtil.curruntNav().pushViewController(SLClassStarPartentDetialController.init(childrenModel: childModel))
                }
            }else{
                var curruntClassId: Int? = classId
                if yxs_user.gradeIds!.count == 1{
                    curruntClassId = yxs_user.gradeIds?.first
                }
                if let curruntClassId = curruntClassId{
                    UIUtil.curruntNav().pushViewController(SLClassStarSignleClassDetialController.init(classId: curruntClassId))
                }else{
                    UIUtil.curruntNav().pushViewController(SLClassStartTeacherClassListController())
                }
                
            }
        default:break
        }
    }
}

