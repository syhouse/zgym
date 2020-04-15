//
//  SLPunchCardSingleStudentListHeaderView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/30.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

let kYXSPunchCardSingleStudentListHeaderViewLookPunchDeitalEvent = "SLPunchCardSingleStudentListHeaderViewLookPunchDeitalEvent"

class YXSPunchCardSingleStudentListHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(punchCalendarShowView)
        addSubview(weekView)
        addSubview(punchCalendarView)
        
        layout()
    }
    
    func layout(){
        punchCalendarShowView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(46)
        }
        weekView.snp.remakeConstraints { (make) in
            make.top.equalTo(punchCalendarShowView.snp_bottom).offset(7)
            make.left.right.equalTo(0)
            make.height.equalTo(30)
        }
        
        punchCalendarView.snp.remakeConstraints { (make) in
            make.top.equalTo(weekView.snp_bottom).offset(10)
            make.left.right.equalTo(0)
            make.height.equalTo(180)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: YXSPunchCardModel!
    func setHeaderModel(_ model: YXSPunchCardModel){
        
        punchCalendarView.model = model
    }
    
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#D2E7FC")
        return lineView
    }()
    
    lazy var punchCalendarShowView: YXSPunchCalendarShowView = {
        let punchCalendarShowView = YXSPunchCalendarShowView()
        return punchCalendarShowView
    }()
    
    
    
    lazy var weekView: YXSPunchWeekView = {
        let weekView = YXSPunchWeekView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        return weekView
    }()
    lazy var punchCalendarView: YXSPunchCalendarView = {
        let calendarViewFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 180)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (SCREEN_WIDTH - 41)/7, height: 30)
        let punchCalendarView = YXSPunchCalendarView(frame: calendarViewFrame, collectionViewLayout: layout)
        punchCalendarView.date = Date()
        punchCalendarView.showOnlyInWeek = false
        return punchCalendarView
    }()
}

// MARK: -HMRouterEventProtocol
extension YXSPunchCardSingleStudentListHeaderView: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        next?.yxs_routerEventWithName(eventName: eventName, info: info)
        switch eventName {
        case kYXSPunchCalendarShowViewChangeCalendarEvent:
            punchCalendarView.date = info![kEventKey] as! Date
        default:
            break
        }
    }
}
