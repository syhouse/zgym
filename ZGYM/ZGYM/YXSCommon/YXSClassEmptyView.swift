//
//  YXSClassEmptyView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/29.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

/// 班级学生为空
class YXSClassEmptyView: SLBaseEmptyView {
    var classNum: String!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //班级之星点评空白页 邀请按钮隐藏功能
    /*
    override func buttonClick(){
        MBProgressHUD.yxs_showLoading()
        YXSEducationGradeQueryRequest.init(num: classNum).request({ (model: YXSClassQueryResultModel) in
            MBProgressHUD.yxs_hideHUD()
            if model.id == nil{
                MBProgressHUD.yxs_showMessage(message: "未查找到班级")
            }else{
                self.showInviteView(model:model)
            }
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    func showInviteView(model: YXSClassQueryResultModel){
        let share = YXSShareView(items: [.YXSShareWechatFriendInvite, .YXSShareQRcode]) {[weak self](item, type,view) in
            guard let strongSelf = self else { return }
            if type == .YXSShareQRcode {
                let vc = YXSInviteViewController(gradeNum: model.num ?? "", gradeName: model.name ?? "", headmasterName: model.headmasterName ?? "")
                strongSelf.pushVC(vc: vc)

            } else {
                let m = HMRequestShareModel(gradeNum: model.num ?? "", gradeName: model.name ?? "", headmasterName: strongSelf.yxs_user.name ?? "")
                MBProgressHUD.yxs_showLoading()
                YXSEducationShareLinkRequest(model: m).request({ (json) in
                    MBProgressHUD.yxs_hideHUD()
                    let shareModel = YXSShareModel(title: "", descriptionText: "", link: json.stringValue)
                    shareModel.way = .WXSession
                    YXSShareTool.share(model: shareModel)

                }) { (msg, code) in
                    MBProgressHUD.yxs_showMessage(message: msg)
                }

            }
            view.cancelClick()
        }
        share.showIn(target: self)
    }
    
    private func pushVC(vc: UIViewController){
        UIUtil.currentNav().pushViewController(vc)
    }
 */
}

/// 图片 文字 按钮
class SLBaseEmptyView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(label)
        addSubview(button)
        
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 271, height: 188.5))
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-60)
        }
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(imageView.snp_bottom).offset(15)
        }
        button.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 124, height: 31))
            make.centerX.equalTo(self)
            make.top.equalTo(label.snp_bottom).offset(18)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonClick(){
    }

    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.mixedImage = MixedImage(normal: "yxs_empty_class", night: "yxs_empty_class_night")
        return imageView
    }()
    
    lazy var label: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), night: kNightBCC6D4)
        label.text = "该班级还没有学生哦！"
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton.init()
        button.setTitleColor(kBlueColor, for: .normal)
        button.setTitle("邀请学生入班", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.borderWidth = 1
        button.borderColor = kBlueColor
        button.cornerRadius = 15.5
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return button
    }()
}
