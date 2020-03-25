//
//  SLHomeClassStartCell.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/20.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

private let kCommentSectionTag = 101

class SLHomeClassStartCell: SLHomeBaseCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sl_setCellModel(_ model: SLHomeListModel){
        self.model = model
        self.sl_setCellModel(model.classStarModel)
    }
    
    // MARK: -action
    @objc func goRemindClick(){
        MBProgressHUD.sl_showLoading()
        SLEducationTeacherTeacherBaseInfoRequest.init(childrenId: model.childrenId ?? 0, classId: model.classId ?? 0).requestCollection({ (items:[SLClassStartTeacherModel]) in
            MBProgressHUD.sl_hideHUD()
            UIUtil.sl_loadClassStartReminderRequest(teacherLists: items,childrenId: self.model.childrenId ?? 0, classId: self.model.classId ?? 0)
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: -UI
    private func initUI(){
        contentView.addSubview(bgContainView)
        bgContainView.addSubview(tagLabel)
        bgContainView.addSubview(headerImageView)
        headerImageView.addSubview(firstRankView)
        headerImageView.addSubview(secendRankView)
        headerImageView.addSubview(thridRankView)
        bgContainView.addSubview(title)
        bgContainView.addSubview(midBgView)
        midBgView.addSubview(scoreLabel)
        midBgView.addSubview(overLabel)
        midBgView.addSubview(lineView)
        bgContainView.addSubview(lookDetial)
        bgContainView.addSubview(tipsLabel)
        bgContainView.addSubview(goRemindButton)
        bgContainView.addSubview(redView)
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
        headerImageView.snp.makeConstraints { (make) in
            make.top.equalTo(tagLabel.snp_bottom).offset(18.5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(222.5)
        }
        
        firstRankView.snp.makeConstraints { (make) in
            make.top.equalTo(11.5)
            make.centerX.equalTo(self)
        }
        secendRankView.snp.makeConstraints { (make) in
            make.top.equalTo(firstRankView).offset(17)
            make.centerX.equalTo(self).offset(-SCREEN_WIDTH/4)
        }
        thridRankView.snp.makeConstraints { (make) in
            make.top.equalTo(firstRankView).offset(17)
            make.centerX.equalTo(self).offset(SCREEN_WIDTH/4)
        }
        title.snp.makeConstraints { (make) in
            make.top.equalTo(headerImageView.snp_bottom).offset(23)
            make.centerX.equalTo(self)
        }
        midBgView.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp_bottom).offset(22)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        }
        
        scoreLabel.snp.makeConstraints { (make) in
            make.width.equalTo(midBgView).multipliedBy(0.4)
            make.left.top.bottom.equalTo(0)
            make.height.equalTo(30)
        }
        
        overLabel.snp.makeConstraints { (make) in
            make.width.equalTo(midBgView).multipliedBy(0.6)
            make.right.top.bottom.equalTo(0)
            make.height.equalTo(30)
        }
        lineView.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(18.5)
            make.centerY.equalTo(midBgView)
            make.left.equalTo(scoreLabel.snp_right)
        }
        
        redView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(0)
            make.size.equalTo(CGSize.init(width: 26, height: 29))
        }
    }
    
    func sl_setCellModel(_ classStarModel: SLClassStarPartentModel? , dateType: DateType = .W){
        setTagUI("班级之星", backgroundColor: UIColor.sl_hexToAdecimalColor(hex: "#F4E2DF"), textColor: UIColor.sl_hexToAdecimalColor(hex: "#E8534C"))
        title.isHidden = true
        lookDetial.isHidden = true
        tipsLabel.isHidden = true
        goRemindButton.isHidden = true
        redView.isHidden = true
        midBgView.isHidden = true
        
        if let classStarModel = classStarModel{
            
            /// 服务端需要返回
            let stage = SLPersonDataModel.sharePerson.personStage
            firstRankView.setViewModel(classStarModel.mapTop3?.first, classStarModel.currentChildren, index: 1, stage: stage)
            secendRankView.setViewModel(classStarModel.mapTop3?.secend, classStarModel.currentChildren, index: 2, stage: stage)
            thridRankView.setViewModel(classStarModel.mapTop3?.thrid, classStarModel.currentChildren, index: 3, stage: stage)
            
            
            if SLPersonDataModel.sharePerson.personRole == .PARENT,SLLocalMessageHelper.shareHelper.sl_isLocalMessage(serviceId: model.serviceId ?? 1001, childId: model.childrenId ?? 0){
                redView.isHidden = false
            }
            
            if classStarModel.showRemindTeacher{
                tipsLabel.isHidden = false
                goRemindButton.isHidden = false
                midBgView.isHidden = false
                firstRankView.snp.updateConstraints { (make) in
                    make.top.equalTo(34)
                }
                midBgView.snp.remakeConstraints { (make) in
                    make.top.equalTo(headerImageView.snp_bottom).offset(22)
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(44)
                }
                tipsLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(midBgView.snp_bottom).offset(21.5)
                    make.left.equalTo(17)
                    make.right.equalTo(-17)
                }
                goRemindButton.snp.remakeConstraints { (make) in
                    make.top.equalTo(tipsLabel.snp_bottom).offset(27.5)
                    make.bottom.equalTo(-33)
                    make.centerX.equalTo(self)
                    make.size.equalTo(CGSize.init(width: 192, height: 49))
                }
                UIUtil.sl_setLabelAttributed(scoreLabel, text: ["\(NSUtil.sl_getDateText(dateType: dateType))获得", " 暂无"], colors: [UIColor.sl_hexToAdecimalColor(hex: "#575A60"),UIColor.sl_hexToAdecimalColor(hex: "#575A60")], fonts: [UIFont.systemFont(ofSize: 13),UIFont.boldSystemFont(ofSize: 21)])
                UIUtil.sl_setLabelAttributed(overLabel, text: ["超越全班", " 未知 ", "同学"], colors: [UIColor.sl_hexToAdecimalColor(hex: "#575A60"),UIColor.sl_hexToAdecimalColor(hex: "#575A60"),UIColor.sl_hexToAdecimalColor(hex: "#575A60")], fonts: [UIFont.systemFont(ofSize: 14),UIFont.boldSystemFont(ofSize: 21),UIFont.systemFont(ofSize: 14)])
                UIUtil.sl_setLabelAttributed(tipsLabel, text: ["您的孩子\((model.childrenRealName ?? self.sl_user.curruntChild?.realName) ?? "")\(NSUtil.sl_getDateText(dateType: dateType))暂无评价数据，全国已有 ", "200万", "名学生正在使用此功能，班级之星是学生德育培养的重要辅助功能，赶快去提醒老师使用吧！"], colors: [UIColor.sl_hexToAdecimalColor(hex: "#898F9A"),kBlueColor,UIColor.sl_hexToAdecimalColor(hex: "#898F9A")], fonts: nil)
            }else{
                title.isHidden = false
                lookDetial.isHidden = false
                firstRankView.snp.updateConstraints { (make) in
                    make.top.equalTo(11.5)
                }
                var text: String? = nil
                if let currentChildren = classStarModel.currentChildren{
                    if currentChildren.topNo ?? 101 == 1{
                        text = "冠军"
                    }else if currentChildren.topNo ?? 101 == 2{
                        text = "亚军"
                    }else if currentChildren.topNo ?? 101 == 3{
                        text = "季军"
                    }
                    if let text = text{
                        UIUtil.sl_setLabelAttributed(title, text: ["恭喜！\(currentChildren.childrenName ?? "")\(NSUtil.sl_getDateText(dateType: dateType))荣获\(text)", "\n您的孩子\(NSUtil.sl_getDateText(dateType: dateType))在班级表现非常棒"], colors: [kTextMainBodyColor,UIColor.sl_hexToAdecimalColor(hex: "#898F9A")], fonts: [UIFont.boldSystemFont(ofSize: 20),UIFont.boldSystemFont(ofSize: 15)],paragraphLineSpacing: 13)
                    }else{
                        UIUtil.sl_setLabelAttributed(title, text: ["\(self.sl_user.curruntChild?.realName ?? "")\(NSUtil.sl_getDateText(dateType: dateType))暂未上榜，请再接再厉！", "\n你的孩子\(NSUtil.sl_getDateText(dateType: dateType))表现还有进步空间！"], colors: [kTextMainBodyColor,UIColor.sl_hexToAdecimalColor(hex: "#898F9A")], fonts: [UIFont.boldSystemFont(ofSize: 20),UIFont.boldSystemFont(ofSize: 15)],paragraphLineSpacing: 13)
                    }
                    let textString: String = (stage == .KINDERGARTEN) ? "朵" : "分"
                    UIUtil.sl_setLabelAttributed(scoreLabel, text: ["\(NSUtil.sl_getDateText(dateType: dateType))获得", "\(classStarModel.currentChildren?.score ?? 0)", textString], colors: [UIColor.sl_hexToAdecimalColor(hex: "#575A60"),kBlueColor,kBlueColor], fonts: [UIFont.systemFont(ofSize: 13),UIFont.systemFont(ofSize: 21),UIFont.systemFont(ofSize: 14)])
                    UIUtil.sl_setLabelAttributed(overLabel, text: ["超越全班", "\(currentChildren.topPercent ?? "")%", "同学"], colors: [UIColor.sl_hexToAdecimalColor(hex: "#575A60"),kBlueColor,UIColor.sl_hexToAdecimalColor(hex: "#575A60")], fonts: [UIFont.systemFont(ofSize: 14),UIFont.boldSystemFont(ofSize: 21),UIFont.systemFont(ofSize: 14)])
                    
                    midBgView.snp.remakeConstraints { (make) in
                        make.top.equalTo(title.snp_bottom).offset(22)
                        make.left.equalTo(15)
                        make.right.equalTo(-15)
                        make.height.equalTo(44)
                    }
                    midBgView.isHidden = false
                    
                    lookDetial.snp.remakeConstraints { (make) in
                        make.top.equalTo(midBgView.snp_bottom).offset(10)
                        make.left.equalTo(15)
                        make.height.equalTo(23.5)
                        make.bottom.equalTo(-14.5)
                    }
                }else{
                    UIUtil.sl_setLabelAttributed(title, text: ["\((model.childrenRealName ?? self.sl_user.curruntChild?.realName) ?? "")\(NSUtil.sl_getDateText(dateType: dateType))暂未上榜，请再接再厉！", "\n你的孩子\(NSUtil.sl_getDateText(dateType: dateType))表现还有进步空间！"], colors: [kTextMainBodyColor,UIColor.sl_hexToAdecimalColor(hex: "#898F9A")], fonts: [UIFont.boldSystemFont(ofSize: 20),UIFont.boldSystemFont(ofSize: 15)],paragraphLineSpacing: 13)
                    lookDetial.snp.remakeConstraints { (make) in
                        make.top.equalTo(title.snp_bottom).offset(10)
                        make.left.equalTo(15)
                        make.height.equalTo(23.5)
                        make.bottom.equalTo(-14.5)
                    }
                    midBgView.isHidden = true
                }
            }
        }
    }
    
    // MARK: -getter&setter
    
    lazy var headerImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "home_classstar_bg"))
        return imageView
    }()
    lazy var firstRankView: ClassStartPartentRankView = {
        let firstRankView = ClassStartPartentRankView.init(size: CGSize.init(width: 70, height: 70), labelImage: "sl_classstar_partent_frist", labelText: "冠军", borderColor: UIColor.sl_hexToAdecimalColor(hex: "#FFCA28"), isFrist: true)
        return firstRankView
    }()
    lazy var secendRankView: ClassStartPartentRankView = {
        let secendRankView = ClassStartPartentRankView.init(size: CGSize.init(width: 60, height: 60), labelImage: "sl_classstar_partent_secend", labelText: "亚军", borderColor: UIColor.sl_hexToAdecimalColor(hex: "#7567FB"), isFrist: false)
        return secendRankView
    }()
    lazy var thridRankView: ClassStartPartentRankView = {
        let thridRankView = ClassStartPartentRankView.init(size: CGSize.init(width: 60, height: 60), labelImage: "sl_classstar_partent_thrid", labelText: "季军", borderColor: UIColor.sl_hexToAdecimalColor(hex: "#C2EEFC"), isFrist: false)
        return thridRankView
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var midBgView: UIView = {
        let midBgView = UIView()
        midBgView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: UIColor.clear)
        return midBgView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#E6EAF3"), night: kNight2F354B)
        return lineView
    }()
    
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var overLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var lookDetial: SLCustomImageControl = {
        let remaidControl = SLCustomImageControl.init(imageSize: CGSize.init(width: 13.4, height: 13.4), position: SLImagePositionType.right, padding: 9.5)
        remaidControl.font = UIFont.boldSystemFont(ofSize: 15)
        remaidControl.textColor = kBlueColor
        remaidControl.locailImage = "arrow_gray"
        remaidControl.title = "查看详情"
        remaidControl.isUserInteractionEnabled = false
        return remaidControl
    }()
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    
    lazy var goRemindButton: UIButton = {
        let goRemindButton = UIButton()
        goRemindButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        goRemindButton.setTitleColor(UIColor.white, for: .normal)
        goRemindButton.setTitle("一键提醒", for: .normal)
        goRemindButton.cornerRadius = 24.5
        goRemindButton.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: 192, height: 49), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        goRemindButton.sl_shadow(frame: CGRect(x: 0, y: 0, width: 192, height: 49), color: UIColor.sl_hexToAdecimalColor(hex: "#4C74F6"), cornerRadius: 7.5, offset: CGSize(width: 0, height: 3))
        goRemindButton.addTarget(self, action: #selector(goRemindClick), for: .touchUpInside)
        return goRemindButton
    }()
}
