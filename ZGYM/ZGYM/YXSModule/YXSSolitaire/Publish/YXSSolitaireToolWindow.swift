//
//  YXSSolitaireToolWindow.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/27.
//  Copyright © 2020 zgym. All rights reserved.
//

import NightNight

class YXSSolitaireSettingBar: UIView{
    var settingClickBlock: (() -> ())?
    var pickUpClickBlock: (() -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F7F9FD"), night: kNight282C3B)
        self.addSubview(settingButton)
        settingButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15.5)
            make.top.equalTo(7)
            make.width.equalTo(35)
        }
        
        self.addSubview(pickUpButton)
        pickUpButton.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(18)
            make.width.equalTo(35)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func settingClick(){
        settingClickBlock?()
    }
    
    @objc func pickUpClick(){
        pickUpClickBlock?()
    }
    
    lazy var settingButton: YXSCustomImageControl = {
        let settingButton = YXSCustomImageControl.init(imageSize: CGSize.init(width: 26, height: 26), position: YXSImagePositionType.top, padding: 7)
        settingButton.font = UIFont.systemFont(ofSize: 12)
        settingButton.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: kNightBCC6D4)
        settingButton.locailImage = "yxs_solitaire_setting"
        settingButton.title = "设置"
        settingButton.addTarget(self, action: #selector(settingClick), for: .touchUpInside)
        return settingButton
    }()
    
    lazy var pickUpButton: YXSCustomImageControl = {
        let settingButton = YXSCustomImageControl.init(imageSize: CGSize.init(width: 14.5, height: 9.5), position: YXSImagePositionType.top, padding: 12)
        settingButton.font = UIFont.systemFont(ofSize: 12)
        settingButton.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: kNightBCC6D4)
        settingButton.locailImage = "yxs_solitaire_packUp"
        settingButton.title = "收起"
        settingButton.addTarget(self, action: #selector(pickUpClick), for: .touchUpInside)
        settingButton.isHidden = true
        return settingButton
    }()
}


