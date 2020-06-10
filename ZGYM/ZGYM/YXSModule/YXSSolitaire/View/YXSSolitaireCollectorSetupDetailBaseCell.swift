//
//  YXSSolitaireCollectorSetupDetailCell.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/5.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import NightNight

class YXSSolitaireCollectorSetupDetailBaseCell: YXSBaseDetailViewCell {
    var callClickBlock:((_ isChat: Bool)->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(imgAvatar)
        self.contentView.addSubview(lbTitle)
        
        contentView.addSubview(btnChat)
        contentView.addSubview(btnPhone)
        
        contentView.yxs_addLine(position: .bottom)
        contentView.addSubview(nineMediaView)
        contentView.addSubview(detailLabel)
        
        imgAvatar.snp.remakeConstraints({ (make) in
            make.top.equalTo(17)
            make.left.equalTo(15)
            make.width.height.equalTo(40)
        })
        
        lbTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(imgAvatar)
            make.left.equalTo(imgAvatar.snp_right).offset(13)
        })
        
        btnPhone.snp.makeConstraints({ (make) in
            make.centerY.equalTo(imgAvatar)
            make.right.equalTo(-15)
            make.width.height.equalTo(22)
        })
        
        btnChat.snp.makeConstraints({ (make) in
            make.centerY.equalTo(imgAvatar)
            make.right.equalTo(btnPhone.snp_left).offset(-20)
        })
        
        btnPhone.addTarget(self, action: #selector(callUpClick), for: .touchUpInside)
        btnChat.addTarget(self, action: #selector(chatClick), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func callUpClick(){
        callClickBlock?(false)
    }
    
    @objc func chatClick(){
        callClickBlock?(true)
    }
    
    func setCellModel(model: YXSClassMemberModel, type: YXSQuestionType){
        
        nineMediaView.isHidden = true
        detailLabel.isHidden = true
        
        switch type {
        case .image:
            nineMediaView.isHidden = false
            imgAvatar.snp.remakeConstraints({ (make) in
                make.top.equalTo(17)
                make.left.equalTo(15)
                make.width.height.equalTo(40)
            })
            nineMediaView.snp.remakeConstraints({ (make) in
                make.top.equalTo(imgAvatar.snp_bottom).offset(13)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(-17).priorityHigh()
            })
            var medias = [YXSFriendsMediaModel]()
            let imgUrls = (model.option ?? "").components(separatedBy: ",")
            for imgurl in imgUrls{
                if !imgurl.isEmpty{
                    let meidaModel = YXSFriendsMediaModel(url: imgurl, type: .serviceImg)
                    medias.append(meidaModel)
                }
            }
            nineMediaView.medias = medias
        case .gap:
            detailLabel.isHidden = false
            imgAvatar.snp.remakeConstraints({ (make) in
                make.top.equalTo(17)
                make.left.equalTo(15)
                make.width.height.equalTo(40)
            })
            detailLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(imgAvatar.snp_bottom).offset(13)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.bottom.equalTo(-17).priorityHigh()
            })
            detailLabel.text = model.option
        case .single, .checkbox:
            imgAvatar.snp.remakeConstraints({ (make) in
                make.top.equalTo(9.5)
                make.left.equalTo(15)
                make.bottom.equalTo(-9.5)
                make.width.height.equalTo(40)
            })
        }
        
        lbTitle.text = "\(model.realName ?? "")\(model.relationship?.yxs_RelationshipValue() ?? "")"
        imgAvatar.sd_setImage(with: URL(string: model.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
    }
    
    
    lazy var nineMediaView: YXSNineMediaView = {
        let nineMediaView = YXSNineMediaView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0), imageMaxCount: 3)
        nineMediaView.edges = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        return nineMediaView
    }()
    
    lazy var detailLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#696C73"), night: UIColor.yxs_hexToAdecimalColor(hex: "#696C73"))
        return label
    }()
}

