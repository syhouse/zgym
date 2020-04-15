//
//  YXSLinkView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/25.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSLinkView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var block:((_ url:String)->())?
    init(link:String, clickCompletion:((_ url:String)->())?) {
        super.init(frame: CGRect.zero)
        
        self.block = clickCompletion
        strLink = link
    }
    
    func createUI() {
        
        self.clipsToBounds = true
        self.cornerRadius = 3
        self.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNightForegroundColor)
        self.addSubview(self.imgIcon)
        self.addSubview(self.btnLink)
        
        self.imgIcon.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(15)
            make.width.height.equalTo(18)
        })
        
        self.btnLink.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(self.imgIcon.snp_right).offset(5)
            make.right.equalTo(-5)
        })
    }
    
    var strLink:String? {
        didSet {
            btnLink.setTitle("链接: \(self.strLink ?? "")", for: .normal)
        }
    }
    
    // MARK: - Action
    @objc func linkClick(sender: YXSButton) {
        self.block?(strLink ?? "")
    }
    
    // MARK: - LazyLoad
    lazy var btnLink: YXSButton = {
        let btn = YXSButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.contentHorizontalAlignment = .left
        btn.setMixedTitleColor(MixedColor(normal: k575A60Color, night: kNightBCC6D4), forState: .normal)
        btn.addTarget(self, action: #selector(linkClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var imgIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "yxs_homework_link")
        return img
    }()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
