//
//  YXSPunchCardPublishController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/27.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper

class YXSPunchCardPublishController: YXSCommonPublishBaseController {
    // MARK: -leftCycle
    public var punchCardComplete: ((_ requestModel: HMRequestShareModel, _ shareModel: YXSPunchCardShareModel) -> ())?
    
    /// 是否是补卡
    private var isPatch: Bool = false
    
    
    /// 当前选择日历补卡
    private var patchCardTime: String?
    
    
    /// 多选日历
    private var patchCardTimeList: [String]?
    //    SLPunchCardCommintListModel
    
    private var clockInId: Int = 0
    
    /// 打卡任务model
    private var punchCardModel: YXSPunchCardModel?
    
    ///修改的model
    var changePunchCardModel: YXSPunchCardCommintListModel?
    
    /// 老师发布打卡
    init(){
        super.init(nil)
        saveDirectory = "punchCard"
        sourceDirectory = .punchCard
    }
    
    /// 家长修改打卡
    /// - Parameter changePunchCardModel: changePunchCardModel
    convenience init(changePunchCardModel: YXSPunchCardCommintListModel?){
        self.init()
        self.changePunchCardModel = changePunchCardModel
        self.clockInId = changePunchCardModel?.clockInId ?? 0
    }
    
    
    /// 家长选择日历补卡
    /// - Parameters:
    ///   - patchCardTime: 补卡时间
    ///   - clockInId: 打卡任务id
    convenience init(patchCardTime: String, punchCardModel: YXSPunchCardModel){
        self.init()
        self.isPatch = true
        self.patchCardTime = patchCardTime
        self.clockInId = punchCardModel.clockInId ?? 0
        self.punchCardModel = punchCardModel
    }
    
    
    /// 家长漏卡补卡
    /// - Parameters:
    ///   - patchCardTimeList: 漏卡列表
    ///   - clockInId: 打卡任务id
    convenience init( patchCardTimeList: [String],punchCardModel: YXSPunchCardModel){
        self.init()
        self.isPatch = true
        self.patchCardTimeList = patchCardTimeList
        self.clockInId = punchCardModel.clockInId ?? 0
        self.punchCardModel = punchCardModel
    }
    
    
    /// 家长打卡
    /// - Parameters:
    ///   - clockInId: 打卡任务id
    ///   - childrenId: 孩子id
    convenience init( punchCardModel: YXSPunchCardModel){
        self.init()
        self.clockInId = punchCardModel.clockInId ?? 0
        self.punchCardModel = punchCardModel
    }
    
    override var fileName: String{
        get{
            return "\(saveDirectory)\(clockInId)\(yxs_user.type ?? "")"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "打卡"
        self.publishType = .punchCard
        updateUI()
        publishView = YXSCommonPublishView.init(publishModel: publishModel,isShowMedia: YXSPersonDataModel.sharePerson.personRole == .TEACHER ? false : true, limitTextLength: 800,type: .punchCard)
        
        YXSPersonDataModel.sharePerson.personRole == .PARENT ? setPartentUI() : setTeacherUI()
        subjectField.text = publishModel.subjectText
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.greetingTextFieldChanged),
                                               name:NSNotification.Name(rawValue:"UITextFieldTextDidChangeNotification"),
                                               object: self.subjectField)
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            loadTemplateData()
            
