//
//  SLCommonSection.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/17.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight
enum SLCommonSectionType: Int {
    case onlyArrow
    case onlyRightTitle
    case onlyRightImage
    case rightTitleAndArrow
    case rightImageAndArrow
}


// MARK: - TipsSection  (左标题始终存在)
class SLCommonSection: UIControl {
    
    /// 初始化通用栏
    /// - Parameter type: 布局类型
    init(type: SLCommonSectionType) {
        super.init(frame: CGRect.zero)
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        addSubview(leftlabel)
        addSubview(rightLabel)
        addSubview(arrowImage)
        addSubview(rightImage)
        
        leftlabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(self)
        }
        arrowImage.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.size.equalTo(CGSize.init(width: 13.4, height: 13.4))
            make.centerY.equalTo(self)
        }
        rightLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(arrowImage)
        }
        
        rightImage.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(arrowImage)
            make.size.equalTo(CGSize.init(width: 41, height: 41))
        }
        
        sl_addLine(position: .bottom, leftMargin: 15)
        
        changeTypeUI(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 右边头像地址
    public var rightUrl:String?{
        didSet{
            rightImage.sd_setImage(with: URL.init(string: rightUrl ?? ""),placeholderImage: kImageDefualtImage, completed: nil)
        }
    }
    
    
    /// 修改布局
    /// - Parameter type: 布局类型
    public func changeTypeUI(type: SLCommonSectionType){
        arrowImage.isHidden = true
        rightImage.isHidden = true
        rightLabel.isHidden = true
        switch type {
        case .onlyRightTitle:
            rightLabel.isHidden = false
        case .onlyRightImage:
            rightImage.isHidden = false
        case .rightTitleAndArrow:
            rightLabel.isHidden = false
            arrowImage.isHidden = false
            rightLabel.snp.remakeConstraints { (make) in
                make.right.equalTo(arrowImage.snp_left).offset(-11)
                make.centerY.equalTo(arrowImage)
            }
        case .rightImageAndArrow:
            rightLabel.isHidden = false
            rightImage.isHidden = false
            rightImage.snp.remakeConstraints { (make) in
                make.right.equalTo(arrowImage.snp_left).offset(-11)
                make.centerY.equalTo(arrowImage)
                make.size.equalTo(CGSize.init(width: 41, height: 41))
            }
        case .onlyArrow:
            arrowImage.isHidden = false
            break
        }
    }
    
    /// 左边label
    lazy var leftlabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white)
        return label
    }()
    /// 右边label
    lazy var rightLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"), night: kNightBCC6D4)
        return label
    }()
    /// 右边arrow
    lazy var arrowImage: UIImageView = {
        let arrowImage = UIImageView.init(image: UIImage.init(named: "arrow_gray"))
        return arrowImage
    }()
    
    /// 右边图片
    lazy var rightImage: UIImageView = {
        let rightImage = UIImageView()
        rightImage.cornerRadius = 20.5
        return rightImage
    }()
}
