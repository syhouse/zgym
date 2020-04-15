//
//  YXSCustomImageControl.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/15.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import SDWebImage
import NightNight

enum YXSImagePositionType: Int {
    case left
    case right
    case top
    case bottom
}


/// Control 尺寸需要自己设置  (left  right 需要设置高度  宽度自适应) ( top  bottom 需要设置宽度 高度自适应)
class YXSCustomImageControl: UIControl {
    /// 图片位置
    private var position: YXSImagePositionType
    
    /// 图片文字间距
    private var padding: CGFloat
    
    /// 整体Insets
    private var insets: UIEdgeInsets
        /// 初始化Control
    /// - Parameter imageSize: 图片大小
    /// - Parameter position: 图片位置
    /// - Parameter padding: 图文间距
    /// - Parameter insets: 图文插入间距
    init(imageSize: CGSize = CGSize.init(width: 16, height: 16), position: YXSImagePositionType = .right, padding: CGFloat = 10, insets: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)) {
        self.imageSize = imageSize
        self.position = position
        self.padding = padding
        self.insets = insets
        super.init(frame: CGRect.zero)
        addSubview(image)
        addSubview(titleLabel)
        updateUI()
        
        
    }
    
    private func updateUI(){
        switch position {
        case .right:
            titleLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(insets.left)
                make.centerY.equalTo(self)
            }
            image.snp.remakeConstraints { (make) in
                make.left.equalTo(titleLabel.snp_right).offset(padding)
                make.size.equalTo(imageSize)
                make.centerY.equalTo(self)
                make.right.equalTo(-insets.right).priorityHigh()
            }
            case .left:
            titleLabel.snp.remakeConstraints { (make) in
                make.right.equalTo(-insets.right).priorityHigh()
                make.centerY.equalTo(self)
                make.left.equalTo(image.snp_right).offset(padding)
            }
            image.snp.remakeConstraints { (make) in
                make.left.equalTo(insets.left)
                make.size.equalTo(imageSize)
                make.centerY.equalTo(self)
            }
            case .top:
            image.snp.remakeConstraints { (make) in
                make.top.equalTo(insets.top)
                make.size.equalTo(imageSize)
                make.centerX.equalTo(self)
            }
            titleLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(image.snp_bottom).offset(padding)
                make.centerX.equalTo(self)
                make.bottom.equalTo(-insets.bottom).priorityHigh()
            }
            case .bottom:
            image.snp.remakeConstraints { (make) in
                make.top.equalTo(titleLabel.snp_bottom).offset(padding)
                make.size.equalTo(imageSize)
                make.centerX.equalTo(self)
                make.bottom.equalTo(-insets.bottom).priorityHigh()
            }
            titleLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(insets.top)
                make.centerX.equalTo(self)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public
    /// 图片大小
    public var imageSize: CGSize{
        didSet{
            updateUI()
        }
    }
    
    /// 文字内容
    public var title: String?{
        didSet{
            titleLabel.text = self.title
        }
    }
    
    /// 文字富文本
    public var attributedText: NSAttributedString?{
        didSet{
            titleLabel.attributedText = attributedText
        }
    }
    
    /// 字体
    public var font: UIFont?{
        didSet{
            titleLabel.font = font
        }
    }
    
    /// 文字颜色
    public var textColor: UIColor!{
        didSet{
            titleLabel.textColor = textColor
        }
    }
    
    /// 设置日夜间颜色
    public var mixedTextColor: MixedColor!{
        didSet{
            titleLabel.mixedTextColor = mixedTextColor
        }
    }
    
    /// 是否选中
    public override var isSelected: Bool{
        didSet{
            if isSelected{
                titleLabel.text = selectTitle
                image.image = selectImage
            }else{
                titleLabel.text = normalTitle
                image.image = normalImage
            }
            //没有设置夜间夜色时候  临时处理
            if mixedTextColor == nil{
                titleLabel.textColor = isSelected ? selectColor : normalColor
            }
        }
    }

    public func setTitleColor(_ color: UIColor, for states: UIControl.State){
        if states == .normal{
            normalColor = color
        }else if states == .selected{
            selectColor = color
        }
    }
    public func setTitle(_ title: String!, for states: UIControl.State){
        if states == .normal{
            normalTitle = title
        }else if states == .selected{
            selectTitle = title
        }
        
        //更新文字颜色
        let isSelect = self.isSelected
        self.isSelected = isSelect
    }
    
    public func setImage(_ image: UIImage!, for states: UIControl.State){
        if states == .normal{
            normalImage = image
        }else if states == .selected{
            selectImage = image
        }
        
        //更新文字颜色
        let isSelect = self.isSelected
        self.isSelected = isSelect
    }

    
    /// 本地图片
    public var locailImage: String!{
        didSet{
            image.image = UIImage.init(named: self.locailImage)
        }
    }
    
    /// 本地光暗图片图片
    public var mixedImage: MixedImage!{
        didSet{
            image.mixedImage = mixedImage
        }
    }
    
    /// 网络图片
    public var netImageUrl: String!{
        didSet{
            image.sd_setImage(with: URL.init(string: netImageUrl),placeholderImage: kImageDefualtImage, completed: nil)
        }
    }
    
    public var textLabel: YXSLabel{
        get{
            return titleLabel
        }
    }
    
    private var normalTitle:String!
    private var selectTitle:String!
    private var normalColor:UIColor!
    private var selectColor:UIColor!

    private var normalImage:UIImage!
    private var selectImage:UIImage!
    
    private lazy var titleLabel: YXSLabel = {
       let view = YXSLabel()
        view.font = UIFont.systemFont(ofSize: 14)
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var image: UIImageView = {
       let view = UIImageView()
        return view
    }()
}
