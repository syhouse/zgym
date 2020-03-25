//
//  SourceView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/19.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

class SLHomeSourceView: UIImageView{
    init(){
        super.init(frame: CGRect.zero)
        
        addSubview(bgView)
        bgView.addSubview(iconImage)
        bgView.addSubview(label)

        bgView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(20)
        }
        iconImage.snp.makeConstraints { (make) in
            make.left.equalTo(2)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
            make.centerY.equalTo(bgView)
        }

        label.snp.makeConstraints { (make) in
            make.center.equalTo(bgView)
        }
        bgView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.cornerRadius = 2.5
        bgView.backgroundColor = UIColor(red: 0.02, green: 0.02, blue: 0.02, alpha: 0.5)
        return bgView
    }()
    
    lazy var iconImage: UIImageView = {
        let iconImage = UIImageView.init(image: UIImage.init(named: "audio"))
        return iconImage
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.text = "音频"
        return label
    }()
}
