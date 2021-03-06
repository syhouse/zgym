//
//  YXSHomeSolitaireBottom.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/19.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

let kSolitaireBottomGoEvnet = "SolitaireBottomGoEvnet"

class YXSHomeSolitaireBottom: UIView {
    let isHome: Bool
    init(_ isHome: Bool = true) {
        self.isHome = isHome
        super.init(frame: CGRect.zero)
        
        addSubview(countLabel)
        addSubview(classLabel)
        addSubview(deadlineLabel)
        addSubview(statusLabel)
        addSubview(statusButton)
        addSubview(nameTimeLabel)
        
        countLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(0)
        }
        statusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(70)
            make.height.equalTo(19)
        }
        if isHome{
            classLabel.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(-90)
                make.top.equalTo(nameTimeLabel.snp_bottom).offset(10.5)
            }
            nameTimeLabel.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(-90)
                make.top.equalTo(countLabel.snp_bottom).offset(10.5)
            }
        }else{
            classLabel.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(-90)
                make.top.equalTo(countLabel.snp_bottom).offset(10.5)
            }
        }
        deadlineLabel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(classLabel.snp_bottom).offset(10)
            make.bottom.equalTo(0).priorityHigh()
        }
        statusButton.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.top.equalTo(statusLabel.snp_top).offset(2)
            make.size.equalTo(CGSize.init(width: 79, height: 31))
        }
        
        
        statusButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //0 已结束 1 正在接龙 2 已接龙
    func setStatusText(status: Int){
        if status == 0{
            statusLabel.text = "已结束"
            statusLabel.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
            statusLabel.textColor = UIColor.white
        }else if status == 1{
            statusLabel.text = "正在接龙"
            statusLabel.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F4E2DF")
            statusLabel.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#E8534C")
        }else{
            statusLabel.text = "已接龙"
            statusLabel.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#DFF3EC")
            statusLabel.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#38B16B")
        }
    }
    
    func setHomeModel(_ model: YXSHomeListModel){
        UIUtil.yxs_setLabelAttributed(countLabel, text: ["\(model.commitCount)", "个人已经参与接龙"], colors: [kRedMainColor, UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")])
        classLabel.text = "接收班级：\(model.className ?? "")"
        deadlineLabel.text = "截止日期：\((model.endTime ?? "").dateTime?.toString(format: DateFormatType.custom("yyyy/MM/dd HH:mm")) ?? "")"
        UIUtil.yxs_setLabelAttributed(nameTimeLabel, text: ["\(model.teacherName ?? "")", "  |  \(model.createTime?.yxs_Time() ?? "")"], colors: [MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")),MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))])
        
        var name: String = model.teacherName ?? ""
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER && model.teacherId == yxs_user.id{
            name = "我"
        }
        name = name.count > 6 ? "\(name.mySubString(to: 6))..." : name
        
        statusButton.isHidden = true
        statusLabel.isHidden = true
        
        setStatusText(state: model.state, endTime: model.endTime, memberCount: model.memberCount, commintCount: model.commitCount)
    }
    
    func setSolitaireModel(_ model: YXSSolitaireModel){
        statusButton.isHidden = true
        statusLabel.isHidden = true
        
        setStatusText(state: model.state, endTime: model.endTime, memberCount: nil, commintCount: nil)
        
        UIUtil.yxs_setLabelAttributed(countLabel, text: ["\(model.committedSum ?? 0)", "个人已经参与接龙"], colors: [kRedMainColor, UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")])
        classLabel.text = "接收班级：\(model.className ?? "")"
        deadlineLabel.text = "截止日期：\((model.endTime ?? "").dateTime?.toString(format: DateFormatType.custom("yyyy/MM/dd HH:mm")) ?? "")"
        UIUtil.yxs_setLabelAttributed(nameTimeLabel, text: ["\(model.teacherName ?? "")", "  |  \(model.createTime?.yxs_Time() ?? "")"], colors: [MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")),MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))])
    }
    
    private func setStatusText(state: Int?, endTime: String?, memberCount:Int? , commintCount: Int?){
        if let state = state{
            let isFinish = state == 100 || (endTime?.yxs_Date().timeIntervalSince1970 ?? 0) < Date().timeIntervalSince1970 || (memberCount ?? 0) == (commintCount ?? 1)
            if isFinish {
                setStatusText(status: 0)
                statusLabel.isHidden = false
            }else if state == 10 && YXSPersonDataModel.sharePerson.personRole == .PARENT{
                statusButton.isHidden = false
            }
            else if state == 20 && YXSPersonDataModel.sharePerson.personRole == .PARENT{
                setStatusText(status: 2)
                statusLabel.isHidden = false
            }
            else if state == 30  && YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                setStatusText(status: 1)
                statusLabel.isHidden = false
            }
        }
    }
    
    
    
    @objc func goSolitaireClick(){
        next?.yxs_routerEventWithName(eventName: kSolitaireBottomGoEvnet)
    }
    
    
    lazy var statusButton: UIButton = {
        let button = UIButton.init()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15.5
        button.layer.borderWidth = 1
        button.layer.borderColor = kRedMainColor.cgColor
        button.backgroundColor = UIColor.clear
        button.setTitleColor(kRedMainColor, for: .normal)
        button.setTitle("去接龙", for: .normal)
        button.isUserInteractionEnabled = false
        //        button.addTarget(self, action: #selector(goSolitaireClick), for: .touchUpInside)
        return button
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: YXSHomeListModel.smallFontSize)
        return label
    }()
    
    lazy var classLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        label.font = UIFont.systemFont(ofSize: YXSHomeListModel.smallFontSize)
        return label
    }()
    
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: YXSHomeListModel.smallFontSize)
        label.cornerRadius = 9.5
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    lazy var nameTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        label.font = UIFont.systemFont(ofSize: YXSHomeListModel.smallFontSize)
        return label
    }()
}
