//
//  YXSDatePickerView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/2.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

/// 选择接龙日期
class YXSDatePickerView: UIView {
    
    /// 初始化日期选择
    /// - Parameters:
    ///   - date: 当前选中日期
    ///   - minimumDate: 最小日期
    ///   - compelect: 确定选中回调
    @discardableResult static func showDateView(_ date: Date? = nil,minimumDate: Date? = Date(),compelect:((_ date: Date) ->())? = nil) -> YXSDatePickerView{
        return self.showDateView(date, minimumDate: minimumDate, maximumDate: nil, compelect: compelect)
//        let view = YXSDatePickerView(date,minimumDate: minimumDate)
//        view.setDateModel(dateModel: .date)
//        view.compelect = compelect
//        view.beginAnimation()
//        return view
    }
    
    /// 初始化日期选择
    /// - Parameters:
    ///   - date: 当前选中日期
    ///   - minimumDate: 最小日期
    ///   - maximumDate: 最大日期
    ///   - compelect: 确定选中回调
    @discardableResult static func showDateView(_ date: Date? = nil,minimumDate: Date? = Date(),maximumDate: Date? = nil,dateModel: UIDatePicker.Mode? = .dateAndTime,title: String = "",topRightTitle: String = "",compelect:((_ date: Date) ->())? = nil) -> YXSDatePickerView{
        let view = YXSDatePickerView(date,minimumDate: minimumDate,maximumDate: maximumDate,dateModel: dateModel,title: title,topRightTitle: topRightTitle)
//        let view = YXSDatePickerView(date,minimumDate: minimumDate)
        view.compelect = compelect
        view.beginAnimation()
        return view
    }
    
    /// 设置时间选择器模式
    /// - Parameter dateModel: 展示模式
    public func setDateModel(dateModel: UIDatePicker.Mode){
        datePickerView.datePickerMode = dateModel
    }
    
    private var compelect:((_ date: Date) ->())?
    private var date: Date?
    private var minimumDate:Date?
    private var maximumDate:Date?
    private var title:String?
    private var topRightTitle:String?
    private init(_ date: Date? = nil,minimumDate: Date?,maximumDate: Date?,dateModel: UIDatePicker.Mode?,title: String?,topRightTitle: String?) {
        self.date = date
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.title = title
        self.topRightTitle = topRightTitle
        
        super.init(frame: CGRect.zero)
        self.setDateModel(dateModel: dateModel ?? .dateAndTime)
        self.addSubview(titleView)
        self.addSubview(datePickerView)
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        if title?.count ?? 0 > 0 || topRightTitle?.count ?? 0 > 0 {
            titleView.isHidden = false
            titleLabel.text = title
            rightTitleButton.setTitle(topRightTitle, for: .normal)
            datePickerView.snp.makeConstraints { (make) in
                make.top.equalTo(titleView.snp.bottom)
                make.left.right.equalTo(0)
                make.height.equalTo(200)
            }
        } else {
            titleView.isHidden = true
            datePickerView.snp.makeConstraints { (make) in
                make.top.equalTo(10)
                make.left.right.equalTo(0)
                make.height.equalTo(200)
            }
        }
        
        
        leftButton.snp.makeConstraints { (make) in
            make.height.equalTo(49)
            make.bottom.equalTo(-kSafeBottomHeight).priorityHigh()
            make.top.equalTo(datePickerView.snp_bottom).offset(15)
            make.left.equalTo(0)
        }
        rightButton.snp.makeConstraints { (make) in
            make.height.equalTo(49)
            make.top.equalTo(leftButton)
            make.right.equalTo(0)
            make.left.equalTo(leftButton.snp_right)
            make.width.equalTo(leftButton)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func beginAnimation() {
        UIApplication.shared.keyWindow?.addSubview(bgWindow)
        
        bgWindow.addSubview(self)
        bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.mixedBackgroundColor = MixedColor(normal:  UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightForegroundColor)
        self.yxs_addRoundedCorners(corners: [.topLeft, .topRight], radii: CGSize.init(width: 4, height: 4), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 500))
        self.clipsToBounds = true
        
        self.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
        }
        bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 1
        })
    }
    
    // MARK: -event
    
    @objc private func dismiss(){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 0
        }) { finished in
            self.bgWindow.removeFromSuperview()
            
        }
    }
    
    @objc private func rightTitleBtnClick() {
        dismiss()
        compelect?(Date().yxs_dateByAddingMonths(months: 4) ?? Date())
    }
    
    @objc private func certainClick(){
        dismiss()
        date = datePickerView.date
        compelect?(date ?? Date())
        
    }
    
    @objc private func changeDate(datePicker : UIDatePicker){
        date = datePicker.date
    }
    
    // MARK: -getter
    
//    private lazy var titleLabel : UILabel = {
//        let view = getLabel(text: "选择周期")
//        view.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#000000"), night: UIColor.white)
//        view.font = UIFont.boldSystemFont(ofSize: 17)
//        view.numberOfLines = 0
//        view.textAlignment = NSTextAlignment.center
//        return view
//    }()
    
    private lazy var titleView : UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
        view.isHidden = true
        view.addSubview(self.titleLabel)
        view.addSubview(self.rightTitleButton)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH * 0.6)
            make.centerX.equalTo(view)
        }
        self.rightTitleButton.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(0)
            make.width.equalTo(70)
        }
        return view
    }()
    
    private lazy var titleLabel : UILabel = {
        let view = UILabel()
        view.mixedTextColor = MixedColor(normal: kBlueColor, night: kBlueColor)
        view.font = UIFont.boldSystemFont(ofSize: 17)
        view.textAlignment = NSTextAlignment.center
        return view
    }()
    
    private lazy var rightTitleButton : UIButton = {
        let button = UIButton.init()
        button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#F85354"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(rightTitleBtnClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var datePickerView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN") as Locale
        if NightNight.theme == .night{
            datePicker.setValue(UIColor.white, forKey: "textColor")
        }
        if let minimumDate = minimumDate{
            datePicker.minimumDate = minimumDate
        }
        if let maximumDate = maximumDate{
            datePicker.maximumDate = maximumDate
        }
        if let date = date{
            if self.topRightTitle?.count ?? 0 > 0 {
                if date.yxs_isDifferWithMonth(month: 3) ?? false {
                    datePicker.date = Date()
                } else {
                    datePicker.date = date
                }
            } else {
                datePicker.date = date
            }
        }
        ///显示24小时制
        datePicker.calendar = Calendar.current
        datePicker.locale = Locale.init(identifier: "zh_GB")
        
        //注意：action里面的方法名后面需要加个冒号“：”
        datePicker.addTarget(self, action: #selector(changeDate),
                             for: UIControl.Event.valueChanged)
        datePicker.calendar = Calendar.current
        datePicker.locale = Locale.init(identifier: "zh_GB")
        return datePicker
    }()
    
    private lazy var leftButton : UIButton = {
        let button = UIButton.init()
        button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#797B7E"), for: .normal)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightButton : UIButton = {
        let button = UIButton.init()
        button.setTitleColor(kBlueColor, for: .normal)
        button.setTitle("确认", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(certainClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var bgWindow : UIControl = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        return view
    }()
}
