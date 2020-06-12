//
//  YXSSolitaireContainerController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/5.
//  Copyright © 2020 zgym. All rights reserved.
//


import UIKit
import NightNight
import JXCategoryView
import FDFullscreenPopGesture_Bell
import ObjectMapper

class YXSSolitaireContainerController: YXSBaseViewController, JXCategoryViewDelegate, JXCategoryListContainerViewDelegate {
    
    var backClickBlock:(()->())?
    var committedList: [YXSClassMemberModel] = [YXSClassMemberModel]()
    var uncommittedList: [YXSClassMemberModel] = [YXSClassMemberModel]()
    var readList: [YXSClassMemberModel] = [YXSClassMemberModel]()
    var unreadList: [YXSClassMemberModel] = [YXSClassMemberModel]()
    
    var firstTableView: YXSSolitaireReadListController!
    var secondTableView: YXSSolitaireReplyListController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightForegroundColor)
        
        // Do any additional setup after loading the view.
        self.categoryView.titles =  ["阅读", "提交"]
        //        firstTableView = SLNoticeReadListViewController()
        //        secondTableView = YXSNoticeReplyListViewController()
        
        
        
        fd_prefersNavigationBarHidden = true
        // Do any additional setup after loading the view.
        firstTableView = YXSSolitaireReadListController(classId: detailModel?.classId ?? 0, serviceId: detailModel?.censusId ?? 0, createTime: detailModel?.createTime ?? "",serviceType: 3, callbackRequestParameter: ["type": detailModel?.type ?? 0])
        secondTableView = YXSSolitaireReplyListController(classId: detailModel?.classId ?? 0, serviceId: detailModel?.censusId ?? 0, createTime: detailModel?.createTime ?? "",serviceType: 3)
        
        firstTableView.showRemind = detailModel?.state == 100 ? false : true
        secondTableView.showRemind = detailModel?.state == 100 ? false : true
        
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
    var detailModel: YXSSolitaireDetailModel? {
        didSet {
            refreshData()
        }
    }
    
    // MARK: - Request
    func refreshData() {
        YXSEducationCensusReadOrNoReadRequest(censusId: detailModel?.censusId ?? 0).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            weakSelf.readList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["readCensusResponseList"].rawString()!) ?? [YXSClassMemberModel]()
            weakSelf.unreadList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["notReadCensusResponseList"].rawString()!) ?? [YXSClassMemberModel]()
            weakSelf.firstTableView.firstListModel = weakSelf.readList
            weakSelf.firstTableView.secondListModel = weakSelf.unreadList
            
            weakSelf.firstTableView.yxs_refreshData()
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
        YXSEducationCensusCommitOrNoCommitRequest(censusId: detailModel?.censusId ?? 0).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            weakSelf.committedList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["commitCensusResponseList"].rawString()!) ?? [YXSClassMemberModel]()
            weakSelf.uncommittedList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["notCommitCensusResponseList"].rawString()!) ?? [YXSClassMemberModel]()
            
            weakSelf.secondTableView.firstListModel = weakSelf.committedList
            weakSelf.secondTableView.secondListModel = weakSelf.uncommittedList
            weakSelf.secondTableView.yxs_refreshData()
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
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
        return 2
    }
    
    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        if index == 0 {
            return firstTableView
            
        } else {
            return secondTableView
        }
        
    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        if index == 0 {
            secondTableView.yxs_refreshData()
            
        }else{
            firstTableView.yxs_refreshData()
        }
    }
    
    // MARK: - LazyLoad
    lazy var categoryView: JXCategoryTitleView = {
        let view = JXCategoryTitleView(frame: CGRect(x: 0, y: 0, width: 130, height: 30))
        
        view.titleColor = NightNight.theme == .night ? kNightBCC6D4 : k575A60Color
        view.titleSelectedColor = NightNight.theme == .night ? kNightFFFFFF : kTextMainBodyColor
        view.titles = ["阅读", "提交"]
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: -HMRouterEventProtocol
extension YXSSolitaireContainerController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:
            break
        }
    }
}
