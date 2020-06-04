//
//  YXSScoreTeacherCommentView.swift
//  ZGYM
//
//  Created by yihao on 2020/6/3.
//  Copyright © 2020 zgym. All rights reserved.
//  老师评语视图

import Foundation

class YXSScoreTeacherCommentView: UIView {
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        initUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        addSubview(contentView)
        contentView.addSubview(titleLbl)
        contentView.addSubview(contactBtn)
        contentView.addSubview(contentLbl)
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        titleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(30)
            make.size.equalTo(CGSize(width: 70, height: 17))
        }
        contactBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.size.equalTo(CGSize(width: 85, height: 30))
            make.centerY.equalTo(titleLbl.snp_centerY)
        }
        contentLbl.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(contactBtn.snp_bottom).offset(15)
            make.height.equalTo(50)
            make.bottom.equalTo(-25)
        }
        
    }
    
    // MARK: - Action
    @objc func contactBtnClick() {
        
    }
    
    // MARK: - getter&stter
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "老师评语"
        lbl.textColor = kTextMainBodyColor //UIFont.boldSystemFont(ofSize: 15)
        lbl.font = UIFont.systemFont(ofSize: 17)
        return lbl
    }()
    
    lazy var contactBtn: UIButton = {
        let button = UIButton.init()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.clipsToBounds = true
        button.setTitle("联系老师", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = kRedMainColor.cgColor
        button.setTitleColor(kRedMainColor, for: .normal)
        button.layer.cornerRadius = 15
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(contactBtnClick), for: .touchUpInside)
        return button
    }()
    
    lazy var contentLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        lbl.font = UIFont.systemFont(ofSize: 16)
        return lbl
    }()
}
