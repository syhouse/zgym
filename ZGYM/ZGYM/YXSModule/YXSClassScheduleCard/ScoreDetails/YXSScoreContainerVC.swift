//
//  YXSScoreContainerVC.swift
//  ZGYM
//
//  Created by yihao on 2020/6/9.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight
import JXCategoryView
import FDFullscreenPopGesture_Bell
import ObjectMapper

class YXSScoreContainerVC: YXSBaseViewController, JXCategoryViewDelegate, JXCategoryListContainerViewDelegate {
    var backClickBlock:(()->())?
    var readList: [YXSClassMemberModel] = [YXSClassMemberModel]()
    var unreadList: [YXSClassMemberModel] = [YXSClassMemberModel]()
    var firstTableView: YXSScoreReadingListVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightForegroundColor)
        self.categoryView.titles = ["阅读"]
        
        fd_prefersNavigationBarHidden = true
        firstTableView = YXSScoreReadingListVC()
        
        self.view.addSubview(listContainerView)
        self.categoryView.listContainer = listContainerView
        self.categoryView.delegate = self
        
        view.addSubview(customNav)
        customNav.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }
        customNav.addSubview(categoryView)
        categoryView.snp.makeConstraints { (make) in
            make.centerX.equalTo(customNav)
            make.centerY.equalTo(customNav.backImageButton)
            make.size.equalTo(CGSize.init(width: 130, height: 30))
        }
        listContainerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(customNav.snp_bottom)
        }
    }
    
    // MARK: - Setter
    var detailModel: YXSScoreListModel? {
        didSet {
            refreshData()
        }
    }
    
    // MARK: - Request
    func refreshData() {
        MBProgressHUD.yxs_showLoading(ignore: true)
        YXSEducationScoreReadingChildListRequset.init(examId: detailModel?.examId ?? 0).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            weakSelf.readList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["readList"].rawString()!) ?? [YXSClassMemberModel]()
            weakSelf.unreadList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["notReadList"].rawString()!) ?? [YXSClassMemberModel]()
            weakSelf.firstTableView.homeListModel = weakSelf.detailModel
            weakSelf.firstTableView.firstListModel = weakSelf.readList
            weakSelf.firstTableView.secondListModel = weakSelf.unreadList
            weakSelf.firstTableView.yxs_refreshData()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
//        YXSEducationNoticeQueryCommitReadInfoRequest(noticeId: detailModel?.serviceId ?? 0, gradeId: detailModel?.classId ?? 0, noticeCreateTime: detailModel?.createTime ?? "").request({ [weak self](json) in
//            guard let weakSelf = self else {return}
//            MBProgressHUD.yxs_hideHUD()
//            weakSelf.readList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["readList"].rawString()!) ?? [YXSClassMemberModel]()
//            weakSelf.unreadList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["unreadList"].rawString()!) ?? [YXSClassMemberModel]()
//            
//            weakSelf.firstTableView.homeListModel = weakSelf.detailModel
//            weakSelf.firstTableView.firstListModel = weakSelf.readList
//            weakSelf.firstTableView.secondListModel = weakSelf.unreadList
//
//            weakSelf.firstTableView.yxs_refreshData()
//
//            
//        }) { (msg, code) in
//            MBProgressHUD.yxs_showMessage(message: msg)
//        }
    }
    
    // MARK: - Other
    override func yxs_onBackClick() {
       if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
           backClickBlock?()
       }
       super.yxs_onBackClick()
    }
    
    // MARK: - Delegate
    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
       return 1
    }

    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
            return firstTableView
    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        firstTableView.yxs_refreshData()
    }
    
    // MARK: - LazyLoad
    lazy var categoryView: JXCategoryTitleView = {
       let view = JXCategoryTitleView(frame: CGRect(x: 0, y: 0, width: 130, height: 30))
       
       view.titleColor = NightNight.theme == .night ? kNightBCC6D4 : k575A60Color
       view.titleSelectedColor = NightNight.theme == .night ? kNightFFFFFF : kTextMainBodyColor
       view.titles = ["阅读"]
       
       let lineView = JXCategoryIndicatorLineView()
       lineView.indicatorWidth = JXCategoryViewAutomaticDimension
       lineView.indicatorColor = kNight5E88F7
       lineView.lineStyle = .lengthen
       view.indicators = [lineView]
       return view
    }()

    lazy var listContainerView: JXCategoryListContainerView = {
       let view = JXCategoryListContainerView(type: JXCategoryListContainerType.scrollView, delegate: self)
       return view!
    }()


    lazy var customNav: YXSCustomNav = {
       let customNav = YXSCustomNav.init(.onlyback)
       customNav.backImageButton.setMixedImage(MixedImage(normal: "back", night: "yxs_back_white"), forState: .normal)
       return customNav
    }()
}

// MARK: -HMRouterEventProtocol
extension YXSScoreContainerVC: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:
            break
        }
    }
}
