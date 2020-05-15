//
//  YXSSelectMediaHelper.swift
//  EducationShop
//
//  Created by zgjy_mac on 2019/10/11.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

import TZImagePickerController
import AssetsLibrary

enum SLSelectMediaStyle {
    /// 仅图片
    case onlyImage
    /// 仅视频
    case onlyViedo
    /// 图片+视频
    case all
    /// 图片+视频并存
    case bothImageVideoGif
}

protocol YXSSelectMediaHelperDelegate {
    /// 拍照完成/选中视频
    /// - Parameter asset: model
    func didSelectMedia(asset: YXSMediaModel)
    
    /// 选中图片资源
    /// - Parameter assets: models
    func didSelectSourceAssets(assets: [YXSMediaModel])
    
    
    /// 选中图片资源(裁剪后的)
    /// - Parameter images: images
    func didSelectImages(images: [UIImage])
}

extension YXSSelectMediaHelperDelegate {
    func didSelectMedia(asset: YXSMediaModel){}

    func didSelectSourceAssets(assets: [YXSMediaModel]){}
    
    func didSelectImages(images: [UIImage]){}
}

class YXSSelectMediaHelper: NSObject,TZImagePickerControllerDelegate {
    static let shareHelper = YXSSelectMediaHelper()
    private override init() {
        super.init()
        imagePickerVc.delegate = self
    }
    
