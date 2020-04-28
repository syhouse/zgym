//
//  YXSClassStarCommentDelectListController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/6.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import NightNight

class YXSClassStarCommentDelectListController: YXSBaseTableViewController{
    var dataSource: [YXSClassStarCommentItemModel]
    var index: Int
    var complete: ((_ dataSource: [YXSClassStarCommentItemModel]) -> ())?
    init(_ dataSource: [YXSClassStarCommentItemModel], index: Int) {
        var lists = [YXSClassStarCommentItemModel]()
        for model in dataSource{
            if model.itemType == .Service && model.itemIsSystem == false{
                lists.append(model)
            }
        }
        self.dataSource = lists
        self.index = index
        super.init()
        hasRefreshHeader = false
        showBegainRefresh = false
    }
     
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selectItems:[YXSClassStarCommentItemModel]{
        get{
            var items = [YXSClassStarCommentItemModel]()
            for model in dataSource{
                if model.isSelected{
                    items.append(model)
                }
            }
            return items
        }
    }
    // MARK: -leftCicle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)

        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        tableView.rowHeight = 69
        tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(9.5)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        tableView.register(ClassStarCommentDelectListCell.self, forCellReuseIdentifier: "ClassStarCommentDelectListCell")
        
        let rightItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightItem
        
        let backButton = yxs_setNavLeftTitle(title: "取消")
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        backButton.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white), forState: .normal)
    }
    
    // MARK: - loadData
    func loadDelectData(_ indexPath: IndexPath? ){
        var evaluationIds = [Int]()
        
        if let indexPath = indexPath{
            evaluationIds = [dataSource[indexPath.row].id ?? 0]
        }else{
            for model in selectItems{
                evaluationIds.append(model.id ?? 0)
            }
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        YXSEducationFEvaluationListDeleteRequest.init(evaluationIds: evaluationIds).request({ (json) in
            MBProgressHUD.hide(for: self.view, animated: true)
            var delectItems = [YXSClassStarCommentItemModel]()
            if let indexPath = indexPath{
                delectItems.append(self.dataSource[indexPath.row])
                self.dataSource.remove(at: indexPath.row)
                
            }else{
                var newArrays = [YXSClassStarCommentItemModel]()
                for model in self.dataSource{
                    if model.isSelected == false{
                        newArrays.append(model)
                    }
                }
                delectItems = self.selectItems
                self.dataSource = newArrays
            }
            
            //update
            for vc in self.navigationController!.viewControllers{
                if vc is YXSClassStarCommentEditItemListController{
                    let listVc = vc as! YXSClassStarCommentEditItemListController
                    listVc.delectItems(items: delectItems, defultIndex: self.index)
                }
                if vc is YXSClassStarTeacherPublishCommentController{
                    let publishVc = vc as! YXSClassStarTeacherPublishCommentController
                    publishVc.delectItems(items: delectItems, defultIndex: self.index)
                }
                if vc is YXSClassStarSignleClassStudentDetialController{
                    let publishVc = vc as! YXSClassStarSignleClassStudentDetialController
                    publishVc.delectItems(items: delectItems, defultIndex: self.index)
                }
            }
            
            self.rightButton.isSelected = false
            self.updateEditItem()
            self.tableView.reloadData()
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: true)
            MBProgressHUD.yxs_showMessage(message: msg, inView: self.view)
        }
    }
    
    // MARK: - tableviewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassStarCommentDelectListCell") as! ClassStarCommentDelectListCell
        cell.selectionStyle = .none
        cell.yxs_setCellModel(dataSource[indexPath.row])
        let delectButton = MGSwipeButton.init(title: "", icon: UIImage.init(named: "yxs_classstar_edit_delect"), backgroundColor: kBlueColor)
        delectButton.buttonWidth = 69.5
        delectButton.callback = {
          [weak self](sender: MGSwipeTableCell!) -> Bool in
            guard let strongSelf = self else { return true}
            strongSelf.loadDelectData(indexPath)
          return true
        }
        cell.rightButtons = [delectButton]
        cell.rightSwipeSettings.transition = .rotate3D
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        model.isSelected = !model.isSelected
        tableView.reloadRows(at: [indexPath], with: .none)
        updateEditItem()
    }
    
    func updateEditItem(){
        if rightButton.isSelected{
            let count = selectItems.count
            rightButton.setTitle(count  == 0 ? "删除" :"删除(\(count))", for: .normal)
        }else{
            rightButton.setTitle("批量删除", for: .normal)
        }
    }
    
    // MARK: -action
    
    override func yxs_onBackClick() {
        for model in dataSource{
            model.isSelected = false
            model.isShowEdit = false
        }
        super.yxs_onBackClick()
    }
    
    @objc func rightClick(){
        if rightButton.isSelected{
            if selectItems.count == 0{
                yxs_showAlert(title: "请选择删除项")
                return
            }
            //do delect
            loadDelectData(nil)
        }
        else{
            rightButton.isSelected = true
            for model in dataSource{
                model.isShowEdit = true
                model.isSelected = false
            }
            updateEditItem()
            tableView.reloadData()
        }
    }
    
    // MARK: - getter&setter
    lazy var rightButton: UIButton = {
        self.navigationItem.rightBarButtonItem = nil
        let button = YXSButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        button.setTitleColor(NightNight.theme == .night ? UIColor.white : UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        button.setTitle("批量删除", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
        button.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        return button
    }()
    
}


// MARK: -HMRouterEventProtocol
extension YXSClassStarCommentDelectListController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kClassStarCommentDelectListUpdateUIEvent:
            updateEditItem()
        default:break
        }
    }
}


private let kClassStarCommentDelectListUpdateUIEvent = "ClassStarCommentDelectListUpdateUIEvent"

class ClassStarCommentDelectListCell: MGSwipeTableCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(selectButton)
        yxs_addLine(position: .bottom, leftMargin: 70, rightMargin: 0)
        
        
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 41, height: 41))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp_right).offset(14.5)
            make.centerY.equalTo(contentView)
        }
        
        selectButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(-17.5)
            make.width.height.equalTo(27)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func changeSelectClick(){
        model.isSelected = !model.isSelected
        selectButton.isSelected = model.isSelected
        next?.yxs_routerEventWithName(eventName: kClassStarCommentDelectListUpdateUIEvent)
    }

    var model:YXSClassStarCommentItemModel!
    func yxs_setCellModel(_ model: YXSClassStarCommentItemModel){
        self.model = model
        let newUrl = (model.evaluationUrl ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        iconImageView.sd_setImage(with: URL.init(string: newUrl),placeholderImage: kImageDefualtImage, completed: nil)
        UIUtil.yxs_setLabelAttributed(titleLabel, text: ["\(model.scoreDescribe ?? "")  ", "\(model.evaluationItem ?? "")"], colors: [kBlueColor,UIColor.yxs_hexToAdecimalColor(hex: "#575A60")])
        selectButton.isHidden = !model.isShowEdit
        selectButton.isSelected = model.isSelected
        
    }
    
    // MARK: -getter&setter
    
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.cornerRadius = 20.5
        return iconImageView
    }()
    
    lazy var selectButton: YXSButton = {
          let button = YXSButton.init()
          button.setImage(UIImage.init(named: "yxs_classstar_selected"), for: .selected)
          button.setImage(UIImage.init(named: "yxs_classstar_no_select"), for: .normal)
          button.addTarget(self, action: #selector(changeSelectClick), for: .touchUpInside)
          return button
      }()
    
}
