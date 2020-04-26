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


class YXSClassStarCommentWindowView: UIView {
    @discardableResult static func showClassStarComment(model: ClassStarCommentTotalModel,sucess:((_ item:YXSClassStarCommentItemModel)->())?) -> YXSClassStarCommentWindowView{
        let view = YXSClassStarCommentWindowView(model: model,sucess:sucess)
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
        
        categoryView.addSubview(editBtn)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(17)
            make.centerX.equalTo(self)
        }
        btnClose.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalTo(titleLabel)
        }
        
        categoryView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(49)
            make.height.equalTo(49)
        }
        editBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15.5)
            make.centerY.equalTo(categoryView)
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
        self.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - (kSafeTopHeight + 64))
        self.yxs_addRoundedCorners(corners: [.topLeft, .topRight], radii: CGSize.init(width: 5, height: 5))
        bgWindow.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.frame = CGRect.init(x: 0, y: kSafeTopHeight + 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - (kSafeTopHeight + 64))
        })
    }
    
    // MARK: -event
    
    func pushWithItemModel(item: YXSClassStarCommentItemModel,defultIndex: Int){
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
    
    @objc func dismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 0
        }) { finished in
            self.bgWindow.removeFromSuperview()
            
        }
    }
    
    @objc func editItem(){
        let newModel = ClassStarCommentTotalModel.init(titles: model.titles, dataSource: [model.dataSource[0], model.dataSource[1]],classId:model.classId,stage: model.stage)
        if model.stage == .KINDERGARTEN{
            newModel.dataSource[0].insert(YXSClassStarCommentItemModel.getYMClassStarCommentItemModel(.Delect, title: "删除"), at: 0)
            newModel.dataSource[0].insert(YXSClassStarCommentItemModel.getYMClassStarCommentItemModel(.Add, title: "添加"), at: 0)
        }else{
            newModel.dataSource[0].insert(YXSClassStarCommentItemModel.getYMClassStarCommentItemModel(.Delect, title: "删除"), at: 0)
            newModel.dataSource[0].insert(YXSClassStarCommentItemModel.getYMClassStarCommentItemModel(.Add, title: "添加"), at: 0)
            newModel.dataSource[1].insert(YXSClassStarCommentItemModel.getYMClassStarCommentItemModel(.Delect, title: "删除"), at: 0)
            newModel.dataSource[1].insert(YXSClassStarCommentItemModel.getYMClassStarCommentItemModel(.Add, title: "添加"), at: 0)
        }
        UIUtil.curruntNav().pushViewController(YXSClassStarCommentEditItemListController.init(totalModel: newModel, defultIndex: categoryView.selectedIndex))
        dismiss()
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
        view.titleSelectedColor = kBlueColor
        view.titleColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        view.titleFont = UIFont.boldSystemFont(ofSize: 15)
        view.titleSelectedFont = UIFont.boldSystemFont(ofSize: 15)
        view.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9");
        view.titles = model.titles
        view.contentEdgeInsetLeft = 15
        view.cellWidth = 48
        view.isAverageCellSpacingEnabled = false
        view.cellSpacing = 60.5
        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorColor = kBlueColor
        lineView.indicatorHeight = 2
        view.indicators = [lineView]
        return view
    }()
    
    
    lazy var listContainerView: JXCategoryListContainerView = {
        let view = JXCategoryListContainerView(type: JXCategoryListContainerType.scrollView, delegate: self)
        return view!
    }()
    
    lazy var btnClose: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("关闭", for: .normal)
        btn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        btn.yxs_touchInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        return btn
    }()
    
    lazy var editBtn: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("编辑", for: .normal)
        btn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#696C73"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(editItem), for: .touchUpInside)
        btn.yxs_touchInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        return btn
    }()
    
    
    lazy var bgWindow : UIControl! = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        return view
    }()
}

extension YXSClassStarCommentWindowView: JXCategoryListContainerViewDelegate, JXCategoryViewDelegate{
    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return model.titles.count
    }
    
    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        let vc = YXSClassStarCommentItemController.init(canCommentDataSource: model.dataSource[index], childrens: model.childrenIds, classId: model.classId, stage: model.stage, category: index == 0 ? 10 : 20)
        vc.didSelectItems = {
            [weak self] (item: YXSClassStarCommentItemModel) in
            guard let strongSelf = self else { return }
            strongSelf.pushWithItemModel(item: item, defultIndex: index)
        }
        return vc
    }
}
