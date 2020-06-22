//
//  YXSPhotoShowAlubmFooterView.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/13.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
/// 赞/评论
class YXSPhotoPreviewFooterView: UIView {
    var model: YXSPhotoAlbumsPraiseModel?{
        didSet{
            if let model = model{
                minePriseButton.isSelected = model.praiseStat == 1
                commentButton.title = "评论(\(model.commentCount ?? 0))"
                let praiseCount = model.praiseCount ?? 0
                currentPriseButton.title = praiseCount > 99 ? "99+" : "\(praiseCount)"
            }
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        addSubview(minePriseButton)
        addSubview(commentButton)
        addSubview(currentPriseButton)
        
        
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
        
        
        currentPriseButton.snp.makeConstraints { (make) in
            make.right.equalTo(-56)
            make.centerY.equalTo(minePriseButton)
            make.height.equalTo(22)
        }
        addSubview(moreActionButton)
        moreActionButton.snp.makeConstraints { (make) in
            make.right.equalTo(-4.5)
            make.centerY.equalTo(minePriseButton)
            make.width.height.equalTo(42)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cellBlock: ((_ isComment: Bool)->())?
    
    // MARK: - LazyLoad
    lazy var minePriseButton: YXSCustomImageControl = {
        let minePriseButton = YXSCustomImageControl.init(imageSize: CGSize.init(width: 22, height: 22), position: YXSImagePositionType.left, padding: 7)
        minePriseButton.setTitleColor(UIColor.white, for: .normal)
        minePriseButton.setTitleColor(UIColor.white, for: .selected)
        minePriseButton.setTitle("赞", for: .normal)
        minePriseButton.setTitle("赞", for: .selected)
        minePriseButton.font = UIFont.systemFont(ofSize: 16)
        minePriseButton.setImage(UIImage.init(named: "yxs_photo_praise_normal"), for: .normal)
        minePriseButton.setImage(UIImage.init(named: "yxs_photo_praise_select"), for: .selected)
        minePriseButton.isSelected = false
        minePriseButton.yxs_touchInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        return minePriseButton
    }()
    
    lazy var commentButton: YXSCustomImageControl = {
        let commentButton = YXSCustomImageControl.init(imageSize: CGSize.init(width: 22, height: 22), position: YXSImagePositionType.left, padding: 7)
        commentButton.textColor = UIColor.white
        commentButton.title = "评论"
        commentButton.font = UIFont.systemFont(ofSize: 16)
        commentButton.locailImage = "yxs_photo_comment"
        commentButton.yxs_touchInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        return commentButton
    }()
    
    lazy var currentPriseButton: YXSCustomImageControl = {
        let currentPriseButton = YXSCustomImageControl.init(imageSize: CGSize.init(width: 22, height: 22), position: YXSImagePositionType.left, padding: 7)
        currentPriseButton.textColor = UIColor.white
        currentPriseButton.title = "0"
        currentPriseButton.font = UIFont.systemFont(ofSize: 16)
        currentPriseButton.locailImage = "yxs_photo_praise_normal"
        currentPriseButton.yxs_touchInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        return currentPriseButton
    }()
    
    lazy var moreActionButton: UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage.init(named: "yxs_photo_more"), for: .normal)
        button.yxs_touchInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()
}
