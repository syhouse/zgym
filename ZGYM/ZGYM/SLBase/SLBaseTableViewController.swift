//
//  SLBaseTableViewController.swift
//  SwiftBase
//
//  Created by sl_mac on 2019/9/10.
//  Copyright © 2019 sl_mac. All rights reserved.
//

import UIKit
import MJRefresh
import NightNight
class SLBaseTableViewController: SLBaseScrollViewController {
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
                self.scrollView.mj_footer = tableRefreshFooter
            }else{
                self.scrollView.mj_footer = nil
                self.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    func getTableView() -> UITableView{
        let tableView = UITableView(frame: CGRect.zero, style: tableViewIsGroup ? UITableView.Style.grouped : UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mixedBackgroundColor = MixedColor.init(normal: UIColor.white, night: kNightBackgroundColor)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
    }
    
}

class SLBaseCollectionViewController: SLBaseScrollViewController {
    /// 是否下拉加载更多
    var loadMore: Bool = false{
        didSet{
            if self.loadMore{
                self.scrollView.mj_footer = tableRefreshFooter
            }else{
                self.scrollView.mj_footer = nil
                self.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
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
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
    }
}


class SLBaseScrollViewController: SLBaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    //当前页码
    var curruntPage: Int = 1
    // 是否有下拉刷新
    var hasRefreshHeader = true
    //是否一创建就刷新
    var showBegainRefresh = true
    
    /// 是否展示空白视图
    var showEmptyDataSource = false
    
    var scrollView: UIScrollView!

    
    lazy var tableViewRefreshHeader: MJRefreshNormalHeader = MJRefreshNormalHeader.init(refreshingBlock:{ [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.curruntPage = 1
        strongSelf.sl_refreshData()
    })
    
    lazy var tableRefreshFooter = MJRefreshBackStateFooter.init(refreshingBlock: {[weak self] in
        guard let strongSelf = self else { return }
        strongSelf.curruntPage += 1
        strongSelf.sl_loadNextPage()
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.mj_header = hasRefreshHeader ? tableViewRefreshHeader : nil
        if showBegainRefresh{
//            beginRefresh()
            sl_refreshData()
        }
    }
    
    @objc func sl_refreshData(){
    }
    
    func sl_loadNextPage(){
    }
    
     @objc func sl_beginRefresh(){
        if hasRefreshHeader{
            self.scrollView.mj_header?.beginRefreshing()
        }
     }
    
    func sl_endingRefresh(endSucess: (() ->())? = nil){
        showEmptyDataSource = true
        if self.curruntPage == 1{
            if hasRefreshHeader,let header = self.scrollView.mj_header{
                header.endRefreshing(completionBlock: endSucess ?? {()})
            }
        }else{
            if let footer = self.scrollView.mj_footer {
                footer.endRefreshing(completionBlock: endSucess ?? {()})
            }
        }
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
extension SLBaseScrollViewController{
    func sl_dealPublishAction(_ event: SLHomeActionEvent,classId: Int?){
        if event == .homework{
            let vc = SLHomeworkPublishController()
            vc.singlePublishClassId = classId
            vc.complete = {(requestModel,shareModel) in
                self.sl_refreshData()
                SLPublishHomeworkSucessView.showAlert {
                    UIUtil.sl_shareLink(requestModel: requestModel, shareModel: shareModel){
                        shareModel.way = SLShareWayType.WXSession
                        SLShareTool.share(model: shareModel)
                    }
                }
            }
            self.navigationController?.pushViewController(vc)
        }else if event == .punchCard{
            let vc = SLPunchCardPublishController()
            vc.singlePublishClassId = classId
            self.navigationController?.pushViewController(vc)
        }
        else if event == .notice{
            let vc = SLNoticePublishController()
            vc.singlePublishClassId = classId
            self.navigationController?.pushViewController(vc)
        }
        else if event == .solitaire{
            let vc = SLSolitairePublishController()
            vc.singlePublishClassId = classId
            self.navigationController?.pushViewController(vc)
        }
        else if event == .friendCicle{
            let vc = SLFriendPublishController()
            vc.singlePublishClassId = classId
            self.navigationController?.pushViewController(vc)
        }
        else if event == .classstart{
            //教师班级之星 只有单个班级
            if sl_user.gradeIds!.count == 1{
                let vc = SLClassStarTeacherPublishCommentController.init(model: nil,isPublish: true,classId: sl_user.gradeIds?.first ?? 0)
                self.navigationController?.pushViewController(vc)
            }else{
                let vc = SLClassStartTeacherClassListController.init(classId: classId, isPublish: true)
                self.navigationController?.pushViewController(vc)
            }
            
        }
        
    }
}
