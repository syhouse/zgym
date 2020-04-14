//
//  YXSClassSelectRoleView.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/21.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import SnapKit

class YXSClassSelectRoleView: UIView {
    
    /// 展示
    /// - Parameter complete: 点击所有按钮回调
    @discardableResult static func showAlert(complete:(( _ isSelectTeacher: Bool) ->())?) -> YXSClassSelectRoleView{
        let view = YXSClassSelectRoleView()
        view.complete = complete
        view.beginAnimation()
        return view
    }

    private var complete:((_ isSelectTeacher: Bool) ->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(line)
        addSubview(teacherButton)
        addSubview(parentButton)
        addSubview(closeButton)
        
        teacherButton.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        parentButton.snp.makeConstraints { (make) in
            make.top.equalTo(teacherButton.snp_bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(parentButton.snp_bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(5)
        }
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(parentButton.snp_bottom).offset(5)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
            make.height.equalTo(49)
        }
    }
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -public
    public func beginAnimation() {
        UIApplication.shared.keyWindow?.addSubview(bgWindow)
        
        bgWindow.addSubview(self)
        bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.backgroundColor = UIColor.white
        self.yxs_addRoundedCorners(corners: [UIRectCorner.topLeft,UIRectCorner.topRight], radii: CGSize.init(width: 5, height: 5), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 500))
        self.clipsToBounds = true
        
        self.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
        }
        bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 1
        })
    }
    
    @objc public  func dismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 0
        }) { finished in
            self.bgWindow.removeFromSuperview()
        }
    }
    
    
    @objc private func selectTeacher(){
        dismiss()
        complete?(true)
    }
    
    @objc private func selectParent(){
         dismiss()
        complete?(false)
    }
    
    
    // MARK: -event

    
    // MARK: -getter
    
    lazy var bgWindow : UIControl = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.152, alpha: 0.7)
        return view
    }()
    
    lazy var teacherButton: YXSButton = {
        let button = YXSButton()
        button.setTitle("我是任课老师", for: .normal)
        button.addTarget(self, action: #selector(selectTeacher), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        button.yxs_addLine(color: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), lineHeight: 1)
        return button
    }()
    
    lazy var parentButton: YXSButton = {
        let button = YXSButton()
        button.setTitle("我是家长", for: .normal)
        button.addTarget(self, action: #selector(selectParent), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        return button
    }()
    
    lazy var closeButton: YXSButton = {
        let button = YXSButton()
        button.setTitle("取消", for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(kBlueColor, for: .normal)
        return button
    }()
    
    lazy var line: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9")
        return view
    }()
}
