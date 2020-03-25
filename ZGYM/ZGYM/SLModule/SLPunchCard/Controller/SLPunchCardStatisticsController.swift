//
//  SLPunchCardStatisticsController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/2.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import FDFullscreenPopGesture_Bell


class SLPunchCardStatisticsController: SLBaseTableViewController {
    let punchCardModel: SLPunchCardModel
    var statisticsModel :SLPunchCardStatisticsModel!
    var dataSource: [ClockInListTopResponseList]{
        get{
            if let statisticsModel = self.statisticsModel{
                return statisticsModel.clockInListTopResponseList ?? [ClockInListTopResponseList]()
            }
            return [ClockInListTopResponseList]()
        }
    }
    init(punchCardModel: SLPunchCardModel) {
        self.punchCardModel = punchCardModel
        super.init()
        tableViewIsGroup = true
        showBegainRefresh = false
        hasRefreshHeader = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        
        view.addSubview(customNav)
        customNav.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }
        view.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#A9CBFF")
        tableView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#A9CBFF")
        
        tableHeaderView.layoutIfNeeded();
        let height = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        tableHeaderView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height )
        tableView.tableHeaderView = tableHeaderView
        
        tableView.rowHeight = 61.5
        tableView.register(SLPunchCardStatisticsCell.self, forCellReuseIdentifier: "SLPunchCardStatisticsCell")
//        tableHeaderView.setHeaderModel()
        
        tableView.sectionFooterHeight = 0.0
        tableView.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 20))
        
        
        loadData()
    }
    
    // MARK: -UI

    // MARK: -loadData
    
    func loadData(){
        SLEducationClockInTeacherPunchStatisticsRequest.init(clockInId: punchCardModel.clockInId ?? 0).request({ (result:SLPunchCardStatisticsModel) in
            self.statisticsModel = result
            self.tableHeaderView.setHeaderModel(self.statisticsModel)
            self.tableView.reloadData()
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: -action
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SLPunchCardStatisticsCell") as! SLPunchCardStatisticsCell
        cell.sl_setCellModel(dataSource[indexPath.row])
        cell.isLastRow = indexPath.row == dataSource.count - 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        let vc = SLPunchCardSingleStudentListController.init(punchTopResponseModel: model, clockInId: punchCardModel.clockInId ?? 0)
        self.navigationController?.pushViewController(vc)
    }
    
    
    // MARK: - getter&setter
    lazy var tableHeaderView: SLPunchCardStatisticsHeaderView = {
        let tableHeaderView = SLPunchCardStatisticsHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        return tableHeaderView
    }()
    
    lazy var customNav: SLCustomNav = {
        let customNav = SLCustomNav()
        customNav.title = SLPersonDataModel.sharePerson.personRole == PersonRole.PARENT ? "打卡排行" : "打卡统计"
        customNav.hasRightButton = false
        return customNav
    }()
}

extension SLPunchCardStatisticsController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > kSafeTopHeight + 64{
            customNav.backgroundColor = UIColor.white
        }else{
            customNav.backgroundColor = UIColor.clear
        }
    }
}

// MARK: -HMRouterEventProtocol
extension SLPunchCardStatisticsController: SLRouterEventProtocol{
    func sl_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kHMCustomNavBackEvent:
            sl_onBackClick()
        default:
            break
        }
    }
}


