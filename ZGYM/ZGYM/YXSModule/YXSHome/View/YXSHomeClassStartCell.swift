//
//  SLHomeClassStartCell.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/20.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

private let kCommentSectionTag = 101

class YXSHomeClassStartCell: YXSHomeBaseCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func yxs_setCellModel(_ model: YXSHomeListModel){
        self.model = model
        self.yxs_setCellModel(model.classStarModel)
    }
    
    // MARK: -action
    @objc func goRemindClick(){
        MBProgressHUD.yxs_showLoading()
        YXSEducationTeacherTeacherBaseInfoRequest.init(childrenId: model.childrenId ?? 0, classId: model.classId ?? 0).requestCollection({ (items:[YXSClassStartTeacherModel]) in
            MBProgressHUD.yxs_hideHUD()
            UIUtil.yxs_loadClassStartReminderRequest(teacherLists: items,childrenId: self.model.childrenId ?? 0, classId: self.model.classId ?? 0)
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: -UI
    private func initUI(){
        contentView.addSubview(bgContainView)
        bgContainView.addSubview(tagLabel)
        bgContainView.addSubview(yxs_headerImageView)
        yxs_headerImageView.addSubview(yxs_firstRankView)
        yxs_headerImageView.addSubview(yxs_secendRankView)
        yxs_headerImageView.addSubview(yxs_thridRankView)
        bgContainView.addSubview(yxs_title)
        bgContainView.addSubview(yxs_midBgView)
        yxs_midBgView.addSubview(yxs_scoreLabel)
        yxs_midBgView.addSubview(yxs_overLabel)
        yxs_midBgView.addSubview(yxs_lineView)
        bgContainView.addSubview(yxs_lookDetial)
        bgContainView.addSubview(yxs_tipsLabel)
        bgContainView.addSubview(yxs_goRemindButton)
        bgContainView.addSubview(redView)
    }
    
    func layout(){
        bgContainView.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.left.equalTo(15).priorityHigh()
            make.right.equalTo(-15).priorityHigh()
            make.bottom.equalTo(0).priorityHigh()
        }
        
        tagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(19)
            make.height.equalTo(19)
        }
        yxs_headerImageView.snp.makeConstraints { (make) in
            make.top.equalTo(tagLabel.snp_bottom).offset(18.5)
            make.left.equalTo(15).priorityHigh()
            make.right.equalTo(-15).priorityHigh()
            make.height.equalTo(222.5)
        }
        
        yxs_firstRankView.snp.makeConstraints { (make) in
            make.top.equalTo(11.5)
            make.centerX.equalTo(self)
        }
        yxs_secendRankView.snp.makeConstraints { (make) in
            make.top.equalTo(yxs_firstRankView).offset(17)
            make.centerX.equalTo(self).offset(-SCREEN_WIDTH/4)
        }
        yxs_thridRankView.snp.makeConstraints { (make) in
            make.top.equalTo(yxs_firstRankView).offset(17)
            make.centerX.equalTo(self).offset(SCREEN_WIDTH/4)
        }
        yxs_title.snp.makeConstraints { (make) in
            make.top.equalTo(yxs_headerImageView.snp_bottom).offset(23)
            make.centerX.equalTo(self)
        }
        yxs_midBgView.snp.makeConstraints { (make) in
            make.top.equalTo(yxs_title.snp_bottom).offset(22)
            make.left.equalTo(15).priorityHigh()
            make.right.equalTo(-15).priorityHigh()
            make.height.equalTo(44).priorityHigh()
        }
        
        yxs_scoreLabel.snp.makeConstraints { (make) in
            make.width.equalTo(yxs_midBgView).multipliedBy(0.4)
            make.left.top.bottom.equalTo(0)
            make.height.equalTo(30).priorityHigh()
        }
        
        yxs_overLabel.snp.makeConstraints { (make) in
            make.width.equalTo(yxs_midBgView).multipliedBy(0.6)
            make.right.top.bottom.equalTo(0)
            make.height.equalTo(30).priorityHigh()
        }
        yxs_lineView.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(18.5)
            make.centerY.equalTo(yxs_midBgView)
            make.left.equalTo(yxs_scoreLabel.snp_right)
        }
        
        redView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(0)
            make.size.equalTo(CGSize.init(width: 26, height: 29))
        }
    }
    
    func yxs_setCellModel(_ classStarModel: YXSClassStarPartentModel? , dateType: DateType = .W){
        setTagUI("班级之星", backgroundColor: UIColor.yxs_hexToAdecimalColor(hex: "#F4E2DF"), textColor: UIColor.yxs_hexToAdecimalColor(hex: "#E8534C"))
        yxs_title.isHidden = true
        yxs_lookDetial.isHidden = true
        yxs_tipsLabel.isHidden = true
        yxs_goRemindButton.isHidden = true
        redView.isHidden = true
        yxs_midBgView.isHidden = true
        
        if let classStarModel = classStarModel{
            /// 服务端需要返回
            let stage = YXSPersonDataModel.sharePerson.personStage
            yxs_firstRankView.setViewModel(classStarModel.mapTop3?.first, classStarModel.currentChildren, index: 1, stage: stage)
            yxs_secendRankView.setViewModel(classStarModel.mapTop3?.secend, classStarModel.currentChildren, index: 2, stage: stage)
            yxs_thridRankView.setViewModel(classStarModel.mapTop3?.thrid, classStarModel.currentChildren, index: 3, stage: stage)
            
            if YXSPersonDataModel.sharePerson.personRole == .PARENT,YXSLocalMessageHelper.shareHelper.yxs_isLocalMessage(serviceId: model.serviceId ?? 1001, childId: model.childrenId ?? 0){
                redView.isHidden = false
            }
            
            if classStarModel.showRemindTeacher{
                yxs_tipsLabel.isHidden = false
                yxs_goRemindButton.isHidden = false
                yxs_midBgView.isHidden = false
                yxs_firstRankView.snp.updateConstraints { (make) in
                    make.top.equalTo(34)
                }
                yxs_midBgView.snp.remakeConstraints { (make) in
                    make.top.equalTo(yxs_headerImageView.snp_bottom).offset(22)
                    make.left.equalTo(15).priorityHigh()
                    make.right.equalTo(-15).priorityHigh()
                    make.height.equalTo(44).priorityHigh()
                }
                yxs_tipsLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(yxs_midBgView.snp_bottom).offset(21.5)
                    make.left.equalTo(17)
                    make.right.equalTo(-17)
                }
                yxs_goRemindButton.snp.remakeConstraints { (make) in
                    make.top.equalTo(yxs_tipsLabel.snp_bottom).offset(27.5)
                    make.centerX.equalTo(self)
                    make.size.equalTo(CGSize.init(width: 192, height: 49))
                }
                UIUtil.yxs_setLabelAttributed(yxs_scoreLabel, text: ["\(NSUtil.yxs_getDateText(dateType: dateType))获得", " 暂无"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#575A60"),UIColor.yxs_hexToAdecimalColor(hex: "#575A60")], fonts: [UIFont.systemFont(ofSize: 13),UIFont.boldSystemFont(ofSize: 21)])
                UIUtil.yxs_setLabelAttributed(yxs_overLabel, text: ["超越全班", " 未知 ", "同学"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#575A60"),UIColor.yxs_hexToAdecimalColor(hex: "#575A60"),UIColor.yxs_hexToAdecimalColor(hex: "#575A60")], fonts: [UIFont.systemFont(ofSize: 14),UIFont.boldSystemFont(ofSize: 21),UIFont.systemFont(ofSize: 14)])
                UIUtil.yxs_setLabelAttributed(yxs_tipsLabel, text: ["您的孩子\((model.childrenRealName ?? self.yxs_user.curruntChild?.realName) ?? "")\(NSUtil.yxs_getDateText(dateType: dateType))暂无评价数据，全国已有 ", "200万", "名学生正在使用此功能，班级之星是学生德育培养的重要辅助功能，赶快去提醒老师使用吧！"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"),kRedMainColor,UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")], fonts: nil)
            }else{
                yxs_title.isHidden = false
                yxs_lookDetial.isHidden = false
                yxs_firstRankView.snp.updateConstraints { (make) in
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
                        UIUtil.yxs_setLabelAttributed(yxs_title, text: ["恭喜！\(currentChildren.childrenName ?? "")\(NSUtil.yxs_getDateText(dateType: dateType))荣获\(text)", "\n您的孩子\(NSUtil.yxs_getDateText(dateType: dateType))在班级表现非常棒"], colors: [kTextMainBodyColor,UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")], fonts: [UIFont.boldSystemFont(ofSize: 20),UIFont.boldSystemFont(ofSize: 15)],paragraphLineSpacing: 13)
                    }else{
                        UIUtil.yxs_setLabelAttributed(yxs_title, text: ["\(self.yxs_user.curruntChild?.realName ?? "")\(NSUtil.yxs_getDateText(dateType: dateType))暂未上榜，请再接再厉！", "\n你的孩子\(NSUtil.yxs_getDateText(dateType: dateType))表现还有进步空间！"], colors: [kTextMainBodyColor,UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")], fonts: [UIFont.boldSystemFont(ofSize: 20),UIFont.boldSystemFont(ofSize: 15)],paragraphLineSpacing: 13)
                    }
                    let textString: String = (stage == .KINDERGARTEN) ? "朵" : "分"
                    UIUtil.yxs_setLabelAttributed(yxs_scoreLabel, text: ["\(NSUtil.yxs_getDateText(dateType: dateType))获得", "\(classStarModel.currentChildren?.score ?? 0)", textString], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#575A60"),kRedMainColor,kRedMainColor], fonts: [UIFont.systemFont(ofSize: 13),UIFont.systemFont(ofSize: 21),UIFont.systemFont(ofSize: 14)])
                    UIUtil.yxs_setLabelAttributed(yxs_overLabel, text: ["超越全班", "\(currentChildren.topPercent ?? "")%", "同学"], colors: [UIColor.yxs_hexToAdecimalColor(hex: "#575A60"),kRedMainColor,UIColor.yxs_hexToAdecimalColor(hex: "#575A60")], fonts: [UIFont.systemFont(ofSize: 14),UIFont.boldSystemFont(ofSize: 21),UIFont.systemFont(ofSize: 14)])
                    
                    yxs_midBgView.snp.remakeConstraints { (make) in
                        make.top.equalTo(yxs_title.snp_bottom).offset(22)
                        make.left.equalTo(15)
                        make.right.equalTo(-15)
                        make.height.equalTo(44)
                    }
                    yxs_midBgView.isHidden = false
                    
                    yxs_lookDetial.snp.remakeConstraints { (make) in
                        make.top.equalTo(yxs_midBgView.snp_bottom).offset(10)
                        make.left.equalTo(15)
                        make.height.equalTo(23.5)
                    }
                }else{
                    UIUtil.yxs_setLabelAttributed(yxs_title, text: ["\((model.childrenRealName ?? self.yxs_user.curruntChild?.realName) ?? "")\(NSUtil.yxs_getDateText(dateType: dateType))暂未上榜，请再接再厉！", "\n你的孩子\(NSUtil.yxs_getDateText(dateType: dateType))表现还有进步空间！"], colors: [kTextMainBodyColor,UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")], fonts: [UIFont.boldSystemFont(ofSize: 20),UIFont.boldSystemFont(ofSize: 15)],paragraphLineSpacing: 13)
                    yxs_lookDetial.snp.remakeConstraints { (make) in
                        make.top.equalTo(yxs_title.snp_bottom).offset(10)
                        make.left.equalTo(15)
                        make.height.equalTo(23.5)
                    }
                    yxs_midBgView.isHidden = true
                }
            }
        }
    }
    
    // MARK: -getter&setter
    
    lazy var yxs_headerImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "home_classstar_bg"))
        return imageView
    }()
    lazy var yxs_firstRankView: ClassStartPartentRankView = {
        let yxs_firstRankView = ClassStartPartentRankView.init(size: CGSize.init(width: 70, height: 70), labelImage: "yxs_classstar_partent_frist", labelText: "冠军", borderColor: UIColor.yxs_hexToAdecimalColor(hex: "#FFCA28"), isFrist: true)
        return yxs_firstRankView
    }()
    lazy var yxs_secendRankView: ClassStartPartentRankView = {
        let yxs_secendRankView = ClassStartPartentRankView.init(size: CGSize.init(width: 60, height: 60), labelImage: "yxs_classstar_partent_secend", labelText: "亚军", borderColor: UIColor.yxs_hexToAdecimalColor(hex: "#7567FB"), isFrist: false)
        return yxs_secendRankView
    }()
    lazy var yxs_thridRankView: ClassStartPartentRankView = {
        let yxs_thridRankView = ClassStartPartentRankView.init(size: CGSize.init(width: 60, height: 60), labelImage: "yxs_classstar_partent_thrid", labelText: "季军", borderColor: UIColor.yxs_hexToAdecimalColor(hex: "#C2EEFC"), isFrist: false)
        return yxs_thridRankView
    }()
    
    lazy var yxs_title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var yxs_midBgView: UIView = {
        let yxs_midBgView = UIView()
        yxs_midBgView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: UIColor.clear)
        return yxs_midBgView
    }()
    
    lazy var yxs_lineView: UIView = {
        let yxs_lineView = UIView()
        yxs_lineView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), night: kNight2F354B)
        return yxs_lineView
    }()
    
    lazy var yxs_scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var yxs_overLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var yxs_lookDetial: YXSCustomImageControl = {
        let remaidControl = YXSCustomImageControl.init(imageSize: CGSize.init(width: 13.4, height: 13.4), position: YXSImagePositionType.right, padding: 9.5)
        remaidControl.font = UIFont.boldSystemFont(ofSize: 15)
        remaidControl.textColor = kRedMainColor
        remaidControl.locailImage = "arrow_gray"
        remaidControl.title = "查看详情"
        remaidControl.isUserInteractionEnabled = false
        return remaidControl
    }()
    
    lazy var yxs_tipsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    
    lazy var yxs_goRemindButton: UIButton = {
        let yxs_goRemindButton = UIButton()
        yxs_goRemindButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        yxs_goRemindButton.setTitleColor(UIColor.white, for: .normal)
        yxs_goRemindButton.setTitle("一键提醒", for: .normal)
        yxs_goRemindButton.cornerRadius = 24.5
        yxs_goRemindButton.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 192, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        yxs_goRemindButton.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 192, height: 49), color: UIColor.yxs_hexToAdecimalColor(hex: "#4C74F6"), cornerRadius: 7.5, offset: CGSize(width: 0, height: 3))
        yxs_goRemindButton.addTarget(self, action: #selector(goRemindClick), for: .touchUpInside)
        return yxs_goRemindButton
    }()
}
