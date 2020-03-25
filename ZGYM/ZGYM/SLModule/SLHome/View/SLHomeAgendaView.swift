//
//  SLHomeAgendaView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/20.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLHomeAgendaView: UIControl{
    private init(){
        super.init(frame: CGRect.zero)
    }
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    /// 初始化
    /// - Parameter isHover: 悬停
    convenience init(_ isHover: Bool = false) {
        self.init(frame: CGRect.zero)
        addSubview(bgView)
        addSubview(shadowView)
        addSubview(leftView)
        addSubview(redLabel)
        addSubview(arrowImage)
        addSubview(redView)
        if isHover{
            bgView.snp.makeConstraints { (make) in
                make.edges.equalTo(0)
                make.height.equalTo(49).priorityHigh()
            }
            bgView.cornerRadius = 0
            bgView.sl_addLine(position: .bottom, color: UIColor.sl_hexToAdecimalColor(hex: "#e6eaf3"),lineHeight: 1)
        }else{
            bgView.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(0)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(49).priorityHigh()
            }
        }

        leftView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.bottom.equalTo(0)
        }
        redView.snp.makeConstraints { (make) in
            make.left.equalTo(49)
            make.size.equalTo(CGSize.init(width: 11, height: 11))
            make.top.equalTo(11)
        }
        arrowImage.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.size.equalTo(CGSize.init(width: 13.4, height: 13.4))
            make.centerY.equalTo(bgView)
        }
        redLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImage.snp_left).offset(-11)
            make.centerY.equalTo(bgView)
        }
    }
    
    public var count: Int = 0{
        didSet{
            if count > 0{
                redLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNightBCC6D4)
                redLabel.text = "\(count)项待办"
                redView.isHidden = false
            }else{
                redLabel.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"))
                redLabel.backgroundColor = UIColor.clear
                redLabel.text = "暂无"
                redView.isHidden = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var leftView: SLCustomImageControl = {
        let leftView = SLCustomImageControl.init(imageSize: CGSize.init(width: 28, height: 28), position: .left, padding: 11)
        leftView.font = UIFont.boldSystemFont(ofSize: 16)
        leftView.title = "待办事项"
        leftView.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        leftView.locailImage = "agenda"
        return leftView
    }()
    	
    lazy var redLabel: SLPaddingLabel = {
       let redLabel = SLPaddingLabel()
        redLabel.font = UIFont.systemFont(ofSize: 14)
        return redLabel
    }()
    
    lazy var arrowImage: UIImageView = {
        let arrowImage = UIImageView.init(image: UIImage.init(named: "arrow_gray"))
        return arrowImage
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.cornerRadius = 4
        bgView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight20222F)
        return bgView
    }()
    
    lazy var redView: UIView = {
        let redView = UIView()
        redView.cornerRadius = 5.5
        redView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#E8534C")
        redView.isHidden = true
        return redView
    }()
    
    lazy var shadowView: UIView = {
        let shadowView = UIView()
        shadowView.isHidden = true
        shadowView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9")
        return shadowView
    }()
    
}
