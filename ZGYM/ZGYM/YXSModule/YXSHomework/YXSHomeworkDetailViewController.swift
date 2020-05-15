//
//  YXSHomeworkDetailViewController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/25.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
import YYText
import ObjectMapper
import MJRefresh
import SDWebImage
import Popover

/// 作业未提交时候查看详情
class YXSHomeworkDetailViewController: YXSBaseViewController, UITableViewDelegate, UITableViewDataSource {

    /// 当前操作的 IndexPath
    var curruntIndexPath: IndexPath!
    
    var currentSection: Int = 0
    var currentIndexModel: YXSHomeworkDetailModel = YXSHomeworkDetailModel.init(JSON: ["":""])!
    var isModifyRemark: Bool = true
    
    /// 图片编辑涂鸦
    var graffitiSection: Int!
    var graffitiDetailModel: YXSHomeworkDetailModel!
    var graffitiImageIndex: Int!
    
    /// 是否下拉加载更多
    var loadMore: Bool = false{
        didSet{
            if self.loadMore{
                self.tableView.mj_footer = tableRefreshFooter
            }else{
                self.tableView.mj_footer = nil
                self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    public var topHistoryModel: YXSClassStarTopHistoryModel?{
        didSet{
            tableView.reloadData()
        }
    }
    var dataSource: [YXSHomeworkDetailModel] = [YXSHomeworkDetailModel]()
    var curruntPage: Int = 1
    var isGood: Int = -1
    var isRemark: Int = -1
    var homeModel:YXSHomeListModel
    //    var btnCommit: YXSButton?
    init(model: YXSHomeListModel) {
        self.homeModel = model
        UIUtil.yxs_reduceHomeRed(serviceId: model.serviceId ?? 0,childId: model.childrenId ?? 0)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ///移到点击按钮返回事件中去了
        YXSSSAudioListPlayer.sharedInstance.stopPlayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "作业详情"
        // Do any additional setup after loading the view.
        setupRightBarButtonItem()
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            footerRemindBtn.isHidden = true
        }
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.bottomBtnView)
        tableView.tableHeaderView = tableHeaderView
        tableView.register(YXSHomeworkDetailCell.self, forCellReuseIdentifier: "YXSHomeworkDetailCell")
        tableView.register(YXSHomeworkDetailSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "YXSHomeworkDetailSectionHeaderView")
        tableView.register(YXSPunchCardDetialTableFooterView.self, forHeaderFooterViewReuseIdentifier: "SLPunchCardDetialTableFooterView")

        tableHeaderView.pushToBlock = { [weak self]()in
            guard let weakSelf = self else {return}
            weakSelf.pushToContainer()
        }

        tableHeaderView.contactClickBlock = { [weak self]()in
            guard let weakSelf = self else {return}
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                UIUtil.yxs_chatImRequest(childrenId: weakSelf.homeModel.childrenId ?? 0, classId: weakSelf.model?.classId ?? 0)

            } else {
                weakSelf.yxs_pushChatVC(imId: weakSelf.model?.teacherImId ?? "")
            }
        }

        tableHeaderView.linkView.block = { (url) in
            let tmpStr = YXSObjcTool.shareInstance().getCompleteWebsite(url)
            var charSet = CharacterSet.urlQueryAllowed
            charSet.insert(charactersIn: "#")
            charSet.insert(charactersIn: "%")
            let newUrl = tmpStr.addingPercentEncoding(withAllowedCharacters: charSet)!
            UIApplication.shared.openURL(URL(string: newUrl)!)
        }

        tableHeaderView.filterBtnView.jobTypeChankBlock = { [weak self](tag) in
            guard let weakSelf = self else {return}
            switch tag {
            case 10001:
                //全部作业
                weakSelf.isGood = -1
                
                if weakSelf.isRemark == -1 {
                    weakSelf.footerContentLbl.text = "暂无作业提交"
                    weakSelf.footerRemindBtn.isHidden = false
                } else if weakSelf.isRemark == 0 {
                    weakSelf.footerContentLbl.text = "暂无待点评"
                    weakSelf.footerRemindBtn.isHidden = true
                } else {
                    weakSelf.footerContentLbl.text = "暂无已点评"
                    weakSelf.footerRemindBtn.isHidden = true
                }
            case 10002:
                //优秀作业
                weakSelf.isGood = 1
                weakSelf.footerRemindBtn.isHidden = true
                weakSelf.footerContentLbl.text = "暂无优秀作业"
            case 10003:
                //我的作业
                weakSelf.isGood = 0
                weakSelf.footerRemindBtn.isHidden = true
                weakSelf.footerContentLbl.text = "暂无作业提交"
            default:
                break
            }
            if YXSPersonDataModel.sharePerson.personRole == .PARENT {
                weakSelf.footerRemindBtn.isHidden = true
            }
            weakSelf.refreshHomeworkData(index: weakSelf.isGood)
//            weakSelf.refreshData()
        }

        tableHeaderView.filterBtnView.jobStatusChankBlock = { [weak self](sender) in
            guard let weakSelf = self else {return}
            let point = UIApplication.shared.keyWindow?.convert(weakSelf.tableHeaderView.filterBtnView.bounds.origin, to: weakSelf.tableHeaderView.filterBtnView)
            let offsetY = fabsf(Float(point!.y))
            YXSHomeListSelectView.showAlert(offset: CGPoint(x: 15, y: CGFloat(offsetY) + 50), selects: weakSelf.selectModels) { [weak self](selectModel,selectModels) in
                guard let strongSelf = self else { return }
                YXSSSAudioListPlayer.sharedInstance.stopPlayer()
                let selectType = SLCommonScreenSelectType.init(rawValue: selectModel.paramsKey) ?? .all
                if selectType == .toReview {
                    //待点评
                    strongSelf.isRemark = 0
                    weakSelf.footerContentLbl.text = "暂无待点评作业"
                    weakSelf.footerRemindBtn.isHidden = true
                } else if selectType == .haveComments {
                    //已点评
                    strongSelf.isRemark = 1
                    weakSelf.footerContentLbl.text = "暂无已点评作业"
                    weakSelf.footerRemindBtn.isHidden = true
                } else {
                    strongSelf.isRemark = -1
                    weakSelf.footerContentLbl.text = "暂无作业提交"
                    weakSelf.footerRemindBtn.isHidden = false
                }
                if YXSPersonDataModel.sharePerson.personRole == .PARENT {
                    weakSelf.footerRemindBtn.isHidden = true
                }
                weakSelf.refreshData()
            }
        }
        
        layout()
        self.model = YXSCacheHelper.yxs_getCachePublishHomeworkDetailTask(homeworkId: homeModel.serviceId ?? 0)
        self.dataSource = YXSCacheHelper.yxs_getCacheSubmitHomeworkDetailTask(homeworkId: homeModel.serviceId ?? 0, isGood: self.isGood, isRemark: self.isRemark)
        yxs_loadClassStarTopHistoryData()
        refreshData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(homeworkCommitSuccess(obj:)), name: NSNotification.Name(rawValue: kParentSubmitSucessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(homeworkUndoSuccess(obj:)), name: NSNotification.Name.init(rawValue: kOperationStudentWorkNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUnreadMessage), name: NSNotification.Name.init(rawValue: kChatCallRefreshHomeworkNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupRightBarButtonItem() {
        let btnShare = YXSButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        btnShare.setMixedImage(MixedImage(normal: "yxs_punchCard_share", night: "yxs_punchCard_share_white"), forState: .normal)
        btnShare.setMixedImage(MixedImage(normal: "yxs_punchCard_share", night: "yxs_punchCard_share_white"), forState: .highlighted)
        btnShare.addTarget(self, action: #selector(shareClick(sender:)), for: .touchUpInside)
        let navShareItem = UIBarButtonItem(customView: btnShare)
        
        self.navigationItem.rightBarButtonItems = [navShareItem]
        
    }

    func layout() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }

    }
    
    @objc func refreshLayout() {
        
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            self.tableView.snp.remakeConstraints { (make) in
                make.top.equalTo(0)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(self.bottomBtnView.snp_top)
            }
            bottomBtnView.isHidden = false
            bottomBtnView.snp.makeConstraints({ (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(0)
                make.height.equalTo(62)
            })
            if self.model?.isExpired ?? false {
                self.bottomBtnView.btnCommit.setTitle("当前作业已过期", for: .normal)
                self.bottomBtnView.btnCommit.setMixedTitleColor(MixedColor(normal: kNight898F9A, night: kNight898F9A), forState: .normal)
                self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
                bottomBtnView.isHidden = false
                bottomBtnView.isUserInteractionEnabled = false
            } else {
                if self.model?.onlineCommit == 1 {
                    if homeModel.commitState == 1 {
                        self.bottomBtnView.btnCommit.setTitle("提交作业", for: .normal)
                        self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 21)
                        self.bottomBtnView.btnCommit.setMixedTitleColor(MixedColor(normal: kNightFFFFFF, night: kNightFFFFFF), forState: .normal)
                        bottomBtnView.isUserInteractionEnabled = true
                    } else {
                        self.bottomBtnView.btnCommit.setTitle("已提交", for: .normal)
                        self.bottomBtnView.btnCommit.setMixedTitleColor(MixedColor(normal: kNight898F9A, night: kNight898F9A), forState: .normal)
                        self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
                        bottomBtnView.isUserInteractionEnabled = false
                    }
                } else {
                    self.bottomBtnView.btnCommit.setTitle("当前作业无需提交", for: .normal)
                    self.bottomBtnView.btnCommit.setMixedTitleColor(MixedColor(normal: kNight898F9A, night: kNight898F9A), forState: .normal)
                    self.bottomBtnView.btnCommit.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 21)
                    bottomBtnView.isUserInteractionEnabled = false
                    bottomBtnView.isHidden = false
                }
            }
            
        }
    }
    
