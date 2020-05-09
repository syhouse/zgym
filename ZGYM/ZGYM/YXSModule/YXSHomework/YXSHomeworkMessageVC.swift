//
//  YXSHomeworkMessageVC.swift
//  ZGYM
//
//  Created by yihao on 2020/4/10.
//  Copyright © 2020 hmym. All rights reserved.
//  作业互动消息详情页面

import Foundation
import NightNight
import YYText
import MJRefresh
import ObjectMapper

class YXSHomeworkMessageVC: YXSBaseViewController, UITableViewDelegate, UITableViewDataSource {
    var detailModel: YXSHomeworkDetailModel?
    var homeModel:YXSHomeListModel
    var messageModel:YXSHomeworkMessageModel
    /// 老师发布作业详情模型
    var deModel: YXSHomeworkDetailModel?
    /// 当前操作的 IndexPath
    var curruntIndexPath: IndexPath!
    
    init(deModel: YXSHomeworkDetailModel, model: YXSHomeListModel, messageModel:YXSHomeworkMessageModel) {
        self.deModel = deModel
        self.homeModel = model
        self.messageModel = messageModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详情"
        self.view.addSubview(self.tableView)
        tableView.register(YXSHomeworkDetailCell.self, forCellReuseIdentifier: "YXSHomeworkDetailCell")
        tableView.register(YXSHomeworkDetailSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "YXSHomeworkDetailSectionHeaderView")
        tableView.register(YXSPunchCardDetialTableFooterView.self, forHeaderFooterViewReuseIdentifier: "YXSPunchCardDetialTableFooterView")
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        refreshData()
    }
    
