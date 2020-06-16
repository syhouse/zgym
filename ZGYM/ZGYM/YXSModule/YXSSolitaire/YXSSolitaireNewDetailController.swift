//
//  YXSSolitaireNewDetailController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/2.
//  Copyright © 2020 zgym. All rights reserved.
//
import UIKit
import NightNight
import ObjectMapper
import SwiftyJSON
import IQKeyboardManager


private let placeholderReplaceKey = "YXSSolitaireNewDetailController___XYSPlaceholderReplaceKey__"

class YXSSolitaireUploadPlaceholderModel: NSObject{
    var questionIndex: Int
    var selectIndex: Int
    var media: YXSMediaModel
    var uploadUrl: String?
    init(questionIndex: Int, selectIndex: Int, media: YXSMediaModel){
        self.questionIndex = questionIndex
        self.selectIndex = selectIndex
        self.media = media
        super.init()
    }
}

class YXSSolitaireNewDetailController: YXSBaseTableViewController {
    // MARK: - property
    var headerSelectedIndex: Int = 0
    var censusId: Int?
    var classId: Int?
    var childrenId: Int?
    var serviceCreateTime: String?
    var header: YXSSolitaireNewDetailHeaderView?
    
    var sectionDataRequestSucess: Bool = false
    
    ///采集题目model
    var solitaireGatherHoldersModel: YXSSolitaireGatherHoldersModel?
    ///采集题目数组
    var solitaireCollectorItems = [YXSSolitaireQuestionModel]()
    ///家长采集题目提交数组
    var censusCommitGatherResponseList = [YXSSolitaireAnswerHolderItemModel]()
    ///家长当前提交的id
    var censusCommitId: Int?
    ///家长是否可以编辑 重新提交
    var canEdit: Bool{
        return (detailModel?.state == 100) ? false : true
    }
    
    var detailModel: YXSSolitaireDetailModel? {
        didSet {
            tableView.reloadData()
            updateBottomView()
        }
    }
    
    var curruntIndex: IndexPath?
    
    var curruntContentOffset: CGPoint?
    
    ///家长选择选项列表
    var partakeResponseLists = [[YXSClassMemberModel](), [YXSClassMemberModel]()]
    
    ///标记图片题目
    var placeholderUrls = [YXSSolitaireUploadPlaceholderModel]()
    
