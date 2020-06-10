//
//  YXSScoreLevelChildHeaderView.swift
//  ZGYM
//
//  Created by yihao on 2020/6/8.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation

class YXSScoreLevelChildHeaderView: UIView {
    var contactClickBlock:(() -> ())?
    var detailsModel: YXSScoreDetailsModel?
    
    // MARK: -leftCycle
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
        
        contentView.addSubview(contactBtn)
        contentView.addSubview(headerChildNameLbl)
        contentView.addSubview(headerExmTimeLbl)
        contentView.addSubview(valueLbl)
        contentView.addSubview(titleLbl)
        contentView.addSubview(formTable)
        valueLbl.isHidden = false
        titleLbl.isHidden = false
        formTable.isHidden = false
        var last: UIView
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            contactBtn.isHidden = true
            headerChildNameLbl.isHidden = false
            headerExmTimeLbl.isHidden = false
            contactBtn.snp.removeConstraints()
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
            last = headerExmTimeLbl
        } else {
            contactBtn.isHidden = false
            headerChildNameLbl.isHidden = true
            headerExmTimeLbl.isHidden = true
            contactBtn.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 85, height: 30))
                make.top.equalTo(40)
                make.centerX.equalTo(contentView.snp_centerX)
            }
            headerChildNameLbl.snp.removeConstraints()
            headerExmTimeLbl.snp.removeConstraints()
            last = contactBtn
        }
        valueLbl.snp.makeConstraints { (make) in
            make.top.equalTo(last.snp_bottom).offset(20)
            make.centerX.equalTo(contentView.snp_centerX)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        titleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(valueLbl.snp_bottom).offset(10)
            make.height.equalTo(20)
            make.bottom.equalTo(-15)
        }
        formTable.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(headerExmTimeLbl.snp_bottom).offset(15)
            make.height.equalTo(50)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(isMultiple: Bool) {
        contactBtn.isHidden = true
        headerChildNameLbl.isHidden = true
        headerExmTimeLbl.isHidden = true
        valueLbl.isHidden = true
        titleLbl.isHidden = true
        formTable.isHidden = true
        var last: UIView
        var interval = 5
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            contactBtn.isHidden = true
            headerChildNameLbl.isHidden = false
            headerExmTimeLbl.isHidden = false
            contactBtn.snp.removeConstraints()
            headerChildNameLbl.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(40)
                make.height.equalTo(20)
            }
            headerExmTimeLbl.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(headerChildNameLbl.snp_bottom).offset(4)
                make.height.equalTo(20)
            }
            last = headerExmTimeLbl
        } else {
            contactBtn.isHidden = false
            headerChildNameLbl.isHidden = true
            headerExmTimeLbl.isHidden = true
            contactBtn.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize(width: 85, height: 30))
                make.top.equalTo(40)
                make.centerX.equalTo(contentView.snp_centerX)
            }
            headerChildNameLbl.snp.removeConstraints()
            headerExmTimeLbl.snp.removeConstraints()
            last = contactBtn
            interval = 20
        }
        if isMultiple {
            // 多科
            formTable.isHidden = false
            valueLbl.snp.removeConstraints()
            titleLbl.snp.removeConstraints()
            formTable.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(last.snp_bottom).offset(interval)
                make.height.equalTo(50)
                make.bottom.equalTo(-15)
            }
        } else {
            // 单科
            interval = 20
            valueLbl.isHidden = false
            titleLbl.isHidden = false
            formTable.snp.removeConstraints()
            valueLbl.snp.remakeConstraints { (make) in
                make.top.equalTo(last.snp_bottom).offset(interval)
                make.centerX.equalTo(contentView.snp_centerX)
                make.size.equalTo(CGSize(width: 35, height: 35))
            }
            titleLbl.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(valueLbl.snp_bottom).offset(10)
                make.height.equalTo(20)
                make.bottom.equalTo(-50)
            }
        }
        
        
    }
    
    func setModel(model: YXSScoreDetailsModel) {
        self.detailsModel = model
        avatarImageV.sd_setImage(with: URL(string: model.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            headerChildNameLbl.text = model.childrenName
            if let dateStr = model.creationTime, dateStr.count > 0 {
                headerExmTimeLbl.text =  "考试时间：\(dateStr.yxs_Date().toString(format: .custom("yyyy/MM/dd")))"
            }
            if let list = model.hierarchySubjectsResponseList, list.count > 1 {
                //多科
                self.updateUI(isMultiple: true)
                self.setFormTableData(list: list, isPARENT: true)
            } else {
                //单科或没有数据
                self.updateUI(isMultiple: false)
                valueLbl.text = model.hierarchySubjectsResponseList?.first?.rank
                titleLbl.text = "本次\(model.hierarchySubjectsResponseList?.first?.subjectsName ?? "")得分"
            }
        } else {
            if let list = model.hierarchySubjectsResponseList, list.count > 1 {
                //多科
                self.updateUI(isMultiple: true)
                self.setFormTableData(list: list, isPARENT: false)
            } else {
                //单科或没有数据
                self.updateUI(isMultiple: false)
                valueLbl.text = model.hierarchySubjectsResponseList?.first?.rank
                titleLbl.text = "本次\(model.hierarchySubjectsResponseList?.first?.subjectsName ?? "")得分"
            }
        }
    }
    
    func setFormTableData(list: [YXSScoreChildrenSubjectsModel], isPARENT: Bool) {
        
        var line = 0
        var columns = 0
        var keyArr = [String]()
        var valueArr = [String]()
        for sub in list {
            keyArr.append(sub.subjectsName ?? "")
            valueArr.append(sub.rank ?? "")
        }
        if list.count > 3 {
            line = list.count / 3
            if list.count % 3 > 0 {
                line += 1
            }
            line *= 2
            columns = 3
        } else {
            line = 2
            columns = list.count
        }
        let width = CGFloat(SCREEN_WIDTH - 60.0)
        let height = CGFloat(line * 34)
        var last: UIView = contactBtn
        var interval = 20
        if isPARENT {
            last = headerExmTimeLbl
            interval = 5
        }
        formTable.snp.remakeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(last.snp_bottom).offset(interval)
            make.height.equalTo(height)
            make.bottom.equalTo(-15)
        }
        formTable.wzb_drawList(with: CGRect(x: 0, y: 0, width: width, height: height), line: line, columns: columns, keyDatas: keyArr, valueDatas: valueArr,isLevel: true)
    }
    
    // MARK: - Action
    @objc func contactBtnClick() {
        contactClickBlock?()
    }
    
    // MARK: - getter&stter
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
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#212121")
        return lbl
    }()
    /// 考试时间
    lazy var headerExmTimeLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F99")
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
    
    lazy var valueLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 41)
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#5D87F7")
        return lbl
    }()
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#57595F")
        return lbl
    }()
}
