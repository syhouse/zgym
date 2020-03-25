//
//  SLPunchCardSingleStudentListCell.swift
//  ZGYM
//
//  Created by sy_mac on 2020/2/25.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import NightNight

private let maxCount: Int = 9
private let kImageViewTag: Int = 100
class SLPunchCardSingleStudentListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        backgroundColor = UIColor.white
        contentView.addSubview(timeLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(voiceView)
        contentView.addSubview(showAllControl)
        contentView.addSubview(nineMediaView)
        
        contentView.sl_addLine(position: .bottom,mixedBackgroundColor: MixedColor(normal: kLineColor, night: kLineColor))
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(23)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel)
            make.right.equalTo(-15.5)
            make.top.equalTo(timeLabel.snp_bottom).offset(14.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model:PunchCardPublishListModel!
    
    var isLastRow: Bool = false{
        didSet{
        }
    }
    func sl_setCellModel(_ model: PunchCardPublishListModel){
        self.model = model
        
        for index in 0..<maxCount {
            let imageView = viewWithTag(index + kImageViewTag)
            imageView?.snp.removeConstraints()
            imageView?.isHidden = true
        }
        
        timeLabel.text = (model.createTime ?? "").sl_Date().toString(format: DateFormatType.custom("yyyy年MM月dd日"))
        
        var last: UIView = contentLabel
        
        let dic = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        UIUtil.sl_setLabelParagraphText(contentLabel, text: model.content)
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
        }else{
            showAllControl.isHidden = true
            showAllControl.snp.removeConstraints()
        }
        
        if model.hasVoice{
            voiceView.isHidden = false
            let voiceModel = SLVoiceViewModel()
            voiceModel.voiceDuration = model.audioDuration
            voiceModel.voiceUlr = model.audioUrl
            voiceView.model = voiceModel
            voiceView.snp.remakeConstraints { (make) in
                make.top.equalTo(last.snp_bottom).offset(14.5)
                make.left.right.equalTo(contentLabel)
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
    
    
    /// 展开全文
    var cellBlock: (() ->())?
    // MARK: -action
    @objc func showAllClick(){
        model.isShowAll = !model.isShowAll
        showAllControl.isSelected = model.isShowAll
        cellBlock?()
    }
    
    
    // MARK: -getter&setter
    
    lazy var timeLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#575A60")
        return label
    }()
    
    
    lazy var contentLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#575A60")
//        label.font = kTextMainBodyFont
//        label.textColor = kTextMainBodyColor
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
