//
//  ScoreDetialController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2020/1/17.
//  Copyright © 2020 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLScoreDetialController: SLBaseViewController{
    
    // MARK: -leftCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "成绩"
        initUI()
    }
    
    func initUI(){
        view.addSubview(scheduleImage)
        view.addSubview(scheduleLabel)
        
        view.addSubview(imageView)
        scheduleImage.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.right.equalTo(view).offset(-100)
            make.size.equalTo(CGSize.init(width: 271, height: 188.5))
        }
        scheduleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(imageView.snp_bottom).offset(15.5)
        }
    }
  
    lazy var scheduleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var scheduleLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#C4CDDA")
        label.text = "暂无成绩"
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.mixedImage = MixedImage(normal: "sl_empty_classScheduleCard", night: "sl_empty_classScheduleCard_night")
        return imageView
    }()
}
