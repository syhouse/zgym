//
//  ClassScheduleCardListController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/27.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

import MBProgressHUD

class SLClassScheduleCardListController: SLBaseTableViewController {
    var dataSource: [SLClassScheduleCardModel] = [SLClassScheduleCardModel]()
    var childrenId: Int?
    var classId: Int?
    init(_ childrenId:Int?,classId: Int?) {
        super.init()
        self.classId = classId
        self.childrenId = childrenId
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    var isFriendSelectClass = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = SLPersonDataModel.sharePerson.personStage == StageType.KINDERGARTEN ? "食谱" : "课表"
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        tableView.register(SLClassScheduleCardCell.self, forCellReuseIdentifier: "SLClassScheduleCardCell")
        tableView.rowHeight = 84
    }
    
    override func sl_refreshData() {
        loadData()
    }
    
    override func sl_loadNextPage() {
        loadData()
    }
    
    func loadData() {
        var request: SLBaseRequset!
        if SLPersonDataModel.sharePerson.personRole == .TEACHER{
            request = SLEducationClassScheduleCardTeacherClassScheduleCardListRequest.init(currentPage: curruntPage, stage: SLPersonDataModel.sharePerson.personStage,classId:classId)
        }else{
            request = SLEducationClassScheduleCardParentsClassScheduleCardListRequest.init(currentPage: curruntPage, stage: SLPersonDataModel.sharePerson.personStage,childrenId: childrenId,classId:classId)
        }
        request.requestCollection({ (list:[SLClassScheduleCardModel]) in
        if self.curruntPage == 1{
            self.dataSource.removeAll()
        }

        self.dataSource += list

        self.loadMore = list.count == kPageSize
        self.tableView.reloadData()
        self.sl_endingRefresh()
        }) { (msg, code) in
            self.sl_endingRefresh()
            self.view.makeToast("\(msg)")
        }
    }
    
    // MARK: -UI
    
    // MARK: -action
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SLClassScheduleCardCell") as! SLClassScheduleCardCell
        cell.selectionStyle = .none
        cell.sl_setCellModel(dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        let vc = SLClassScheduleCardDetialController.init(model)
        vc.updateBlock = {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.reloadData()
        }
        navigationController?.pushViewController(vc)
    }
}

