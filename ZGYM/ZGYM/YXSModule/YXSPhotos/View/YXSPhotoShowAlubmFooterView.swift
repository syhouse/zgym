//
//  YXSPhotoShowAlubmFooterView.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/13.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit

let kYXSPhotoShowAlubmFooterViewMoreEventKey = "YXSPhotoShowAlubmFooterViewMoreEventKey"

class YXSPhotoShowAlubmFooterView: UIView {
    var model: YXSPhotoAlbumsPraiseModel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        addSubview(minePriseButton)
        addSubview(commentButton)
        addSubview(curruntPriseButton)
        addSubview(moreActionButton)
        
        minePriseButton.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.equalTo(21)
            make.height.equalTo(22)
        }
        
        commentButton.snp.makeConstraints { (make) in
            make.left.equalTo(90)
            make.centerY.equalTo(minePriseButton)
            make.height.equalTo(22)
        }
        
        curruntPriseButton.snp.makeConstraints { (make) in
            make.right.equalTo(-56)
            make.centerY.equalTo(minePriseButton)
            make.height.equalTo(22)
        }
        
        moreActionButton.snp.makeConstraints { (make) in
            make.right.equalTo(-4.5)
            make.centerY.equalTo(minePriseButton)
            make.width.height.equalTo(42)
        }
        
//        64 +
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model: YXSPhotoAlbumsPraiseModel){
        self.model = model
        minePriseButton.isSelected = model.isPraise == 1
        commentButton.title = "评论\(model.commentList?.count ?? 0)"
        let praiseCount = model.praiseCount ?? 0
        curruntPriseButton.title = praiseCount > 99 ? "99+" : "\(praiseCount)"
    }
    
    var cellBlock: ((_ isComment: Bool)->())?
    
    @objc func minePriseButtonClick(){
        if model != nil{
            let isCanclePraise = (model.isPraise ?? 0 ) == 1
            model.isPraise =  isCanclePraise ? 0 : 1
            model.praiseCount = isCanclePraise ? (model.praiseCount ?? 0) - 1 : (model.praiseCount ?? 0) + 1
            cellBlock?(false)
        }
    }
    
    @objc func commentButtonClick(){
        cellBlock?(true)
    }
    
    @objc func moreActionClick(){
        next?.yxs_routerEventWithName(eventName: kYXSPhotoShowAlubmFooterViewMoreEventKey)
    }
    
    
    lazy var minePriseButton: YXSCustomImageControl = {
        let minePriseButton = YXSCustomImageControl.init(imageSize: CGSize.init(width: 22, height: 22), position: YXSImagePositionType.left, padding: 7)
        minePriseButton.setTitleColor(UIColor.white, for: .normal)
        minePriseButton.setTitle("赞", for: .normal)
        minePriseButton.setTitle("赞", for: .selected)
        minePriseButton.font = UIFont.systemFont(ofSize: 16)
        minePriseButton.setImage(UIImage.init(named: "yxs_photo_praise_normal"), for: .normal)
        minePriseButton.setImage(UIImage.init(named: "yxs_photo_praise_select"), for: .selected)
        minePriseButton.addTarget(self, action: #selector(minePriseButtonClick), for: .touchUpInside)
        minePriseButton.isSelected = false
        return minePriseButton
    }()
    
    lazy var commentButton: YXSCustomImageControl = {
        let commentButton = YXSCustomImageControl.init(imageSize: CGSize.init(width: 22, height: 22), position: YXSImagePositionType.left, padding: 7)
        commentButton.textColor = UIColor.white
        commentButton.title = "评论"
        commentButton.font = UIFont.systemFont(ofSize: 16)
        commentButton.locailImage = "yxs_photo_comment"
        commentButton.addTarget(self, action: #selector(commentButtonClick), for: .touchUpInside)
        return commentButton
    }()
    
    lazy var curruntPriseButton: YXSCustomImageControl = {
        let curruntPriseButton = YXSCustomImageControl.init(imageSize: CGSize.init(width: 22, height: 22), position: YXSImagePositionType.left, padding: 7)
        curruntPriseButton.textColor = UIColor.white
        curruntPriseButton.title = "0"
        curruntPriseButton.font = UIFont.systemFont(ofSize: 16)
        curruntPriseButton.locailImage = "yxs_photo_praise_normal"
        return curruntPriseButton
    }()
    
    lazy var moreActionButton: UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage.init(named: "yxs_photo_more"), for: .normal)
        button.addTarget(self, action: #selector(moreActionClick), for: .touchUpInside)
        return button
    }()
}
