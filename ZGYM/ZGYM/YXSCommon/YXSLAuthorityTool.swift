//
//  YXSLAuthorityTool.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/28.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Photos
import AssetsLibrary
import MediaPlayer
import CoreTelephony
import CoreLocation
import AVFoundation

enum YXSPermissionsType{
    /// 相机
    case camera
    /// 相册
    case photo
    /// 位置
    case location
    /// 网络
    case network
    /// 麦克风
    case microphone
    /// 媒体库
    case media
}

class YXSLAuthorityTool: NSObject{
    // MARK: - 开启媒体资料库/Apple Music 服务
    /// 开启媒体资料库/Apple Music 服务
    @available(iOS 9.3, *)
    static func yxs_openMediaPlayerServiceWithBlock(_ isSet:Bool? = nil,_ action :@escaping ((Bool)->())) {
        let authStatus = MPMediaLibrary.authorizationStatus()
        if authStatus == MPMediaLibraryAuthorizationStatus.notDetermined {
            MPMediaLibrary.requestAuthorization { (status) in
                if (status == MPMediaLibraryAuthorizationStatus.authorized) {
                    DispatchQueue.main.async {
                        action(true)
                    }
                }else{
                    DispatchQueue.main.async {
                        action(false)
                        if isSet == true {self.yxs_OpenURL(.media)}
                    }
                }
            }
        } else if authStatus == MPMediaLibraryAuthorizationStatus.authorized {
            action(true)
        } else {
            action(false)
             if isSet == true {yxs_OpenURL(.media)}
        }
    }

    // MARK: - 检测是否开启联网
    /// 检测是否开启联网
    static func yxs_openEventServiceWithBolck(_ isSet:Bool? = nil,_ action :@escaping ((Bool)->())) {
        let cellularData = CTCellularData()
        cellularData.cellularDataRestrictionDidUpdateNotifier = { (state) in
            if state == CTCellularDataRestrictedState.restrictedStateUnknown ||  state == CTCellularDataRestrictedState.notRestricted {
                action(false)
                if isSet == true {self.yxs_OpenURL(.network)}
            } else {
                action(true)
            }
        }
        let state = cellularData.restrictedState
        if state == CTCellularDataRestrictedState.restrictedStateUnknown ||  state == CTCellularDataRestrictedState.notRestricted {
            action(false)
            if isSet == true {yxs_OpenURL(.network)}
        } else {
            action(true)
        }
    }

    // MARK: - 检测是否开启定位
    /// 检测是否开启定位
    static func yxs_openLocationServiceWithBlock(_ isSet:Bool? = nil,_ action :@escaping ((Bool)->())) {
        var isOpen = false
    //    if CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() != .denied {
    //        isOpen = true
    //    }
        if CLLocationManager.authorizationStatus() != .restricted && CLLocationManager.authorizationStatus() != .denied {
            isOpen = true
        }
        if isOpen == false && isSet == true {yxs_OpenURL(.location)}
        action(isOpen)
    }

    // MARK: - 检测是否开启摄像头
    /// 检测是否开启摄像头 (可用)
    static func yxs_openCaptureDeviceServiceWithBlock(_ isSet:Bool? = nil,_ action :@escaping ((Bool)->())) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == AVAuthorizationStatus.notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                action(granted)
                if granted == false && isSet == true {self.yxs_OpenURL(.camera)}
            }
        } else if authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.denied {
            action(false)
            if isSet == true {yxs_OpenURL(.camera)}
        } else {
            action(true)
        }
    }
    // MARK: - 检测是否开启相册
    /// 检测是否开启相册
    static func yxs_openAlbumServiceWithBlock(_ isSet:Bool? = nil,_ action :@escaping ((Bool)->())) {
        var isOpen = true
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == PHAuthorizationStatus.restricted || authStatus == PHAuthorizationStatus.denied {
            isOpen = false;
            if isSet == true {yxs_OpenURL(.photo)}
        }
        action(isOpen)
    }

    // MARK: - 检测是否开启麦克风
    /// 检测是否开启麦克风
    static func yxs_openRecordServiceWithBlock(_ isSet:Bool? = nil,_ action :@escaping ((Bool)->())) {
        let permissionStatus = AVAudioSession.sharedInstance().recordPermission
        if permissionStatus == AVAudioSession.RecordPermission.undetermined {
            AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
                action(granted)
                if granted == false && isSet == true {self.yxs_OpenURL(.microphone)}
            }
        } else if permissionStatus == AVAudioSession.RecordPermission.denied || permissionStatus == AVAudioSession.RecordPermission.undetermined{
            action(false)
            if isSet == true {yxs_OpenURL(.microphone)}
        } else {
            action(true)
        }
    }
    // MARK: - 跳转系统设置界面
    static func yxs_OpenURL(_ type: YXSPermissionsType? = nil) {
        let title = "访问受限"
        var message = "请点击“前往”，允许访问权限"
        let appName: String = (Bundle.main.infoDictionary!["CFBundleDisplayName"] ?? "") as! String //App 名称
        if type == .camera { // 相机
            message = "请在iPhone的\"设置-隐私-相机\"选项中，允许\"\(appName)\"访问你的相机"
        } else if type == .photo { // 相册
            message = "请在iPhone的\"设置-隐私-照片\"选项中，允许\"\(appName)\"访问您的相册"
        } else if type == .location { // 位置
            message = "请在iPhone的\"设置-隐私-定位服务\"选项中，允许\"\(appName)\"访问您的位置，获得更多商品信息"
        } else if type == .network { // 网络
            message = "请在iPhone的\"设置-蜂窝移动网络\"选项中，允许\"\(appName)\"访问您的移动网络"
        } else if type == .microphone { // 麦克风
            message = "请在iPhone的\"设置-隐私-麦克风\"选项中，允许\"\(appName)\"访问您的麦克风"
        } else if type == .media { // 媒体库
            message = "请在iPhone的\"设置-隐私-媒体与Apple Music\"选项中，允许\"\(appName)\"访问您的媒体库"
        }
        let url = URL(string: UIApplication.openSettingsURLString)
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
        let settingsAction = UIAlertAction(title:"前往", style: .default, handler: {
            (action) -> Void in
            if  UIApplication.shared.canOpenURL(url!) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url!, options: [:],completionHandler: {(success) in})
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

}

