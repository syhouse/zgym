//
//  YXSHomeworkHistoryGoodVC.swift
//  ZGYM
//
//  Created by yihao on 2020/4/30.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight
import ObjectMapper
import UIKit

class YXSHomeworkHistoryGoodVC: YXSBaseTableViewController {
    var dataSource: [YXSHomeworkDetailModel] = [YXSHomeworkDetailModel]()
    /// 被点击的孩子id
    var childid: Int?
    /// 班级id
    var classId: Int?
    /// 当前操作的 IndexPath
    var curruntIndexPath: IndexPath!
    var cancelGoodBlock: ((_ homeworkId: Int) ->())?
    init(classId: Int,childid: Int,cancelGoodBlock:((_ homeworkId: Int) ->())? = nil) {
        self.childid = childid
        self.classId = classId
        self.cancelGoodBlock = cancelGoodBlock
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        tableViewIsGroup = true
        super.viewDidLoad()
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.register(YXSHomeworkDetailCell.self, forCellReuseIdentifier: "YXSHomeworkDetailCell")
        tableView.register(YXSHomeworkDetailSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "YXSHomeworkDetailSectionHeaderViewHistory")
        tableView.register(YXSPunchCardDetialTableFooterView.self, forHeaderFooterViewReuseIdentifier: "YXSPunchCardDetialTableFooterView")
        self.dataSource = YXSCacheHelper.yxs_getCacheHomeworkHistoryGoodListTask(childrenId: self.childid ?? 0, classId: self.classId ?? 0)
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: -loadData
    override func yxs_refreshData() {
        curruntPage = 1
        loadData()
        
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    func loadData(){
        YXSEducationHomeworkQueryHistoryGoodRequest.init(childrenId: self.childid ?? 0, classId: self.classId ?? 0, currentPage: curruntPage).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            weakSelf.yxs_endingRefresh()
            let joinList = Mapper<YXSHomeworkDetailModel>().mapArray(JSONObject: json["homeworkCommitList"].object) ?? [YXSHomeworkDetailModel]()
            for join in joinList {
//                join.remarkVisible = weakSelf.detailModel.remarkVisible
                if let backImageUrl = join.backImageUrl, backImageUrl.count <= 0 {
                    join.backImageUrl = join.imageUrl
                }
            }
            weakSelf.loadMore = json["hasNext"].boolValue
            if weakSelf.curruntPage == 1 {
                weakSelf.dataSource.removeAll()
            }
            weakSelf.dataSource += joinList
            if weakSelf.dataSource.count == 0 {
                weakSelf.tableView.tableFooterView = weakSelf.tableFooterView
            } else {
                weakSelf.tableView.tableFooterView = weakSelf.tableWhFooterView
            }
            YXSCacheHelper.yxs_cacheHomeworkHistoryGoodListTask(data: weakSelf.dataSource, childrenId: weakSelf.childid ?? 0, classId: weakSelf.classId ?? 0)
            weakSelf.tableView.reloadData()
        }) { (msg, code) in
            self.yxs_endingRefresh()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Action
    func showComment(_ commentModel: YXSHomeworkCommentModel? = nil, section: Int){
        if commentModel?.isMyComment ?? false{
            return
        }
        let tips = commentModel == nil ? "评论：" : "回复\(commentModel!.showUserName ?? "")："
        YXSFriendsCommentAlert.showAlert(tips, maxCount: 400) { [weak self](content) in
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
        let listModel = dataSource[section]
        
        var requset: YXSBaseRequset!
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            if let commentModel = commentModel{
                requset = YXSEducationHomeworkCommentRequest.init(childrenId: listModel.childrenId ?? 0, homeworkCreateTime: listModel.homeworkCreateTime ?? "", content: content, homeworkId: listModel.homeworkId ?? 0, type: "REPLY" ,id: commentModel.id ?? 0)
            }else{
                requset = YXSEducationHomeworkCommentRequest.init(childrenId: listModel.childrenId ?? 0, homeworkCreateTime: listModel.homeworkCreateTime ?? "", content: content, homeworkId: listModel.homeworkId ?? 0, type: "COMMENT" )
            }
        }else{
            if let commentModel = commentModel{
                requset = YXSEducationHomeworkCommentRequest.init(childrenId: listModel.childrenId ?? 0, homeworkCreateTime: listModel.homeworkCreateTime ?? "", content: content, homeworkId: listModel.homeworkId ?? 0, type: "REPLY" ,id: commentModel.id ?? 0)
                
            }else{
                requset = YXSEducationHomeworkCommentRequest.init(childrenId: listModel.childrenId ?? 0, homeworkCreateTime: listModel.homeworkCreateTime ?? "", content: content, homeworkId: listModel.homeworkId ?? 0, type: "COMMENT" )
            }
        }
        requset.request({ (model:YXSHomeworkCommentModel) in
            if listModel.commentJsonList != nil {
                listModel.commentJsonList?.append(model)
            }else{
                listModel.commentJsonList = [model]
            }
            self.reloadTableViewToScrollComment(section: section)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
    }
    
    func loadDelectCommentData(_ section: Int = 0,commentModel: YXSHomeworkCommentModel){
        let listModel = dataSource[section]
        
        var requset: YXSBaseRequset!
        requset = YXSEducationHomeworkCommentDeleteRequest.init(childrenId: listModel.childrenId ?? 0, homeworkCreateTime: listModel.homeworkCreateTime ?? "", homeworkId: listModel.homeworkId ?? 0, id: commentModel.id ?? 0)
        requset.request({ (result) in
            if let curruntIndexPath  = self.curruntIndexPath{
                listModel.commentJsonList?.remove(at: curruntIndexPath.row)
            }
            self.reloadTableView(section: section, scroll: false)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
    }
    
    //    _ section: Int
    func reloadTableView(section: Int? = nil, scroll: Bool = false){
        UIView.performWithoutAnimation {
            if let section = section{
                let offset = tableView.contentOffset
                tableView.reloadSections(IndexSet.init(arrayLiteral: section), with: UITableView.RowAnimation.none)
                if !scroll{//为什会会跳动 why
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
                          self.tableView.setContentOffset(offset, animated: false)
                      }
                }
            }else{
                tableView.reloadData()
            }
            tableView.reloadData()
        }
        
        if let section = section,scroll{
            tableView.selectRow(at: IndexPath.init(row: 0, section: section), animated: false, scrollPosition: .top)
        }
        
    }
    
    /// 点评滚动居中
    /// - Parameter section: section
    func reloadTableViewToScrollComment(section: Int){
        //                none
        let model = self.dataSource[section]
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet.init(arrayLiteral: section), with: UITableView.RowAnimation.none)
            let count: Int? = model.commentJsonList?.count
            //是否需要点评滚动居中 (当前处于收起点评状态不滚动)
            if let count = count,count > 0 && !(model.isNeeedShowCommentAllButton && !model.isShowCommentAll){
                tableView.selectRow(at: IndexPath.init(row: count - 1, section: section), animated: false, scrollPosition: .middle)
            }
        }
        
    }
    
    
    func setHomeworkGoodEvent(_ section: Int){
        let model = dataSource[section]
        if model.isExpired{
            MBProgressHUD.yxs_showMessage(message: "当前作业已过期")
        } else {
            YXSEducationHomeworkInTeacherChangeGoodRequest.init(childrenId: model.childrenId ?? 0, homeworkCreateTime: model.homeworkCreateTime ?? "", homeworkId: model.homeworkId ?? 0, isGood: 0).request({ (result) in
                
                self.dataSource.remove(at: section)
                if self.dataSource.count == 0 {
                    self.tableView.tableFooterView = self.tableFooterView
                } else {
                    self.tableView.tableFooterView = self.tableWhFooterView
                }
                self.tableView.reloadData()
                self.cancelGoodBlock?(0)
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
    }
    
    // MARK: -点击展开刷新
    /// 点击展开刷新
    /// - Parameters:
    ///   - section: section
    ///   - isScroll: 是否滚动
    func showAllRefresh(section: Int, isScroll: Bool = false){
        var scroll = false
        let headerView = tableView.headerView(forSection: section)
        if let headerView = headerView, isScroll{
            let rc = tableView.convert(headerView.frame, to: self.view)
            SLLog(rc)
            if rc.minY < 0{
                scroll = true
            }
        }
        
        reloadTableView(section:section,scroll: scroll)
    }
    
    // MARK: - tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count > section {
            let model = dataSource[section]
            if let comments = model.commentJsonList {
                var commentsCount = comments.count
                if model.isNeeedShowCommentAllButton && !model.isShowCommentAll{
                    commentsCount = 3
                }
                return  commentsCount
            }
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSHomeworkDetailCell") as! YXSHomeworkDetailCell
        cell.selectionStyle = .none
        let model = dataSource[indexPath.section]
        if let comments = model.commentJsonList{
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
        let model = dataSource[section]
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YXSHomeworkDetailSectionHeaderViewHistory") as? YXSHomeworkDetailSectionHeaderView
        if let headerView = headerView{
            headerView.curruntSection = section
            headerView.hmModel = model
            model.isShowLookGoodButton = false
            headerView.setModel(model: model)
            let cl = NightNight.theme == .night ? kNightBackgroundColor : kTableViewBackgroundColor
            headerView.yxs_addLine(position: .top, color: cl, lineHeight: 0.5)
            headerView.goodClick = { [weak self](model)in
                guard let weakSelf = self else {return}
                weakSelf.setHomeworkGoodEvent(section)
            }
            headerView.reviewControlBlock = { [weak self](model)in
                guard let weakSelf = self else {return}
                if model.isExpired{
                    MBProgressHUD.yxs_showMessage(message: "当前作业已过期")
                } else {
                    let vc = YXSHomeworkCommentController()
                    let homeModel = YXSHomeListModel.init(JSON: ["" : ""])
                    homeModel?.serviceId = model.homeworkId
                    homeModel?.createTime = model.homeworkCreateTime
                    homeModel?.teacherId = model.teacherId
                    homeModel?.teacherName = model.teacherName
                    vc.initChangeReview(myReviewModel: model, model: homeModel!)
                    vc.childrenIdList = [(model.childrenId ?? 0)]
                    vc.isPop = true
                    //点评成功后 刷新数据
                    vc.commetCallBack = { (list)in
                        weakSelf.loadData()
                        weakSelf.cancelGoodBlock?(model.homeworkId ?? 0)
                    }
                    weakSelf.navigationController?.pushViewController(vc)
                }
            }
            headerView.remarkView.remarkChangeBlock = { [weak self](sender,model)in
                guard let weakSelf = self else {return}
                let point = UIApplication.shared.keyWindow?.convert(sender.bounds.origin, to: sender)
                let offsetY = fabsf(Float(point!.y))
                YXSHomeListSelectView.showAlert(offset: CGPoint(x: 15, y: CGFloat(offsetY) + 20), isShowSelectBtn: false, selects: weakSelf.changeModels) { [weak self](selectModel, selectModels) in
                    guard let strongSelf = self else { return }
                    if model.isExpired{
                        MBProgressHUD.yxs_showMessage(message: "当前作业已过期")
                    } else {
                        let selectType = SLCommonScreenSelectType.init(rawValue: selectModel.paramsKey) ?? .all
                        if selectType == .change {
                            //修改
                            let vc = YXSHomeworkCommentController()
                            vc.isChangeRemark = true
                            let homeModel = YXSHomeListModel.init(JSON: ["" : ""])
                            homeModel?.serviceId = model.homeworkId
                            homeModel?.createTime = model.homeworkCreateTime
                            homeModel?.teacherId = model.teacherId
                            homeModel?.teacherName = model.teacherName
                            vc.initChangeReview(myReviewModel: model, model: homeModel!)
                            vc.childrenIdList = [(model.childrenId ?? 0)]
    //                        vc.isPop = true
                            //点评成功后 刷新数据
                            vc.commetCallBack = { (list)in
                                weakSelf.loadData()
                                weakSelf.cancelGoodBlock?(model.homeworkId ?? 0)
                            }
                            weakSelf.navigationController?.pushViewController(vc)
                        } else if selectType == .recall {
                            //撤回
                            let alert = UIAlertController.init(title: "提示", message: "您是否撤回本条点评？", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
                                MBProgressHUD.yxs_showLoading()
                                YXSEducationHomeworkRemarkCancel(homeworkId: model.homeworkId ?? 0, childrenId: model.childrenId ?? 0, homeworkCreateTime: model.homeworkCreateTime ?? "").request({ (json) in
                                    MBProgressHUD.yxs_hideHUD()
                                    MBProgressHUD.yxs_showMessage(message: "删除点评成功")
                                    strongSelf.loadData()
                                    strongSelf.cancelGoodBlock?(model.homeworkId ?? 0)
                                }, failureHandler: { (msg, code) in
                                    MBProgressHUD.yxs_showMessage(message: msg)
                                })
                            }))
                            alert.popoverPresentationController?.sourceView = UIUtil.curruntNav().view
                            UIUtil.curruntNav().present(alert, animated: true, completion: nil)
                        }
                    }
                    
                }
            }
            headerView.cellBlock = { [weak self](type,model: YXSHomeworkDetailModel) in
                guard let weakSelf = self else {return}
                switch type {
                case .comment:
                    weakSelf.showComment(section:section)
                    break
                case .showAll:
                    weakSelf.showAllRefresh(section: section, isScroll: !model.isShowContentAll)
                case .praise:
                    YXSEducationHomeworkPraiseRequest(childrenId: model.childrenId ?? 0, homeworkCreateTime: model.homeworkCreateTime ?? "", homeworkId: model.homeworkId ?? 0).request({ [weak self](json) in
                        guard let strongSelf = self else {return}
                        model.praiseJson = json.stringValue
                        strongSelf.dataSource[section] = model
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight: CGFloat = 0
        //是否是最后一行 最后一行需要补偿高度
        var isLastRow = false
        let model = dataSource[indexPath.section]
        if let comments = model.commentJsonList{
            var commentsCount = comments.count
            if model.isNeeedShowCommentAllButton && !model.isShowCommentAll{
                commentsCount = 3
                isLastRow = true
            }
            if indexPath.row < commentsCount{
                let commetModel = comments[indexPath.row]
                cellHeight = commetModel.cellHeight
                if indexPath.row == comments.count - 1{
                    isLastRow = true
                }
                
                if isLastRow{
                    cellHeight += 8.0
                }
            }
        }
        return cellHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let model = self.dataSource[section]
        return model.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let model = dataSource[section]
        return model.isNeeedShowCommentAllButton ? 40.0 : 10.0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let model = dataSource[section]
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YXSPunchCardDetialTableFooterView") as! YXSPunchCardDetialTableFooterView
        footerView.setFooterHomeworkModel(model)
        footerView.footerBlock = {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.reloadTableView(section: section, scroll: false)
        }
        return footerView
    }
    
    // MARK: - LazyLoad
    lazy var changeModels:[YXSSelectModel] = {
        var selectModels = [YXSSelectModel.init(text: "修改", isSelect: false, paramsKey: SLCommonScreenSelectType.change.rawValue),YXSSelectModel.init(text: "撤回", isSelect: false, paramsKey: SLCommonScreenSelectType.recall.rawValue)]
        return selectModels
    }()
    
    lazy var tableFooterView: UIView = {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
        let imageView = UIImageView.init(frame: CGRect(x: 52, y: 30, width: SCREEN_WIDTH - 104, height: 188))
        imageView.mixedImage = MixedImage(normal: "yxs_homework_defultImage_nodata", night: "yxs_defultImage_nodata_night")
        imageView.contentMode = .scaleAspectFit
        footer.addSubview(imageView)
        
        let lbl = UILabel.init(frame: CGRect(x: 0, y: 228, width: SCREEN_WIDTH, height: 20))
        lbl.text = "暂无历史优秀作业"
        lbl.textAlignment = .center
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        lbl.font = UIFont.systemFont(ofSize: 15)
        footer.addSubview(lbl)
        return footer
    }()
    
    lazy var tableWhFooterView: UIView = {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 20))
        return footer
    }()
}
