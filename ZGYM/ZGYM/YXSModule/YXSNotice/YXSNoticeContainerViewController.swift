//
//  YXSNoticeContainerViewController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/2.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
import JXCategoryView
import FDFullscreenPopGesture_Bell
import ObjectMapper

class YXSNoticeContainerViewController: YXSBaseViewController, JXCategoryViewDelegate, JXCategoryListContainerViewDelegate {

    var backClickBlock:(()->())?
    var committedList: [YXSClassMemberModel] = [YXSClassMemberModel]()
    var uncommittedList: [YXSClassMemberModel] = [YXSClassMemberModel]()
    var readList: [YXSClassMemberModel] = [YXSClassMemberModel]()
    var unreadList: [YXSClassMemberModel] = [YXSClassMemberModel]()
    
    var firstTableView: SLNoticeReadListViewController!
    var secondTableView: YXSNoticeReplyListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightForegroundColor)
        
        // Do any additional setup after loading the view.
        self.categoryView.titles = detailModel?.onlineCommit == 1 ? ["回执", "阅读"] : ["阅读"]
//        firstTableView = SLNoticeReadListViewController()
//        secondTableView = YXSNoticeReplyListViewController()
        
        
        
        fd_prefersNavigationBarHidden = true
        // Do any additional setup after loading the view.
        firstTableView = SLNoticeReadListViewController()
        secondTableView = YXSNoticeReplyListViewController()
        
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
    var detailModel: YXSHomeListModel? {
        didSet {
            refreshData()
        }
    }
    
    // MARK: - Request
    func refreshData() {
        MBProgressHUD.yxs_showLoading(ignore: true)
        YXSEducationNoticeQueryCommitReadInfoRequest(noticeId: detailModel?.serviceId ?? 0, gradeId: detailModel?.classId ?? 0, noticeCreateTime: detailModel?.createTime ?? "").request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()
            weakSelf.readList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["readList"].rawString()!) ?? [YXSClassMemberModel]()
            weakSelf.unreadList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["unreadList"].rawString()!) ?? [YXSClassMemberModel]()
            weakSelf.committedList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["committedList"].rawString()!) ?? [YXSClassMemberModel]()
            weakSelf.uncommittedList = Mapper<YXSClassMemberModel>().mapArray(JSONString: json["uncommittedList"].rawString()!) ?? [YXSClassMemberModel]()
            
            weakSelf.firstTableView.homeListModel = weakSelf.detailModel
            weakSelf.firstTableView.firstListModel = weakSelf.readList
            weakSelf.firstTableView.secondListModel = weakSelf.unreadList
            
            weakSelf.secondTableView.homeListModel = weakSelf.detailModel
            weakSelf.secondTableView.firstListModel = weakSelf.committedList
            weakSelf.secondTableView.secondListModel = weakSelf.uncommittedList
            
            if weakSelf.detailModel?.onlineCommit == 1 {
                if weakSelf.categoryView.selectedIndex == 0{
                    weakSelf.secondTableView.yxs_refreshData()
                    
                }else{
                    weakSelf.firstTableView.yxs_refreshData()
                }
                
            } else {
                weakSelf.firstTableView.yxs_refreshData()
            }

            
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
       return detailModel?.onlineCommit == 1 ? 2 : 1
    }

    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        if detailModel?.onlineCommit == 1 {
            if index == 0 {
                 return secondTableView
                
            } else {
                 return firstTableView
            }
            
        } else {
            return firstTableView
        }

    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        if detailModel?.onlineCommit == 1 {
            if index == 0 {
                 secondTableView.yxs_refreshData()
             
            }else{
                 firstTableView.yxs_refreshData()
            }
            
        } else {
            firstTableView.yxs_refreshData()
        }
    }

    // MARK: - LazyLoad
    lazy var categoryView: JXCategoryTitleView = {
       let view = JXCategoryTitleView(frame: CGRect(x: 0, y: 0, width: 130, height: 30))
       
       view.titleColor = NightNight.theme == .night ? kNightBCC6D4 : k575A60Color
       view.titleSelectedColor = NightNight.theme == .night ? kNightFFFFFF : kTextMainBodyColor
       view.titles = detailModel?.onlineCommit == 1 ? ["提交","阅读"] : ["阅读"]
       
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
extension YXSNoticeContainerViewController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:
            break
        }
    }
}
