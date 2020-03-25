//
//  SLPunchCardMembersListViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/2.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import ObjectMapper

class SLPunchCardMembersListViewController: SLBaseTableViewController{//SLHomeworkCommitListViewController {
    let clockInId: Int
    let classId: Int
    /// 当前选中按钮
    var curruntHeaderIndex: Int = 0
    var calendarModel: CalendarModel?
    var punchModel: SLPunchCardModel?
    var clockInList = [SLPunchCardChildModel]()
    var unClockInList = [SLPunchCardChildModel]()

    var dataSource = [[SLPunchCardChildModel](), [SLPunchCardChildModel]()]
    var buttonTitles = ["已打卡", "未打卡"]
    init(clockInId: Int,classId: Int, calendarModel: CalendarModel? = nil , punchM: SLPunchCardModel? = nil) {
        self.clockInId = clockInId
        self.classId = classId
        self.calendarModel = calendarModel
        self.punchModel = punchM
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "打卡名单"
        // Do any additional setup after loading the view.
        
        self.tableView.register(SLHomeworkReadListSectionHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: "SLHomeworkReadListSectionHeader")
        self.tableView.register(SLHomeworkCommitListCell.classForCoder(), forCellReuseIdentifier: "SLHomeworkCommitListCell")
    }
    
    override func sl_refreshData() {
        loadData()
    }
    
    func loadData(){
        var startTime: String? = nil
         var endTime:String? = nil
         if let calendarModel = calendarModel{
             startTime = calendarModel.startTime
             endTime = calendarModel.endTime
         }
        SLEducationClockInTeacherStaffListRequest.init(clockInId: clockInId,startTime: startTime,endTime: endTime).request({ (result) in
            self.sl_endingRefresh()
            self.clockInList = Mapper<SLPunchCardChildModel>().mapArray(JSONObject: result["clockInList"].object) ?? [SLPunchCardChildModel]()
            self.unClockInList = Mapper<SLPunchCardChildModel>().mapArray(JSONObject: result["unClockInList"].object) ?? [SLPunchCardChildModel]()
           
            if SLPersonDataModel.sharePerson.personRole == .TEACHER{
                self.dataSource = [self.unClockInList, self.clockInList]
                self.buttonTitles = ["未打卡（\(self.unClockInList.count)）","已打卡（\(self.clockInList.count)）"]
            }else{
                self.dataSource = [self.clockInList, self.unClockInList]
                self.buttonTitles = ["已打卡（\(self.clockInList.count)）","未打卡（\(self.unClockInList.count)）"]
            }
            self.tableView.reloadData()
        }) { (msg, code) in
            self.sl_endingRefresh()
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    @objc func reminderRequest() {
        var childrenIdList:[Int] = [Int]()
        for model in unClockInList{
            childrenIdList.append(model.childrenId ?? 0)
        }
        MBProgressHUD.sl_showLoading()
        SLEducationTeacherOneTouchReminderRequest(childrenIdList: childrenIdList, classId: classId, opFlag: 1, serviceId: clockInId, serviceType: 2).request({ (result) in
            MBProgressHUD.sl_showMessage(message: "通知成功")
            
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[curruntHeaderIndex].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SLHomeworkCommitListCell = tableView.dequeueReusableCell(withIdentifier: "SLHomeworkCommitListCell") as! SLHomeworkCommitListCell
        let model = dataSource[curruntHeaderIndex][indexPath.row]
        cell.lbName.text = "\(model.realName ?? "")"
        cell.imgAvatar.sd_setImage(with: URL.init(string: model.avatar ?? ""),placeholderImage: kImageUserIconStudentDefualtImage, completed: nil)
        cell.chatBlock = {[weak self] in
            guard let strongSelf = self else { return }
            UIUtil.sl_chatImRequest(childrenId: model.childrenId ?? 0 , classId: strongSelf.classId)
        }
        cell.phoneBlock = {[weak self] in
            guard let strongSelf = self else { return }
            UIUtil.sl_callPhoneNumberRequest(childrenId: model.childrenId ?? 0 , classId: strongSelf.classId)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: SLHomeworkReadListSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SLHomeworkReadListSectionHeader") as! SLHomeworkReadListSectionHeader
        header.selectedBlock = {[weak self](selectedIndex) in
            guard let strongSelf = self else { return }
            strongSelf.curruntHeaderIndex = selectedIndex
            strongSelf.tableView.reloadData()
        }
        header.alertClick = {[weak self](_) in
            guard let strongSelf = self else { return }
            strongSelf.reminderRequest()
        }
        header.btnTitle2.setTitle(buttonTitles[1], for: .normal)
        header.btnTitle1.setTitle(buttonTitles[0], for: .normal)
        if SLPersonDataModel.sharePerson.personRole == .TEACHER && punchModel?.state != 100 && curruntHeaderIndex == 0{
            header.btnAlert.isHidden = false
        } else {
            header.btnAlert.isHidden = true
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
