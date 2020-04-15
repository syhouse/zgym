//
//  YXSHomePublishView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/20.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import SnapKit
import NightNight

private var texts = ["通知", "作业", "班级之星", "打卡", "接龙"]
private var images = [kNoticeKey, kHomeworkKey, kClassStartKey,kPunchCardKey,  kSolitaireKey]
private var actions = [YXSHomeHeaderActionEvent.notice,.homework, .classstart, .punchCard, .solitaire]
private let controlViewOrginTag = 101
class YXSHomePublishView: UIView {
    
    /// 展示
    /// - Parameter complete: 点击所有按钮回调
    @discardableResult static func showAlert(complete:(( _ action: YXSHomeHeaderActionEvent) ->())?) -> YXSHomePublishView{
        let view = YXSHomePublishView()
        view.complete = complete
        view.beginAnimation()
        return view
    }

    private var complete:((_ action: YXSHomeHeaderActionEvent) ->())?
    override init(frame: CGRect) {
        super.init(frame: frame)

        if YXSPersonDataModel.sharePerson.personRole == .TEACHER && YXSPersonDataModel.sharePerson.personStage == .KINDERGARTEN  {
            texts = [ "班级之星", "通知","打卡","接龙"]
            images = [ kClassStartKey, kNoticeKey,  kPunchCardKey,kSolitaireKey]
            actions = [.classstart, .notice, .punchCard, .solitaire]
            
//            texts = ["优成长", "班级之星", "通知","打卡","接龙"]
//            images = ["yxs_friend_circle", kClassStartKey, kNoticeKey,  kPunchCardKey,kSolitaireKey]
//            actions = [.friendCicle, .classstart, .notice, .punchCard, .solitaire]
            
        }else{
            texts = ["通知", "作业", "班级之星","打卡", "接龙" ]
            images = [kNoticeKey, kHomeworkKey, kClassStartKey,kPunchCardKey,  kSolitaireKey]
            actions = [YXSHomeHeaderActionEvent.notice,.homework, .classstart, .punchCard, .solitaire]
        }
        
        
        let lineCount = 3
        let padding: CGFloat = (SCREEN_WIDTH - 52*2 - 41*CGFloat(lineCount))/CGFloat((lineCount - 1))
        var last: UIView!
        for index in 0..<texts.count{
            let control = YXSCustomImageControl.init(imageSize: CGSize.init(width: 41, height: 41), position: .top, padding: 14)
            control.tag = index + controlViewOrginTag
            control.addTarget(self, action: #selector(controlClick), for: .touchUpInside)
            control.title = texts[index]
            control.locailImage = images[index]
            control.mixedTextColor  = MixedColor(normal: kTextLightBlackColor, night: UIColor.white)
            control.font = UIFont.systemFont(ofSize: 14)
            addSubview(control)
            let row = index % lineCount
            let low = index / lineCount
            control.snp.makeConstraints { (make) in
                if row == 0{
                    if low == 0{
                        make.top.equalTo(39)
                    }else{
                        make.top.equalTo(last!.snp_bottom).offset(21.5)
                    }
                    make.left.equalTo(52)
                }
                else {
                    make.top.equalTo(last!)
                    make.left.equalTo(last!.snp_right).offset(padding)
                }
                make.width.equalTo(41)
            }

            last = control
        }
        addSubview(yxs_closeButton)
        yxs_closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(last.snp_bottom).offset(39)
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
        UIApplication.shared.keyWindow?.addSubview(yxs_bgWindow)
        
        yxs_bgWindow.addSubview(self)
        yxs_bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        self.yxs_addRoundedCorners(corners: [UIRectCorner.topLeft,UIRectCorner.topRight], radii: CGSize.init(width: 5, height: 5), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 500))
        self.clipsToBounds = true
        
        self.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
        }
        yxs_bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.yxs_bgWindow.alpha = 1
        })
    }
    
    @objc public  func dismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.yxs_bgWindow.alpha = 0
        }) { finished in
            self.yxs_bgWindow.removeFromSuperview()
        }
    }
    
    
    // MARK: -event

    @objc func controlClick(button: YXSButton){
        let index = button.tag - controlViewOrginTag
        complete?(actions[index])
        dismiss()
    }
    
    
    // MARK: -getter
    
    lazy var yxs_bgWindow : UIControl = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.252, alpha: 0.7)
        return view
    }()
    
    lazy var yxs_closeButton: YXSButton = {
        let button = YXSButton()
        button.setImage(UIImage.init(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        button.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightForegroundColor)
        return button
    }()
}
