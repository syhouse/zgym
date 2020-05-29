//
//  YXSSolitaireCollectorPublishBaseController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/28.
//  Copyright © 2020 zgym. All rights reserved.
//

import NightNight

class YXSSolitaireCollectorPublishController: YXSSolitaireNewPublishBaseController {
    override init(){
        super.init()
        saveDirectory = "Solitaire_collector"
        sourceDirectory = .solitaire
        isSelectSingleClass = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "信息采集"
        
        publishView.updateContentOffSet = {
            [weak self](offsetY) in
            guard let strongSelf = self else { return }
            strongSelf.updateHeaderView()
            var offset = strongSelf.tableView.contentOffset
            offset.y += offsetY
            strongSelf.tableView.contentOffset = offset
        }

        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        tableView.estimatedRowHeight = 120
    }
    
    
    // MARK: -UI
    override func setTeacherUI() {
        view.addSubview(tableView)
        view.addSubview(footerSettingView)
        footerSettingView.snp.makeConstraints { (make) in
            make.height.equalTo(60 + kSafeBottomHeight)
            make.bottom.left.right.equalTo(0)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.bottom.equalTo(-60 - kSafeBottomHeight)
        }
        
        // 设置tableHeaderView
        tableHeaderView.addSubview(publishView)
        tableHeaderView.addSubview(selectClassView)
        selectClassView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        publishView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(selectClassView.snp_bottom).offset(10)
            make.bottom.equalTo(0)
        }
        publishView.yxs_addLine()

        updateHeaderView()
        
        //设置footerView
        tableView.tableFooterView = tableFooterView
        tableFooterView.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(tableFooterView)
            make.top.equalTo(60)
            make.size.equalTo(CGSize.init(width: 146.5, height: 31))
        }
    }
    
    
    // MARK: -loadData
    override func yxs_loadClassDataSucess(){
        loadClassCountData()
    }
    
    // MARK: - action
    @objc func addQuestion(){
        YXSSolitaireQuestionWindow.showWindow {
            [weak self] (type) in
            guard let strongSelf = self else { return }
            strongSelf.pushQuestionSetVC(questionModel: nil, type: type)
        }
    }
    
    func pushQuestionSetVC(questionModel: YXSSolitaireQuestionModel?, editIndex: Int? = nil, type: YXSQuestionType){
        let vc = YXSSolitaireQuestionSetController(questionModel, type: type)
        vc.completeHandler = {
            [weak self] (questionModel) in
            guard let strongSelf = self else { return }
            if let editIndex = editIndex{
                strongSelf.publishModel.solitaireQuestions[editIndex] = questionModel
            }else{
                strongSelf.publishModel.solitaireQuestions.append(questionModel)
            }
            strongSelf.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc)
    }
    
    // MARK: - private
    private func updateHeaderView(){
        let headerHeight = self.tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        self.tableHeaderView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: headerHeight)
        self.tableView.tableHeaderView = tableHeaderView
    }
    
    // MARK: - getter&setter
    lazy var addButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 146.5, height: 31))
        button.setImage(UIImage(named: "yxs_solitaire_add_small"), for: .normal)
        button.layer.cornerRadius = 15.5
        button.borderWidth = 1
        button.borderColor = kBlueColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("添加题目", for: .normal)
        button.setTitleColor(kBlueColor, for: .normal)
        button.addTarget(self, action: #selector(addQuestion), for: .touchUpInside)
        button.yxs_setIconInLeftWithSpacing(8)
        return button
    }()
    lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView()
        tableHeaderView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "F2F5F9"), night: kNightBackgroundColor)
        return tableHeaderView
    }()
    
    lazy var tableFooterView: UIView = {
        let tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 160))
        return tableFooterView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mixedBackgroundColor = MixedColor.init(normal: UIColor.white, night: kNightBackgroundColor)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        tableView.register(YXSSolitaireQuestionItemsCell.self, forCellReuseIdentifier: "YXSSolitaireQuestionItemsCell")
        tableView.register(YXSSolitaireQuestionBaseCell.self, forCellReuseIdentifier: "YXSSolitaireQuestionBaseCell")
        return tableView
    }()
}

extension YXSSolitaireCollectorPublishController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return publishModel.solitaireQuestions.count == 0 ? 0 : 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publishModel.solitaireQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = publishModel.solitaireQuestions[indexPath.row]
        var cell: YXSSolitaireQuestionBaseCell!
        switch model.type {
        case .gap, .image:
            cell = tableView.dequeueReusableCell(withIdentifier: "YXSSolitaireQuestionBaseCell", for: indexPath) as? YXSSolitaireQuestionBaseCell
        case .checkbox, .single:
            cell = tableView.dequeueReusableCell(withIdentifier: "YXSSolitaireQuestionItemsCell", for: indexPath) as? YXSSolitaireQuestionItemsCell
        }
        cell.questionDealBlock = {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dealChangeClick(indexPath: indexPath)
        }
        cell.setCellModel(model, index: indexPath.row)
        return cell
    }
    
    func dealChangeClick(indexPath: IndexPath){
        let model = publishModel.solitaireQuestions[indexPath.row]
        let cell = self.tableView.cellForRow(at: indexPath)
        if let cell  = cell as? YXSSolitaireQuestionBaseCell{
            let selectFrame = cell.convert(cell.dealBtn.frame, to: self.tabBarController?.view)
            var y: CGFloat =  selectFrame.maxY - 4
            let selectHeight: CGFloat = 2*35 + kSafeBottomHeight
            if SCREEN_HEIGHT - y < selectHeight {
                y = SCREEN_HEIGHT - selectHeight
            }
            
            let selects = [YXSSelectModel.init(text: "编辑", isSelect: false, paramsKey: "10"),YXSSelectModel.init(text: "删除", isSelect: false, paramsKey: "20")]
            YXSBaseSelectView.showAlert(offset: CGPoint.init(x: 14.5, y: y), selects:  selects) { [weak self](index, selectTypeModels) in
                guard let strongSelf = self else { return }
                if selects[index].paramsKey == "10"{
                    strongSelf.pushQuestionSetVC(questionModel: model, editIndex: indexPath.row, type: model.type)
                }else{
                    strongSelf.publishModel.solitaireQuestions.remove(at: indexPath.row)
                    strongSelf.tableView.reloadData()
                }
                strongSelf.fd_interactivePopDisabled = false
            }
        }
    }
}




