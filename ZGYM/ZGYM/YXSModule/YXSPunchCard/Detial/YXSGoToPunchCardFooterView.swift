//
//  YXSGoToPunchCardFooterView.swift
//  HNYMEducation
//
//  Created by sy_mac on 2020/4/9.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

enum YXSPunchCardFooterType{
    case goPunchCard
    case goPatchAppointDay//指定补卡
    case goPatchSelectDay//去选择补卡
}

class YXSGoToPunchCardFooterView: UIView{
    /// 当前日历model
    var calendarModel: YXSCalendarModel?{
        didSet{
            setFooterModel(model)
        }
    }
    
    /// 当前展示的是日历
    var isCurruntCalendarVC: Bool = false{
        didSet{
            setFooterModel(model)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        addSubview(goPunchCardBtn)
        addSubview(statusLabel)
        addSubview(goPunchCardSmallBtn)
        goPunchCardSmallBtn.snp.makeConstraints { (make) in
            make.width.equalTo(113)
            make.right.equalTo(-15)
            make.top.equalTo(9.5)
            make.height.equalTo(41)
        }
        goPunchCardBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(9.5)
            make.height.equalTo(41)
        }
        yxs_addLine(position: .top)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var footerBlock: ((_ type: YXSPunchCardFooterType, _ patchTime: String?)->())?
    @objc func goPunchCardClick(){
        if let calendarModel = calendarModel, isCurruntCalendarVC,calendarModel.toDayDateCompare != .Today{
            footerBlock?(.goPatchAppointDay, calendarModel.responseModel?.clockInTime)
        }else{
            if model.hasPunch{
                footerBlock?(.goPatchSelectDay, nil)
            }else{
                footerBlock?(.goPunchCard, nil)
            }
        }
        
    }
    
    var model: YXSPunchCardModel!
    func setFooterModel(_ model: YXSPunchCardModel){
        self.model = model
        
        goPunchCardBtn.isHidden = true
        statusLabel.isHidden = true
        
        goPunchCardSmallBtn.isHidden = true
        goPunchCardSmallBtn.isEnabled = true
        goPunchCardBtn.isEnabled = true
        
        goPunchCardBtn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 41), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 20.5)
        
        statusLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(9.5)
            make.height.equalTo(41)
        }
        
        if model.hasPunchFinish{
            statusLabel.isHidden = false
            statusLabel.text = "打卡已结束"
            return
        }
        
        if let calendarModel = calendarModel, isCurruntCalendarVC, calendarModel.toDayDateCompare != .Today{
            if calendarModel.toDayDateCompare == .Big{
                statusLabel.isHidden = false
                statusLabel.text = "未到打卡时间"
            }else{
                if calendarModel.toDayDateCompare == .Big{
                    statusLabel.isHidden = false
                    statusLabel.text = "未到打卡时间"
                }else if calendarModel.toDayDateCompare == .Small{
                    if calendarModel.status == .beforeHasSign{
                        statusLabel.isHidden = false
                        statusLabel.text = "今日已打卡"
                    }else{
                        statusLabel.isHidden = false
                        statusLabel.text = "打卡已经过期"
                        statusLabel.snp.remakeConstraints { (make) in
                            make.left.equalTo(15)
                            make.top.equalTo(9.5)
                            make.height.equalTo(41)
                        }
                        goPunchCardSmallBtn.isHidden = false
                        //不允许打卡或者打卡已结束
                        if model.isPatchCard == 0{
                            goPunchCardSmallBtn.isEnabled = false
                            goPunchCardSmallBtn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 113, height: 41), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#cad3e2"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#cad3e2"), cornerRadius: 20.5)
                        }else{
                            goPunchCardSmallBtn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 113, height: 41), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 20.5)
                        }
                    }
                }
            }
        }else{
            if model.hasNeedPunch{
                if model.hasPunch{
                    if model.hasLeakyPunch{
                        goPunchCardBtn.isHidden = false
                        goPunchCardBtn.setTitle("今日已打卡，有遗漏打卡去补卡", for: .normal)
                    }else{
                        statusLabel.isHidden = false
                        statusLabel.text = "今日已打卡"
                        
                    }
                }else{
                    goPunchCardBtn.isHidden = false
                    goPunchCardBtn.setTitle("去打卡", for: .normal)
                }
            }else{
                statusLabel.isHidden = false
                statusLabel.text = "今日无需打卡"
            }
            
        }
        
    }
    
    lazy var goPunchCardBtn: UIButton = {
        let button = UIButton.init()
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitle("去打卡", for: .normal)
        button.setTitle("去打卡", for: .disabled)
        button.layer.cornerRadius = 20.5
        button.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 41), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 20.5)
        button.addTarget(self, action: #selector(goPunchCardClick), for: .touchUpInside)
        return button
    }()
    
    ///不用2个按钮会有恶心的动画效果
    lazy var goPunchCardSmallBtn: UIButton = {
        let button = UIButton.init()
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitle("去补卡", for: .normal)
        button.layer.cornerRadius = 20.5
        button.addTarget(self, action: #selector(goPunchCardClick), for: .touchUpInside)
        return button
    }()
    
    lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 18)
        return statusLabel
    }()
}
