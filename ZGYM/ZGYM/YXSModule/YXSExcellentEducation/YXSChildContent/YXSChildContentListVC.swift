//
//  YXSChildContentListVC.swift
//  ZGYM
//
//  Created by yihao on 2020/4/24.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import JXCategoryView
import NightNight
import ObjectMapper

class YXSChildContentListVC: YXSBaseTableViewController,JXCategoryListContentViewDelegate {
    
    private var typeModel: YXSChildContentHomeTypeModel?
    private var dataSource: [YXSChildContentHomeListModel] = [YXSChildContentHomeListModel]()
    
    func listView() -> UIView! {
        return self.view
    }
    init(typeModel: YXSChildContentHomeTypeModel) {
        super.init()
        self.typeModel = typeModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.scrollView.snp.remakeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.register(YXSChildContentListCell.self, forCellReuseIdentifier: "YXSChildContentListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    // MARK: -loadData
    override func yxs_refreshData() {
        curruntPage = 1
        loadData()
        
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    func loadData(){
        
        YXSEducationChildContentPageListRequest.init(current: curruntPage, type: typeModel?.id ?? 0).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            weakSelf.yxs_endingRefresh()
            let list = Mapper<YXSChildContentHomeListModel>().mapArray(JSONObject: json["records"].object) ?? [YXSChildContentHomeListModel]()
            
            if weakSelf.curruntPage == 1{
                weakSelf.dataSource.removeAll()
            }
            weakSelf.dataSource += list
            if json["pages"].intValue > weakSelf.curruntPage {
                weakSelf.loadMore = true
            } else {
                weakSelf.loadMore = false
            }
            weakSelf.tableView.reloadData()
        }) { (msg, code) in
            self.yxs_endingRefresh()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
//        YXSEducationChildContentPageListRequest.init(currentPage: curruntPage, tabId: self.currentTab?.id ?? 1).request({ (json) in
//            self.yxs_endingRefresh()
//            let list = Mapper<YXSSynClassListModel>().mapArray(JSONObject: json["folderList"].object) ?? [YXSSynClassListModel]()

//            self.dataSource += list
//            self.loadMore = json["hasNext"].boolValue
//            self.tableView.reloadData()
//        }) { (msg, code) in
//            self.yxs_endingRefresh()
//            MBProgressHUD.yxs_showMessage(message: msg)
//        }
    }
    
    // MARK: - tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSChildContentListCell") as! YXSChildContentListCell
        cell.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), leftMargin: 15, rightMargin: 0, lineHeight: 0.5)
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
            let vc = YXSBaseWebViewController()
//            vc.loadUrl = "http://192.168.10.157/yehw/index.html"
            vc.loadUrl = "http://www.ym698.com/yehw/"
            let dic = ["id":model.id ?? 0, "token":YXSPersonDataModel.sharePerson.token ?? ""] as [String : Any]
            vc.scriptKey = dic.jsonString() ?? ""
            self.navigationController?.pushViewController(vc)
        }
    }
    
    // MARK: -列表为空
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return showEmptyDataSource
    }
    
    override func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 10
    }
}
