//
//  SLAddClassAlertView.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/19.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

enum ClassEvent {
    case ClassEventCreate
    case ClassEventAdd
}

class SLAddClassAlertView: UIView {
    
    static func showIn(target: UIView, complete:((_ type: ClassEvent) ->())?) {
        let view = SLAddClassAlertView()
        view.complete = complete
        view.bgWindow.addSubview(view)
        target.addSubview(view.bgWindow)
        
        view.snp.makeConstraints({ (make) in
            make.left.equalTo(view.bgWindow.snp_left).offset(0)
            make.right.equalTo(view.bgWindow.snp_right).offset(0)
            make.bottom.equalTo(view.bgWindow.snp_bottom).offset(0)
            make.height.equalTo(69)
        })
        
        view.bgWindow.snp.makeConstraints({ (make) in
            make.edges.equalTo(target.snp_edges)
        })
    }
    
    private var complete: ((_ type: ClassEvent) ->())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.addSubview(self.btnCreateClass)
        self.addSubview(self.btnAddClass)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        self.btnCreateClass.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp_left).offset(12)
            make.centerY.equalTo(self.snp_centerY)
            make.height.equalTo(45)
            make.width.equalTo(self.btnAddClass)
        })
        
        self.btnAddClass.snp.makeConstraints({ (make) in
            make.left.equalTo(self.btnCreateClass.snp_right).offset(12)
            make.right.equalTo(self.snp_right).offset(-12)
            make.centerY.equalTo(self.snp_centerY)
            make.height.equalTo(45)
        })
    }
    
    // MARK: - Action
    @objc func createClassClick(sender: SLButton) {
        self.complete?(ClassEvent.ClassEventCreate)
        dissmiss()
    }
    
    @objc func addClassClick(sender: SLButton) {
        self.complete?(ClassEvent.ClassEventAdd)
        dissmiss()
    }
    
    @objc func dissmiss() {
        self.bgWindow.removeFromSuperview()
    }
    
    // MARK: - LazyLoad
    lazy var btnCreateClass: SLButton = {
        let btn = SLButton()
        btn.setTitle("创建班级", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.mixedBackgroundColor = MixedColor(normal: 0x5E88F7, night: 0x5E88F7)
        btn.setMixedTitleColor(MixedColor(normal: 0xffffff, night: 0xffffff), forState: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(createClassClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnAddClass: SLButton = {
        let btn = SLButton()
        btn.setTitle("加入班级", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.mixedBackgroundColor = MixedColor(normal: 0x5E88F7, night: 0x5E88F7)
        btn.setMixedTitleColor(MixedColor(normal: 0xffffff, night: 0xffffff), forState: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(addClassClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var bgWindow : UIControl = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.252, alpha: 0.7)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dissmiss))
        view.addGestureRecognizer(gesture)
        return view
    }()

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
