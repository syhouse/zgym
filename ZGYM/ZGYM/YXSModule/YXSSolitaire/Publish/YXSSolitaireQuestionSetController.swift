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
    
    var completeHandler: ((_ questionModel: YXSSolitaireQuestionModel) -> ())?
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let limitTextLength = 400
    
    let textMinHeight: CGFloat = 120
    
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
        contentView.addSubview(textBgView)
        
        textBgView.addSubview(textView)
        textBgView.addSubview(textCountlabel)
        
        let lineView = UIView()
        lineView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "F2F5F9"), night: kNightBackgroundColor)
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(10)
        }
        
        let lineView1 = UIView()
        lineView1.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "F2F5F9"), night: kNightBackgroundColor)
        contentView.addSubview(lineView1)
        
        isNecessarySwitch.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        textBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(isNecessarySwitch.snp_bottom).offset(10)
        }
        textView.snp.makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.right.equalTo(-15)
            make.height.equalTo(textMinHeight)
        }
        textCountlabel.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp_bottom).offset(5)
            make.height.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-21.5)
        }
        switch questionModel.type {
        case .single:
            self.title = "添加单选题"
            
            lineView1.snp.makeConstraints { (make) in
                make.top.equalTo(isNecessarySwitch.snp_bottom)
                make.left.right.equalTo(0)
                make.height.equalTo(10)
            }
            
            contentView.addSubview(questionNameLabel)
            questionNameLabel.snp.makeConstraints { (make) in
                make.top.equalTo(textBgView.snp_bottom).offset(19)
                make.left.equalTo(15)
            }
            contentView.addSubview(selectView)
            selectView.snp.makeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(questionNameLabel.snp_bottom).offset(13)
                make.bottom.equalTo(-40)
            }
            scrollView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "F2F5F9"), night: kNightBackgroundColor)
            contentView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "F2F5F9"), night: kNightBackgroundColor)
        case .gap:
            self.title = "添加填空题"
            
            lineView1.snp.makeConstraints { (make) in
                make.top.equalTo(isNecessarySwitch.snp_bottom)
                make.left.right.equalTo(0)
                make.height.equalTo(10)
            }
            
            textBgView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(isNecessarySwitch.snp_bottom).offset(10)
                make.bottom.equalTo(0).priorityHigh()
            }
            scrollView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
            contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        case .image:
            self.title = "添加图片题"
            contentView.addSubview(imageSelectSection)
            imageSelectSection.snp.makeConstraints { (make) in
                make.top.equalTo(isNecessarySwitch.snp_bottom)
                make.left.right.equalTo(0)
                make.height.equalTo(49)
            }
            lineView1.snp.makeConstraints { (make) in
                make.top.equalTo(imageSelectSection.snp_bottom)
                make.left.right.equalTo(0)
                make.height.equalTo(10)
            }
            
            textBgView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(imageSelectSection.snp_bottom).offset(10)
                make.bottom.equalTo(0).priorityHigh()
            }
            
            scrollView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
            contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
            
            self.questionItemCountSection.rightLabel.text = "\(questionModel.imageLimint)"
            self.questionItemCountSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        case .checkbox:
            self.title = "添加多选题"
            contentView.addSubview(questionItemCountSection)
            questionItemCountSection.snp.makeConstraints { (make) in
                make.top.equalTo(isNecessarySwitch.snp_bottom)
                make.left.right.equalTo(0)
                make.height.equalTo(49)
            }
            lineView1.snp.makeConstraints { (make) in
                make.top.equalTo(questionItemCountSection.snp_bottom)
                make.left.right.equalTo(0)
                make.height.equalTo(10)
            }
            
            contentView.addSubview(questionNameLabel)
            questionNameLabel.snp.makeConstraints { (make) in
                make.top.equalTo(textBgView.snp_bottom).offset(19)
                make.left.equalTo(15)
            }
            contentView.addSubview(selectView)
            selectView.snp.makeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(questionNameLabel.snp_bottom).offset(13)
                make.bottom.equalTo(-40)
            }
            scrollView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "F2F5F9"), night: kNightBackgroundColor)
            contentView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "F2F5F9"), night: kNightBackgroundColor)
            resetQuestionItemCount()
        }
        
    }
    
    func updateUI(){
        let size = textView.sizeThatFits(CGSize.init(width: SCREEN_WIDTH - 30, height: 3000))
        let textHeight = size.height + 20 > textMinHeight ? size.height + 20 : textMinHeight
        textView.snp.updateConstraints({ (make) in
            make.height.equalTo(textHeight)
        })
    }
    
    ///更新图片上线数
    func resetQuestionItemCount(){
        self.questionItemCountSection.rightLabel.text = "\(questionModel.maxSelect ?? (questionModel.solitaireSelects?.count ?? 1))"
        self.questionItemCountSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
    }
    
    /// 保存
    func save(){
        NSKeyedArchiver.archiveRootObject(questionModel, toFile: NSUtil.yxs_cachePath(file: "question_\(self.questionModel.type.rawValue)", directory: "archive"))
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
        completeHandler?(questionModel)
        self.navigationController?.popViewController()
    }
    
    @objc func questionItemCountClick(){
        let maxImageCount: Int = questionModel.solitaireSelects?.count ?? 1
        var dataSource = [YXSPunchCardDay]()
        
        let curruntIndex: Int = questionItemCountSection.rightLabel.text?.int ?? 1
        var selectModel: YXSPunchCardDay!
        
        for index in 1...maxImageCount{
            let model = YXSPunchCardDay.init("\(maxImageCount - index + 1)", index)
            dataSource.append(model)
            if index == curruntIndex{
                selectModel = model
            }
        }
        YXSPunchCardSelectDaysView.showAlert(selectModel,yxs_dataSource: dataSource,title: "最多可选择项数", compelect: {  [weak self] (modle, _) in
            guard let strongSelf = self else { return }
            strongSelf.questionModel.maxSelect = modle.text.int
            strongSelf.resetQuestionItemCount()
            
        })
    }
    
    // MARK: -tool
    func yxs_cheackCanSetUp() -> Bool{
        //主题不能为空
        if questionModel.type == .single || questionModel.type == .checkbox{
            if selectView.selectModels.first?.title?.isBlank ?? true {
                yxs_showAlert(title: "请添加选项内容")
                return false
            }
        }
        
        if textView.text.isEmpty{
            yxs_showAlert(title: "请输入题干")
            return false
        }
        return true
    }
    
    
    func yxs_remove(){
        try? FileManager.default.removeItem(atPath: NSUtil.yxs_cachePath(file: "question_\(self.questionModel.type.rawValue)", directory: "archive"))
    }
    
    // MARK: - getter&setter
    
    lazy var isNecessarySwitch: YXSPublishSwitchLabel = {
        let isNecessarySwitch = YXSPublishSwitchLabel()
        isNecessarySwitch.titleLabel.text = "必答"
        isNecessarySwitch.valueChangeBlock = {
            [weak self] (isOn) in
            guard let strongSelf = self else { return }
            strongSelf.questionModel.isNecessary = isOn
        }
        isNecessarySwitch.swt.snp.remakeConstraints { (make) in
            make.right.equalTo(-25)
            make.size.equalTo(CGSize.init(width: 43, height: 22))
            make.centerY.equalTo(isNecessarySwitch)
        }
        return isNecessarySwitch
    }()
    
    lazy var selectView: YXSQuestionPublishNewSelectItemsView = {
        let selectView = YXSQuestionPublishNewSelectItemsView(selectModels: questionModel.solitaireSelects)
        selectView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        selectView.updateItemsBlock = {
            [weak self] (selectModels) in
            guard let strongSelf = self else { return }
            strongSelf.questionModel.solitaireSelects = selectModels
            strongSelf.resetQuestionItemCount()
        }
        return selectView
    }()
    
    lazy var textBgView: UIView = {
        let textBgView = UIView()
        textBgView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        return textBgView
    }()
    
    lazy var imageSelectSection: SLTipsRightLabelSection = {
        let imageSelectSection = SLTipsRightLabelSection()
        imageSelectSection.leftlabel.text = "图片上传数量限制"
        //        imageSelectSection.addTarget(self, action: #selector(questionItemCountClick), for: .touchUpInside)
        imageSelectSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        imageSelectSection.rightLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(imageSelectSection)
        }
        imageSelectSection.arrowImage.isHidden = true
        return imageSelectSection
    }()
    
    lazy var questionItemCountSection: SLTipsRightLabelSection = {
        let imageSelectSection = SLTipsRightLabelSection()
        imageSelectSection.leftlabel.text = "最多可选择项数"
        imageSelectSection.addTarget(self, action: #selector(questionItemCountClick), for: .touchUpInside)
        imageSelectSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        imageSelectSection.arrowImage.snp.updateConstraints { (make) in
            make.right.equalTo(-17.5)
        }
        return imageSelectSection
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
            strongSelf.textCountlabel.text = "\(text.count)/\(strongSelf.limitTextLength)"
            strongSelf.questionModel.questionStemText = text
            strongSelf.updateUI()
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
    
    lazy var questionNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        label.text = "题目选项"
        return label
    }()
}


