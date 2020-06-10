//
//  YXSScoreParentHeaderView.swift
//  ZGYM
//
//  Created by yihao on 2020/6/1.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight

class YXSScoreParentHeaderView: UIView {
    var contactClickBlock:(() -> ())?
    var detailsModel: YXSScoreDetailsModel?
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        addSubview(contentView)
        addSubview(avatarView)
        
        avatarView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(10)
            make.size.equalTo(CGSize(width: 80, height: 70))
        }
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(avatarView.snp_top).offset(35)
            make.bottom.equalTo(0)
        }
        contentView.addSubview(headerChildNameLbl)
        contentView.addSubview(headerExmTimeLbl)
        contentView.addSubview(headerTitleLbl)
        contentView.addSubview(contactBtn)
        contentView.addSubview(formTable)

        
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            headerTitleLbl.isHidden = true
            contactBtn.isHidden = true
            headerChildNameLbl.isHidden = false
            headerExmTimeLbl.isHidden = false
            headerChildNameLbl.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(40)
                make.height.equalTo(20)
            }
            headerExmTimeLbl.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(headerChildNameLbl.snp_bottom).offset(4)
                make.height.equalTo(20)
            }
            formTable.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(headerExmTimeLbl.snp_bottom).offset(5)
                make.height.equalTo(50)
                make.bottom.equalTo(contentView.snp_bottom).offset(-15)
            }
        } else {
            headerChildNameLbl.isHidden = true
            headerExmTimeLbl.isHidden = true
            headerTitleLbl.isHidden = false
            contactBtn.isHidden = false
            headerTitleLbl.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(40)
                make.size.equalTo(CGSize(width: 110, height: 30))
            }
            contactBtn.snp.makeConstraints { (make) in
                make.right.equalTo(-15)
                make.top.equalTo(headerTitleLbl)
                make.size.equalTo(CGSize(width: 85, height: 30))
            }
            
            formTable.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(contactBtn.snp_bottom).offset(20)
                make.height.equalTo(50)
                make.bottom.equalTo(contentView.snp_bottom).offset(-15)
            }
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model: YXSScoreDetailsModel) {
        self.detailsModel = model
        avatarImageV.sd_setImage(with: URL(string: model.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
        var last: UIView
        var interval = 5
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            headerChildNameLbl.text = model.childrenName
            if let dateStr = model.creationTime, dateStr.count > 0 {
                headerExmTimeLbl.text =  "考试时间：\(dateStr.yxs_Date().toString(format: .custom("yyyy/MM/dd")))"
            }
            last = headerExmTimeLbl
        } else {
            interval = 20
            last = contactBtn
        }
        
        if let list = model.achievementChildrenSubjectsResponseList,list.count > 0 {
            var line = 0
            var columns = 0
            var keyArr = [String]()
            var valueArr = [String]()
            for sub in list {
                keyArr.append(sub.subjectsName ?? "")
                valueArr.append(String(sub.score ?? 0))
            }
            if list.count > 3 {
                line = list.count / 3
                if list.count % 3 > 0 {
                    line += 1
                }
                line *= 2
                columns = 4
            } else {
                line = 2
                columns = list.count + 1
            }
            keyArr.append(model.achievementChildrenSubjectsResponseSum?.subjectsName ?? "")
            valueArr.append(String(model.achievementChildrenSubjectsResponseSum?.score ?? 0))
            let width = CGFloat(SCREEN_WIDTH - 60.0)
            let height = CGFloat(line * 34)
            formTable.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(last.snp_bottom).offset(interval)
                make.height.equalTo(height)
                make.bottom.equalTo(contentView.snp_bottom).offset(-15)
            }
            formTable.wzb_drawList(with: CGRect(x: 0, y: 0, width: width, height: height), line: line, columns: columns, keyDatas: keyArr, valueDatas: valueArr,isLevel: false)
            
        }
    }
    
    
    // MARK: - Action
    @objc func contactBtnClick() {
        contactClickBlock?()
    }
    
    lazy var avatarView: UIView = {
        let view = UIView()
        let backgroundImageV = UIImageView()
        backgroundImageV.image = UIImage.init(named: "yxs_score_avatar_bg")
        view.addSubview(backgroundImageV)
        backgroundImageV.contentMode = .scaleAspectFit
        backgroundImageV.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        view.addSubview(avatarImageV)
        avatarImageV.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(7)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        
        return view
    }()
    
    lazy var avatarImageV: UIImageView = {
        let imgV = UIImageView()
        imgV.layer.cornerRadius = 25
        imgV.layer.masksToBounds = true
        imgV.contentMode = .scaleAspectFit
        imgV.image = kImageUserIconStudentDefualtImage
        return imgV
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var formTable: UIView = {
        let view = UIView()
        return view
    }()
    
    /// 孩子名称
    lazy var headerChildNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#222222")
        return lbl
    }()
    /// 考试时间
    lazy var headerExmTimeLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return lbl
    }()
    
    /// 得分情况标题
    lazy var headerTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        lbl.text = "本次得分情况"
        return lbl
    }()
    
    lazy var contactBtn: UIButton = {
        let button = UIButton.init()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.clipsToBounds = true
        button.setTitle("联系家长", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = kRedMainColor.cgColor
        button.setTitleColor(kRedMainColor, for: .normal)
        button.layer.cornerRadius = 15
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(contactBtnClick), for: .touchUpInside)
        return button
    }()
}
