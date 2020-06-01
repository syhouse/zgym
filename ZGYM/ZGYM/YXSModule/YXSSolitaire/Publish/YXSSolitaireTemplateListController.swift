//
//  YXSSolitaireTemplateListController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/27.
//  Copyright © 2020 zgym. All rights reserved.
//

import NightNight

class YXSSolitaireTemplateListController: YXSBaseTableViewController {
    var dataSouer = [YXSTemplateListModel]()
    
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
        self.title = "更多模版"
        tableView.sectionHeaderHeight = 20
        tableView.register(YXSSolitaireTemplateCell.self, forCellReuseIdentifier: "YXSSolitaireTemplateCell")
        tableView.rowHeight = 55
        
        loadTemplateData()
    }
    
    override func yxs_loadNextPage() {
        loadTemplateData()
    }
    // MARK: - loadData
    func loadTemplateData(){
        YXSEducationCensusTeacherGatherTemplateListRequest(currentPage: 1).requestCollection({ (templateLists: [YXSTemplateListModel]) in
            self.yxs_endingRefresh()
            if self.currentPage == 1{
                self.dataSouer.removeAll()
            }
            
            self.dataSouer += templateLists
            
            self.loadMore = templateLists.count == kPageSize
            self.tableView.reloadData()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
            self.yxs_endingRefresh()
        }
        
        
    }
    
    func loadTemplateDetialData(id: Int){
        YXSEducationCensusTeacherGatherTemplateDetailRequest.init(id: id).request({ (json) in
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
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
}
