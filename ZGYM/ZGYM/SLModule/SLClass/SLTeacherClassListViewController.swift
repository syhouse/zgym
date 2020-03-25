//
//  SLTeacherClassListViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/20.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper

class SLTeacherClassListViewController: SLBaseTableViewController {

    var createClassList: [SLClassModel] = [SLClassModel]()
    var joinClassList: [SLClassModel] = [SLClassModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "班级列表"
//        setupRightBarButtonItem()
        
        // Do any additional setup after loading the view.
        self.tableView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        
        self.tableView.register(SLTeacherClassListTableViewCell.classForCoder(), forCellReuseIdentifier: "SLTeacherClassListTableViewCell")
        self.tableView.register(TeacherClassListSectionHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: "TeacherClassListSectionHeader")
        self.tableView.tableHeaderView = self.headerView
    }
    
    func setupRightBarButtonItem() {
        let btnAdd = SLButton()
        btnAdd.setTitle("添加班级", for: .normal)
        btnAdd.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btnAdd.setMixedTitleColor(MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: kNight898F9A), forState: .normal)
        btnAdd.addTarget(self, action: #selector(navRightButtonClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btnAdd)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    override func sl_refreshData() {
        super.sl_refreshData()
        loadData()
    }
    
    // MARK: - Request
    func loadData() {
        SLEducationGradeListRequest().request({ [weak self](json) in
            guard let weakSelf = self else {return}
            weakSelf.joinClassList = Mapper<SLClassModel>().mapArray(JSONString: json["listJoin"].rawString()!) ?? [SLClassModel]()
            weakSelf.createClassList = Mapper<SLClassModel>().mapArray(JSONString: json["listCreate"].rawString()!) ?? [SLClassModel]()
            
            weakSelf.tableView.reloadData()
            weakSelf.checkEmptyData()
            weakSelf.sl_endingRefresh()
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_showMessage(message: msg)
            weakSelf.sl_endingRefresh()
        }
    }
    
    // MARK: - Action
    @objc func navRightButtonClick(sender: SLButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "创建班级", style: .default, handler: { (_) -> Void in
            self.createClass(sender: SLButton())
        }))
        
        alert.addAction(UIAlertAction(title: "加入班级", style: .default, handler: { (_) -> Void in
            self.joinClass(sender: SLButton())
        }))

        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    /// 加入
    @objc func joinClass(sender: SLButton) {
        let vc = SLClassAddController()
        navigationController?.pushViewController(vc)
    }
    
    /// 创建
    @objc func createClass(sender: SLButton) {
        let vc = SLClassCreateController()
        navigationController?.pushViewController(vc)
    }
    
    /// 邀请
    @objc func inviteClick(sender: SLButton) {
        let share = SLShareView(items: [.SLShareWechatFriendInvite, .SLShareQRcode]) { [weak self](item, type,view) in
            guard let weakSelf = self else {return}
            let model = weakSelf.createClassList[sender.tag]
            
            if type == .SLShareQRcode {
                let vc = SLInviteViewController(gradeNum: model.num ?? "", gradeName: model.name ?? "", headmasterName: weakSelf.sl_user.name ?? "")
                weakSelf.navigationController?.pushViewController(vc)
                
            } else {
                let request = HMRequestShareModel(gradeNum: model.num ?? "", gradeName: model.name ?? "", headmasterName: weakSelf.sl_user.name ?? "")
                MBProgressHUD.sl_showLoading()
                SLEducationShareLinkRequest(model: request).request({ (json) in
                    MBProgressHUD.sl_hideHUD()
                    let shareModel = SLShareModel(title: "优学生", descriptionText: "收到\(weakSelf.sl_user.name ?? "")发来的入班邀请。", link: json.stringValue)
                    shareModel.way = .WXSession
                    SLShareTool.share(model: shareModel)
                    
                }) { (msg, code) in
                    MBProgressHUD.sl_showMessage(message: msg)
                }

            }
            view.cancelClick()
        }
        share.showIn(target: self.view)
    }
    
