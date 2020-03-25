//
//  SLHomePublishView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/20.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import SnapKit
import NightNight

private var texts = ["通知", "作业", "班级之星", "接龙" ,"打卡"]
private var images = [kNoticeKey, kHomeworkKey, kClassStartKey,  kSolitaireKey,kPunchCardKey]
private var actions = [SLHomeActionEvent.notice,.homework, .classstart, .solitaire, .punchCard]
private let controlViewOrginTag = 101
class SLHomePublishView: UIView {
    
    /// 展示
    /// - Parameter complete: 点击所有按钮回调
    @discardableResult static func showAlert(complete:(( _ action: SLHomeActionEvent) ->())?) -> SLHomePublishView{
        let view = SLHomePublishView()
        view.complete = complete
        view.beginAnimation()
        return view
    }

    private var complete:((_ action: SLHomeActionEvent) ->())?
    override init(frame: CGRect) {
        super.init(frame: frame)

        if SLPersonDataModel.sharePerson.personRole == .TEACHER && SLPersonDataModel.sharePerson.personStage == .KINDERGARTEN  {
            texts = ["优成长", "班级之星", "通知","打卡","接龙"]
            images = ["sl_friend_circle", kClassStartKey, kNoticeKey,  kPunchCardKey,kSolitaireKey]
            actions = [.friendCicle, .classstart, .notice, .punchCard, .solitaire]
            
//            texts = ["优成长", "班级之星", "通知","打卡","接龙"]
//            images = ["sl_friend_circle", kClassStartKey, kNoticeKey,  kPunchCardKey,kSolitaireKey]
//            actions = [SLHomeActionEvent.friendCicle,.classstart, .notice, .punchCard, .solitaire]
        }else{
//            texts = ["通知", "作业", "班级之星", "接龙" ,"打卡", "成绩"]
//            images = ["sl_notice", "sl_homework", "sl_classstart",  "sl_solitaire","sl_punchCard", "sl_score"]
//            actions = [HomeActionEvent.notice,.homework, .classstart, .solitaire, .punchCard, .score]
            texts = ["通知", "作业", "班级之星", "接龙" ,"打卡"]
            images = [kNoticeKey, kHomeworkKey, kClassStartKey,  kSolitaireKey,kPunchCardKey]
            actions = [SLHomeActionEvent.notice,.homework, .classstart, .solitaire, .punchCard]
        }
        
        
        let lineCount = 3
        let padding: CGFloat = (SCREEN_WIDTH - 52*2 - 41*CGFloat(lineCount))/CGFloat((lineCount - 1))
        var last: UIView!
        for index in 0..<texts.count{
            let control = SLCustomImageControl.init(imageSize: CGSize.init(width: 41, height: 41), position: .top, padding: 14)
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
        addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
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
        UIApplication.shared.keyWindow?.addSubview(bgWindow)
        
        bgWindow.addSubview(self)
        bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        self.sl_addRoundedCorners(corners: [UIRectCorner.topLeft,UIRectCorner.topRight], radii: CGSize.init(width: 5, height: 5), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 500))
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
    
    
    // MARK: -event

    @objc func controlClick(button: SLButton){
        let index = button.tag - controlViewOrginTag
        complete?(actions[index])
        dismiss()
    }
    
    
    // MARK: -getter
    
    lazy var bgWindow : UIControl = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.252, alpha: 0.7)
        return view
    }()
    
    lazy var closeButton: SLButton = {
        let button = SLButton()
        button.setImage(UIImage.init(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        button.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightForegroundColor)
        return button
    }()
}
