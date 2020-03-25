//
//  FriendsCircleInfoCell.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/17.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

//修改学号
enum FriendsCircleInfoCellType: Int{
    case name
    case studentId
    case exitClass
}

class SLFriendsCircleInfoCellModel: NSObject{
    var leftText: String?
    var canEdit: Bool = false
    var rightText: String?
    var type: FriendsCircleInfoCellType
    init(type: FriendsCircleInfoCellType, leftText: String?,canEdit: Bool,rightText: String?) {
        self.type = type
        self.leftText = leftText
        self.canEdit = canEdit
        self.rightText = rightText
        super.init()
    }
}

class SLFriendsCircleInfoCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(headerImageSection)
        headerImageSection.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellInfo(_ model: SLFriendsCircleInfoCellModel){
        headerImageSection.leftlabel.text = model.leftText
        headerImageSection.rightLabel.text = model.rightText
        switch model.type {
        case .name:
            headerImageSection.changeTypeUI(type: .onlyRightTitle)
        case .studentId:
            if model.canEdit{
                headerImageSection.changeTypeUI(type: .rightTitleAndArrow)
            }else{
                headerImageSection.changeTypeUI(type: .onlyRightTitle)
            }
        case .exitClass:
            headerImageSection.changeTypeUI(type: .onlyArrow)
        }
    }
    
    lazy var headerImageSection: SLCommonSection = {
        let section = SLCommonSection.init(type: SLCommonSectionType.onlyRightImage)
        section.leftlabel.text = "头像"
        section.isUserInteractionEnabled = false
        return section
    }()
    
}
