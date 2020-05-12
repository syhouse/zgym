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
import JXCategoryView

class YXSMyCollectDetailsVC: YXSBaseTableViewController,JXCategoryListContentViewDelegate{

    var type: YXSCollectType = .voice
    var dataSource: [YXSMyCollectModel] = [YXSMyCollectModel]()
    var currentIndex: Int = 0

    func listView() -> UIView! {
        return self.view
    }
    
    init(type: YXSCollectType) {
        super.init()
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.scrollView.snp.remakeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.register(YXSMyCollectDetailsCell.self, forCellReuseIdentifier: "YXSMyCollectDetailsCell")
        tableView.register(YXSMyCollectAlbumCell.self, forCellReuseIdentifier: "YXSMyCollectAlbumCell")
        if type == .voice {
            self.dataSource = YXSCacheHelper.yxs_getCacheMyCollectionVoiceTask()
        } else {
            self.dataSource = YXSCacheHelper.yxs_getCacheMyCollectionAlbumTask()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    // MARK: -loadData
    override func yxs_refreshData() {
        curruntPage = 1
        loadData()
        
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    func loadData() {
        if type == .voice {
            YXSEducationBabyVoiceCollectionPageRequest.init(current: self.curruntPage, size: 20).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                weakSelf.yxs_endingRefresh()
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
                weakSelf.refreshData()
            }) { (msg, code) in
                self.yxs_endingRefresh()
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        } else {
            YXSEducationBabyAlbumCollectionPageRequset.init(current: self.curruntPage, size: 20).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                weakSelf.yxs_endingRefresh()
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
                weakSelf.refreshData()
            }, failureHandler: { (msg, code) in
                self.yxs_endingRefresh()
                MBProgressHUD.yxs_showMessage(message: msg)
            })
        }
    }
    
    func refreshData() {
        if type == .voice {
            YXSCacheHelper.yxs_cacheMyCollectionVoiceTask(dataSource: self.dataSource)
        } else {
            YXSCacheHelper.yxs_cacheMyCollectionAlbumTask(dataSource: self.dataSource)
        }
        
        self.tableView.reloadData()
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == .voice {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if type == .voice {
            return 60.0
        } else {
            return 93.0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataSource[indexPath.row]
        if type == .voice {
            YXSEducationXMLYTracksGetBatchRequest.init(ids: "\(model.voiceId ?? 0)").request({ [weak self](json) in
                guard let weakSelf = self else {return}
                let joinList = Mapper<YXSTrackModel>().mapArray(JSONObject: json["tracks"].object) ?? [YXSTrackModel]()
                if joinList.count > 0 {
                    let curruntTrack = joinList.first
                    if let  track = XMTrack.init(dictionary: curruntTrack?.toJSON()){
                        let vc = YXSPlayingViewController.init(track: track, trackList: [track])
                        weakSelf.navigationController?.pushViewController(vc)
                    }
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
    
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 10
    }
    
    // MARK: - LazyLoad
    
}
