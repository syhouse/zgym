//
//  HomeCell.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/15.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

//通知、作业、打卡、接龙、成绩  班级之星的评价
enum HomeType: Int{
    case notice = 0
    case homework
    case punchCard
    case solitaire//接龙
    case classstart//班级之星
    case friendCicle//朋友圈
    case score
}



class SLHomeCell: SLHomeBaseCell {
    override func sl_setCellModel(_ model: SLHomeListModel){
        self.model = model
        switch model.type {
        case .score:
            break
        case .classstart:
            break
        case .friendCicle,.notice,.homework,.punchCard,.solitaire:
            break
        }
    }
    
    // MARK: -action
    override func showAllClick(){
        model.isShowAll = !model.isShowAll
        showAllControl.isSelected = model.isShowAll
        cellBlock?(.showAll)
    }
    override func sl_recallClick(){
        cellBlock?(.recall)
    }
    
    
    // MARK: -UI
    private func layout(){
 
        
  
    }

}
