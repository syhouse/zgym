//
//  YXSPhotoEditAlbumController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/6.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

class YXSPhotoEditAlbumController: YXSEditAlbumBaseController {
    var updateAlbumSucess: ((_ albumModel: YXSPhotoAlbumsModel)->())?
    let albumModel: YXSPhotoAlbumsModel
    // MARK: -leftCycle
    
    init(albumModel: YXSPhotoAlbumsModel) {
        self.albumModel = albumModel
        super.init(classId: albumModel.classId ?? 0)
    }
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "编辑相册"
        let rightButton = YXSButton(frame: CGRect(x: 0, y: 0, width: 58, height: 25))
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.setTitle("保存", for: .normal)
        rightButton.cornerRadius = 12.5
        rightButton.backgroundColor = kBlueColor
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightButton.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        rightButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        rightButton.widthAnchor.constraint(equalToConstant: 58).isActive = true
        let rightItem = UIBarButtonItem.init(customView: rightButton)
        navigationItem.rightBarButtonItem = rightItem
        
        
        let backButton = yxs_setNavLeftTitle(title: "取消")
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        backButton.setMixedTitleColor( MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4) , forState: .normal)
        
        nameField.text = albumModel.albumName
        photoSection.setImages(images: [albumModel.coverUrl ?? ""])
    }
    override func initUI(){
        super.initUI()
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 84))
        let btnDelete = YXSButton()
        btnDelete.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightForegroundColor)
        btnDelete.setImage(UIImage(named: "yxs_mine_delete"), for: .normal)
        btnDelete.setTitle("删除相册", for: .normal)
        btnDelete.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btnDelete.setMixedTitleColor(MixedColor(normal: 0xEC9590, night: 0xEC9590), forState: .normal)
        btnDelete.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
        footerView.addSubview(btnDelete)
        btnDelete.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(49)
        })
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(photoSection.snp_bottom).offset(25.5)
            make.height.equalTo(49)
        }
    }
    
    @objc func rightClick(){
        if nameField.text == albumModel.albumName && self.selectMediaModel == nil {
            yxs_showAlert(title: "当前未有修改")
            return
        }
        loadUploadImageData()
    }
    
    /// 上传照片完成请求
    override func loadUploadFinishData(){
        MBProgressHUD.yxs_showLoading()
        YXSEducationAlbumUpdateAlbumNameOrCoverRequest.init(id: albumModel.id ?? 0, albumName: nameField.text, coverUrl: coverUrl).request({ (result) in
            MBProgressHUD.yxs_showMessage(message: "修改成功")
            self.albumModel.albumName = self.nameField.text
            self.albumModel.coverUrl = self.coverUrl
            self.updateAlbumSucess?(self.albumModel)
            self.navigationController?.popViewController()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    @objc func deleteClick(){
        MBProgressHUD.yxs_showLoading()
        YXSEducationAlbumDeleteRequest.init(id: albumModel.id ?? 0).request({ (result) in
            MBProgressHUD.yxs_showMessage(message: "删除成功")
            self.navigationController?.yxs_existViewController(existClass: YXSPhotoClassPhotoAlbumListController.self, complete: { (vc) in
                vc.removeAlbum(albumModel: self.albumModel)
            })
            self.navigationController?.popViewController()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
}
