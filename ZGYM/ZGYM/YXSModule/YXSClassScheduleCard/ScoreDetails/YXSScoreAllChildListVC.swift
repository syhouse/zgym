//
//  YXSScoreAllChildListVC.swift
//  ZGYM
//
//  Created by yihao on 2020/6/3.
//  Copyright © 2020 zgym. All rights reserved.
//  老师查看全班孩子成绩

import Foundation
import NightNight
import ObjectMapper

class YXSScoreAllChildListVC: YXSBaseTableViewController {
    var dataSource: [YXSScoreChildListModel] = [YXSScoreChildListModel]()
    
    var detailsModel: YXSScoreDetailsModel?
    
    init(detailsModel: YXSScoreDetailsModel) {
        self.detailsModel = detailsModel
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "全班得分"
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        tableView.register(YXSScoreAllChildListCell.self, forCellReuseIdentifier: "YXSScoreAllChildListCell")
        self.tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F4F5FC"), night: kNightBackgroundColor)
        let tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        self.tableView.tableHeaderView = tableHeaderView
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        YXSEducationClassMemberListScoreRequest.init(examId: self.detailsModel?.examId ?? 0, currentPage: currentPage).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            weakSelf.yxs_endingRefresh()
            let joinList = Mapper<YXSScoreChildListModel>().mapArray(JSONObject: json["list"].object) ?? [YXSScoreChildListModel]()
            if weakSelf.currentPage == 1 {
               weakSelf.dataSource.removeAll()
            }
            weakSelf.dataSource += joinList
            weakSelf.loadMore = json["hasNext"].boolValue
            weakSelf.tableView.reloadData()
        }) { (msg, code) in
            self.yxs_endingRefresh()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSScoreAllChildListCell") as! YXSScoreAllChildListCell
        cell.selectionStyle = .none
        if dataSource.count > indexPath.row {
            let model = dataSource[indexPath.row]
            cell.setModel(model: model, index: indexPath.row + 1)
        }
        cell.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), leftMargin: 15, rightMargin: 0, lineHeight: 0.5)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource.count > indexPath.row {
            let model = dataSource[indexPath.row]
            let vc = YXSScoreNumParentDetailsVC.init(childModel: model)
            vc.examId = self.detailsModel?.examId ?? 0
            vc.childrenId = model.childrenId ?? 0
            self.navigationController?.pushViewController(vc)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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