    // MARK: - Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return createClassList.count
        } else {
            return joinClassList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model: SLClassModel
        if indexPath.section == 0 {
            model = createClassList[indexPath.row]
        } else {
            model = joinClassList[indexPath.row]
        }
        
        let cell:SLTeacherClassListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SLTeacherClassListTableViewCell") as! SLTeacherClassListTableViewCell
        cell.lbTitle.text = model.name
        cell.lbClassNumber.text = "班级号：\(model.num!)"
        cell.lbStudentCount.text = "成员：\(model.members ?? 0)"
        cell.btnInvite.isHidden = indexPath.section == 0 ? false : true
        if indexPath.section == 0 {
            cell.btnInvite.tag = indexPath.row
            cell.btnInvite.addTarget(self, action: #selector(inviteClick(sender:)), for: .touchUpInside)

            cell.lbTitle.snp.remakeConstraints({ (make) in
                make.bottom.equalTo(cell.contentView.snp_centerY).offset(-5)
                make.left.equalTo(15)
                make.right.equalTo(cell.btnInvite.snp_left).offset(-15)
            })

        } else {
            cell.lbTitle.snp.remakeConstraints({ (make) in
                make.bottom.equalTo(cell.contentView.snp_centerY).offset(-5)
                make.left.equalTo(15)
                make.right.equalTo(-15)
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0 && createClassList.count > 0) {
            return 45
            
        } else if (section == 1 && joinClassList.count > 0) {
            return 45
            
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: TeacherClassListSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TeacherClassListSectionHeader") as! TeacherClassListSectionHeader
        if section == 0 {
            header.lbTitle.text = "我创建的"
        } else {
            header.lbTitle.text = "我加入的"
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: SLClassModel
        if indexPath.section == 0 {
            model = createClassList[indexPath.row]
            
        } else {
            model = joinClassList[indexPath.row]
        }
        
        let vc = SLClassDetialListController.init(classModel: model)
        vc.navRightBarButtonTitle = indexPath.section == 0 ? "班级管理":"班级信息"
        navigationController?.pushViewController(vc)
    }
    
    // MARK: - LazyLoad
    lazy var headerView: TeacherClassListHeaderView = {
        let view = TeacherClassListHeaderView()
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 130)
        view.btnJoin.addTarget(self, action: #selector(joinClass(sender:)), for: .touchUpInside)
        view.btnCreate.addTarget(self, action: #selector(createClass(sender:)), for: .touchUpInside)
        return view
    }()
    
    // MARK: - Other
    @objc func checkEmptyData() {
        if (createClassList.count == 0) && (joinClassList.count == 0) {

            let footer = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
            let imageView = UIImageView()
            imageView.mixedImage = MixedImage(normal: "sl_defultImage_nodata", night: "sl_defultImage_nodata_night")
            imageView.contentMode = .scaleAspectFit
            footer.addSubview(imageView)
            imageView.snp.makeConstraints({ (make) in
                make.edges.equalTo(0)
            })
            self.tableView.tableFooterView = footer
            
        } else {
            self.tableView.tableFooterView = nil
        }
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

class TeacherClassListHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        self.addSubview(self.btnJoin)
        self.addSubview(self.btnCreate)
        
        self.btnJoin.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.centerX.equalTo(self.snp_centerX).offset(-87)
            make.width.equalTo(64)
        })
        
        self.btnCreate.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.centerX.equalTo(self.snp_centerX).offset(87)
            make.width.equalTo(64)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LazyLoad
    lazy var btnJoin: SLCustomImageControl = {
        let btn = SLCustomImageControl(imageSize: CGSize(width: 45, height: 45), position: SLImagePositionType.top, padding: 15)
        btn.title = "加入班级"
        btn.mixedImage = MixedImage(normal: "sl_class_join", night: "sl_class_join_night")
        btn.mixedTextColor = MixedColor(normal: k575A60Color, night: kNightFFFFFF)
        btn.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    
    lazy var btnCreate: SLCustomImageControl = {
        let btn = SLCustomImageControl(imageSize: CGSize(width: 45, height: 45), position: SLImagePositionType.top, padding: 15)
        btn.title = "创建班级"
        btn.mixedImage = MixedImage(normal: "sl_class_create", night: "sl_class_create_night")
        btn.mixedTextColor = MixedColor(normal: k575A60Color, night: kNightFFFFFF)
        btn.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
}


class TeacherClassListSectionHeader: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        self.contentView.addSubview(self.lbTitle)
        self.lbTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(15)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var lbTitle: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
}
