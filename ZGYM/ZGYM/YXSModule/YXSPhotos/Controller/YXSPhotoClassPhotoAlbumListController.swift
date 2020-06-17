//
//  YXSPhotoClassPhotoAlbumListController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/2/27.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper

/// 相册列表
class YXSPhotoClassPhotoAlbumListController: YXSBaseCollectionViewController, UICollectionViewDelegateFlowLayout {
    var dataSource: [YXSPhotoAlbumsModel] = [YXSPhotoAlbumsModel]()
    var messageInfo: YXSPhotoClassPhotoAlbumListMsgModel?
    
    let classId: Int
    init(classId: Int) {
        self.classId = classId
        super.init()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 6
        layout.sectionInset = UIEdgeInsets.init(top: 20, left: 15, bottom: 0, right: 15)
        let itemW = (SCREEN_WIDTH - CGFloat(15*2) - CGFloat(2*6))/3
        layout.itemSize = CGSize.init(width: itemW, height: itemW + 49.5)
        
        self.layout = layout
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "班级相册"

        collectionView.register(YXSPhotoAlbumsListCell.self, forCellWithReuseIdentifier: "YXSPhotoAlbumsListCell")
        collectionView.register(YXSFriendsCircleMessageView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "YXSFriendsCircleMessageView")
    }
    
    override func yxs_refreshData() {
        self.currentPage = 1
        yxs_loadData()
    }
    
    override func yxs_loadNextPage() {
        yxs_loadData()
    }
    
    func yxs_loadData() {
        YXSEducationAlbumPagequeryRequest.init(classId: classId, currentPage: currentPage).request({ [weak self](result) in
            guard let weakSelf = self else {return}
            weakSelf.yxs_endingRefresh()
            
            weakSelf.messageInfo = Mapper<YXSPhotoClassPhotoAlbumListMsgModel>().map(JSONObject: result["messageInfo"].object)
            
            if weakSelf.currentPage == 1{
                weakSelf.dataSource.removeAll()
            }
            let list = Mapper<YXSPhotoAlbumsModel>().mapArray(JSONObject: result["classAlbumList"].object) ?? [YXSPhotoAlbumsModel]()
            weakSelf.dataSource += list
            
            if list.count != 0 && YXSPersonDataModel.sharePerson.personRole == .TEACHER{
                let createAlbums = YXSPhotoAlbumsModel.init(JSON: ["": ""])
                createAlbums?.isSystemCreateItem = true
                weakSelf.dataSource.insert(createAlbums!, at: 0)
            }
            weakSelf.loadMore = result["hasNext"].boolValue
            
            weakSelf.collectionView.reloadData()
        }) { (msg, code) in
            self.yxs_endingRefresh()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - public
    public func updateCover(cover: String, albumId: Int){
        for model in dataSource{
            if model.id == albumId{
                model.coverUrl = cover
                break
            }
        }
        collectionView.reloadData()
    }
    
    // MARK: - Action
    /// 创建相册
    @objc func createAlbumClick() {
        let vc = YXSPhotoCreateAlbumController(classId: classId)
        vc.changeAlbumBlock = {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.yxs_refreshData()
        }
        self.navigationController?.pushViewController(vc)
    }
    
    /// 删除相册
    /// - Parameter albumModel: 相册modle
    func removeAlbum(albumModel:YXSPhotoAlbumsModel){
        let index = dataSource.firstIndex(of: albumModel)
        if let index = index{
            dataSource.remove(at: index)
            collectionView.reloadData()
        }
        
    }
    
    /// 新消息按钮点击
    @objc func newMessageClick(sender: YXSButton) {
        
    }
    
    // MARK: - tableViewDelegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXSPhotoAlbumsListCell", for: indexPath) as! YXSPhotoAlbumsListCell
        
        cell.setCellModel(self.dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataSource[indexPath.row]
        if model.isSystemCreateItem{
            createAlbumClick()
            
        }else{
            let vc = YXSPhotoAlbumDetialListController.init(albumModel: model)
            vc.title = model.albumName
            vc.updateAlbumModel = {[weak self](albumModel) in
                guard let strongSelf = self else { return }
                strongSelf.dataSource[indexPath.row] = albumModel
                strongSelf.collectionView.reloadItems(at: [indexPath])
            }
            self.navigationController?.pushViewController(vc)
        }
    }

    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return showEmptyDataSource
    }
    
    override func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        let view = SLBaseEmptyView()
        view.frame = self.view.frame
        view.imageView.mixedImage = MixedImage(normal: "yxs_photo_nodata", night: "yxs_photo_nodata")
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            view.label.text = "你还没有创建过相册哦"
            view.button.isHidden = false
            view.button.setTitle("新建相册", for: .normal)
            view.button.setTitleColor(UIColor.white, for: .normal)
            view.button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            view.button.addTarget(self, action: #selector(createAlbumClick), for: .touchUpInside)
            view.button.yxs_gradualBackground(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
            view.button.yxs_shadow(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49), color: UIColor(red: 0.3, green: 0.45, blue: 0.96, alpha: 0.5), cornerRadius:  24.5, offset: CGSize(width: 0, height: 3))
            view.button.snp.updateConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 230, height: 49))
            }
            view.button.cornerRadius = 24.5
            
        } else {
            view.label.text = "老师还没有上传照片哦"
            view.button.isHidden = true
        }
        
        return view
    }
    
    // MARK: - Header Footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if messageInfo?.messageCount ?? 0 > 0 {
            return CGSize(width: SCREEN_WIDTH, height: 50)

        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header: YXSFriendsCircleMessageView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "YXSFriendsCircleMessageView", for: indexPath) as! YXSFriendsCircleMessageView
            header.setMessageTipsModel(messageModel: messageInfo)
            return header
        }
        return UICollectionReusableView()
    }
}

extension YXSPhotoClassPhotoAlbumListController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?){
        switch eventName {
        case kFriendsCircleMessageViewGoMessageEvent:
            let vc = YXSCommonMessageListController.init(photoClassId: classId)
            vc.loadSucess = {
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.messageInfo = nil
                strongSelf.collectionView.reloadData()
            }
            self.navigationController?.pushViewController(vc)
            break
        default:
            print("")
        }
    }
}

