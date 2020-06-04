//
//  YXSTemplateListController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/26.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight
import ObjectMapper

enum YXSTemplateType{
    case notice
    case punchcard
}

class YXSTemplateListController: YXSBaseCollectionViewController{
    
    /// 提交完成后的block
    var didSelectTemplateModel: ((_ model: YXSTemplateListModel) -> ())?
    
    var type: YXSTemplateType = .punchcard
    ///只展示模版
    var punchCardTemplates: [YXSTemplateListModel] = [YXSTemplateListModel]()
    
    ///展示标签+模版
    var tabListTemplates: [YXSTemplateTabModel] = [YXSTemplateTabModel]()
    
    ///初始化选中模版
    var selectTemplate: YXSTemplateListModel? = nil
    
    init(type: YXSTemplateType, templateItems: [YXSTemplateListModel]?) {
        if let templateItems = templateItems{
            self.punchCardTemplates = templateItems
            for model in templateItems{
                if model.isSelected{
                    self.selectTemplate = model
                    break
                }
            }
        }
        self.type = type
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCicle
    
    override func viewDidLoad() {
        
        let layout = UICollectionViewFlowLayout()
        let itemW: CGFloat = (self.view.frame.size.width - CGFloat(13.5*2.0) - CGFloat(15.0*2.0))/3.0
        layout.minimumLineSpacing = 13.5
        layout.minimumInteritemSpacing = 13.5
        layout.sectionInset = UIEdgeInsets.init(top: 30, left: 15, bottom: 17, right: 15)
        layout.itemSize = CGSize.init(width: itemW, height: 29)
        self.layout =  layout
        
        hasRefreshHeader = false
        
        super.viewDidLoad()
        
        switch type {
        case .punchcard:
            title = "打卡模版"
            self.layout.headerReferenceSize = CGSize.zero
        case .notice:
            title = "通知模版"
            loadData()
            self.layout.headerReferenceSize = CGSize.init(width: SCREEN_WIDTH, height: 45)
        }
        collectionView.register(YXSTemplateListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "YXSTemplateListHeaderView")
        collectionView.register(YXSTemplateListCell.self, forCellWithReuseIdentifier: "YXSTemplateListCell")
        
    }
    
    // MARK: - loadData
    func loadData(){
        var serviceType = 0
        switch YXSPersonDataModel.sharePerson.personStage {
        case .KINDERGARTEN:
            serviceType = 0
        case .PRIMARY_SCHOOL:
            serviceType = 100
        case .MIDDLE_SCHOOL:
            serviceType = 101
        }
        YXSEducationTemplateQueryTabTemplateRequest(serviceType: serviceType).requestCollection({ (list: [YXSTemplateTabModel]) in
            var hasFound = false
            for tabModel in list{
                if let templateList = tabModel.templateList{
                    ///设置初始化选中
                    for tem in templateList{
                        if tem.id == self.selectTemplate?.id{
                            tem.isSelected = true
                            hasFound = true
                            break
                        }
                        
                    }
                    
                    if hasFound{
                        break
                    }
                }
            }
            self.tabListTemplates = list
            self.collectionView.reloadData()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    override func yxs_onBackClick() {
        self.navigationController?.popViewController()
    }
    
    
    // MARK: - UICol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch type {
        case .punchcard:
            let curruntModel = punchCardTemplates[indexPath.row]
            if curruntModel.isSelected{
                return
            }
            for (index, model) in punchCardTemplates.enumerated(){
                if index == indexPath.row{
                    model.isSelected = true
                }else{
                    model.isSelected = false
                }
                didSelectTemplateModel?(curruntModel)
            }
        case .notice:
            let curruntModel = tabListTemplates[indexPath.section].templateList?[indexPath.row]
            if let curruntModel = curruntModel{
                if curruntModel.isSelected{
                    return
                }
                for (section, sectionModel) in tabListTemplates.enumerated(){
                    if let templateList = sectionModel.templateList{
                        for (index, model) in templateList.enumerated(){
                            if index == indexPath.row && section == indexPath.section{
                                model.isSelected = true
                            }else{
                                model.isSelected = false
                            }
                        }
                    }
                    
                    didSelectTemplateModel?(curruntModel)
                }
            }
        }
        
        collectionView.reloadData()
        self.navigationController?.popViewController()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type {
        case .punchcard:
            return punchCardTemplates.count
        case .notice:
            return tabListTemplates[section].templateList?.count ?? 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch type {
        case .punchcard:
            return 1
        case .notice:
            return tabListTemplates.count
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXSTemplateListCell", for: indexPath) as! YXSTemplateListCell
        switch type {
        case .punchcard:
            cell.setModel(punchCardTemplates[indexPath.row])
        case .notice:
            cell.setModel(tabListTemplates[indexPath.section].templateList?[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "YXSTemplateListHeaderView", for: indexPath) as! YXSTemplateListHeaderView
            headerView.setModel(tabListTemplates[indexPath.section])
            return headerView
        }
        return YXSTemplateListHeaderView()
    }
}



class YXSTemplateListCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setModel(_ model: YXSTemplateListModel?){
        button.setTitle(model?.title, for: .normal)
        button.isSelected = model?.isSelected ?? false
        updateButtonUI(button)
    }
    
    private func updateButtonUI(_ button: UIButton){
        if button.isSelected{
            button.borderColor = kBlueColor
            
        }else{
            button.borderColor = UIColor.clear
        }
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.borderWidth = 1
        button.setBackgroundImage(UIImage.yxs_image(with: UIColor.white), for: .selected)
        button.setBackgroundImage(UIImage.yxs_image(with: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9")), for: .normal)
        button.setTitleColor(kBlueColor, for: .selected)
        button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#696C73"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.cornerRadius = 14.5
        button.titleLabel?.textAlignment = .center
        button.isUserInteractionEnabled = false
        return button
    }()
}

class YXSTemplateListHeaderView: UICollectionReusableView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(icon)
        addSubview(titleLabel)
        icon.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 22, height: 22))
            make.left.equalTo(16)
            make.top.equalTo(22)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp_right).offset(13)
            make.centerY.equalTo(icon)
        }
    }
    
    func setModel(_ model: YXSTemplateTabModel?){
        titleLabel.text = model?.tabName
        icon.sd_setImage(with: URL.init(string: model?.icon ?? ""), placeholderImage: kImageDefualtImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = kTextMainBodyColor
        return label
    }()
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = kImageDefualtImage
        return icon
    }()
}
