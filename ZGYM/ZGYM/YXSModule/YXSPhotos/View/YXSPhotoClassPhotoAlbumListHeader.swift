//
//  YXSPhotoClassPhotoAlbumListHeader.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/5/27.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
/// 相册列表最顶部(x条最新消息)
class YXSPhotoClassPhotoAlbumListHeader: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(panelView)
        panelView.addSubview(btnTopMsg)
        panelView.addSubview(imgCover)
        
        panelView.snp.makeConstraints({ (make) in
            make.top.equalTo(10).offset(0)
            make.height.equalTo(30)
            make.centerX.equalTo(self.snp_centerX)
        })
        
        imgCover.snp.makeConstraints({ (make) in
            make.left.equalTo(panelView.snp_left).offset(2)
            make.centerY.equalTo(panelView.snp_centerY)
            make.width.height.equalTo(28)
        })
        
        btnTopMsg.snp.makeConstraints({ (make) in
            make.left.equalTo(imgCover.snp_right).offset(4)
            make.right.equalTo(panelView.snp_right).offset(-10)
            make.centerY.equalTo(panelView.snp_centerY)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var messageInfo: YXSPhotoClassPhotoAlbumListMsgModel? {
        didSet {
            imgCover.sd_setImage(with: URL(string: self.messageInfo?.messageAvatar ?? ""), placeholderImage: UIImage(named: "defultImage"))
            btnTopMsg.setTitle("\(self.messageInfo?.messageCount ?? 0)条新消息", for: .normal)
        }
    }
    
    // MARK: - LazyLoad
    lazy var panelView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#93B0F9")
        view.cornerRadius = 15
        return view
    }()
    
    lazy var imgCover: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "defultImage")
        img.cornerRadius = 14
        img.clipsToBounds = true
        return img
    }()
    
    lazy var btnTopMsg: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("2条新消息", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        btn.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#93B0F9")
//        btn.clipsToBounds = true
//        btn.addTarget(self, action: #selector(newMessageClick(sender:)), for: .touchUpInside)
        return btn
    }()
}
