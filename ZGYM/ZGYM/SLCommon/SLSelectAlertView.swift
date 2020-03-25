//
//  SLSelectAlertView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/16.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLSelectSectionModel:NSObject {
    
    /// 展示中文
    var text: String
    
    /// 提交服务器参数
    var paramsKey: String
    init(_ text: String, _ paramsKey: String) {
        self.text = text
        self.paramsKey = paramsKey
    }
}
let Stages:[SLSelectSectionModel] = [SLSelectSectionModel("幼儿园", "KINDERGARTEN"),
                                     SLSelectSectionModel("小学", "PRIMARY_SCHOOL"),
                                     SLSelectSectionModel("中学", "MIDDLE_SCHOOL"),]

var SLCommonSubjcts:[SLSelectSectionModel] = [SLSelectSectionModel.init("语文", "CHINESE"),
                                      SLSelectSectionModel.init("数学", "MATHEMATICS"),
                                      SLSelectSectionModel.init("外语", "FOREIGN_LANGUAGES"),
                                      SLSelectSectionModel.init("物理", "PHYSICS"),
                                      SLSelectSectionModel.init("化学", "CHEMISTRY"),
                                      SLSelectSectionModel.init("自然", "NATURAL"),
                                      SLSelectSectionModel.init("地理", "GEOGRAPHY"),
                                      SLSelectSectionModel.init("历史", "HISTORY"),
                                      SLSelectSectionModel.init("社会", "SOCIOLOGY"),
                                      SLSelectSectionModel.init("道德与法治", "MORALITY_LAW"),
                                      SLSelectSectionModel.init("思想政治", "POLITICS"),
                                      SLSelectSectionModel.init("音乐", "MUSIC"),
                                      SLSelectSectionModel.init("美术", "PAINTING"),
                                      SLSelectSectionModel.init("艺术", "ART"),
                                      SLSelectSectionModel.init("体育与健身", "SPORTS"),
                                      SLSelectSectionModel.init("其它", "OTHER")]

let Relationships:[SLSelectSectionModel] = [SLSelectSectionModel.init("妈妈", "MOM"),
                                            SLSelectSectionModel.init("爸爸", "DAD"),
                                            SLSelectSectionModel.init("爷爷", "GRANDPA"),
                                            SLSelectSectionModel.init("奶奶", "GRANDMA"),
                                            SLSelectSectionModel.init("哥哥", "BROTHER"),
                                            SLSelectSectionModel.init("姐姐", "SISTER"),
                                            SLSelectSectionModel.init("叔叔", "UNCLE"),
                                            SLSelectSectionModel.init("阿姨", "MATERNAL_AUNT"),
                                            SLSelectSectionModel.init("姑姑", "AUNT"),
                                            SLSelectSectionModel.init("伯伯", "FATHER_ELDER_BROTHER")]


/// 选择打卡天数
class SLSelectAlertView: UIView {
    // MARK: - public
    @discardableResult static func showAlert(_ dataSource:[SLSelectSectionModel],_ selectModel: SLSelectSectionModel? = nil,title: String?,compelect:((_ modle: SLSelectSectionModel) ->())? = nil) -> SLSelectAlertView{
        let view = SLSelectAlertView(dataSource,selectModel,title: title)
        view.compelect = compelect
        view.beginAnimation()
        return view
    }
    // MARK: - private
    
    private var title: String?
    private var selectModel:SLSelectSectionModel?
    private var dataSource: [SLSelectSectionModel]
    private var compelect:((_ modle: SLSelectSectionModel) ->())?
    
    private init(_ dataSource:[SLSelectSectionModel],_ selectModel: SLSelectSectionModel? = nil,title: String?) {
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
    
    private func layout(){
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
    
    private func beginAnimation() {
        UIApplication.shared.keyWindow?.addSubview(bgWindow)
        
        bgWindow.addSubview(self)
        bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
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
    
    @objc private func dismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 0
        }) { finished in
            self.bgWindow.removeFromSuperview()
            
        }
    }
    
    @objc private func certainClick(){
        dismiss()
        compelect?(dataSource[pickView.selectedRow(inComponent: 0)])
        
    }
    
    @objc private func cancelClick(){
        dismiss()
        
    }
    
    // MARK: -getter
    
    private lazy var titleLabel : UILabel = {
        let view = getLabel(text: title ?? "")
        view.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#000000"), night: UIColor.white)
        view.font = UIFont.boldSystemFont(ofSize: 17)
        view.numberOfLines = 0
        view.textAlignment = NSTextAlignment.center
        return view
    }()
    
    private lazy var pickView: UIPickerView = {
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
    
    
    private lazy var leftButton : SLButton = {
        let button = SLButton.init()
        button.setTitleColor(UIColor.sl_hexToAdecimalColor(hex: "#797B7E"), for: .normal)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightButton : SLButton = {
        let button = SLButton.init()
        button.setTitleColor(kBlueColor, for: .normal)
        button.setTitle("确认", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(certainClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var bgWindow : UIControl! = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        return view
    }()
}

extension SLSelectAlertView:UIPickerViewDataSource,UIPickerViewDelegate{
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
