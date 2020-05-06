//
//  YXSAgendaListCell.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/8.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

class YXSAgendaListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        
        contentView.addSubview(bgContainView)
        bgContainView.addSubview(iconImageView)
        bgContainView.addSubview(titlelabel)
        bgContainView.addSubview(redLabel)
        bgContainView.addSubview(iconImageView)
        bgContainView.addSubview(arrowImage)
        
        bgContainView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0)
        }
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.centerY.equalTo(bgContainView)
            make.size.equalTo(CGSize.init(width: 48, height: 48))
        }
        
        arrowImage.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.size.equalTo(CGSize.init(width: 13.4, height: 13.4))
            make.centerY.equalTo(bgContainView)
        }
        redLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImage.snp_left).offset(-11)
            make.centerY.equalTo(bgContainView)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func yxs_setCellModel(_ model: YXSAgendaListModel){
        iconImageView.image = UIImage.init(named: model.image)
        titlelabel.text = model.title
        
        var rightText = ""
        
        switch model.eventType {
        case .punchCard:
            rightText = YXSPersonDataModel.sharePerson.personRole == .PARENT ? "项待打卡" : "项打卡待查看"
        case .homework:
            rightText = YXSPersonDataModel.sharePerson.personRole == .PARENT ? "项作业待提交" : "份作业待查看"
        case .solitaire:
            rightText = YXSPersonDataModel.sharePerson.personRole == .PARENT ? "项接龙待提交" : "份接龙待查看"
        case .notice:
            rightText = YXSPersonDataModel.sharePerson.personRole == .PARENT ? "项通知待回执" : "份通知回执待查看"
        default:
            break
        }
        
        if model.count > 0{
            redLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNightLightForegroundColor)
            redLabel.text = (model.eventType == .punchCard && YXSPersonDataModel.sharePerson.personRole != .TEACHER) ? "\(model.allCount)\(rightText)" : "\(model.count)\(rightText)"
        }else{
            redLabel.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: kNightLightForegroundColor)
            redLabel.backgroundColor = UIColor.clear
            redLabel.text = "暂无"
        }
        
        titlelabel.snp.remakeConstraints { (make) in
            make.left.equalTo(iconImageView.snp_right).offset(14.5)
            make.centerY.equalTo(bgContainView)
        }
    }
    
    // MARK: -action
    
    
    // MARK: -getter&setter
    lazy var bgContainView: UIView = {
        let bgContainView = UIView()
        bgContainView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        bgContainView.cornerRadius = 4
        return bgContainView
    }()
    
    lazy var titlelabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#222222"), night: kNightLightForegroundColor)
        return label
    }()
    
    lazy var desLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), night: kNightLightForegroundColor)
        return label
    }()
    
    lazy var redLabel: YXSPaddingLabel = {
        let redLabel = YXSPaddingLabel()
        redLabel.font = UIFont.systemFont(ofSize: 14)
        return redLabel
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    lazy var arrowImage: UIImageView = {
        let arrowImage = UIImageView.init(image: UIImage.init(named: "arrow_gray"))
        return arrowImage
    }()
    
}
