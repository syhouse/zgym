//
//  YXSMineHeaderView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/5.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
import SDWebImage

class YXSMineHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUIForTtransition()
        layoutForTransition()
        
//        createUI()
//        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func createUIForTtransition() {
//        self.addSubview(imgBG)
        self.addSubview(panelView)
        panelView.addSubview(btnEdit)
        namePanelView.addSubview(lbName)
        namePanelView.addSubview(btnTag)
        panelView.addSubview(namePanelView)
        panelView.addSubview(lbSubTitle)
        
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            panelView.addSubview(btnAvatar)

        } else {
            panelView.addSubview(imgStackingView)
        }
    }
    
    func layoutForTransition() {
        panelView.snp.makeConstraints({ (make) in
            make.top.equalTo(44+kSafeTopHeight)
            make.centerX.equalTo(snp_centerX)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0)
        })
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            btnAvatar.snp.makeConstraints({ (make) in
                make.top.equalTo(5)
                make.left.equalTo(1)
                make.width.height.equalTo(60)
                make.bottom.equalTo(-24)
            })

            namePanelView.snp.makeConstraints({ (make) in
                make.left.equalTo(btnAvatar.snp_right).offset(10)
                make.top.equalTo(btnAvatar.snp_top).offset(10)
            })

        } else {
            
            namePanelView.snp.makeConstraints({ (make) in
                make.top.equalTo(5)
                make.left.equalTo(1)
            })
            
            imgStackingView.snp.makeConstraints({ (make) in
                make.top.equalTo(namePanelView.snp_bottom).offset(10)
                make.left.equalTo(1)
                make.bottom.equalTo(-24)
            })
        }
        
        btnEdit.snp.makeConstraints({ (make) in
            make.centerY.equalTo(lbSubTitle.snp_centerY)
            make.right.equalTo(0)
            make.width.equalTo(75)
            make.height.equalTo(24)
        })


        lbName.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(22)
        })

        btnTag.snp.makeConstraints({ (make) in
            make.centerY.equalTo(namePanelView.snp_centerY)
            make.left.equalTo(lbName.snp_right).offset(11)
            make.width.equalTo(43)
            make.height.equalTo(20)
            make.right.equalTo(0)
        })

        


        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            
            lbSubTitle.snp.makeConstraints({ (make) in
                make.top.equalTo(namePanelView.snp_bottom).offset(6)
                make.left.equalTo(namePanelView.snp_left)
                make.centerX.equalTo(panelView.snp_centerX)
            })

        } else {
            
            lbSubTitle.snp.makeConstraints({ (make) in
                make.top.equalTo(namePanelView.snp_bottom).offset(10)
                make.left.equalTo(imgStackingView.snp_right).offset(6)
                make.centerY.equalTo(imgStackingView.snp_centerY)
                make.height.equalTo(36)
            })
        }
    }
    
    
    @objc func createUI() {
        
    }
    
    @objc func layout() {
        
    }
    
    func refreshData() {
        btnAvatar.yxs_setImage(with: URL(string: self.yxs_user.avatar ?? ""), for: .normal, placeholderImage: kImageUserIconTeacherDefualtMixedImage)
        btnAvatar.yxs_setImage(with: URL(string: self.yxs_user.avatar ?? ""), for: .highlighted, placeholderImage: kImageUserIconTeacherDefualtMixedImage)
        lbName.text = self.yxs_user.name ?? ""
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            lbSubTitle.text = self.yxs_user.school ?? "暂无学校"
        } else {
            if (self.yxs_user.children?.count ?? 0) > 0 {
                lbSubTitle.text = "共\((self.yxs_user.children?.count ?? 0))个孩子"
            } else {
                lbSubTitle.text = "共0个孩子"
            }
            
            /// 刷新孩子头像个数
            var arr: [String] = [String]()
            for index in 0..<(self.yxs_user.children ?? [YXSChildrenModel]()).count{
                arr.append(self.yxs_user.children![index].avatar ?? "")
            }
            self.imgStackingView.imagesUrl = arr
        }
        
    }
    // MARK: - Setter
//    var model: UserInfoModel? {
//        didSet {
//            self.yxs_user
//        }
//    }
    
    // MARK: - LazyLoad
