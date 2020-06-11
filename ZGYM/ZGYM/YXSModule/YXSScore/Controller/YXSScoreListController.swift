//
//  YXSScoreListController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2020/1/17.
//  Copyright © 2020 zgjy_mac. All rights reserved.
//  成绩列表

import UIKit
import NightNight
import ObjectMapper

class YXSScoreListController: YXSBaseTableViewController{
    private var dataSource: [YXSScoreListModel] = [YXSScoreListModel]()

    var currentChildrenId: Int = NSObject.init().yxs_user.currentChild?.id ?? 0
    var currentClassId: Int = NSObject.init().yxs_user.currentChild?.classId ?? 0
    init(classId: Int = NSObject.init().yxs_user.currentChild?.classId ?? 0, childId: Int = NSObject.init().yxs_user.currentChild?.id ?? 0) {
        super.init()
        currentChildrenId = childId
        currentClassId = classId
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "成绩"
        self.tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F4F5FC"), night: kNightBackgroundColor)
        self.scrollView.snp.remakeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.register(YXSScoreListCell.self, forCellReuseIdentifier: "YXSScoreListCell")
        
        ///发布按钮先隐藏  下个版本开出来
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            view.addSubview(publishButton)
            publishButton.snp.makeConstraints { (make) in
                make.right.equalTo(-15)
                make.bottom.equalTo(-kTabBottomHeight - 15)
                make.size.equalTo(CGSize.init(width: 51.5, height: 51.5))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
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
//        self.yxs_endingRefresh()
//        self.tableView.reloadData()
        var request: YXSBaseRequset!
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            request = YXSEducationScoreTeacherListRequest.init(currentPage: currentPage, classId: currentClassId)
        }else{
            request = YXSEducationScoreParentListRequest.init(currentPage: currentPage, childrenId: currentChildrenId, classId: currentClassId)
        }
        request.request({ [weak self](json) in
            guard let weakSelf = self else {return}
            weakSelf.yxs_endingRefresh()
            let joinList = Mapper<YXSScoreListModel>().mapArray(JSONObject: json["list"].object) ?? [YXSScoreListModel]()
            if weakSelf.currentPage == 1{
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
    
    // MARK: - Action
    func readScoreModel(index: Int) {
        let model = dataSource[index]
        YXSEducationReadingScoreRequest.init(childrenId: currentChildrenId, examId: model.examId ?? 0).request({ (json) in
            MBProgressHUD.yxs_showMessage(message: "已阅读")
            model.isRead = true
            self.tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: UITableView.RowAnimation.automatic)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    @objc func yxs_publishClick() {
        let popView = YXSScorePublishView.init(frame: CGRect(x: 0, y: 0, width: 260*SCREEN_SCALE, height: 305*SCREEN_SCALE))
        popView.showIn(target: UIUtil.RootController().view)
    }
    
    // MARK: - tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSScoreListCell") as! YXSScoreListCell
        if dataSource.count > indexPath.row {
            let model = dataSource[indexPath.row]
            cell.setModel(model: model)
            cell.cellBlock = { [weak self](cellModel)in
                guard let weakSelf = self else {return}
                weakSelf.readScoreModel(index: indexPath.row)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if dataSource.count > indexPath.row {
            let model = dataSource[indexPath.row]
            if let strategy = model.calculativeStrategy, strategy == 10 {
                /// 分数制
                if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                    let detail = YXSScoreNumTeacherDetailsVC.init(model: model)
                    self.navigationController?.pushViewController(detail)
                } else {
                    let detail = YXSScoreNumParentDetailsVC.init(model: model)
                    detail.examId = model.examId ?? 0
                    detail.childrenId = NSObject.init().yxs_user.currentChild?.id ?? 0
                    self.navigationController?.pushViewController(detail)
                }
            } else {
                /// 等级制
                if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                    let detail = YXSScoreLevelTeacherDetailsVC.init(model: model)
                    self.navigationController?.pushViewController(detail)
                    
                } else {
                    let detail = YXSScoreLevelParentDetailsVC.init(model: model)
                    detail.examId = model.examId ?? 0
                    detail.childrenId = NSObject.init().yxs_user.currentChild?.id ?? 0
                    self.navigationController?.pushViewController(detail)
                }
            }
            
            
        }
    }
    
    // MARK: -列表为空
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    override func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 10
    }
    
    override func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "暂无成绩"
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: CGFloat(18)),
                          NSAttributedString.Key.foregroundColor: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")]
        return NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
    }
    override func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return  NightNight.theme == .night ?  UIImage.init(named: "yxs_empty_classScheduleCard") : UIImage.init(named: "yxs_empty_classScheduleCard_night")
    }
    
    
    // MARK: - LazyLoad
    lazy var publishButton: YXSButton = {
        let button = YXSButton()
        button.setBackgroundImage(UIImage.init(named: "publish"), for: .normal)
        button.addTarget(self, action: #selector(yxs_publishClick), for: .touchUpInside)
        return button
    }()
}
