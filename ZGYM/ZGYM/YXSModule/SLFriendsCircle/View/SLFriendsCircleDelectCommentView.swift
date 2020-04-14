//
//  SLFriendsCircleDelectCommentView.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/12.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

class SLFriendsCircleDelectCommentView: UIView {
    @discardableResult static func showAlert(_ point: CGPoint,compelect:(() ->())? = nil) -> SLFriendsCircleDelectCommentView{
        let view = SLFriendsCircleDelectCommentView(point)
        view.compelect = compelect
        view.beginAnimation()
        return view
    }
    
    var point: CGPoint
    var compelect:(() ->())?
    init(_ point: CGPoint) {
        self.point = point
        super.init(frame: CGRect.zero)
        self.addSubview(certainButton)
        certainButton.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginAnimation() {
        UIApplication.shared.keyWindow?.addSubview(bgWindow)
        bgWindow.addSubview(self)
        bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 94.5, height: 53))
            make.bottom.equalTo(point.y - SCREEN_HEIGHT)
            make.left.equalTo(point.x - 47)
        }
        bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 1
        })
    }
    
    // MARK: -event
    
    @objc func dismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 0
        }) { finished in
            self.bgWindow.removeFromSuperview()
        }
    }

    @objc func certainClick(){
        dismiss()
        compelect?()
    }
    
    // MARK: -getter
    lazy var certainButton : YXSButton = {
        let button = YXSButton.init()
        button.setTitle("删除", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets.init(top: -5, left: 0, bottom: 0, right: 0)
        button.setBackgroundImage(UIImage.init(named: "yxs_friend_circle_delect"), for: .normal)
        button.addTarget(self, action: #selector(certainClick), for: .touchUpInside)
        return button
    }()
    
    lazy var bgWindow : UIControl! = {
        let view = UIControl()
        view.backgroundColor = UIColor.clear
        view.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return view
    }()
}
