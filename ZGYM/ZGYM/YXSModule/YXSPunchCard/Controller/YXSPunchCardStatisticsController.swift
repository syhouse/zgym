//
//  YXSPunchCardStatisticsController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/2.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSPunchCardStatisticsController: YXSBaseTableViewController {
    // MARK: - property
    let yxs_punchCardModel: YXSPunchCardModel
    var yxs_statisticsModel :YXSPunchCardStatisticsModel!
    var yxs_dataSource: [YXSClockInListTopResponseList]{
        get{
            if let statisticsModel = self.yxs_statisticsModel{
                return statisticsModel.clockInListTopResponseList ?? [YXSClockInListTopResponseList]()
            }
            return [YXSClockInListTopResponseList]()
        }
    }
    
    // MARK: - init
    init(punchCardModel: YXSPunchCardModel) {
        self.yxs_punchCardModel = punchCardModel
        super.init()
        tableViewIsGroup = true
        showBegainRefresh = false
        hasRefreshHeader = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = YXSPersonDataModel.sharePerson.personRole == PersonRole.PARENT ? "打卡排行" : "打卡统计"

        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        
        yxs_tableHeaderView.layoutIfNeeded();
        let height = yxs_tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        yxs_tableHeaderView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height )
        tableView.tableHeaderView = yxs_tableHeaderView
        
        tableView.rowHeight = 61.5
        tableView.register(YXSPunchCardStatisticsCell.self, forCellReuseIdentifier: "YXSPunchCardStatisticsCell")
//        tableHeaderView.setHeaderModel()
        
        tableView.sectionFooterHeight = 0.0
        tableView.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 20))
        
        
        loadData()
    }
    
    // MARK: -UI

    // MARK: -loadData
    
    func loadData(){
        YXSEducationClockInTeacherPunchStatisticsRequest.init(clockInId: yxs_punchCardModel.clockInId ?? 0).request({ (result:YXSPunchCardStatisticsModel) in
            self.yxs_statisticsModel = result
            self.yxs_tableHeaderView.setHeaderModel(self.yxs_statisticsModel)
            self.tableView.reloadData()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: -action
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yxs_dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSPunchCardStatisticsCell") as! YXSPunchCardStatisticsCell
        cell.yxs_setCellModel(yxs_dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = yxs_dataSource[indexPath.row]
        let vc = YXSPunchCardSingleStudentBaseListController.init(isMyPublish: yxs_punchCardModel.promulgator ?? false, type: .studentPunchCardList,clockInId: yxs_punchCardModel.clockInId ?? 0, childrenId: model.childrenId ?? 0, classId: yxs_punchCardModel.classId ?? 0, top3Model: nil)
        vc.title = model.realName
        self.navigationController?.pushViewController(vc)
    }
    
    
    // MARK: - getter&setter
    lazy var yxs_tableHeaderView: YXSPunchCardStatisticsHeaderView = {
        let tableHeaderView = YXSPunchCardStatisticsHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 178))
        return tableHeaderView
    }()
}

// MARK: -HMRouterEventProtocol
extension YXSPunchCardStatisticsController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:
            break
        }
    }
}


// MARK: - other func
extension YXSPunchCardStatisticsController{
    func yxs_dealPunchCardStatisticsListUI() {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "PunchCardStatistics"
    }
    
    func yxs_changePunchCardStatisticsListUI(_ cancelled: Bool) {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "PunchCardStatistics"
    }
    
    func yxs_addPunchCardStatisticsListUI() {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "PunchCardStatistics"
    }
    
    func yxs_removePunchCardStatisticsListUI() {
        let view = UITextField()
        view.keyboardType = UIKeyboardType.numberPad
        view.leftViewMode = UITextField.ViewMode.always
        view.layer.cornerRadius = 5
        view.font = UIFont.systemFont(ofSize: 14)
        let leftView = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        leftView.font = UIFont.systemFont(ofSize: 14)
        leftView.text = "PunchCardStatistics"
        leftView.textAlignment = NSTextAlignment.center
        view.leftView = leftView
    }
}

