//
//  SLPunchCalendarView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/28.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

enum YXSCalendarCellStatus:Int{
    ///灰色背景
    case gray
    ///背景clear
    case normal
    ///之前已签到
    case beforeHasSign
    ///之前未签到
    case beforeNotSign
}

enum YXSCalendarDateCompare:Int{
    ///同一天
    case Today
    ///大
    case Big
    ///小
    case Small
}

class YXSCalendarModel: NSObject{
    var status: YXSCalendarCellStatus = .normal
    var text: String?
    var sginStatus: Int?
    var toDayDateCompare: YXSCalendarDateCompare!
    var isSelect = false
    var responseModel: YXSClockInDateStatusResponseList?
    var startTime: String?
    var endTime: String{
        get {
            if let startTime = startTime{
                return startTime.yxs_tomorrow()
            }
            return ""
        }
    }
}

let kYXSPunchCalendarViewCellEventClick = "SLPunchCalendarViewCellEventClick"
class YXSPunchCalendarView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(YXSCalendarCell.self, forCellWithReuseIdentifier: "cell")
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        self.delegate = self
        self.dataSource = self
        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = false
    }

    // MARK: - propert
    /// 当前月所有的日历Model
    var totalCalendars = [YXSCalendarModel]()
    
    /// 当前展示的日历model
    var showCalendars = [YXSCalendarModel]()
    
    var model: YXSPunchCardModel?{
        didSet{
            self.days = calculateDaysInDateMonth(date)
            resetShowData()
        }
    }
    var date: Date = Date() {
        didSet {
            //获取日期所在月份的所有日期
            self.weekday = getFirstDayInDateMonth(date) - 1
            print("date所在月份第一天是星期\(self.weekday)")
            self.days = calculateDaysInDateMonth(date)
            print("date所在月份有\(self.days)天")
        }
    }
    /// 指定日期所在月份的第一天是星期几
    var weekday: Int = 0
    
    /// 总共cell个数
    let totalCell = 42
    
    /// 当前展示cell个数
    var showCell: Int = 42
    /// 指定日期的天数
    var days: Int = 0{
        didSet{
            reloadCalendarsData()
        }
    }
    var todayIndexInDays: Int?
    
    // MARK: - func
    private func reloadCalendarsData(){
        var tempDay = 1
        todayIndexInDays = nil
        totalCalendars.removeAll()
        for index in 0..<totalCell{
            let model = YXSCalendarModel()
            if index >= self.weekday && index < self.weekday + self.days{
                model.text = "\(tempDay)"
                model.startTime = yxs_startTime(date, currentDay: "\(tempDay)")
                let todayCompare = yxs_isToDay(date, currentDay: "\(tempDay)")
                model.toDayDateCompare = todayCompare
                if let punchModel = self.model{
                    let compeletSmall = yxs_isToDay(date, compareDate: (punchModel.startTime ?? "").yxs_Date(), currentDay: "\(tempDay)")
                    let compeletEnd = yxs_isToDay(date, compareDate: (punchModel.endTime ?? "").yxs_Date(), currentDay: "\(tempDay)")
                    if  compeletSmall != .Small && compeletEnd != .Big{
                        if let clockInDateStatusResponseList = punchModel.clockInDateStatusResponseList{
                            for listModel in clockInDateStatusResponseList{
                                if yxs_isToDay(date, compareDate: (listModel.clockInTime ?? "").yxs_Date(), currentDay: "\(tempDay)") == .Today{
                                    
                                    model.status = .gray
                                    if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                                        model.status = .gray
                                    }else{
                                        if model.toDayDateCompare == .Small{
                                            if listModel.state == 10{
                                                model.status = .beforeNotSign
                                                model.text = "未"
                                            }else{
                                                model.status = .beforeHasSign
                                            }
                                        }else if model.toDayDateCompare == .Big{
                                            model.status = .gray
                                        }
                                    }
                                    
                                    model.responseModel = listModel
                                    model.sginStatus = listModel.state
                                    break
                                }
                            }
                        }
                    }
                }
                if todayCompare == .Today{
                    model.text = "今"
                    model.isSelect = model.status != .normal ? true : false
                    todayIndexInDays = index
                }
                tempDay += 1
            }
            totalCalendars.append(model)
        }
        showCalendars = totalCalendars
        self.reloadData()
    }
    
    /// 当前只展示一周
    var showOnlyInWeek: Bool = false{
        didSet{
            resetShowData()
        }
    }
    
    func resetShowData(){
        showCell = showOnlyInWeek ? 7 : 42
        if showOnlyInWeek{
            //当前月
            if let todayIndexInDays = todayIndexInDays{
                let row = todayIndexInDays/7
                var newCalendars = [YXSCalendarModel]()
                for index in row*7..<(row + 1)*7{
                    newCalendars.append(totalCalendars[index])
                }
                showCalendars = newCalendars
            }
        }else{
            showCalendars = totalCalendars
        }
        reloadData()
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showCell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! YXSCalendarCell
        cell.yxs_setCellModel(showCalendars[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = showCalendars[indexPath.row]
        if model.status != .normal{
            if  model.toDayDateCompare == .Big && YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                MBProgressHUD.yxs_showMessage(message: "暂未到打卡期限")
                return
            }
            
            //当前已选中 不需要再次请求数据
            if model.isSelect{
                return
            }
            for (index,model) in showCalendars.enumerated(){
                if index == indexPath.row{
                    model.isSelect = true
                }else{
                    model.isSelect = false
                }
                
            }
            next?.yxs_routerEventWithName(eventName: kYXSPunchCalendarViewCellEventClick, info: [kEventKey : model])
            collectionView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - tool
    /// 获取指定月份的天数
    func calculateDaysInDateMonth(_ date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        //指定日期转换
        let specifiedDateCom = calendar.dateComponents([.year,.month,.day], from: date)
        //指定日期所在月的第一天
        var startCom = DateComponents()
        startCom.day = 1
        startCom.month = specifiedDateCom.month
        startCom.year = specifiedDateCom.year
        let startDate = calendar.date(from: startCom)
        //指定日期所在月的下一个月第一天
        var endCom = DateComponents()
        endCom.day = 1
        endCom.month = specifiedDateCom.month == 12 ? 1 : specifiedDateCom.month! + 1
        endCom.year = specifiedDateCom.month == 12 ? specifiedDateCom.year! + 1 : specifiedDateCom.year
        let endDate = calendar.date(from: endCom)
        //计算指定日期所在月的总天数
        let days = calendar.dateComponents([.day], from: startDate!, to: endDate!)
        let count = days.day ?? 0
        return count
    }
    /// 获取指定日期所在月份的第一天是星期几
    func getFirstDayInDateMonth(_ date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        var specifiedDateCom = calendar.dateComponents([.year,.month], from: date)
        specifiedDateCom.setValue(1, for: .day)
        let startOfMonth = calendar.date(from: specifiedDateCom)
        let weekDayCom = calendar.component(.weekday, from: startOfMonth!)
        return weekDayCom
    }
}

class YXSCalendarCell: UICollectionViewCell {
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.cornerRadius = 13
        return bgView
    }()
    lazy var dateLabel: YXSLabel = {
        let label = YXSLabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    lazy var signImage: UIImageView = {
        let signImage = UIImageView()
        signImage.image = UIImage.init(named: "yxs_punch_has_sign")
        return signImage
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bgView)
        bgView.addSubview(dateLabel)
        bgView.addSubview(signImage)
        bgView.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 26, height: 26))
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.center.equalTo(bgView)
        }
        signImage.snp.makeConstraints { (make) in
              make.center.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 18, height: 12.5))
        }
        
    }
    
    func yxs_setCellModel(_ model: YXSCalendarModel){
        dateLabel.isHidden = true
        signImage.isHidden = true
        dateLabel.text = model.text
        dateLabel.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        switch model.status {
        case .normal:
            dateLabel.isHidden = false
            bgView.backgroundColor = UIColor.clear
        case .gray:
            dateLabel.isHidden = false
            bgView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9")
        case .beforeNotSign:
            dateLabel.textColor = UIColor.white
            dateLabel.isHidden = false
            bgView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#D41B1B")
        case .beforeHasSign:
            dateLabel.isHidden = true
            signImage.isHidden = false
            bgView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#81D285")
        }
        if model.isSelect{
            dateLabel.textColor = UIColor.white
            bgView.backgroundColor = kBlueColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class YXSPunchWeekView: UIView {
    
    let weekDays: [String] = ["日","一","二","三","四","五","六"]
    override init(frame: CGRect) {
        super.init(frame: frame)
        for (index,string) in self.weekDays.enumerated() {
            let dayLabel: YXSLabel = {
                let label = YXSLabel()
                label.text = string
                label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
                label.textAlignment = .center
                return label
            }()
            dayLabel.frame = CGRect(x: CGFloat(index)*(frame.width/7), y: 0, width: frame.width/7, height: 30)
            self.addSubview(dayLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


let kYXSPunchCalendarShowViewChangeCalendarEvent = "PunchCalendarShowViewChangeCalendarEvent"
class YXSPunchCalendarShowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(titleLabel)
        
        leftButton.snp.makeConstraints { (make) in
            make.left.equalTo(58)
            make.top.equalTo(12.5)
            make.size.equalTo(CGSize.init(width: 28.5, height: 33.5 ))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(leftButton)
        }
        rightButton.snp.makeConstraints { (make) in
            make.right.equalTo(-58)
            make.centerY.equalTo(leftButton)
            make.size.equalTo(CGSize.init(width: 28.5, height: 33.5 ))
        }
        
        titleLabel.text = self.formatYearOMonth(yearOMonth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var yearOMonth: Date = Date() {
        didSet {
            titleLabel.text = self.formatYearOMonth(yearOMonth)
        }
    }
    /// 获取上个月的同一日期
    @objc func getLastMonth() {
        let calendar = Calendar.init(identifier: .gregorian)
        var comLast = DateComponents()
        comLast.setValue(-1, for: .month)
        yearOMonth = calendar.date(byAdding: comLast, to: self.yearOMonth)!
        yxs_routerEventWithName(eventName: kYXSPunchCalendarShowViewChangeCalendarEvent, info: [kEventKey : yearOMonth])
    }
    /// 获取下个月的同一日期
    @objc func getNextMonth() {
        let calendar = Calendar.init(identifier: .gregorian)
        var comLast = DateComponents()
        comLast.setValue(+1, for: .month)
        yearOMonth = calendar.date(byAdding: comLast, to: self.yearOMonth)!
        yxs_routerEventWithName(eventName: kYXSPunchCalendarShowViewChangeCalendarEvent, info: [kEventKey : yearOMonth])
    }
    /// 将日期展示为年月
    func formatYearOMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        let string = formatter.string(from: date)
        return string
    }
    
    lazy var leftButton: YXSButton = {
        let button = YXSButton.init()
        button.setImage(UIImage(named: "yxs_punch_left"), for: .normal)
        button.addTarget(self, action: #selector(getLastMonth), for: .touchUpInside)
        return button
    }()
    
    lazy var rightButton: YXSButton = {
        let button = YXSButton.init()
        button.setImage(UIImage(named: "yxs_punch_right"), for: .normal)
        button.addTarget(self, action: #selector(getNextMonth), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return label
    }()
}
