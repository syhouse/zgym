//
//  YXSHomePhotoCell.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/17.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import NightNight

class YXSHomePhotoCell: YXSHomeBaseCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc override func longTap(_ longTap: UILongPressGestureRecognizer){
        
    }
    public var headerBlock: ((FriendsCircleHeaderBlockType) -> ())?
    
    override func yxs_setCellModel(_ model: YXSHomeListModel) {
        self.model = model
        redView.isHidden = true
        
        var medias = [YXSFriendsMediaModel]()
        let jsonData:Data = (model.bgUrl ?? "").data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if let array = array as? [Any]{
            for item in array{
                if let imgurl = item as? String{
                    if !imgurl.isEmpty{
                        let meidaModel = YXSFriendsMediaModel(url: imgurl, type: .serviceImg)
                        medias.append(meidaModel)
                    }
                }
            }
        }
        nineMediaView.medias = medias
        countLabel.isHidden = true
        maskImageView.isHidden = true
        if medias.count > 3{
            countLabel.isHidden = false
            maskImageView.isHidden = false
            countLabel.text = "+\(medias.count - 3)"
        }
        
        
        setTagUI("班级相册", backgroundColor: UIColor.yxs_hexToAdecimalColor(hex: "#E1EBFE"), textColor: kBlueColor)
        titleLabel.text = "\(model.teacherName ?? "")发布了班级相册"
        
        UIUtil.yxs_setLabelAttributed(nameTimeLabel, text: ["\(model.teacherName ?? "")", "  |  \(model.createTime?.yxs_Time() ?? "")"], colors: [MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#4B4E54"), night: UIColor.yxs_hexToAdecimalColor(hex: "#4B4E54")),MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))])
        classLabel.text = model.className
        
        ///红点
        if YXSPersonDataModel.sharePerson.personRole == .PARENT,YXSLocalMessageHelper.shareHelper.yxs_isLocalMessage(serviceId: model.serviceId ?? 1001, childId: model.childrenId ?? 0){
            redView.isHidden = false
        }
    }
    
    private func initUI(){
        contentView.addSubview(bgContainView)
        bgContainView.addSubview(nameTimeLabel)
        bgContainView.addSubview(titleLabel)
        bgContainView.addSubview(classLabel)
        
        bgContainView.addSubview(tagLabel)
        
        bgContainView.addSubview(redView)
        bgContainView.addSubview(nineMediaView)
        
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
    
    func layout(){
        bgContainView.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0).priorityHigh()
        }
        
        tagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(19)
            make.height.equalTo(19)
        }
        
        nameTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(tagLabel.snp_right).offset(14)
            make.centerY.equalTo(tagLabel)
        }
        
        redView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(0)
            make.size.equalTo(CGSize.init(width: 26, height: 29))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14.5)
            make.top.equalTo(tagLabel.snp_bottom).offset(14)
            make.right.equalTo(-15)
        }
        
        nineMediaView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(titleLabel.snp_bottom).offset(14)
        }
        classLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14.5)
            make.top.equalTo(nineMediaView.snp_bottom).offset(14)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var nineMediaView: YXSNineMediaView = {
        let nineMediaView = YXSNineMediaView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 0), imageMaxCount: 9)
        nineMediaView.edges = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        nineMediaView.itemClickBlock = {
            [weak self] (_)in
            guard let strongSelf = self else { return }
            strongSelf.cellBlock?(.goPhotoLists)
        }
        nineMediaView.imageMaxCount = 3
        return nineMediaView
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

