//
//  SLPhotoCreateAlbumController.swift
//  HNYMEducation
//
//  Created by sy_mac on 2020/3/2.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

class SLPhotoCreateAlbumController: SLEditAlbumBaseController {
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
            yxs_showAlert(title: "请输入相册名称")
            return
        }
        if selectMediaModel != nil{
            loadUploadImageData()
        }else{
            loadUploadFinishData()
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
