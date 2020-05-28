//
//  YXSPhotoCreateAlbumController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/2.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

/// 新建相册
class YXSPhotoCreateAlbumController: YXSEditAlbumBaseController {
    // MARK: -leftCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initUI(){
        super.initUI()
        self.view.addSubview(createBtn)
        createBtn.snp.makeConstraints { (make) in
            make.left.equalTo(28.5)
            make.right.equalTo(-28.5)
            make.top.equalTo(photoSection.snp_bottom).offset(50)
            make.height.equalTo(49)
        }
    }
    
    @objc func createClick(){
        if nameField.text?.count == 0 {
            MBProgressHUD.yxs_showMessage(message: "请输入相册名称")
            return
        }
        
        if selectMediaModel == nil {
            MBProgressHUD.yxs_showLoading(inView: self.view)
            YXSEducationAlbumCreateRequest.init(classId: self.classId, albumName: self.nameField.text!, coverUrl: "").request({ (json) in
                MBProgressHUD.yxs_hideHUDInView(view: self.view)
                MBProgressHUD.yxs_showMessage(message: "创建成功")
                self.changeAlbumBlock?()
                self.navigationController?.popViewController()
            }) { (msg, code) in
                MBProgressHUD.yxs_hideHUDInView(view: self.view)
                self.view.makeToast("\(msg)")
            }
            
        } else {
            YXSFileUploadHelper.sharedInstance.uploadPHAssetDataSource(mediaAssets: [selectMediaModel.asset], storageType: .albumCover, classId: classId, progress: nil, sucess: { [weak self](list) in
                guard let weakSelf = self else {return}
                
                if let url = list.first?.fileUrl {
                    MBProgressHUD.yxs_showLoading(inView: weakSelf.view)
                    YXSEducationAlbumCreateRequest.init(classId: weakSelf.classId, albumName: weakSelf.nameField.text!, coverUrl: url).request({ (json) in
                        MBProgressHUD.yxs_hideHUDInView(view: weakSelf.view)
                        MBProgressHUD.yxs_showMessage(message: "创建成功")
                        weakSelf.changeAlbumBlock?()
                        weakSelf.navigationController?.popViewController()
                    }) { (msg, code) in
                        MBProgressHUD.yxs_hideHUDInView(view: weakSelf.view)
                        weakSelf.view.makeToast("\(msg)")
                    }
                }
                
            }) { [weak self](msg, code) in
                guard let weakSelf = self else {return}

                MBProgressHUD.yxs_hideHUDInView(view: weakSelf.view)
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
    }
    
    lazy var createBtn: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("完成新建", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setMixedTitleColor(MixedColor(normal: 0xFFFFFF, night: 0xFFFFFF), forState: .normal)
        btn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 57, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        btn.yxs_shadow(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 57, height: 49), color: UIColor.gray, cornerRadius: 24.5, offset: CGSize(width: 4, height: 4))
        btn.layer.cornerRadius = 24.5
        btn.addTarget(self, action: #selector(createClick), for: .touchUpInside)
        return btn
    }()
}
