//
//  SLPunchCardMainView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/30.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

let kSLPunchCardMainViewLookPunchDeitalEvent = "SLPunchCardMainViewLookPunchDeitalEvent"

class SLPunchCardMainView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        addSubview(punchDaysView)
        addSubview(leftLabel)
        addSubview(rightlabel)
        addSubview(signDaysLabel)
        addSubview(sortControl)
        addSubview(lineView)
        addSubview(punchCalendarShowView)
        addSubview(weekView)
        addSubview(punchCalendarView)
        addSubview(showAllButton)
        
        addSubview(punchCardBottomView)
        addSubview(leftCicleView)
        addSubview(rightCicleView)
        addSubview(dottedView)
        
        layout()
    }
    
    func layout(){
        rightlabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(leftLabel)
            make.size.equalTo(CGSize.init(width: 30.5, height: 38.5))
            make.left.equalTo(leftLabel.snp_right).offset(5.5)
        }
        
        signDaysLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(leftLabel)
            make.left.equalTo(rightlabel.snp_right).offset(11)
        }
        sortControl.snp.makeConstraints { (make) in
            make.centerY.equalTo(leftLabel)
            make.right.equalTo(-16)
            make.height.equalTo(20)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(rightlabel.snp_bottom).offset(15.5)
            make.height.equalTo(0.5)
        }
        punchCalendarShowView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp_bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(58.5)
        }
        weekView.snp.makeConstraints { (make) in
            make.top.equalTo(punchCalendarShowView.snp_bottom).offset(5)
            make.left.right.equalTo(0)
            make.height.equalTo(30)
        }
        
        punchCalendarView.snp.makeConstraints { (make) in
            make.top.equalTo(weekView.snp_bottom).offset(10)
            make.left.right.equalTo(0)
            make.height.equalTo(180)
        }
        showAllButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(punchCalendarView.snp_bottom).offset(15)
            make.size.equalTo(CGSize.init(width: 23.5, height: 28.5))
        }
        
        dottedView.snp.makeConstraints { (make) in
            make.top.equalTo(showAllButton.snp_bottom).offset(8.5)
            make.left.equalTo(7.5)
            make.right.equalTo(-7.5)
            make.height.equalTo(1)
        }
        leftCicleView.snp.makeConstraints { (make) in
            make.centerY.equalTo(dottedView)
            make.left.equalTo(-7.5)
            make.size.equalTo(CGSize.init(width: 15, height: 15))
        }
        rightCicleView.snp.makeConstraints { (make) in
            make.centerY.equalTo(dottedView)
            make.right.equalTo(7.5)
            make.size.equalTo(CGSize.init(width: 15, height: 15))
        }
        
        punchCardBottomView.snp.makeConstraints { (make) in
            make.top.equalTo(dottedView.snp_bottom)
            make.height.equalTo(96.5).priorityHigh()
            make.left.right.equalTo(0)
            make.bottom.equalTo(0).priorityHigh()
        }
        
        //默认收起
        showAllButton.isSelected = true
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: SLPunchCardModel!
    func setHeaderModel(_ model: SLPunchCardModel){
        punchDaysView.isHidden = true
        self.model = model
        if SLPersonDataModel.sharePerson.personRole == .PARENT {
            punchDaysView.isHidden = false
            punchDaysView.snp.remakeConstraints { (make) in
                make.top.left.right.equalTo(0)
                make.height.equalTo(53)
            }
            
            leftLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(punchDaysView.snp_bottom).offset(20)
                make.size.equalTo(CGSize.init(width: 30.5, height: 38.5))
                make.left.equalTo(16)
            }
            sortControl.title = "打卡排行"
            
        }else{
            
            leftLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(38)
                make.size.equalTo(CGSize.init(width: 30.5, height: 38.5))
                make.left.equalTo(16)
            }
            sortControl.title = "打卡统计"
        }
        leftLabel.setTitle("\((model.currentClockInDayNo ?? 0)/10)", for: .normal)
        rightlabel.setTitle("\((model.currentClockInDayNo ?? 0)%10)", for: .normal)
        punchCardBottomView.setViewModel(model)
        signDaysLabel.text = "\(model.currentClockInDayNo ?? 0)/\(model.totalDay ?? 0)天"
        punchDaysView.setViewModel(model)
        
        punchCalendarView.model = model
    }
    
    @objc func lookDetialClick(){
        next?.sl_routerEventWithName(eventName: kSLPunchCardMainViewLookPunchDeitalEvent)
    }
    @objc func showClick(){
        showAllButton.isSelected = !showAllButton.isSelected
        punchCalendarView.showOnlyInWeek = showAllButton.isSelected
        updateUI()
    }
    
    func updateUI(){
        if showAllButton.isSelected {
            punchCalendarShowView.isHidden = true
            weekView.snp.remakeConstraints { (make) in
                make.top.equalTo(lineView.snp_bottom)
                make.left.right.equalTo(0)
                make.height.equalTo(30)
            }
            punchCalendarView.snp.remakeConstraints { (make) in
                make.top.equalTo(weekView.snp_bottom).offset(10)
                make.left.right.equalTo(0)
                make.height.equalTo(30)
            }
        }else{
            punchCalendarShowView.isHidden = false
            weekView.snp.remakeConstraints { (make) in
                make.top.equalTo(punchCalendarShowView.snp_bottom).offset(5)
                make.left.right.equalTo(0)
                make.height.equalTo(30)
            }
            
            punchCalendarView.snp.remakeConstraints { (make) in
                make.top.equalTo(weekView.snp_bottom).offset(10)
                make.left.right.equalTo(0)
                make.height.equalTo(180)
            }
        }
        next?.sl_routerEventWithName(eventName: kSLPunchCardDetialHeaderViewUpdateHeaderViewEvent)
    }
    
    lazy var punchDaysView: PunchCardDaysView = {
        let punchDaysView = PunchCardDaysView()
        punchDaysView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#F3F7FF")
        return punchDaysView
    }()
    
    lazy var leftLabel: SLButton = {
        let button = SLButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setBackgroundImage(UIImage.init(named: "sl_punchCard_bgRight"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    lazy var rightlabel: SLButton = {
        let button = SLButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setBackgroundImage(UIImage.init(named: "sl_punchCard_bgRight"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    lazy var signDaysLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#898F9A")
        return label
    }()
    
    
    lazy var sortControl: SLCustomImageControl = {
        let sortControl = SLCustomImageControl.init(imageSize: CGSize.init(width: 13.4, height: 13.4), position: SLImagePositionType.right, padding: 7.5)
        sortControl.font = UIFont.boldSystemFont(ofSize: 15)
        sortControl.textColor = UIColor.sl_hexToAdecimalColor(hex: "#898F9A")
        sortControl.locailImage = "arrow_gray"
        sortControl.addTarget(self, action: #selector(lookDetialClick), for: .touchUpInside)
        return sortControl
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#D2E7FC")
        return lineView
    }()
    
    lazy var punchCalendarShowView: PunchCalendarShowView = {
        let punchCalendarShowView = PunchCalendarShowView()
        return punchCalendarShowView
    }()
    
    lazy var weekView: PunchWeekView = {
        let weekView = PunchWeekView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 0))
        return weekView
    }()
    lazy var punchCalendarView: SLPunchCalendarView = {
        let calendarViewFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 180)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (SCREEN_WIDTH - 41)/7, height: 30)
        let punchCalendarView = SLPunchCalendarView(frame: calendarViewFrame, collectionViewLayout: layout)
        punchCalendarView.date = Date()
        punchCalendarView.showOnlyInWeek = true
//        SLPunchCalendarView.selectCalendarViewClick = {(model) in
//            
//        }
        return punchCalendarView
    }()
    
    lazy var showAllButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 4, y: 20 + kSafeTopHeight, width: 44, height: 44))
        button.addTarget(self, action: #selector(showClick), for: .touchUpInside)
        button.setImage(UIImage(named: "sl_punchCard_up"), for: .normal)
        button.setImage(UIImage(named: "sl_punchCard_down"), for: .selected)
        return button
    }()
    lazy var punchCardBottomView: PunchCardBottomView = {
        let punchCardBottomView = PunchCardBottomView()
        return punchCardBottomView
    }()
    
    lazy var leftCicleView: UIView = {
        let leftCicleView = UIView()
        leftCicleView.layer.cornerRadius = 7.5
        leftCicleView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#AACCFF")
        return leftCicleView
    }()
    
    lazy var rightCicleView: UIView = {
        let rightCicleView = UIView()
        rightCicleView.layer.cornerRadius = 7.5
        rightCicleView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#AACCFF")
        return rightCicleView
    }()
    
    lazy var dottedView: UIView = {
        let dottedView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41 - 15 , height: 1))
        dottedView.clipsToBounds = true
        UIUtil.sl_drawDashLine(dottedView, strokeColor: UIColor.sl_hexToAdecimalColor(hex: "#AACCFF"), lineWidth: SCREEN_WIDTH - 41 - 15)
        return dottedView
    }()
}

// MARK: -HMRouterEventProtocol
extension SLPunchCardMainView: SLRouterEventProtocol{
    func sl_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        next?.sl_routerEventWithName(eventName: eventName, info: info)
        switch eventName {
        case kPunchCalendarShowViewChangeCalendarEvent:
            punchCalendarView.date = info![kEventKey] as! Date
        default:
            break
        }
    }
}
