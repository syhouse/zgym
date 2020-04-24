//
//  YXSSynClassListVC.swift
//  ZGYM
//
//  Created by yihao on 2020/4/20.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import JXCategoryView
import NightNight
import ObjectMapper

class YXSSynClassListVC: YXSBaseTableViewController,JXCategoryListContentViewDelegate {
    
    var type: YXSSynClassListType?
    var currentTab: YXSSynClassTabModel?
    var primarySchoolTabs:[YXSSynClassTabModel] = [YXSSynClassTabModel]()
    var middleSchoolTabs:[YXSSynClassTabModel] = [YXSSynClassTabModel]()
    var highSchoolTabs:[YXSSynClassTabModel] = [YXSSynClassTabModel]()
    var dataSource: [YXSSynClassListModel] = [YXSSynClassListModel]()
    
    func listView() -> UIView! {
        return self.view
    }
    init(type: YXSSynClassListType) {
        super.init()
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTabData()
        self.scrollView.snp.remakeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.register(YXSSynClassListCell.self, forCellReuseIdentifier: "YXSSynClassListCell")
        tableView.tableHeaderView = tableHeaderView
        tableHeaderView.tabSelectBlock = { (tab) in
            self.currentTab = tab
            self.loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
    }

    
    func refreshHeaderTab() {
        switch self.type {
        case .PRIMARY_SCHOOL:
            self.tableHeaderView.setTabs(tabs: self.primarySchoolTabs)
            self.currentTab = self.primarySchoolTabs.first
        case .MIDDLE_SCHOOL:
            self.tableHeaderView.setTabs(tabs: self.middleSchoolTabs)
            self.currentTab = self.middleSchoolTabs.first
        case .HIGH_SCHOOL:
            self.tableHeaderView.setTabs(tabs: self.highSchoolTabs)
            self.currentTab = self.highSchoolTabs.first
        default:
            print("")
        }
        self.loadData()
    }
    
    // MARK: -loadData
    func loadTabData() {
        YXSEducationExcellentTabPageRequest.init().request({ [weak self](json) in
            guard let weakSelf = self else {return}
            let joinList = Mapper<YXSSynClassTabModel>().mapArray(JSONObject: json["tabList"].object) ?? [YXSSynClassTabModel]()
            weakSelf.primarySchoolTabs.removeAll()
            weakSelf.middleSchoolTabs.removeAll()
            weakSelf.highSchoolTabs.removeAll()
            for tab in joinList {
                if tab.stage == .PRIMARY_SCHOOL {
                    weakSelf.primarySchoolTabs.append(tab)
                } else if tab.stage == .MIDDLE_SCHOOL {
                    weakSelf.middleSchoolTabs.append(tab)
                } else if tab.stage == .HIGH_SCHOOL {
                    weakSelf.highSchoolTabs.append(tab)
                }
            }
            weakSelf.refreshHeaderTab()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    override func yxs_refreshData() {
        curruntPage = 1
        loadData()
        
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    func loadData(){
        YXSEducationFolderPageQueryRequest.init(currentPage: curruntPage, tabId: self.currentTab?.id ?? 1).request({ (json) in
            self.yxs_endingRefresh()
            let list = Mapper<YXSSynClassListModel>().mapArray(JSONObject: json["folderList"].object) ?? [YXSSynClassListModel]()
            if self.curruntPage == 1{
                self.dataSource.removeAll()
            }
            self.dataSource += list
            self.loadMore = json["hasNext"].boolValue
            self.tableView.reloadData()
        }) { (msg, code) in
            self.yxs_endingRefresh()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSSynClassListCell") as! YXSSynClassListCell
        cell.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), lineHeight: 0.5)
        if dataSource.count > indexPath.row {
            let model = dataSource[indexPath.row]
            cell.setModel(model: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if dataSource.count > indexPath.row {
            let model = dataSource[indexPath.row]
            let vc = YXSSynClassFolderVC.init(folderId: model.id!, title: model.folderName ?? "")
            vc.refreshPlayBlock = { ()in
            }
            self.navigationController?.pushViewController(vc)
        }
    }
    
    // MARK: - getter&setter
    lazy var tableHeaderView:YXSSynClassListTableHeaderView = {
        let headerView = YXSSynClassListTableHeaderView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 58))
        return headerView
    }()
}

class YXSSynClassListTableHeaderView:UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.scrollView.addSubview(self.mas_widthContentView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.scrollView)
            make.width.equalTo(self.mas_widthContentView)
            make.height.equalTo(self.scrollView)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tabSelectBlock:((_ tab:YXSSynClassTabModel)->())?
    var lastView: UIView = UIView()
    var tabs:[YXSSynClassTabModel] = [YXSSynClassTabModel]()
    
    @objc func tabBtnClick(sender: UIButton){
        let index = sender.tag - 10001
        sender.isSelected = true
        sender.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), night: UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"))
        for subView in self.contentView.subviews {
            if subView.tag > 10000 && subView.tag != sender.tag{
                if subView is UIButton {
                    let btn = subView as! UIButton
                    btn.isSelected = false
                    btn.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"))
                }
            }
        }
        if tabs.count > index {
            let selectTab = tabs[index]
            self.tabSelectBlock?(selectTab)
        }
        
    }
    
    func setTabs(tabs:[YXSSynClassTabModel]) {
        self.tabs = tabs
        self.contentView.removeSubviews()

        let firstBtn = UIButton()
        firstBtn.tag = 10001
        firstBtn.setTitle(tabs.first?.tabName, for: .normal)
        firstBtn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        firstBtn.setTitleColor(UIColor.white, for: .selected)
        firstBtn.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), night: UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"))
        firstBtn.layer.cornerRadius = 14
        firstBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        firstBtn.layer.masksToBounds = true
        firstBtn.isSelected = true
        firstBtn.addTarget(self, action: #selector(tabBtnClick(sender:)), for: .touchUpInside)
        self.contentView.addSubview(firstBtn)
        firstBtn.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.width.equalTo(69)
            make.height.equalTo(28)
        }
        lastView = firstBtn
        var index = 0
        for tab in tabs {
            if index == 0 {
                index += 1
                continue
            }
            let btn = UIButton()
            btn.tag = 10001 + index
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.setTitle(tab.tabName, for: .normal)
            btn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
            btn.setTitleColor(UIColor.white, for: .selected)
            btn.layer.cornerRadius = 14
            btn.addTarget(self, action: #selector(tabBtnClick(sender:)), for: .touchUpInside)
            btn.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"))
            btn.layer.masksToBounds = true
            self.contentView.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.left.equalTo(self.lastView.snp_right).offset(8)
                make.top.equalTo(15)
                make.width.equalTo(69)
                make.height.equalTo(28)
            }
            lastView = btn
            index += 1
        }
        self.updateLayout()
    }
    
    func updateLayout() {
        self.mas_widthContentView.snp.remakeConstraints { (make) in
            make.top.bottom.left.equalTo(self.scrollView)
            make.right.equalTo(self.lastView).offset(8)
        }
        
        
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.zero)
        scrollView.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight383E56)
        return scrollView
    }()
    
    lazy var mas_widthContentView: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        return view
    }()
}
