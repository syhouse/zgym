//
//  SLHomeworkContainerViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/26.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight
import JXCategoryView
import FDFullscreenPopGesture_Bell
import ObjectMapper

/// 阅读 提交 列表 （老师端）
class SLHomeworkContainerViewController: SLBaseViewController, JXCategoryViewDelegate, JXCategoryListContainerViewDelegate {
    
    var backClickBlock:(()->())?
    var committedList: [SLClassMemberModel] = [SLClassMemberModel]()
    var uncommittedList: [SLClassMemberModel] = [SLClassMemberModel]()
    var readList: [SLClassMemberModel] = [SLClassMemberModel]()
    var unreadList: [SLClassMemberModel] = [SLClassMemberModel]()
    
    var firstTableView: SLHomeworkReadListViewController!
    var secondTableView: SLHomeworkCommitListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightForegroundColor)
        
        fd_prefersNavigationBarHidden = true
        // Do any additional setup after loading the view.
        firstTableView = SLHomeworkReadListViewController()
        secondTableView = SLHomeworkCommitListViewController()
        
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
    var detailModel: SLHomeListModel? {
        didSet {
            refreshData()
        }
    }
    
    // MARK: - Request
    func refreshData() {
        SLEducationHomeworkQueryCommitReadInfoRequest(gradeId: detailModel?.classId ?? 0, homeworkCreateTime: detailModel?.createTime ?? "", homeworkId: detailModel?.serviceId ?? 0).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            weakSelf.readList = Mapper<SLClassMemberModel>().mapArray(JSONString: json["readList"].rawString()!) ?? [SLClassMemberModel]()
            weakSelf.unreadList = Mapper<SLClassMemberModel>().mapArray(JSONString: json["unreadList"].rawString()!) ?? [SLClassMemberModel]()
            weakSelf.committedList = Mapper<SLClassMemberModel>().mapArray(JSONString: json["committedList"].rawString()!) ?? [SLClassMemberModel]()
            weakSelf.uncommittedList = Mapper<SLClassMemberModel>().mapArray(JSONString: json["uncommittedList"].rawString()!) ?? [SLClassMemberModel]()
            
            weakSelf.firstTableView.SLHomeListModel = weakSelf.detailModel
            weakSelf.firstTableView.firstListModel = weakSelf.readList
            weakSelf.firstTableView.secondListModel = weakSelf.unreadList
            
            weakSelf.secondTableView.homeListModel = weakSelf.detailModel
            weakSelf.secondTableView.firstListModel = weakSelf.committedList
            weakSelf.secondTableView.secondListModel = weakSelf.uncommittedList
            
            if weakSelf.detailModel?.onlineCommit == 1 {
                if weakSelf.categoryView.selectedIndex == 0{
                    weakSelf.secondTableView.sl_refreshData()
                }else{
                    weakSelf.firstTableView.sl_refreshData()
                }
                
            } else {
                weakSelf.firstTableView.sl_refreshData()
            }
            
        }) { (msg, code) in
            
        }
    }
    
    // MARK: - Other
    override func sl_onBackClick() {
        if SLPersonDataModel.sharePerson.personRole == .TEACHER {
            backClickBlock?()
        }
        super.sl_onBackClick()
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
                 secondTableView.sl_refreshData()
             
            }else{
                 firstTableView.sl_refreshData()
            }
            
        } else {
            firstTableView.sl_refreshData()
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
    
    
    lazy var customNav: SLCustomNav = {
        let customNav = SLCustomNav.init(.onlyback)
        customNav.backImageButton.setMixedImage(MixedImage(normal: "back", night: "sl_back_white"), forState: .normal)
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
extension SLHomeworkContainerViewController: SLRouterEventProtocol{
    func sl_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kHMCustomNavBackEvent:
            sl_onBackClick()
        default:
            break
        }
    }
}

