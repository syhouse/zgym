//
//  YXSRecordVideoController.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/11.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import AssetsLibrary
import TZImagePickerController

class YXSRecordVideoController: YXSBaseViewController {
     var selectComplete:((YXSMediaModel) -> Void)?
    init(complete:  ((YXSMediaModel) -> Void)?) {
        self.selectComplete = complete
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(vedioLayerView)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vedioLayerView.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        vedioLayerView.stopRunning()
    }
    
    // MARK: -UI
    
    // MARK: -loadData
    
    // MARK: -action
    
    
    // MARK: -private
    
    // MARK: -public
    
    
    // MARK: - getter&setter
    lazy var vedioLayerView: YXSPhotoCollectionView = {
        let vedioLayerView = YXSPhotoCollectionView.init(frame: view.bounds)
        return vedioLayerView
    }()
    //选择本地视频
    func selectVedio(){
        YXSSelectMediaHelper.shareHelper.pushImagePickerController( mediaStyle: .onlyViedo, showTakePhoto: false, maxCount: 1,presentVc: self)
        YXSSelectMediaHelper.shareHelper.delegate = self
    }
}

// MARK: -HMRouterEventProtocol
extension YXSRecordVideoController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSPhotoCollectionViewDimiss:
            dismiss(animated: true, completion: nil)
        case kYXSPhotoCollectionViewFinish:
            let model = YXSMediaModel()
            model.asset = info![kEventKey] as? PHAsset
            self.selectComplete?(model)
            dismiss(animated: true, completion: nil)
        case kYXSPhotoCollectionViewChoseLocal:
            selectVedio()
        default:
            break
        }
    }
}

extension YXSRecordVideoController:YXSSelectMediaHelperDelegate{
    func didSelectMedia(asset: YXSMediaModel) {
        self.selectComplete?(asset)
        self.dismiss(animated: true, completion: nil)
    }
}


