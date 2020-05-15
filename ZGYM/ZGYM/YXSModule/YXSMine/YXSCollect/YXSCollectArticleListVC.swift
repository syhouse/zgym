//
//  YXSCollectArticleListVC.swift
//  ZGYM
//
//  Created by yihao on 2020/5/13.
//  Copyright © 2020 zgym. All rights reserved.
//  收藏的育儿文章列表

import Foundation
import NightNight
import ObjectMapper

class YXSCollectArticleListVC: YXSBaseTableViewController {
    private var dataSource: [YXSChildContentHomeListModel] = [YXSChildContentHomeListModel]()
    var currentIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "育儿文章"
        self.loadData()
        self.scrollView.snp.remakeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.register(YXSCollectArticleCell.self, forCellReuseIdentifier: "YXSCollectArticleCell")
    }
    
    // MARK: -loadData
    override func yxs_refreshData() {
        currentPage = 1
        loadData()
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    func loadData(){
        YXSEducationChildContentCollectionArticleRequest.init(current: currentPage).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            weakSelf.yxs_endingRefresh()
            let list = Mapper<YXSChildContentHomeListModel>().mapArray(JSONObject: json["records"].object) ?? [YXSChildContentHomeListModel]()
            
            if weakSelf.currentPage == 1{
                weakSelf.dataSource.removeAll()
            }
            weakSelf.dataSource += list
            if json["pages"].intValue > weakSelf.currentPage {
                weakSelf.loadMore = true
            } else {
                weakSelf.loadMore = false
            }
            if json["pages"].intValue > weakSelf.currentPage {
                weakSelf.loadMore = true
            } else {
                weakSelf.loadMore = false
            }
            weakSelf.tableView.reloadData()
        }) { (msg, code) in
            self.yxs_endingRefresh()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    /// 取消收藏
    /// - Parameter id: 收藏文章id
    func cancelCollect(articleId: Int) {
        if articleId != 0 {
            YXSEducationChildContentCollectionArticleModifyRequest.init(articleId: articleId).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                MBProgressHUD.yxs_showMessage(message: "取消收藏成功")
                weakSelf.dataSource.remove(at: weakSelf.currentIndex)
                weakSelf.tableView.deleteRows(at: [IndexPath.init(row: weakSelf.currentIndex, section: 0)], with: .left)
                if weakSelf.dataSource.count == 0 {
                    weakSelf.tableView.reloadData()
                }
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
    }
    
    // MARK: - tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSCollectArticleCell") as! YXSCollectArticleCell
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
            vc.isCache = true
//            vc.loadUrl = "http://192.168.10.157/yehw/index.html"
//            vc.loadUrl = "http://www.ym698.com/yehw/"
            vc.loadUrl = childContentUrl
            let dic = ["id":model.id ?? 0, "token":YXSPersonDataModel.sharePerson.token ?? "", "avatar":YXSPersonDataModel.sharePerson.userModel.avatar ?? "","name":YXSPersonDataModel.sharePerson.userModel.name ?? ""] as [String : Any]
            vc.scriptKey = dic.jsonString() ?? ""
            vc.title = "详情"
            self.navigationController?.pushViewController(vc)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = dataSource[indexPath.row]
            currentIndex = indexPath.row
            self.cancelCollect(articleId: model.id ?? 0)
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "取消收藏"
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
