//
//  SLCommonBottomAlerView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/19.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

import UIKit
import NightNight

class SLCommonBottomParams: NSObject{
    /// 展示文本
    var title: String
    
    /// 选中响应事件字符串
    var event: String
    init(title: String, event: String){
        self.title = title
        self.event = event
        super.init()
    }
}


private let kButtonTag = 101

/// 底部弹出选择窗口
class SLCommonBottomAlerView: UIView {
    
    var complete: (()->())?
    var completeParams: ((SLCommonBottomParams)->())?
    var buttons:[SLCommonBottomParams]
    
    /// 单行选项初始化方法
    /// - Parameters:
    ///   - topButtonTitle: 单选文本
    ///   - complete: 选中回调
    @discardableResult static func showIn(topButtonTitle: String = "置顶", complete:(()->())?) -> SLCommonBottomAlerView{
        let view = SLCommonBottomAlerView(buttons: [SLCommonBottomParams.init(title: topButtonTitle, event: "")])
        view.complete = complete
        view.beginAnimation()
        return view
    }
    
    
    /// 多行选项初始化
    /// - Parameters:
    ///   - buttons: 多项参数
    ///   - completeParams: 选中回调
    @discardableResult static func showIn(buttons: [SLCommonBottomParams], completeParams:((SLCommonBottomParams)->())?) -> SLCommonBottomAlerView{
        let view = SLCommonBottomAlerView(buttons: buttons)
        view.completeParams = completeParams
        view.beginAnimation()
        return view
    }
    
    private init(buttons: [SLCommonBottomParams]) {
        self.buttons = buttons
        super.init(frame: CGRect.zero)
        
        self.addSubview(self.btnCancel)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func beginAnimation() {
        UIApplication.shared.keyWindow?.addSubview(bgWindow)
        
        bgWindow.addSubview(self)
        bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        self.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 1
        })
    }
    
    // MARK: -event
    
    @objc private func dismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 0
        }) { finished in
            self.bgWindow.removeFromSuperview()
        }
    }
    private func layout() {
        self.btnCancel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(50)
        })
        
        for (index,model) in buttons.enumerated() {
            let btn = UIButton()
            btn.setTitle(model.title, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight383E56)
            btn.setMixedTitleColor(MixedColor(normal: k575A60Color, night: kNightFFFFFF), forState: .normal)
            btn.addTarget(self, action: #selector(setTopClick(sender:)), for: .touchUpInside)
            btn.tag = kButtonTag + index
            if index == buttons.count - 1{
                btn.sl_addLine(position: LinePosition.bottom, color: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 5)
            }
            self.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                if index == 0 {
                    make.top.equalTo(0)
                }
                make.bottom.equalTo(self.btnCancel.snp_top).offset(-55*(buttons.count - 1 - index))
                make.right.left.equalTo(0)
                make.height.equalTo(55)
            })
        }
    }
    
    // MARK: - Action
    @objc private func setTopClick(sender: UIButton) {
        dismiss()
        completeParams?(buttons[sender.tag - kButtonTag])
        complete?()
    }
    
    
    // MARK: - LazyLoad
    private lazy var btnCancel: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight383E56)
        btn.setMixedTitleColor(MixedColor(normal: kNight5E88F7, night: kNight898F9A), forState: .normal)
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return btn
        
    }()
    
    private lazy var bgWindow : UIControl = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        return view
    }()
}
