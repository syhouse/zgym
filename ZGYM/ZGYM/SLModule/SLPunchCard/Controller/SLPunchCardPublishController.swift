//
//  SLPunchCardPublishController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/27.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLPunchCardPublishController: SLCommonPublishBaseController {
    // MARK: -leftCycle
    var punchCardComplete: ((_ requestModel: HMRequestShareModel, _ shareModel: PunchCardShareModel) -> ())?
    var punchCardModel: SLPunchCardModel?

    init(_ punchCardModel: SLPunchCardModel?) {
        self.punchCardModel = punchCardModel
        super.init(nil)
        saveDirectory = "punchCard"
        sourceDirectory = .punchCard
    }
    convenience init(){
        self.init(nil)
    }
    
    override var fileName: String{
        get{
            return "\(saveDirectory)\(punchCardModel?.clockInId ?? 0)\(sl_user.type ?? "")"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "打卡"
        updateUI()
        publishView = SLCommonPublishView.init(publishModel: publishModel,isShowMedia: SLPersonDataModel.sharePerson.personRole == .TEACHER ? false : true, limitTextLength: 800)
        
        SLPersonDataModel.sharePerson.personRole == .PARENT ? setPartentUI() : setTeacherUI()
        subjectField.text = publishModel.subjectText
        

        
        NotificationCenter.default.addObserver(self,
        selector: #selector(self.greetingTextFieldChanged),
        name:NSNotification.Name(rawValue:"UITextFieldTextDidChangeNotification"),
        object: self.subjectField)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: -UI
    func setTeacherUI(){
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        // 添加容器视图
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view) // 确定的宽度，因为垂直滚动
        }
        contentView.addSubview(publishView)
        contentView.addSubview(selectClassView)
        contentView.addSubview(subjectField)
        contentView.addSubview(weakSection)
        contentView.addSubview(daysSection)
        contentView.addSubview(topSwitch)
        selectClassView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        
        subjectField.snp.makeConstraints { (make) in
            make.top.equalTo(selectClassView.snp_bottom).offset(10)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        publishView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(subjectField.snp_bottom).offset(10)
        }
        
        weakSection.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(publishView.snp_bottom).offset(10)
            make.height.equalTo(49)
        }
        daysSection.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(weakSection.snp_bottom)
            make.height.equalTo(49)
        }
        
        topSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(daysSection.snp_bottom)
            make.bottom.equalTo(-kSafeBottomHeight - 18.5)
            make.height.equalTo(49)
        }
        
        topSwitch.swt.isOn = publishModel.isTop
    }
    
    func setPartentUI(){
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        // 添加容器视图
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view) // 确定的宽度，因为垂直滚动
        }
        contentView.addSubview(publishView)
        
        publishView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(10)
            make.bottom.equalTo(-kSafeBottomHeight - 18.5)
        }
    }
    
    func updateUI(){
        var punchCardWeaks = kPunCardDefultWeaks
        if let lastPunchCardWeaks = publishModel.punchCardWeaks {
            punchCardWeaks = lastPunchCardWeaks
        }else{
            publishModel.punchCardWeaks = punchCardWeaks
        }
        var strs = [String]()
        for model in punchCardWeaks {
            strs.append(model.text)
        }
        let text = punchCardWeaks.count == 7 ? "每天" : strs.joined(separator: ",")
        self.weakSection.rightLabel.text = text
        self.weakSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        
        var punchCardDay = PunchCardDay.init("21天", 21)
        if let lastCardDay = publishModel.punchCardDay{
            punchCardDay = lastCardDay
        }else{
            publishModel.punchCardDay = punchCardDay
        }
        self.daysSection.rightLabel.text = punchCardDay.text
        self.daysSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
    }
    
    // MARK: -loadData
    
    // MARK: -action
    @objc func greetingTextFieldChanged(obj:Notification) {
        self.greetingTextFieldChanged(obj: obj, length : 20)
    }
    
    @objc func selectDaysClick(){
        SLPunchCardSelectDaysView.showAlert(self.publishModel.punchCardDay, compelect: {  [weak self] (modle) in
            guard let strongSelf = self else { return }
            strongSelf.publishModel.punchCardDay = modle
            strongSelf.updateUI()
        })
    }
    
    @objc func selectWeakClick(){
        SLPunchCardSelectWeakView.showAlert(self.publishModel.punchCardWeaks) { [weak self](punchCardWeaks) in
            guard let strongSelf = self else { return }
            strongSelf.publishModel.punchCardWeaks = punchCardWeaks
            strongSelf.updateUI()
        }
    }
    
    // MARK: -loadData
    override func sl_loadCommintData(mediaInfos: [[String: Any]]?){
        var classIdList = [Int]()
        var picture: String = ""
        var video: String = ""
        var audioUrl: String = ""
        var pictures = [String]()
        var bgUrl: String = ""
        if let classs = publishModel.classs{
            for model in classs{
                classIdList.append(model.id ?? 0)
            }
        }
        
        if let mediaInfos = mediaInfos{
            for model in mediaInfos{
                if let type = model[typeKey] as? SourceNameType{
                    if type == .video{
                        video = model[urlKey] as? String ?? ""
                    }else if type == .image{
                        pictures.append(model[urlKey] as? String ?? "")
                    }else if type == .voice{
                        audioUrl = model[urlKey] as? String ?? ""
                    }else if type == .firstVideo{
                        bgUrl = model[urlKey] as? String ?? ""
                    }
                }
            }
            
        }
        if pictures.count > 0{
            picture = pictures.joined(separator: ",")
        }
        if SLPersonDataModel.sharePerson.personRole == .PARENT{
            MBProgressHUD.sl_showLoading(message: "提交中")
            SLEducationClockInParentCommitRequest.init(childrenId: punchCardModel?.childrenId ?? 0, clockInId: punchCardModel?.clockInId ?? 0, content: publishView.textView.text, audioUrl: audioUrl, audioDuration: publishModel.audioModels.first?.time ?? 0, videoUrl: video, bgUrl: bgUrl, imageUrl: picture, link:  publishModel.publishLink ?? "").request({ (result) in
                MBProgressHUD.sl_showMessage(message: "提交成功")
                self.sl_remove()
                self.loadChildInfoData()
                
            }) { (msg, code) in
                MBProgressHUD.sl_showMessage(message: msg)
            }
        }else{
            MBProgressHUD.sl_showLoading(message: "发布中")
            SLEducationClockInTeacherPublishRequest.init(classIdList: classIdList,content: publishView.textView.text, title: subjectField.text!, periodList: publishModel.periodList, totalDay: publishModel.punchCardDay!.paramsKey, audioUrl: audioUrl, audioDuration:  publishModel.audioModels.first?.time ?? 0, videoUrl: video, bgUrl: bgUrl, imageUrl: picture, link: publishModel.publishLink ?? "", isTop: topSwitch.isSelect ? 1 : 0).request({ (result) in
                MBProgressHUD.sl_showMessage(message: "发布成功")
                self.sl_remove()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kTeacherPublishSucessNotification), object: nil)
                    self.navigationController?.popViewController()
                }
            }) { (msg, code) in
                MBProgressHUD.sl_showMessage(message: msg)
            }
        }
    }
    
    func loadChildInfoData(){
        SLEducationClockInStatisticsTodayChildrenRequest.init(childrenId: punchCardModel?.childrenId ?? 0, clockInId: punchCardModel?.clockInId ?? 0).request({ (result) in
            MBProgressHUD.sl_hideHUD()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationIdKey: self.punchCardModel?.clockInId ?? 0])
                let hasFinish = self.punchCardModel?.surplusClockInDayCount ?? 1 ==  1
                UIUtil.sl_reduceAgenda(serviceId: self.punchCardModel?.clockInId ?? 0, info: [kEventKey: HomeType.punchCard,kValueKey: hasFinish])
                self.navigationController?.popViewController()
                
                self.punchCardComplete?(HMRequestShareModel.init(clockInId: self.punchCardModel?.clockInId ?? 0, childrenId: self.punchCardModel?.childrenId ?? 0)
                    ,PunchCardShareModel.init(downLoadUrl: result["appDownloadUrl"].stringValue, name: self.sl_user.curruntChild?.realName ?? "", avar: self.sl_user.curruntChild?.avatar ?? "", title: self.punchCardModel?.title ?? "", clockInDayCount: result["clockInDayCount"].intValue, percentOver: result["percentOver"].stringValue, bgUrl: result["bgUrl"].stringValue))
            }
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: -pivate
    override func sl_cheackCanSetUp() -> Bool {
        if SLPersonDataModel.sharePerson.personRole == .TEACHER{
            if publishModel.punchCardDay == nil {
                sl_showAlert(title: "请选择打卡总天数")
                return false
            }
            if publishModel.punchCardWeaks == nil {
                sl_showAlert(title: "请选择打卡周期")
                return false
            }
            if subjectField.text!.count == 0{
                sl_showAlert(title: "请输入打卡主题")
                return false
            }
            if subjectField.text!.isBlank{
                sl_showAlert(title: "打卡主题不能为空")
                return false
            }
        }
        return super.sl_cheackCanSetUp()
    }
    
    override func save(){
        publishModel.subjectText = subjectField.text
        publishModel.isTop = topSwitch.swt.isOn
        NSKeyedArchiver.archiveRootObject(publishModel, toFile: NSUtil.sl_cachePath(file: fileName, directory: "archive"))
    }
    
    // MARK: - getter&setter
    
    lazy var subjectField: SLQSTextField = {
        let classField = UIUtil.sl_getTextField(UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0), placeholder: "请输入打卡主题，最多可输入20字", placeholderColor: kNight898F9A, mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: UIColor.white))
        classField.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        return classField
    }()
    
    lazy var topSwitch: SLPublishSwitchLabel = {
        let topSwitch = SLPublishSwitchLabel()
        topSwitch.titleLabel.text = "是否置顶"
        return topSwitch
    }()
    
    lazy var weakSection: SLTipsRightLabelSection = {
        let weakSection = SLTipsRightLabelSection()
        weakSection.leftlabel.text = "打卡周期"
        weakSection.addTarget(self, action: #selector(selectWeakClick), for: .touchUpInside)
        return weakSection
    }()
    
    lazy var daysSection: SLTipsRightLabelSection = {
        let daysSection = SLTipsRightLabelSection()
        daysSection.leftlabel.text = "需要打卡天数"
        daysSection.addTarget(self, action: #selector(selectDaysClick), for: .touchUpInside)
        return daysSection
    }()
}
