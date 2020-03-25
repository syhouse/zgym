//
//  SLFriendsCircleController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/13.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import ObjectMapper

import SwiftyJSON
import NightNight
import Photos

class SLFriendsCircleController: SLBaseTableViewController {
    // MARK: - 属性
    var dataSource: [SLFriendCircleModel] = [SLFriendCircleModel]()
    ///朋友圈个人列表
    var userIdPublisher: Int?
    var childrenId: Int?
    var gradeId: Int?
    var classCircleId: Int?
    var userType: String?
    var curruntIndexPath: IndexPath?
    
    var selectModels:[SLSelectModel]!
    var classes: [SLClassModel] = [SLClassModel]()
    var curruntSelectModel:SLSelectModel = SLSelectModel.init(text: "全部", isSelect: true, paramsKey: "all")
    var isDetial: Bool = false
    ///朋友圈单个列表
    
    // MARK: - init
    
    init(userIdPublisher: Int? = nil, userType: String? = nil) {
        self.userIdPublisher = userIdPublisher
        self.userType = userType
        super.init()
        tableViewIsGroup = true
    }
    
    //    SLEducationClassCircleTimeAxisDetailRequest
    convenience init(isDetial: Bool,classCircleId: Int? = nil){
        self.init(userIdPublisher: nil, userType:nil)
        self.classCircleId = classCircleId
        self.isDetial = isDetial
        
        hasRefreshHeader = false
        showBegainRefresh = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SLFriendsCircleCell.self, forCellReuseIdentifier: "SLFriendsCircleCell")
        tableView.register(SLFriendsCircleHeaderView.self, forHeaderFooterViewReuseIdentifier: "SLFriendsCircleHeaderView")
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        //去除group空白
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 0.01))
        tableView.snp.remakeConstraints { (make) in
            make.top.left.right.equalTo(0)
            if userIdPublisher == nil{
                make.bottom.equalTo(-kTabBottomHeight)
            }else{
                make.bottom.equalTo(-kSafeBottomHeight)
            }
        }
        
        
        //键盘输入
        self.view.addSubview(commentView)
        //优成长首页
        if userIdPublisher == nil && !isDetial{
            let rightButton = sl_setRightButton(mixedImage: MixedImage(normal: "sl_screening", night: "sl_screening_night"))
            rightButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -40)
            rightButton.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
            
            view.addSubview(publishButton)
            publishButton.snp.makeConstraints { (make) in
                make.right.equalTo(-15)
                make.bottom.equalTo(-kTabBottomHeight - 15)
                make.size.equalTo(CGSize.init(width: 51.5, height: 51.5))
            }
            
            self.dataSource = SLCacheHelper.sl_getCacheFriendsList()
            for model in self.dataSource{
                model.confingHeight()
                for  comment in model.comments ?? [SLFriendsCommentModel](){
                    comment.configHeight()
                }
            }
        }
        
        if isDetial{
            title = "详情"
            
        }
        
        
        addNotification()
        
        if isDetial{
            loadDetialData()
        }
        
        
        
        self.showGuide()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadHeaderMessageUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: -UI
    /// 头部消息
    @objc func reloadHeaderMessageUI(){
        if userIdPublisher == nil && !isDetial{
            if SLPersonDataModel.sharePerson.friendsTips?.count ?? 0 > 0{
                tableView.tableHeaderView = messageView
                messageView.reloadData()
            }else{
                tableView.tableHeaderView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 0.01))
            }
        }
    }
    var isShowGuide = false
    func showGuide(){
        if SLPersonDataModel.sharePerson.personRole == .PARENT{
            var isShowPartentFriendGuide = UserDefaults.standard.bool(forKey: "isShowPartentFriendGuide")
            if !isShowPartentFriendGuide{
                isShowGuide = true
                //                let serviceDataSource = dataSource
                var sources = [SLFriendCircleModel]()
                let friendCircleModel = SLFriendCircleModel.init(JSON: ["" : ""])!
                friendCircleModel.content = "我们养花浇水施肥，给她春雨阳光，希望她茁壮成长，香飘四方；我们培养孩子，更希望她朝气蓬勃天天向上，希望我的孩子们像葵花像青松，植根于祖国的神州大地。"
                friendCircleModel.namePublisher = "优学生官方助手"
                friendCircleModel.avatarImage = UIImage.init(named: "sl_logo")
                friendCircleModel.attachment = "sl_friends_guide_1,sl_friends_guide_2,sl_friends_guide_3"
                friendCircleModel.noComment = NoComment.NO.rawValue
                sources.append(friendCircleModel)
                dataSource = sources
                tableView.reloadData()
                
                self.view.layoutIfNeeded()
                var items = [SLGuideModel]()
                let headerView = self.tableView.headerView(forSection: 0)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                    if let headerView  = headerView as? SLFriendsCircleHeaderView{
                        let shareFrame = headerView.convert(headerView.friendCircleContentView.shareButton.frame, to: self.tabBarController?.view)
                        let shareModel = SLGuideModel.init(type: SLGuideType.mask, maskFrame: CGRect.init(x: shareFrame.minX - 10, y: shareFrame.minY - 5, width: SCREEN_WIDTH - (shareFrame.minX - 5) - 8.5, height: shareFrame.height + 10), maskCornerRadius: 15, imageFrame: CGRect.init(x: SCREEN_WIDTH - 15 - 197, y: shareFrame.maxY + 5, width: 197, height: 135.5), imageName: "sl_guide_partent_3")
                        items.append(shareModel)
                    }
                    let publishFrame = self.view.convert(self.publishButton.frame, to: self.tabBarController!.view)
                    let publishiModel = SLGuideModel.init(type: SLGuideType.mask, maskFrame: CGRect.init(x: publishFrame.minX - 10, y: publishFrame.minY - 10, width: publishFrame.width + 20, height: publishFrame.width + 20), maskCornerRadius: (publishFrame.width + 20)/2, imageFrame: CGRect.init(x: SCREEN_WIDTH - 11 - 161, y: publishFrame.maxY - (publishFrame.width + 10) - 135, width: 160.5, height: 135), imageName: "sl_guide_teacher_2")
                    items.append(publishiModel)
                    
                    let selectFrame = CGRect.init(x: SCREEN_WIDTH - 44 - 7, y: kSafeTopHeight + 20, width: 44, height: 44)
                    let selectModel = SLGuideModel.init(type: SLGuideType.mask, maskFrame: selectFrame, maskCornerRadius: 22, imageFrame: CGRect.init(x: SCREEN_WIDTH - 10 - 125, y: selectFrame.maxY, width: 125, height: 136), imageName: "sl_guide_partent_4")
                    items.append(selectModel)
                    SLGuideViewWindow.showGuideViewWindow(items: items){
                        [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.isShowGuide = false
                        strongSelf.reloadHeaderMessageUI()
                        strongSelf.tableView.reloadData()
                    }
                }
                
                UserDefaults.standard.set(true, forKey: "isShowPartentFriendGuide")
            }
        }
    }
    
    // MARK: - loadData
    override func sl_refreshData() {
        self.curruntPage = 1
        loadData()
    }
    
    override func sl_loadNextPage() {
        loadData()
    }
    
    func loadData(){
        if !SLPersonDataModel.sharePerson.isNetWorkingConnect{
            self.dataSource = SLCacheHelper.sl_getCacheFriendsList()
            for model in self.dataSource{
                model.confingHeight()

            }
            return
        }
        
        let own = curruntSelectModel.paramsKey == "own" ? true : nil
        let paramsIndex: Int? = Int(curruntSelectModel.paramsKey)
        var typePublisher: PersonRole?
        if let userType = userType{
            typePublisher = userType == PersonRole.TEACHER.rawValue ? PersonRole.TEACHER : .PARENT
        }else{
            typePublisher = curruntSelectModel.paramsKey == PersonRole.TEACHER.rawValue ? PersonRole.TEACHER : nil
        }
        
        SLEducationClassCircleTimeAxisPageRequest.init(current: curruntPage, own: own, typePublisher: typePublisher, gradeId: paramsIndex, userIdPublisher: userIdPublisher).request({ (json) in
            self.sl_endingRefresh()
            if self.curruntPage == 1{
                self.dataSource.removeAll()
            }
            let list = Mapper<SLFriendCircleModel>().mapArray(JSONObject: json["records"].object) ?? [SLFriendCircleModel]()
            //计算高度
            for  model in list{
                model.confingHeight()
            }
            self.dataSource += list
            self.loadMore = json["total"].intValue == self.dataSource.count ? false : true
            
            
            //            DispatchQueue.global().async {
            //
            //            }
            
            if !self.isShowGuide{
                self.reloadHeaderMessageUI()
                self.tableView.reloadData()
            }
            SLCacheHelper.sl_cacheFriendsList(dataSource: self.dataSource)
        }) { (msg, code) in
            self.sl_endingRefresh()
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    
    
    
    func loadDetialData(){
        SLEducationClassCircleTimeAxisDetailRequest.init(classCircleId: classCircleId ?? 0).request({ (model:SLFriendCircleModel) in
            model.confingHeight()
            for  comment in model.comments ?? [SLFriendsCommentModel](){
                comment.configHeight()
            }
            self.dataSource = [model]
            self.tableView.reloadData()
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    func loadDelectCommentData(_ section: Int = 0,commentModel: SLFriendsCommentModel){
        var positon = SLOperationPosition.friendCircle
        if isDetial || userIdPublisher != nil{
            positon = .list
        }
        let SLFriendCircleModel = dataSource[section]
        UIUtil.sl_changeCommentFriendCirclePrise(SLFriendCircleModel.classCircleId ?? 0, commentId: commentModel.id ?? 0,positon: positon) { [weak self](model) in
            guard let strongSelf = self else { return }
            if let curruntIndexPath  = strongSelf.curruntIndexPath{
                SLFriendCircleModel.comments?.remove(at: curruntIndexPath.row)
            }
            strongSelf.reloadTableView()
        }
    }
    func loadCommentData(_ section: Int = 0,classCircleId: Int,content: String,commentModel: SLFriendsCommentModel?){
        
        let SLFriendCircleModel = dataSource[section]
        var positon = SLOperationPosition.friendCircle
        if isDetial || userIdPublisher != nil{
            positon = .list
        }
        UIUtil.sl_changeCommentFriendCirclePrise(SLFriendCircleModel.classCircleId ?? 0,commentModel: commentModel,content: content,positon: positon) { [weak self](model) in
            guard let strongSelf = self else { return }
            model.configHeight()
            if SLFriendCircleModel.comments != nil {
                SLFriendCircleModel.comments?.append(model)
            }else{
                SLFriendCircleModel.comments = [model]
            }
            
            strongSelf.reloadTableViewToScrollComment(section: section)
        }
    }
    
    // MARK: - action
    @objc func rightClick(){
        if SLPersonDataModel.sharePerson.personRole == .PARENT{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            SLEducationClassOptionalGradeListRequest().requestCollection({ (classs:[SLClassModel]) in
                //                self.classes = classs
                MBProgressHUD.hide(for: self.view, animated: true)
                var classIds = [Int]()
                var classNames = [String]()
                for model in classs{
                    if classIds.contains(model.id ?? 0){
                        continue
                    }else{
                        classIds.append(model.id ?? 0)
                        classNames.append(model.name ?? "")
                    }
                }
                self.selectModels = [SLSelectModel.init(text: "全部", isSelect: false, paramsKey: "all"),SLSelectModel.init(text: "只看老师的", isSelect: false, paramsKey: "TEACHER")]
                for index in 0..<classIds.count{
                    let selectModel = SLSelectModel.init(text: classNames[index], isSelect: false, paramsKey: "\(classIds[index])")
                    self.selectModels.append(selectModel)
                }
                self.showSelectView()
            }) { (msg, code) in
                MBProgressHUD.hide(for: self.view, animated: true)
                self.view.makeToast("\(msg)")
            }
        }else{
            selectModels = [SLSelectModel.init(text: "全部", isSelect: false, paramsKey: "all"),SLSelectModel.init(text: "仅看我的", isSelect: false, paramsKey: "own")]
            showSelectView()
        }
    }
    
    @objc func publishClick(){
        let vc = SLFriendPublishController()
        if vc.isExitLocal{
            self.navigationController?.pushViewController(vc)
        }else{
            let  selectMediaHelper = SLSelectMediaHelper.shareHelper
            selectMediaHelper.showSelectMedia( selectAll: true, customVideo: true, maxCount: 9) { [weak self](model) in
                guard let strongSelf = self else { return }
                strongSelf.pushPublish(assets: [model])
            }
            selectMediaHelper.delegate = self
        }
        
    }
    
    // MARK: - showWindownUI
    func showSelectView(){
        var isExit = false
        for model in selectModels{
            if model.paramsKey == curruntSelectModel.paramsKey{
                model.isSelect = true
                isExit = true
                break
            }
        }
        if !isExit{
            selectModels.first?.isSelect = true
        }
        SLHomeListSelectView.showAlert(offset: CGPoint.init(x: 8, y: 58 + kSafeTopHeight), selects: selectModels) { [weak self](selectModel,selectModels) in
            guard let strongSelf = self else { return }
            strongSelf.selectModels = selectModels
            strongSelf.curruntSelectModel = selectModel
            strongSelf.sl_refreshData()
        }
    }
    
    // MARK: - Notification
    @objc func keyBoardWillShow(_ notification:Notification){
        if UIUtil.TopViewController() == self{
            DispatchQueue.main.async {
                let user_info = notification.userInfo
                let keyboardRect = (user_info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                if let curruntIndexPath = self.curruntIndexPath{
                    let cell = self.tableView.cellForRow(at: curruntIndexPath)
                    if let friendCell  = cell as? SLFriendsCircleCell{
                        
                        let rc = friendCell.convert(friendCell.comentLabel.frame, to: self.view)
                        
                        let offsetY = (SCREEN_HEIGHT - rc.maxY) - (keyboardRect.height + 40) - rc.height
                        var contentSet = self.tableView.contentOffset
                        contentSet.y -= offsetY
                        if contentSet.y >= 0 {
                            self.tableView.setContentOffset(contentSet, animated: true)
                        }
                        self.commentView.frame = CGRect.init(x: 0, y: self.view.height - keyboardRect.height - self.commentView.height - 40, width: self.commentView.width, height: self.commentView.height)
                    }
                }
            }
        }
        
    }
    @objc func keyBoardWillHide(_ notification:Notification){
        if UIUtil.TopViewController() == self{
            DispatchQueue.main.async {
                self.commentView.isHidden = true
            }
        }
    }
    
    // MARK: - private
    func showDelectComment(_ commentModel: SLFriendsCommentModel,_ point: CGPoint, section: Int){
        var pointInView = point
        if let curruntIndexPath = self.curruntIndexPath{
            let cell = self.tableView.cellForRow(at: curruntIndexPath)
            if let friendCell  = cell as? SLFriendsCircleCell{
                
                let rc = friendCell.convert(friendCell.comentLabel.frame, to: self.view)
                let offsetY = rc.minY + point.y + kTabBottomHeight
                pointInView.y = offsetY + 14
            }
        }
        SLFriendsCircleDelectCommentView.showAlert(pointInView) {
            [weak self]in
            guard let strongSelf = self else { return }
            strongSelf.loadDelectCommentData(section, commentModel: commentModel)
        }
    }
    
    func showComment(_ commentModel: SLFriendsCommentModel? = nil, section: Int){
        let SLFriendCircleModel = dataSource[section]
        if SLFriendCircleModel.noComment == NoComment.YES.rawValue || commentModel?.isMyComment ?? false{
            return
        }
        let tips = commentModel == nil ? "评论：" : "回复\(commentModel!.showUserName ?? "")："
        SLFriendsCommentAlert.showAlert(tips) { [weak self](content) in
            guard let strongSelf = self else { return }
            strongSelf.loadCommentData(section,classCircleId: SLFriendCircleModel.classCircleId ?? 0, content: content!, commentModel: commentModel)
        }
        
    }
    
    func recallEvent(_ section: Int){
        var positon = SLOperationPosition.friendCircle
        if isDetial || userIdPublisher != nil{
            positon = .list
        }
        let SLFriendCircleModel = dataSource[section]
        UIUtil.sl_loadRecallData(.friendCicle, id: SLFriendCircleModel.classCircleId ?? 0,positon: positon) {
            self.dataSource.remove(at: section)
            self.reloadTableView()
        }
    }
    func changePrise(_ section: Int){
        var positon = SLOperationPosition.friendCircle
        if isDetial || userIdPublisher != nil{
            positon = .list
        }
        let SLFriendCircleModel = dataSource[section]
        UIUtil.sl_changeFriendCirclePrise(SLFriendCircleModel,positon: positon) {
            self.reloadTableView(section: section)
        }
    }
    
    func goToUserInfoController(_ section: Int){
        let model =  dataSource[section]
        let vc = SLFriendsCircleInfoController.init(userId:  model.userIdPublisher ?? 0, childId: model.childrenId ?? 0, type: model.typePublisher ?? "")
        self.navigationController?.pushViewController(vc)
    }
    //    _ section: Int
    func reloadTableView(section: Int? = nil, scroll: Bool = false){
        //        none
        //缓存数据
        SLCacheHelper.sl_cacheFriendsList(dataSource: self.dataSource)
        //
        //        let contentoffSet = tableView.contentOffset
        
        
        UIView.performWithoutAnimation {
            //            tableView.reloadData()
            if let section = section{
                tableView.reloadSections(IndexSet.init(arrayLiteral: section), with: UITableView.RowAnimation.none)
            }else{
                tableView.reloadData()
            }
        }
        
        if let section = section,scroll{
            tableView.selectRow(at: IndexPath.init(row: 0, section: section), animated: false, scrollPosition: .top)
        }
    }
    
    
    /// 点评滚动居中
    /// - Parameter section: section
    func reloadTableViewToScrollComment(section: Int){
        //        none
        //缓存数据
        SLCacheHelper.sl_cacheFriendsList(dataSource: self.dataSource)
        
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet.init(arrayLiteral: section), with: UITableView.RowAnimation.none)
            let count: Int? = self.dataSource[section].comments?.count
            if let count = count,count > 0{
                tableView.selectRow(at: IndexPath.init(row: count - 1, section: section), animated: false, scrollPosition: .middle)
            }
        }
        
    }
    
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
        if let comments = dataSource[section].comments{
            return comments.count + 1
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let friendModel = dataSource[section]
        return friendModel.friendHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 14
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == dataSource[indexPath.section].comments?.count{
            return 0
        }
        let cellHeight = dataSource[indexPath.section].comments?[indexPath.row].cellHeight ?? 0
        return (indexPath.row == (dataSource[indexPath.section].comments?.count ?? 0) - 1) ? cellHeight + 3 : cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FriendsCircleFooterView")
        if footerView == nil{
            footerView = UITableViewHeaderFooterView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 14))
            let lineView = UIView.init(frame: CGRect.init(x: 0, y: 13, width: self.view.width, height: 0.5))
            lineView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#E6EAF3"), night: kNight2F354B)
            footerView?.addSubview(lineView)
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = dataSource[section]
        model.isShowDay = userIdPublisher == nil ? false : true
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SLFriendsCircleHeaderView") as? SLFriendsCircleHeaderView
        if let headerView = headerView{
            headerView.setModel(dataSource[section])
            headerView.headerBlock = {[weak self](type) in
                guard let strongSelf = self else { return }
                switch type {
                case .comment:
                    strongSelf.showComment(section:section)
                case .praise:
                    strongSelf.changePrise(section)
                case .showAll:
                    strongSelf.showAllRefresh(section: section, isScroll: !model.isShowAll)
                case .recall:
                    strongSelf.recallEvent(section)
                case .goToUserInfo:
                    strongSelf.goToUserInfoController(section)
                case .share:
                    UIUtil.sl_shareLink(requestModel: HMRequestShareModel.init(classCircleId: model.classCircleId ?? 0,classCircleType: model.circleType), shareModel: SLShareModel(way: SLShareWayType.QQSession, title: "\(model.namePublisher ?? "")分享了一条优成长", descriptionText: model.shareText, link: ""))
                }
            }
        }
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SLFriendsCircleCell") as! SLFriendsCircleCell
        cell.selectionStyle = .none
        let SLFriendCircleModel = dataSource[indexPath.section]
        if let comments = SLFriendCircleModel.comments{
            if indexPath.row < comments.count{
                cell.contentView.isHidden = false
                cell.sl_setCellModel(comments[indexPath.row])
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
                
                cell.isMyPublish = SLFriendCircleModel.isMyPublish
                cell.isLastRow = indexPath.row == comments.count - 1
            }else{
                cell.contentView.isHidden = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let comments = dataSource[indexPath.section].comments{
            self.curruntIndexPath = indexPath
            self.showComment(comments[indexPath.row], section: indexPath.section)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //视图滚动时隐藏长按的悬浮菜单
        if UIMenuController.shared.isMenuVisible {
            UIMenuController.shared.setMenuVisible(false, animated: false)
        }
        self.resignFirstResponder()
    }
    
    // MARK: - getter&setter
    lazy var commentView: SLFriendsCommentView = {
        let commentView = SLFriendsCommentView.init(frame: CGRect.init(x: 0, y: 0, width: view.width, height: 40))
        return commentView
    }()
    
    lazy var publishButton: SLButton = {
        let button = SLButton()
        button.setBackgroundImage(UIImage.init(named: "publish"), for: .normal)
        button.addTarget(self, action: #selector(publishClick), for: .touchUpInside)
        return button
    }()
    lazy var messageView: SLFriendsCircleMessageView = {
        let messageView = SLFriendsCircleMessageView.init(frame: CGRect.init(x: 0, y: 0, width: view.width, height: 42.5))
        return messageView
    }()
    
}

// MARK: - HMRouterEventProtocol
extension SLFriendsCircleController: SLRouterEventProtocol{
    func sl_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kFriendsCircleMessageViewGoMessageEvent:
            let vc = SLFriendCircleListController()
            vc.loadSucess = {
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.reloadHeaderMessageUI()
            }
            self.navigationController?.pushViewController(vc)
        default:
            break
        }
    }
}

// MARK: - MediaHelper
extension SLFriendsCircleController: SLSelectMediaHelperDelegate{
    func pushPublish(assets: [SLMediaModel]){
        let vc = SLFriendPublishController.init(nil, medias: assets)
        vc.complete = {
            [weak self](_,_) in
            guard let strongSelf = self else { return }
            strongSelf.sl_refreshData()
        }
        self.navigationController?.pushViewController(vc)
    }
    
    func didSelectMedia(asset: SLMediaModel) {
        self.pushPublish(assets: [asset])
    }
    
    func didSelectSourceAssets(assets: [SLMediaModel]) {
        self.pushPublish(assets: assets)
    }
}

// MARK: -

extension SLFriendsCircleController{
    func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_ :)),name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_ :)),name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //班级圈首页
        if !isDetial && userIdPublisher == nil{
            NotificationCenter.default.addObserver(self, selector: #selector(updateListForRecall), name: NSNotification.Name.init(rawValue: kOperationRecallInItemListNotification), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(updateListForRecall), name: NSNotification.Name.init(rawValue: kOperationRecallInHomeNotification), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(updateListForRecall), name: NSNotification.Name.init(rawValue: kOperationRecallInSingleClassHomeNotification), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(updateListForPraise), name: NSNotification.Name.init(rawValue: kOperationPraiseInItemHomeNotification), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(updateListForPraise), name: NSNotification.Name.init(rawValue: kOperationPraiseInItemListNotification), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(updateListForComment), name: NSNotification.Name.init(rawValue: kOperationCommentInItemListNotification), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(reloadMessageData), name: NSNotification.Name.init(rawValue: kChatCallRefreshFriendsCircleNotification), object: nil)
        }
    }
    
    
    /// 刷新消息
    @objc func reloadMessageData(){
        UIUtil.sl_loadClassCircleMessageListData(){
            self.reloadHeaderMessageUI()
        }
        sl_refreshData()
    }
    
    @objc func updateListForRecall(_ notification:Notification){
        let userInfo = notification.object as? [String: Any]
        if let serviceId = userInfo?[kNotificationIdKey] as? Int{
            for (index,model) in dataSource.enumerated(){
                if model.classCircleId == serviceId{
                    dataSource.remove(at: index)
                    self.reloadTableView()
                    break
                }
            }
        }
    }
    
    @objc func updateListForComment(_ notification:Notification){
        let userInfo = notification.object as? [String: Any]
        if let isAddComment = userInfo?[kNotificationIsDelectKey] as? Bool,let commentModel = userInfo?[kNotificationModelKey] as? SLFriendsCommentModel,let classCircleId = userInfo?[kNotificationIdKey] as? Int{
            for (section,SLFriendCircleModel) in dataSource.enumerated(){
                if classCircleId == SLFriendCircleModel.classCircleId{
                    if isAddComment{
                        if var comments = SLFriendCircleModel.comments{
                            comments.append(commentModel)
                            SLFriendCircleModel.comments = comments
                        }else{
                            SLFriendCircleModel.comments = [commentModel]
                        }
                        reloadTableView()
                    }else{
                        if var comments = SLFriendCircleModel.comments{
                            for comment in comments{
                                if commentModel.id == comment.id{
                                    comments.remove(at: comments.firstIndex(of: commentModel) ?? 0)
                                    SLFriendCircleModel.comments = comments
                                    reloadTableView()
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func updateListForPraise(_ notification:Notification){
        let userInfo = notification.object as? [String: Any]
        if let isCancel = userInfo?[kNotificationIsCancelKey] as? Bool,let praiseModel = userInfo?[kNotificationModelKey] as? SLFriendsPraiseModel,let classCircleId = userInfo?[kNotificationIdKey] as? Int{
            for (section,SLFriendCircleModel) in dataSource.enumerated(){
                if classCircleId == SLFriendCircleModel.classCircleId{
                    if isCancel{
                        if var praiseList = SLFriendCircleModel.praises{
                            for praise in praiseList{
                                if praiseModel.userId == praise.userId && praiseModel.userType == praise.userType{
                                    praiseList.remove(at: praiseList.firstIndex(of: praise) ?? 0)
                                    SLFriendCircleModel.praises = praiseList
                                    reloadTableView()
                                    break
                                }
                            }
                        }
                    }else{
                        if var praises = SLFriendCircleModel.praises{
                            praises.append(praiseModel)
                            SLFriendCircleModel.praises = praises
                        }else{
                            SLFriendCircleModel.praises = [praiseModel]
                        }
                        reloadTableView()
                    }
                }
            }
        }
    }
    
}