//    lazy var imgBG: UIImageView = {
//        let img = UIImageView()
//        img.mixedImage = MixedImage(normal: "yxs_mine_header_bg", night: "yxs_mine_header_bg_night")
//        return img
//    }()
    
    lazy var panelView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        
//        view.backgroundColor = UIColor.yellow
//        view.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-30, height: (SCREEN_WIDTH-30)*70/345), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#000000"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#000000"), cornerRadius: 5)
//        view.yxs_shadow(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-30, height: (SCREEN_WIDTH-30)*70/345), color: UIColor.yxs_hexToAdecimalColor(hex: "#181A23"), cornerRadius: 5, offset: CGSize(width: 0, height: 2))
        return view
    }()
    
    
    lazy var btnAvatar: YXSButton = {
        let btn = YXSButton()
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            btn.setImage(kImageUserIconTeacherDefualtImage, for: .normal)
        } else {
            btn.setImage(kImageUserIconStudentDefualtImage, for: .normal)
        }
        btn.imageView?.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        btn.cornerRadius = 30
        return btn
    }()
    
    lazy var btnEdit: YXSButton = {
        let btn = YXSButton()
//        btn.setImage(UIImage(named: "yxs_mine_edit"), for: .normal)
        btn.setTitle("编辑信息", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF"), night: kNight5E88F7), forState: .normal)
        btn.borderColor = UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF")
        btn.borderWidth = 0.5
        btn.cornerRadius = 12
        return btn
    }()
    
        
    lazy var namePanelView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var lbName: YXSLabel = {
        let lb = YXSLabel()
        lb.text = self.yxs_user.name ?? ""//"张山老师"
        lb.font = UIFont.systemFont(ofSize: 19)
        lb.mixedTextColor = MixedColor(normal: 0xFFFFFF, night: 0xFFFFFF)
        return lb
    }()
    
    lazy var btnTag: YXSButton = {
        let btn = YXSButton()
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            btn.setTitle("老师", for: .normal)
        } else {
            btn.setTitle("家长", for: .normal)
        }
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#FFFFFF", alpha: 0.3)
//        btn.mixedBackgroundColor = MixedColor(normal: 0xE1EBFE, night: 0x20232F)
        btn.setMixedTitleColor(MixedColor(normal: 0xFFFFFF, night: 0x5E88F7), forState: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        return btn
    }()

    lazy var lbSubTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.text = self.yxs_user.school ?? ""
        lb.font = UIFont.systemFont(ofSize: 13)
//        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        lb.mixedTextColor = MixedColor(normal: 0xFFFFFF, night: 0x898F9A)
        return lb
    }()
    
//    lazy var btnChangeStage: YXSButton = {
//        let btn = YXSButton()
//        btn.setTitle("切换学段", for: .normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        btn.setMixedTitleColor(MixedColor(normal: 0x575A60, night: 0xEB9A3C), forState: .normal)
//        btn.setBackgroundImage(UIImage(named: "yxs_mine_stage"), for: .normal)
//        btn.isHidden = YXSPersonDataModel.sharePerson.personRole == .TEACHER ? false : true
//        return btn
//    }()
//
//    lazy var operationView: UIView = {
//        let view = UIView()
//        view.clipsToBounds = false
//        view.mixedBackgroundColor = MixedColor(normal: 0xFFFFFF, night: 0x20232F)
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 5
////        view.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-30, height: (SCREEN_WIDTH-30)*55/345), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#20232F"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#20232F"), cornerRadius: 5)
////        view.yxs_shadow(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-30, height: (SCREEN_WIDTH-30)*55/345), color: UIColor.yxs_hexToAdecimalColor(hex: "#181A23"), cornerRadius: 5, offset: CGSize(width: 0, height: 2))
//        return view
//    }()
    
//    lazy var btnMyClass: YXSButton = {
//        let btn = YXSButton()
//        btn.setTitle("我的班级", for: .normal)
//        btn.setImage(UIImage(named: "yxs_mine_house"), for: .normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
////        btn.mixedBackgroundColor = MixedColor(normal: 0x658FF7, night: 0x658FF7)
//        btn.setMixedTitleColor(MixedColor(normal: 0x575A60, night: 0xFFFFFF), forState: .normal)
////        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
//        return btn
//    }()
//
//    lazy var btnMyClass2: YXSButton = {
//        let btn = YXSButton()
//        btn.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNight20232F)
//        btn.clipsToBounds = true
//        btn.layer.cornerRadius = 5
//        return btn
//    }()
    
