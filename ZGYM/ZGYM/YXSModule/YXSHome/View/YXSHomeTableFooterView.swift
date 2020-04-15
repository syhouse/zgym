//
//  YXSHomeTableFooterView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/21.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSHomeTableFooterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(midView)
        addSubview(leftLine)
        addSubview(rightLine)
        addSubview(emptyView)
        
        midView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(22)
            make.height.equalTo(22.5)
        }
        leftLine.snp.makeConstraints { (make) in
            make.right.equalTo(midView.snp_left).offset(-4)
            make.centerY.equalTo(midView)
            make.size.equalTo(CGSize.init(width: 60, height: 0.5))
        }
        
        rightLine.snp.makeConstraints { (make) in
            make.left.equalTo(midView.snp_right).offset(4)
            make.centerY.equalTo(midView)
            make.size.equalTo(CGSize.init(width: 60, height: 0.5))
        }
        
        emptyView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        emptyView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///刷新view 是否展示没有数据
    func showEmpty(_ isEmpty: Bool){
        emptyView.isHidden = true
        rightLine.isHidden = true
        leftLine.isHidden = true
        midView.isHidden = true
        if isEmpty{
            emptyView.isHidden = false
        }else{
            rightLine.isHidden = false
            leftLine.isHidden = false
            midView.isHidden = false
        }
    }

    lazy var midView: YXSCustomImageControl = {
        let midView = YXSCustomImageControl.init(imageSize: CGSize.init(width: 27.5, height: 22.5), position: .left, padding: 5)
        midView.title = "我是有底线滴"
        midView.locailImage = "home_footer"
        midView.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        midView.font = UIFont.systemFont(ofSize: 13)
        return midView
    }()
    
    lazy var leftLine: UIView = {
       let leftLine = UIView()
        leftLine.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDD9")
        return leftLine
    }()
    
    lazy var rightLine: UIView = {
       let rightLine = UIView()
        rightLine.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDD9")
        return rightLine
    }()
    
    lazy var emptyView: UIImageView = {
        let imageView = UIImageView()
        imageView.mixedImage = MixedImage(normal: "yxs_defultImage_nodata", night: "yxs_defultImage_nodata_night")
        return imageView
    }()
}
