//
//  YXSCollectBabyhearListVC.swift
//  ZGYM
//
//  Created by yihao on 2020/5/12.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import JXCategoryView
import NightNight

enum YXSCollectType {
    /// 声音
    case voice
    /// 专辑
    case album
}

class YXSCollectBabyhearListVC: YXSBaseViewController {
    private var listContainerView: JXCategoryListContainerView!
    ///分类标题
    private var titles: [String] = ["声音", "专辑"]
    private var types: [YXSCollectType] = [.voice, .album]
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "宝宝听"
        congfigUI()
    }
    
    func congfigUI(){
        listContainerView = JXCategoryListContainerView.init(type: .collectionView, delegate: self)
        listContainerView.scrollView.isScrollEnabled = false
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
        view.titleFont = UIFont.systemFont(ofSize: 16)
        view.cellSpacing = 10
        view.isTitleColorGradientEnabled = true
        view.titles = self.titles
        view.cellWidthIncrement = 30
//        view.layer.cornerRadius = 20
        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorColor = UIColor.yxs_hexToAdecimalColor(hex: "#7CABFF");
        lineView.indicatorWidth = 50
        lineView.indicatorHeight = 3
        view.indicators = [lineView]
        view.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), leftMargin: 0, rightMargin: 0, lineHeight: 1)
        return view
    }()
}

extension YXSCollectBabyhearListVC: JXCategoryListContainerViewDelegate, JXCategoryViewDelegate{
    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return categoryView.titles.count
    }
    
    
    
    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        return YXSCollectBabyhearDetailsVC.init(type: types[index])
    }
    
//    func categoryView(_ categoryView: JXCategoryBaseView!, scrollingFromLeftIndex leftIndex: Int, toRightIndex rightIndex: Int, ratio: CGFloat) {
//        self.listContainerView?.scrolling(fromLeftIndex: leftIndex, toRightIndex: rightIndex, ratio: ratio, selectedIndex: categoryView.selectedIndex)
//    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        self.listContainerView?.didClickSelectedItem(at: index)
    }
}