    func refreshSelectModel() {
        self.selectModels = [YXSSelectModel.init(text: "全部", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),YXSSelectModel.init(text: "待点评", isSelect: false, paramsKey: SLCommonScreenSelectType.toReview.rawValue),YXSSelectModel.init(text: "已点评", isSelect: false, paramsKey: SLCommonScreenSelectType.haveComments.rawValue)]
        self.isRemark = -1
    }
    
    @objc func refreshHomeworkData(index:Int) {
        switch index {
        case -1: //全部作业
            YXSEducationHomeworkChildrenPageQueryRequest(currentPage: self.curruntPage, homeworkCreateTime: self.homeModel.createTime ?? "", homeworkId: self.homeModel.serviceId ?? 0, pageSize: 20, isGood: self.isGood, isRemark: self.isRemark).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                let joinList = Mapper<YXSHomeworkDetailModel>().mapArray(JSONObject: json["homeworkCommitList"].object) ?? [YXSHomeworkDetailModel]()
//                    for (index,model) in buttons.enumerated() {
                for join in joinList {
                    join.remarkVisible = weakSelf.model?.remarkVisible
                    join.teacherId = weakSelf.model?.teacherId
                    if let backImageUrl = join.backImageUrl, backImageUrl.count <= 0 {
                        join.backImageUrl = join.imageUrl
                    }
                }
                weakSelf.loadMore = json["hasNext"].boolValue
                if weakSelf.curruntPage == 1 {
                    weakSelf.dataSource.removeAll()
                }
                weakSelf.dataSource += joinList
                if weakSelf.dataSource.count == 0  && weakSelf.model?.onlineCommit == 1{
                    weakSelf.tableView.tableFooterView = weakSelf.tableFooterView
                } else {
                    weakSelf.tableView.tableFooterView = nil
                }
                YXSCacheHelper.yxs_cacheSubmitHomeworkDetailTask(data: weakSelf.dataSource, homeworkId: weakSelf.homeModel.serviceId ?? 0, isGood: weakSelf.isGood, isRemark: weakSelf.isRemark)
                weakSelf.tableView.reloadData()
            }, failureHandler: { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            })
            break
        case 1: //优秀作业
            self.refreshSelectModel()
            YXSEducationHomeworkChildrenPageQueryRequest(currentPage: self.curruntPage, homeworkCreateTime: self.homeModel.createTime ?? "", homeworkId: self.homeModel.serviceId ?? 0, pageSize: 20, isGood: self.isGood).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                let joinList = Mapper<YXSHomeworkDetailModel>().mapArray(JSONObject: json["homeworkCommitList"].object) ?? [YXSHomeworkDetailModel]()
//                    for (index,model) in buttons.enumerated() {
                for join in joinList {
                    join.remarkVisible = weakSelf.model?.remarkVisible
                    join.teacherId = weakSelf.model?.teacherId
                    if let backImageUrl = join.backImageUrl, backImageUrl.count <= 0 {
                        join.backImageUrl = join.imageUrl
                    }
                }
                weakSelf.loadMore = json["hasNext"].boolValue
                if weakSelf.curruntPage == 1 {
                    weakSelf.dataSource.removeAll()
                }
                weakSelf.dataSource += joinList
                if weakSelf.dataSource.count == 0 && weakSelf.model?.onlineCommit == 1{
                    weakSelf.tableView.tableFooterView = weakSelf.tableFooterView
                } else {
                    weakSelf.tableView.tableFooterView = nil
                }
                YXSCacheHelper.yxs_cacheSubmitHomeworkDetailTask(data: weakSelf.dataSource, homeworkId: weakSelf.homeModel.serviceId ?? 0, isGood: weakSelf.isGood, isRemark: weakSelf.isRemark)
                weakSelf.tableView.reloadData()
            }, failureHandler: { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            })
            break
        case 0: //我的作业
            //查询我的作业
            self.refreshSelectModel()
            YXSEducationHomeworkQueryHomeworkCommitByIdRequest(childrenId: self.yxs_user.curruntChild?.id ?? 0, homeworkCreateTime: self.homeModel.createTime ?? "", homeworkId: self.homeModel.serviceId ?? 0).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                if json.rawString() == "null" {
                    weakSelf.dataSource.removeAll()
                } else {
                    let model = Mapper<YXSHomeworkDetailModel>().map(JSONObject:json.object) ?? YXSHomeworkDetailModel.init(JSON: ["": ""])!
                    if let backImageUrl = model.backImageUrl, backImageUrl.count <= 0 {
                        model.backImageUrl = model.imageUrl
                    }
                    model.teacherId = weakSelf.model?.teacherId
                    model.remarkVisible = weakSelf.model?.remarkVisible
                    let joinList = [model]
                    weakSelf.dataSource.removeAll()
                    weakSelf.dataSource += joinList
                }
                weakSelf.loadMore = false
                if weakSelf.dataSource.count == 0 && weakSelf.model?.onlineCommit == 1{
                    weakSelf.tableView.tableFooterView = weakSelf.tableFooterView
                } else {
                    weakSelf.tableView.tableFooterView = nil
                }
                YXSCacheHelper.yxs_cacheSubmitHomeworkDetailTask(data: weakSelf.dataSource, homeworkId: weakSelf.homeModel.serviceId ?? 0, isGood: weakSelf.isGood, isRemark: weakSelf.isRemark)
                weakSelf.tableView.reloadData()
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
            break
        default:
            break
        }
    }
    
    @objc func refreshUnreadMessage() {
        self.refreshData(isRefreshList: true)
    }
    
    @objc func yxs_loadClassStarTopHistoryData(){
        if let data = UserDefaults.standard.object(forKey: "\(String(describing: self.homeModel.classId))") {
            let historyModel = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! YXSClassStarTopHistoryModel
            let endDate = Date.init(fromString: historyModel.endTime!, format: .custom("yyyy-MM-dd HH:mm:ss"))
            if let date = endDate {
                let isDiffer = date.yxs_dateByAddingDays(days: 7)?.yxs_dateByDeleteHour(hour: -4)?.yxs_CompareDiffer()
                if isDiffer ?? false{
                    self.topHistoryModel = historyModel
                    self.model?.topHistoryModel = topHistoryModel
                } else {
                    self.refreshHistoryData()
                }
            } else {
                self.refreshHistoryData()
            }
        } else {
            self.refreshHistoryData()
        }
    }
    
    func refreshHistoryData(){
        YXSEducationClassStarTopHistoryRequest.init(classId: self.homeModel.classId ?? 0).request({ (topHistoryModel: YXSClassStarTopHistoryModel) in
            self.topHistoryModel = topHistoryModel
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: topHistoryModel)
            UserDefaults.standard.set(encodedData, forKey: "\(String(describing: self.homeModel.classId))")
            UserDefaults.standard.synchronize()
            self.model?.topHistoryModel = topHistoryModel
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Request
    @objc func refreshData(isRefreshList: Bool = true) {
        MBProgressHUD.yxs_showLoading(ignore: true)
        
        YXSEducationHomeworkQueryHomeworkByIdRequest(childrenId: homeModel.childrenId ?? 0, homeworkCreateTime: homeModel.createTime ?? "", homeworkId: homeModel.serviceId ?? 0).request({ [weak self](model: YXSHomeworkDetailModel) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            weakSelf.tableViewRefreshHeader.endRefreshing()
            model.topHistoryModel = weakSelf.topHistoryModel
            weakSelf.model = model
            weakSelf.tableHeaderView.setModel(model: model)
            YXSCacheHelper.yxs_cachePublishHomeworkDetailTask(data: model, homeworkId: weakSelf.homeModel.serviceId ?? 0)
            if YXSPersonDataModel.sharePerson.personRole == .PARENT && weakSelf.homeModel.isRead != 1{
                /// 标记页面已读
                if !(weakSelf.model?.readList?.contains(weakSelf.homeModel.childrenId ?? 0) ?? false) {
                    let hModel = YXSHomeListModel(JSON: ["":""])
                    hModel?.serviceId = weakSelf.homeModel.serviceId
                    hModel?.childrenId = weakSelf.homeModel.childrenId
                    hModel?.createTime = weakSelf.homeModel.createTime
                    hModel?.serviceType = 1
                    UIUtil.yxs_loadReadData(hModel!)
                }
            }
            if isRefreshList {
                
                weakSelf.refreshHomeworkData(index: weakSelf.isGood)
            } else {
                weakSelf.tableView.reloadData()
            }
            
            
        }) { (msg, code) in
            self.tableViewRefreshHeader.endRefreshing()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    func yxs_loadNextPage(){
        self.refreshHomeworkData(index: self.isGood)
    }
    
    // MARK: - Setter
    var model: YXSHomeworkDetailModel? {
        didSet {
            checkHomeworkCommited()
            tableHeaderView.setModel(model: self.model!)
            tableView.tableHeaderView = tableHeaderView
            refreshLayout()
        }
    }
    
    
    // MARK: - Action
    @objc func shareClick(sender: YXSButton) {
        let model = HMRequestShareModel(homeworkId: homeModel.serviceId ?? 0, homeworkCreateTime: homeModel.createTime ?? "")
        MBProgressHUD.yxs_showLoading()
        YXSEducationShareLinkRequest(model: model).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            
            let strUrl = json.stringValue
            let title = "\(weakSelf.model?.teacherName ?? "")布置的作业!"
            let dsc = "\((weakSelf.model?.createTime ?? "").yxs_Date().toString(format: DateFormatType.custom("MM月dd日")))作业：\(weakSelf.model?.content ?? "")"
            
            let shareModel = YXSShareModel(title: title, descriptionText: dsc, link: strUrl)
            YXSShareTool.showCommonShare(shareModel: shareModel)
            
        }) { (msg, code ) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    @objc func voiceClick() {
        
    }
    
    @objc func moreClick(sender: YXSButton) {
        sender.isEnabled = false
        let title = model?.isTop == 0 ? "置顶" : "取消置顶"
        YXSSetTopAlertView.showIn(target: self.view, topButtonTitle:title) { [weak self](btn) in
            guard let weakSelf = self else {return}
            
            sender.isEnabled = true
            
            if btn.titleLabel?.text == title {
                let isTop = weakSelf.model?.isTop == 0 ? 1 : 0
                
                UIUtil.yxs_loadUpdateTopData(type: .homework, id: weakSelf.homeModel.serviceId ?? 0, createTime: weakSelf.model?.createTime ?? "", isTop: isTop, positon: .detial) {
                    weakSelf.model?.isTop = isTop
                }
            }
        }
    }
    
    /// 去提交
    @objc func goCommitClick(sender: YXSButton) {
        let vc = YXSHomeworkPublishController.init(homeModel)
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func alertClick(sender: YXSButton) {
        pushToContainer()
    }
    
    @objc func pushToContainer() {
        let vc = YXSHomeworkContainerViewController()
        vc.detailModel = self.homeModel
        vc.detailModel?.onlineCommit = model?.onlineCommit
        vc.backClickBlock = { [weak self]()in
            guard let weakSelf = self else {return}
            weakSelf.refreshData()
        }
        self.navigationController?.pushViewController(vc)
    }


    @objc func remindClick() {
        pushToContainer()
    }
    
    ///更新高度
    func updateHeaderHeight(){
        self.tableHeaderView.setModel(model: self.model!)
        self.tableView.tableHeaderView = self.tableHeaderView
    }
    
    // MARK: -点击展开刷新
    /// 点击展开刷新
    /// - Parameters:
    ///   - section: section
    ///   - isScroll: 是否滚动
    func showAllRefresh(section: Int, isScroll: Bool = false){
        var scroll = false
        let headerView = tableView.headerView(forSection: section)
        if let headerView = headerView, isScroll{
            let rc = tableView.convert(headerView.frame, to: self.view)
            SLLog(rc)
            if rc.minY < 0{
                scroll = true
            }
        }
        
        reloadTableView(section:section,scroll: scroll)
    }
    
    // MARK: -家长修改作业（修改或撤回）
    func parentModifyHomeworkWithModel(model: YXSHomeworkDetailModel, type: SLCommonScreenSelectType) {
        if type == .change {
            //修改
            let vc = YXSHomeworkPublishController.init(mySubmitModel: model, model: self.homeModel)
            vc.changeSubmitSucess = { (newModel) in
                self.dataSource[self.currentSection] = newModel
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc)
        } else if type == .recall {
            // 撤回
            let alert = UIAlertController.init(title: "提示", message: "您是否撤回该作业？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
                MBProgressHUD.yxs_showLoading()
                YXSEducationHomeworkStudentCancelRequest(childrenId: model.childrenId  ?? 0, homeworkCreateTime:self.homeModel.createTime ?? "" ,homeworkId:self.homeModel.serviceId  ?? 0).request({ (json) in
                    MBProgressHUD.yxs_hideHUD()
                    MBProgressHUD.yxs_showMessage(message: "删除作业成功")
                    self.homeModel.commitState = 1
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationStudentWorkNotification), object: [kNotificationModelKey: self.homeModel])
                    self.refreshData()
                }, failureHandler: { (msg, code) in
                    MBProgressHUD.yxs_showMessage(message: msg)
                })
            }))
            alert.popoverPresentationController?.sourceView = UIUtil.curruntNav().view
            UIUtil.curruntNav().present(alert, animated: true, completion: nil)
        }
        
    }
    
    // MARK: -老师修改点评（修改或撤回）
    func teacherModifyRemarkWithModel(model: YXSHomeworkDetailModel, type: SLCommonScreenSelectType) {
        if type == .change {
            // 修改
            let vc = YXSHomeworkCommentController()
            vc.isChangeRemark = true
            vc.initChangeReview(myReviewModel: model, model: self.homeModel)
            vc.childrenIdList = [(model.childrenId ?? 0)]
            //                        vc.isPop = true
            //点评成功后 刷新数据
            vc.commetCallBack = { (list)in
                self.refreshData()
            }
            self.navigationController?.pushViewController(vc)
        } else if type == .recall {
            // 撤回
            let alert = UIAlertController.init(title: "提示", message: "您是否撤回本条点评？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
                MBProgressHUD.yxs_showLoading()
                YXSEducationHomeworkRemarkCancel(homeworkId: self.homeModel.serviceId ?? 0, childrenId: model.childrenId ?? 0, homeworkCreateTime: self.homeModel.createTime ?? "").request({ (json) in
                    MBProgressHUD.yxs_hideHUD()
                    MBProgressHUD.yxs_showMessage(message: "删除点评成功")
                    self.refreshData()
                }, failureHandler: { (msg, code) in
                    MBProgressHUD.yxs_showMessage(message: msg)
                })
            }))
            alert.popoverPresentationController?.sourceView = UIUtil.curruntNav().view
            UIUtil.curruntNav().present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Other
    /// 检查推送进来 作业是否有提交 有提交则盖界面上来
    @objc func checkHomeworkCommited() {
        //        if (model?.committedList?.contains(homeModel.childrenId ?? 0) ?? false) {
        //            /// 已提交
        //            let notif = Notification(name: Notification.Name(rawValue: kParentSubmitSucessNotification), object: nil, userInfo: [kNotificationModelKey:homeModel])
        //            homeworkCommitSuccess(obj: notif)
        //            return
        //        }
    }


    /// 家长撤回作业成功通知
    @objc func homeworkUndoSuccess(obj:Notification?) {
        let userInfo = obj?.object as? [String: Any]
        if let model = userInfo?[kNotificationModelKey] as? YXSHomeListModel{
            if model.type == .homework {
                /// 刷新按钮
                homeModel.commitState = 1
                refreshLayout()
                refreshUnreadMessage()
            }
        }
    }

    /// 提交作业成功后 把界面盖上去
    @objc func homeworkCommitSuccess(obj:Notification?) {
        let userInfo = obj?.object as? [String: Any]
        if let model = userInfo?[kNotificationModelKey] as? YXSHomeListModel{
            if model.type == .homework {
                homeModel.commitState = 2
                self.refreshData()
                
                /// 刷新按钮
                refreshLayout()
                refreshUnreadMessage()
            }
        }
    }
    
    override func yxs_onBackClick() {
        if YXSPersonDataModel.sharePerson.personRole == .PARENT && self.model?.onlineCommit == 1 && homeModel.commitState == 1 && !(self.model?.isExpired ?? false){
            /// 未提交
            YXSCommonAlertView.showAlert(title: "", message: "当前作业需要提交,是否提交作业", leftTitle: "退出", leftClick: { [weak self] in
                guard let weakSelf = self else {return}
                weakSelf.navigationController?.popViewController()
                
                YXSSSAudioListPlayer.sharedInstance.stopPlayer()
                
                }, rightTitle: "去提交", rightClick: { [weak self] in
                    guard let weakSelf = self else {return}
                    let vc = YXSHomeworkPublishController.init(weakSelf.homeModel)
                    weakSelf.navigationController?.pushViewController(vc)
                    
                }, superView: self.navigationController?.view)
            
        } else {
            super.yxs_onBackClick()
        }
    }
    
    func showComment(_ commentModel: YXSHomeworkCommentModel? = nil, section: Int){
        if commentModel?.isMyComment ?? false{
            return
        }
        let tips = commentModel == nil ? "评论：" : "回复\(commentModel!.showUserName ?? "")："
        YXSFriendsCommentAlert.showAlert(tips, maxCount: 400) { [weak self](content) in
            guard let strongSelf = self else { return }
            strongSelf.loadCommentData(section, content: content!, commentModel: commentModel)
        }
    }
    
    func showDelectComment(_ commentModel: YXSHomeworkCommentModel,_ point: CGPoint, section: Int){
        var pointInView = point
        if let curruntIndexPath = self.curruntIndexPath{
            let cell = self.tableView.cellForRow(at: curruntIndexPath)
            if let listCell  = cell as? YXSHomeworkDetailCell{
                let rc = listCell.convert(listCell.comentLabel.frame, to: UIUtil.curruntNav().view)
                pointInView.y = rc.minY + 14.0
            }
        }
        YXSFriendsCircleDelectCommentView.showAlert(pointInView) {
            [weak self]in
            guard let strongSelf = self else { return }
            strongSelf.loadDelectCommentData(section, commentModel: commentModel)
        }
    }
    
    func loadCommentData(_ section: Int = 0,content: String,commentModel: YXSHomeworkCommentModel?){
        let listModel = dataSource[section]
        
        var requset: YXSBaseRequset!
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            if let commentModel = commentModel{
                requset = YXSEducationHomeworkCommentRequest.init(childrenId: listModel.childrenId ?? 0, homeworkCreateTime: self.homeModel.createTime!, content: content, homeworkId: self.homeModel.serviceId ?? 0, type: "REPLY" ,id: commentModel.id ?? 0)
            }else{
                requset = YXSEducationHomeworkCommentRequest.init(childrenId: listModel.childrenId ?? 0, homeworkCreateTime: self.homeModel.createTime!, content: content, homeworkId: self.homeModel.serviceId ?? 0, type: "COMMENT" )
            }
        }else{
            if let commentModel = commentModel{
                requset = YXSEducationHomeworkCommentRequest.init(childrenId: listModel.childrenId ?? 0, homeworkCreateTime: self.homeModel.createTime!, content: content, homeworkId: self.homeModel.serviceId ?? 0, type: "REPLY" ,id: commentModel.id ?? 0)
                
            }else{
                requset = YXSEducationHomeworkCommentRequest.init(childrenId: listModel.childrenId ?? 0, homeworkCreateTime: self.homeModel.createTime!, content: content, homeworkId: self.homeModel.serviceId ?? 0, type: "COMMENT" )
            }
        }
        requset.request({ (model:YXSHomeworkCommentModel) in
            if listModel.commentJsonList != nil {
                listModel.commentJsonList?.append(model)
            }else{
                listModel.commentJsonList = [model]
            }
            self.reloadTableViewToScrollComment(section: section)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
    }
    
    func loadDelectCommentData(_ section: Int = 0,commentModel: YXSHomeworkCommentModel){
        let listModel = dataSource[section]
        
        var requset: YXSBaseRequset!
        requset = YXSEducationHomeworkCommentDeleteRequest.init(childrenId: listModel.childrenId ?? 0, homeworkCreateTime: self.homeModel.createTime!, homeworkId: self.homeModel.serviceId ?? 0, id: commentModel.id ?? 0)
        requset.request({ (result) in
            if let curruntIndexPath  = self.curruntIndexPath{
                listModel.commentJsonList?.remove(at: curruntIndexPath.row)
            }
            self.reloadTableView(section: section, scroll: false)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
    }
    
    //    _ section: Int
    func reloadTableView(section: Int? = nil, scroll: Bool = false){
        UIView.performWithoutAnimation {
            if let section = section{
                let offset = tableView.contentOffset
                tableView.reloadSections(IndexSet.init(arrayLiteral: section), with: UITableView.RowAnimation.none)
                if !scroll{//为什会会跳动 why
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
                          self.tableView.setContentOffset(offset, animated: false)
                      }
                }
            }else{
                tableView.reloadData()
            }
            tableView.reloadData()
        }
        
        if let section = section,scroll{
            tableView.selectRow(at: IndexPath.init(row: 0, section: section), animated: false, scrollPosition: .top)
        }
        
    }
    
    /// 点评滚动居中
    /// - Parameter section: section
    func reloadTableViewToScrollComment(section: Int){
        //                none
        let model = self.dataSource[section]
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet.init(arrayLiteral: section), with: UITableView.RowAnimation.none)
            let count: Int? = model.commentJsonList?.count
            //是否需要点评滚动居中 (当前处于收起点评状态不滚动)
            if let count = count,count > 0 && !(model.isNeeedShowCommentAllButton && !model.isShowCommentAll){
                tableView.selectRow(at: IndexPath.init(row: count - 1, section: section), animated: false, scrollPosition: .middle)
            }
        }
        
    }
    
    
    func setHomeworkGoodEvent(_ section: Int,isGood: Int){
        let model = dataSource[section]
        YXSEducationHomeworkInTeacherChangeGoodRequest.init(childrenId: model.childrenId ?? 0, homeworkCreateTime: self.homeModel.createTime!, homeworkId: self.homeModel.serviceId ?? 0, isGood: isGood).request({ (result) in
            
            if isGood == 1{
                //设置优秀作业不刷新页面
                model.isGood = 1
                self.refreshData(isRefreshList: false)
                
            } else {
                if self.isGood != -1 {
                    self.dataSource.remove(at: section)
                    if self.dataSource.count == 0 {
                        self.tableView.tableFooterView = self.tableFooterView
                    } else {
                        self.tableView.tableFooterView = nil
                    }
                }
                self.refreshData()
//                self.refreshHomeworkData(index: self.isGood)
            }
            
            
            
//            self.reloadTableView()
            
        }) { (msg, code) in
            if isGood == 1{
                model.isGood = 0
            } else {
                model.isGood = 1
            }
            self.tableView.reloadData()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    /// 老师清除还原被涂鸦的图片
    /// - Parameter urlStr: 需要还原的原始图片地址
    func clearGraffitiRequest(urlStr: String) {
        YXSEducationHomeworkCancelPaintingRequest.init(childrenId: self.graffitiDetailModel.childrenId ?? 0, homeworkCreateTime: self.homeModel.createTime!, homeworkId: self.homeModel.serviceId ?? 0, cancelIndex: self.graffitiImageIndex).request({ [weak self](json) in
            guard let weakSelf = self else { return }
            if weakSelf.dataSource.count > weakSelf.graffitiSection {
                let model = weakSelf.dataSource[weakSelf.graffitiSection]
                if model.imgs.count > weakSelf.graffitiImageIndex {
                    let img = YXSFriendsMediaModel.init(url: urlStr, type: .serviceImg)
                    model.showImages[weakSelf.graffitiImageIndex] = img
                    weakSelf.tableView.reloadSections(IndexSet.init(arrayLiteral: weakSelf.graffitiSection), with: UITableView.RowAnimation.none)
                    MBProgressHUD.yxs_showMessage(message: "清除涂鸦成功")
                }
            }
            weakSelf.clearGraffitiData()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
            self.clearGraffitiData()
        }
    }
    
    /// 老师涂鸦作业
    /// - Parameter urlStr: 涂鸦后的图片地址
    func graffitiRequest(urlStr: String) {
        YXSEducationHomeworkPaintingRequest.init(childrenId: self.graffitiDetailModel.childrenId ?? 0, homeworkCreateTime: self.homeModel.createTime!, homeworkId: self.homeModel.serviceId ?? 0, paintingImageUrl: urlStr, replaceIndex: self.graffitiImageIndex).request({ [weak self](json) in
            guard let weakSelf = self else { return }
            if weakSelf.dataSource.count > weakSelf.graffitiSection {
                let model = weakSelf.dataSource[weakSelf.graffitiSection]
                if model.imgs.count > weakSelf.graffitiImageIndex {
                    let img = YXSFriendsMediaModel.init(url: urlStr, type: .serviceImg)
                    model.showImages[weakSelf.graffitiImageIndex] = img
                    weakSelf.tableView.reloadSections(IndexSet.init(arrayLiteral: weakSelf.graffitiSection), with: UITableView.RowAnimation.none)
                }
            }
            weakSelf.clearGraffitiData()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
            self.clearGraffitiData()
        }
    }
    
    // MARK: - tableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count > section {
            let model = dataSource[section]
            if let comments = model.commentJsonList {
                var commentsCount = comments.count
                if model.isNeeedShowCommentAllButton && !model.isShowCommentAll{
                    commentsCount = 3
                }
                return  commentsCount
            }
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSHomeworkDetailCell") as! YXSHomeworkDetailCell
        cell.selectionStyle = .none
        let model = dataSource[indexPath.section]
        if let comments = model.commentJsonList{
            if indexPath.row < comments.count{
                cell.contentView.isHidden = false
                cell.yxs_setCellModel(comments[indexPath.row])
                cell.commentBlock = {
                    [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.curruntIndexPath = indexPath
                    strongSelf.showComment(comments[indexPath.row], section: indexPath.section)
                }
                cell.cellLongTapEvent = {
                    [weak self](point) in
                    guard let strongSelf = self else { return }
                    strongSelf.curruntIndexPath = indexPath
                    strongSelf.showDelectComment(comments[indexPath.row], point, section: indexPath.section)
                }

                cell.isNeedCorners = indexPath.row == comments.count - 1
            }else{
                cell.contentView.isHidden = true
            }
        }else{
            cell.contentView.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = dataSource[section]
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YXSHomeworkDetailSectionHeaderView") as? YXSHomeworkDetailSectionHeaderView
        if let headerView = headerView{
            headerView.curruntSection = section
            headerView.hmModel = self.model
            headerView.setModel(model: model)
            let cl = NightNight.theme == .night ? kNightBackgroundColor : kTableViewBackgroundColor
            headerView.yxs_addLine(position: .top, color: cl, lineHeight: 0.5)
            headerView.goodClick = { [weak self](model)in
                guard let weakSelf = self else {return}
                if model.isGood ?? 0 == 0 {
                    weakSelf.setHomeworkGoodEvent(section, isGood: 1)
                } else {
                    weakSelf.setHomeworkGoodEvent(section, isGood: 0)
                }
            }
            headerView.reviewControlBlock = { [weak self](model)in
                guard let weakSelf = self else {return}
                let vc = YXSHomeworkCommentController()
                vc.initChangeReview(myReviewModel: model, model: weakSelf.homeModel)
//                vc.homeModel = weakSelf.homeModel
                vc.childrenIdList = [(model.childrenId ?? 0)]
                vc.isPop = true
                //点评成功后 刷新数据
                vc.commetCallBack = { (list)in
                    weakSelf.refreshData()
                }
                weakSelf.navigationController?.pushViewController(vc)
            }
            headerView.remarkView.remarkChangeBlock = { [weak self](sender,model)in
                guard let weakSelf = self else {return}
                let point = UIApplication.shared.keyWindow?.convert(sender.bounds.origin, to: sender)
                let offsetY = fabsf(Float(point!.y))
                let offsetX = fabsf(Float(point!.x))
                weakSelf.currentSection = section
                weakSelf.isModifyRemark = true
                weakSelf.popoverView.height = 88
                weakSelf.currentIndexModel = model
                weakSelf.popover.show(weakSelf.popoverView, point: CGPoint(x: CGFloat(offsetX + 10), y: CGFloat(offsetY)))
            }
            headerView.homeWorkChangeBlock = { [weak self](sender,model)in
                guard let weakSelf = self else {return}
                let point = UIApplication.shared.keyWindow?.convert(sender.bounds.origin, to: sender)
                let offsetY = fabsf(Float(point!.y))
                let offsetX = fabsf(Float(point!.x))
                weakSelf.currentSection = section
                weakSelf.popoverView.height = 88
                weakSelf.currentIndexModel = model
                weakSelf.isModifyRemark = false
                weakSelf.popover.show(weakSelf.popoverView, point: CGPoint(x: CGFloat(offsetX + 10), y: CGFloat(offsetY)))
            }
            headerView.cellBlock = { [weak self](type,model: YXSHomeworkDetailModel) in
                guard let weakSelf = self else {return}
                switch type {
                case .comment:
                    weakSelf.showComment(section:section)
                    break
                case .praise:
                    YXSEducationHomeworkPraiseRequest(childrenId: model.childrenId ?? 0, homeworkCreateTime: weakSelf.homeModel.createTime ?? "", homeworkId: weakSelf.homeModel.serviceId ?? 0).request({ [weak self](json) in
                        guard let strongSelf = self else {return}
                        model.praiseJson = json.stringValue
                        strongSelf.dataSource[section] = model
                        UIView.performWithoutAnimation {
                            strongSelf.tableView.reloadSections(IndexSet.init(arrayLiteral: section), with: UITableView.RowAnimation.none)
                        }
                    }) { (msg, code) in
                        MBProgressHUD.yxs_showMessage(message: msg)
                    }
                    break
                case .showAll:
                    weakSelf.showAllRefresh(section: section, isScroll: !model.isShowContentAll)
                case .lookHomeWorkGood:
                    let vc = YXSHomeworkHistoryGoodVC.init(classId: weakSelf.homeModel.classId ?? 0, childid: model.childrenId ?? 0) { (id) in
                        if id == 0 {
                            weakSelf.refreshData(isRefreshList: true)
                        } else if id == weakSelf.homeModel.serviceId {
                            weakSelf.refreshData(isRefreshList: true)
                        }
                    }
                    vc.title = model.childrenName
                    weakSelf.navigationController?.pushViewController(vc)
//                    let vc = YXSHomeworkHistoryGoodVC.init(hmModel: weakSelf.homeModel, deModel: weakSelf.model!,childid: model.childrenId ?? 0)
                    
                    break
                case .lookLastWeakClassStart:
                    let vc = YXSClassStarPartentDetialController.init(classId: weakSelf.homeModel.classId ?? 0, childrenName: model.childrenName ?? "", childrenId: model.childrenId ?? 0, avar: model.childHeadPortrait ?? "", stage: YXSPersonDataModel.sharePerson.personStage, startTime: weakSelf.topHistoryModel?.startTime, endTime: weakSelf.topHistoryModel?.endTime, isLookOtherStudent: true)
                    UIUtil.curruntNav().pushViewController(vc)
                default:
                    break
                }
            }
        }

        return headerView
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight: CGFloat = 0
        //是否是最后一行 最后一行需要补偿高度
        var isLastRow = false
        let model = dataSource[indexPath.section]
        if let comments = model.commentJsonList{
            var commentsCount = comments.count
            if model.isNeeedShowCommentAllButton && !model.isShowCommentAll{
                commentsCount = 3
                isLastRow = true
            }
            if indexPath.row < commentsCount{
                let commetModel = comments[indexPath.row]
                cellHeight = commetModel.cellHeight
                if indexPath.row == comments.count - 1{
                    isLastRow = true
                }
                
                if isLastRow{
                    cellHeight += 8.0
                }
            }
        }
        return cellHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let model = self.dataSource[section]
        return model.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let model = dataSource[section]
        return model.isNeeedShowCommentAllButton ? 40.0 : 10.0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let model = dataSource[section]
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SLPunchCardDetialTableFooterView") as! YXSPunchCardDetialTableFooterView
        footerView.setFooterHomeworkModel(model)
        footerView.footerBlock = {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.reloadTableView(section: section, scroll: false)
        }
        return footerView
    }

    // MARK: - LazyLoad
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
//        if NightNight.theme != .night {
//            view.yxs_addLine(position: .top, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 10)
//        }
        return view
    }()

    lazy var tableHeaderView: YXSHomeWorkDetailTableHeaderView = {
        let tableHeaderView = YXSHomeWorkDetailTableHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 0))
        return tableHeaderView
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.dataSource
            = self
        tableView.delegate = self
        tableView.mixedBackgroundColor = MixedColor.init(normal: UIColor.white, night: kNightBackgroundColor)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        tableView.mj_header = tableViewRefreshHeader
        tableView.estimatedSectionHeaderHeight = 0
        //去除group空白
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()

    
    
    lazy var bottomBtnView: YXSBottomBtnView = {
        let view = YXSBottomBtnView()
        view.isHidden = true

        view.btnCommit.addTarget(self, action: #selector(goCommitClick(sender:)), for: .touchUpInside)
        return view
    }()

    lazy var selectModels:[YXSSelectModel] = {
        var selectModels = [YXSSelectModel.init(text: "全部", isSelect: true, paramsKey: SLCommonScreenSelectType.all.rawValue),YXSSelectModel.init(text: "待点评", isSelect: false, paramsKey: SLCommonScreenSelectType.toReview.rawValue),YXSSelectModel.init(text: "已点评", isSelect: false, paramsKey: SLCommonScreenSelectType.haveComments.rawValue)]
        return selectModels
    }()

    lazy var changeModels:[YXSSelectModel] = {
        var selectModels = [YXSSelectModel.init(text: "修改", isSelect: false, paramsKey: SLCommonScreenSelectType.change.rawValue),YXSSelectModel.init(text: "撤回", isSelect: false, paramsKey: SLCommonScreenSelectType.recall.rawValue)]
        return selectModels
    }()

    lazy var tableFooterView: UIView = {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
        let imageView = UIImageView.init(frame: CGRect(x: 52, y: 30, width: SCREEN_WIDTH - 104, height: 188))
        imageView.mixedImage = MixedImage(normal: "yxs_homework_defultImage_nodata", night: "yxs_defultImage_nodata_night")
        imageView.contentMode = .scaleAspectFit
        footer.addSubview(imageView)
        footer.addSubview(footerContentLbl)
        footer.addSubview(footerRemindBtn)
        
        return footer
    }()
    
    lazy var footerContentLbl: UILabel = {
        let lbl = UILabel.init(frame: CGRect(x: 0, y: 228, width: SCREEN_WIDTH, height: 20))
        lbl.text = "暂无作业提交"
        lbl.textAlignment = .center
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()
    
    lazy var footerRemindBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 268, width: 105, height: 30))
        btn.setTitle("一键提醒", for: .normal)
        btn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), for: .normal)
        btn.layer.borderWidth = 1.0
        btn.yxs_centerX = SCREEN_WIDTH * 0.5
        btn.layer.cornerRadius = 15
        btn.layer.borderColor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7").cgColor
        btn.addTarget(self, action: #selector(remindClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var tableRefreshFooter = MJRefreshBackStateFooter.init(refreshingBlock: {[weak self] in
        guard let strongSelf = self else { return }
        strongSelf.curruntPage += 1
        strongSelf.yxs_loadNextPage()
    })
    
    lazy var tableViewRefreshHeader: MJRefreshNormalHeader = MJRefreshNormalHeader.init(refreshingBlock:{ [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.curruntPage = 1
        strongSelf.refreshData()
    })
    
    lazy var popoverView: HomeworkPopoverListView = {
        let view = HomeworkPopoverListView.init(frame: CGRect(x: 0, y: 0, width: 100, height: 88))
        view.setTitles(titles: ["修改", "撤回"])
        view.selectClick = { (index)in
            print("点击了\(index)")
            self.popover.dismiss()
            if self.model?.isExpired ?? false{
                MBProgressHUD.yxs_showMessage(message: "当前作业已过期")
            }
            let type = index == 0 ? SLCommonScreenSelectType.change : SLCommonScreenSelectType.recall
            if self.isModifyRemark {
                
                self.teacherModifyRemarkWithModel(model: self.currentIndexModel, type: type)
            } else {
                self.parentModifyHomeworkWithModel(model: self.currentIndexModel, type: type)
            }
        }
        return view
    }()
    
    lazy var popover: Popover = {
        let popover = Popover(options: [
        .type(.up),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6)),
        .sideEdge(20)])
        return popover
    }()
    
    ///上传进度
    lazy var uploadHud: MBProgressHUD = {
        let hud = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        hud.mode = .indeterminate
        return hud
    }()
}

