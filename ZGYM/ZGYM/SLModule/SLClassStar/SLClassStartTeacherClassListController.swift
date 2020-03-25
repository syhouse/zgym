//
//  SLClassStartTeacherClassListController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/3.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight
import MBProgressHUD

class SLClassStartTeacherClassListController: SLBaseTableViewController {
    var dataSource: [SLClassStartClassModel] = [SLClassStartClassModel]()
    var classId: Int?
    var isPublish: Bool
    init(classId: Int? = nil, isPublish: Bool = false) {
        self.classId = classId
        self.isPublish = isPublish
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
        self.title = "班级之星"
        
        headerView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 114*SCREEN_SCALE)
        headerView.addSubview(topLabel)
        topLabel.snp.makeConstraints { (make) in
            make.left.equalTo(29)
            make.right.equalTo(-152*SCREEN_SCALE)
            make.centerY.equalTo(headerView)
        }
        UIUtil.sl_setLabelAttributed(topLabel, text: ["班级之星", "是学生德育培养的重要辅助功能，经常评价对家校共育有很好的帮助哦！"], colors: [UIColor.sl_hexToAdecimalColor(hex: "#FFF033"), UIColor.white])
        
        
        tableView.tableHeaderView = headerView
        
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        tableView.register(SLClassStartTeacherClassListCell.self, forCellReuseIdentifier: "SLClassStartTeacherClassListCell")
        tableView.rowHeight = 84
        
        tableView.sectionFooterHeight = 0.0
        tableView.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 20))
        
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name.init(rawValue: kUpdateClassStarScoreNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func loadData() {
        SLEducationClassStarTeacherClassTopRequest(classId: classId, stage: SLPersonDataModel.sharePerson.personStage, dateType: DateType.W).requestCollection({ (classs:[SLClassStartClassModel]) in
            self.dataSource = classs
            self.tableView.reloadData()
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SLClassStartTeacherClassListCell") as! SLClassStartTeacherClassListCell
        cell.selectionStyle = .none
        cell.sl_setCellModel(dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let classModel = dataSource[indexPath.row]
        if isPublish{
            let vc = SLClassStarTeacherPublishCommentController.init(model: classModel)
            navigationController?.pushViewController(vc)
        }else{
            let vc = SLClassStarSignleClassDetialController.init(classModel: classModel)
            navigationController?.pushViewController(vc)
        }
    }
    
    
    // MARK: - getter&setter
    
    lazy var headerView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "sl_classstar_teacher_list_bg"))
        return imageView
    }()
    
    lazy var topLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
}

