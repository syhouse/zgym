//
//  YXSSynClassHomeListVC.swift
//  ZGYM
//
//  Created by yihao on 2020/4/20.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import JXCategoryView
import NightNight

enum YXSSynClassListType: String{
    ///小学
    case PRIMARY_SCHOOL
    ///中学
    case MIDDLE_SCHOOL
    ///高中
    case HIGH_SCHOOL
}

enum YXSSynClassGradeType: String{
    ///一年级
    case first_grade
    ///二年级
    case second_grade
    ///三年级
    case third_grade
    ///四年级
    case fourth_grade
    ///五年级
    case fifth_grade
    ///初一
    case one_junior
    ///初二
    case two_junior
    ///初三
    case three_junior
    ///高一
    case one_senior
    ///高二
    case two_senior
    ///高三
    case three_senior
}

class YXSSynClassHomeListVC: YXSBaseViewController{
    private var listContainerView: JXCategoryListContainerView!
    ///分类标题
    private var titles: [String] = ["小学","初中","高中"]
    private var listVCTypes: [YXSSynClassListType] = [.PRIMARY_SCHOOL, .MIDDLE_SCHOOL, .HIGH_SCHOOL]
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "同步课堂"
        loadCategoryData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCategoryData()
    }
    
    
    func loadCategoryData(){
        self.congfigUI()
    }
    
    func congfigUI(){
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
            make.bottom.equalTo(0)
        }
        
        categoryView.contentScrollView = listContainerView.scrollView
        categoryView.delegate = self
    }
    
    lazy var categoryView :JXCategoryTitleView = {
        //            64  8 40  15
        let view = JXCategoryTitleView()
        view.titleSelectedColor = NightNight.theme == .night ? UIColor.white : kBlueColor
        view.titleColor = NightNight.theme == .night ? kNightBCC6D4 : k575A60Color
        view.titleFont = UIFont.systemFont(ofSize: 17)
        view.titles = self.titles
        view.cellSpacing = 30
        view.isTitleColorGradientEnabled = true
        view.cellWidthIncrement = 50
        view.layer.cornerRadius = 20
        
        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorColor = UIColor.yxs_hexToAdecimalColor(hex: "#7CABFF");
        lineView.indicatorWidth = 50
        lineView.indicatorHeight = 2
        view.indicators = [lineView]
        return view
    }()
}

extension YXSSynClassHomeListVC: JXCategoryListContainerViewDelegate, JXCategoryViewDelegate{
    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return categoryView.titles.count
    }
    
    
    
    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        return YXSSynClassListVC.init(type: listVCTypes[index])
    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, scrollingFromLeftIndex leftIndex: Int, toRightIndex rightIndex: Int, ratio: CGFloat) {
        self.listContainerView?.scrolling(fromLeftIndex: leftIndex, toRightIndex: rightIndex, ratio: ratio, selectedIndex: categoryView.selectedIndex)
    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        self.listContainerView?.didClickSelectedItem(at: index)
    }
}
