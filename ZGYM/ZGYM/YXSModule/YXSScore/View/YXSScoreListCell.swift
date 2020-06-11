//
//  YXSScoreListCell.swift
//  ZGYM
//
//  Created by yihao on 2020/5/26.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import UIKit
import NightNight

class YXSScoreListCell: UITableViewCell {
    var model: YXSScoreListModel = YXSScoreListModel.init(JSON: ["":""])!
    /// cell点击block
    public var cellBlock: ((_ model: YXSScoreListModel) -> ())?
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        contentView.addSubview(bgContainView)
        bgContainView.addSubview(contentLabel)
        bgContainView.addSubview(classLabel)
        bgContainView.addSubview(nameTimeLabel)
        bgContainView.addSubview(visibleView)
        bgContainView.addSubview(readButton)
        layer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layer() {
        bgContainView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(14)
            make.right.equalTo(-15)
            make.bottom.equalTo(0).priorityHigh()
        }
        
        nameTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(bgContainView.snp_centerY)
            make.right.equalTo(-15)
            make.height.equalTo(20)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(nameTimeLabel.snp_top).offset(-10)
            make.right.equalTo(-15)
            make.height.equalTo(20)
        }
        classLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(SCREEN_WIDTH - 60 - 80)
            make.top.equalTo(nameTimeLabel.snp_bottom).offset(10)
        }
        visibleView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(classLabel)
            make.height.equalTo(18)
        }
    }
    
    func setModel(model: YXSScoreListModel) {
        visibleView.isHidden = true
        readButton.isHidden = true
        self.model = model
        contentLabel.text = model.examName
        UIUtil.yxs_setLabelAttributed(nameTimeLabel, text: ["\(model.teacherName ?? "")", "  |  \(model.creationTime?.yxs_Time() ?? "")"], colors: [MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")),MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))])
        classLabel.text = model.className
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            visibleView.locailImage = "visible"
            visibleView.imageSize = CGSize.init(width: 18, height: 18)
            visibleView.isHidden = false
            UIUtil.yxs_setLabelAttributed(visibleView.textLabel, text: [String(model.readNumber ?? 0), "/\(String(model.sumNumber ?? 0))"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), kTextLightColor])
        } else {
            readButton.isHidden = false
            readButton.isEnabled = !(model.isRead ?? false)
            if readButton.isEnabled {
                readButton.mixedBackgroundColor = MixedColor(normal: kRedMainColor, night: kRedMainColor)
                readButton.cornerRadius = 14.5
                readButton.yxs_setIconInLeftWithSpacing(0)
            }else{
                readButton.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: UIColor.clear)
                readButton.cornerRadius = 0
                readButton.yxs_setIconInLeftWithSpacing(7)
            }
            let readButtonSize: CGSize = model.isRead ?? false ? CGSize.init(width: 65, height: 29) : CGSize.init(width: 65, height: 29)
            readButton.snp.remakeConstraints { (make) in
                make.size.equalTo(readButtonSize)
                make.right.equalTo(bgContainView.snp_right).offset(-10)
                make.centerY.equalTo(classLabel)
            }
        }
        
        
    }
    
    @objc func readClick(){
        cellBlock?(model)
    }
    
    // MARK: - getter&setter
    lazy var bgContainView: UIView = {
        let bgContainView = UIView()
        bgContainView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        bgContainView.cornerRadius = 4
        return bgContainView
    }()
    
    lazy var visibleView: YXSCustomImageControl = {
        let visibleView = YXSCustomImageControl.init(imageSize: CGSize.init(width: 18, height: 18), position: YXSImagePositionType.left, padding: 7)
        visibleView.font = UIFont.systemFont(ofSize: 13)
        visibleView.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        visibleView.locailImage = "visible"
        visibleView.isUserInteractionEnabled = false
        return visibleView
    }()
    
    lazy var readButton: YXSButton = {
        let button = YXSButton.init()
        button.setMixedTitleColor(MixedColor(normal: UIColor.white, night: UIColor.white), forState: .normal)
        button.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white), forState: .disabled)
        button.setImage(UIImage.init(named: "has_red"), for: .disabled)
        button.setImage(nil, for: .normal)
        button.setTitle("阅", for: .normal)
        button.setTitle("已阅", for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(readClick), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var nameTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var classLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = kTextMainBodyFont
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.numberOfLines = 1
        return label
    }()
}
