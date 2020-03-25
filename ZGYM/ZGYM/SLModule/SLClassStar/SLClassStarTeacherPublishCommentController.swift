//
//  SLClassStarTeacherPublishCommentController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/5.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

class SLClassStarTeacherPublishCommentController: SLBaseViewController {
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
            sl_loadClassTopData()
        }else{
            sl_loadData()
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
    func sl_setEmptyView(){
        emptyView.classNum = model.classNo ?? ""
        emptyView.isHidden = false
        publishView.isHidden = true
    }
    
    func sl_updateCommentView(){
        if selectComments.count == 0{
            commentButton.isHidden = true
        }else{
            commentButton.isHidden = false
            commentButton.setTitle("点评(\(selectComments.count))", for: .normal)
        }
    }
    var loadAll = true
    // MARK: -sl_loadData
    let queue = DispatchQueue.global()
    let group = DispatchGroup()
    func sl_loadData(){
        if loadAll{
            group.enter()
            queue.async {
                self.sl_loadEvaluationListData()
            }
        }
        
        
        group.enter()
        queue.async {
            self.sl_loadClassChildrensData()
        }
        
        group.notify(queue: queue){
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                if let dataSource = self.dataSource{
                    if dataSource.count > 1{
                        self.publishView.items = dataSource
                    }else{
                        self.sl_setEmptyView()
                    }
                }
            }
        }
    }
    
    @objc func sl_loadClassTopData() {
        SLEducationClassStarTeacherClassTopRequest.init(classId: classId, dateType: model?.dateType ?? DateType.W).requestCollection({ (classs:[SLClassStartClassModel]) in
            
            if let model = classs.first{
                self.model = model
                self.sl_loadData()
                self.title = model.className
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast("\(msg)")
        }
    }
    
    func sl_loadClassChildrensData(){
        SLEducationClassStarTeacherClassChildrenTopRequest.init(classId: model.classId ?? 0, sortType: Int(publishView.selectModel.paramsKey) ?? 0, dateType: model.dateType).requestCollection({ (list:[SLClassStarChildrenModel]) in
            self.dataSource = list
            let allClassModel = SLClassStarChildrenModel.init(JSON: ["" : ""])!
            allClassModel.isAllChildren = true
            var improveScore = 0
            var praiseScore = 0
            for model in list{
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
            self.group.leave()
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
            self.group.leave()
        }
    }
    
    func sl_loadEvaluationListData(){
        SLEducationFEvaluationListListRequest.init(classId: model.classId ?? 0,stage: model.stageType).requestCollection({ (list: [SLClassStarCommentItemModel]) in
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
            self.group.leave()
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
            self.group.leave()
        }
    }
    
    
    // MARK: -action
    @objc func sl_commentEvent(){
        sl_dealComment(nil)
    }
    func sl_dealComment(_ model: SLClassStarChildrenModel?){
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
            strongSelf.sl_updateCommentView()
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
    
    lazy var emptyView: SLClassEmptyView = {
        let emptyView = SLClassEmptyView()
        emptyView.isHidden = true
        return emptyView
    }()
    
    lazy var commentButton: SLButton = {
        let btn = SLButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.cornerRadius = 24.5
        btn.setTitle("点评", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        btn.addShadow(ofColor: UIColor.sl_hexToAdecimalColor(hex: "#4C74F6"), radius: 7.5, offset: CGSize(width: 0, height: 3), opacity: 0.5)
        btn.addTarget(self, action: #selector(sl_commentEvent), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
}

// MARK: -HMRouterEventProtocol
extension SLClassStarTeacherPublishCommentController: SLRouterEventProtocol{
    func sl_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYMClassStarTeacherPublishViewReloadDataEvent:
            loadAll = false
            sl_loadData()
        case kYMClassStarTeacherPublishViewUpdateCommentButtonEvent:
            sl_updateCommentView()
        case kYMClassStarTeacherPublishViewDoCommentEvent:
            sl_dealComment(info?[kEventKey] as? SLClassStarChildrenModel)
        default:
            break
        }
    }
}


