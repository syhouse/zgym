//
//  SLPunchCardMembersListViewController.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/2.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import ObjectMapper

class YXSPunchCardMembersListViewController: YXSBaseTableViewController{
    // MARK: - property

    let clockInId: Int
    let classId: Int
    /// 当前选中按钮
    var yxs_curruntHeaderIndex: Int = 0
    var yxs_calendarModel: YXSCalendarModel?
    var yxs_punchModel: YXSPunchCardModel?
    var yxs_clockInList = [YXSPunchCardChildModel]()
    var yxs_unyxs_clockInList = [YXSPunchCardChildModel]()

    var yxs_dataSource = [[YXSPunchCardChildModel](), [YXSPunchCardChildModel]()]
    var yxs_buttonTitles = ["已打卡", "未打卡"]
    // MARK: - init
    init(clockInId: Int,classId: Int, calendarModel: YXSCalendarModel? = nil , punchM: YXSPunchCardModel? = nil) {
        self.clockInId = clockInId
        self.classId = classId
        self.yxs_calendarModel = calendarModel
        self.yxs_punchModel = punchM
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "打卡名单"
        // Do any additional setup after loading the view.
        
        self.tableView.register(YXSHomeworkReadListSectionHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: "YXSHomeworkReadListSectionHeader")
        self.tableView.register(YXSHomeworkCommitListCell.classForCoder(), forCellReuseIdentifier: "SLHomeworkCommitListCell")
    }
    
    override func yxs_refreshData() {
        yxs_loadData()
    }
    
    func yxs_loadData(){
        var startTime: String? = nil
         var endTime:String? = nil
         if let calendarModel = yxs_calendarModel{
             startTime = calendarModel.startTime
             endTime = calendarModel.endTime
         }
        YXSEducationClockInTeacherStaffListRequest.init(clockInId: clockInId,startTime: startTime,endTime: endTime).request({ (result) in
            self.yxs_endingRefresh()
            self.yxs_clockInList = Mapper<YXSPunchCardChildModel>().mapArray(JSONObject: result["clockInList"].object) ?? [YXSPunchCardChildModel]()
            self.yxs_unyxs_clockInList = Mapper<YXSPunchCardChildModel>().mapArray(JSONObject: result["unClockInList"].object) ?? [YXSPunchCardChildModel]()
           
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                self.yxs_dataSource = [self.yxs_unyxs_clockInList, self.yxs_clockInList]
                self.yxs_buttonTitles = ["未打卡（\(self.yxs_unyxs_clockInList.count)）","已打卡（\(self.yxs_clockInList.count)）"]
            }else{
                self.yxs_dataSource = [self.yxs_clockInList, self.yxs_unyxs_clockInList]
                self.yxs_buttonTitles = ["已打卡（\(self.yxs_clockInList.count)）","未打卡（\(self.yxs_unyxs_clockInList.count)）"]
            }
            self.tableView.reloadData()
        }) { (msg, code) in
            self.yxs_endingRefresh()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    @objc func yxs_reminderRequest() {
        var childrenIdList:[Int] = [Int]()
        for model in yxs_unyxs_clockInList{
            childrenIdList.append(model.childrenId ?? 0)
        }
        MBProgressHUD.yxs_showLoading()
        YXSEducationTeacherOneTouchReminderRequest(childrenIdList: childrenIdList, classId: classId, opFlag: 1, serviceId: clockInId, serviceType: 2).request({ (result) in
            MBProgressHUD.yxs_showMessage(message: "通知成功")
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yxs_dataSource[yxs_curruntHeaderIndex].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:YXSHomeworkCommitListCell = tableView.dequeueReusableCell(withIdentifier: "SLHomeworkCommitListCell") as! YXSHomeworkCommitListCell
        let model = yxs_dataSource[yxs_curruntHeaderIndex][indexPath.row]
        cell.lbName.text = "\(model.realName ?? "")"
        cell.imgAvatar.sd_setImage(with: URL.init(string: model.avatar ?? ""),placeholderImage: kImageUserIconStudentDefualtImage, completed: nil)
        cell.chatBlock = {[weak self] in
            guard let strongSelf = self else { return }
            UIUtil.yxs_chatImRequest(childrenId: model.childrenId ?? 0 , classId: strongSelf.classId)
        }
        cell.phoneBlock = {[weak self] in
            guard let strongSelf = self else { return }
            UIUtil.yxs_callPhoneNumberRequest(childrenId: model.childrenId ?? 0 , classId: strongSelf.classId)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: YXSHomeworkReadListSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YXSHomeworkReadListSectionHeader") as! YXSHomeworkReadListSectionHeader
        header.selectedBlock = {[weak self](selectedIndex) in
            guard let strongSelf = self else { return }
            strongSelf.yxs_curruntHeaderIndex = selectedIndex
            strongSelf.tableView.reloadData()
        }
        header.alertClick = {[weak self](_) in
            guard let strongSelf = self else { return }
            strongSelf.yxs_reminderRequest()
        }
        header.btnTitle2.setTitle(yxs_buttonTitles[1], for: .normal)
        header.btnTitle1.setTitle(yxs_buttonTitles[0], for: .normal)
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER && yxs_punchModel?.state != 100 && yxs_curruntHeaderIndex == 0{
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

// MARK: - other func
extension YXSPunchCardMembersListViewController{
    func yxs_dealPunchCardMembersListUI() {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "PunchCardStatistics"
    }
    
    func yxs_changePunchCardMembersListUI(_ cancelled: Bool) {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "PunchCardStatistics"
    }
    
    func yxs_addPunchCardMembersListUI() {
        let view = UILabel(frame: CGRect.init(x: 0, y: 0, width: 130, height: 48))
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.red
        view.text = "PunchCardStatistics"
    }
    
    func yxs_removePunchCardMembersListUI() {
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


