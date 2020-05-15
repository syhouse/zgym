//
//  YXSPhotoShowAlbumController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/12.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper
import FDFullscreenPopGesture_Bell
import JXCategoryView

class YXSPhotoShowAlbumController: YXSBaseViewController,JXCategoryViewDelegate, JXCategoryListContainerViewDelegate {
    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        let vc = YXSPhotoShowAlbumItemController(model: dataSource[index])
        return vc
    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        
    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, didScrollSelectedItemAt index: Int) {
        
    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, didClickSelectedItemAt index: Int) {
        
    }
    
    var dataSource: [YXSPhotoAlbumsDetailListModel]
    var titles:[String]
    var currentIndex: Int
    var praisesModels = [Int: YXSPhotoAlbumsPraiseModel]()
    
    
    
    /// 当前是否展示工具栏
    var iscurrentShowTool: Bool = true
    init(dataSource: [YXSPhotoAlbumsDetailListModel], currentIndex: Int) {
        self.currentIndex = currentIndex
        self.dataSource = dataSource
        self.titles = [String].init(repeating: "", count: dataSource.count)
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var rightButton: UIButton!
    
    var isFirstEnterScroll: Bool = true
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(listContainerView)
        self.listContainerView.snp.remakeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.categoryView.listContainer = listContainerView
        self.categoryView.delegate = self
        categoryView.defaultSelectedIndex = currentIndex
        
        self.view.addSubview(customNav)
        customNav.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
        }
        
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(0)
            make.height.equalTo(64 + kSafeBottomHeight)
        }
        
        self.fd_prefersNavigationBarHidden = true

    }
    // MARK: - loadData
    func loadPraiseData(index: Int){
        let model = dataSource[index]
        YXSEducationAlbumQueryCommentListAndPraiseRequest.init(albumId: model.albumId ?? 0, resourceId: model.id ?? 0).request({ (resultModel: YXSPhotoAlbumsPraiseModel) in
            self.praisesModels[model.id ?? 0] = resultModel
            self.updateUI()
        }) { (msg, code) in
            
        }
    }
    
    func loadPraiseOrCancelData(index: Int){
        let model = dataSource[index]
        YXSEducationAlbumPraiseOrCancelRequest.init(albumId: model.albumId ?? 0, resourceId: model.id ?? 0).request({ (resultModel: YXSPhotoAlbumsPraiseModel) in
        }) { (msg, code) in
        }
    }
   
    
  
    // MARK: -UI
    
    // MARK: -action
    
    
    // MARK: -private
    func updateUI(){
        if iscurrentShowTool{
            customNav.isHidden = false
            footerView.isHidden = false
        }else{
            customNav.isHidden = true
            footerView.isHidden = true
        }
        customNav.title = "\(currentIndex + 1)/\(self.dataSource.count)"
        
        let model = praisesModels[dataSource[currentIndex].id ?? 0]
        if let model = model{
            footerView.setModel(model: model)
        }
    }
    
    lazy var categoryView: JXCategoryTitleView = {
        let view = JXCategoryTitleView(frame: CGRect(x: 0, y: 0, width: 130, height: 30))
        view.titleColor = NightNight.theme == .night ? kNight898F9A : UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        view.titleSelectedColor = NightNight.theme == .night ? kBlueColor : kTextMainBodyColor
        view.titles = ["表扬", "待改进","表扬", "待改进","表扬", "待改进"]
        
        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorWidth = JXCategoryViewAutomaticDimension
        lineView.lineStyle = .lengthen
        lineView.indicatorColor = kBlueColor
        view.indicators = [lineView]
        return view
    }()
    
  
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataSource.count
//    }
//
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXSPhotoShowAlubmCell", for: indexPath) as! YXSPhotoShowAlubmCell
//        cell.setCellModel(self.dataSource[indexPath.row])
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        iscurrentShowTool = !iscurrentShowTool
//        updateUI()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        //每次切换请求接口  后面优化?
//        loadPraiseData(index: indexPath.row)
//    }
    
    lazy var customNav: YXSCustomNav = {
       let customNav = YXSCustomNav.init(.backAndTitle)
       customNav.backImageButton.setMixedImage(MixedImage(normal: "yxs_back_white", night: "yxs_back_white"), forState: .normal)
        customNav.backgroundColor = UIColor.black
        customNav.titleLabel.textColor = UIColor.white
       return customNav
    }()
    
    lazy var footerView: YXSPhotoShowAlubmFooterView = {
       let footerView = YXSPhotoShowAlubmFooterView()
        footerView.isHidden = true
        footerView.cellBlock = {[weak self]
            (isComment) in
            guard let strongSelf = self else { return }
            if isComment{
                
            }else{
                strongSelf.updateUI()
            }
        }
       return footerView
    }()
    
    lazy var listContainerView: JXCategoryListContainerView = {
        let view = JXCategoryListContainerView(type: JXCategoryListContainerType.collectionView, delegate: self)
        return view!
    }()
}


extension YXSPhotoShowAlbumController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:
            break
        }
    }
}