// MARK: -HMRouterEventProtocol
extension YXSHomeworkDetailViewController: YXSRouterEventProtocol,LFPhotoEditingControllerDelegate{
    
    
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSHomeworkDetialHeaderViewUpdateHeaderViewEvent:
            let isShow: Bool = info!["isShow"] as! Bool
            self.model?.isShowContentAll = isShow
            self.updateHeaderHeight()
        case kFriendsCircleMessageViewGoMessageEvent:
            let vc = YXSCommonMessageListController.init(hmModel: self.homeModel, deModel: self.model!)
            vc.loadSucess = {
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.tableHeaderView.setModel(model: strongSelf.model!)
            }
            self.navigationController?.pushViewController(vc)
        case kHomeworkPictureGraffitiNextEvent:
            if info != nil {
                let model = info!["imgModel"]
                let index = info!["imgIndex"] as? Int
                let hModel = info!["hmModel"]
                let section = info!["curruntSection"]
                self.graffitiSection = section as? Int
                self.graffitiDetailModel = hModel as? YXSHomeworkDetailModel
                self.graffitiImageIndex = (index ?? 10001) - 10001
                if model is YXSFriendsMediaModel {
                    let imgModel:YXSFriendsMediaModel = model as! YXSFriendsMediaModel
                    var originalImgModel:YXSFriendsMediaModel?
                    if self.graffitiDetailModel.backImageUrlList.count > 0 {
                        originalImgModel = self.graffitiDetailModel.backImageUrlList[self.graffitiImageIndex]
                    }
                    
                    let vc = LFPhotoEditingController.init()
                    vc.isHiddenStatusBar = true
                    vc.modalPresentationStyle = .fullScreen
                    vc.titleStr = self.graffitiDetailModel.childrenName ?? ""
                    let nav = UINavigationController.init(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    nav.setNavigationBarHidden(true, animated: false)
                    vc.isShowClearReductionBtn = false
                    if originalImgModel != nil {
                        vc.isShowClearReductionBtn = !((originalImgModel?.url ?? "") == imgModel.url)
                    }
                    
                    vc.clearReductionBlock = { [weak self]()in
                        guard let weakSelf = self else { return }
                        weakSelf.clearGraffitiRequest(urlStr: originalImgModel!.url ?? "")
                        vc.dismiss(animated: true, completion: nil)
                    }
                    vc.delegate = self
                    if let img = SDImageCache.shared.imageFromCache(forKey: imgModel.url) {
                        vc.setEdit(img, durations: [0])
                        self.present(nav, animated: true, completion: nil)
                    } else {
                        let downManager = SDWebImageDownloader.shared
                        downManager.downloadImage(with: URL.init(string: imgModel.url!)) { (image, data, error, finish) in
                            if finish && image != nil {
                                SDImageCache.shared.store(image, forKey: imgModel.url, completion: nil)
                                vc.setEdit(image, durations: [0])
                                self.present(nav, animated: true, completion: nil)
                            } else {
                                MBProgressHUD.yxs_showMessage(message: error.debugDescription)
                            }
                        }
                        
                    }
                }
            }
        default:
            print("")
        }
    }
    func lf_PhotoEditingController(_ photoEditingVC: LFPhotoEditingController!, didFinish photoEdit: LFPhotoEdit!) {
        photoEditingVC.delegate = nil
        if photoEdit != nil {
            self.uploadHud.label.text = "上传中(0%)"
            uploadHud.show(animated: true)
            let mediaModel = SLPublishMediaModel.init()
            mediaModel.showImg = photoEdit.editPreviewImage
            var localMeidaInfos = [[String: Any]]()
            localMeidaInfos.append([typeKey: SourceNameType.image,modelKey: mediaModel])
        
            if localMeidaInfos.count > 0{
                YXSUploadSourceHelper().uploadMedia(mediaInfos: localMeidaInfos, uploadPaths: [YXSUploadSourceHelper.expiresImgDoucmentPath], progress: {
                    (progress)in
                    DispatchQueue.main.async {
                        self.uploadHud.label.text = "上传中(\(String.init(format: "%d", Int((1.0*progress + (1.0 - 1.0)) * 100)))%)"
                    }
                }, sucess: { (infos) in
                    SLLog(infos)
                    print("123")
                    MBProgressHUD.yxs_hideHUDInView(view: self.navigationController!.view)
                    let urlStr = infos.first?.aliYunUploadBackUrl ?? ""
                    self.graffitiRequest(urlStr: urlStr)
                }) { (msg, code) in
                    MBProgressHUD.yxs_hideHUDInView(view: self.navigationController!.view)
                    MBProgressHUD.yxs_showMessage(message: msg)
                    self.clearGraffitiData()
                }
            }
            else{
                MBProgressHUD.yxs_hideHUDInView(view: self.navigationController!.view)
                self.clearGraffitiData()
            }
        }
        
        photoEditingVC.dismiss(animated: true, completion: nil)
        SLLog("编辑完成")
    }
    
    func clearGraffitiData() {
        self.graffitiSection = 0
        self.graffitiDetailModel = nil
        self.graffitiImageIndex = 0
    }
    
    func lf_PhotoEditingControllerDidCancel(_ photoEditingVC: LFPhotoEditingController!) {
        photoEditingVC.delegate = nil
        photoEditingVC.dismiss(animated: true, completion: nil)
//        photoEditingVC.navigationController?.popViewController()
        self.clearGraffitiData()
        SLLog("取消编辑")
    }
}

