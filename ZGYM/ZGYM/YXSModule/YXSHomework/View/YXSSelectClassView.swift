//
//  SelectClassView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/18.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import SnapKit
import NightNight

private let maxcount = 2
private let kLabelOrginTag = 101

class YXSSelectClassView: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(selectTipslabel)
        self.addSubview(selectLabel)
        self.addSubview(imageView)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: UIColor.yxs_hexToAdecimalColor(hex: "#20232F"))
        selectTipslabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(self)
        }
        selectLabel.snp.makeConstraints { (make) in
            make.right.equalTo(imageView.snp_left).offset(-10)
            make.centerY.equalTo(self)
        }
        imageView.snp.makeConstraints { (make) in
            make.right.equalTo(-14)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize.init(width: 13, height: 21))
        }
        
        for index in 0..<maxcount{
            let label = YXSPaddingLabel()
            label.font = kTextMainBodyFont
            label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNightBCC6D4)
            label.textInsets = UIEdgeInsets.init(top: 0, left: 11, bottom: 0, right: 11)
            label.cornerRadius = 12
            label.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNight282C3B)
            label.clipsToBounds = true
            label.tag = index + kLabelOrginTag
            addSubview(label)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewModel(_ models:[SLClassModel]!){
        if let models = models{
            for index in 0..<maxcount{
                let label = viewWithTag(index + kLabelOrginTag)
                label?.isHidden = true
                label?.snp.removeConstraints()
            }
            
            let count = models.count > maxcount ? maxcount : models.count
            
            var labelMaxWidth:CGFloat = 0
            if models.count > maxcount{
                selectLabel.isHidden = false
                selectLabel.text = "等\(models.count)个级班"
                
                labelMaxWidth = (SCREEN_WIDTH - 88 - 50 - CGFloat(count - 1)*5 - 5 - selectLabel.sizeThatFits(CGSize.init(width: 100, height: 20)).width)/CGFloat(count)
            }else{
                selectLabel.isHidden = true
                labelMaxWidth = (SCREEN_WIDTH - 88 - 50 - CGFloat(count - 1)*5)/CGFloat(count)
            }
            
            var last: UIView?
            for index in 0..<count{
                let label = viewWithTag(index + kLabelOrginTag) as? UILabel
                label?.isHidden = false
                label?.text = models[count - index - 1].name
                label?.snp.makeConstraints({ (make) in
                    if let last = last{
                        make.right.equalTo(last.snp_left).offset(-5) 
                    }else{
                        make.right.equalTo(selectLabel.snp_left).offset(-5)
                    }
                    make.centerY.equalTo(self)
                    make.height.equalTo(24)
                    make.width.lessThanOrEqualTo(labelMaxWidth)
                })
                last = label
            }
        }
    }
    
    lazy var selectTipslabel: YXSLabel = {
        let label = YXSLabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.text = "接收班级"
        return label
    }()
    
    lazy var selectLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNightBCC6D4)
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_class_arrow"))
        return imageView
    }()
}

