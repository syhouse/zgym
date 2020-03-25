//
//  SLRecordVideoController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/11.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import AssetsLibrary
import TZImagePickerController

class SLRecordVideoController: SLBaseViewController {
     var selectComplete:((SLMediaModel) -> Void)?
    init(complete:  ((SLMediaModel) -> Void)?) {
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
    lazy var vedioLayerView: SLPhotoCollectionView = {
        let vedioLayerView = SLPhotoCollectionView.init(frame: view.bounds)
        return vedioLayerView
    }()
    //选择本地视频
    func selectVedio(){
        SLSelectMediaHelper.shareHelper.pushImagePickerController( mediaStyle: .onlyViedo, showTakePhoto: false, maxCount: 1,presentVc: self)
        SLSelectMediaHelper.shareHelper.delegate = self
    }
}

// MARK: -HMRouterEventProtocol
extension SLRecordVideoController: SLRouterEventProtocol{
    func sl_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYMPhotoCollectionViewDimiss:
            dismiss(animated: true, completion: nil)
        case kYMPhotoCollectionViewFinish:
            let model = SLMediaModel()
            model.asset = info![kEventKey] as? PHAsset
            self.selectComplete?(model)
            dismiss(animated: true, completion: nil)
        case kYMPhotoCollectionViewChoseLocal:
            selectVedio()
        default:
            break
        }
    }
}

extension SLRecordVideoController:SLSelectMediaHelperDelegate{
    func didSelectMedia(asset: SLMediaModel) {
        self.selectComplete?(asset)
        self.dismiss(animated: true, completion: nil)
    }
}


