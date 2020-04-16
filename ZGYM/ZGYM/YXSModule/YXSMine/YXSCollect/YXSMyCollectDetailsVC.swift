//
//  YXSMyCollectDetailsVC.swift
//  ZGYM
//
//  Created by yihao on 2020/4/14.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import NightNight
import ObjectMapper
import SwiftyJSON
import MJRefresh

enum YXSCollectType {
    /// 声音
    case voice
    /// 专辑
    case album
}

class YXSMyCollectDetailsVC: YXSBaseViewController,UITableViewDelegate, UITableViewDataSource{

    var type: YXSCollectType = .voice
    var dataSource: [YXSMyCollectModel] = [YXSMyCollectModel]()
    var currentIndex: Int = 0
    var curruntPage: Int = 1
    /// 是否下拉加载更多
    var loadMore: Bool = false{
        didSet{
            if self.loadMore{
                self.tableView.mj_footer = tableRefreshFooter
            }else{
                self.tableView.mj_footer = nil
                self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
    override init(){
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }

        self.title = "我的收藏"
        self.loadData()
    }
    
    func loadData() {
        if type == .voice {
            YXSEducationBabyVoiceCollectionPageRequest.init(current: self.curruntPage, size: 20).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                if weakSelf.curruntPage == 1 {
                    weakSelf.dataSource.removeAll()
                }
                let joinList = Mapper<YXSMyCollectModel>().mapArray(JSONObject: json["records"].object) ?? [YXSMyCollectModel]()
                if json["pages"].intValue > weakSelf.curruntPage {
                    weakSelf.loadMore = true
                } else {
                    weakSelf.loadMore = false
                }
                weakSelf.dataSource += joinList
                weakSelf.tableView.reloadData()
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        } else {
            YXSEducationBabyAlbumCollectionPageRequset.init(current: self.curruntPage, size: 20).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                if weakSelf.curruntPage == 1 {
                    weakSelf.dataSource.removeAll()
                }
                let joinList = Mapper<YXSMyCollectModel>().mapArray(JSONObject: json["records"].object) ?? [YXSMyCollectModel]()
                if json["pages"].intValue > weakSelf.curruntPage {
                    weakSelf.loadMore = true
                } else {
                    weakSelf.loadMore = false
                }
                weakSelf.dataSource += joinList
                weakSelf.tableView.reloadData()
            }, failureHandler: { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            })
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Action
    @objc func headerBtnClick(sender: UIButton) {
        switch sender.tag {
        case 2001:
            type = .voice
            leftBtn.isSelected = true
            rightBtn.isSelected = false
            rightBtn.yxs_removeLine()
            leftBtn.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), leftMargin: 40, rightMargin: 40, lineHeight: 2)
        case 2002:
            type = .album
            rightBtn.isSelected = true
            leftBtn.isSelected = false
            leftBtn.yxs_removeLine()
            rightBtn.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), leftMargin: 40, rightMargin: 40, lineHeight: 2)
        default:
            print("")
        }
        self.loadData()
    }
    
    
    /// 取消收藏
    /// - Parameter id: 收藏的声音id或者专辑id
    func cancelCollect(id:Int, Type:YXSCollectType) {
        if Type == .voice {
            YXSEducationBabyVoiceCollectionCancelRequest.init(voiceId: id).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                MBProgressHUD.yxs_showMessage(message: "取消收藏成功")
                weakSelf.dataSource.remove(at: weakSelf.currentIndex)
                weakSelf.tableView.deleteRows(at: [IndexPath.init(row: weakSelf.currentIndex, section: 0)], with: .left)
                if weakSelf.dataSource.count == 0 {
                    weakSelf.tableView.reloadData()
                }
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
                self.currentIndex = 0
            }
        } else {
            YXSEducationBabyAlbumCollectionCancelRequest.init(albumId: id).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                MBProgressHUD.yxs_showMessage(message: "取消收藏成功")
                weakSelf.dataSource.remove(at: weakSelf.currentIndex)
                weakSelf.tableView.deleteRows(at: [IndexPath.init(row: weakSelf.currentIndex, section: 0)], with: .left)
                if weakSelf.dataSource.count == 0 {
                    weakSelf.tableView.reloadData()
                }
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
                self.currentIndex = 0
            }
        }
    }
    
    // MARK: - UITableViewDataSource，UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if leftBtn.isSelected {
            let cell: YXSMyCollectDetailsCell = tableView.dequeueReusableCell(withIdentifier: "YXSMyCollectDetailsCell") as! YXSMyCollectDetailsCell
            let model = dataSource[indexPath.row]
            cell.setModel(model: model)
            if indexPath.row == 0 {
                cell.yxs_addLine(position: LinePosition.top, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 15, rightMargin: 0, lineHeight: 0.5)
            }
            cell.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 15, rightMargin: 0, lineHeight: 0.5)
            return cell
        } else {
            let cell: YXSMyCollectAlbumCell = tableView.dequeueReusableCell(withIdentifier: "YXSMyCollectAlbumCell") as! YXSMyCollectAlbumCell
            let model = dataSource[indexPath.row]
            cell.setModel(model: model)
            if indexPath.row == 0 {
                cell.yxs_addLine(position: LinePosition.top, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 15, rightMargin: 0, lineHeight: 0.5)
            }
            cell.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 15, rightMargin: 0, lineHeight: 0.5)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tabHeaderView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if leftBtn.isSelected {
            return 60.0
        } else {
            return 93.0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataSource[indexPath.row]
        if type == .voice {
//            YXSEducationXMLYTracksGetBatchRequest
            YXSEducationXMLYTracksGetBatchRequest.init(ids: "\(model.voiceId ?? 0)").request({ [weak self](json) in
                guard let weakSelf = self else {return}
                let joinList = Mapper<YXSTrackModel>().mapArray(JSONObject: json["tracks"].object) ?? [YXSTrackModel]()
                if joinList.count > 0 {
                    let curruntTrack = joinList.first
                    let vc = YXSPlayingViewController()
                    let track = XMTrack.init(dictionary: curruntTrack?.toJSON())
                    vc.track = track
                    vc.trackList = [track!]
                    weakSelf.navigationController?.pushViewController(vc)
                }
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        } else {
            let vc = YXSContentDetialController.init(id: model.albumId ?? 0)
            self.navigationController?.pushViewController(vc)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = dataSource[indexPath.row]
            currentIndex = indexPath.row
            if type == .voice {
                self.cancelCollect(id: model.voiceId ?? 0, Type: .voice)
            } else {
                self.cancelCollect(id: model.albumId ?? 0, Type: .album)
            }
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "取消收藏"
    }
    
    // MARK: -列表为空
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    override func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
//    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
//        return 140
//    }
    
    // MARK: - LazyLoad
    lazy var tabHeaderView: UIView = {
        let tabHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
        tabHeaderView.addSubview(leftBtn)
        tabHeaderView.addSubview(rightBtn)
        
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(1)
            make.bottom.equalTo(-1)
            make.width.equalTo(SCREEN_WIDTH * 0.5)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.top.equalTo(1)
            make.bottom.equalTo(-1)
            make.width.equalTo(SCREEN_WIDTH * 0.5)
        }
        
        tabHeaderView.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 1)
        return tabHeaderView
    }()
    
    lazy var leftBtn: UIButton = {
        let leftBtn = UIButton.init()
        leftBtn.setTitle("声音", for: .normal)
        leftBtn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        leftBtn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), for: .selected)
        leftBtn.tag = 2001
        leftBtn.addTarget(self, action: #selector(headerBtnClick(sender:)), for: .touchUpInside)
        leftBtn.isSelected = true
        leftBtn.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), leftMargin: 40, rightMargin: 40, lineHeight: 2)
        return leftBtn
    }()
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton.init()
        rightBtn.setTitle("专辑", for: .normal)
        rightBtn.tag = 2002
        rightBtn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        rightBtn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), for: .selected)
        rightBtn.addTarget(self, action: #selector(headerBtnClick(sender:)), for: .touchUpInside)
        return rightBtn
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.delegate = self
        return scrollView
    }()
    
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
        tableView.estimatedSectionHeaderHeight = 0
        //去除group空白
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.estimatedRowHeight = 50
        tableView.register(YXSMyCollectDetailsCell.self, forCellReuseIdentifier: "YXSMyCollectDetailsCell")
        tableView.register(YXSMyCollectAlbumCell.self, forCellReuseIdentifier: "YXSMyCollectAlbumCell")
        return tableView
    }()
    
    lazy var tableRefreshFooter = MJRefreshBackStateFooter.init(refreshingBlock: {[weak self] in
        guard let strongSelf = self else { return }
        strongSelf.curruntPage += 1
        strongSelf.loadData()
    })
}
