//
//  SLPhotoAlbumDetialListController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/2.
//  Copyright © 2020 hmym. All rights reserved.
//


import UIKit
import NightNight
import ObjectMapper

class SLPhotoAlbumDetialListController: SLBaseCollectionViewController {
    var dataSource: [SLPhotoAlbumsDetailListModel] = [SLPhotoAlbumsDetailListModel]()
    var albumModel: SLPhotoAlbumsModel
    var videoDuration: Int?
    var updateAlbumModel: ((_ albumModel:  SLPhotoAlbumsModel)->())?
    
    var isEdit: Bool = false
    var resourceIdList: [Int]{
        var selectModels = [Int]()
        for model in dataSource{
            if model.isSelected{
                selectModels.append(model.id ?? 0)
            }
        }
        return selectModels
    }
    init(albumModel: SLPhotoAlbumsModel) {
        self.albumModel = albumModel
        super.init()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 6
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 15, bottom: 0, right: 15)
        let itemW = (SCREEN_WIDTH - CGFloat(15*2) - CGFloat(2*6))/3
        layout.itemSize = CGSize.init(width: itemW, height: itemW)
        
        self.layout = layout
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var rightButton: UIButton!
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = albumModel.albumName
        
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
            make.height.equalTo(60)
        }
        
        collectionView.register(SLPhotoAlbumsDetailListCell.self, forCellWithReuseIdentifier: "SLPhotoAlbumsDetailListCell")
        
        rightButton = sl_setRightButton(title: "编辑",titleColor: UIColor.sl_hexToAdecimalColor(hex: "#575A60"))
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightButton.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
    }
    
    override func sl_refreshData() {
        self.curruntPage = 1
        sl_loadData()
    }
    
    override func sl_loadNextPage() {
        sl_loadData()
    }
    
    func sl_loadData() {
        SLEducationAlbumPagequeryResourceRequest.init(albumId: albumModel.id ?? 0, currentPage: curruntPage).request({ (result) in
            if self.curruntPage == 1{
                self.dataSource.removeAll()
            }
            let list = Mapper<SLPhotoAlbumsDetailListModel>().mapArray(JSONObject: result["classAlbumResourceList"].object) ?? [SLPhotoAlbumsDetailListModel]()
            //编辑全选状态默认选中当前model
            if self.footerView.isCurruntSelectAll{
                for model in list{
                    model.isSelected = true
                }
            }
            self.dataSource += list
            self.loadMore = result["hasNext"].boolValue
            self.sl_endingRefresh()
            self.refreshShowFooterData()
        }) { (msg, code) in
            self.sl_endingRefresh()
        }
    }
    
    
    /// 上传资源个数
    var uploadCount: Int = 0
    func loadUploadRequest(_ assets: [SLMediaModel]){
        uploadCount = assets.count
        var mediaInfos = [[String: Any]]()
        for asset in assets{
            if asset.type == .video {
                mediaInfos.append([typeKey: SourceNameType.video,modelKey: asset])
                videoDuration = Int(asset.asset.duration)
            }else{
                mediaInfos.append([typeKey: SourceNameType.image,modelKey: asset])
            }
        }
        MBProgressHUD.sl_showLoading(message: "上传中", inView: self.navigationController!.view)
        SLUploadSourceHelper().uploadMedia(mediaInfos: mediaInfos, sucess: { (infos) in
            SLLog(infos)
            self.loadUploadAlbumRequest(mediaInfos: infos)
        }) { (msg, code) in
            MBProgressHUD.sl_hideHUDInView(view: self.navigationController!.view)
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }

    func loadUploadAlbumRequest(mediaInfos: [[String: Any]]){
        var resourceList = [[String: Any]]()
        var pictures = [String]()
        var video: String = ""
        var bgUrl: String = ""
        for model in mediaInfos{
            if let type = model[typeKey] as? SourceNameType{
                if type == .video{
                    video = model[urlKey] as? String ?? ""
                }else if type == .image{
                    pictures.append(model[urlKey] as? String ?? "")
                }else if type == .firstVideo{
                    bgUrl = model[urlKey] as? String ?? ""
                }
            }
        }
        
        
        if video.count != 0{
            resourceList.append(["resourceType": 1, "resourceUrl": video, "bgUrl": bgUrl, "videoDuration": videoDuration ?? 0])
        }else{
            for picUrl in pictures{
                resourceList.append(["resourceType": 0, "resourceUrl": picUrl,"bgUrl": "", "videoDuration": 0])
            }
        }
        SLEducationAlbumUploadResourceRequest.init(albumId: albumModel.id ?? 0, resourceList: resourceList).request({ (result) in
            MBProgressHUD.sl_hideHUDInView(view: self.navigationController!.view)
            MBProgressHUD.sl_showMessage(message: "上传完成")
            self.sl_refreshData()
            self.albumModel.resourceCount = (self.albumModel.resourceCount ?? 0) + self.uploadCount
            self.updateAlbumModel?(self.albumModel)
        }) { (msg, code) in
            MBProgressHUD.sl_hideHUDInView(view: self.navigationController!.view)
            MBProgressHUD.sl_showMessage(message: msg)
        }
        
    }
    
    func loadDelectAlbum(){
        if resourceIdList.count == 0{
            MBProgressHUD.sl_showMessage(message: "请选择要删除的照片")
            return
        }
        MBProgressHUD.sl_showLoading()
        let delectCount = resourceIdList.count
        SLEducationAlbumBatchDeleteResourceRequest.init(albumId: albumModel.id ?? 0, resourceIdList: resourceIdList).request({ (result) in
            MBProgressHUD.sl_showMessage(message: "删除完成")
            
            var newData = [SLPhotoAlbumsDetailListModel]()
            for model in self.dataSource{
                if model.isSelected == false{
                    newData.append(model)
                }
            }
            self.dataSource = newData
            
            self.albumModel.resourceCount = (self.albumModel.resourceCount ?? 0) - delectCount
            self.updateAlbumModel?(self.albumModel)
            if self.albumModel.resourceCount == 0{
                self.refreshShowFooterData()
            }else{
                self.sl_refreshData()
            }
            self.refreshView(isEdit: false)
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: -UI
    
    // MARK: -action
    @objc func rightButtonClick(){
        let vc = SLPhotoEditAlbumController.init(albumModel: albumModel)
        vc.updateAlbumSucess = {[weak self](albumModel) in
            guard let strongSelf = self else { return }
            strongSelf.title = albumModel.albumName
            strongSelf.albumModel = albumModel
            strongSelf.updateAlbumModel?(albumModel)
        }
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func addPhotoClick(){
        SLSelectMediaHelper.shareHelper.showSelectMedia(selectAll: true, maxCount: 9)
        SLSelectMediaHelper.shareHelper.delegate = self
    }
    
    
    // MARK: -private
    func refreshShowFooterData(){
        if self.dataSource.count == 0{
            self.footerView.isHidden = true
            self.collectionView.snp.remakeConstraints { (make) in
                make.left.top.right.equalTo(0)
                make.bottom.equalTo(-kSafeBottomHeight)
            }
        }else{
            self.footerView.isHidden = false
            self.collectionView.snp.remakeConstraints { (make) in
                make.left.top.right.equalTo(0)
                make.bottom.equalTo(-kSafeBottomHeight - 60)
            }
        }
        self.collectionView.reloadData()
    }
    
    func refreshView(isEdit: Bool){
        self.isEdit = isEdit
        rightButton.isHidden = isEdit
        footerView.isEdit = isEdit
        cleanSelects()
        refreshShowFooterData()
    }
    
    func cleanSelects(){
        for model in dataSource{
            model.isSelected = false
        }
    }
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SLPhotoAlbumsDetailListCell", for: indexPath) as! SLPhotoAlbumsDetailListCell
        cell.isEdit = isEdit
        cell.setCellModel(self.dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataSource[indexPath.row]
        if isEdit{
            model.isSelected = !model.isSelected
            footerView.rightButton.setTitle("删除(\(resourceIdList.count))", for: .normal)
            collectionView.reloadItems(at: [indexPath])
        }else{
            let vc = SLPhotoShowAlbumController(dataSource: self.dataSource, curruntIndex: indexPath.row)
            self.navigationController?.pushViewController(vc)
        }
    }
    
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return showEmptyDataSource
    }
    
    override func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        let view = SLBaseEmptyView()
        view.frame = self.view.frame
        view.imageView.mixedImage = MixedImage(normal: "sl_photo_nodata", night: "sl_photo_nodata")
        view.label.text = "你还没有上传过照片哦"
        view.button.setTitle("上传照片", for: .normal)
        view.button.setTitleColor(UIColor.white, for: .normal)
        view.button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        view.button.addTarget(self, action: #selector(addPhotoClick), for: .touchUpInside)
        view.button.sl_gradualBackground(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        view.button.sl_shadow(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49), color: UIColor(red: 0.3, green: 0.45, blue: 0.96, alpha: 0.5), cornerRadius:  24.5, offset: CGSize(width: 0, height: 3))
        view.button.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 230, height: 49))
        }
        view.button.cornerRadius = 24.5
        return view
    }
    // MARK: - getter&setter
    
    lazy var footerView: SLPhotoAlbumDetialFooterView = {
        let footerView = SLPhotoAlbumDetialFooterView()
        footerView.isEdit = false
        footerView.isHidden = true
        footerView.selectAllBlock = {[weak self](isSelected) in
            guard let strongSelf = self else { return }
            if isSelected{
                for model in strongSelf.dataSource{
                    model.isSelected = true
                }
            }else{
                strongSelf.cleanSelects()
                
            }
            strongSelf.collectionView.reloadData()
        }
        return footerView
    }()
}

extension SLPhotoAlbumDetialListController: SLSelectMediaHelperDelegate{
    func didSelectMedia(asset: SLMediaModel) {
        loadUploadRequest([asset])
    }
    
    /// 选中多个图片资源
    /// - Parameter assets: models
    func didSelectSourceAssets(assets: [SLMediaModel]) {
        loadUploadRequest(assets)
    }
}


// MARK: -HMRouterEventProtocol
extension SLPhotoAlbumDetialListController: SLRouterEventProtocol{
    func sl_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kSLPhotoAlbumDetialFooterViewDelectEventKey:
            loadDelectAlbum()
        case kSLPhotoAlbumDetialFooterViewCancelEditEventKey:
            refreshView(isEdit: false)
        case kSLPhotoAlbumDetialFooterViewUploadEventKey:
            addPhotoClick()
        case kSLPhotoAlbumDetialFooterViewBeginEventKey:
            refreshView(isEdit: true)
        default:
            break
        }
    }
}

