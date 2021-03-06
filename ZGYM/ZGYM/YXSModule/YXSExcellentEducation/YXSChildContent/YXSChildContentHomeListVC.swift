//
//  YXSChildContentHomeListVC.swift
//  ZGYM
//
//  Created by yihao on 2020/4/24.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import JXCategoryView
import NightNight
import ObjectMapper

class YXSChildContentHomeListVC: YXSBaseViewController {
    private var listContainerView: JXCategoryListContainerView!
    ///分类标题
    private var homeTypeModels: [YXSChildContentHomeTypeModel] = [YXSChildContentHomeTypeModel]()
    private var titles: [String] = [String]()
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "育儿好文"
        loadCategoryData()
    }
    func loadCategoryData(){
        YXSEducationChildContentHomeListTypeRequest.init().request({ (json) in
            let list = Mapper<YXSChildContentHomeTypeModel>().mapArray(JSONObject: json.object) ?? [YXSChildContentHomeTypeModel]()
            // 新增全部标签
            let allType = YXSChildContentHomeTypeModel.init(JSON: ["id":0,"name":"全部"])
            self.homeTypeModels.removeAll()
            self.titles.removeAll()
            self.homeTypeModels.append(allType!)
            self.titles.append(allType?.name ?? "全部")
            self.homeTypeModels += list
            for type in list {
                self.titles.append(type.name ?? "")
            }
            self.congfigUI()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
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

extension YXSChildContentHomeListVC: JXCategoryListContainerViewDelegate, JXCategoryViewDelegate{
    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return categoryView.titles.count
    }
    
    
    
    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        return YXSChildContentListVC.init(typeModel: homeTypeModels[index])
    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, scrollingFromLeftIndex leftIndex: Int, toRightIndex rightIndex: Int, ratio: CGFloat) {
        self.listContainerView?.scrolling(fromLeftIndex: leftIndex, toRightIndex: rightIndex, ratio: ratio, selectedIndex: categoryView.selectedIndex)
    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        self.listContainerView?.didClickSelectedItem(at: index)
    }
}

