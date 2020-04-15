//
//  SLFriendsCircleInfoController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/17.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class SLFriendsCircleInfoController: YXSBaseTableViewController {
    var userId: Int
    var childId :Int?
    var type :String
    var SLFriendCircleUserInfoModel: SLFriendCircleUserInfoModel!
    var dataSource = [SLFriendsCircleInfoCellModel]()
    init(userId: Int, childId: Int?, type :String) {
        self.childId = childId
        self.userId = userId
        self.type = type
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
        
        title = "个人信息"
        setupRightBarButtonItem()
        
        
        view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        tableView.rowHeight = 49
        tableView.register(SLFriendsCircleInfoCell.self, forCellReuseIdentifier: "SLFriendsCircleInfoCell")
        tableView.sectionFooterHeight = 0.0
        tableView.sectionHeaderHeight = 0.0
        
        tableFooterView.addSubview(callButton)
        tableFooterView.addSubview(chatButton)
        callButton.snp.makeConstraints { (make) in
            make.top.equalTo(33)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        chatButton.snp.makeConstraints { (make) in
            make.top.equalTo(callButton.snp_bottom).offset(10)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        loadData()
    }
    
    func setupRightBarButtonItem() {
        let btnComplaint = YXSButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        btnComplaint.setMixedImage(MixedImage(normal: "yxs_class_complaint", night: "yxs_class_complaint_night"), forState: .normal)
        btnComplaint.setMixedImage(MixedImage(normal: "yxs_class_complaint", night: "yxs_class_complaint_night"), forState: .highlighted)
        btnComplaint.addTarget(self, action: #selector(yxs_complaintClick), for: .touchUpInside)
        let navShareItem = UIBarButtonItem(customView: btnComplaint)
        self.navigationItem.rightBarButtonItem = navShareItem
    }
    
    // MARK: -UI
    var curruntStudent: YXSChildrenModel?
    func yxs_changeUI(){
        dataSource.removeAll()
        if let children = SLFriendCircleUserInfoModel.children{
            for model in children{
                if model.id == childId{
                    curruntStudent = model
                    break
                }
            }
            
            if let curruntStudent = curruntStudent{
                //家长修改学号 先不做
                dataSource.append(SLFriendsCircleInfoCellModel.init(type: .name, leftText: "孩子名", canEdit: false,rightText: curruntStudent.realName))
                if curruntStudent.headmaster ?? false && YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                    dataSource.append(SLFriendsCircleInfoCellModel.init(type: .studentId, leftText: "学号", canEdit: true,rightText: curruntStudent.studentId))
                    dataSource.append(SLFriendsCircleInfoCellModel.init(type: .exitClass, leftText: "请出班级", canEdit: true,rightText: nil))
                }else{
                    dataSource.append(SLFriendsCircleInfoCellModel.init(type: .studentId, leftText: "学号", canEdit: false,rightText: curruntStudent.studentId))
                }
            }
        }
        tableHeaderView.layoutIfNeeded()
        self.tableHeaderView.setHeaderModel(self.SLFriendCircleUserInfoModel)
        let height = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        tableHeaderView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height )
        tableView.tableHeaderView = tableHeaderView
        //家长也可以联系人
//        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
//
//        }
        tableView.tableFooterView = tableFooterView
        self.tableView.reloadData()
    }
    // MARK: -loadData
    func yxs_loadOutData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        YXSEducationGradeOutRequest.init(gradeId: curruntStudent?.classId ?? 0, uid: userId, childrenId: curruntStudent?.id ?? 0).request({ [weak self](result) in
            guard let weakSelf = self else {return}
            MBProgressHUD.hide(for: weakSelf.view, animated: false)
            MBProgressHUD.yxs_showMessage(message: "请出成功")
            weakSelf.curruntStudent?.headmaster = false
            weakSelf.yxs_changeUI()
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            MBProgressHUD.hide(for: weakSelf.view, animated: false)
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    func loadData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        YXSEducationClassCircleUserInfoRequest.init(id: userId, type: type).request({ [weak self](result: SLFriendCircleUserInfoModel) in
            guard let weakSelf = self else {return}
            weakSelf.SLFriendCircleUserInfoModel = result
            weakSelf.yxs_changeUI()
            MBProgressHUD.hide(for: weakSelf.view, animated: false)
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            MBProgressHUD.hide(for: weakSelf.view, animated: false)
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: -action
    @objc func yxs_complaintClick() {
        self.navigationController?.pushViewController(YXSComplaintOptionsViewController(respondentId: SLFriendCircleUserInfoModel.id ?? 0, respondentType: SLFriendCircleUserInfoModel.type ?? ""))
    }
    
    @objc func yxs_callClick(){
        if SLFriendCircleUserInfoModel.account ?? "" == yxs_user.account{
            MBProgressHUD.yxs_showMessage(message: "不能呼叫自己")
            return
        }
        let alert = YXSCommonAlertView.showAlert(title: "", message: "\(SLFriendCircleUserInfoModel.account ?? "")", leftTitle: "取消", leftClick: nil, rightTitle: "呼叫", rightClick: {
            [weak self] in
            guard let strongSelf = self else { return }
            let phone = "telprompt://" + "\(strongSelf.SLFriendCircleUserInfoModel.account ?? "")"
            if UIApplication.shared.canOpenURL(URL(string: phone)!) {
                 UIApplication.shared.openURL(URL(string: phone)!)
             }
        })
        UIUtil.yxs_setLabelAttributed(alert.messageLabel, text: ["是否呼叫", "  \(SLFriendCircleUserInfoModel.account ?? "")"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#575A60"),kTextMainBodyColor])
        alert.beginAnimation()
        
    }
    
    @objc func chatClick(){
        if SLFriendCircleUserInfoModel.account ?? "" == yxs_user.account{
            MBProgressHUD.yxs_showMessage(message: "不能私聊自己")
            return
        }
        UIUtil.TopViewController().yxs_pushChatVC(imId: SLFriendCircleUserInfoModel.imid ?? "")
        
    }
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SLFriendsCircleInfoCell") as! SLFriendsCircleInfoCell
        cell.setCellInfo(dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        switch model.type {
        case .studentId:
            if model.canEdit{
                let vc = YXSProfileChildrenViewController()
                vc.sucess = {[weak self](studentId) in
                    
                    guard let strongSelf = self else { return }
                    strongSelf.curruntStudent?.studentId = studentId
                    strongSelf.yxs_changeUI()
                }
                self.navigationController?.pushViewController(vc)
            }
        case .exitClass:
            YXSCommonAlertView.showAlert(title: "确定要请出？", message: "", rightClick: {
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.yxs_loadOutData()
            })
        default:
            break
        }
    }
    
    
    // MARK: - getter&setter
    lazy var tableHeaderView: SLFriendCircleInfoHeaderView = {
        let tableHeaderView = SLFriendCircleInfoHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        return tableHeaderView
    }()
    
    lazy var tableFooterView: UIView = {
        let tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 141))
        return tableFooterView
    }()
    
    lazy var callButton: YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(kBlueColor, for: .normal)
        button.setTitle("打电话", for: .normal)
        button.setImage(UIImage.init(named: "yxs_friend_circle_phone"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        button.yxs_setIconInLeftWithSpacing(10)
        button.addTarget(self, action: #selector(yxs_callClick), for: .touchUpInside)
        return button
    }()
    
    lazy var chatButton: YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(kBlueColor, for: .normal)
        button.setTitle("发起私聊", for: .normal)
        button.setImage(UIImage.init(named: "yxs_friend_circle_chat"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        button.yxs_setIconInLeftWithSpacing(10)
        button.addTarget(self, action: #selector(chatClick), for: .touchUpInside)
        return button
    }()
}

// MARK: -HMRouterEventProtocol
extension SLFriendsCircleInfoController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kFriendCircleInfoHeaderDetialEvent:
            let vc = SLFriendsCircleController.init(userIdPublisher: userId,userType: type)
            vc.title = "TA的优成长"
            self.navigationController?.pushViewController(vc)
        default:
            break
        }
    }
}


