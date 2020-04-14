//
//  YXSHomeAgendaView.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/20.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSHomeAgendaView: UIControl{
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
        addSubview(yxs_bgView)
        addSubview(yxs_shadowView)
        addSubview(yxs_leftView)
        addSubview(yxs_redLabel)
        addSubview(yxs_arrowImage)
        addSubview(yxs_redView)
        if isHover{
            yxs_bgView.snp.makeConstraints { (make) in
                make.edges.equalTo(0)
                make.height.equalTo(49).priorityHigh()
            }
            yxs_bgView.cornerRadius = 0
            yxs_bgView.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#e6eaf3"),lineHeight: 1)
        }else{
            yxs_bgView.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(0)
                make.left.equalTo(15).priorityHigh()
                make.right.equalTo(-15).priorityHigh()
                make.height.equalTo(49).priorityHigh()
            }
        }

        yxs_leftView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.bottom.equalTo(0)
        }
        yxs_redView.snp.makeConstraints { (make) in
            make.left.equalTo(49)
            make.size.equalTo(CGSize.init(width: 11, height: 11))
            make.top.equalTo(11)
        }
        yxs_arrowImage.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.size.equalTo(CGSize.init(width: 13.4, height: 13.4))
            make.centerY.equalTo(yxs_bgView)
        }
        yxs_redLabel.snp.makeConstraints { (make) in
            make.right.equalTo(yxs_arrowImage.snp_left).offset(-11)
            make.centerY.equalTo(yxs_bgView)
        }
    }
    ///修改待办数量
    public var count: Int = 0{
        didSet{
            if count > 0{
                yxs_redLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNightBCC6D4)
                yxs_redLabel.text = "\(count)项待办"
                yxs_redView.isHidden = false
            }else{
                yxs_redLabel.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
                yxs_redLabel.backgroundColor = UIColor.clear
                yxs_redLabel.text = "暂无"
                yxs_redView.isHidden = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var yxs_leftView: YXSCustomImageControl = {
        let yxs_leftView = YXSCustomImageControl.init(imageSize: CGSize.init(width: 28, height: 28), position: .left, padding: 11)
        yxs_leftView.font = UIFont.boldSystemFont(ofSize: 16)
        yxs_leftView.title = "待办事项"
        yxs_leftView.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        yxs_leftView.locailImage = "yxs_agenda"
        return yxs_leftView
    }()
    	
    lazy var yxs_redLabel: YXSPaddingLabel = {
       let yxs_redLabel = YXSPaddingLabel()
        yxs_redLabel.font = UIFont.systemFont(ofSize: 14)
        return yxs_redLabel
    }()
    
    lazy var yxs_arrowImage: UIImageView = {
        let yxs_arrowImage = UIImageView.init(image: UIImage.init(named: "arrow_gray"))
        return yxs_arrowImage
    }()
    
    lazy var yxs_bgView: UIView = {
        let yxs_bgView = UIView()
        yxs_bgView.cornerRadius = 4
        yxs_bgView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight20222F)
        return yxs_bgView
    }()
    
    lazy var yxs_redView: UIView = {
        let yxs_redView = UIView()
        yxs_redView.cornerRadius = 5.5
        yxs_redView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#E8534C")
        yxs_redView.isHidden = true
        return yxs_redView
    }()
    
    lazy var yxs_shadowView: UIView = {
        let yxs_shadowView = UIView()
        yxs_shadowView.isHidden = true
        yxs_shadowView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9")
        return yxs_shadowView
    }()
    
}
