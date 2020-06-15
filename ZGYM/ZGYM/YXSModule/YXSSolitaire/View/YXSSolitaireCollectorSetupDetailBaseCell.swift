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
    var imageGoDetialBlock: ((()->()))?
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
        
        let imageView = viewWithTag(kImageOrginTag + 2)
        if let imageView = imageView{
            imageView.addSubview(maskImageView)
            maskImageView.snp.makeConstraints { (make) in
                make.edges.equalTo(imageView)
            }
            imageView.addSubview(countLabel)
            countLabel.snp.makeConstraints({ (make) in
                make.center.equalTo(imageView)
            })
        }
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
    
    var medias = [YXSFriendsMediaModel]()
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
            self.medias = medias
            nineMediaView.medias = medias
            countLabel.isHidden = true
            maskImageView.isHidden = true
            if medias.count > 3{
                countLabel.isHidden = false
                maskImageView.isHidden = false
                countLabel.text = "+\(medias.count - 3)"
            }
            
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
        nineMediaView.itemClickBlock = {
            [weak self] (index)in
            guard let strongSelf = self else { return }
            let goDetial = index == 2 && strongSelf.medias.count > 3
            if goDetial{
                strongSelf.imageGoDetialBlock?()
            }else{
                var urls = [URL]()
                var images = [UIImage?]()
                for index in 0..<strongSelf.medias.count{
                    let model = strongSelf.medias[index]
                    if model.type == .serviceImg {
                        if let url = URL.init(string: model.url ?? ""){
                            urls.append(url)
                        }
                    }else{
                        images.append(UIImage.init(named: model.url ?? ""))
                    }
                }
                YXSShowBrowserHelper.showImage(urls: urls, images: images, currentIndex: index)
            }
        }
        return nineMediaView
    }()
    
    lazy var detailLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#696C73"), night: UIColor.yxs_hexToAdecimalColor(hex: "#696C73"))
        return label
    }()
    
    
    lazy var countLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 29)
        label.mixedTextColor = MixedColor(normal: UIColor.white, night: UIColor.white)
        return label
    }()
    
    lazy var maskImageView: UIView = {
        let maskView = UIView()
        maskView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#000000", alpha: 0.3)
        return maskView
    }()
}

//29
