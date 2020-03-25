//
//  SLPunchCardSingleStudentList.swift
//  ZGYM
//
//  Created by sy_mac on 2020/2/25.
//  Copyright © 2020 hmym. All rights reserved.
//


import UIKit
import FDFullscreenPopGesture_Bell
import NightNight

class SLPunchCardSingleStudentListController: SLBaseTableViewController {
    var punchTopResponseModel: ClockInListTopResponseList
    let clockInId: Int
    var dataSource: [PunchCardPublishListModel] = [PunchCardPublishListModel]()
    init(punchTopResponseModel model: ClockInListTopResponseList,clockInId: Int) {
        self.punchTopResponseModel = model
        self.clockInId = clockInId
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = punchTopResponseModel.realName ?? ""
        view.backgroundColor = UIColor.white
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 277.5
        tableView.register(SLPunchCardSingleStudentListCell.self, forCellReuseIdentifier: "SLPunchCardSingleStudentListCell")
        tableView.sectionFooterHeight = 0.0
        tableView.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 20))
        loadData()
    }
    
    // MARK: -UI
    
    override func sl_onBackClick() {
        super.sl_onBackClick()
        SLSSAudioPlayer.sharedInstance.stopVoice()
    }
    
    // MARK: -loadData
    override func sl_refreshData() {
        loadData()
    }
    
    override func sl_loadNextPage() {
        loadData()
    }

    func loadData(){
        SLEducationClockInSingleChildCommitListPageRequest.init(childrenId: punchTopResponseModel.childrenId ?? 0, clockInId: clockInId, currentPage: curruntPage).requestCollection({ (list:[PunchCardPublishListModel]) in
            if self.curruntPage == 1{
                self.dataSource.removeAll()
            }
            self.dataSource += list
            self.loadMore = list.count == kPageSize
            self.tableView.reloadData()
            self.sl_endingRefresh()
        }) { (msg, code) in
            self.sl_endingRefresh()
        }
    }
    
    // MARK: -action
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count > 0 ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SLPunchCardSingleStudentListCell") as! SLPunchCardSingleStudentListCell
        cell.sl_setCellModel(dataSource[indexPath.row])
        cell.cellBlock = {
            [weak self] in
            guard let strongSelf = self else { return }
            UIView.performWithoutAnimation {
                strongSelf.tableView.reloadRows(at: [indexPath], with: .none)
                strongSelf.tableView.selectRow(at: indexPath, animated: false, scrollPosition:.middle)
            }
        }
        return cell
    }
    
    // MARK: -列表为空
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return showEmptyDataSource
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}


