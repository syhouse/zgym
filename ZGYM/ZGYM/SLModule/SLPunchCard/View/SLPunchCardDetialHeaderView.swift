//
//  SLPunchCardDetialHeaderView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/27.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

class SLPunchCardDetialHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#A9CBFF")
        
        addSubview(headerImageView)
        

        addSubview(labelImageView)
        
        addSubview(cardTeacherView)
        
        addSubview(punchCardMainView)
        
        addSubview(linkLeftView)
        addSubview(linkRightView)
        
        layout()
    }
    
    func layout(){
        headerImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(226 + kSafeTopHeight)
        }
       
        labelImageView.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.height.equalTo(33)
            make.top.equalTo(183 + kSafeTopHeight)
            
        }
        cardTeacherView.snp.makeConstraints { (make) in
            make.left.equalTo(20.5)
            make.right.equalTo(-20.5)
            make.top.equalTo(labelImageView).offset(13.5)
        }

        punchCardMainView.snp.remakeConstraints { (make) in
            make.top.equalTo(cardTeacherView.snp_bottom).offset(10)
            make.left.equalTo(20.5)
            make.right.equalTo(-20.5)
            make.bottom.equalTo(-14).priorityHigh()
        }
        
        linkLeftView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(cardTeacherView.snp_bottom).offset(-26)
            make.size.equalTo(CGSize.init(width: 31.5, height: 62))
        }
        linkRightView.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.top.equalTo(cardTeacherView.snp_bottom).offset(-26)
            make.size.equalTo(CGSize.init(width: 31.5, height: 62))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var model: SLPunchCardModel!
    func setHeaderModel(_ model: SLPunchCardModel){
        self.model = model
        punchCardMainView.setHeaderModel(model)
        cardTeacherView.setViewModel(model)
    }
    
    // MARK: -getter&setter
    
    lazy var headerImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "sl_punchCard_bg"))
        return imageView
    }()
    
    lazy var labelImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "sl_punchCard_midline"))
        return imageView
    }()
    
    
    lazy var cardTeacherView: SLPunchCardTeacherView = {
        let cardTeacherView = SLPunchCardTeacherView()
        cardTeacherView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#ffffff")
        cardTeacherView.layer.cornerRadius = 5
        return cardTeacherView
    }()
    
    lazy var linkLeftView: UIImageView = {
        let linkLeftView = UIImageView.init(image: UIImage.init(named: "sl_punchCard_link"))
        return linkLeftView
    }()
    
    lazy var linkRightView: UIImageView = {
        let linkRightView = UIImageView.init(image: UIImage.init(named: "sl_punchCard_link"))
        return linkRightView
    }()
    
    lazy var punchCardMainView: SLPunchCardMainView = {
        let punchCardMainView = SLPunchCardMainView()
        punchCardMainView.cornerRadius = 4
//        SLPunchCardMainView.clipsToBounds = true
        return punchCardMainView
    }()
}

