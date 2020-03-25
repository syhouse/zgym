//
//  SLPunchCardSelectDaysView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/27.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class PunchCardDay:NSObject, NSCoding {
    var text: String
    var paramsKey: Int
    init(_ text: String, _ paramsKey: Int) {
        self.text = text
        self.paramsKey = paramsKey
    }
    @objc required init(coder aDecoder: NSCoder){
        text = aDecoder.decodeObject(forKey: "text") as? String ?? ""
        paramsKey = aDecoder.decodeInteger(forKey: "paramsKey") as Int
    }
    @objc func encode(with aCoder: NSCoder)
    {
        aCoder.encode(paramsKey, forKey: "paramsKey")
        aCoder.encode(text, forKey: "text")
    }
}
let PunchCardDays:[PunchCardDay] = [PunchCardDay.init("7天", 7),
                                           PunchCardDay.init("8天", 8),
                                           PunchCardDay.init("9天", 9),
                                           PunchCardDay.init("10天", 10),
                                           PunchCardDay.init("11天", 11),
                                           PunchCardDay.init("12天", 12),
                                           PunchCardDay.init("13天", 13),
                                           PunchCardDay.init("14天", 14),
                                           PunchCardDay.init("15天", 15),
                                           PunchCardDay.init("16天", 16),
                                           PunchCardDay.init("17天", 17),
                                           PunchCardDay.init("18天", 18),
                                           PunchCardDay.init("19天", 19),
                                           PunchCardDay.init("20天", 20),
                                           PunchCardDay.init("21天", 21),
                                           PunchCardDay.init("22天", 22),
                                           PunchCardDay.init("23天", 23),
                                           PunchCardDay.init("24天", 24),
                                           PunchCardDay.init("25天", 25),
                                           PunchCardDay.init("26天", 26),
                                           PunchCardDay.init("27天", 27),
                                           PunchCardDay.init("28天", 28),
                                           PunchCardDay.init("29天", 29),
                                           PunchCardDay.init("30天", 30)]

/// 选择打卡天数
class SLPunchCardSelectDaysView: UIView {
    @discardableResult static func showAlert(_ selectModel: PunchCardDay? = nil, dataSource:[PunchCardDay] = PunchCardDays,title:String = "选择打卡天数",compelect:((_ modle: PunchCardDay) ->())? = nil) -> SLPunchCardSelectDaysView{
        let view = SLPunchCardSelectDaysView(selectModel,dataSource: dataSource,title: title)
        view.compelect = compelect
        view.beginAnimation()
        return view
    }
    var dataSource: [PunchCardDay]
    var title: String
    var selectModel:PunchCardDay?
    var compelect:((_ modle: PunchCardDay) ->())?
    init(_ selectModel: PunchCardDay? = nil,dataSource:[PunchCardDay],title: String) {
        self.dataSource = dataSource
        self.title = title
        self.selectModel = selectModel
        super.init(frame: CGRect.zero)
        
        self.addSubview(titleLabel)
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        self.addSubview(pickView)
        
        leftButton.sl_addLine(position: .top, lineHeight: 0.5)
        rightButton.sl_addLine(position: .top, lineHeight: 0.5)
        leftButton.sl_addLine(position: .right, lineHeight: 0.5)
        layout()
    }
    
    func layout(){
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(60)
            make.right.equalTo(-60)
            make.top.equalTo(24)
        }
        pickView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(50)
            make.height.equalTo(180)
        }
        leftButton.snp.makeConstraints { (make) in
            make.height.equalTo(49)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(244)
            make.left.equalTo(0)
        }
        rightButton.snp.makeConstraints { (make) in
            make.height.equalTo(49)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(leftButton)
            make.right.equalTo(0)
            make.left.equalTo(leftButton.snp_right)
            make.width.equalTo(leftButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginAnimation() {
        UIApplication.shared.keyWindow?.addSubview(bgWindow)
        
        bgWindow.addSubview(self)
        bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.snp.makeConstraints { (make) in
            make.left.equalTo(57.5)
            make.right.equalTo(-57.5)
            make.centerY.equalTo(bgWindow)
        }
        bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 1
        })
    }
    
    // MARK: -event
    
    @objc func dismiss(){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 0
        }) { finished in
            self.bgWindow.removeFromSuperview()
            
        }
    }
    
    @objc func certainClick(){
        dismiss()
        compelect?(dataSource[pickView.selectedRow(inComponent: 0)])
        
    }
    
    @objc func cancelClick(){
        dismiss()
        
    }
    
    // MARK: -getter
    
    lazy var titleLabel : UILabel = {
        let view = getLabel(text: title)
        view.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#000000"), night: UIColor.white)
        view.font = UIFont.boldSystemFont(ofSize: 17)
        view.numberOfLines = 0
        view.textAlignment = NSTextAlignment.center
        return view
    }()
    
    lazy var pickView: UIPickerView = {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 250, width: 350, height:100))
            //delegate设为自己
            pickerView.delegate = self
            //DataSource设为自己
            pickerView.dataSource = self
            //设置PickerView默认值
        if let selectModel = selectModel{
            for (index,model) in dataSource.enumerated(){
                if model.text == selectModel.text{
                    pickerView.selectRow(index, inComponent: 0, animated: true)
                    break
                }
            }
        }else{
             pickerView.selectRow(0, inComponent: 0, animated: true)
        }
        return pickerView
    }()
    
    
    lazy var leftButton : SLButton = {
        let button = SLButton.init()
        button.setTitleColor(UIColor.sl_hexToAdecimalColor(hex: "#797B7E"), for: .normal)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        return button
    }()
    
    lazy var rightButton : SLButton = {
        let button = SLButton.init()
        button.setTitleColor(kBlueColor, for: .normal)
        button.setTitle("确认", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(certainClick), for: .touchUpInside)
        return button
    }()
    
    lazy var bgWindow : UIControl! = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        return view
    }()
}

extension SLPunchCardSelectDaysView:UIPickerViewDataSource,UIPickerViewDelegate{
    //设置PickerView列数(dataSourse协议)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //设置PickerView行数(dataSourse协议)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    //设置PickerView选项内容(delegate协议)

    //设置列宽
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 80
    }
    //设置行高
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    //修改PickerView选项
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        //将图片设为PickerView选型

        var pickerLabel = view as? UILabel
        if pickerLabel == nil{
            pickerLabel = SLLabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 15)
            pickerLabel?.textAlignment = .center
        }
        let model = dataSource[row]
        pickerLabel?.text = model.text
        pickerLabel?.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4)
        return pickerLabel!
    }
}
