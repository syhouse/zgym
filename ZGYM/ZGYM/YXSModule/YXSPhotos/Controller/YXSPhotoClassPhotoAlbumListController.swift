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

class YXSPhotoClassPhotoAlbumListController: YXSBaseCollectionViewController {
    var dataSource: [YXSPhotoAlbumsModel] = [YXSPhotoAlbumsModel]()
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
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "班级相册"
        
        collectionView.register(YXSPhotoAlbumsListCell.self, forCellWithReuseIdentifier: "YXSPhotoAlbumsListCell")
    }
    
    override func yxs_refreshData() {
        self.currentPage = 1
        yxs_loadData()
    }
    
    override func yxs_loadNextPage() {
        yxs_loadData()
    }
    
    func yxs_loadData() {
        YXSEducationAlbumPagequeryRequest.init(classId: classId, currentPage: currentPage).request({ (result) in
            self.yxs_endingRefresh()
            if self.currentPage == 1{
                self.dataSource.removeAll()
            }
            let list = Mapper<YXSPhotoAlbumsModel>().mapArray(JSONObject: result["classAlbumList"].object) ?? [YXSPhotoAlbumsModel]()
            self.dataSource += list
            if list.count != 0 {
                let createAlbums = YXSPhotoAlbumsModel.init(JSON: ["": ""])
                createAlbums?.isSystemCreateItem = true
                self.dataSource.insert(createAlbums!, at: 0)
            }
            self.loadMore = result["hasNext"].boolValue
            
            self.collectionView.reloadData()
        }) { (msg, code) in
            self.yxs_endingRefresh()
        }
    }
    
    // MARK: -UI
    
    // MARK: -action
    @objc func addPhotoClick(){
        let vc = YXSPhotoCreateAlbumController.init(classId: classId)
        vc.changeAlbumBlock = {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.yxs_refreshData()
        }
        self.navigationController?.pushViewController(vc)
    }
    
    // MARK: -private
    
    // MARK: -public
    
    /// 删除相册
    /// - Parameter albumModel: 相册modle
    func removeAlbum(albumModel:YXSPhotoAlbumsModel){
        let index = dataSource.firstIndex(of: albumModel)
        if let index = index{
            dataSource.remove(at: index)
            collectionView.reloadData()
        }
        
    }
    
    // MARK: -tableViewDelegate
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
            addPhotoClick()
        }else{
            let vc = YXSPhotoAlbumDetialListController.init(albumModel: model)
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
        view.label.text = "你还没有创建过相册哦"
        view.button.setTitle("新建相册", for: .normal)
        view.button.setTitleColor(UIColor.white, for: .normal)
        view.button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        view.button.addTarget(self, action: #selector(addPhotoClick), for: .touchUpInside)
        view.button.yxs_gradualBackground(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        view.button.yxs_shadow(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49), color: UIColor(red: 0.3, green: 0.45, blue: 0.96, alpha: 0.5), cornerRadius:  24.5, offset: CGSize(width: 0, height: 3))
        view.button.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 230, height: 49))
        }
        view.button.cornerRadius = 24.5
        return view
    }
    // MARK: - getter&setter
}

