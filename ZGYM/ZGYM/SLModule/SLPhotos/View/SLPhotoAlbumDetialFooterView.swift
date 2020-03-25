//
//  SLPhotoAlbumDetialFooterView.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/9.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit

let kSLPhotoAlbumDetialFooterViewDelectEventKey = "SLPhotoAlbumDetialFooterViewDelectEvent"
let kSLPhotoAlbumDetialFooterViewUploadEventKey = "SLPhotoAlbumDetialFooterViewUploadEvent"
let kSLPhotoAlbumDetialFooterViewBeginEventKey = "SLPhotoAlbumDetialFooterViewBeginEvent"
let kSLPhotoAlbumDetialFooterViewCancelEditEventKey = "SLPhotoAlbumDetialFooterViewCancelEditEvent"

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
            next?.sl_routerEventWithName(eventName: kSLPhotoAlbumDetialFooterViewDelectEventKey)
        }else{
            next?.sl_routerEventWithName(eventName: kSLPhotoAlbumDetialFooterViewUploadEventKey)
        }
    }
    
    @objc func selectPhotoButtonClick(){
        next?.sl_routerEventWithName(eventName: kSLPhotoAlbumDetialFooterViewBeginEventKey)
        
    }
    
    @objc func selectAllControlClick(){
        isCurruntSelectAll = !selectAllControl.isSelected
        selectAllControl.isSelected = isCurruntSelectAll
        
        selectAllBlock?(selectAllControl.isSelected)
    }
    @objc func cancelSelectButtonClick(){
        next?.sl_routerEventWithName(eventName: kSLPhotoAlbumDetialFooterViewCancelEditEventKey)
    }

    lazy var rightButton: SLButton = {
        let rightButton = SLButton.init(frame: CGRect.init(x: 0, y: 0, width: 214, height: 41))
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightButton.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        rightButton.sl_gradualBackground(frame: CGRect.init(x: 0, y: 0, width: 214, height: 41), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 20.5)
        rightButton.setTitle("上传照片", for: .normal)
        return rightButton
    }()
    
    lazy var selectPhotoButton: UIButton = {
        let selectPhotoButton = UIButton()
        selectPhotoButton.setTitleColor(UIColor.sl_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        selectPhotoButton.setTitle("选择照片", for: .normal)
        selectPhotoButton.addTarget(self, action: #selector(selectPhotoButtonClick), for: .touchUpInside)
        return selectPhotoButton
    }()
    
    lazy var selectAllControl: SLCustomImageControl = {
        let selectAllControl = SLCustomImageControl.init(imageSize: CGSize.init(width: 17, height: 17), position: SLImagePositionType.left, padding: 7)
        selectAllControl.setTitleColor(UIColor.sl_hexToAdecimalColor(hex: "#222222"), for: .normal)
        selectAllControl.setTitle("全选", for: .normal)
        selectAllControl.setTitle("全选", for: .selected)
        selectAllControl.font = UIFont.systemFont(ofSize: 17)
        selectAllControl.setImage(UIImage.init(named: "sl_chose_normal"), for: .normal)
        selectAllControl.setImage(UIImage.init(named: "sl_chose_selected"), for: .selected)
        selectAllControl.addTarget(self, action: #selector(selectAllControlClick), for: .touchUpInside)

        return selectAllControl
    }()
    
        lazy var cancelSelectButton: UIButton = {
        let cancelSelectButton = UIButton()
        cancelSelectButton.setTitleColor(UIColor.sl_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        cancelSelectButton.setTitle("取消", for: .normal)
        cancelSelectButton.addTarget(self, action: #selector(cancelSelectButtonClick), for: .touchUpInside)
        return cancelSelectButton
    }()
}
