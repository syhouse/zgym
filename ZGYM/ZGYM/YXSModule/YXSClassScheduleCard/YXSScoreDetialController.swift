//
//  ScoreDetialController.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2020/1/17.
//  Copyright © 2020 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSScoreDetialController: YXSBaseViewController{
    
    // MARK: -leftCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "成绩"
        yxs_initUI()
    }
    
    func yxs_initUI(){
        view.addSubview(yxs_scheduleImage)
        view.addSubview(yxs_scheduleLabel)
        
        view.addSubview(yxs_imageView)
        yxs_scheduleImage.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        yxs_imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.right.equalTo(view).offset(-100)
            make.size.equalTo(CGSize.init(width: 271, height: 188.5))
        }
        yxs_scheduleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(yxs_imageView.snp_bottom).offset(15.5)
        }
    }
  
    lazy var yxs_scheduleImage: UIImageView = {
        let yxs_imageView = UIImageView()
        yxs_imageView.contentMode = .scaleAspectFit
        return yxs_imageView
    }()
    
    lazy var yxs_scheduleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        label.text = "暂无成绩"
        return label
    }()
    
    lazy var yxs_imageView: UIImageView = {
        let yxs_imageView = UIImageView()
        yxs_imageView.mixedImage = MixedImage(normal: "yxs_empty_classScheduleCard", night: "yxs_empty_classScheduleCard_night")
        return yxs_imageView
    }()
}
