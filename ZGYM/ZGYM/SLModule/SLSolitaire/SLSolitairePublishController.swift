//
//  SLSolitairePublishController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/2.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight
import IQKeyboardManager

let solitaireMax = 4

class SLSolitairePublishController: SLCommonPublishBaseController {
    // MARK: -leftCycle
    
    var classId: Int? {
        return publishModel.classs?.first?.id
    }
    
    var commitUpperLimit: Int?
    var totalCommitUpperLimit: Int?
    

    init(){
        super.init(nil)
        saveDirectory = "Solitaire"
        sourceDirectory = .solitaire
        isSelectSingleClass = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "接龙"
        
        setTeacherUI()
        
        if classId != nil{
            loadClassCountData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 45
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 0
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
        contentView.addSubview(dateSection)
        contentView.addSubview(topSwitch)
        contentView.addSubview(tipsLabel)
        contentView.addSubview(selectView)
        contentView.addSubview(studentSection)
        
        selectClassView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        publishView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(selectClassView.snp_bottom).offset(10)
        }
        
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(publishView.snp_bottom).offset(19)
        }
        
        selectView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(tipsLabel.snp_bottom).offset(13)
        }
        dateSection.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(selectView.snp_bottom).offset(10)
            
            make.height.equalTo(49)
        }
        studentSection.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(dateSection.snp_bottom).offset(10)

            make.height.equalTo(49)
        }
        topSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(studentSection.snp_bottom).offset(10)
            make.height.equalTo(49)
            make.bottom.equalTo(-kSafeBottomHeight - 18.5)
        }
        
        topSwitch.swt.isOn = publishModel.isTop
        dateSection.rightLabel.text = publishModel.solitaireDate?.toString(format: DateFormatType.custom("yyyy/MM/dd HH:mm"))
    }
    
    // MARK: -loadData
    override func sl_loadClassDataSucess(){
        loadClassCountData()
    }
    /// 请求班级人数
    override func loadClassCountData(){
        SLEducationGradeFindNumberOfStudentsRequest.init(gradeId: classId ?? 0).request({ (result) in
            self.totalCommitUpperLimit = result.intValue
            self.setSolitaireCount(count: result.intValue)
        }) { (msg, code) in
        }
    }
    
    // MARK: -action
    @objc func selectStudentClick(){
        if let totalCommitUpperLimit = totalCommitUpperLimit{
            if totalCommitUpperLimit == 0{
                MBProgressHUD.sl_showMessage(message: "班级暂无人员")
                return
            }
            var dataSource = [PunchCardDay]()
            for index in 1...totalCommitUpperLimit{
                let model = PunchCardDay.init("\(totalCommitUpperLimit - index + 1)", index)
                dataSource.append(model)
            }
             SLPunchCardSelectDaysView.showAlert(self.publishModel.solitaireStudents,dataSource: dataSource,title: "提交人数上限", compelect: {  [weak self] (modle) in
                guard let strongSelf = self else { return }
                strongSelf.publishModel.solitaireStudents = modle
                strongSelf.commitUpperLimit = modle.text.int ?? 0
                strongSelf.setSolitaireCount(count: modle.text.int ?? 0)
                
            })
        }else{
            MBProgressHUD.sl_showMessage(message: "请先选择班级")
        }
        
    }
    

    
    @objc func dateSectionClick(){
        view.endEditing(true)
        SLDatePickerView.showDateView(publishModel.solitaireDate) {[weak self]  (date) in
            guard let strongSelf = self else { return }
            strongSelf.publishModel.solitaireDate = date
            strongSelf.dateSection.rightLabel.text = date.toString(format: DateFormatType.custom("yyyy/MM/dd HH:mm"))
        }
    }
    
    // MARK: -pivate
    func setSolitaireCount(count: Int){
        self.studentSection.rightLabel.text = totalCommitUpperLimit == count ? "全部" : "\(count)"
        self.studentSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        self.publishModel.commitUpperLimit = count
    }
    
    override func sl_loadCommintData(mediaInfos: [[String: Any]]?){
        var classIdList = [Int]()
        var picture: String = ""
        var video: String = ""
        var audioUrl: String = ""
        var pictures = [String]()
        var bgUrl: String = ""
        var options = [String]()
        
        if let classs = publishModel.classs{
            for model in classs{
                classIdList.append(model.id ?? 0)
            }
        }
        
        for model in selectView.selectModels{
            options.append(model.title ?? "")
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
        MBProgressHUD.sl_showLoading(message: "发布中")
        SLEducationCensusTeacherPublishRequest.init(classIdList: classIdList, content: publishView.textView.text, audioUrl: audioUrl, audioDuration: publishModel.audioModels.first?.time ?? 0, videoUrl: video, bgUrl: bgUrl, imageUrl: picture, link: publishModel.publishLink ?? "",commitUpperLimit: commitUpperLimit ?? 0, optionList: options, endTime: publishModel.solitaireDate!.toString(format: DateFormatType.custom("yyyy-MM-dd HH:mm:ss")), isTop: topSwitch.isSelect ? 1 : 0).request({ (result) in
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
    // MARK: -pivate
    override func sl_cheackCanSetUp() -> Bool {
        if selectView.selectModels.first?.title?.isBlank ?? true {
            sl_showAlert(title: "请添加接龙内容")
            return false
        }
        if publishModel.solitaireDate == nil {
            sl_showAlert(title: "请选择截止日期")
            return false
        }
        if self.publishModel.commitUpperLimit == nil{
            sl_showAlert(title: "请选择最高接龙人数")
            return false
        }
        return super.sl_cheackCanSetUp()
    }
    
    
    override func save(){
        publishModel.solitaireSelects = selectView.selectModels
        publishModel.isTop = topSwitch.swt.isOn
        NSKeyedArchiver.archiveRootObject(publishModel, toFile: NSUtil.sl_cachePath(file: fileName, directory: "archive"))
    }
    
    // MARK: - getter&setter
    
    lazy var dateSection: SLTipsRightLabelSection = {
        let dateSection = SLTipsRightLabelSection()
        dateSection.leftlabel.text = "截止日期"
        dateSection.addTarget(self, action: #selector(dateSectionClick), for: .touchUpInside)
        dateSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return dateSection
    }()
    
    lazy var topSwitch: SLPublishSwitchLabel = {
        let topSwitch = SLPublishSwitchLabel()
        topSwitch.titleLabel.text = "是否置顶"
        return topSwitch
    }()
    
    lazy var selectView: SolitairePublishSelectView = {
        let selectView = SolitairePublishSelectView(selectModels: publishModel.solitaireSelects)
        return selectView
    }()
    
    lazy var studentSection: SLTipsRightLabelSection = {
        let studentSection = SLTipsRightLabelSection()
        studentSection.leftlabel.text = "提交人数上限"
        studentSection.addTarget(self, action: #selector(selectStudentClick), for: .touchUpInside)
        studentSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return studentSection
    }()
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"))
        label.text = "增加选项"
        return label
    }()
}

class SolitairePublishSelectModel: NSObject, NSCoding{
    var title: String?
    var index: Int = 0{
        didSet{
            switch index {
            case 0:
                leftText = "A"
            case 1:
                leftText = "B"
            case 2:
                leftText = "C"
            default:
                leftText = "D"
            }
        }
    }
    var leftText: String?
    
    override init() {
    }
    
    @objc required init(coder aDecoder: NSCoder){
        title = aDecoder.decodeObject(forKey: "title") as? String
        index = aDecoder.decodeInteger(forKey: "index")
        leftText = aDecoder.decodeObject(forKey: "leftText") as? String
    }
    @objc func encode(with aCoder: NSCoder)
    {
        if title != nil{
            aCoder.encode(title, forKey: "title")
            
        }
        if leftText != nil{
            aCoder.encode(leftText, forKey: "leftText")
            
        }
        aCoder.encode(index, forKey: "index")
        
    }
}

class SolitairePublishSelectView: UIView{
    var selectModels: [SolitairePublishSelectModel]
    init(selectModels: [SolitairePublishSelectModel]?) {
        if let  selectModels = selectModels {
            self.selectModels = selectModels
        }else{
            let model = SolitairePublishSelectModel()
            model.index = 0
            self.selectModels = [model]
        }
        super.init(frame: CGRect.zero)
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showMoreClick(){
        let model = SolitairePublishSelectModel()
        model.index = self.selectModels.count
        self.selectModels.append(model)
        updateUI(true)
    }
    
    func updateUI(_ becomeFirst: Bool = false){
        removeSubviews()
        let showMore:Bool = self.selectModels.count < 4
        var last: UIView!
        for (index, model) in self.selectModels.enumerated(){
            let section = SolitaireSignleSection.init(selectModel: model, showDelect: (index != 0 && index == self.selectModels.count - 1))
            addSubview(section)
            if becomeFirst, index == self.selectModels.count - 1{
                section.contentField.becomeFirstResponder()
            }
            
            section.sectionBlock = {
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.selectModels.remove(at: strongSelf.selectModels.firstIndex(of: model) ?? 0)
                strongSelf.updateUI(true)
            }
            section.snp.makeConstraints { (make) in
                make.height.equalTo(49)
                make.left.right.equalTo(0)
                if index == 0{
                    make.top.equalTo(0)
                }else{
                    make.top.equalTo(last.snp_bottom)
                }
                
                if !showMore && index == 3{
                    make.bottom.equalTo(0)
                }
            }
            last = section
        }
        
        if showMore{
            let button = SLButton.init()
            button.setTitleColor(kBlueColor, for: .normal)
            button.setTitle("增加选项", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            button.setImage(UIImage.init(named: "sl_solitaire_add"), for: .normal)
            button.addTarget(self, action: #selector(showMoreClick), for: .touchUpInside)
            button.sl_setIconInLeftWithSpacing(5)
            addSubview(button)
            button.snp.makeConstraints { (make) in
                make.height.equalTo(49)
                make.top.equalTo(last.snp_bottom)
                make.left.right.bottom.equalTo(0)
            }
        }
    }
}


class SolitaireSignleSection: UIView{
    var selectModel: SolitairePublishSelectModel?
    var showDelect: Bool
    init(selectModel: SolitairePublishSelectModel?, showDelect: Bool) {
        self.selectModel = selectModel
        self.showDelect = showDelect
        super.init(frame: CGRect.zero)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        addSubview(leftLabel)
        addSubview(contentField)
        contentField.text = selectModel?.title
        sl_addLine(position: .bottom, leftMargin: 15.5, rightMargin: 0.5, lineHeight: 0.5)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14.5)
            make.centerY.equalTo(self)
        }
        contentField.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.bottom.equalTo(0)
            make.right.equalTo(-50)
        }
        if showDelect{
            addSubview(delectButton)
            delectButton.snp.makeConstraints { (make) in
                make.right.equalTo(-7.5)
                make.size.equalTo(CGSize.init(width: 39, height: 39))
                make.centerY.equalTo(self)
            }
        }
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.greetingTextFieldChanged),
            name:NSNotification.Name(rawValue:"UITextFieldTextDidChangeNotification"),
            object: self.contentField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    // MARK: -action
    @objc func greetingTextFieldChanged(obj:Notification) {
        self.greetingTextFieldChanged(obj: obj, charslength: 20)
        selectModel?.title = contentField.text
    }
    
    var sectionBlock: (() ->())?
    @objc func delectClick(){
        sectionBlock?()
    }
    
    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white)
        label.text = selectModel?.leftText
        return label
    }()
    
    lazy var contentField: SLQSTextField = {
        let contentField = UIUtil.sl_getTextField(UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0), placeholder: "请输入选项内容", placeholderColor: UIColor.sl_hexToAdecimalColor(hex: "#C4CDDA"), mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: kNightBCC6D4))
        return contentField
    }()
    
    lazy var delectButton: SLButton = {
        let button = SLButton.init()
        button.setImage(UIImage.init(named: "sl_solitaire_delect"), for: .normal)
        button.addTarget(self, action: #selector(delectClick), for: .touchUpInside)
        return button
    }()
}

