//
//  YXSClassStarCommentEditItemListController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/6.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import JXCategoryView
import FDFullscreenPopGesture_Bell
import NightNight

class YXSClassStarCommentEditItemListController: YXSBaseViewController, JXCategoryViewDelegate, JXCategoryListContainerViewDelegate {
    var defultIndex: Int
    var totalModel: ClassStarCommentTotalModel
    init(totalModel: ClassStarCommentTotalModel, defultIndex: Int) {
        self.totalModel = totalModel
        self.defultIndex = defultIndex
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVC()
        fd_prefersNavigationBarHidden = true
        // Do any additional setup after loading the view.
        self.view.addSubview(listContainerView)
        self.categoryView.listContainer = listContainerView
        self.categoryView.delegate = self
        categoryView.defaultSelectedIndex = defultIndex
        
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
        
        refreshData()
    }
    
    var detailModel: YXSHomeListModel? {
        didSet {
            
        }
    }
    
    // MARK: - Request
    func refreshData() {
        YXSEducationHomeworkQueryCommitReadInfoRequest(gradeId: detailModel?.classId ?? 0, homeworkCreateTime: detailModel?.createTime ?? "", homeworkId: detailModel?.serviceId ?? 0).request({ (json) in
            
        }) { (msg, code) in
            
        }
    }
    
    // MARK: - Delegate
    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return vcs.count
    }
    
    var vcs = [YXSClassStarItemListController]()
    
    func initVC(){
        let firstVC = YXSClassStarItemListController.init(dataSource: totalModel.dataSource[0])
        firstVC.didSelectItems = {
            [weak self] (item: YXSClassStarCommentItemModel) in
            guard let strongSelf = self else { return }
            strongSelf.pushWithItemModel(item: item,defultIndex:0)
        }
        vcs.append(firstVC)
        if totalModel.stage != .KINDERGARTEN{
            let secentVC = YXSClassStarItemListController.init(dataSource: totalModel.dataSource[1])
            secentVC.didSelectItems = {
                [weak self] (item: YXSClassStarCommentItemModel) in
                guard let strongSelf = self else { return }
                strongSelf.pushWithItemModel(item: item,defultIndex:1)
            }
            vcs.append(secentVC)
        }
    }
    
    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        return vcs[index]
    }
    
    func pushWithItemModel(item: YXSClassStarCommentItemModel,defultIndex: Int){
        if item.itemType == .Add{
            let vc = YXSClassStarCommentEditItemController.init(classId: totalModel.classId,itemModel: nil,index:defultIndex,stage: totalModel.stage)
            self.navigationController?.pushViewController(vc)
        }else if item.itemType == .Delect{
            let vc = YXSClassStarCommentDelectListController.init(totalModel.dataSource[defultIndex] ,index:defultIndex)
            self.navigationController?.pushViewController(vc)
            
        }else{
            let vc = YXSClassStarCommentEditItemController.init(classId: totalModel.classId,itemModel: item, index: defultIndex,stage: totalModel.stage)
            self.navigationController?.pushViewController(vc)
        }
    }
    
    func updateItems(item: YXSClassStarCommentItemModel, defultIndex: Int, isUpdate: Bool){
        let vc = vcs[defultIndex]
        var lists = [YXSClassStarCommentItemModel]()
        if isUpdate{
            for model in vc.dataSource{
                if model.id == item.id{
                    lists.append(item)
                }else{
                    lists.append(model)
                }
            }
        }else{
            for model in vc.dataSource{
                lists.append(model)
            }
            lists.insert(item, at: 2)
        }
        vc.dataSource = lists
        totalModel.dataSource[defultIndex] = lists
    }
    
    func delectItems(items: [YXSClassStarCommentItemModel], defultIndex: Int){
        let vc = vcs[defultIndex]
        var lists = vc.dataSource
        for model in items{
            for source in vc.dataSource{
                if model.id == source.id{
                    lists.remove(at: lists.firstIndex(of: source) ?? 0)
                    break
                }
            }
            
        }
        vc.dataSource = lists
        totalModel.dataSource[defultIndex] = lists
    }
    
    
    //    YXSClassStarCommentEditItemController
    
    // MARK: - LazyLoad
    lazy var categoryView: JXCategoryTitleView = {
        let view = JXCategoryTitleView(frame: CGRect(x: 0, y: 0, width: 130, height: 30))
        view.titleColor = NightNight.theme == .night ? kNight898F9A : UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        view.titleSelectedColor = NightNight.theme == .night ? kBlueColor : kTextMainBodyColor
        view.titles = totalModel.stage == .KINDERGARTEN ? ["表扬"] : ["表扬", "待改进"]
        
        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorWidth = JXCategoryViewAutomaticDimension
        lineView.lineStyle = .lengthen
        lineView.indicatorColor = kBlueColor
        view.indicators = [lineView]
        return view
    }()
    
    lazy var listContainerView: JXCategoryListContainerView = {
        let view = JXCategoryListContainerView(type: JXCategoryListContainerType.scrollView, delegate: self)
        
        return view!
    }()
    
    
    lazy var customNav: YXSCustomNav = {
        let customNav = YXSCustomNav.init(.onlyback)
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
extension YXSClassStarCommentEditItemListController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:break
        }
    }
}
