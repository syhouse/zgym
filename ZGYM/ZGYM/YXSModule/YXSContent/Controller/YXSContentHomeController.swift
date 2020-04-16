//
//  YXSContentHomeController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/11.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import JXCategoryView
import NightNight

class YXSContentHomeController: YXSBaseViewController{
    private var listContainerView: JXCategoryListContainerView!
    ///分类model列表
    private var categoryLists: [YXSColumnModel] = [YXSColumnModel]()
    ///分类标题
    private var titles: [String] = [String]()
    
    private var hasLoadData = false
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategoryData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCategoryData()
    }
    
    // MARK: -UI
    
    // MARK: -loadData
    func loadCategoryData(){
//        YXSEducationXMLYOperationBannersRequest.init(page: 1).requestCollection({ (list:[YXSBannerModel], pageCount) in
//            SLLog(list.toJSONString())
//        }) { (msg, code) in
//
//        }
        if hasLoadData{
            return
        }
        
        YXSEducationXMLYOperationColumnsRequest.init(page: 1).requestCollection({ (list:[YXSColumnModel], pageCount) in
            var titles = [String]()
            var newModels = [YXSColumnModel]()
            for model in list{
                if model.id == 6680{//小优推荐
                    titles.insert("推荐", at: 0)
                    newModels.insert(model, at: 0)
                }else{
                    titles.append(model.title ?? "")
                    newModels.append(model)
                }
            }
            self.titles = titles
            self.categoryLists = newModels
            
            self.congfigUI()
        }) { (msg, code) in
            
        }
    }
    
    // MARK: -action
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: - UI
    func congfigUI(){
        if hasLoadData{
            return
        }
        
        hasLoadData = true
        listContainerView = JXCategoryListContainerView.init(type: .collectionView, delegate: self)
        
        self.view.addSubview(categoryView)
        self.view.addSubview(listContainerView)
        categoryView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(50)
        }
        listContainerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(categoryView.snp_bottom)
            make.bottom.equalTo(-kTabBottomHeight)
        }
        
        categoryView.contentScrollView = listContainerView.scrollView
        categoryView.delegate = self
    }
    
    
    // MARK: - getter&setter
    
    lazy var categoryView :JXCategoryTitleView = {
        //            64  8 40  15
        let view = JXCategoryTitleView()
        view.titleSelectedColor = NightNight.theme == .night ? UIColor.white : kBlueColor
        view.titleColor = NightNight.theme == .night ? kNightBCC6D4 : k575A60Color
        view.titleFont = UIFont.systemFont(ofSize: 17)
        view.titles = self.titles
        view.cellSpacing = 30
        view.isTitleColorGradientEnabled = true
        view.cellWidthIncrement = 10
        view.layer.cornerRadius = 20
        
        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorColor = UIColor.yxs_hexToAdecimalColor(hex: "#7CABFF");
        lineView.indicatorWidth = 20
        lineView.indicatorHeight = 2
        view.indicators = [lineView]
        return view
    }()
}

extension YXSContentHomeController: JXCategoryListContainerViewDelegate, JXCategoryViewDelegate{
    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return categoryView.titles.count
    }
    
    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        if index == 0{
            return YXSContentListViewController.init(id: categoryLists[index].id ?? 0, showHeader: true)
        }
        return YXSContentListViewController.init(id: categoryLists[index].id ?? 0)
    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, scrollingFromLeftIndex leftIndex: Int, toRightIndex rightIndex: Int, ratio: CGFloat) {
        self.listContainerView?.scrolling(fromLeftIndex: leftIndex, toRightIndex: rightIndex, ratio: ratio, selectedIndex: categoryView.selectedIndex)
    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        self.listContainerView?.didClickSelectedItem(at: index)
    }
}