class HomeworkPopoverListView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    var selectClick:((_ index:Int)->())?
    let cellHeight: CGFloat = 44.0
    func setTitles(titles:[String]) {
        for (index,sub) in titles.enumerated() {
            let btn = YXSButton.init(frame: CGRect(x: 0, y: cellHeight * CGFloat(index), width: 100, height: cellHeight))
            btn.tag = 30000 + index
            btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
            btn.setTitle(sub, for: .normal)
            self.addSubview(btn)
        }
    }
    @objc func btnClick(sender: YXSButton) {
        selectClick?(sender.tag - 30000)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 一年级3班  我 ｜ 2019/11/13 14:30
class HomeworkDetailTopHeader: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(lbGrade)
        self.addSubview(lbName)
        //        self.addSubview(lbDate)
        
        self.lbGrade.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(17)
        })
//        lbGrade.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
//        lbGrade.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        
        self.lbName.snp.makeConstraints({ (make) in
//            make.centerY.equalTo(self.lbGrade.snp_centerY)
            make.right.equalTo(0)
            make.top.equalTo(self.lbGrade.snp_bottom).offset(15)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
        })
        lbName.setContentHuggingPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        lbName.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
        
        //        self.lbDate.snp.makeConstraints({ (make) in
        //            make.centerY.equalTo(self.lbGrade.snp_centerY)
        //            make.left.equalTo(self.lbName.snp_right).offset(20)
        //        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var strSubTitle: String? {
        didSet {
            lbName.text = self.strSubTitle
        }
    }
    
    var strGrade: String? {
        didSet {
            lbGrade.text = self.strGrade
        }
    }
    
    lazy private var lbGrade: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNightFFFFFF)
        lb.font = UIFont.systemFont(ofSize: 18)
        return lb
    }()
    
    lazy private var lbName: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    //    lazy var lbDate: YXSLabel = {
    //        let lb = YXSLabel()
    //        lb.mixedTextColor = MixedColor(normal: 0x898F9A, night: 0x000000)
    //        lb.text = ""
    //        lb.font = UIFont.systemFont(ofSize: 15)
    //        return lb
    //    }()
}

