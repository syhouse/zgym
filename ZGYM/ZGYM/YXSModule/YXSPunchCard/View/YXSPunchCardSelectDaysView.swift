//
//  SLPunchCardSelectDaysView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/27.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSPunchCardDay:NSObject, NSCoding {
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
let PunchCardDays:[YXSPunchCardDay] = [YXSPunchCardDay.init("7天", 7),
                                           YXSPunchCardDay.init("8天", 8),
                                           YXSPunchCardDay.init("9天", 9),
                                           YXSPunchCardDay.init("10天", 10),
                                           YXSPunchCardDay.init("11天", 11),
                                           YXSPunchCardDay.init("12天", 12),
                                           YXSPunchCardDay.init("13天", 13),
                                           YXSPunchCardDay.init("14天", 14),
                                           YXSPunchCardDay.init("15天", 15),
                                           YXSPunchCardDay.init("16天", 16),
                                           YXSPunchCardDay.init("17天", 17),
                                           YXSPunchCardDay.init("18天", 18),
                                           YXSPunchCardDay.init("19天", 19),
                                           YXSPunchCardDay.init("20天", 20),
                                           YXSPunchCardDay.init("21天", 21),
                                           YXSPunchCardDay.init("22天", 22),
                                           YXSPunchCardDay.init("23天", 23),
                                           YXSPunchCardDay.init("24天", 24),
                                           YXSPunchCardDay.init("25天", 25),
                                           YXSPunchCardDay.init("26天", 26),
                                           YXSPunchCardDay.init("27天", 27),
                                           YXSPunchCardDay.init("28天", 28),
                                           YXSPunchCardDay.init("29天", 29),
                                           YXSPunchCardDay.init("30天", 30)]

/// 选择打卡天数  标题+居中内容+取消+确定按钮 
class YXSPunchCardSelectDaysView: UIView {
    @discardableResult static func showAlert(_ yxs_selectModel: YXSPunchCardDay? = nil, yxs_dataSource:[YXSPunchCardDay] = PunchCardDays,title:String = "选择打卡天数",compelect:((_ modle: YXSPunchCardDay) ->())? = nil) -> YXSPunchCardSelectDaysView{
        let view = YXSPunchCardSelectDaysView(yxs_selectModel,yxs_dataSource: yxs_dataSource,title: title)
        view.compelect = compelect
        view.yxs_beginAnimation()
        return view
    }
    private var yxs_dataSource: [YXSPunchCardDay]
    private var title: String
    private var yxs_selectModel:YXSPunchCardDay?
    private var compelect:((_ modle: YXSPunchCardDay) ->())?
    private init(_ yxs_selectModel: YXSPunchCardDay? = nil,yxs_dataSource:[YXSPunchCardDay],title: String) {
        self.yxs_dataSource = yxs_dataSource
        self.title = title
        self.yxs_selectModel = yxs_selectModel
        super.init(frame: CGRect.zero)
        
        self.addSubview(titleLabel)
        self.addSubview(yxs_leftButton)
        self.addSubview(yxs_rightButton)
        self.addSubview(pickView)
        
        yxs_leftButton.yxs_addLine(position: .top, lineHeight: 0.5)
        yxs_rightButton.yxs_addLine(position: .top, lineHeight: 0.5)
        yxs_leftButton.yxs_addLine(position: .right, lineHeight: 0.5)
        yxs_layout()
    }
    
    private func yxs_layout(){
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
        yxs_leftButton.snp.makeConstraints { (make) in
            make.height.equalTo(49)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(244)
            make.left.equalTo(0)
        }
        yxs_rightButton.snp.makeConstraints { (make) in
            make.height.equalTo(49)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(yxs_leftButton)
            make.right.equalTo(0)
            make.left.equalTo(yxs_leftButton.snp_right)
            make.width.equalTo(yxs_leftButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func yxs_beginAnimation() {
        UIApplication.shared.keyWindow?.addSubview(yxs_bgWindow)
        
        yxs_bgWindow.addSubview(self)
        yxs_bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.snp.makeConstraints { (make) in
            make.left.equalTo(57.5)
            make.right.equalTo(-57.5)
            make.centerY.equalTo(yxs_bgWindow)
        }
        yxs_bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.yxs_bgWindow.alpha = 1
        })
    }
    
    // MARK: -event
    
    @objc func dismiss(){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.yxs_bgWindow.alpha = 0
        }) { finished in
            self.yxs_bgWindow.removeFromSuperview()
            
        }
    }
    
    @objc func yxs_certainClick(){
        dismiss()
        compelect?(yxs_dataSource[pickView.selectedRow(inComponent: 0)])
        
    }
    
    @objc func yxs_cancelClick(){
        dismiss()
        
    }
    
    // MARK: -getter
    
    private lazy var titleLabel : UILabel = {
        let view = getLabel(text: title)
        view.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#000000"), night: UIColor.white)
        view.font = UIFont.boldSystemFont(ofSize: 17)
        view.numberOfLines = 0
        view.textAlignment = NSTextAlignment.center
        return view
    }()
    
    private lazy var pickView: UIPickerView = {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 250, width: 350, height:100))
            //delegate设为自己
            pickerView.delegate = self
            //yxs_dataSource设为自己
            pickerView.dataSource = self
            //设置PickerView默认值
        if let yxs_selectModel = yxs_selectModel{
            for (index,model) in yxs_dataSource.enumerated(){
                if model.text == yxs_selectModel.text{
                    pickerView.selectRow(index, inComponent: 0, animated: true)
                    break
                }
            }
        }else{
             pickerView.selectRow(0, inComponent: 0, animated: true)
        }
        return pickerView
    }()
    
    
    private lazy var yxs_leftButton : YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#797B7E"), for: .normal)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(yxs_cancelClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var yxs_rightButton : YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(kBlueColor, for: .normal)
        button.setTitle("确认", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(yxs_certainClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var yxs_bgWindow : UIControl! = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        return view
    }()
}

extension YXSPunchCardSelectDaysView:UIPickerViewDataSource,UIPickerViewDelegate{
    //设置PickerView列数(dataSourse协议)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //设置PickerView行数(dataSourse协议)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yxs_dataSource.count
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

        var yxs_pickerLabel = view as? UILabel
        if yxs_pickerLabel == nil{
            yxs_pickerLabel = YXSLabel()
            yxs_pickerLabel?.font = UIFont.systemFont(ofSize: 15)
            yxs_pickerLabel?.textAlignment = .center
        }
        let model = yxs_dataSource[row]
        yxs_pickerLabel?.text = model.text
        yxs_pickerLabel?.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4)
        return yxs_pickerLabel!
    }
}