    var selectStyle: SLSelectMediaStyle = .onlyImage
    var delegate: YXSSelectMediaHelperDelegate!
    var maxcount: Int = 1
    var imagePickerVc: UIImagePickerController = {
        let vc = UIImagePickerController()
        // set appearance / 改变相册选择页的导航栏外观
        vc.navigationBar.barTintColor = UIColor.black
        vc.navigationBar.tintColor = UIColor.black
        var tzBarItem: UIBarButtonItem?
        var BarItem: UIBarButtonItem?
        tzBarItem = UIBarButtonItem.appearance(whenContainedInInstancesOf: [TZImagePickerController.self])
        BarItem = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIImagePickerController.self])
        let titleTextAttributes = tzBarItem?.titleTextAttributes(for: .normal)
        BarItem?.setTitleTextAttributes(titleTextAttributes, for: .normal)
        return vc
    }()
    
    
    /// 启动相机拍照
    func takePhoto(){
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if (authStatus == .restricted || authStatus == .denied) {
            // 无相机权限 做一个友好的提示
            UIUtil.RootController().showAlert(title: "无法使用相机",message: "请在iPhone的\"设置-隐私-相机\"中允许访问相机", leftTitle: "取消", rightTitle: "设置", rightClickBlock: {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            })
            // 拍照之前还需要检查相册权限
        } else if authStatus == .notDetermined {
            // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if granted {
                    DispatchQueue.main.async(execute: {
                        self.takePhoto()
                    })
                }
            })
            // 拍照之前还需要检查相册权限
        } else if PHPhotoLibrary.authorizationStatus().rawValue == 2 {
            // 已被拒绝，没有相册权限，将无法保存拍的照片
            UIUtil.RootController().showAlert(title: "无法访问相册",message: "请在iPhone的\"设置-隐私-相册\"中允许访问相册", leftTitle: "取消", rightTitle: "设置", rightClickBlock: {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            })
        } else if PHPhotoLibrary.authorizationStatus().rawValue == 0 {
            // 未请求过相册权限
            TZImageManager().requestAuthorization {
                self.takePhoto()
            }
        } else {
            // 正在弹框询问用户是否允许访问相册，监听权限状态
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerVc.sourceType = .camera
                imagePickerVc.modalPresentationStyle = .overCurrentContext
                UIUtil.RootController().present(self.imagePickerVc, animated: true, completion: nil)
                YXSPlayerMediaSingleControlTool.share.pausePlayer()
            } else {
                print("模拟器中无法打开照相机,请在真机中使用")
            }
        }
    }
    
    /// x选择单个资源提交弹窗
    /// - Parameters:
    ///   - selectImage: 选择照片
    ///   - selectVedio: 选择视频
    ///   - selectAll:  选择照片或者视频
    ///   - customVideo: 自己拍摄视频
    ///   - maxCount: 最大选择数量
    ///   - customVideoFinish: 拍视频回调
    
    
    public func showSelectMedia(selectImage: Bool = false, selectVedio: Bool = false,selectAll: Bool = false, customVideo: Bool = false, maxCount:Int = 1, customVideoFinish: ((YXSMediaModel) -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: { (_) -> Void in
            self.takePhoto()
        }))
        
        if customVideo{
            alert.addAction(UIAlertAction(title: "拍视频", style: .default, handler: { (_) -> Void in
                self.pushRecordVideo(complete: customVideoFinish)
            }))
        }
        
        if selectImage{
            alert.addAction(UIAlertAction(title: "选择照片", style: .default, handler: { (_) -> Void in
                self.pushImagePickerController(mediaStyle: .onlyImage, maxCount: maxCount)
            }))
        }
        if selectVedio{
            alert.addAction(UIAlertAction(title: "选择视频", style: .default, handler: { (_) -> Void in
                self.pushImagePickerController(mediaStyle: .onlyViedo, maxCount: maxCount)
            }))
        }
        if selectAll{
            alert.addAction(UIAlertAction(title: "从相册中选择", style: .default, handler: { (_) -> Void in
                self.pushImagePickerController(mediaStyle: .all, maxCount: maxCount)
            }))
        }
        alert.popoverPresentationController?.sourceView = UIUtil.currentNav().view
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        UIUtil.currentNav().present(alert, animated: true, completion: nil)
    }
    
    private func pushRecordVideo(complete: ((YXSMediaModel) -> Void)?){
        let vc = YXSRecordVideoController.init(complete:complete)
        vc.modalPresentationStyle = .fullScreen
        UIUtil.RootController().present(vc, animated: true, completion: nil)
    }
    
    
    /// 选择图片
    /// - Parameters:
    ///   - selectedAssets: 展示当前选中的资源
    ///   - mediaStyle: 选择模式  只图片 只视频等等
    ///   - showTakePhoto: 是否展示拍照按钮
    ///   - maxCount: 最大数量
    ///   - presentVc: 从那个控制器presentVc
    public func pushImagePickerController( _ selectedAssets: [TZAssetModel] = [TZAssetModel](), mediaStyle: SLSelectMediaStyle = .all, showTakePhoto: Bool = true, maxCount:Int = 9,presentVc: UIViewController = UIUtil.RootController()){
        let imagePickerVc = TZImagePickerController(maxImagesCount: maxCount, columnNumber: 4, delegate: self, pushPhotoPickerVc: true)
        imagePickerVc!.preferredLanguage = "zh-Hans"
        imagePickerVc!.naviBgColor = UIColor.black
        imagePickerVc!.navigationBar.isTranslucent = false
        imagePickerVc!.isSelectOriginalPhoto = true
        imagePickerVc!.allowTakePicture = showTakePhoto // 在内部显示拍照按钮
        switch mediaStyle {
        case .all:
            imagePickerVc!.allowPickingVideo = true
            imagePickerVc!.allowPickingImage = true
        case .onlyViedo:
            imagePickerVc!.allowPickingVideo = true
            imagePickerVc!.allowPickingImage = false
        case .onlyImage:
            imagePickerVc!.allowPickingVideo = false
            imagePickerVc!.allowPickingImage = true
        case .bothImageVideoGif:
            imagePickerVc!.allowPickingMultipleVideo = true
        }
        
        imagePickerVc!.allowPickingOriginalPhoto = true
        imagePickerVc!.allowPickingGif = false
        imagePickerVc!.sortAscendingByModificationDate = false
        imagePickerVc!.showSelectBtn = false
        imagePickerVc!.allowCrop = false
        imagePickerVc!.needCircleCrop = false
        imagePickerVc!.circleCropRadius = 100
        imagePickerVc?.isSelectOriginalPhoto = false
        imagePickerVc!.didFinishPickingPhotosHandle = nil
        
        for model in selectedAssets{
            imagePickerVc!.addSelectedModel(model)
        }
        imagePickerVc!.modalPresentationStyle = .fullScreen
        presentVc.present(imagePickerVc!, animated: true, completion: nil)
        
        YXSPlayerMediaSingleControlTool.share.pausePlayer()
    }
    
    
    /// 展示裁剪框的选择图片
    public func pushImageAllCropPickerController(){
        let imagePickerVc = TZImagePickerController(maxImagesCount: 1, columnNumber: 4, delegate: self, pushPhotoPickerVc: true)
        imagePickerVc!.preferredLanguage = "zh-Hans"
        imagePickerVc!.naviBgColor = UIColor.black
        imagePickerVc!.navigationBar.isTranslucent = false
        imagePickerVc!.isSelectOriginalPhoto = true
        imagePickerVc!.allowTakePicture = true // 在内部显示拍照按钮
        imagePickerVc!.allowPickingVideo = false
        imagePickerVc!.allowPickingImage = true
        
        imagePickerVc!.allowPickingOriginalPhoto = true
        imagePickerVc!.allowPickingGif = false
        imagePickerVc!.sortAscendingByModificationDate = false
        imagePickerVc!.showSelectBtn = false
        imagePickerVc!.allowCrop = true
        imagePickerVc!.needCircleCrop = false
        imagePickerVc!.circleCropRadius = 100
        imagePickerVc?.isSelectOriginalPhoto = false
        imagePickerVc!.didFinishPickingPhotosHandle = nil
        

        imagePickerVc!.modalPresentationStyle = .fullScreen
        UIUtil.RootController().present(imagePickerVc!, animated: true, completion: nil)
    }
    
    func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        print("cancel")
        
        YXSPlayerMediaSingleControlTool.share.resumePlayer()
    }
    
    // photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        SLLog(picker.selectedAssets)
        delegate?.didSelectSourceAssets(assets: YXSMediaModel.getMediaModels(assets: assets as! [PHAsset]))
        
        delegate?.didSelectImages(images: photos ?? [UIImage]())
        
        YXSPlayerMediaSingleControlTool.share.resumePlayer()
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: PHAsset!) {
//        大小50M以内 时长180s
        if asset.duration > 180{
            MBProgressHUD.yxs_showMessage(message: "视频时长不能超过3分钟")
            return
        }
        
        let res = PHAssetResource.assetResources(for: asset).first
        let size: Int64 = res?.value(forKey: "fileSize") as? Int64 ?? 0
        if size > videoMax{
            MBProgressHUD.yxs_showMessage(message: "视频大小不能超过50M")
            return
        }
        let model = YXSMediaModel()
        model.showImg = coverImage
        model.asset = asset
        self.delegate.didSelectMedia(asset: model)

        
        YXSPlayerMediaSingleControlTool.share.resumePlayer()
    }
    
    
}

