//
//  SLAddressPickerView.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/14.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLAddressPickerView: SLBasePopingView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selectedProvinceIndex: Int = 0
    var selectedCityIndex: Int = 0
    var selectedDistrictIndex: Int = 0
    var address: [SLAddressProvince] = SLAddressPickerModel.shareInstance().address
    var block: ((_ province:String, _ city:String, _ district:String, _ view: SLAddressPickerView)->())?
    
    init(frame: CGRect, completionHandler:((_ province:String, _ city:String, _ district:String, _ view: SLAddressPickerView)->())?) {
        block = completionHandler
        
        super.init(frame: frame)
        
        self.layer.cornerRadius = 0
        self.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNight282C3B)
        
        self.lbTitle.text = "选择地区"
        
        
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.addSubview(pickerView)
        self.addSubview(btnCancel)
        self.addSubview(btnDone)

        self.snp.remakeConstraints({ (make) in
            make.height.equalTo(320)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        })

        pickerView.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle.snp_bottom)
            make.left.equalTo(0).offset(0)
            make.right.equalTo(0).offset(0)
        })
        
        btnCancel.snp.makeConstraints({ (make) in
            make.top.equalTo(pickerView.snp_bottom).offset(10)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(49)
        })
        
        btnDone.snp.makeConstraints({ (make) in
            make.top.equalTo(pickerView.snp_bottom).offset(10)
            make.left.equalTo(btnCancel.snp_right)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(btnCancel.snp_width)
            make.height.equalTo(btnCancel.snp_height)
        })
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Action
    @objc func doneClick(sender: SLButton) {
        block?(self.address[selectedProvinceIndex].name, self.address[selectedProvinceIndex].citys[selectedCityIndex].name, self.address[selectedProvinceIndex].citys[selectedCityIndex].districts[selectedDistrictIndex].name, self)
    }
    
    // MARK: - Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch (component) {
            case 0:
                return self.address.count;
                
            case 1:
                return self.address[self.selectedProvinceIndex].citys.count;
                
            default:
                return self.address[self.selectedProvinceIndex].citys[self.selectedCityIndex].districts.count;
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = SLLabel()
        pickerLabel.adjustsFontSizeToFitWidth = true
        pickerLabel.textAlignment = .center
        pickerLabel.backgroundColor = UIColor.clear
        pickerLabel.font = UIFont.systemFont(ofSize: 14)
        pickerLabel.text = getTitle(pickerView: pickerView, forRow: row, forComponent: component)
        pickerLabel.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"), night: kNightBCC6D4)
        return pickerLabel;
    }
    
    @objc func getTitle(pickerView:UIPickerView, forRow:Int, forComponent:Int) ->String {
        switch (forComponent) {
            case 0:
                return self.address[forRow].name;
            case 1:
                return self.address[self.selectedProvinceIndex].citys[forRow].name;
            default:
                return self.address[self.selectedProvinceIndex].citys[self.selectedCityIndex].districts[forRow].name;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch (component) {
            case 0:
                self.selectedProvinceIndex = row;
                self.selectedCityIndex = 0;
                self.selectedDistrictIndex = 0;
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: true)
                
                pickerView.reloadComponent(2)
                pickerView.selectRow(0, inComponent: 2, animated: true)

            case 1:
                self.selectedCityIndex = row;
                self.selectedDistrictIndex = 0;
                
                pickerView.reloadComponent(2)
                pickerView.selectRow(0, inComponent: 2, animated: true)
            
            case 2:
                self.selectedDistrictIndex = row;

            default:
                break;
        }
    }
    
    
    // MARK: -
    lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight383E56)
        return view
    }()
    
    lazy var btnCancel: SLButton = {
        let btn = SLButton()
        btn.setTitle("取消", for: .normal)
        btn.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight383E56)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setMixedTitleColor(MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"), night: kNightBCC6D4), forState: .normal)
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(cancelClick(sender:)), for: .touchUpInside)
        btn.sl_addLine(position: .right, leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
        return btn
    }()
    
    lazy var btnDone: SLButton = {
        let btn = SLButton()
        btn.setTitle("确认", for: .normal)
        btn.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight383E56)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(UIColor.sl_hexToAdecimalColor(hex: "#5E88F7"), for: .normal)
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(doneClick(sender:)), for: .touchUpInside)
        return btn
    }()
}
