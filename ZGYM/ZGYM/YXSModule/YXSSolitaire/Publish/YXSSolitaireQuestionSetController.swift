//
//  YXSSolitaireQuestionSetController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/28.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import NightNight

class YXSSolitaireQuestionSetController: YXSBaseViewController{
    
    /// 问题model
    var questionModel : YXSSolitaireQuestionModel
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let limitTextLength = 400

    init(_ questionModel: YXSSolitaireQuestionModel) {
        self.questionModel = questionModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var rightButton: YXSButton!
    // MARK: -leftCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_interactivePopDisabled = true
        
        
        rightButton = YXSButton(frame: CGRect(x: 0, y: 0, width: 58, height: 25))
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.setTitle("确定", for: .normal)
        rightButton.cornerRadius = 12.5
        rightButton.backgroundColor = kBlueColor
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightButton.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        rightButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        rightButton.widthAnchor.constraint(equalToConstant: 58).isActive = true
        let rightItem = UIBarButtonItem.init(customView: rightButton)
        navigationItem.rightBarButtonItem = rightItem
        
        
        let backButton = yxs_setNavLeftTitle(title: "取消")
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        backButton.setMixedTitleColor( MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4) , forState: .normal)
        
        
        scrollView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        
        initUI()
    }
    
    
    func initUI(){
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
        contentView.addSubview(isNecessarySwitch)
        contentView.addSubview(textView)
        contentView.addSubview(textCountlabel)
        
        isNecessarySwitch.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
                   textView.snp.makeConstraints { (make) in
                    make.left.right.equalTo(0)
            make.right.equalTo(-15)
            make.height.equalTo(120)
                    make.top.equalTo(isNecessarySwitch.snp_bottom).offset(10)
        }

        switch questionModel.type {
        case .single:
            textCountlabel.snp.makeConstraints { (make) in
                make.top.equalTo(textView.snp_bottom).offset(5)
                make.height.equalTo(20)
                make.right.equalTo(-20)
            }
            contentView.addSubview(questionNameLabel)
            questionNameLabel.snp.makeConstraints { (make) in
                make.top.equalTo(textCountlabel.snp_bottom).offset(19)
                make.left.equalTo(15)
            }
            contentView.addSubview(selectView)
            selectView.snp.makeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(questionNameLabel.snp_bottom).offset(13)
                make.bottom.equalTo(-40)
            }
        default:
            break
        }
        
        
        
        
    }
    
    /// 保存
    func save(){
        
    }
    
    // MARK: -action
    override func yxs_onBackClick() {
        self.view.endEditing(true)
        YXSCommonAlertView.showAlert(title: "提示", message: "您确定退出吗？", leftTitle: "直接退出", leftTitleColor: UIColor.yxs_hexToAdecimalColor(hex:"#797B7E"), leftClick: {
            [weak self] in
            guard let strongSelf = self else { return }
            try? FileManager.default.removeItem(atPath: NSUtil.yxs_cachePath(file: "question_\(strongSelf.questionModel.type.rawValue)", directory: "archive"))
            strongSelf.navigationController?.popViewController()
            }, rightTitle: "保存后退出", rightClick: {
                [weak self] in
                guard let strongSelf = self else { return }
                //do  save
                strongSelf.save()
                strongSelf.navigationController?.popViewController()
        })
    }
    
    @objc func rightClick(){
        self.view.endEditing(true)
        
        if !yxs_cheackCanSetUp(){
            return
        }
    }
    
    
    func yxs_remove(){
        try? FileManager.default.removeItem(atPath: NSUtil.yxs_cachePath(file: "question_\(self.questionModel.type.rawValue)", directory: "archive"))
    }
    
    
    // MARK: -tool
    func yxs_cheackCanSetUp() -> Bool{
        //主题不能为空
//        let publishText: String = publishModel.publishText?.removeSpace() ?? ""
//        if publishText.count == 0{
//            yxs_showAlert(title: "正文不能为空")
//            return false
//        }
//        if publishModel.classs == nil && (YXSPersonDataModel.sharePerson.personRole == .TEACHER || publishModel.isFriendCiclePublish){
//            yxs_showAlert(title: "接收班级不能为空")
//            return false
//        }
        return true
    }
    
    // MARK: - getter&setter
