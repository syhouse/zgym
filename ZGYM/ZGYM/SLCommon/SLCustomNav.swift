//
//  SLCustomNav.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/28.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

let kHMCustomNavBackEvent = "HMCustomNavBackEvent"
let kHMCustomNavShareEvent = "HMCustomNavShareEvent"
let kHMCustomNavMoreEvent = "HMCustomNavMoreEvent"

enum CustomStyle: Int{
    case onlyback
    case backAndTitle
    case backAndTitleAndRight
}

class SLCustomNav: UIView{
    init(_ style: CustomStyle = .backAndTitleAndRight) {
        super.init(frame: CGRect.zero)
       
        addSubview(backImageButton)
        
         
        backImageButton.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(20 + kSafeTopHeight)
            make.size.equalTo(CGSize.init(width: 64, height: 44))
            make.bottom.equalTo(0)
        }
        
        if style == .backAndTitle{
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(backImageButton)
                make.left.equalTo(74)
                make.right.equalTo(-74)
                make.height.equalTo(44)
            }
            
        }else if style == .backAndTitleAndRight{
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(backImageButton)
                make.left.equalTo(74)
                make.right.equalTo(-74)
                make.height.equalTo(44)
            }
            
            addSubview(shareButton)
//            addSubview(moreButton)
//            moreButton.snp.makeConstraints { (make) in
//                make.right.equalTo(-8.5)
//                make.centerY.equalTo(backImageButton)
//                make.size.equalTo(CGSize.init(width: 42, height: 42))
//            }
            shareButton.snp.makeConstraints { (make) in
                make.right.equalTo(-8.5)
                make.centerY.equalTo(backImageButton)
                make.size.equalTo(CGSize.init(width: 42, height: 42))
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -public
    
    /// 标题
    public var title: String? {
        didSet{
            titleLabel.text = title
        }
    }
    
    public var leftImage: String? {
        didSet{
            backImageButton.setImage(UIImage(named: leftImage ?? ""), for: .normal)
        }
    }
    
    
    /// 是否有右边 分享 更多按钮
    public var hasRightButton: Bool = true{
        didSet{
            if !hasRightButton{
                moreButton.isHidden = true
                shareButton.isHidden = true
            }
        }
    }
    
    
    // MARK: -action
    @objc func onBackClick(){
        sl_routerEventWithName(eventName: kHMCustomNavBackEvent)
    }
    @objc func shareClick(){
        sl_routerEventWithName(eventName: kHMCustomNavShareEvent)
    }
    @objc func moreClick(){
        sl_routerEventWithName(eventName: kHMCustomNavMoreEvent)
    }
    
    // MARK: -getter&setter
    
    lazy var backImageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onBackClick), for: .touchUpInside)
        /// !注意 修改此处请与石工沟通
        button.setMixedImage(MixedImage(normal: "back", night: "back"), forState: .normal)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
        button.setImage(UIImage(named: "sl_punchCard_share"), for: .normal)
        return button
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 4, y: 20 + kSafeTopHeight, width: 44, height: 44))
        button.addTarget(self, action: #selector(moreClick), for: .touchUpInside)
        button.setImage(UIImage(named: "sl_homework_more"), for: .normal)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kTextMainBodyColor)
        label.text = ""
        label.textAlignment = .center
        return label
    }()
}
