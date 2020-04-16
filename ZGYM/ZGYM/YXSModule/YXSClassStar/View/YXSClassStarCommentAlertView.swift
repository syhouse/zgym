//
//  YXSClassStarCommentAlertView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/5.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import JXCategoryView
import NightNight

class ClassStarCommentTotalModel: NSObject{
    var titles: [String]
    var classId: Int
    var dataSource: [[YXSClassStarCommentItemModel]]
    var alertTitle: String?
    var childrenIds: [Int]!
    var stage: StageType
    init(titles: [String],dataSource: [[YXSClassStarCommentItemModel]],classId: Int,stage: StageType) {
        self.titles = titles
        self.dataSource = dataSource
        self.classId = classId
        self.stage = stage
        super.init()
    }
}

class YXSClassStarCommentAlertView: UIView {
    @discardableResult static func showClassStarComment(model: ClassStarCommentTotalModel,sucess:((_ item:YXSClassStarCommentItemModel)->())?) -> YXSClassStarCommentAlertView{
        let view = YXSClassStarCommentAlertView(model: model,sucess:sucess)
        view.beginAnimation()
        return view
    }
    let model: ClassStarCommentTotalModel
    let sucess:((_ item:YXSClassStarCommentItemModel)->())?
    init(model: ClassStarCommentTotalModel,sucess:((_ item: YXSClassStarCommentItemModel)->())?){
        self.model = model
        self.sucess = sucess
        super.init(frame: CGRect.zero)
        
        self.addSubview(listContainerView)
        self.addSubview(categoryView)
        self.addSubview(titleLabel)
        self.addSubview(btnClose)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(24)
            make.centerX.equalTo(self)
        }
        btnClose.snp.makeConstraints { (make) in
            make.top.equalTo(15.5)
            make.right.equalTo(-17.5)
            make.size.equalTo(CGSize.init(width: 34, height: 34))
        }
        
        categoryView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(model.stage == StageType.KINDERGARTEN ? 134.5 : 269)
            make.top.equalTo(64.5)
            make.height.equalTo(30)
        }
        
        listContainerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(categoryView.snp_bottom)
        }
        
        self.categoryView.listContainer = listContainerView
        self.categoryView.delegate = self
        
        titleLabel.text = model.alertTitle
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginAnimation() {
        UIApplication.shared.keyWindow?.addSubview(bgWindow)
        
        bgWindow.addSubview(self)
        bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        self.cornerRadius = 15
        
        self.snp.makeConstraints { (make) in
            make.left.equalTo(21)
            make.right.equalTo(-21)
            make.centerY.equalTo(bgWindow)
            make.height.equalTo(401.5)
        }
        bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 1
        })
    }
    
    // MARK: -event
    
    func pushWithItemModel(item: YXSClassStarCommentItemModel,defultIndex: Int){
        
        //剔除系统的
        var firstCleanList = [YXSClassStarCommentItemModel]()
        var secendCleanList = [YXSClassStarCommentItemModel]()
        for model in model.dataSource[0]{
            if model.itemType == .Service && model.itemIsSystem == false{
                firstCleanList.append(model)
            }
        }
        if model.stage != .KINDERGARTEN{
            for model in model.dataSource[1]{
                if model.itemType == .Service && model.itemIsSystem == false{
                    secendCleanList.append(model)
                }
            }
        }
        
        if item.itemType == .Edit{
            let newModel = ClassStarCommentTotalModel.init(titles: model.titles, dataSource: [firstCleanList, secendCleanList],classId:model.classId,stage: model.stage)
            if model.stage == .KINDERGARTEN{
                newModel.dataSource[0].insert(YXSClassStarCommentItemModel.getYMClassStarCommentItemModel(.Delect, title: "删除"), at: 0)
                newModel.dataSource[0].insert(YXSClassStarCommentItemModel.getYMClassStarCommentItemModel(.Add, title: "添加"), at: 0)
            }else{
                newModel.dataSource[0].insert(YXSClassStarCommentItemModel.getYMClassStarCommentItemModel(.Delect, title: "删除"), at: 0)
                newModel.dataSource[0].insert(YXSClassStarCommentItemModel.getYMClassStarCommentItemModel(.Add, title: "添加"), at: 0)
                newModel.dataSource[1].insert(YXSClassStarCommentItemModel.getYMClassStarCommentItemModel(.Delect, title: "删除"), at: 0)
                newModel.dataSource[1].insert(YXSClassStarCommentItemModel.getYMClassStarCommentItemModel(.Add, title: "添加"), at: 0)
            }
            UIUtil.curruntNav().pushViewController(YXSClassStarCommentEditItemListController.init(totalModel: newModel, defultIndex: defultIndex))
            dismiss()
        }else{
            //do comment
            MBProgressHUD.showAdded(to: self.bgWindow, animated: true)
            YXSEducationClassStarTeacherEvaluationChildrenRequest.init(childrenIds: model.childrenIds, classId: model.classId, evaluationId: item.id ?? 0).request({ (result) in
                MBProgressHUD.hide(for: self.bgWindow, animated: true)
                self.sucess?(item)
                self.dismiss()
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kUpdateClassStarScoreNotification), object: nil)
            }) { (msg, code) in
                MBProgressHUD.hide(for: self.bgWindow, animated: true)
                MBProgressHUD.yxs_showMessage(message: msg, inView: self.bgWindow)
            }
        }
        
    }
    
    @objc func dismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 0
        }) { finished in
            self.bgWindow.removeFromSuperview()
            
        }
    }
    
    // MARK: -getter
    
    lazy var titleLabel : UILabel = {
        let view = getLabel(text: "")
        view.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#000000"), night: kNightFFFFFF)
        view.font = UIFont.boldSystemFont(ofSize: 17)
        return view
    }()
    
    lazy var categoryView :JXCategoryTitleView = {
        let view = JXCategoryTitleView()
        view.titleSelectedColor = UIColor.white
        view.titleColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        view.titleFont = UIFont.boldSystemFont(ofSize: 15)
        view.titleSelectedFont = UIFont.boldSystemFont(ofSize: 15)
        view.cellWidth = 134.5;
        view.cellBackgroundSelectedColor = kBlueColor;
        view.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9");
        view.cellWidthIncrement = 0
        view.titles = model.titles
        view.cellSpacing = 0
        view.cornerRadius = 5
        let lineView = JXCategoryIndicatorBackgroundView()
        lineView.indicatorColor = kBlueColor
        lineView.indicatorWidth = 134.5;
        lineView.indicatorHeight = 34
        lineView.indicatorWidthIncrement = 0
        lineView.indicatorCornerRadius = 5
        view.indicators = [lineView];
        return view
    }()
    
    
    lazy var listContainerView: JXCategoryListContainerView = {
        let view = JXCategoryListContainerView(type: JXCategoryListContainerType.scrollView, delegate: self)
        return view!
    }()
    
    lazy var btnClose: YXSButton = {
        let btn = YXSButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var bgWindow : UIControl! = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        return view
    }()
}

extension YXSClassStarCommentAlertView: JXCategoryListContainerViewDelegate, JXCategoryViewDelegate{
    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return model.titles.count
    }
    
    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        let vc = YXSClassStarCommentItemController.init(dataSource: model.dataSource[index])
        vc.collectionWidth = SCREEN_WIDTH - 42
        vc.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 42, height: 0)
        vc.didSelectItems = {
            [weak self] (item: YXSClassStarCommentItemModel) in
            guard let strongSelf = self else { return }
            strongSelf.pushWithItemModel(item: item, defultIndex: index)
        }
        return vc
    }
}