    func refreshData() {
        YXSEducationHomeworkQueryHomeworkCommitByIdRequest(childrenId: self.messageModel.childrenId ?? 0, homeworkCreateTime: self.homeModel.createTime ?? "", homeworkId: self.homeModel.serviceId ?? 0).request({ [weak self](model:YXSHomeworkDetailModel) in
            guard let weakSelf = self else {return}
            weakSelf.detailModel = model
            weakSelf.deModel?.teacherId = model.teacherId
            weakSelf.deModel?.teacherName = model.teacherName
            weakSelf.deModel?.homeworkEndTime = model.homeworkEndTime
            weakSelf.deModel?.endTime = model.homeworkEndTime
            weakSelf.deModel?.homeworkCreateTime = model.homeworkCreateTime
             weakSelf.tableView.reloadData()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Action
    func showComment(_ commentModel: YXSHomeworkCommentModel? = nil, section: Int){
        if commentModel?.isMyComment ?? false{
            return
        }
        let tips = commentModel == nil ? "评论：" : "回复\(commentModel!.showUserName ?? "")："
        YXSFriendsCommentAlert.showAlert(tips) { [weak self](content) in
            guard let strongSelf = self else { return }
            strongSelf.loadCommentData(section, content: content!, commentModel: commentModel)
            
        }
    }
    
    func showDelectComment(_ commentModel: YXSHomeworkCommentModel,_ point: CGPoint, section: Int){
        var pointInView = point
        if let curruntIndexPath = self.curruntIndexPath{
            let cell = self.tableView.cellForRow(at: curruntIndexPath)
            if let listCell  = cell as? YXSHomeworkDetailCell{
                let rc = listCell.convert(listCell.comentLabel.frame, to: UIUtil.curruntNav().view)
                pointInView.y = rc.minY + 14.0
            }
        }
        YXSFriendsCircleDelectCommentView.showAlert(pointInView) {
            [weak self]in
            guard let strongSelf = self else { return }
            strongSelf.loadDelectCommentData(section, commentModel: commentModel)
        }
    }
    
    func loadCommentData(_ section: Int = 0,content: String,commentModel: YXSHomeworkCommentModel?){
        let listModel = detailModel
        
        var requset: YXSBaseRequset!
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            if let commentModel = commentModel{
                requset = YXSEducationHomeworkCommentRequest.init(childrenId: listModel?.childrenId ?? 0, homeworkCreateTime: self.homeModel.createTime!, content: content, homeworkId: self.homeModel.serviceId ?? 0, type: "REPLY" ,id: commentModel.id ?? 0)
            }else{
                requset = YXSEducationHomeworkCommentRequest.init(childrenId: listModel?.childrenId ?? 0, homeworkCreateTime: self.homeModel.createTime!, content: content, homeworkId: self.homeModel.serviceId ?? 0, type: "COMMENT" )
            }
        }else{
            if let commentModel = commentModel{
                requset = YXSEducationHomeworkCommentRequest.init(childrenId: listModel?.childrenId ?? 0, homeworkCreateTime: self.homeModel.createTime!, content: content, homeworkId: self.homeModel.serviceId ?? 0, type: "REPLY" ,id: commentModel.id ?? 0)
                
            }else{
                requset = YXSEducationHomeworkCommentRequest.init(childrenId: listModel?.childrenId ?? 0, homeworkCreateTime: self.homeModel.createTime!, content: content, homeworkId: self.homeModel.serviceId ?? 0, type: "COMMENT" )
            }
        }
        requset.request({ (model:YXSHomeworkCommentModel) in
            if listModel?.commentJsonList != nil {
                listModel?.commentJsonList?.append(model)
            }else{
                listModel?.commentJsonList = [model]
            }
            self.detailModel = listModel
            self.reloadTableViewToScrollComment(section: section)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
    }
    
    func loadDelectCommentData(_ section: Int = 0,commentModel: YXSHomeworkCommentModel){
        let listModel = detailModel
        
        var requset: YXSBaseRequset!
        requset = YXSEducationHomeworkCommentDeleteRequest.init(childrenId: listModel?.childrenId ?? 0, homeworkCreateTime: self.homeModel.createTime!, homeworkId: self.homeModel.serviceId ?? 0, id: commentModel.id ?? 0)
        requset.request({ (result) in
            if let curruntIndexPath  = self.curruntIndexPath{
                listModel?.commentJsonList?.remove(at: curruntIndexPath.row)
            }
            self.detailModel = listModel
            self.reloadTableView(section: section, scroll: false)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
    }
    
    //    _ section: Int
    func reloadTableView(section: Int? = nil, scroll: Bool = false){
        UIView.performWithoutAnimation {
            tableView.reloadData()
        }
    }
    
    /// 点评滚动居中
    /// - Parameter section: section
    func reloadTableViewToScrollComment(section: Int){
        //                none
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet.init(arrayLiteral: section), with: UITableView.RowAnimation.none)
            let count: Int? = detailModel?.commentJsonList?.count
            //是否需要点评滚动居中 (当前处于收起点评状态不滚动)
            if let count = count,count > 0 && !(detailModel?.isNeeedShowCommentAllButton ?? false && !(detailModel?.isShowCommentAll ?? false)){
                tableView.selectRow(at: IndexPath.init(row: count - 1, section: section), animated: false, scrollPosition: .middle)
            }
        }
        
    }
    
    func setHomeworkGoodEvent(_ section: Int,isGood: Int){
        YXSEducationHomeworkInTeacherChangeGoodRequest.init(childrenId: detailModel?.childrenId ?? 0, homeworkCreateTime: self.homeModel.createTime!, homeworkId: self.homeModel.serviceId ?? 0, isGood: isGood).request({ (result) in
//            self.refreshHomeworkData(index: self.isGood)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }

    // MARK: - tableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let comments = detailModel?.commentJsonList {
            var commentsCount = comments.count
            if detailModel?.isNeeedShowCommentAllButton ?? false && !(detailModel?.isShowCommentAll ?? false){
                commentsCount = 3
            }
            return  commentsCount
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSHomeworkDetailCell") as! YXSHomeworkDetailCell
        cell.selectionStyle = .none
        let model = detailModel
        if let comments = model?.commentJsonList{
            if indexPath.row < comments.count{
                cell.contentView.isHidden = false
                cell.yxs_setCellModel(comments[indexPath.row])
                cell.commentBlock = {
                    [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.curruntIndexPath = indexPath
                    strongSelf.showComment(comments[indexPath.row], section: indexPath.section)
                }
                cell.cellLongTapEvent = {
                    [weak self](point) in
                    guard let strongSelf = self else { return }
                    strongSelf.curruntIndexPath = indexPath
                    strongSelf.showDelectComment(comments[indexPath.row], point, section: indexPath.section)
                }

                cell.isNeedCorners = indexPath.row == comments.count - 1
            }else{
                cell.contentView.isHidden = true
            }
        }else{
            cell.contentView.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.detailModel != nil {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YXSHomeworkDetailSectionHeaderView") as? YXSHomeworkDetailSectionHeaderView
            if let headerView = headerView{
                self.detailModel?.isShowLookGoodButton = false
                headerView.hmModel = self.deModel
                headerView.model = self.detailModel
    //            let cl = NightNight.theme == .night ? kNightBackgroundColor : kTableViewBackgroundColor
    //            headerView.yxs_addLine(position: .top, color: cl, lineHeight: 0.5)
                headerView.goodClick = { [weak self](model)in
                    guard let weakSelf = self else {return}
                    if model.isGood ?? 0 == 0 {
                        weakSelf.setHomeworkGoodEvent(section, isGood: 1)
                    } else {
                        weakSelf.setHomeworkGoodEvent(section, isGood: 0)
                    }
                }
                headerView.reviewControlBlock = { [weak self](model)in
                    guard let weakSelf = self else {return}
                    let vc = YXSHomeworkCommentController()
                    vc.initChangeReview(myReviewModel: model, model: weakSelf.homeModel)
//                    vc.homeModel = weakSelf.homeModel
                    vc.childrenIdList = [(model.childrenId ?? 0)]
                    vc.isPop = true
                    //点评成功后 刷新数据
                    vc.commetCallBack = { () -> () in
                        weakSelf.refreshData()
                    }
                    weakSelf.navigationController?.pushViewController(vc)
                }
                headerView.remarkView.remarkChangeBlock = { [weak self](sender,model)in
                    guard let weakSelf = self else {return}
                    let point = UIApplication.shared.keyWindow?.convert(sender.bounds.origin, to: sender)
                    let offsetY = fabsf(Float(point!.y))
                    YXSHomeListSelectView.showAlert(offset: CGPoint(x: 15, y: CGFloat(offsetY) + 20), isShowSelectBtn: false, selects: weakSelf.changeModels) { [weak self](selectModel, selectModels) in
                        guard let strongSelf = self else { return }
                        let selectType = SLCommonScreenSelectType.init(rawValue: selectModel.paramsKey) ?? .all
                        if selectType == .change {
                            //修改
                            let vc = YXSHomeworkCommentController()
                            vc.isChangeRemark = true
                            vc.initChangeReview(myReviewModel: model, model: weakSelf.homeModel)
                            vc.childrenIdList = [(model.childrenId ?? 0)]
    //                        vc.isPop = true
                            //点评成功后 刷新数据
                            vc.commetCallBack = { () -> () in
                                weakSelf.refreshData()
                            }
                            weakSelf.navigationController?.pushViewController(vc)
                        } else if selectType == .recall {
                            //撤回
                            let alert = UIAlertController.init(title: "提示", message: "您是否撤回本条点评？", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
                                MBProgressHUD.yxs_showLoading()
                                YXSEducationHomeworkRemarkCancel(homeworkId: strongSelf.homeModel.serviceId ?? 0, childrenId: model.childrenId ?? 0, homeworkCreateTime: strongSelf.homeModel.createTime ?? "").request({ (json) in
                                    MBProgressHUD.yxs_hideHUD()
                                    MBProgressHUD.yxs_showMessage(message: "删除点评成功")
                                    strongSelf.refreshData()
                                }, failureHandler: { (msg, code) in
                                    MBProgressHUD.yxs_showMessage(message: msg)
                                })
                            }))
                            alert.popoverPresentationController?.sourceView = UIUtil.curruntNav().view
                            UIUtil.curruntNav().present(alert, animated: true, completion: nil)
                        }
                    }
                }
                headerView.homeWorkChangeBlock = { [weak self](sender,model)in
                    guard let weakSelf = self else {return}
                    let point = UIApplication.shared.keyWindow?.convert(sender.bounds.origin, to: sender)
                    let offsetY = fabsf(Float(point!.y))
                    YXSHomeListSelectView.showAlert(offset: CGPoint(x: 15, y: CGFloat(offsetY) + 20), isShowSelectBtn: false, selects: weakSelf.changeModels) { [weak self](selectModel, selectModels) in
                        guard let strongSelf = self else { return }
                        let selectType = SLCommonScreenSelectType.init(rawValue: selectModel.paramsKey) ?? .all
                        if selectType == .change {
                            //修改
                            let vc = YXSHomeworkPublishController.init(mySubmitModel: model, model: strongSelf.homeModel)
                            vc.changeSubmitSucess = { (newModel) in
                                strongSelf.detailModel = newModel
                                strongSelf.tableView.reloadData()
                            }
                            strongSelf.navigationController?.pushViewController(vc)
                        } else if selectType == .recall {
                            //撤回
                            let alert = UIAlertController.init(title: "提示", message: "您是否撤回该作业？", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
                                MBProgressHUD.yxs_showLoading()
                                YXSEducationHomeworkStudentCancelRequest(childrenId: model.childrenId  ?? 0, homeworkCreateTime:strongSelf.homeModel.createTime ?? "" ,homeworkId:strongSelf.homeModel.serviceId  ?? 0).request({ (json) in
                                    MBProgressHUD.yxs_hideHUD()
                                    MBProgressHUD.yxs_showMessage(message: "删除作业成功")
                                    strongSelf.navigationController?.yxs_existViewController(existClass: YXSHomeworkDetailViewController.init(model: strongSelf.homeModel), complete: { (isExist, resultVC) in
                                        if isExist {
                                            resultVC.refreshData()
                                            strongSelf.navigationController?.popToViewController(resultVC, animated: true)
                                        } else {
                                            strongSelf.navigationController?.popViewController()
                                        }
                                    })
                                    strongSelf.homeModel.commitState = 1
                                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOperationStudentWorkNotification), object: [kNotificationModelKey: strongSelf.homeModel])
//                                    strongSelf.refreshData()
                                }, failureHandler: { (msg, code) in
                                    MBProgressHUD.yxs_showMessage(message: msg)
                                })
                            }))
                            alert.popoverPresentationController?.sourceView = UIUtil.curruntNav().view
                            UIUtil.curruntNav().present(alert, animated: true, completion: nil)
                        }
                    }
                }
                headerView.cellBlock = { [weak self](type,model: YXSHomeworkDetailModel) in
                    guard let weakSelf = self else {return}
                    switch type {
                    case .comment:
                        weakSelf.showComment(section:section)
                        break
                    case .praise:
                        YXSEducationHomeworkPraiseRequest(childrenId: model.childrenId ?? 0, homeworkCreateTime: weakSelf.homeModel.createTime ?? "", homeworkId: weakSelf.homeModel.serviceId ?? 0).request({ [weak self](json) in
                            guard let strongSelf = self else {return}
                            model.praiseJson = json.stringValue
                            strongSelf.detailModel = model
                            UIView.performWithoutAnimation {
                                strongSelf.tableView.reloadSections(IndexSet.init(arrayLiteral: section), with: UITableView.RowAnimation.none)
                            }
                        }) { (msg, code) in
                            MBProgressHUD.yxs_showMessage(message: msg)
                        }
                        break
                    default:
                        break
                    }
                }
            }

            return headerView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight: CGFloat = 0
        let model = detailModel
        if let comments = model?.commentJsonList{
            var commentsCount = comments.count
            if model?.isNeeedShowCommentAllButton ?? false && !(model?.isShowCommentAll ?? false){
                commentsCount = 3
            }
            if indexPath.row < commentsCount{
                let commetModel = comments[indexPath.row]
                cellHeight = commetModel.cellHeight
                if indexPath.row == comments.count - 1{
                    cellHeight += 8.0
                }
            }
        }
        return cellHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if detailModel != nil {
            return detailModel!.headerHeight
        }
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if detailModel != nil {
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YXSPunchCardDetialTableFooterView") as! YXSPunchCardDetialTableFooterView
            footerView.setFooterHomeworkModel(detailModel!)
            footerView.footerBlock = {[weak self] in
                guard let strongSelf = self else { return }
                strongSelf.reloadTableView()
            }
            return footerView
        }
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if detailModel != nil {
            return detailModel!.isNeeedShowCommentAllButton ? 40.0 : 0.01
        }
        return 0.01
    }
    
    
    // MARK: - LazyLoad
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mixedBackgroundColor = MixedColor.init(normal: UIColor.white, night: kNightBackgroundColor)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        tableView.estimatedSectionHeaderHeight = 0.0
        //去除group空白
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.estimatedRowHeight = 50
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()
    
    lazy var changeModels:[YXSSelectModel] = {
        var selectModels = [YXSSelectModel.init(text: "修改", isSelect: false, paramsKey: SLCommonScreenSelectType.change.rawValue),YXSSelectModel.init(text: "撤回", isSelect: false, paramsKey: SLCommonScreenSelectType.recall.rawValue)]
        return selectModels
    }()
}
