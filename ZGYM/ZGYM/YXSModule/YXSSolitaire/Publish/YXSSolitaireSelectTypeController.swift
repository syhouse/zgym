//
//  YXSSolitaireSelectTypeController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/27.
//  Copyright © 2020 zgym. All rights reserved.
//

import NightNight

class YXSSolitaireSelectTypeController: YXSBaseTableViewController {
    var dataSouer = [YXSTemplateListModel]()
    
    /// 单个班级详情页发布
    var singlePublishClassId: Int?
    
    override init() {
        super.init()
        showBegainRefresh = false
        hasRefreshHeader = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择报名类型"
        tableView.tableHeaderView = headerView
        tableView.register(YXSSolitaireTemplateCell.self, forCellReuseIdentifier: "YXSSolitaireTemplateCell")
        tableView.rowHeight = 55
        tableView.isScrollEnabled = false
        
        loadTemplateData()
    }
    
    // MARK: - loadData
    func loadTemplateData(){
        YXSEducationCensusTeacherGatherTemplateListRequest(currentPage: 1).requestCollection({ (templateLists: [YXSTemplateListModel]) in
            self.dataSouer.removeAll()
            let maxCount = templateLists.count > 3 ? 3 : templateLists.count
            for index in 0..<maxCount{
                self.dataSouer.append(templateLists[index])
            }
            self.tableView.reloadData()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    func loadTemplateDetialData(id: Int){
        YXSEducationCensusTeacherGatherTemplateDetailRequest.init(id: id).request({ (detialModel: YXSSolitaireTemplateDetialModel) in
//            SLLog(detialModel.toJSONString())
            self.pushPublishVC(index: detialModel.type == 2 ? 0 : 1, detialModel: detialModel)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    /// index 0 报名 1采集
    func pushPublishVC(index: Int, detialModel: YXSSolitaireTemplateDetialModel?){
        var vc: YXSSolitaireNewPublishBaseController!
        if index == 0{
            vc = YXSSolitaireApplyPublishController()
        }else{
            vc = YXSSolitaireCollectorPublishController()
        }
        vc.solitaireTemplateModel = detialModel
        vc.singlePublishClassId = self.singlePublishClassId
        self.navigationController?.pushViewController(vc)
    }
    
    // MARK: - UITableViewDataSource，UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouer.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: YXSSolitaireTemplateCell = tableView.dequeueReusableCell(withIdentifier: "YXSSolitaireTemplateCell") as! YXSSolitaireTemplateCell
        cell.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        cell.setModel(dataSouer[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSouer[indexPath.row]
        loadTemplateDetialData(id: model.id ?? 0)
    }
    
    
    lazy var headerView: YXSSolitaireSelectTypeTabelView = {
        let headerView = YXSSolitaireSelectTypeTabelView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 359))
        headerView.lookMoreClickBlock = {
            [weak self] in
            guard let strongSelf = self else { return }
            let vc = YXSSolitaireTemplateListController()
            vc.singlePublishClassId = strongSelf.singlePublishClassId
            strongSelf.navigationController?.pushViewController(vc)
        }
        headerView.selectSectionBlock = {
            [weak self] (index)in
            guard let strongSelf = self else { return }
            strongSelf.pushPublishVC(index: index, detialModel: nil)
        }
        return headerView
    }()
    
}

class YXSSolitaireTemplateCell: UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        addSubview(bgView)
        bgView.addSubview(icon)
        bgView.addSubview(title)
        bgView.snp.makeConstraints { (make) in
            make.height.equalTo(45)
            make.top.equalTo(0)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(19.5)
            make.centerY.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.left.equalTo(icon.snp_right).offset(15.5)
            make.right.equalTo(-15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(_ model: YXSTemplateListModel?){
        icon.image = UIImage(named: model?.type == 2 ? "yxs_solitaire_apply_small" : "yxs_solitaire_collector_small")
        title.text = model?.name
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F7F9FD")
        bgView.cornerRadius = 2.5
        return bgView
    }()
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = kImageDefualtImage
        return icon
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = kTextMainBodyColor
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
    
}

class YXSSolitaireSelectTypeTabelView: UIView{
    var lookMoreClickBlock: (()->())?
    ///0报名接龙 1信息采集
    var selectSectionBlock: ((_ index: Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9")
        addSubview(topSectionView)
        addSubview(secendSectionView)
        topSectionView.yxs_addLine(position: .bottom, color: kLineColor, leftMargin: 15, rightMargin: 15, lineHeight: 0.5)
        
        addSubview(secendSectionView)
        
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        addSubview(bottomView)
        bottomView.addSubview(titleL)
        bottomView.addSubview(lookMore)
        
        topSectionView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.height.equalTo(140.5)
        }
        secendSectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topSectionView.snp_bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(140.5)
        }
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(secendSectionView.snp_bottom).offset(10)
            make.left.right.equalTo(0)
            make.height.equalTo(58.5)
        }
        titleL.snp.makeConstraints { (make) in
            make.top.equalTo(21.5)
            make.left.equalTo(15.5)
        }
        lookMore.snp.makeConstraints { (make) in
            make.height.equalTo(25)
            make.centerY.equalTo(titleL)
            make.right.equalTo(-15.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func sectionClick(view: UIView){
        selectSectionBlock?( view == topSectionView ? 0 : 1)
    }
    
    @objc func lookMoreClick(){
        lookMoreClickBlock?()
    }
    
    lazy var topSectionView: YXSSolitaireSelectionView = {
        let topSectionView = YXSSolitaireSelectionView()
        topSectionView.icon.image = UIImage(named: "yxs_solitaire_apply")
        topSectionView.title.text = "发起报名接龙"
        topSectionView.desLabel.text = "支持家长选择参加或不参加，可备注说明"
        topSectionView.addTarget(self, action: #selector(sectionClick), for: .touchUpInside)
        return topSectionView
    }()
    
    lazy var secendSectionView: YXSSolitaireSelectionView = {
        let secendSectionView = YXSSolitaireSelectionView()
        secendSectionView.icon.image = UIImage(named: "yxs_solitaire_collector")
        secendSectionView.title.text = "发起信息采集/投票选举"
        secendSectionView.desLabel.text = "支持自定义投票选项，可以单选、多选"
        secendSectionView.addTarget(self, action: #selector(sectionClick), for: .touchUpInside)
        return secendSectionView
    }()
    
    lazy var lookMore: YXSCustomImageControl = {
        let lookMore = YXSCustomImageControl.init(imageSize: CGSize.init(width: 13.4, height: 13.4), position: YXSImagePositionType.right, padding: 9.5)
        lookMore.font = UIFont.boldSystemFont(ofSize: 14)
        lookMore.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        lookMore.locailImage = "arrow_gray"
        lookMore.title = "查看更多"
        lookMore.addTarget(self, action: #selector(lookMoreClick), for: .touchUpInside)
        return lookMore
    }()
    
    lazy var titleL: UILabel = {
        let label = UILabel()
        label.text = "常用模版"
        label.textColor = kTextMainBodyColor
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
}

class YXSSolitaireSelectionView: UIControl{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        addSubview(icon)
        addSubview(title)
        addSubview(desLabel)
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize.init(width: 58, height: 58))
        }
        title.snp.makeConstraints { (make) in
            make.top.equalTo(icon)
            make.left.equalTo(icon.snp_right).offset(20.5)
        }
        desLabel.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp_bottom).offset(18.5)
            make.left.equalTo(icon.snp_right).offset(20.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = kImageDefualtImage
        return icon
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = kTextMainBodyColor
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var desLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#696C73")
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
}