    // MARK: - leftCycle
    init(censusId: Int = 0, childrenId: Int = 0, classId: Int, serviceCreateTime: String = "") {
        super.init()
        self.censusId = censusId
        self.childrenId = childrenId
        self.classId = classId
        self.serviceCreateTime = serviceCreateTime
        UIUtil.yxs_reduceHomeRed(serviceId: censusId, childId: childrenId )
        
        self.hasRefreshHeader = false
        self.showBegainRefresh = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        YXSSSAudioPlayer.sharedInstance.stopVoice()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "接龙详情"
        
        initUI()
        
        self.tableView.register(YXSSolitaireNewDetailHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "YXSSolitaireNewDetailHeaderView")
        self.tableView.register(YXSHomeworkReadListSectionHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: "YXSHomeworkReadListSectionHeader")
        self.tableView.register(YXSSolitaireCollectorSectionHeader.self, forHeaderFooterViewReuseIdentifier: "YXSSolitaireCollectorSectionHeader")
        
        self.tableView.register(YXSDetailNormalRecallCell.classForCoder(), forCellReuseIdentifier: "YXSDetailNormalRecallCell")
        self.tableView.register(YXSDetailSubTitleBottomCell.classForCoder(), forCellReuseIdentifier: "YXSDetailSubTitleBottomCell")
        
        //家长采集cell
        self.tableView.register(YXSSolitaireCollectorPartentDetialSelectItemsCell.self, forCellReuseIdentifier: "YXSSolitaireCollectorPartentDetialSelectItemsCell")
        self.tableView.register(YXSSolitaireCollectorPartentDetialTextCell.self, forCellReuseIdentifier: "YXSSolitaireCollectorPartentDetialTextCell")
        self.tableView.register(YXSSolitaireCollectorPartentDetialImageCell.self, forCellReuseIdentifier: "YXSSolitaireCollectorPartentDetialImageCell")
        
        //老师采集cell
        self.tableView.register(YXSSolitaireCollectorTeacherDetialNoSelectCell.self, forCellReuseIdentifier: "YXSSolitaireCollectorTeacherDetialNoSelectCell")
        self.tableView.register(YXSSolitaireCollectorTeacherDetiaSelectItemsCell.self, forCellReuseIdentifier: "YXSSolitaireCollectorTeacherDetiaSelectItemsCell")
        
        //加载缓存数据
        self.detailModel = YXSCacheHelper.yxs_getCacheSolitaireDetailTask(censusId: censusId ?? 0, childrenId: childrenId ?? 0)
        
        if detailModel != nil{
            sectionDataRequestSucess = true
        }
        
        if detailModel?.type == 2{
            self.partakeResponseLists = YXSCacheHelper.yxs_getCacheSolitaireResponseList(censusId: censusId ?? 0)
        }else{
            self.solitaireCollectorItems = YXSCacheHelper.yxs_getCacheSolitaireCollectorItems(censusId: censusId ?? 0, childrenId: childrenId ?? 0)
        }
        yxs_refreshData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_ :)),name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_ :)),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func yxs_refreshData() {
        MBProgressHUD.yxs_showLoading(ignore: true)
        YXSEducationCensusCensusDetailRequest(censusId: censusId ?? 0, childrenId: childrenId ?? 0).request({ [weak self](model: YXSSolitaireDetailModel) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            weakSelf.detailModel = model
            YXSCacheHelper.yxs_cacheSolitaireDetailTask(model: model, censusId: weakSelf.censusId ?? 0, childrenId: weakSelf.childrenId ?? 0)
            
            ///设置已读
            if !(model.read ?? false){
                if let model = YXSHomeListModel.init(JSON: ["childrenId": weakSelf.childrenId ?? 0, "serviceId": weakSelf.censusId ?? 0, "serviceType" : 3]){
                    UIUtil.yxs_loadReadData(model)
                }
            }
            
            
            MBProgressHUD.yxs_showLoading(ignore: true)
            
            if model.type == 2{
                YXSEducationCensusPartakeOrNoPartakeRequest(censusId: weakSelf.censusId ?? 0).request({ [weak self](json) in
                    guard let strongSelf = self else {return}
                    MBProgressHUD.yxs_hideHUD()
                    strongSelf.sectionDataRequestSucess = true
                    strongSelf.partakeResponseLists[0] = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["censusPartakeResponseList"].rawString()!) ?? [YXSClassMemberModel]()
                    strongSelf.partakeResponseLists[1] = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["censusNoPartakeResponseList"].rawString()!) ?? [YXSClassMemberModel]()
                    YXSCacheHelper.yxs_cacheSolitaireResponseList(dataSource: strongSelf.partakeResponseLists , censusId: weakSelf.censusId ?? 0)
                    strongSelf.checkEmptyData()
                    strongSelf.tableView.reloadData()
                }) { (msg, code) in
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
            }else if model.type == 3{
                if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                    YXSEducationCensusTeacherGatherDetailRequest(censusId: weakSelf.censusId ?? 0).request({ [weak self](detialModel: YXSSolitaireGatherHoldersModel) in
                        guard let strongSelf = self else {return}
                        MBProgressHUD.yxs_hideHUD()
                        strongSelf.sectionDataRequestSucess = true
                        strongSelf.solitaireGatherHoldersModel = detialModel
                        
                        strongSelf.configTeacherCollectorData()
                        strongSelf.tableView.reloadData()
                        
                    }) { (msg, code) in
                        MBProgressHUD.yxs_showMessage(message: msg)
                    }
                }else{
                    YXSEducationCensusParentGatherDetailRequest(censusId: weakSelf.censusId ?? 0, childrenId: weakSelf.childrenId ?? 0).request({ [weak self](json) in
                        guard let strongSelf = self else {return}
                        MBProgressHUD.yxs_hideHUD()
                        strongSelf.sectionDataRequestSucess = true
                        strongSelf.solitaireGatherHoldersModel = Mapper<YXSSolitaireGatherHoldersModel>().map(JSONString: json["censusGatherJsonData"].rawString()!)
                        
                        strongSelf.censusCommitGatherResponseList = Mapper<YXSSolitaireAnswerHolderItemModel>().mapArray(JSONString: json["censusCommitGatherResponseList"].rawString()!) ?? [YXSSolitaireAnswerHolderItemModel]()
                        strongSelf.configPartentCollectorData()
                        strongSelf.tableView.reloadData()
                        
                    }) { (msg, code) in
                        MBProgressHUD.yxs_showMessage(message: msg)
                    }
                }
            }
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Action
    @objc func yxs_solitaireClick(sender: YXSButton) {
        if detailModel?.type == 2{
            setupApply()
        }else if detailModel?.type == 3{
            setupCollector()
        }
    }
    
    @objc func yxs_shareClick(sender: YXSButton) {
        let model = HMRequestShareModel(censusId: censusId ?? 0)
        MBProgressHUD.yxs_showLoading()
        YXSEducationShareLinkRequest(model: model).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            let strUrl = json.stringValue
            let title = "\(weakSelf.detailModel?.teacherName ?? "")布置的接龙!"
            let dsc = "\(weakSelf.detailModel?.title ?? "")"
            let shareModel = YXSShareModel(title: title, descriptionText: dsc, link: strUrl)
            YXSShareTool.showCommonShare(shareModel: shareModel)
        }) { (msg, code ) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    @objc func yxs_callUpClick(sender:YXSButton) {
        let model = partakeResponseLists[headerSelectedIndex][sender.tag]
        UIUtil.yxs_callPhoneNumberRequest(childrenId: model.childrenId ?? 0, classId: detailModel?.classId ?? 0)
    }
    
    @objc func yxs_chatClick(sender:YXSButton) {
        let model = partakeResponseLists[headerSelectedIndex][sender.tag]
        UIUtil.yxs_chatImRequest(childrenId: model.childrenId ?? 0, classId: detailModel?.classId ?? 0)
    }
    
    @objc func recallClick(){
        YXSCommonAlertView.showAlert(title: "请确认", message: "您是否取消接龙？", rightClick: {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.recallRequest()
        })
    }
    
    // MARK: - getter
    lazy var bottomBtnView: YXSBottomBtnView = {
        let view = YXSBottomBtnView()
        view.isHidden = true
        view.btnCommit.setTitle("我来接龙", for: .normal)
        view.btnCommit.addTarget(self, action: #selector(yxs_solitaireClick(sender:)), for: .touchUpInside)
        return view
    }()
    
    // MARK: - tableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionDataRequestSucess ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            if detailModel?.type == 2{
                return partakeResponseLists[headerSelectedIndex].count
            }else{
                return solitaireCollectorItems.count
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if detailModel?.type == 2{
            let cModel = partakeResponseLists[headerSelectedIndex][indexPath.row]
            return getApplyCell(indexPath: indexPath, cModel: cModel)
            
        }else{
            let model = solitaireCollectorItems[indexPath.row]
            var identifier = ""
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                switch model.type {
                case .single, .checkbox:
                    identifier = "YXSSolitaireCollectorTeacherDetiaSelectItemsCell"
                case .image, .gap:
                    identifier = "YXSSolitaireCollectorTeacherDetialNoSelectCell"
                }
                let cell: YXSSolitaireCollectorTeacherDetialBaseCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! YXSSolitaireCollectorTeacherDetialBaseCell
                cell.setCellModel(model, index: indexPath.row)
                //                cell.refreshCell = {
                //                    [weak self] in
                //                    guard let strongSelf = self else { return }
                //                    strongSelf.yxs_reloadTableView(indexPath)
                //                }
                //
                cell.lookDetialBlock = {
                    [weak self] (gatherTopicId,selectModel) in
                    guard let strongSelf = self else { return }
                    let vc = YXSSolitaireCollectorSetupDetailController(censusId: strongSelf.censusId ?? 0, gatherId: strongSelf.solitaireGatherHoldersModel?.gatherId ?? 0, gatherTopicId: gatherTopicId, option: selectModel?.leftText, type: model.type, classId: strongSelf.classId ?? 0)
                    switch model.type {
                    case .single, .checkbox:
                        vc.title = "选项\(selectModel?.leftText ?? "")成员（\(selectModel?.gatherTopicCount ?? 0)人）"
                    case .gap:
                        vc.title = "填空题详情（\(model.gatherTopicCount ?? 0)人）"
                    case .image:
                        vc.title = "图片题详情（\(model.gatherTopicCount ?? 0)人）"
                    }
                    strongSelf.navigationController?.pushViewController(vc)
                }
                return cell
            }
            else{
                let model = solitaireCollectorItems[indexPath.row]
                switch model.type {
                case .single, .checkbox:
                    identifier = "YXSSolitaireCollectorPartentDetialSelectItemsCell"
                case .image:
                    identifier = "YXSSolitaireCollectorPartentDetialImageCell"
                case .gap:
                    identifier = "YXSSolitaireCollectorPartentDetialTextCell"
                }
                let cell: YXSSolitaireCollectorPartentDetialBaseCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! YXSSolitaireCollectorPartentDetialBaseCell
                cell.canEdit = canEdit
                cell.setCellModel(model, index: indexPath.row)
                cell.refreshCell = {
                    [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.yxs_reloadTableView(indexPath)
                }
                
                cell.changeMedias = {
                    [weak self] (meidas) in
                    guard let strongSelf = self else { return }
                    model.answerMedias = meidas
                    strongSelf.yxs_reloadTableView(indexPath)
                }
                cell.textViewBeginEdit = {
                    [weak self]  in
                    guard let strongSelf = self else { return }
                    strongSelf.curruntIndex = indexPath
                }
                
                return cell
            }
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YXSSolitaireNewDetailHeaderView") as? YXSSolitaireNewDetailHeaderView
            header?.setHeaderViewModel(detailModel: detailModel)
            header?.videoTouchedBlock = { [weak self](url) in
                guard let weakSelf = self else {return}
                let vc = SLVideoPlayController()
                vc.videoUrl = url
                weakSelf.navigationController?.pushViewController(vc)
            }
            header?.pushToContainerBlock = { [weak self] in
                guard let weakSelf = self else {return}
                let vc = YXSSolitaireContainerController()
                vc.detailModel = weakSelf.detailModel
                //                vc.backClickBlock = { [weak self]()in
                //                    guard let weakSelf = self else {return}
                //                    weakSelf.ref
                //                }
                weakSelf.navigationController?.pushViewController(vc)
            }
            
            return header
            
        } else {
            if detailModel?.type == 2{
                let header: YXSHomeworkReadListSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YXSHomeworkReadListSectionHeader") as! YXSHomeworkReadListSectionHeader
                
                header.btnTitle1.setTitle("参加\(partakeResponseLists[0].count)人", for: .normal)
                header.btnTitle2.setTitle("不参加\(partakeResponseLists[1].count)人", for: .normal)
                header.btnAlert.isHidden = true
                
                header.selectedIndex = headerSelectedIndex
                
                header.selectedBlock = {[weak self](index) in
                    guard let weakSelf = self else {return}
                    weakSelf.headerSelectedIndex = index
                    weakSelf.tableView.reloadData()
                    weakSelf.checkEmptyData()
                }
                
                return header
            }else{
                let header: YXSSolitaireCollectorSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YXSSolitaireCollectorSectionHeader") as! YXSSolitaireCollectorSectionHeader
                return header
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if detailModel?.type == 2{
            let cModel = partakeResponseLists[headerSelectedIndex][indexPath.row]
            let remark = (cModel.remark ?? "")
            let remarkHeight: CGFloat =  UIUtil.yxs_getTextHeigh(textStr: remark, font: UIFont.systemFont(ofSize: 14), width: SCREEN_WIDTH - 15 - 15) + 13.5
            return 17.5 + 41  + 16 + (remark.isEmpty ? 0 : remarkHeight)
        }else{
            let model = solitaireCollectorItems[indexPath.row]
            return model.getCellDetialHeight(index: indexPath.row)
        }
    }
    
    
}

// MARK: - config data
extension YXSSolitaireNewDetailController{
    func configPartentCollectorData(){
        if let solitaireGatherHoldersModel = solitaireGatherHoldersModel{
            if let holders = solitaireGatherHoldersModel.gatherHolders{
                var solitaireQuestions = [YXSSolitaireQuestionModel]()
                for holder in holders{
                    ///把服务器返回的题目model 转换为YXSSolitaireQuestionModel 并给值
                    let questionModel = YXSSolitaireQuestionModel(questionType: holder.questionType)
                    questionModel.questionStemText = holder.gatherHolderItem?.topicTitle
                    questionModel.isNecessary = holder.gatherHolderItem?.isRequired ?? false
                    questionModel.gatherTopicId = holder.gatherHolderItem?.gatherTopicId
                    if let optionItems = holder.gatherHolderItem?.censusTopicOptionItems{
                        var optionModels = [SolitairePublishNewSelectModel]()
                        for (index, optionItem) in optionItems.enumerated(){
                            let solitaireselectModel = SolitairePublishNewSelectModel()
                            solitaireselectModel.index = index
                            solitaireselectModel.title = optionItem.optionContext
                            if !(optionItem.optionImage ?? "").isEmpty{
                                let mediaModel = SLPublishMediaModel()
                                mediaModel.serviceUrl = optionItem.optionImage
                                solitaireselectModel.mediaModel = mediaModel
                            }
                            optionModels.append(solitaireselectModel)
                        }
                        questionModel.solitaireSelects = optionModels
                    }
                    
                    ///把提交的回答 塞进展示的题目列表中
                    if detailModel?.state == 20{
                        for answer in censusCommitGatherResponseList{
                            if answer.gatherTopicId == questionModel.gatherTopicId{
                                
                                switch questionModel.type {
                                case .gap:
                                    questionModel.answerContent = answer.option
                                case .image:
                                    let imgUrls = (answer.option ?? "").components(separatedBy: ",")
                                    for imgurl in imgUrls{
                                        if !imgurl.isEmpty{
                                            let meidaModel = SLPublishEditMediaModel(isAddItem: false)
                                            meidaModel.serviceUrl = imgurl
                                            questionModel.answerMedias.append(meidaModel)
                                        }
                                    }
                                case .checkbox, .single:
                                    let selectOptions = (answer.option ?? "").components(separatedBy: ",")
                                    if let solitaireSelects = questionModel.solitaireSelects{
                                        for solitaireSelect in solitaireSelects{
                                            for selectOption in selectOptions{
                                                if solitaireSelect.leftText == selectOption{
                                                    solitaireSelect.isSelected = true
                                                    break	
                                                }
                                            }
                                        }
                                    }
                                    break
                                }
                            }
                        }
                    }
                    
                    ///是否需要初始化图片题目添加按钮
                    if questionModel.type == .image && (detailModel?.state == 10 || questionModel.answerMedias.count < 9){
                        questionModel.answerMedias.append(SLPublishEditMediaModel(isAddItem: true))
                    }
                    
                    solitaireQuestions.append(questionModel)
                }
                solitaireCollectorItems = solitaireQuestions
                
                YXSCacheHelper.yxs_cacheSolitaireCollectorItems(dataSource: solitaireCollectorItems, censusId: censusId ?? 0, childrenId: childrenId ?? 0)
            }
        }
        
    }
    
    func configTeacherCollectorData(){
        if let solitaireGatherHoldersModel = solitaireGatherHoldersModel{
            if let holders = solitaireGatherHoldersModel.gatherHolders{
                var solitaireQuestions = [YXSSolitaireQuestionModel]()
                for holder in holders{
                    ///把服务器返回的题目model 转换为YXSSolitaireQuestionModel 并给值
                    let questionModel = YXSSolitaireQuestionModel(questionType: holder.questionType)
                    questionModel.questionStemText = holder.gatherHolderItem?.topicTitle
                    questionModel.isNecessary = holder.gatherHolderItem?.isRequired ?? false
                    questionModel.gatherTopicId = holder.gatherHolderItem?.gatherTopicId
                    questionModel.gatherTopicCount = holder.gatherHolderItem?.gatherTopicCount
                    questionModel.ratio = holder.gatherHolderItem?.ratio
                    if let optionItems = holder.gatherHolderItem?.censusTopicOptionItems{
                        var optionModels = [SolitairePublishNewSelectModel]()
                        for (index, optionItem) in optionItems.enumerated(){
                            let solitaireselectModel = SolitairePublishNewSelectModel()
                            solitaireselectModel.index = index
                            solitaireselectModel.title = optionItem.optionContext
                            solitaireselectModel.gatherTopicCount = optionItem.gatherTopicCount
                            solitaireselectModel.ratio = optionItem.ratio
                            if !(optionItem.optionImage ?? "").isEmpty{
                                let mediaModel = SLPublishMediaModel()
                                mediaModel.serviceUrl = optionItem.optionImage
                                solitaireselectModel.mediaModel = mediaModel
                            }
                            optionModels.append(solitaireselectModel)
                        }
                        questionModel.solitaireSelects = optionModels
                    }
                    solitaireQuestions.append(questionModel)
                }
                solitaireCollectorItems = solitaireQuestions
                
                YXSCacheHelper.yxs_cacheSolitaireCollectorItems(dataSource: solitaireCollectorItems, censusId: censusId ?? 0, childrenId: childrenId ?? 0)
            }
            
        }
        
    }
}

// MARK: - tool
extension YXSSolitaireNewDetailController{
    @objc func checkEmptyData() {
        let list: [YXSClassMemberModel] = partakeResponseLists[headerSelectedIndex]
        if list.count == 0 {
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
            let imageView = UIImageView()
            imageView.mixedImage = MixedImage(normal: "yxs_defultImage_nodata", night: "yxs_defultImage_nodata_night")
            imageView.contentMode = .scaleAspectFit
            footer.addSubview(imageView)
            imageView.snp.makeConstraints({ (make) in
                make.edges.equalTo(0)
            })
            tableView.tableFooterView = footer
            
        } else {
            tableView.tableFooterView = nil
        }
    }
    
    ///检查是否可以提交采集  可以提交会返回提交参数
    func cheakCanSetup() -> Bool{
        var isTotalEmpty = true
        for (itemIndex, collectorItem) in solitaireCollectorItems.enumerated(){
            var option: String = ""
            switch collectorItem.type {
            case .image:
                var imgurls = [String]()
                for (answerIndex, model) in collectorItem.answerMedias.enumerated(){
                    if model.isAddItem{
                        continue
                    }
                    
                    if let serviceUrl = model.serviceUrl{
                        imgurls.append(serviceUrl)
                    }else{
                        imgurls.append("hasurl")
                        let uploadPlaceModel = YXSSolitaireUploadPlaceholderModel(questionIndex: itemIndex, selectIndex: answerIndex, media: model)
                        placeholderUrls.append(uploadPlaceModel)
                    }
                }
                option = imgurls.joined(separator: ",")
            case .gap:
                option = collectorItem.answerContent ?? ""
            case .single, .checkbox:
                var selectOptions = [String]()
                if let solitaireSelects = collectorItem.solitaireSelects{
                    for solitaireSelect in solitaireSelects{
                        if solitaireSelect.isSelected{
                            selectOptions.append(solitaireSelect.leftText ?? "")
                        }
                    }
                }
                option = selectOptions.joined(separator: ",")
            }
            if !option.isEmpty{
                isTotalEmpty = false
                
            }
            if collectorItem.isNecessary && option.isEmpty{
                MBProgressHUD.yxs_showMessage(message: "第\(itemIndex + 1)为必答题")
                return false
            }
        }
        
        if isTotalEmpty{
            yxs_showAlert(title: "您尚未填写任何内容")
            return false
        }
        
        return true
    }
    
    func getSetupLists() -> [[String: Any]]{
        var urls = placeholderUrls
        var setupLists = [[String: Any]]()
        for (itemIndex, collectorItem) in solitaireCollectorItems.enumerated(){
            var setupItem = [String: Any]()
            
            setupItem["gatherTopicId"] = collectorItem.gatherTopicId ?? 0
            var option: String = ""
            switch collectorItem.type {
            case .image:
                var imgurls = [String]()
                for (index, model) in collectorItem.answerMedias.enumerated(){
                    if model.isAddItem{
                        continue
                    }
                    
                    if let serviceUrl = model.serviceUrl{
                        imgurls.append(serviceUrl)
                    }else{
                        for (urlIndex, url) in urls.enumerated(){
                            if url.questionIndex == itemIndex && url.selectIndex == index{
                                imgurls.append(url.uploadUrl ?? "")
                                urls.remove(at: urlIndex)
                                break
                            }
                        }
                    }
                }
                option = imgurls.joined(separator: ",")
            case .gap:
                option = collectorItem.answerContent ?? ""
            case .single, .checkbox:
                var selectOptions = [String]()
                if let solitaireSelects = collectorItem.solitaireSelects{
                    for solitaireSelect in solitaireSelects{
                        if solitaireSelect.isSelected{
                            selectOptions.append(solitaireSelect.leftText ?? "")
                        }
                    }
                }
                option = selectOptions.joined(separator: ",")
            }
            setupItem["option"] = option
            setupLists.append(setupItem)
        }
        SLLog(setupLists)
        self.placeholderUrls.removeAll()
        return setupLists
    }
    
    func setupApply(){
        var optionLists = [YXSSelectModel]()
        if let optionList = detailModel?.optionList{
            for item in optionList{
                optionLists.append(YXSSelectModel.init(text: item))
            }
            
        }
        YXSSolitaireSelectApplyView(items: optionLists, inTarget: self.view) {  [weak self] (view, index, remark) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_showLoading()
            
            var request: YXSBaseRequset!
            var message = ""
            request = YXSEducationCensusParentCommitRequest(censusId: weakSelf.censusId ?? 0, childrenId: weakSelf.childrenId ?? 0, option: weakSelf.detailModel?.optionList?[index] ?? "", remark: remark)
            message = "接龙成功"
            
            request.request({ (json) in
                MBProgressHUD.yxs_hideHUD()
                MBProgressHUD.yxs_showMessage(message: message)
                weakSelf.joinSucessDeal()
                
                weakSelf.yxs_refreshData()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.01) {
                    view.cancelClick()
                }
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        
    }
    
    func setupCollector(){
        if !cheakCanSetup(){
            return
        }
        
        var localMedias = [SLUploadSourceModel]()
        for placeholderUrl in placeholderUrls{
            localMedias.append(SLUploadSourceModel.init(model: placeholderUrl.media, type: .image, storageType: .temporary, fileName: placeholderUrl.media.fileName))
            SLLog(placeholderUrl.media.fileName)
            
        }
        //有本地资源上传
        if localMedias.count != 0 {
            MBProgressHUD.yxs_showUpload(inView: self.navigationController!.view)
            YXSUploadSourceHelper().uploadMedia(mediaInfos: localMedias, progress: {
                (progress)in
                DispatchQueue.main.async {
                    MBProgressHUD.yxs_updateUploadProgess(progess: progress, inView: self.navigationController!.view)
                }
            }, sucess: { (listModels) in
                SLLog(listModels)
                MBProgressHUD.yxs_hideHUDInView(view: self.navigationController!.view)
                for index in 0..<listModels.count{
                    let placeholderUrl = self.placeholderUrls[index]
                    placeholderUrl.uploadUrl = listModels[index].aliYunUploadBackUrl
                    SLLog(listModels[index].aliYunUploadBackUrl)
                }
                self.loadSetupCollectorRequest(setUpItems: self.getSetupLists())
            }) { (msg, code) in
                MBProgressHUD.yxs_hideHUDInView(view: self.navigationController!.view)
                MBProgressHUD.yxs_showMessage(message: msg)
                self.placeholderUrls.removeAll()
            }
        }else{
            self.loadSetupCollectorRequest(setUpItems: self.getSetupLists())
        }
    }
    
    public func yxs_reloadTableView(_ indexPath: IndexPath?){
        UIView.performWithoutAnimation {
            ///存在当前indexPath
            if let indexPath = indexPath{
                tableView.reloadRows(at: [indexPath], with: .none)
            }else{
                tableView.reloadData()
            }
        }
    }
    
    func updateBottomView(){
        if self.detailModel?.state == 100 {
            self.bottomBtnView.btnCommit.setTitle("已结束", for: .disabled)
            self.bottomBtnView.btnCommit.isEnabled = false
            self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
        }
        else if self.detailModel?.state == 10 {
            self.bottomBtnView.btnCommit.setTitle("我来接龙", for: .normal)
            self.bottomBtnView.btnCommit.isEnabled = true
            self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 21)
        }
        else {
            if detailModel?.type == 3{
                self.bottomBtnView.btnCommit.setTitle("已接龙,重新提交", for: .normal)
                self.bottomBtnView.btnCommit.isEnabled = true
                self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 21)
            }else{
                self.bottomBtnView.btnCommit.setTitle("已接龙", for: .normal)
                self.bottomBtnView.btnCommit.isEnabled = false
                self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
            }
        }
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            self.bottomBtnView.isHidden = false
        }
    }
    
    func joinSucessDeal(){
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kParentSubmitSucessNotification), object: [kNotificationIdKey: self.censusId ?? 0])
        UIUtil.yxs_reduceAgenda(serviceId: self.censusId ?? 0, info: [kEventKey:YXSHomeType.solitaire])
    }
    
}