class YXSSolitaireToolWindow: UIView{
    @discardableResult static func showToolWindow(publishModel: YXSPublishModel, inView: UIView) -> YXSSolitaireToolWindow{
        let view = YXSSolitaireToolWindow(publishModel: publishModel, inView: inView)
        view.beganShowTool()
        return view
    }
    private  let publishModel: YXSPublishModel
    private let inView: UIView
    init(publishModel: YXSPublishModel, inView: UIView) {
        self.publishModel = publishModel
        self.inView = inView
        super.init(frame: CGRect.zero)
        self.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F7F9FD"), night: kNight282C3B)
        self.addSubview(settingView)
        self.addSubview(dateSection)
        self.addSubview(topSwitch)
        self.addSubview(studentSection)
        settingView.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.left.top.right.equalTo(0)
        }
        settingView.yxs_addLine()
        dateSection.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.left.right.equalTo(0)
            make.top.equalTo(settingView.snp_bottom).offset(19)
        }
        studentSection.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.left.right.equalTo(0)
            make.top.equalTo(dateSection.snp_bottom).offset(9)
        }
        topSwitch.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.left.right.equalTo(0)
            make.top.equalTo(studentSection.snp_bottom).offset(9)
        }
        
        topSwitch.swt.isOn = publishModel.isTop
        dateSection.rightLabel.text = publishModel.solitaireDate?.toString(format: DateFormatType.custom("yyyy/MM/dd HH:mm"))
        
        setSolitaireCountUI()
    }
    
    public func beganShowTool(){
        inView.addSubview(self)
        self.frame = CGRect(x: 0, y: inView.height - 60 - kSafeBottomHeight, width: inView.width, height: 240 + kSafeBottomHeight)
        UIView.animate(withDuration: 0.25) {
            self.frame = CGRect(x: 0, y: self.inView.height - (240 + kSafeBottomHeight), width: self.inView.width, height: 240 + kSafeBottomHeight)
        }
    }
    
    public func hideTool(){
        UIView.animate(withDuration: 0.25, animations: {
            self.frame = CGRect(x: 0, y: self.inView.height - 60 - kSafeBottomHeight, width: self.inView.width, height: 240 + kSafeBottomHeight)
        }) { (finish) in
            self.isHidden = true
            self.bgView.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func selectStudentClick(){
        if let totalCommitUpperLimit = publishModel.totalCommitUpperLimit{
            if totalCommitUpperLimit == 0{
                MBProgressHUD.yxs_showMessage(message: "班级暂无人员")
                return
            }
            var dataSource = [YXSPunchCardDay]()
            for index in 1...totalCommitUpperLimit{
                let model = YXSPunchCardDay.init("\(totalCommitUpperLimit - index + 1)", index)
                dataSource.append(model)
            }
            YXSPunchCardSelectDaysView.showAlert(self.publishModel.solitaireStudents,yxs_dataSource: dataSource,title: "提交人数上限", compelect: {  [weak self] (modle, _) in
                guard let strongSelf = self else { return }
                strongSelf.publishModel.solitaireStudents = modle
                strongSelf.publishModel.commitUpperLimit = modle.text.int ?? 0
                strongSelf.setSolitaireCountUI()
            })
        }else{
            MBProgressHUD.yxs_showMessage(message: "请先选择班级")
        }
    }

    
    @objc func dateSectionClick(){
        YXSDatePickerView.showDateView(publishModel.solitaireDate) {[weak self]  (date) in
            guard let strongSelf = self else { return }
            strongSelf.publishModel.solitaireDate = date
            strongSelf.dateSection.rightLabel.text = date.toString(format: DateFormatType.custom("yyyy/MM/dd HH:mm"))
        }
    }
    
    // MARK: -pivate
    func setSolitaireCountUI(){
        self.studentSection.rightLabel.text = publishModel.totalCommitUpperLimit == publishModel.commitUpperLimit ? "全部" : "\(publishModel.commitUpperLimit ?? 0)"
        self.studentSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
    }
    
    
    // MARK: - getter&setter
    lazy var bgView: UIView = {
       let bgView = UIView()
        bgView.backgroundColor = UIColor.clear
        return bgView
    }()
    
    lazy var settingView: YXSSolitaireSettingBar = {
        let settingView = YXSSolitaireSettingBar()
        settingView.pickUpButton.isHidden = false
        settingView.pickUpClickBlock = {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.hideTool()
        }
        return settingView
    }()
    
    lazy var dateSection: SLTipsRightLabelSection = {
        let dateSection = SLTipsRightLabelSection()
        dateSection.leftlabel.text = "截止日期"
        dateSection.addTarget(self, action: #selector(dateSectionClick), for: .touchUpInside)
        dateSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        dateSection.backgroundColor = UIColor.clear
        dateSection.arrowImage.snp.remakeConstraints { (make) in
            make.right.equalTo(-14)
            make.size.equalTo(CGSize.init(width: 13.4, height: 13.4))
            make.centerY.equalTo(dateSection)
        }
        return dateSection
    }()
    
    lazy var topSwitch: YXSPublishSwitchLabel = {
        let topSwitch = YXSPublishSwitchLabel()
        topSwitch.titleLabel.text = "是否置顶"
        topSwitch.backgroundColor = UIColor.clear
        topSwitch.yxs_removeLine()
        topSwitch.swt.snp.remakeConstraints { (make) in
            make.right.equalTo(-25)
            make.size.equalTo(CGSize.init(width: 43, height: 22))
            make.centerY.equalTo(topSwitch)
        }
        return topSwitch
    }()
    
    lazy var studentSection: SLTipsRightLabelSection = {
        let studentSection = SLTipsRightLabelSection()
        studentSection.leftlabel.text = "提交人数上限"
        studentSection.addTarget(self, action: #selector(selectStudentClick), for: .touchUpInside)
        studentSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        studentSection.backgroundColor = UIColor.clear
        studentSection.arrowImage.snp.remakeConstraints { (make) in
            make.right.equalTo(-14)
            make.size.equalTo(CGSize.init(width: 13.4, height: 13.4))
            make.centerY.equalTo(studentSection)
        }
        return studentSection
    }()
}
