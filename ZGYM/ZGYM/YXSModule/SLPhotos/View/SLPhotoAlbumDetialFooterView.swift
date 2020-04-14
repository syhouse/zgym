//
//  SLPhotoAlbumDetialFooterView.swift
//  HNYMEducation
//
//  Created by sy_mac on 2020/3/9.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit

let kYXSPhotoAlbumDetialFooterViewDelectEventKey = "SLPhotoAlbumDetialFooterViewDelectEvent"
let kYXSPhotoAlbumDetialFooterViewUploadEventKey = "SLPhotoAlbumDetialFooterViewUploadEvent"
let kYXSPhotoAlbumDetialFooterViewBeginEventKey = "SLPhotoAlbumDetialFooterViewBeginEvent"
let kYXSPhotoAlbumDetialFooterViewCancelEditEventKey = "SLPhotoAlbumDetialFooterViewCancelEditEvent"

class SLPhotoAlbumDetialFooterView: UIView {
    var selectAllBlock: ((_ isSelectAll: Bool)->())?
    
    /// 当前是否全选中
    var isCurruntSelectAll: Bool = false
    var isEdit = false{
        didSet{
            selectPhotoButton.isHidden = true
            selectAllControl.isHidden = true
            cancelSelectButton.isHidden = true
            selectAllControl.isSelected = false
            isCurruntSelectAll = false
            if isEdit{
                selectAllControl.isHidden = false
                cancelSelectButton.isHidden = false
                rightButton.setTitle("删除", for: .normal)
            }else{
                selectPhotoButton.isHidden = false
                rightButton.setTitle("上传照片", for: .normal)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(rightButton)
        addSubview(selectPhotoButton)
        addSubview(selectAllControl)
        addSubview(cancelSelectButton)
        
        rightButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 214, height: 41))
            make.top.equalTo(10)
            make.right.equalTo(-15)
        }
        selectPhotoButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(14.5)
        }
        selectAllControl.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(18)
            make.left.equalTo(14.5)
        }
        cancelSelectButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(82.5)
            make.height.equalTo(18)
            make.width.equalTo(52.5)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func rightButtonClick(){
        if isEdit{
            next?.yxs_routerEventWithName(eventName: kYXSPhotoAlbumDetialFooterViewDelectEventKey)
        }else{
            next?.yxs_routerEventWithName(eventName: kYXSPhotoAlbumDetialFooterViewUploadEventKey)
        }
    }
    
    @objc func selectPhotoButtonClick(){
        next?.yxs_routerEventWithName(eventName: kYXSPhotoAlbumDetialFooterViewBeginEventKey)
        
    }
    
    @objc func selectAllControlClick(){
        isCurruntSelectAll = !selectAllControl.isSelected
        selectAllControl.isSelected = isCurruntSelectAll
        
        selectAllBlock?(selectAllControl.isSelected)
    }
    @objc func cancelSelectButtonClick(){
        next?.yxs_routerEventWithName(eventName: kYXSPhotoAlbumDetialFooterViewCancelEditEventKey)
    }

    lazy var rightButton: YXSButton = {
        let rightButton = YXSButton.init(frame: CGRect.init(x: 0, y: 0, width: 214, height: 41))
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightButton.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        rightButton.yxs_gradualBackground(frame: CGRect.init(x: 0, y: 0, width: 214, height: 41), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 20.5)
        rightButton.setTitle("上传照片", for: .normal)
        return rightButton
    }()
    
    lazy var selectPhotoButton: UIButton = {
        let selectPhotoButton = UIButton()
        selectPhotoButton.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        selectPhotoButton.setTitle("选择照片", for: .normal)
        selectPhotoButton.addTarget(self, action: #selector(selectPhotoButtonClick), for: .touchUpInside)
        return selectPhotoButton
    }()
    
    lazy var selectAllControl: YXSCustomImageControl = {
        let selectAllControl = YXSCustomImageControl.init(imageSize: CGSize.init(width: 17, height: 17), position: YXSImagePositionType.left, padding: 7)
        selectAllControl.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#222222"), for: .normal)
        selectAllControl.setTitle("全选", for: .normal)
        selectAllControl.setTitle("全选", for: .selected)
        selectAllControl.font = UIFont.systemFont(ofSize: 17)
        selectAllControl.setImage(UIImage.init(named: "yxs_chose_normal"), for: .normal)
        selectAllControl.setImage(UIImage.init(named: "yxs_chose_selected"), for: .selected)
        selectAllControl.addTarget(self, action: #selector(selectAllControlClick), for: .touchUpInside)

        return selectAllControl
    }()
    
        lazy var cancelSelectButton: UIButton = {
        let cancelSelectButton = UIButton()
        cancelSelectButton.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        cancelSelectButton.setTitle("取消", for: .normal)
        cancelSelectButton.addTarget(self, action: #selector(cancelSelectButtonClick), for: .touchUpInside)
        return cancelSelectButton
    }()
}
