//
//  SLClassStarTeacherPublishCommentController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/5.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

class SLClassStarTeacherPublishCommentController: YXSBaseViewController {
    var model: SLClassStartClassModel!
    var isPublish: Bool = false
    let classId: Int?
    var alertModel: ClassStarCommentTotalModel!
    var dataSource: [SLClassStarChildrenModel]!
    init(model: SLClassStartClassModel? , isPublish: Bool = false,classId: Int? = nil) {
        self.model = model
        self.classId = classId
        self.isPublish = isPublish
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(publishView)
        view.addSubview(commentButton)
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        publishView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight - 49 - 30)
        }
        commentButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize.init(width: 318, height: 49))
            make.bottom.equalTo(-kSafeBottomHeight - 15)
        }
        if isPublish{
            yxs_loadClassTopData()
        }else{
            yxs_loadData()
            self.title = model?.className
        }
    }
    var selectComments: [SLClassStarChildrenModel]!{
        get{
            var selectComments = [SLClassStarChildrenModel]()
            for model in dataSource{
                if model.isSelect{
                    selectComments.append(model)
                }
            }
            return selectComments
        }
    }
    // MARK: -UI
    func yxs_setEmptyView(){
        emptyView.classNum = model.classNo ?? ""
        emptyView.isHidden = false
        publishView.isHidden = true
    }
    
    func yxs_updateCommentView(){
        if selectComments.count == 0{
            commentButton.isHidden = true
        }else{
            commentButton.isHidden = false
            commentButton.setTitle("点评(\(selectComments.count))", for: .normal)
        }
    }
    var loadAll = true
    // MARK: -yxs_loadData
    let queue = DispatchQueue.global()
    let group = DispatchGroup()
    func yxs_loadData(){
        if loadAll{
            self.yxs_loadEvaluationListData()
        }
        
        
        self.yxs_loadClassChildrensData()
    }
    
    @objc func yxs_loadClassTopData() {
        YXSEducationClassStarTeacherClassTopRequest.init(classId: classId, dateType: model?.dateType ?? DateType.W).requestCollection({ (classs:[SLClassStartClassModel]) in
            
            if let model = classs.first{
                self.model = model
                self.yxs_loadData()
                self.title = model.className
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast("\(msg)")
        }
    }
    
    func yxs_loadClassChildrensData(){
        SLLog("start_yxs_loadClassChildrensData")
        MBProgressHUD.showAdded(to: self.view, animated: true)
        YXSEducationClassStarTeacherClassChildrenTopRequest.init(classId: model.classId ?? 0, sortType: Int(publishView.selectModel.paramsKey) ?? 0, dateType: model.dateType).requestCollection({ (list:[SLClassStarChildrenModel]) in
            self.dataSource = list
            let allClassModel = SLClassStarChildrenModel.init(JSON: ["" : ""])!
            allClassModel.isAllChildren = true
            var improveScore = 0
            var praiseScore = 0
            for (_,model) in list.enumerated(){
                if let impScore = model.improveScore{
                    improveScore += impScore
                }
                if let praScore = model.praiseScore{
                    praiseScore += praScore
                }
            }
            
            allClassModel.improveScore = improveScore
            allClassModel.praiseScore = praiseScore
            self.dataSource.insert(allClassModel, at: 0)
            
            
            if let dataSource = self.dataSource{
                if dataSource.count > 1{
                    self.publishView.items = dataSource
                }else{
                    self.yxs_setEmptyView()
                }
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            SLLog("end_yxs_loadClassChildrensData")
//            self.group.leave()
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
//            self.group.leave()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func yxs_loadEvaluationListData(){
        SLLog("start_yxs_loadEvaluationListData")
        YXSEducationFEvaluationListListRequest.init(classId: model.classId ?? 0,stage: model.stageType).requestCollection({ (list: [SLClassStarCommentItemModel]) in
            
           if self.model.stageType == .KINDERGARTEN{
                var source = list
                source.append(SLClassStarCommentItemModel.getYMClassStarCommentItemModel(.Edit, title: "编辑"))
                self.alertModel = ClassStarCommentTotalModel.init(titles: ["表扬"], dataSource: [source],classId:self.model.classId ?? 0,stage: self.model.stageType)
            }else{
                var pariseLists = [SLClassStarCommentItemModel]()
                var impLists = [SLClassStarCommentItemModel]()
                for model in list{
                    if model.score ?? 0 >= 0{
                        pariseLists.append(model)
                    }else{
                        impLists.append(model)
                    }
                }
                pariseLists.append(SLClassStarCommentItemModel.getYMClassStarCommentItemModel(.Edit, title: "编辑"))
                impLists.append(SLClassStarCommentItemModel.getYMClassStarCommentItemModel(.Edit, title: "编辑"))
                self.alertModel = ClassStarCommentTotalModel.init(titles: ["表扬", "待改进"], dataSource: [pariseLists,impLists],classId:self.model.classId ?? 0,stage: self.model.stageType)
            }
            SLLog("end_yxs_loadEvaluationListData")
    
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    
    // MARK: -action
    @objc func yxs_commentEvent(){
        yxs_dealComment(nil)
    }
    func yxs_dealComment(_ model: SLClassStarChildrenModel?){
        if self.alertModel == nil{
            return
        }
        
        var isAllClass = false
        var childrenIds: [Int] = [Int]()
        
        var selectComments: [SLClassStarChildrenModel] = self.selectComments
        //点击评论
        if let model = model{
            selectComments.append(model)
        }
        
        for model in selectComments{
            if model.isAllChildren{
                isAllClass = true
                break
            }else{
                childrenIds.append(model.childrenId ?? 0)
            }
        }
        
        if !isAllClass && self.selectComments.count == 0 && model == nil{
            return
        }
        
        if isAllClass{
            alertModel.alertTitle = "点评全班"
            for model in dataSource{
                if !model.isAllChildren{
                    childrenIds.append(model.childrenId ?? 0)
                }
            }
        }else if childrenIds.count > 1{
            alertModel.alertTitle = "点评\(selectComments[0].childrenName ?? "")等\(childrenIds.count)人"
        }else{
            alertModel.alertTitle = "点评\(selectComments[0].childrenName ?? "")"
        }
        alertModel.childrenIds = childrenIds
        SLClassStarCommentAlertView.showClassStarComment(model: self.alertModel) { [weak self](item) in
            guard let strongSelf = self else { return }
            let isAdd = (item.score ?? 0) > 0 ? true : false
            if isAllClass{
                for model in strongSelf.dataSource{
                    if model.isAllChildren{
                        model.score = (model.score ?? 0) + Int((item.score ?? 0) * (strongSelf.dataSource.count - 1))
                        if isAdd{
                            model.praiseScore = (model.praiseScore ?? 0) + Int((item.score ?? 0) * (strongSelf.dataSource.count - 1))
                        }else{
                            model.improveScore = (model.improveScore ?? 0) + Int((item.score ?? 0) * (strongSelf.dataSource.count - 1))
                        }
                        model.isShowScoreAnimal = true
                        model.scoreAnimalValue = item.score ?? 0
                    }else{
                        model.score = (model.score ?? 0) + (item.score ?? 0)
                        if isAdd{
                            model.praiseScore = (model.praiseScore ?? 0) + (item.score ?? 0)
                        }else{
                            model.improveScore = (model.improveScore ?? 0) + (item.score ?? 0)
                        }
                    }
                }
            }else{
                for model in selectComments{
                    model.isSelect = false
                    model.score = (model.score ?? 0) + (item.score ?? 0)
                    if isAdd{
                        model.praiseScore = (model.praiseScore ?? 0) + (item.score ?? 0)
                    }else{
                        model.improveScore = (model.improveScore ?? 0) + (item.score ?? 0)
                    }
                    model.isShowScoreAnimal = true
                    model.scoreAnimalValue = item.score ?? 0
                }
                let allModel = strongSelf.dataSource.first!
                allModel.score = (allModel.score ?? 0) + Int((item.score ?? 0) * selectComments.count)
                if isAdd{
                    allModel.praiseScore = (allModel.praiseScore ?? 0) + Int((item.score ?? 0) * selectComments.count)
                }else{
                    allModel.improveScore = (allModel.improveScore ?? 0) + Int((item.score ?? 0) * selectComments.count)
                }
            }
            strongSelf.publishView.items = strongSelf.dataSource
            strongSelf.yxs_updateCommentView()
        }
    }
    
    // MARK: -private
    func delectItems(items: [SLClassStarCommentItemModel], defultIndex: Int){
        var lists = alertModel.dataSource[defultIndex]
        for model in items{
            for source in lists{
                if model.id == source.id{
                    lists.remove(at: lists.firstIndex(of: source) ?? 0)
                    break
                }
            }
            
        }
        alertModel.dataSource[defultIndex] = lists
    }
    
    func updateItems(item: SLClassStarCommentItemModel, defultIndex: Int, isUpdate: Bool){
        var lists = [SLClassStarCommentItemModel]()
        if isUpdate{
            for model in alertModel.dataSource[defultIndex]{
                if model.id == item.id{
                    lists.append(item)
                }else{
                    lists.append(model)
                }
            }
        }else{
            for (index,model) in alertModel.dataSource[defultIndex].enumerated(){
                if index == 2{
                    lists.append(item)
                }
                lists.append(model)
            }
        }
        alertModel.dataSource[defultIndex] = lists
    }
    
    // MARK: -public
    
    
    // MARK: - getter&setter
    
    lazy var publishView: SLClassStarTeacherPublishView = {
        let publishView = SLClassStarTeacherPublishView()
        return publishView
    }()
    
    lazy var emptyView: YXSClassEmptyView = {
        let emptyView = YXSClassEmptyView()
        emptyView.isHidden = true
        return emptyView
    }()
    
    lazy var commentButton: YXSButton = {
        let btn = YXSButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.cornerRadius = 24.5
        btn.setTitle("点评", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        btn.addShadow(ofColor: UIColor.yxs_hexToAdecimalColor(hex: "#4C74F6"), radius: 7.5, offset: CGSize(width: 0, height: 3), opacity: 0.5)
        btn.addTarget(self, action: #selector(yxs_commentEvent), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
}

// MARK: -HMRouterEventProtocol
extension SLClassStarTeacherPublishCommentController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSClassStarTeacherPublishViewReloadDataEvent:
            loadAll = false
            yxs_loadData()
        case kYXSClassStarTeacherPublishViewUpdateCommentButtonEvent:
            yxs_updateCommentView()
        case kYXSClassStarTeacherPublishViewDoCommentEvent:
            yxs_dealComment(info?[kEventKey] as? SLClassStarChildrenModel)
        default:
            break
        }
    }
}


