//
//  ClassScheduleCardListController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/27.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

import MBProgressHUD

class YXSClassScheduleCardListController: YXSBaseTableViewController {
    var yxs_dataSource: [YXSClassScheduleCardModel] = [YXSClassScheduleCardModel]()
    var yxs_childrenId: Int?
    var yxs_classId: Int?
    init(_ yxs_childrenId:Int?,classId: Int?) {
        super.init()
        self.yxs_classId = classId
        self.yxs_childrenId = yxs_childrenId
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    var isFriendSelectClass = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = YXSPersonDataModel.sharePerson.personStage == StageType.KINDERGARTEN ? "食谱" : "课表"
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        tableView.register(YXSClassScheduleCardCell.self, forCellReuseIdentifier: "YXSClassScheduleCardCell")
        tableView.rowHeight = 84
    }
    
    override func yxs_refreshData() {
        yxs_loadData()
    }
    
    override func yxs_loadNextPage() {
        yxs_loadData()
    }
    
    func yxs_loadData() {
        var request: YXSBaseRequset!
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            request = YXSEducationClassScheduleCardTeacherClassScheduleCardListRequest.init(currentPage: curruntPage, stage: YXSPersonDataModel.sharePerson.personStage,classId:yxs_classId)
        }else{
            request = YXSEducationClassScheduleCardParentsClassScheduleCardListRequest.init(currentPage: curruntPage, stage: YXSPersonDataModel.sharePerson.personStage,childrenId: yxs_childrenId,classId:yxs_classId)
        }
        request.requestCollection({ (list:[YXSClassScheduleCardModel]) in
        if self.curruntPage == 1{
            self.yxs_dataSource.removeAll()
        }

        self.yxs_dataSource += list

        self.loadMore = list.count >= kPageSize
        self.tableView.reloadData()
        self.yxs_endingRefresh()
        }) { (msg, code) in
            self.yxs_endingRefresh()
            self.view.makeToast("\(msg)")
        }
    }
    
    // MARK: -UI
    
    // MARK: -action
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yxs_dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSClassScheduleCardCell") as! YXSClassScheduleCardCell
        cell.selectionStyle = .none
        cell.yxs_setCellModel(yxs_dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = yxs_dataSource[indexPath.row]
        let vc = YXSClassScheduleCardDetialController.init(model)
        vc.yxs_updateBlock = {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.reloadData()
        }
        navigationController?.pushViewController(vc)
    }
}

// MARK: - other func
extension YXSClassScheduleCardListController{
    func yxs_dealClassScheduleCardRootUI() {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "aaaaa"
    }
    
    func yxs_changeClassScheduleCardUI(_ cancelled: Bool) {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "ccccccc"
    }
    
    func yxs_addClassScheduleCardUI() {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "测试"
    }
}
