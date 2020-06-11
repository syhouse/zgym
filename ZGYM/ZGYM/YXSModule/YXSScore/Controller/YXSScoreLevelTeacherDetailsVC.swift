//
//  YXSScoreLevelTeacherDetailsVC.swift
//  ZGYM
//
//  Created by yihao on 2020/6/8.
//  Copyright © 2020 zgym. All rights reserved.
//  等级制老师详情

import Foundation
import NightNight
import FDFullscreenPopGesture_Bell
import ObjectMapper

class YXSScoreLevelTeacherDetailsVC: YXSBaseTableViewController {
    private var dataSource: [YXSScoreChildListModel] = [YXSScoreChildListModel]()
    var listModel: YXSScoreListModel?
    init(model:YXSScoreListModel) {
        super.init()
        self.listModel = model
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCicle
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.yxs_gradualBackground(frame: view.frame, startColor: UIColor.yxs_hexToAdecimalColor(hex: "#B4C8FD"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#A9CDFD"), cornerRadius: 0,isRightOrientation: false)
        tableView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#A9CDFD")
        customNav.title = listModel?.examName
        self.fd_prefersNavigationBarHidden = true
        self.scrollView.snp.remakeConstraints { (make) in
            make.edges.equalTo(0)
        }
        view.addSubview(customNav)
        customNav.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }
        if #available(iOS 11.0, *){
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        //去除group空白
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.estimatedRowHeight = 0
        tableView.register(YXSScoreLevelTeacherListCell.self, forCellReuseIdentifier: "YXSScoreLevelTeacherListCell")
        tableView.tableHeaderView = self.tableHeaderView
        if let dateStr = listModel?.creationTime, dateStr.count > 0 {
            self.tableHeaderView.headerExmTimeLbl.text = "发布时间：\(dateStr.yxs_Date().toString(format: .custom("yyyy/MM/dd")))"
        }
        self.tableHeaderView.headerClassNameLbl.text = listModel?.className
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    // MARK: -loadData
    override func yxs_refreshData() {
        currentPage = 1
        loadData()
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    func loadData(){
        YXSEducationScoreLevelChildDetailsListRequset.init(examId: listModel?.examId ?? 0, currentPage: currentPage).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            weakSelf.yxs_endingRefresh()
            let joinList = Mapper<YXSScoreChildListModel>().mapArray(JSONObject: json["list"].object) ?? [YXSScoreChildListModel]()
            if weakSelf.currentPage == 1{
                weakSelf.dataSource.removeAll()
            }
            weakSelf.dataSource += joinList
            weakSelf.loadMore = json["hasNext"].boolValue
            weakSelf.tableView.reloadData()
            weakSelf.tableHeaderView.isHidden = false
        }) { (msg, code) in
            self.yxs_endingRefresh()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSScoreLevelTeacherListCell") as! YXSScoreLevelTeacherListCell
        cell.selectionStyle = .none
        if dataSource.count > indexPath.row {
            let model = dataSource[indexPath.row]
            if indexPath.row == (dataSource.count - 1) {
                cell.setModel(model: model, isNeedCorners: true)
            } else {
                cell.setModel(model: model)
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource.count > indexPath.row {
            let model = dataSource[indexPath.row]
            let vc = YXSScoreLevelParentDetailsVC.init(childModel: model)
            vc.examId = self.listModel?.examId ?? 0
            vc.childrenId = model.childrenId ?? 0
            self.navigationController?.pushViewController(vc)
        }
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
    
    // MARK: - getter&stter
    lazy var customNav: YXSCustomNav = {
        let customNav = YXSCustomNav()
        customNav.leftImage = "back"
        customNav.titleLabel.textColor = kTextMainBodyColor
        customNav.hasRightButton = false
        customNav.backgroundColor = UIColor.clear
        return customNav
    }()
    
    lazy var tableHeaderView: YXSScoreLevelTeacherTableHeaderView = {
        let view = YXSScoreLevelTeacherTableHeaderView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 242 + 19))
        view.isHidden = true
        return view
    }()
    
}

extension YXSScoreLevelTeacherDetailsVC{
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
extension YXSScoreLevelTeacherDetailsVC: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:
            break
        }
    }
}

class YXSScoreLevelTeacherTableHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerBgImageV)
        addSubview(headerView)
        addSubview(bottomView)
        addSubview(leftConnectionImgV)
        addSubview(rightConnectionImgV)
        headerBgImageV.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(242)
        }
        headerView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(headerBgImageV.snp_bottom).offset(-16)
            make.height.equalTo(75)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(headerView.snp_bottom).offset(10)
            make.height.equalTo(25)
        }
        leftConnectionImgV.snp.makeConstraints { (make) in
            make.left.equalTo(headerView.snp_left).offset(15)
            make.top.equalTo(headerView.snp_top).offset(33)
            make.width.equalTo(10)
            make.height.equalTo(75)
        }
        rightConnectionImgV.snp.makeConstraints { (make) in
            make.right.equalTo(headerView.snp_right).offset(-15)
            make.top.equalTo(leftConnectionImgV)
            make.width.height.equalTo(leftConnectionImgV)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var headerBgImageV: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage.init(named: "yxs_score_detailsHear")
        return imgV
    }()
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.addSubview(self.headerClassNameLbl)
        view.addSubview(self.headerExmTimeLbl)
        self.headerClassNameLbl.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.top.equalTo(17)
            make.height.equalTo(20)
        }
        self.headerExmTimeLbl.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.bottom.equalTo(-17)
            make.height.equalTo(20)
        }
        
        return view
    }()
    
    lazy var leftConnectionImgV: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage.init(named: "yxs_score_detailsConnect")
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
    
    lazy var rightConnectionImgV: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage.init(named: "yxs_score_detailsConnect")
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
    
    /// 班级名称
    lazy var headerClassNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")
        return lbl
    }()
    /// 发布时间
    lazy var headerExmTimeLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return lbl
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        view.yxs_addRoundedCorners(corners: [.topLeft,.topRight], radii: CGSize.init(width: 5, height: 5), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 15 - 15, height:25))
        return view
    }()
}