//    lazy var publishView: YXSCommonPublishView = {
//        let publishView = YXSCommonPublishView.init(publishModel: publishModel, audioMaxCount: audioMaxCount,type: self.publishType)
//        publishView.updateContentOffSet = {
//            [weak self](offsetY) in
//            guard let strongSelf = self else { return }
//            var offset = strongSelf.scrollView.contentOffset
//            offset.y += offsetY
//            strongSelf.scrollView.contentOffset = offset
//        }
//        return publishView
//    }()
    
    lazy var isNecessarySwitch: YXSPublishSwitchLabel = {
        let isNecessarySwitch = YXSPublishSwitchLabel()
        isNecessarySwitch.titleLabel.text = "必答"
        return isNecessarySwitch
    }()
    
    lazy var selectView: YXSQuestionPublishNewSelectItemsView = {
        let selectView = YXSQuestionPublishNewSelectItemsView(selectModels: questionModel.solitaireSelects)
        return selectView
    }()
    
    lazy var textView : YXSPlaceholderTextView = {
        let textView = YXSPlaceholderTextView()
        textView.limitCount = limitTextLength
        textView.font = kTextMainBodyFont
        textView.placeholderMixColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        let textColor = NightNight.theme == .night ? UIColor.white : kTextMainBodyColor
        textView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight20232F)
        textView.placeholder = "请输入题干"
        textView.contentInset = UIEdgeInsets.init(top: 20, left: 15, bottom: 0, right: 0)
        textView.textDidChangeBlock = {
            [weak self](text: String) in
            guard let strongSelf = self else { return }
//            strongSelf.textCountlabel.text = "\(text.count)/\(strongSelf.limitTextLength)"
//            strongSelf.publishModel.publishText = text
//            strongSelf.updateUI()
        }
        
        let paragraphStye = NSMutableParagraphStyle()
        //调整行间距
        paragraphStye.lineSpacing = 7
        paragraphStye.lineBreakMode = NSLineBreakMode.byWordWrapping
        textView.typingAttributes = [NSAttributedString.Key.paragraphStyle:paragraphStye,NSAttributedString.Key.font: kTextMainBodyFont, NSAttributedString.Key.foregroundColor: textColor]
        return textView
    }()
    
    private lazy var textCountlabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), night: kNightBCC6D4)
        label.text = "0/\(limitTextLength)"
        return label
    }()
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        label.text = "增加选项"
        return label
    }()
    
    lazy var questionNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        label.text = "题目选项"
        return label
    }()
}


class YXSQuestionPublishNewSelectItemsView: UIView{
    var selectModels: [SolitairePublishNewSelectModel]
    init(selectModels: [SolitairePublishNewSelectModel]?) {
        if let  selectModels = selectModels {
            self.selectModels = selectModels
        }else{
            let model = SolitairePublishNewSelectModel()
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
        let model = SolitairePublishNewSelectModel()
        model.index = self.selectModels.count
        self.selectModels.append(model)
        updateUI(true)
    }
    
    func updateUI(_ becomeFirst: Bool = false){
        removeSubviews()
        let showMore:Bool = self.selectModels.count < 4
        var last: UIView!
        for (index, model) in self.selectModels.enumerated(){
            let section = YXSQuestionPublishItem.init(selectModel: model, showDelect: (index != 0 && index == self.selectModels.count - 1))
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
            let button = YXSButton.init()
            button.setTitleColor(kBlueColor, for: .normal)
            button.setTitle("增加选项", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            button.setImage(UIImage.init(named: "yxs_solitaire_add"), for: .normal)
            button.addTarget(self, action: #selector(showMoreClick), for: .touchUpInside)
            button.yxs_setIconInLeftWithSpacing(5)
            addSubview(button)
            button.snp.makeConstraints { (make) in
                make.height.equalTo(49)
                make.top.equalTo(last.snp_bottom)
                make.left.right.bottom.equalTo(0)
            }
        }
    }
}


class YXSQuestionPublishItem: UIView{
    var selectModel: SolitairePublishNewSelectModel?
    var showDelect: Bool
    init(selectModel: SolitairePublishNewSelectModel?, showDelect: Bool) {
        self.selectModel = selectModel
        self.showDelect = showDelect
        super.init(frame: CGRect.zero)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        addSubview(leftLabel)
        addSubview(contentField)
        contentField.text = selectModel?.title
        yxs_addLine(position: .bottom, leftMargin: 15.5, rightMargin: 0.5, lineHeight: 0.5)
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
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white)
        label.text = selectModel?.leftText
        return label
    }()
    
    lazy var contentField: YXSQSTextField = {
        let contentField = UIUtil.yxs_getTextField(UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0), placeholder: "请输入选项内容", placeholderColor: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: kNightBCC6D4))
        return contentField
    }()
    
    lazy var delectButton: YXSButton = {
        let button = YXSButton.init()
        button.setImage(UIImage.init(named: "yxs_solitaire_delect"), for: .normal)
        button.addTarget(self, action: #selector(delectClick), for: .touchUpInside)
        return button
    }()
}


class SolitairePublishNewSelectModel: NSObject, NSCoding{
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
