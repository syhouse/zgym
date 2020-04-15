//
//  YXSSelectClassController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/18.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

import MBProgressHUD

class YXSSelectClassController: YXSBaseTableViewController {
    var isFriendSelectClass = false
    /// 只能选择单个班级
    var isSelectSingleClass: Bool = false
    
    var dataSource: [SLClassModel] = [SLClassModel](){
        didSet{
            if let selectClass = self.selectClass{
                for model in selectClass{
                    for dataModel in self.dataSource{
                        if dataModel.id == model.id{
                            dataModel.isSelect = true
                        }
                    }
                }
            }
        }
    }
    var selectBlock: ((_ selectClasss: [SLClassModel]) ->())?
    var selectClass: [SLClassModel]?
    init(_ selectClass:[SLClassModel]? = nil,dataSource: [SLClassModel]? = nil) {
        super.init()
        self.selectClass = selectClass
        showBegainRefresh = false
        hasRefreshHeader = false
        if let dataSource = dataSource{//初始化不调用didset
            self.setValue(dataSource, forKey: "dataSource")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        guard let dataSource = value as? [SLClassModel] else{
            return
        }
        self.dataSource = dataSource
    }
    
    // MARK: -leftCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择接收班级"
        
        tableView.register(YXSSelectClassCell.self, forCellReuseIdentifier: "YXSSelectClassCell")
        tableView.rowHeight = 72.5
        
        let rightButton = yxs_setRightButton(title: "确定",titleColor: kBlueColor)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightButton.addTarget(self, action: #selector(yxs_saveClick), for: .touchUpInside)
        
        if dataSource.count == 0 {
            yxs_loadPublishClassListData(isFriendSelectClass) { (classs) in
                self.dataSource = classs
                self.tableView.reloadData()
            }
        }
    }

    // MARK: -UI
    
    @objc func yxs_saveClick(){
        var selectclasss = [SLClassModel]()
        for model in dataSource{
            if model.isSelect{
                selectclasss.append(model)
            }
        }
        if selectclasss.count == 0{
            self.view.makeToast("未选择班级")
            return
        }
        selectBlock?(selectclasss)
        navigationController?.popViewController()
    }
    // MARK: -action
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSSelectClassCell") as! YXSSelectClassCell
        cell.selectionStyle = .none
        cell.isFriendSelectClass = isFriendSelectClass
        cell.yxs_setCellModel(dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (isFriendSelectClass && YXSPersonDataModel.sharePerson.personRole == .PARENT) || isSelectSingleClass{
            for model in dataSource{
                model.isSelect = false
            }
        }
        let model = dataSource[indexPath.row]
        model.isSelect = !model.isSelect
        tableView.reloadData()
//        tableView.reloadRows(at:[indexPath], with: .automatic)
    }
    
    
    // MARK: - getter&setter
}

