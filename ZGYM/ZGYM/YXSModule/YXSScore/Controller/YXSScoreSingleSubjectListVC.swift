//
//  YXSScoreSingleSubjectListVC.swift
//  ZGYM
//
//  Created by yihao on 2020/6/5.
//  Copyright © 2020 zgym. All rights reserved.
//  孩子单科成绩分布列表

import Foundation
import NightNight
import ObjectMapper

class YXSScoreSingleSubjectListVC: YXSBaseTableViewController {
    private var dataSource: [YXSScoreChildSingleReportModel] = [YXSScoreChildSingleReportModel]()
    var listModel: YXSScoreChildListModel?
    var currentChildrenId: Int = 0
    var currentExamId: Int = 0
    
    init(examId: Int, childId: Int) {
        super.init()
        currentChildrenId = childId
        currentExamId = examId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true
        view.addSubview(customNav)
        customNav.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }
        if #available(iOS 11.0, *){
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
            self.tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        tableView.estimatedSectionHeaderHeight = 0
        //去除group空白
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.estimatedRowHeight = 0
        customNav.title = "单科成绩分布情况"
        self.scrollView.snp.remakeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.backgroundView = bgView
        tableView.register(YXSScoreSingleSubjectListCell.self, forCellReuseIdentifier: "YXSScoreSingleSubjectListCell")
        tableView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#B4C8FD")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    // MARK: -loadData
    override func yxs_refreshData() {
        loadData()
    }
    
    func loadData(){
        YXSEducationChildScoreSingleReport.init(examId: self.currentExamId, childrenId: self.currentChildrenId).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            weakSelf.yxs_endingRefresh()
            let joinModel = Mapper<YXSScoreChildListModel>().map(JSONObject: json.object) ?? YXSScoreChildListModel.init(JSON: ["":""])!
            weakSelf.listModel = joinModel
            weakSelf.dataSource.removeAll()
            weakSelf.dataSource = joinModel.statisticsParentChildScoreSingleReportResponseList ?? [YXSScoreChildSingleReportModel]()
            weakSelf.tableView.reloadData()
        }) { (msg, code) in
            self.yxs_endingRefresh()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSScoreSingleSubjectListCell") as! YXSScoreSingleSubjectListCell
        if dataSource.count > indexPath.row {
            cell.listModel = self.listModel
            cell.index = indexPath.row
            cell.setModel(model: dataSource[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    
    // MARK: -列表为空
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    override func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 10
    }
    
    // MARK: - LazyLoad
    lazy var customNav: YXSCustomNav = {
        let customNav = YXSCustomNav()
        customNav.leftImage = "back"
        customNav.titleLabel.textColor = kTextMainBodyColor
        customNav.hasRightButton = false
        customNav.backgroundColor = UIColor.clear
        return customNav
    }()
    
    lazy var bgView: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        let imageV = UIImageView.init(frame: CGRect(x: 0, y: -22, width: SCREEN_WIDTH, height: 242))
        imageV.image = UIImage.init(named: "yxs_score_detailsHear_one")
        imageV.contentMode = .scaleAspectFit
        view.addSubview(imageV)
        return view
    }()
    
    lazy var headerBgImageView: UIImageView = {
        let imageV = UIImageView.init(frame: CGRect(x: 0, y: -20, width: SCREEN_WIDTH, height: 242))
        imageV.image = UIImage.init(named: "yxs_score_detailsHear_one")
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
}

extension YXSScoreSingleSubjectListVC{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0{
            customNav.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
            customNav.backImageButton.setMixedImage(MixedImage(normal: "back", night: "yxs_back_white"), forState: .normal)
            customNav.titleLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        }else{
            customNav.mixedBackgroundColor = MixedColor(normal: UIColor.clear, night: UIColor.clear)
            customNav.backImageButton.setMixedImage(MixedImage(normal: "back", night: "back"), forState: .normal)
            customNav.titleLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kTextMainBodyColor)
        }
    }
}


// MARK: -HMRouterEventProtocol
extension YXSScoreSingleSubjectListVC: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:
            break
        }
    }
}