/// 阅读 14/40  提交 20/40   去提醒
class HomeworkDetailReadCommitView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.mixedBackgroundColor = MixedColor(normal: kF3F5F9Color, night: kNight282C3B)

        self.cornerRadius = 5
        self.clipsToBounds = true
        
        self.addSubview(self.lbTitle1)
        self.addSubview(self.lbRead)
        self.addSubview(self.lbTotal1)
        
        self.addSubview(self.lbTitle2)
        self.addSubview(self.lbCommit)
        self.addSubview(self.lbTotal2)
        
        self.addSubview(self.btnAlert)
        
        self.lbTitle1.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(self.snp_left).offset(13)
        })
        
        self.lbRead.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(lbTitle1.snp_right).offset(10)
        })
        
        self.lbTotal1.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(lbRead.snp_right).offset(0)
        })
        
        self.lbTitle2.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(lbTotal1.snp_right).offset(30)
        })
        
        self.lbCommit.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(lbTitle2.snp_right).offset(10)
        })
        
        self.lbTotal2.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(lbCommit.snp_right).offset(0)
        })
        
        self.btnAlert.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(self.snp_right).offset(-13)
            make.width.equalTo(79)
            make.height.equalTo(30)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var firstValue: String? {
        didSet {
            lbRead.text = self.firstValue
        }
    }
    
    var secondValue: String? {
        didSet {
            lbCommit.text = self.secondValue
        }
    }
    
    var firstTotal: String? {
        didSet {
            lbTotal1.text = "/\(self.firstTotal ?? "")"
        }
    }
    
    var secondTotal: String? {
        didSet {
            lbTotal2.text = "/\(self.secondTotal ?? "")"
        }
    }
    
    lazy var lbTitle1: YXSLabel = {
        let lb = YXSLabel()
        //        lb.text = "阅读"
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNightBCC6D4)
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbTitle2: YXSLabel = {
        let lb = YXSLabel()
        //        lb.text = "提交"
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNightBCC6D4)
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbRead: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "0"
        lb.mixedTextColor = MixedColor(normal: kNight5E88F7, night: kNight5E88F7)
        lb.font = UIFont.systemFont(ofSize: 19)
        //        lb.addTaget(target: self, selctor: #selector(readListClick))
        return lb
    }()
    
    lazy var lbCommit: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "0"
        lb.mixedTextColor = MixedColor(normal: kNight5E88F7, night: kNight5E88F7)
        lb.font = UIFont.systemFont(ofSize: 19)
        //        lb.addTaget(target: self, selctor: #selector(commitListClick))
        return lb
    }()
    
    lazy var lbTotal1: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "/0"
        lb.mixedTextColor = MixedColor(normal: kC1CDDBColor, night: kNightBCC6D4)
        lb.font = UIFont.systemFont(ofSize: 19)
        return lb
    }()
    
    lazy var lbTotal2: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "/0"
        lb.mixedTextColor = MixedColor(normal: kC1CDDBColor, night: kNightBCC6D4)
        lb.font = UIFont.systemFont(ofSize: 19)
        return lb
    }()
    
    lazy var btnAlert: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("去提醒", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setMixedTitleColor(MixedColor(normal: kNight5E88F7, night: kNight5E88F7), forState: .normal)
        btn.layer.mixedBorderColor = MixedColor(normal: kNight5E88F7, night: kNight5E88F7)
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 16
        //        btn.addTarget(self, action: #selector(alertClick(sender:)), for: .touchUpInside)
        return btn
    }()
}
