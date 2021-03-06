//
//  YXSClassQueryListController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/21.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import MBProgressHUD
import NightNight

class YXSClassQueryListController: YXSBaseTableViewController {
    var dataSource: [YXSClassQueryResultModel] = [YXSClassQueryResultModel]()
    var gradeId: Int{
        get{
            return dataSource.first?.id ?? 0
        }
    }
    
    init(_ model: YXSClassQueryResultModel) {
        super.init()
        showBegainRefresh = false
        hasRefreshHeader = false
        dataSource.append(model)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "查到结果"
        view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        tableView.register(ClassQueryListCell.self, forCellReuseIdentifier: "ClassQueryListCell")
        tableView.rowHeight = 90
        tableView.isScrollEnabled = false
    }
    // MARK: -loadData
    func loadChildList(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        YXSEducationGradeMemberChildrenListRequest.init(gradeId: gradeId).requestCollection({ (list:[YXSChildrenModel]) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.hasLoadChilds = true
            if list.count > 0{
                self.childs = list
                self.showSelectChildView()
            }else{
                self.navigationController?.pushViewController(YXSClassAddInfoController.init(false, gradeId: self.gradeId, stage: self.stage))
            }
            
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast("\(msg)")
        }
    }
    func loadJoinRequest(_ model: YXSChildrenModel){
        MBProgressHUD.yxs_showLoading()
        YXSEducationGradeMemberJoinRequest.init(gradeId: gradeId, position:PersonRole.PARENT,childrenId: model.id ?? 0).request({ (result) in
            MBProgressHUD.yxs_hideHUD()
            YXSCommonAlertView.showAlert(title: "提示", message: "加入班级成功！", rightTitle: "确认", rightClick: {
                for  vc in self.navigationController!.viewControllers{
                    if vc is YXSRegisterSucessController{
                        let popVc = vc as! YXSRegisterSucessController
                        self.navigationController?.popToViewController(popVc, animated: true)
                        popVc.yxs_successToRootVC()
                        break
                        
                    }else if vc is YXSTeacherClassListViewController{
                        let popVc = vc as! YXSTeacherClassListViewController
                        popVc.yxs_refreshData()
                        self.navigationController?.popToViewController(popVc, animated: true)
                        break
                    }else if vc is YXSParentClassListViewController{
                        let popVc = vc as! YXSParentClassListViewController
                        popVc.yxs_refreshData()
                        self.navigationController?.popToViewController(popVc, animated: true)
                        break
                    }
                }
            })
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: -UI
    var stage: StageType{
        return StageType.init(rawValue: self.dataSource.first?.stage ?? "") ?? .KINDERGARTEN
    }
    var hasLoadChilds: Bool = false
    var childs: [YXSChildrenModel]!
    // MARK: -action
    func selectChildAction(){
        if hasLoadChilds{
            if self.childs?.count ?? 0 > 0{
                showSelectChildView()
            }else{
                self.navigationController?.pushViewController(YXSClassAddInfoController.init(false, gradeId: self.gradeId, stage: stage))
            }
        }else{
            loadChildList()
        }
    }
    
    func showSelectChildView(){
        YXSClassSelectChildView.showAlert(childs: childs, leftClick: {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.pushViewController(YXSClassAddInfoController.init(false,gradeId: strongSelf.gradeId, stage:  strongSelf.stage))
        }) {[weak self]( model) in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.pushViewController(YXSClassAddInfoController.init(false,gradeId: strongSelf.gradeId, stage: strongSelf.stage,childModel: model))
        }
    }
    
    
    func clickJoinEvent(){
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            selectChildAction()
        }else{
            //老师可以选择家长
//            YXSClassSelectRoleView.showAlert { [weak self](isSelectTeacher) in
//                guard let strongSelf = self else { return }
//                if isSelectTeacher {
//                    strongSelf.navigationController?.pushViewController(SLClassAddInfoController.init(isSelectTeacher,gradeId: strongSelf.gradeId))
//                }else{
//                    strongSelf.selectChildAction()
//                }
//            }
            self.navigationController?.pushViewController(YXSClassAddInfoController.init(true,gradeId: gradeId, stage:  stage))
           
        }
        
    }
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassQueryListCell") as! ClassQueryListCell
        cell.yxs_setCellModel(dataSource[indexPath.row])
        cell.cellBlock = {[weak self]() in
            guard let strongSelf = self else { return }
            strongSelf.clickJoinEvent()
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    // MARK: - getter&setter
    
}

class ClassQueryListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        contentView.addSubview(classLabel)
        contentView.addSubview(createLabel)
        contentView.addSubview(schoolLabel)
        contentView.addSubview(joinButton)
        
        
        classLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(joinButton.snp_left).offset(-15)
            make.top.equalTo(15)
        }
        createLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.equalTo(classLabel.snp_bottom).offset(11.5)
        }
        
        schoolLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.equalTo(createLabel.snp_bottom).offset(7)
        }
        joinButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 89, height: 31))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: YXSClassQueryResultModel!
    func yxs_setCellModel(_ model: YXSClassQueryResultModel){
        classLabel.text = model.name
        createLabel.text = "创建人：\(model.headmasterName ?? "")"
        schoolLabel.text = "学校：\(model.school ?? "")"
    }
    var cellBlock: (() ->())?
    // MARK: -action
    @objc func joinClick(){
        cellBlock?()
    }
    
    // MARK: -getter&setter
    lazy var classLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return label
    }()
    
    lazy var createLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return label
    }()
    
    lazy var schoolLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return label
    }()
    
    lazy var joinButton: YXSButton = {
        let button = YXSButton.init()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15.5
        button.setTitle("立即加入", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = kBlueColor.cgColor
        button.setTitleColor(kBlueColor, for: .normal)
        button.addTarget(self, action: #selector(joinClick), for: .touchUpInside)
        return button
    }()
    
}
