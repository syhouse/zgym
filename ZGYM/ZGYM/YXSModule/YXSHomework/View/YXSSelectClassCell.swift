//
//  SelectClassCell.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/18.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSSelectClassCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        contentView.addSubview(nameLabel)
        contentView.addSubview(numberLabel)
        contentView.addSubview(selectButton)
        contentView.yxs_addLine(position: .bottom, leftMargin: 14.5)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14.5)
            make.right.equalTo(selectButton.snp_left).offset(-15)
            make.top.equalTo(15)
        }
        numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp_bottom).offset(9)
        }

        selectButton.snp.makeConstraints { (make) in
            make.right.equalTo(-14.5)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 17, height: 17))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model:YXSClassModel!
    
    var isFriendSelectClass: Bool = false
    
    func yxs_setCellModel(_ model: YXSClassModel){
        self.model = model
        nameLabel.text = model.name
        
        selectButton.isSelected = model.isSelect
        numberLabel.text = "成员：\(model.members ?? 0)"
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            numberLabel.isHidden = true
            nameLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(14.5)
                make.centerY.equalTo(contentView)
            }
        }else{
            if isFriendSelectClass{
                numberLabel.isHidden = false
                numberLabel.text = "\(model.realName ?? "")"
            }else{
                numberLabel.isHidden = true
            }
        }

    }
    var cellBlock: ((_ isSelectTeacher: Bool ) ->())?
    // MARK: -action
    @objc func selectClick(){

    }
    
    // MARK: -getter&setter
    lazy var nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4)
        return label
    }()
    
    lazy var numberLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        return label
    }()

    lazy var selectButton: YXSButton = {
        let button = YXSButton.init()
        button.setBackgroundImage(UIImage.init(named: "yxs_class_select"), for: .selected)
        button.setBackgroundImage(UIImage.init(named: "yxs_class_unselect"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()

}
