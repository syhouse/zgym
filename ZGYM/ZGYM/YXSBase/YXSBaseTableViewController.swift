//
//  YXSBaseTableViewController.swift
//  SwiftBase
//
//  Created by zgjy_mac on 2019/9/10.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import MJRefresh
import NightNight
class YXSBaseTableViewController: YXSBaseScrollViewController {
    var tableView: UITableView!
    var tableViewIsGroup = false{
        didSet{
            let tableView = getTableView()
            self.tableView = tableView
            self.scrollView = tableView
        }
    }
    
    override init(){
        super.init()
        let tableView = getTableView()
        self.tableView = tableView
        self.scrollView = tableView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 是否下拉加载更多
    var loadMore: Bool = false{
        didSet{
            if self.loadMore{
                if showFooterNoMoreDataView{
                    self.tableView.tableFooterView = nil
                }
                self.tableView.mj_footer = tableRefreshFooter
            }else{
                self.tableView.mj_footer = nil
                if showFooterNoMoreDataView{
                    self.tableView.tableFooterView = noMoreDataFooterView
                }
//                self.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    ///是否展示底部没有更多的footerView
    var showFooterNoMoreDataView: Bool = false
    
    func getTableView() -> UITableView{
        let tableView = UITableView(frame: CGRect.zero, style: tableViewIsGroup ? UITableView.Style.grouped : UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mixedBackgroundColor = MixedColor.init(normal: UIColor.white, night: kNightBackgroundColor)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
//        tableView.estimatedSectionHeaderHeight = 0
//        //去除group空白
//        tableView.estimatedSectionFooterHeight = 0.0
//        tableView.estimatedRowHeight = 0
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    lazy var noMoreDataFooterView: YXSXMCommonFooterView = {
        let footerView = YXSXMCommonFooterView.init(frame: CGRect.init(x: 0, y: 0, width: self.tableView.width, height: 35))
        return footerView
    }()
    
}

class YXSBaseCollectionViewController: YXSBaseScrollViewController {
    /// 是否下拉加载更多
    var loadMore: Bool = false{
        didSet{
            if self.loadMore{
                self.collectionView.mj_footer = tableRefreshFooter
            }else{
                self.collectionView.mj_footer = nil
//                self.collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    lazy var layout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets.init(top: 21.5, left: 27.5, bottom: 0, right: 27.5)
        layout.itemSize = CGSize.init(width: (self.view.frame.size.width - CGFloat(27.5*2) - CGFloat(2*20))/3, height: 94)
        return layout
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ClassStarCommentItemCell.self, forCellWithReuseIdentifier: "ClassStarCommentItemCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        self.scrollView = self.collectionView
        super.viewDidLoad()
    }
}


class YXSBaseScrollViewController: YXSBaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    //当前页码
    var currentPage: Int = 1
    // 是否有下拉刷新
    var hasRefreshHeader = true
    //是否一创建就刷新
    var showBegainRefresh = true
    
    /// 是否展示空白视图
    var showEmptyDataSource = false
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.frame)
        return scrollView
    }()

    
    lazy var tableViewRefreshHeader: MJRefreshNormalHeader = MJRefreshNormalHeader.init(refreshingBlock:{ [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.currentPage = 1
        strongSelf.yxs_refreshData()
    })
    
    lazy var tableRefreshFooter = MJRefreshBackStateFooter.init(refreshingBlock: {[weak self] in
        guard let strongSelf = self else { return }
        strongSelf.currentPage += 1
        strongSelf.yxs_loadNextPage()
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        
        self.scrollView.mj_header = hasRefreshHeader ? tableViewRefreshHeader : nil
        if showBegainRefresh{
//            beginRefresh()
            yxs_refreshData()
        }
    }
    
    /// 下拉刷新请求
    @objc func yxs_refreshData(){
    }
    
    /// 上拉加载更多请求
    func yxs_loadNextPage(){
    }
    
     @objc func yxs_beginRefresh(){
        if hasRefreshHeader{
            self.scrollView.mj_header?.beginRefreshing()
        }
     }
    
    func yxs_endingRefresh(endSucess: (() ->())? = nil){
        showEmptyDataSource = true
        tableViewRefreshHeader.endRefreshing(completionBlock: endSucess ?? {()})
        tableRefreshFooter.endRefreshing(completionBlock: endSucess ?? {()})
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

// MARK: - commonFunc
extension YXSBaseScrollViewController{
    func yxs_dealPublishAction(_ event: YXSHomeHeaderActionEvent,classId: Int?){
        if event == .homework{
            let vc = YXSHomeworkPublishController()
            vc.singlePublishClassId = classId
            vc.complete = {(requestModel,shareModel) in
                self.yxs_refreshData()
                if !isOldUI{
                    YXSPublishHomeworkSucessView.showAlert {
                        UIUtil.yxs_shareLink(requestModel: requestModel, shareModel: shareModel){
                            shareModel.way = YXSShareWayType.WXSession
                            YXSShareTool.share(model: shareModel)
                        }
                    }
                }
            }
            self.navigationController?.pushViewController(vc)
        }else if event == .punchCard{
            let vc = YXSPunchCardPublishController()
            vc.singlePublishClassId = classId
            self.navigationController?.pushViewController(vc)
        }
        else if event == .notice{
            let vc = YXSNoticePublishController()
            vc.singlePublishClassId = classId
            self.navigationController?.pushViewController(vc)
        }
        else if event == .solitaire{
            let vc = YXSSolitaireSelectTypeController()
            vc.singlePublishClassId = classId
            self.navigationController?.pushViewController(vc)
            
//            let vc = YXSSolitairePublishController()
//            vc.singlePublishClassId = classId
//            self.navigationController?.pushViewController(vc)
        }
        else if event == .friendCicle{
            let vc = YXSFriendPublishController()
            vc.singlePublishClassId = classId
            self.navigationController?.pushViewController(vc)
        }
        else if event == .classstart{
            //教师班级之星 只有单个班级
            if yxs_user.gradeIds!.count == 1{
                let vc = YXSClassStarTeacherPublishCommentController.init(model: nil,isPublish: true,classId: yxs_user.gradeIds?.first ?? 0)
                self.navigationController?.pushViewController(vc)
            }else{
                let vc = YXSClassStartTeacherClassListController.init(classId: classId, isPublish: true)
                self.navigationController?.pushViewController(vc)
            }
            
        }
        
    }
}
