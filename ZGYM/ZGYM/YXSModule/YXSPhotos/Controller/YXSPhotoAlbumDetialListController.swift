//
//  YXSPhotoAlbumDetialListController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/2.
//  Copyright © 2020 hmym. All rights reserved.
//


import UIKit
import NightNight
import ObjectMapper


class YXSPhotoAlbumDetialListSectionModel: NSObject{
    var lists: [YXSPhotoAlbumsDetailListModel] = [YXSPhotoAlbumsDetailListModel]()
    var createTime: String?
    var title: String?{
        return createTime?.yxs_Date().toString(format: DateFormatType.custom("mm月dd日"))
    }
}

/// 相片列表
class YXSPhotoAlbumDetialListController: YXSBaseCollectionViewController {
    var dataSource: [YXSPhotoAlbumDetialListSectionModel] = [YXSPhotoAlbumDetialListSectionModel]()
    var albumModel: YXSPhotoAlbumsModel
    var videoDuration: Int?
    var updateAlbumModel: ((_ albumModel:  YXSPhotoAlbumsModel)->())?
    /// 上传资源个数
    var uploadCount: Int = 0
    
    var rightButton: UIButton!
    
    var isEdit: Bool = false
    var resourceIdList: [Int]{
        var selectModels = [Int]()
        for section in dataSource{
            for model in section.lists{
                if model.isSelected{
                    selectModels.append(model.id ?? 0)
                }
            }
        }
        return selectModels
    }
    init(albumModel: YXSPhotoAlbumsModel) {
        self.albumModel = albumModel
        super.init()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 6
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        let itemW = (SCREEN_WIDTH - CGFloat(15*2) - CGFloat(2*6))/3
        layout.itemSize = CGSize.init(width: itemW, height: itemW)
        layout.headerReferenceSize = CGSize(width: SCREEN_WIDTH, height: 47)
        self.layout = layout
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = albumModel.albumName
        
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
            make.height.equalTo(60)
        }
        
        collectionView.register(YXSPhotoAlbumsDetailListCell.self, forCellWithReuseIdentifier: "YXSPhotoAlbumsDetailListCell")
        collectionView.register(YXSPhotoAlbumsDetailListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "YXSPhotoAlbumsDetailListHeaderView")
        rightButton = yxs_setRightButton(title: "编辑",titleColor: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"))
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightButton.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
    }
    
    // MARK: - Request
    override func yxs_refreshData() {
        self.currentPage = 1
        yxs_loadData()
    }
    
    override func yxs_loadNextPage() {
        yxs_loadData()
    }
    
    func yxs_loadData() {
        YXSEducationAlbumPagequeryResourceRequest.init(classId: albumModel.classId ?? 0 ,albumId: albumModel.id ?? 0, currentPage: currentPage).request({ (result) in
            self.yxs_endingRefresh()
            if self.currentPage == 1{
                self.dataSource.removeAll()
            }
            let list = Mapper<YXSPhotoAlbumsDetailListModel>().mapArray(JSONObject: result["classAlbumResourceList"].object) ?? [YXSPhotoAlbumsDetailListModel]()
            //编辑全选状态默认选中当前model
            if self.footerView.iscurrentSelectAll{
                for model in list{
                    model.isSelected = true
                }
            }

            
            var lastSectionModel = self.dataSource.last
            for model in list{
                if let createTime = lastSectionModel?.createTime,NSUtil.yxs_isSameDay(createTime.yxs_Date(), date2:  model.createTime?.yxs_Date() ?? Date()){
                    lastSectionModel?.lists.append(model)
                }else{
                    let newLastModel = YXSPhotoAlbumDetialListSectionModel()
                    newLastModel.createTime = model.createTime
                    newLastModel.lists.append(model)
                    lastSectionModel = newLastModel
                    self.dataSource.append(newLastModel)
                }
            }
            self.loadMore = result["hasNext"].boolValue
            
            self.refreshShowFooterData()
        }) { (msg, code) in
            self.yxs_endingRefresh()
        }
    }
    
