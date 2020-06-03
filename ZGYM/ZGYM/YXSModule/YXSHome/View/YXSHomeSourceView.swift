//
//  YXSHomeSourceView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/19.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

class YXSHomeSourceView: UIImageView{
    init(){
        super.init(frame: CGRect.zero)
        
        addSubview(yxs_bgView)
        yxs_bgView.addSubview(yxs_iconImage)
        yxs_bgView.addSubview(yxs_label)
        addSubview(vedioImage)
        
        yxs_bgView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(20)
        }
        yxs_iconImage.snp.makeConstraints { (make) in
            make.left.equalTo(2)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
            make.centerY.equalTo(yxs_bgView)
        }
        
        vedioImage.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        yxs_label.snp.makeConstraints { (make) in
            make.center.equalTo(yxs_bgView)
        }
        yxs_bgView.isHidden = true
        vedioImage.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var yxs_bgView: UIView = {
        let bgView = UIView()
        bgView.cornerRadius = 2.5
        bgView.backgroundColor = UIColor(red: 0.02, green: 0.02, blue: 0.02, alpha: 0.5)
        return bgView
    }()
    
    lazy var yxs_iconImage: UIImageView = {
        let iconImage = UIImageView.init(image: UIImage.init(named: "audio"))
        return iconImage
    }()
    
    lazy var vedioImage: UIImageView = {
        let vedioImage = UIImageView.init(image: UIImage.init(named: "vedio"))
        return vedioImage
    }()
    
    lazy var yxs_label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.text = "音频"
        return label
    }()
}
