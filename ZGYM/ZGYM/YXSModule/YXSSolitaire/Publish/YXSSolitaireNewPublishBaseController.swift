//
//  YXSSolitaireNewPublishBaseController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/27.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import NightNight
import IQKeyboardManager


class YXSSolitaireNewPublishBaseController: YXSCommonPublishBaseController {
    // MARK: -leftCycle
    
    var classId: Int? {
        return publishModel.classs?.first?.id
    }
    ///接龙模版model
    var solitaireTemplateModel: YXSSolitaireTemplateDetialModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.publishType = .solitaire
        
        initTouchView()
        if classId != nil{
            loadClassCountData()
        }
        
        scrollView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)

        subjectField.text = publishModel.subjectText
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.greetingTextFieldChanged),
                                               name:NSNotification.Name(rawValue:"UITextFieldTextDidChangeNotification"),
                                               object: self.subjectField)
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
    
    // MARK: - override
    override func initPublish() {
        if let solitaireTemplateModel = solitaireTemplateModel{
            publishModel.publishContent = solitaireTemplateModel.content
            publishModel.subjectText = solitaireTemplateModel.title
            publishModel.solitaireDate = Date().addingTimeInterval(7*24*60*60)
            if let holders = solitaireTemplateModel.gatherHoldersModel?.gatherHolders{
                var solitaireQuestions = [YXSSolitaireQuestionModel]()
                for holder in holders{
                    let questionModel = YXSSolitaireQuestionModel(questionType: holder.questionType)
                    questionModel.questionStemText = holder.gatherHolderItem?.topicTitle
                    questionModel.isNecessary = holder.gatherHolderItem?.isRequired ?? false
                    if let optionItems = holder.gatherHolderItem?.censusTopicOptionItems{
                        var optionModels = [SolitairePublishNewSelectModel]()
                        for (index, optionItem) in optionItems.enumerated(){
                            let solitaireselectModel = SolitairePublishNewSelectModel()
                            solitaireselectModel.index = index
                            solitaireselectModel.title = optionItem.optionContext
                            let mediaModel = SLPublishMediaModel()
                            mediaModel.serviceUrl = optionItem.optionImage
                            solitaireselectModel.mediaModel = mediaModel
                            optionModels.append(solitaireselectModel)
                        }
                        questionModel.solitaireSelects = optionModels
                    }
                    solitaireQuestions.append(questionModel)
                }
                publishModel.solitaireQuestions = solitaireQuestions
            }
        }else{
            if let publishModel = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_cachePath(file: fileName, directory: "archive")) as? YXSPublishModel{
                self.publishModel = publishModel
            }else{
                initEmptyModel()
                publishModel.solitaireDate = Date().addingTimeInterval(7*24*60*60)
            }
        }
    }
    
    override func save(){
        publishModel.subjectText = subjectField.text
        NSKeyedArchiver.archiveRootObject(publishModel, toFile: NSUtil.yxs_cachePath(file: fileName, directory: "archive"))
    }
    
    override func yxs_onBackClick() {
        toolWindow?.hideTool()
        super.yxs_onBackClick()
    }
    
    override func yxs_cheackCanSetUp() -> Bool {
        toolWindow?.hideTool()
        
        if publishModel.solitaireDate == nil {
            yxs_showAlert(title: "请选择截止日期")
            return false
        }
        if self.publishModel.commitUpperLimit == nil{
            yxs_showAlert(title: "请选择最高接龙人数")
            return false
        }
        return super.yxs_cheackCanSetUp()
    }
    
    
    // MARK: -UI
    func initTouchView(){
        view.addSubview(touchView)
        touchView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    // MARK: -loadData
    override func yxs_loadClassDataSucess(){
        loadClassCountData()
    }
    /// 请求班级人数
    override func loadClassCountData(){
        YXSEducationGradeFindNumberOfStudentsRequest.init(gradeId: classId ?? 0).request({ (result) in
            self.publishModel.totalCommitUpperLimit = result.intValue
            self.publishModel.commitUpperLimit = result.intValue
        }) { (msg, code) in
        }
    }
    
    // MARK: -action
    @objc func greetingTextFieldChanged(obj:Notification) {
        self.greetingTextFieldChanged(obj: obj, length : 20)
    }
    
    
    // MARK: - private
    var toolWindow: YXSSolitaireToolWindow?
    func showSettingTool(){
        toolWindow = YXSSolitaireToolWindow.showToolWindow(publishModel: publishModel, inView: touchView)
    }
    
    ///工具栏是否正在试图上
    func isToolWindowOnView() -> Bool{
        if let toolWindow = toolWindow, toolWindow.superview != nil{
            return true
        }
        return false
    }
    
    func publishSucessPop(){
        var isPop = false
        
        self.navigationController?.yxs_existViewController(existClass: YXSSolitaireListController.self, complete: { (listVc) in
            self.navigationController?.popToViewController(listVc, animated: true)
            isPop = true
        })
        if !isPop{
            self.navigationController?.yxs_existViewController(existClass: YXSClassDetialListController.self, complete: { (detialVc) in
                self.navigationController?.popToViewController(detialVc, animated: true)
                isPop = true
            })
        }
        
        if !isPop{
            self.navigationController?.yxs_existViewController(existClass: YXSHomeController.self, complete: { (homeVc) in
                self.navigationController?.popToViewController(homeVc, animated: true)
                isPop = true
            })
        }
        
        if !isPop{
            self.navigationController?.popViewController()
        }
        
    }
    
    // MARK: - getter&setter
    
    lazy var footerSettingView: YXSSolitaireSettingBar = {
        let footerSettingView = YXSSolitaireSettingBar()
        footerSettingView.settingClickBlock = {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showSettingTool()
        }
        return footerSettingView
    }()

    lazy var subjectField: YXSQSTextField = {
        let classField = UIUtil.yxs_getTextField(UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0), placeholder: "输入接龙标题 （20字以内）", placeholderColor: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: UIColor.white))
        classField.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        classField.yxs_addLine(position: .bottom, color: kLineColor, leftMargin: 15, lineHeight: 0.5)
        return classField
    }()
    
    lazy var touchView: YXSTouchView = {
        let touchView = YXSTouchView()
        touchView.touchPoint = {
            [weak self] (point: CGPoint)in
            guard let strongSelf = self else { return }
            
            ///当前工具栏是否出现
            if strongSelf.isToolWindowOnView(){
                //点击位置不在工具栏上 隐藏工具栏
                if !(strongSelf.toolWindow?.frame.contains(point) ?? false){
                    strongSelf.toolWindow?.hideTool()
                }
            }
        }
        return touchView
    }()
}


class YXSTouchView: UIView {
    var touchPoint: ((_ point: CGPoint)->())?
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        SLLog("point = \(point)")
        touchPoint?(point)
        return super.point(inside: point, with: event)
    }
}

