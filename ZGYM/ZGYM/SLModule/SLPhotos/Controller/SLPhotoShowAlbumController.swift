//
//  SLPhotoShowAlbumController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/12.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper
import FDFullscreenPopGesture_Bell

class SLPhotoShowAlbumController: SLBaseCollectionViewController {
    var dataSource: [SLPhotoAlbumsDetailListModel]
    var curruntIndex: Int
    
    
    /// 当前是否展示工具栏
    var isCurruntShowTool: Bool = true
    init(dataSource: [SLPhotoAlbumsDetailListModel], curruntIndex: Int) {
        self.curruntIndex = curruntIndex
        self.dataSource = dataSource
        super.init()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        layout.scrollDirection = .horizontal
        self.layout = layout
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var rightButton: UIButton!
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true
        collectionView.register(SLPhotoShowAlubmCell.self, forCellWithReuseIdentifier: "SLPhotoShowAlubmCell")
        updateUI()
        collectionView.reloadData()
        collectionView.selectItem(at: IndexPath.init(row: curruntIndex, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.top)
    }
   
    
  
    // MARK: -UI
    
    // MARK: -action
    
    
    // MARK: -private
    func updateUI(){
        if isCurruntShowTool{
            customNav.isHidden = false
        }else{
            customNav.isHidden = true
        }
        customNav.title = "\(curruntIndex)/\(self.dataSource.count)"
    }
    
  
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SLPhotoShowAlubmCell", for: indexPath) as! SLPhotoShowAlubmCell
        cell.setCellModel(self.dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isCurruntShowTool = !isCurruntShowTool
        updateUI()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        curruntIndex = indexPath.row
        updateUI()
    }
    
    lazy var customNav: SLCustomNav = {
       let customNav = SLCustomNav.init(.backAndTitle)
       customNav.backImageButton.setMixedImage(MixedImage(normal: "sl_back_white", night: "sl_back_white"), forState: .normal)
        customNav.backgroundColor = UIColor.black
        customNav.titleLabel.textColor = UIColor.white
       return customNav
    }()
}


extension SLPhotoShowAlbumController: SLRouterEventProtocol{
    func sl_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kHMCustomNavBackEvent:
            sl_onBackClick()
        default:
            break
        }
    }
}