//    lazy var btnClass: YXSButton = {
//        let btn = YXSButton()
//        btn.setTitle("我的班级", for: .normal)
//        btn.setImage(UIImage(named: "yxs_mine_class"), for: .normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        btn.setMixedTitleColor(MixedColor(normal: kTextMainBodyColor, night: kNightFFFFFF), forState: .normal)
////        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
//        btn.isUserInteractionEnabled = false
//        return btn
//
//        }()
//
//    lazy private var imgRightArrow: UIImageView = {
//        let img = UIImageView()
//        img.image = UIImage(named: "yxs_class_arrow")
//        return img
//    }()
//
//    lazy var btnMyComment: YXSButton = {
//        let btn = YXSButton()
//        btn.setTitle("我的点评", for: .normal)
//        btn.setImage(UIImage(named: "yxs_mine_comment"), for: .normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
////        btn.mixedBackgroundColor = MixedColor(normal: 0x96DADE, night: 0x96DADE)
//        btn.setMixedTitleColor(MixedColor(normal: kTextMainBodyColor, night: kNightFFFFFF), forState: .normal)
//        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
//        return btn
//    }()
    
    /// 孩子头像
    lazy var imgStackingView: ImagesStackingView = {
        let imgsView = ImagesStackingView()
        return imgsView
    }()
//
//    lazy var btnChildren: YXSButton = {
//        let btn = YXSButton()
//        btn.setTitle("查看孩子", for: .normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        btn.setMixedTitleColor(MixedColor(normal: 0x5E88F7, night: 0x5E88F7), forState: .normal)
//        btn.clipsToBounds = true
//        btn.layer.cornerRadius = 12
//        btn.layer.borderColor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7").cgColor
//        btn.layer.borderWidth = 0.5
//        return btn
//    }()
}

class ImagesStackingView: UIControl {//UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func layout(imagesUrl:[String]) {
        let width:CGFloat = (36.0 - 5.0)*CGFloat((self.imagesUrl?.count ?? 0)) + 5.0
        self.snp.makeConstraints({ (make) in
            make.width.equalTo(width)
            make.height.equalTo(36)
        })
        
        for idx in 0 ..< (self.imagesUrl ?? [String]()).count{
            let img: UIImageView = UIImageView()
            img.layer.borderWidth = 1
            img.layer.borderColor = UIColor.white.cgColor
            img.cornerRadius = 18
            img.contentMode = .scaleAspectFill
            
            
            let placeholderImg = YXSPersonDataModel.sharePerson.personRole == .TEACHER ? kImageUserIconTeacherDefualtMixedImage : kImageUserIconStudentDefualtMixedImage
            let url = self.imagesUrl![idx]
            img.yxs_setImageWithURL(url:  URL(string: url), placeholder: placeholderImg)
            self.addSubview(img)
            
            img.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.snp_centerY)
                make.left.equalTo(idx*28)
                make.width.height.equalTo(36)
            })
        }
    }
    
    var imagesUrl: [String]? {
        didSet {
            self.removeSubviews()
            
            if self.imagesUrl?.count == 0 {
                let width:CGFloat = 36.0
                self.snp.makeConstraints({ (make) in
                    make.width.equalTo(width)
                    make.height.equalTo(36)
                })
                let img: UIImageView = UIImageView()
                img.layer.borderWidth = 1
                img.layer.borderColor = UIColor.white.cgColor
                img.cornerRadius = 18
                img.contentMode = .scaleAspectFill

                if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                    img.mixedImage = MixedImage(normal: kImageUserIconTeacherDefualtImage!, night: kImageUserIconTeacherDefualtImage!)
                } else {
                    img.mixedImage = MixedImage(normal: kImageUserIconStudentDefualtImage!, night: kImageUserIconStudentDefualtImage!)
                }
                self.addSubview(img)
                img.snp.makeConstraints({ (make) in
                    make.edges.equalTo(0)
                })
                
            } else {
                layout(imagesUrl: self.imagesUrl ?? [String]())
            }
            
        }
    }
}