// MARK: - Request
extension YXSSolitaireNewDetailController{
    func loadSetupCollectorRequest(setUpItems: [[String: Any]]){
        MBProgressHUD.yxs_showLoading(inView: self.navigationController?.view)
        if detailModel?.state == 10{
            YXSEducationCensusParentCommitRequest(censusId: censusId ?? 0, childrenId: childrenId ?? 0, option: "调查", remark: "").request({ (json) in
                YXSEducationCensusParentPartakeCommitRequest(censusId: self.censusId ?? 0, childrenId: self.childrenId ?? 0, censusGatherHolderItemRequestList: setUpItems).request({ (json) in
                    MBProgressHUD.yxs_hideHUDInView(view: self.navigationController?.view)
                    MBProgressHUD.yxs_showMessage(message: "参与成功")
                    self.detailModel?.state = 20
                    self.joinSucessDeal()
                    self.updateBottomView()
                }) { (msg, code) in
                    MBProgressHUD.yxs_hideHUDInView(view: self.navigationController?.view)
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
            }) { (msg, code) in
                MBProgressHUD.yxs_hideHUDInView(view: self.navigationController?.view)
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }else{
            YXSEducationCensusParentPartakeCommitRequest(censusId: censusId ?? 0, childrenId: childrenId ?? 0, censusGatherHolderItemRequestList: setUpItems).request({ (json) in
                MBProgressHUD.yxs_hideHUDInView(view: self.navigationController?.view)
                self.joinSucessDeal()
                MBProgressHUD.yxs_showMessage(message: "修改成功")
            }) { (msg, code) in
                MBProgressHUD.yxs_hideHUDInView(view: self.navigationController?.view)
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
    }
    
    @objc func recallRequest(){
        MBProgressHUD.yxs_showLoading()
        YXSEducationCensusParentWithdrawCommitRequest.init(censusId: censusId ?? 0, censusCommitId: censusCommitId ?? 0, childrenId: childrenId ?? 0).request({ (result) in
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationStudentCancelSolitaireNotification), object: [kNotificationIdKey: self.censusId ?? 0])
            self.yxs_refreshData()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
}


// MARK: - UI
extension YXSSolitaireNewDetailController{
    func getApplyCell(indexPath: IndexPath, cModel: YXSClassMemberModel) -> UITableViewCell{
        
        let isShowRecall = cModel.childrenId == childrenId
        if isShowRecall{
            censusCommitId = cModel.censusCommitId
        }
        //        if headerSelectedIndex == 0 {
        //            let cell:YXSDetailSubTitleBottomCell = tableView.dequeueReusableCell(withIdentifier: "YXSDetailSubTitleBottomCell") as! YXSDetailSubTitleBottomCell
        //            cell.lbTitle.text = childrenId == cModel.childrenId ? "我" : "\(cModel.realName ?? "")\(cModel.relationship?.yxs_RelationshipValue() ?? "")"
        //            cell.imgAvatar.sd_setImage(with: URL(string: cModel.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
        //            cell.recallView.addTarget(self, action: #selector(recallClick), for: .touchUpInside)
        //            cell.recallView.isHidden = !isShowRecall
        //            cell.setRemarkTitle(remark: cModel.remark)
        //            cell.btnPhone.tag = indexPath.row
        //            cell.btnChat.tag = indexPath.row
        //            cell.btnPhone.addTarget(self, action: #selector(yxs_callUpClick(sender:)), for: .touchUpInside)
        //            cell.btnChat.addTarget(self, action: #selector(yxs_chatClick(sender:)), for: .touchUpInside)
        //            return cell
        //
        //        } else {
        //            let cell:YXSDetailNormalRecallCell = tableView.dequeueReusableCell(withIdentifier: "YXSDetailNormalRecallCell") as! YXSDetailNormalRecallCell
        //            cell.lbTitle.text = childrenId == cModel.childrenId ? "我" : "\(cModel.realName ?? "")\(cModel.relationship?.yxs_RelationshipValue() ?? "")"
        //            cell.imgAvatar.sd_setImage(with: URL(string: cModel.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
        //            cell.recallView.addTarget(self, action: #selector(recallClick), for: .touchUpInside)
        //            cell.recallView.isHidden = !isShowRecall
        //            cell.btnPhone.tag = indexPath.row
        //            cell.btnChat.tag = indexPath.row
        //            cell.btnPhone.addTarget(self, action: #selector(yxs_callUpClick(sender:)), for: .touchUpInside)
        //            cell.btnChat.addTarget(self, action: #selector(yxs_chatClick(sender:)), for: .touchUpInside)
        //            return cell
        //        }
        let cell:YXSDetailSubTitleBottomCell = tableView.dequeueReusableCell(withIdentifier: "YXSDetailSubTitleBottomCell") as! YXSDetailSubTitleBottomCell
        cell.lbTitle.text = childrenId == cModel.childrenId ? "我" : "\(cModel.realName ?? "")\(cModel.relationship?.yxs_RelationshipValue() ?? "")"
        cell.imgAvatar.sd_setImage(with: URL(string: cModel.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
        cell.recallView.addTarget(self, action: #selector(recallClick), for: .touchUpInside)
        cell.recallView.isHidden = !isShowRecall
        cell.setRemarkTitle(remark: cModel.remark)
        cell.btnPhone.tag = indexPath.row
        cell.btnChat.tag = indexPath.row
        cell.btnPhone.addTarget(self, action: #selector(yxs_callUpClick(sender:)), for: .touchUpInside)
        cell.btnChat.addTarget(self, action: #selector(yxs_chatClick(sender:)), for: .touchUpInside)
        return cell
    }
    
    func setupRightBarButtonItem() {
        let btnShare = YXSButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        btnShare.setMixedImage(MixedImage(normal: "yxs_punchCard_share", night: "yxs_punchCard_share_white"), forState: .normal)
        btnShare.setMixedImage(MixedImage(normal: "yxs_punchCard_share", night: "yxs_punchCard_share_white"), forState: .highlighted)
        btnShare.addTarget(self, action: #selector(yxs_shareClick(sender:)), for: .touchUpInside)
        let navShareItem = UIBarButtonItem(customView: btnShare)
        self.navigationItem.rightBarButtonItems = [navShareItem]
    }
    
    func initUI(){
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            self.view.addSubview(bottomBtnView)
            bottomBtnView.snp.makeConstraints({ (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(0)
                make.height.equalTo(62)
            })
            self.tableView.snp.remakeConstraints { (make) in
                make.top.equalTo(0)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(self.bottomBtnView.snp_top)
            }
        }
        setupRightBarButtonItem()
    }
    
    @objc func keyBoardWillShow(_ notification:Notification){
        if UIUtil.TopViewController() == self{
            DispatchQueue.main.async {
                let user_info = notification.userInfo
                let keyboardRect = (user_info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                if let currentIndexPath = self.curruntIndex{
                    let cell = self.tableView.cellForRow(at: currentIndexPath)
                    if let textCell  = cell as? YXSSolitaireCollectorPartentDetialTextCell{
                        
                        let rc = textCell.convert(textCell.textView.frame, to: self.view)
                        
                        let offsetY = (SCREEN_HEIGHT - rc.maxY) - keyboardRect.height - 40
                        var contentSet = self.tableView.contentOffset
                        self.curruntContentOffset = contentSet
                        contentSet.y -= offsetY
                        if contentSet.y >= 0 {
                            self.tableView.setContentOffset(contentSet, animated: true)
                        }
                    }
                }
            }
        }
        
    }
    @objc func keyBoardWillHide(_ notification:Notification){
        if UIUtil.TopViewController() == self{
            DispatchQueue.main.async {
                if let curruntContentOffset = self.curruntContentOffset{
                    self.tableView.setContentOffset(curruntContentOffset, animated: true)
                }
                self.curruntContentOffset = nil
            }
        }
    }
}