extension YXSSelectMediaHelper: (UIImagePickerControllerDelegate & UINavigationControllerDelegate){
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let type = info[UIImagePickerController.InfoKey.mediaType] as? String
        //    DDLog(@"相机或者照片---》%@",info);
        if (type == "public.image") {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            if let image = image{
                let allPhotosOptions = PHFetchOptions()
                // 按图片生成时间排序
                allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                //选择普通照片
                allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                var localIdentifier: String = ""
                PHPhotoLibrary.shared().performChanges({
                    let createdAssetID = PHAssetChangeRequest.creationRequestForAsset(from: image).placeholderForCreatedAsset?.localIdentifier
                    localIdentifier = createdAssetID!
                    
                }, completionHandler: { (sucess, error) in
                    if sucess{
                        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: allPhotosOptions)
                        if assets.firstObject != nil
                        {
                            //这里拿到了PHAsset对象，往下操作就看自己的需求了
                            let model = YXSMediaModel()
                            model.showImg = image
                            model.asset = assets.firstObject!
                            DispatchQueue.main.async {
                                self.delegate.didSelectMedia(asset: model)
                            }
                        }
                    }else{
                        SLLog("保存错误")
                    }
                })
            }else{
                MBProgressHUD.yxs_showMessage(message: "拍摄失败")
            }
            
            
        }
        
        YXSPlayerMediaSingleControlTool.share.resumePlayer()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
        YXSPlayerMediaSingleControlTool.share.resumePlayer()
    }
}

