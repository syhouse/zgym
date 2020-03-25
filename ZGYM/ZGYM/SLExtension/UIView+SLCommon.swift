//
//  UIView+SLCommon.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/30.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

extension UIView {
     func sl_dealHomeAction(_ action: SLHomeActionEvent, classId: Int?, childModel: SLChildrenModel?){
        if SLPersonDataModel.sharePerson.personRole == .PARENT && classId == nil{
            UIUtil.curruntNav().pushViewController(SLClassAddController())
            return
        }
        if SLPersonDataModel.sharePerson.personRole == .TEACHER && (sl_user.gradeIds == nil || sl_user.gradeIds!.count == 0){
            UIUtil.curruntNav().pushViewController(SLTeacherClassListViewController())
            return
        }
        
        let childId: Int? = childModel?.id
        
        switch action{
        case .course:
            
            if SLPersonDataModel.sharePerson.personRole == .PARENT{
                UIUtil.curruntNav().pushViewController(SLClassScheduleCardDetialController.init( nil,childrenId: childId, classId: classId))
            }else{
                var curruntClassId: Int? = classId
                if sl_user.gradeIds!.count == 1{
                    curruntClassId = sl_user.gradeIds?.first
                }
                if let curruntClassId = curruntClassId{
                    UIUtil.curruntNav().pushViewController(SLClassScheduleCardDetialController.init( nil,childrenId: childId, classId: curruntClassId))
                }else{
                    UIUtil.curruntNav().pushViewController(SLClassScheduleCardListController.init(childId,classId: classId))
                }
                
            }
            
        case .solitaire:
            UIUtil.curruntNav().pushViewController(SLSolitaireListController(classId: classId,childId: childId))
        case .homework:
            UIUtil.curruntNav().pushViewController(SLHomeworkListController(classId: classId,childId: childId))
        case .punchCard:
            UIUtil.curruntNav().pushViewController(SLPunchCardListController(classId: classId,childId: childId))
        case .notice:
            UIUtil.curruntNav().pushViewController(SLNoticeListController(classId: classId,childId: childId))
//            UIUtil.curruntNav().pushViewController(SLPhotoClassListController())
        case .score:
            UIUtil.curruntNav().pushViewController(SLScoreDetialController())
            
        case .addressbook:
            UIUtil.curruntNav().pushViewController(SLContactController.init(classId: classId))
            break
        case .classstart:
            if SLPersonDataModel.sharePerson.personRole == .PARENT{
                
                if let childModel = childModel{
                    UIUtil.curruntNav().pushViewController(SLClassStarPartentDetialController.init(childrenModel: childModel))
                }
            }else{
                var curruntClassId: Int? = classId
                if sl_user.gradeIds!.count == 1{
                    curruntClassId = sl_user.gradeIds?.first
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

