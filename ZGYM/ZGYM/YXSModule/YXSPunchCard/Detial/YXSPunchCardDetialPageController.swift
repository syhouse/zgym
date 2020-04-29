//
//  SLPunchCardDetialPageController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/26.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import JXCategoryView
import NightNight

let kYXSPunchCardCategoryViewRankEvent = "SLPunchCardCategoryViewRankEvent"

class YXSPunchCardCategoryView: UIView {
    let titles: [String]!
    lazy var categoryView :JXCategoryTitleView = {
        //            64  8 40  15
        let view = JXCategoryTitleView()
        view.titleSelectedColor = NightNight.theme == .night ? UIColor.white : kTextMainBodyColor
        view.titleColor = NightNight.theme == .night ? kNightBCC6D4 : k575A60Color
        view.titleFont = UIFont.systemFont(ofSize: 17)
        view.titles = self.titles;
        view.cellSpacing = 0
        view.isTitleColorGradientEnabled = true
        view.layer.cornerRadius = 20
        
        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorColor = UIColor.yxs_hexToAdecimalColor(hex: "#7CABFF");
        lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
        lineView.indicatorHeight = 2
        view.indicators = [lineView];
        return view
    }()
    
    lazy var rankControl: YXSCustomImageControl = {
        let rankControl = YXSCustomImageControl.init(imageSize: CGSize.init(width: 11.5, height: 14), position: YXSImagePositionType.left, padding: 8.5)
        rankControl.font = UIFont.systemFont(ofSize: 15)
        rankControl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        rankControl.locailImage = "yxs_punchCard_rank"
        rankControl.addTarget(self, action: #selector(rankClick), for: .touchUpInside)
        rankControl.title = "打卡排行"
        return rankControl
    }()
    
    init(titles: [String]) {
        self.titles = titles
        super.init(frame: CGRect.zero)
        self.addSubview(categoryView)
        self.yxs_addLine(position: .bottom)
        let isTeacher = YXSPersonDataModel.sharePerson.personRole == .TEACHER
        categoryView.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            if isTeacher{
                make.right.equalTo(-100)
            }else{
                make.right.equalTo(0)
            }
            make.height.equalTo(50)
        }
        if isTeacher{
            self.addSubview(rankControl)
            rankControl.snp.makeConstraints { (make) in
                make.right.equalTo(-15.5)
                make.centerY.equalTo(categoryView)
                make.height.equalTo(14)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func rankClick(){
        next?.yxs_routerEventWithName(eventName: kYXSPunchCardCategoryViewRankEvent)
    }
}



class YXSPunchCardDetialPageController: YXSBaseViewController{
    // MARK: - property

    public var punchModel: YXSPunchCardModel{
        didSet{///在外面被修改
            yxs_punchCardRefresh(type: nil)
        }
    }
    
    public var topHistoryModel: YXSClassStarTopHistoryModel?{
        didSet{
            if let topHistoryModel = topHistoryModel{
                for vc in vcs{
                    vc.topHistoryModel = topHistoryModel
                }
            }
        }
    }
    
    private var isMyPublish: Bool{
        return punchModel.promulgator ?? false
    }
    private var listContainerView: JXCategoryListContainerView!
    private var vcs = [YXSPunchCardSingleStudentListController]()
    private var titles: [String]
    private var listVCTypes: [YXSSingleStudentListType]
    init(punchModel: YXSPunchCardModel) {
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            listVCTypes = [.all, .good, .calendar]
            titles = ["全部打卡","优秀打卡","日历"]
        }else{
            listVCTypes = [.all, .good, .myPunchCard, .calendar]
            titles = ["全部打卡","优秀打卡", "我的打卡","日历"]
        }
        
        self.punchModel = punchModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listContainerView = JXCategoryListContainerView.init(type: .collectionView, delegate: self)
        
        self.view.addSubview(navView)
        self.view.addSubview(listContainerView)
        navView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(50)
        }
        listContainerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.top.equalTo(50)
        }
        
        navView.categoryView.contentScrollView = listContainerView.scrollView
    }
    
    // MARK: - public Refresh
    public func yxs_punchCardRefresh(type: YXSSingleStudentListType?){
        for vc in vcs{
            //不是当前类型 刷新
            if vc.type != type{
                if vc.type == .calendar{
                    ///
//                    var isSelectModel
                    vc.updateHeader(punchCardModel: punchModel)
                }
                vc.yxs_refreshData()
            }
        }
    }
    
    var lastCurruntVC: YXSPunchCardSingleStudentListController!
    
    public func yxs_punchCardRefresh(changeModel: YXSPunchCardCommintListModel){
        for vc in vcs{
            vc.refreshData(changePunchCardModel: changeModel)
        }
    }
    
    lazy var navView: YXSPunchCardCategoryView = {
        let view = YXSPunchCardCategoryView.init(titles: titles)
        view.categoryView.delegate = self
        return view
    }()
    
}


extension YXSPunchCardDetialPageController: JXCategoryListContainerViewDelegate, JXCategoryViewDelegate{
    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return navView.titles.count
    }
    
    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        //         self.navView.categoryView.delegate = self
        let vc = YXSPunchCardSingleStudentListController.init(punchCardModel: punchModel,isMyPublish: isMyPublish, type: listVCTypes[index], topHistoryModel: nil)
        vc.refreshBlock = {
            [weak self] (changeModel, curruntType)in
            guard let strongSelf = self else { return }
            if let changeModel = changeModel{
                strongSelf.yxs_punchCardRefresh(changeModel: changeModel)
            }else{
                strongSelf.yxs_punchCardRefresh(type: curruntType)
            }
            
        }
        vcs.append(vc)
        return vc
    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, scrollingFromLeftIndex leftIndex: Int, toRightIndex rightIndex: Int, ratio: CGFloat) {
        self.listContainerView?.scrolling(fromLeftIndex: leftIndex, toRightIndex: rightIndex, ratio: ratio, selectedIndex: categoryView.selectedIndex)
    }
    
    
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        self.listContainerView?.didClickSelectedItem(at: index)
    }
}

// MARK: -YXSRouterEventProtocol
extension YXSPunchCardDetialPageController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSPunchCardCategoryViewRankEvent:
            let vc = YXSPunchCardStatisticsController.init(punchCardModel: punchModel)
            self.parent?.navigationController?.pushViewController(vc)
        default:
            break
        }
    }
}