    /// 上传资源
    func uploadRequest(_ assets: [YXSMediaModel]){
        uploadCount = assets.count
        var assetList:[PHAsset] = []
        for obj in assets{
            assetList.append(obj.asset)
        }
        uploadCount = assets.count
        var mediaInfos = [SLUploadSourceModel]()
        for asset in assets{
            if asset.type == .video {
                mediaInfos.append(SLUploadSourceModel.init(model: asset, type: .video, storageType: .album, fileName: asset.fileName, classId: albumModel.classId, albumId: albumModel.id))
                videoDuration = Int(asset.asset.duration)
            }else{
                mediaInfos.append(SLUploadSourceModel.init(model: asset, type: .image, storageType: .album, fileName: asset.fileName, classId: albumModel.classId, albumId: albumModel.id))
            }
        }
        MBProgressHUD.yxs_showUpload()
        YXSUploadSourceHelper().uploadMedia(mediaInfos: mediaInfos  , progress: {
            (progress) in
            DispatchQueue.main.async {
                MBProgressHUD.yxs_updateUploadProgess(progess: progress)
            }
        }, sucess: { (lists) in
            self.loadUploadAlbumRequest(mediaInfos: lists)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
    }
    
    func loadUploadAlbumRequest(mediaInfos: [SLUploadDataSourceModel]){
        var resourceList = [[String: Any]]()
        var pictures = [String]()
        var video: String = ""
        var bgUrl: String = ""
        for model in mediaInfos{
            if model.type == .video{
                video = model.aliYunUploadBackUrl ?? ""
            }else if model.type == .image{
                pictures.append(model.aliYunUploadBackUrl ?? "")
            }else if model.type == .firstVideo{
                bgUrl = model.aliYunUploadBackUrl ?? ""
            }
        }


        if video.count != 0{
            resourceList.append(["resourceType": 1, "resourceUrl": video, "bgUrl": bgUrl, "videoDuration": videoDuration ?? 0])
        }else{
            for picUrl in pictures{
                resourceList.append(["resourceType": 0, "resourceUrl": picUrl,"bgUrl": "", "videoDuration": 0])
            }
        }
        YXSEducationAlbumUploadResourceRequest.init(classId: albumModel.classId ?? 0,albumId: albumModel.id ?? 0, resourceList: resourceList).request({ (result) in
            MBProgressHUD.yxs_hideHUD()
            self.yxs_refreshData()
            self.albumModel.resourceCount = (self.albumModel.resourceCount ?? 0) + self.uploadCount
            self.updateAlbumModel?(self.albumModel)
        }) { (msg, code) in
            MBProgressHUD.yxs_hideHUDInView(view: self.navigationController!.view)
            MBProgressHUD.yxs_showMessage(message: msg)
        }

    }
    
    func loadDelectAlbum(){
        if resourceIdList.count == 0{
            MBProgressHUD.yxs_showMessage(message: "请选择要删除的照片")
            return
        }
        MBProgressHUD.yxs_showLoading()
        let delectCount = resourceIdList.count
        YXSEducationAlbumBatchDeleteResourceRequest.init(classId: albumModel.classId ?? 0 ,albumId: albumModel.id ?? 0, resourceIdList: resourceIdList).request({ (result) in
            MBProgressHUD.yxs_showMessage(message: "删除完成")
            for section in self.dataSource{
                section.lists.removeAll { (model) -> Bool in
                    return model.isSelected
                }
            }
            
            self.dataSource.removeAll { (section) -> Bool in
                return section.lists.count == 0
            }
            
            self.albumModel.resourceCount = (self.albumModel.resourceCount ?? 0) - delectCount
            self.updateAlbumModel?(self.albumModel)
            if self.albumModel.resourceCount == 0{
                self.refreshShowFooterData()
            }else{
                self.yxs_refreshData()
            }
            self.refreshView(isEdit: false)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Action
    @objc func rightButtonClick(){
        let vc = YXSPhotoEditAlbumController.init(albumModel: albumModel)
        vc.updateAlbumSucess = {[weak self](albumModel) in
            guard let strongSelf = self else { return }
            strongSelf.title = albumModel.albumName
            strongSelf.albumModel = albumModel
            strongSelf.updateAlbumModel?(albumModel)
        }
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func addPhotoClick(){
        YXSSelectMediaHelper.shareHelper.showSelectMedia(selectAll: true, maxCount: 9)
        YXSSelectMediaHelper.shareHelper.delegate = self
    }
    
    
    // MARK: - Private
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
        for section in dataSource{
            for model in section.lists{
                model.isSelected = false
            }
        }
        
    }
    
    // MARK: - Delegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].lists.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXSPhotoAlbumsDetailListCell", for: indexPath) as! YXSPhotoAlbumsDetailListCell
        cell.isEdit = isEdit
        cell.setCellModel(self.dataSource[indexPath.section].lists[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataSource[indexPath.section].lists[indexPath.row]
        if isEdit{
            model.isSelected = !model.isSelected
            footerView.rightButton.setTitle("删除(\(resourceIdList.count))", for: .normal)
            collectionView.reloadItems(at: [indexPath])
            
        }else{
            var showList = [YXSPhotoAlbumsDetailListModel]()
            for section in dataSource{
                for model in section.lists{
                    showList.append(model)
                }
            }
            let vc = YXSPhotoPreviewController(dataSource: showList, albumModel: albumModel)
            vc.updateAlbumModel = updateAlbumModel
            vc.currentPage = indexPath.row

            self.navigationController?.pushViewController(vc)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "YXSPhotoAlbumsDetailListHeaderView", for: indexPath) as! YXSPhotoAlbumsDetailListHeaderView
//            headerView.setModel(tabListTemplates[indexPath.section])
            headerView.titleLabel.text = dataSource[indexPath.row].title
            return headerView
        }
        return YXSTemplateListHeaderView()
    }
    
    // MARK: - emptyData
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return showEmptyDataSource
    }
    
    override func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        let view = SLBaseEmptyView()
        view.frame = self.view.frame
        view.imageView.mixedImage = MixedImage(normal: "yxs_photo_nodata", night: "yxs_photo_nodata")
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            view.label.text = "你还没有上传过照片哦"
            view.button.setTitle("上传照片", for: .normal)
            view.button.setTitleColor(UIColor.white, for: .normal)
            view.button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            view.button.addTarget(self, action: #selector(addPhotoClick), for: .touchUpInside)
            view.button.yxs_gradualBackground(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
            view.button.yxs_shadow(frame: CGRect.init(x: 0, y: 0, width: 230, height: 49), color: UIColor(red: 0.3, green: 0.45, blue: 0.96, alpha: 0.5), cornerRadius:  24.5, offset: CGSize(width: 0, height: 3))
            view.button.snp.updateConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 230, height: 49))
            }
            view.button.cornerRadius = 24.5
            
        } else {
            view.label.text = "老师还没有上传照片哦"
        }
 
        return view
    }
    
    // MARK: - getter&setter
    
    lazy var footerView: YXSPhotoAlbumDetialFooterView = {
        let footerView = YXSPhotoAlbumDetialFooterView()
        footerView.isEdit = false
        footerView.isHidden = true
        footerView.selectAllBlock = {[weak self](isSelected) in
            guard let strongSelf = self else { return }
            if isSelected{
                for section in strongSelf.dataSource{
                    for model in section.lists{
                        model.isSelected = true
                    }
                }
            }else{
                strongSelf.cleanSelects()
                
            }
            strongSelf.collectionView.reloadData()
        }
        return footerView
    }()
}

// MARK: -
extension YXSPhotoAlbumDetialListController: YXSSelectMediaHelperDelegate{
    func didSelectMedia(asset: YXSMediaModel) {
//        loadUploadRequest([asset])
        uploadRequest([asset])
    }
    
    /// 选中多个图片资源
    /// - Parameter assets: models
    func didSelectSourceAssets(assets: [YXSMediaModel]) {
//        loadUploadRequest(assets)
        uploadRequest(assets)
    }
}


// MARK: -HMRouterEventProtocol
extension YXSPhotoAlbumDetialListController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSPhotoAlbumDetialFooterViewDelectEventKey:
            loadDelectAlbum()
        case kYXSPhotoAlbumDetialFooterViewCancelEditEventKey:
            refreshView(isEdit: false)
        case kYXSPhotoAlbumDetialFooterViewUploadEventKey:
            addPhotoClick()
        case kYXSPhotoAlbumDetialFooterViewBeginEventKey:
            refreshView(isEdit: true)
        default:
            break
        }
    }
}

class YXSPhotoAlbumsDetailListHeaderView: UICollectionReusableView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14.5)
            make.top.equalTo(19)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = kTextMainBodyColor
        return label
    }()
}
