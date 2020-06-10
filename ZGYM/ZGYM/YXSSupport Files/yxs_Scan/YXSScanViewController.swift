//
//  YXSScanViewController.swift
//  swiftScan
//
//  Created by xialibing on 15/12/10.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit
import FDFullscreenPopGesture_Bell

enum ScanType: Int{
    case addClass
    case teacherWebLogin
}

class YXSScanViewController: YXSLBXScanViewController {
    /**
    @brief  扫码区域上方提示文字
    */
    var topTitle: YXSLabel?

    /**
     @brief  闪关灯开启状态
     */
    var isOpenedFlash: Bool = false
    
    var scanType: ScanType
    
    init(scanType: ScanType = .addClass){
        self.scanType = scanType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        
        view.addSubview(customNav)
        customNav.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }

        let rightButton = YXSButton.init()
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.setTitle("相册", for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightButton.addTarget(self, action: #selector(openPhotoAlbum), for: .touchUpInside)
        customNav.addSubview(rightButton)
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(customNav.titleLabel)
            make.size.equalTo(CGSize.init(width: 37.5, height: 44))
            make.right.equalTo(-10)
        }
        //需要识别后的图像
        setNeedCodeImage(needCodeImg: true)

        //框向上移动10个像素
        scanStyle?.centerUpOffset += 10
        scanStyle?.colorRetangleLine = kBlueColor
        scanStyle?.colorAngle = UIColor.yxs_hexToAdecimalColor(hex: "#4E87FF")
        
        let XRetangleLeft = scanStyle?.xScanRetangleOffset ?? 60
        let size = SCREEN_WIDTH - XRetangleLeft * 2.0
        let SLaxRetangle = (SCREEN_HEIGHT - size)/2 + size - (scanStyle?.centerUpOffset ?? 60)
        view.addSubview(btnFlashControl)
        btnFlashControl.snp.makeConstraints { (make) in
            make.bottom.equalTo( -(SCREEN_HEIGHT - SLaxRetangle) + 10)
            make.centerX.equalTo(view)
            make.width.equalTo(60)
        }
        
        view.addSubview(desLabel)
        desLabel.snp.makeConstraints { (make) in
            make.top.equalTo(btnFlashControl.snp_bottom).offset(40)
            make.centerX.equalTo(view)
        }
    }


    override func handleCodeResult(arrayResult: [LBXScanResult]) {

        for result: LBXScanResult in arrayResult {
            if let str = result.strScanned {
                print(str)
            }
        }

        let result: LBXScanResult = arrayResult[0]
        let escapedString = (result.strScanned ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: escapedString ?? "")
        var urlComponents: URLComponents? = nil
        if let url = url {
            urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        }

        // url中参数的key value
        var parameter: [AnyHashable : Any] = [:]
        for item in urlComponents?.queryItems ?? [] {
            parameter[item.name] = item.value
        }
        
        switch scanType {
        case .addClass:
            let vc = YXSClassAddController.init(classText: parameter["gradeNum"] as? String ?? "")
            self.navigationController?.pushViewController(vc)
        default:
            break
        }
        
    }
    
    //开关闪光灯
    @objc func openOrCloseFlash() {
        scanObj?.changeTorch()
        isOpenedFlash = !isOpenedFlash
//
//        if isOpenedFlash
//        {
//            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_down"), for:UIControl.State.normal)
//        }
//        else
//        {
//            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControl.State.normal)
//
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(customNav)
        view.bringSubviewToFront(btnFlashControl)
        view.bringSubviewToFront(desLabel)
    }
    
    lazy var customNav: YXSCustomNav = {
        let customNav = YXSCustomNav.init(.backAndTitle)
        customNav.title = "扫码"
        customNav.titleLabel.textColor = UIColor.white
        customNav.leftImage = "yxs_back_white"
        return customNav
    }()
    
    lazy var btnFlashControl: YXSCustomImageControl = {
        let rightControl = YXSCustomImageControl.init(imageSize: CGSize.init(width: 15, height: 21.5), position: YXSImagePositionType.top, padding: 8.5)
        rightControl.textColor = UIColor.white
        rightControl.locailImage = "yxs_scan_btnFlash"
        rightControl.title = "轻点照亮"
        rightControl.font = UIFont.systemFont(ofSize: 12)
        rightControl.addTarget(self, action: #selector(YXSScanViewController.openOrCloseFlash), for: UIControl.Event.touchUpInside)
        return rightControl
    }()
    
    lazy var desLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF")
        label.text = "请对准二维码进行扫码"
        return label
    }()
}

// MARK: -HMRouterEventProtocol
extension YXSScanViewController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:
            break
        }
    }
}

