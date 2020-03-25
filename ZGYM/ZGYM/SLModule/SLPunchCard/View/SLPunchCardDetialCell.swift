//
//  SLPunchCardDetialCell.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/28.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

private let maxCount: Int = 9
private let kImageViewTag: Int = 100
class SLPunchCardDetialCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#AACCFF")
        contentView.addSubview(bgView)
        bgView.addSubview(userIcon)
        bgView.addSubview(nameLabel)
        bgView.addSubview(timeLabel)
        bgView.addSubview(contentLabel)
        bgView.addSubview(voiceView)
        bgView.addSubview(showAllControl)
        bgView.addSubview(nineMediaView)
        bgView.sl_addLine(position: .bottom, leftMargin: 15.5,rightMargin: 15.5)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(20.5)
            make.right.equalTo(-20.5)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        userIcon.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 41, height: 41))
            make.left.equalTo(15.5)
            make.top.equalTo(19)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userIcon.snp_right).offset(13)
            make.top.equalTo(userIcon).offset(4)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp_bottom).offset(6)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userIcon)
            make.right.equalTo(-15.5)
            make.top.equalTo(userIcon.snp_bottom).offset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model:PunchCardPublishListModel!
    
    var isLastRow: Bool = false{
        didSet{
            if isLastRow{
                bgView.sl_addRoundedCorners(corners: [.bottomLeft,.bottomRight], radii: CGSize.init(width: 4, height: 4), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 3000))
            }else{
                bgView.sl_addRoundedCorners(corners: [.bottomLeft,.bottomRight], radii: CGSize.init(width: 0, height: 0), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 3000))
            }
        }
    }
    func sl_setCellModel(_ model: PunchCardPublishListModel){
        self.model = model
        
        for index in 0..<maxCount {
            let imageView = viewWithTag(index + kImageViewTag)
            imageView?.snp.removeConstraints()
            imageView?.isHidden = true
        }
        
        nameLabel.text = "\(model.realName ?? "")\((model.relationship ?? "").sl_RelationshipValue())"
        timeLabel.text = (model.createTime ?? "").sl_Time()
        userIcon.sd_setImage(with: URL.init(string: model.avatar ?? ""),placeholderImage: kImageUserIconStudentDefualtImage, completed: nil)
        
        var last: UIView = contentLabel
        
        let dic = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        UIUtil.sl_setLabelParagraphText(contentLabel, text: model.content,removeSpace:  !model.isShowAll)
        let height = UIUtil.sl_getTextHeigh(textStr: model.content ?? "", attributes: dic , width: SCREEN_WIDTH - 41 - 30)
        contentLabel.numberOfLines = model.isShowAll ? 0 : 3
        //需要展示多行
        let showMore = height > 45
        if showMore{
            last = showAllControl
            showAllControl.isHidden = false
            showAllControl.isSelected = model.isShowAll
            showAllControl.snp.remakeConstraints { (make) in
                make.left.equalTo(contentLabel)
                make.height.equalTo(26)
                make.top.equalTo(contentLabel.snp_bottom).offset(10)
            }
            contentLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(userIcon)
                make.right.equalTo(-15.5)
                make.top.equalTo(userIcon.snp_bottom).offset(15)
            }
        }else{
            showAllControl.isHidden = true
            showAllControl.snp.removeConstraints()
            contentLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(userIcon)
                make.top.equalTo(userIcon.snp_bottom).offset(15)
            }
            contentLabel.sizeToFit()
        }
        
        if model.hasVoice{
            voiceView.isHidden = false
            let voiceModel = SLVoiceViewModel()
            voiceModel.voiceDuration = model.audioDuration
            voiceModel.voiceUlr = model.audioUrl
            voiceView.model = voiceModel
            voiceView.snp.remakeConstraints { (make) in
                make.top.equalTo(last.snp_bottom).offset(14.5)
                make.left.equalTo(contentLabel)
                make.right.equalTo(-15.5)
                make.height.equalTo(36)
            }
            last = voiceView
        }else{
            voiceView.isHidden = true
        }
        nineMediaView.medias = model.medias
        nineMediaView.snp.remakeConstraints { (make) in
            make.top.equalTo(last.snp_bottom).offset(15)
            make.right.left.equalTo(0)
            make.bottom.equalTo(-19).priorityHigh()
        }
    }
    
    var cellBlock: (() ->())?
    // MARK: -action
    @objc func showAllClick(){
        model.isShowAll = !model.isShowAll
        showAllControl.isSelected = model.isShowAll
        cellBlock?()
    }
    
    
    // MARK: -getter&setter
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    lazy var userIcon: UIImageView = {
        let userIcon = UIImageView.init(image: kImageUserIconStudentDefualtImage)
        userIcon.cornerRadius = 20.5
        userIcon.contentMode = .scaleAspectFill
        return userIcon
    }()
    
    lazy var nameLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#575A60")
        return label
    }()
    
    lazy var timeLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#898F9A")
        return label
    }()
    
    
    lazy var contentLabel: SLEventCopyLabel = {
        let label = SLEventCopyLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#575A60")
        label.numberOfLines = 3
        return label
    }()
    
    lazy var showAllControl: SLCustomImageControl = {
        let showAllControl = SLCustomImageControl.init(imageSize: CGSize.init(width: 14, height: 14), position: SLImagePositionType.right, padding: 5.5)
        showAllControl.setTitleColor(kBlueColor, for: .normal)
        showAllControl.setTitle("查看全文", for: .normal)
        showAllControl.setTitleColor(kBlueColor, for: .selected)
        showAllControl.setTitle("收起", for: .selected)
        showAllControl.font = UIFont.boldSystemFont(ofSize: 14)
        showAllControl.setImage(UIImage.init(named: "down_gray"), for: .normal)
        showAllControl.setImage(UIImage.init(named: "up_gray"), for: .selected)
        showAllControl.addTarget(self, action: #selector(showAllClick), for: .touchUpInside)
        showAllControl.isSelected = false
        return showAllControl
    }()
    
    lazy var voiceView: SLVoiceView = {
        let voiceView = SLVoiceView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 30 - 41, height: 36), complete: {
            [weak self] (url, duration)in
            guard let strongSelf = self else { return }
        })
        voiceView.minWidth = 120
        return voiceView
    }()
    
    lazy var nineMediaView: HMNineMediaView = {
        let nineMediaView = HMNineMediaView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 0))
        nineMediaView.edges = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        nineMediaView.padding = 10
        return nineMediaView
    }()
}
