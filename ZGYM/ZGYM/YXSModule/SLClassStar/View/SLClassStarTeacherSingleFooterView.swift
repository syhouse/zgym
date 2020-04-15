//
//  SLClassStarTeacherSingleFooterView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/5.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

let KClassStarTeacherSingleFooterCommentEvent = "ClassStarTeacherSingleFooterCommentEvent"

class SLClassStarTeacherSingleFooterView: UITableViewHeaderFooterView {
    var showComment: Bool = false{
        didSet{
            if showComment{
                bgView.snp.remakeConstraints { (make) in
                    make.left.equalTo(20.5)
                    make.right.equalTo(-20.5)
                    make.top.equalTo(0)
                    make.bottom.equalTo(-15)
                }
                bgView.isHidden = false
            }else{
                bgView.snp.removeConstraints()
                bgView.isHidden = true
            }
        }
    }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(bgView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(commentLabel)
        bgView.addSubview(goCommontButton)
        contentView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#D2E4FF")
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.centerX.equalTo(bgView)
        }
        commentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(22)
            make.left.equalTo(32)
            make.right.equalTo(-32)
        }
        goCommontButton.snp.makeConstraints { (make) in
            make.top.equalTo(commentLabel.snp_bottom).offset(25.5)
            make.bottom.equalTo(-56)
            make.centerX.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 192, height: 49))
        }
        bgView.yxs_addLine(position: .bottom,leftMargin: 15.5, rightMargin: 15.5)
    }
    
    func setFooterModel(_ model: SLClassStartClassModel?){
        if let model = model{
            titleLabel.text = "\(model.dateText)暂无点评"
            UIUtil.yxs_setLabelAttributed(commentLabel, text: ["全国已有", "200万", "名学生正在使用此功能，班级之星是学生德育培养的重要辅助功能，亲爱的老师赶快去使用吧！"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#BABDC2"),kBlueColor, UIColor.yxs_hexToAdecimalColor(hex: "#BABDC2")])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func goCommont(){
        next?.yxs_routerEventWithName(eventName: KClassStarTeacherSingleFooterCommentEvent)
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        bgView.cornerRadius = 5
        return bgView
    }()
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#6A6C71")
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var commentLabel: YXSLabel = {
        let label = YXSLabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#6A6C71")
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var goCommontButton: YXSButton = {
        let goCommontButton = YXSButton()
        goCommontButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        goCommontButton.setTitleColor(UIColor.white, for: .normal)
        goCommontButton.setTitle("马上点评", for: .normal)
        goCommontButton.cornerRadius = 24.5
        goCommontButton.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 192, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        goCommontButton.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 192, height: 49), color: UIColor.yxs_hexToAdecimalColor(hex: "#4C74F6"), cornerRadius: 7.5, offset: CGSize(width: 0, height: 3))
        goCommontButton.addTarget(self, action: #selector(goCommont), for: .touchUpInside)
        return goCommontButton
    }()
}