            publishView.limitTextLength = 500
            publishView.setPlaceholderText("请输入打卡任务，最多可输入500字")
        }
        
    }
    
    override func initPublish() {
        if let changePunchCardModel = changePunchCardModel{
            if let publishModel = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_cachePath(file: fileName, directory: "archive")) as? SLPublishEditModel{
                self.publishModel = publishModel
            }else{
                //初始化资源
                self.publishModel = SLPublishEditModel()
                publishModel.sourceDirectory = sourceDirectory
                var publishMedias = [SLPublishMediaModel]()
                if let videoUrl = changePunchCardModel.videoUrl,videoUrl.count != 0{
                    let mediaModel = SLPublishMediaModel()
                    mediaModel.serviceUrl = videoUrl
                    mediaModel.showImageUrl = changePunchCardModel.bgUrl
                    publishMedias.append(mediaModel)
                }
                
                if let imageUrl = changePunchCardModel.imageUrl,imageUrl.count != 0{
                    let images = imageUrl.split(separator: ",")
                    for imageStr in images{
                        let mediaModel = SLPublishMediaModel()
                        mediaModel.serviceUrl = String(imageStr)
                        publishMedias.append(mediaModel)
                    }
                }
                
                publishModel.medias = publishMedias
                
                //设置音频(当前只设置一个)
                if let audioUrl = changePunchCardModel.audioUrl, audioUrl.count != 0{
                    let audioModel = SLAudioModel()
                    audioModel.servicePath = audioUrl
                    audioModel.time = changePunchCardModel.audioDuration ?? 0
                    publishModel.audioModels = [audioModel]
                }
                
                //                audioUrl  audioDuration
                publishModel.publishText = changePunchCardModel.content
            }
        }else{
            if let publishModel = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_cachePath(file: fileName, directory: "archive")) as? YXSPublishModel{
                self.publishModel = publishModel
            }else{
                self.publishModel = YXSPublishModel()
                publishModel.sourceDirectory = sourceDirectory
                publishModel.remindPanchCardTime = "18:00"
                publishModel.isAllowPatch = true
            }
        }
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
        contentView.addSubview(templateSection)
        
        contentView.addSubview(subjectField)
        contentView.addSubview(weakSection)
        contentView.addSubview(daysSection)
        contentView.addSubview(topSwitch)
        contentView.addSubview(remindTimeSection)
        contentView.addSubview(patchSwitch)
        selectClassView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        
        templateSection.snp.makeConstraints { (make) in
            make.top.equalTo(selectClassView.snp_bottom).offset(10)
            make.left.right.equalTo(0)
        }
        
        subjectField.snp.makeConstraints { (make) in
            make.top.equalTo(templateSection.snp_bottom).offset(10)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        publishView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(subjectField.snp_bottom).offset(0)
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
        remindTimeSection.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(daysSection.snp_bottom)
            make.height.equalTo(49)
        }
        patchSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(remindTimeSection.snp_bottom)
            make.height.equalTo(49)
        }
        topSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(patchSwitch.snp_bottom)
            make.bottom.equalTo(-kSafeBottomHeight - 18.5)
            make.height.equalTo(49)
        }
        
        weakSection.yxs_addLine(position: .bottom, leftMargin: 15)
        daysSection.yxs_addLine(position: .bottom, leftMargin: 15)
        remindTimeSection.yxs_addLine(position: .bottom, leftMargin: 15)
        patchSwitch.yxs_addLine(position: .bottom, leftMargin: 15)
    }
    
    func setPartentUI(){
        
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        // 添加容器视图
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(scrollView)
            make.left.right.equalTo(view) // 确定的宽度，因为垂直滚动
        }
        
        var isShowSelectTime = false
        if let patchCardTimeList = patchCardTimeList{
            isShowSelectTime = true
            patchCardTime = publishModel.patchCardTime
            if !patchCardTimeList.contains(patchCardTime ?? ""){
                patchCardTime = patchCardTimeList.first
            }
        }
        if isShowSelectTime{
            contentView.addSubview(patchSelectTimeSection)
            patchSelectTimeSection.snp.makeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(10)
                make.height.equalTo(49)
            }
            
            self.patchSelectTimeSection.rightLabel.text = patchCardTime?.date(withFormat: kCommonDateFormatString)?.toString(format: DateFormatType.custom("MM月dd日"))
            self.patchSelectTimeSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        }
        
        
        contentView.addSubview(publishView)
        
        publishView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            if isShowSelectTime{
                make.top.equalTo(patchSelectTimeSection.snp_bottom).offset(10)
            }else{
                make.top.equalTo(10)
            }
            make.bottom.equalTo(-kSafeBottomHeight - 18.5)
        }
        
        
    }
    
    func updateUI(){
        var punchCardWeaks = kYXSPunCardDefultWeaks
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
        
        var punchCardDay = YXSPunchCardDay.init("21天", 21)
        if let lastCardDay = publishModel.punchCardDay{
            punchCardDay = lastCardDay
        }else{
            publishModel.punchCardDay = punchCardDay
        }
        self.daysSection.rightLabel.text = punchCardDay.text
        self.daysSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        
        topSwitch.swt.isOn = publishModel.isTop
        patchSwitch.swt.isOn = publishModel.isAllowPatch
        self.remindTimeSection.rightLabel.text = publishModel.remindPanchCardTime
        self.remindTimeSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
    }
    
    // MARK: -loadData
    
    // MARK: -action
    @objc func greetingTextFieldChanged(obj:Notification) {
        self.greetingTextFieldChanged(obj: obj, length : 20)
    }
    
    @objc func selectDaysClick(){
        YXSPunchCardSelectDaysView.showAlert(self.publishModel.punchCardDay, compelect: {  [weak self] (modle, _) in
            guard let strongSelf = self else { return }
            strongSelf.publishModel.punchCardDay = modle
            strongSelf.updateUI()
        })
    }
    
    @objc func selectWeakClick(){
        YXSPunchCardSelectWeakView.showAlert(self.publishModel.punchCardWeaks) { [weak self](punchCardWeaks) in
            guard let strongSelf = self else { return }
            strongSelf.publishModel.punchCardWeaks = punchCardWeaks
            strongSelf.updateUI()
        }
    }
    
    @objc func selectRemindTimeClick(){
        var currentModel: YXSPunchCardDay?
        var selectTimes = [YXSPunchCardDay]()
        for index in 0..<24{
            let model = YXSPunchCardDay.init(String.init(format: "%02d", index) + ":00", 0)
            selectTimes.append(model)
            if model.text == publishModel.remindPanchCardTime{
                currentModel = model
            }
        }
        YXSPunchCardSelectDaysView.showAlert(currentModel,yxs_dataSource: selectTimes, title: "选择提醒时间", compelect: {  [weak self] (modle, _) in
            guard let strongSelf = self else { return }
            strongSelf.publishModel.remindPanchCardTime = modle.text
            strongSelf.remindTimeSection.rightLabel.text =  modle.text
        })
             
    }
    
    @objc func patchSelectTimeClick(){
        
        if let patchCardTimeList = patchCardTimeList{
            var currentModel: YXSPunchCardDay?
            var selectTimes = [YXSPunchCardDay]()
            for time in patchCardTimeList{
                let model = YXSPunchCardDay.init(time.date(withFormat: kCommonDateFormatString)?.toString(format: DateFormatType.custom("MM月dd日")) ?? "", 0)
                selectTimes.append(model)
                if time == patchCardTime{
                    currentModel = model
                }
            }
            YXSPunchCardSelectDaysView.showAlert(currentModel,yxs_dataSource: selectTimes, title: "选择补卡时间", compelect: {  [weak self] (modle, index) in
                guard let strongSelf = self else { return }
                strongSelf.patchCardTime = patchCardTimeList[index]
                strongSelf.patchSelectTimeSection.rightLabel.text =  modle.text
            })
            
            
        }
    }
    
    // MARK: - loadData
    override func yxs_loadCommintData(mediaInfos: [[String: Any]]?){
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
        
        //修改打卡
        if let changePunchCardModel = changePunchCardModel{
            MBProgressHUD.yxs_showLoading(message: "提交中", inView: self.navigationController?.view)
            YXSEducationClockInParentUpDateCommitRequest.init(childrenId: changePunchCardModel.childrenId ?? 0, clockInId: clockInId, content: publishView.getTextContent(), audioUrl: audioUrl, audioDuration: publishModel.audioModels.first?.time ?? 0, videoUrl: video, bgUrl: bgUrl, imageUrl: picture, clockInCommitId: changePunchCardModel.clockInCommitId ?? 0).request({ (result) in
                MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
                MBProgressHUD.yxs_showMessage(message: "修改成功", inView: self.navigationController!.view)
                //                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationIdKey: self.punchCardModel?.clockInId ?? 0])
                
                changePunchCardModel.audioUrl = audioUrl
                changePunchCardModel.content = self.publishView.getTextContent()
                changePunchCardModel.audioDuration = self.publishModel.audioModels.first?.time ?? 0
                changePunchCardModel.bgUrl = bgUrl
                changePunchCardModel.videoUrl = video
                changePunchCardModel.imageUrl = picture
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kOperationStudentChangePunchCardNotification), object: changePunchCardModel)
                self.navigationController?.popViewController()
            }) { (msg, code) in
                MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }else if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            var request: YXSBaseRequset!
            if isPatch{
                request = YXSEducationClockInParentPatchCardRequest.init(clockInId: clockInId, childrenId: punchCardModel?.childrenId ?? 0, patchCardTime: patchCardTime ?? "", content: publishView.getTextContent(), audioUrl: audioUrl, audioDuration: publishModel.audioModels.first?.time ?? 0, videoUrl: video, bgUrl: bgUrl, imageUrl: picture)
            }else{
                request = YXSEducationClockInParentCommitRequest.init(childrenId: punchCardModel?.childrenId ?? 0, clockInId: clockInId, content: publishView.getTextContent(), audioUrl: audioUrl, audioDuration: publishModel.audioModels.first?.time ?? 0, videoUrl: video, bgUrl: bgUrl, imageUrl: picture)
            }
            MBProgressHUD.yxs_showLoading(message: "提交中", inView: self.navigationController?.view)
            MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
            request.request({ (result) in
                MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
                MBProgressHUD.yxs_showMessage(message: "提交成功", inView: self.navigationController?.view)
                self.yxs_remove()
                if self.isPatch{
                    self.punchcardSucess()
                }else{
                    self.loadChildInfoData()
                }
            }) { (msg, code) in
                MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }else{
            MBProgressHUD.yxs_showLoading(message: "发布中", inView: self.navigationController?.view)
            YXSEducationClockInTeacherPublishRequest.init(classIdList: classIdList,content: publishView.getTextContent(), title: subjectField.text!, periodList: publishModel.periodList, totalDay: publishModel.punchCardDay!.paramsKey, audioUrl: audioUrl, audioDuration:  publishModel.audioModels.first?.time ?? 0, videoUrl: video, bgUrl: bgUrl, imageUrl: picture, link: publishModel.publishLink ?? "", isTop: topSwitch.isSelect ? 1 : 0, reminder: publishModel.remindPanchCardTime.removingSuffix(":00").int ?? 0, isPatchCard: patchSwitch.isSelect ? 1 : 0).request({ (result) in
                MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
                MBProgressHUD.yxs_showMessage(message: "发布成功", inView: self.navigationController?.view)
                self.yxs_remove()
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kTeacherPublishSucessNotification), object: nil)
                self.navigationController?.popViewController()
            }) { (msg, code) in
                MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
    }
    ///查询模版列表
    func loadTemplateData(){
        YXSEducationTemplateQueryAllTemplateRequest(serviceType: 2).request({ (json) in
            self.templateLists =  Mapper<YXSTemplateListModel>().mapArray(JSONObject: json["templateList"].object) ?? [YXSTemplateListModel]()
            if let templateListModel = self.publishModel.templateListModel{
                for model in self.templateLists{
                    if model.id == templateListModel.id{
                        model.isSelected = true
                        break
                    }
                }
            }
            self.templateSection.setTemplates(items: self.templateLists)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    ///查询模版详情
    func loadTemplateDetialData(id: Int){
        YXSEducationTemplateQueryTemplateByIdRequest(id: id).request({ (detialModel: YXSTemplateDetialModel) in
            self.publishModel.subjectText = detialModel.title
            self.publishModel.publishText = detialModel.content
            
            let jsonData:Data = (detialModel.period ?? "").data(using: .utf8)!
            let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            var list = [Int]()
            if let array = array as? [Any]{
                for item in array{
                    if item is Int{
                        list.append(item as! Int)
                    }
                }
            }
            var punchCardWeaks = [YXSPunchCardWeak]()
            for week in list{
                switch week {
                case 1:
                    punchCardWeaks.append(YXSPunchCardWeak.init("周日", 1))
                case 2:
                punchCardWeaks.append(YXSPunchCardWeak.init("周一", 2))
                case 3:
                punchCardWeaks.append(YXSPunchCardWeak.init("周二", 3))
                case 4:
                punchCardWeaks.append(YXSPunchCardWeak.init("周三", 4))
                case 5:
                punchCardWeaks.append(YXSPunchCardWeak.init("周四", 5))
                case 6:
                punchCardWeaks.append(YXSPunchCardWeak.init("周五", 6))
                case 7:
                punchCardWeaks.append(YXSPunchCardWeak.init("周六", 7))
                default:
                    break
                }
            }
            
            self.publishModel.punchCardWeaks = punchCardWeaks
            self.publishModel.remindPanchCardTime = "\(String.init(format: "%02d", detialModel.reminder ?? 0) ):00"
            
            PunchCardDays.forEach { (model) in
                if model.text == "\(detialModel.totalDay ?? 0)"{
                    self.publishModel.punchCardDay = model
                    return
                }
            }
            self.publishView.setTemplateText(detialModel.content ?? "")
            self.subjectField.text = detialModel.title
            self.updateUI()
            
        }, failureHandler: { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        })
    }
    
    func loadChildInfoData(){
        MBProgressHUD.yxs_showLoading(inView: self.navigationController!.view)
        YXSEducationClockInStatisticsTodayChildrenRequest.init(childrenId: punchCardModel?.childrenId ?? 0, clockInId: punchCardModel?.clockInId ?? 0).request({ (result) in
            MBProgressHUD.yxs_hideHUDInView(view: self.navigationController!.view)
            MBProgressHUD.yxs_hideHUD()

            self.punchcardSucess()
            
            self.punchCardComplete?(HMRequestShareModel.init(clockInId: self.punchCardModel?.clockInId ?? 0, childrenId: self.punchCardModel?.childrenId ?? 0)
                ,YXSPunchCardShareModel.init(downLoadUrl: result["appDownloadUrl"].stringValue, name: self.yxs_user.currentChild?.realName ?? "", avar: self.yxs_user.currentChild?.avatar ?? "", title: self.punchCardModel?.title ?? "", clockInDayCount: result["clockInDayCount"].intValue, percentOver: result["percentOver"].stringValue, bgUrl: result["bgUrl"].stringValue))
        }) { (msg, code) in
            MBProgressHUD.yxs_hideHUDInView(view: self.navigationController!.view)
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    ///家长打卡操作
    func punchcardSucess(){
        if self.patchCardTime == nil{//不是补卡 发送打卡成功通知
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationIdKey: self.punchCardModel?.clockInId ?? 0])
        }
        let hasFinish = self.punchCardModel?.surplusClockInDayCount ?? 1 ==  1
        UIUtil.yxs_reduceAgenda(serviceId: self.punchCardModel?.clockInId ?? 0, info: [kEventKey: YXSHomeType.punchCard,kValueKey: hasFinish])
        self.navigationController?.popViewController()
    }
    
    // MARK: -pivate
    override func yxs_cheackCanSetUp() -> Bool {
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            if publishModel.punchCardDay == nil {
                yxs_showAlert(title: "请选择打卡总天数")
                return false
            }
            if publishModel.punchCardWeaks == nil {
                yxs_showAlert(title: "请选择打卡周期")
                return false
            }
            if subjectField.text!.count == 0{
                yxs_showAlert(title: "请输入打卡主题")
                return false
            }
            if subjectField.text!.isBlank{
                yxs_showAlert(title: "打卡主题不能为空")
                return false
            }
        }
        return super.yxs_cheackCanSetUp()
    }
    
    override func save(){
        publishModel.subjectText = subjectField.text
        publishModel.isTop = topSwitch.swt.isOn
        publishModel.isAllowPatch = patchSwitch.swt.isOn
        publishModel.remindPanchCardTime = remindTimeSection.rightLabel.text ?? ""
        publishModel.patchCardTime = patchCardTime
        NSKeyedArchiver.archiveRootObject(publishModel, toFile: NSUtil.yxs_cachePath(file: fileName, directory: "archive"))
    }
    
    // MARK: - getter&setter
    
    lazy var subjectField: YXSQSTextField = {
        let classField = UIUtil.yxs_getTextField(UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0), placeholder: "请输入打卡主题，最多可输入20字", placeholderColor: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: UIColor.white))
        classField.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        classField.yxs_addLine(position: .bottom, color: kLineColor, leftMargin: 15, lineHeight: 0.5)
        return classField
    }()
    
    lazy var topSwitch: YXSPublishSwitchLabel = {
        let topSwitch = YXSPublishSwitchLabel()
        topSwitch.titleLabel.text = "是否置顶"
        return topSwitch
    }()
    
    lazy var patchSwitch: YXSPublishSwitchLabel = {
        let topSwitch = YXSPublishSwitchLabel()
        topSwitch.titleLabel.text = "是否允许补打卡"
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
    
    lazy var remindTimeSection: SLTipsRightLabelSection = {
        let section = SLTipsRightLabelSection()
        section.leftlabel.text = "提醒时间"
        section.addTarget(self, action: #selector(selectRemindTimeClick), for: .touchUpInside)
        return section
    }()
    
    lazy var patchSelectTimeSection: SLTipsRightLabelSection = {
        let section = SLTipsRightLabelSection()
        section.leftlabel.text = "补卡日期"
        section.addTarget(self, action: #selector(patchSelectTimeClick), for: .touchUpInside)
        return section
    }()
    
    lazy var templateSection: YXSPublishTemplateSection = {
        let templateSection = YXSPublishTemplateSection()
        templateSection.didSelectTemplateBlock = {
            [weak self] (model) in
            guard let strongSelf = self else { return }
            strongSelf.publishModel.templateListModel = model
            strongSelf.loadTemplateDetialData(id: model.id ?? 0)
        }
        return templateSection
    }()
}
