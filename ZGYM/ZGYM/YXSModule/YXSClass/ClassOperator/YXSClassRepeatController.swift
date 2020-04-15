//
//  YXSClassRepeatController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/18.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSClassRepeatController: YXSBaseViewController {
    let errorModel: YXSClassAddErrorModel
    var cheakReuslt: ((_ sucess: Bool) ->())?
    init(errorModel: YXSClassAddErrorModel) {
        self.errorModel = errorModel
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        var text = errorModel.realName ?? "" + "的"
        for model in Relationships{
            if model.paramsKey == errorModel.relationship{
                text += model.text
                break
            }
        }
        let phoneText =  errorModel.account ?? "18565309951"
        text += ":\(phoneText.mySubString(to: 3))****\(phoneText.mySubString(from: 7))"
        titleLabel.text = text
        //            {\"account\":\"18565309951\",\"childrenId\":3,\"gradeId\":24,\"id\":100,\"realName\":\"李五\",\"relationship\":\"MOM\",\"userId\":2}
    }
    
    // MARK: -UI
    func initUI(){
        view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        view.addSubview(tipsLabel)
        view.addSubview(titleLabel)
        view.addSubview(isMyChildButton)
        view.addSubview(notMyChildButton)
        tipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(19)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tipsLabel.snp_bottom).offset(45.5)
            make.centerX.equalTo(view)
        }
        isMyChildButton.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(93)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize.init(width: 318, height: 49))
        }
        notMyChildButton.snp.makeConstraints { (make) in
            make.top.equalTo(isMyChildButton.snp_bottom).offset(20)
            make.centerX.equalTo(view)
            make.height.equalTo(24)
        }
    }
    
    // MARK: -loadData
    
    // MARK: -action
    @objc func isClick(){
        let vc = YXSClassRepeatCheckController.init(errorModel: errorModel)
        vc.cheakSucess = {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.cheakReuslt?(true)
        }
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func isNotClick(){
        cheakReuslt?(false)
        navigationController?.popViewController()
    }
    // MARK: -private
    
    // MARK: -public
    
    
    // MARK: - getter&setter
    
    lazy var tipsLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: kNightBCC6D4)
        label.text = "此班级已有家长关联了此姓名的孩子，他是您的家庭成员吗？选“是”你们将一起关注此孩子的学习和成长！"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return label
    }()
    
    lazy var isMyChildButton: YXSButton = {
        let btn = YXSButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.cornerRadius = 24.5
        btn.setTitle("是的", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        btn.addShadow(ofColor: UIColor.yxs_hexToAdecimalColor(hex: "#4C74F6"), radius: 7.5, offset: CGSize(width: 0, height: 3), opacity: 0.5)
        btn.addTarget(self, action: #selector(isClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var notMyChildButton: YXSButton = {
        let btn = YXSButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitle("不是，修改孩子姓名", for: .normal)
        btn.setTitleColor(kBlueColor, for: .normal)
        btn.addTarget(self, action: #selector(isNotClick), for: .touchUpInside)
        return btn
    }()
}

