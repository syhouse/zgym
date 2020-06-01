//
//  YXSSolitaireQuestionWindow.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/28.
//  Copyright © 2020 zgym. All rights reserved.
//
import UIKit
import NightNight
///RADIO,MULTIPLE,TEXT,IMAGE
public enum YXSQuestionType: String{
    ///单选题
    case single = "RADIO"
    ///多选题
    case checkbox = "MULTIPLE"
    ///图片题
    case image = "IMAGE"
    ///填空题
    case gap = "TEXT"
}

private var texts = ["单选题", "多选题", "填空题", "图片题"]
private var images = ["yxs_solitaire_single", "yxs_solitaire_checkbox", "yxs_solitaire_gap","yxs_solitaire_image"]
private var actions = [YXSQuestionType.single,.checkbox, .gap, .image]
private let controlViewOrginTag = 101
class YXSSolitaireQuestionWindow: UIView {
    
    /// 展示
    /// - Parameter complete: 点击所有按钮回调
    @discardableResult static func showWindow(complete:(( _ action: YXSQuestionType) ->())?) -> YXSSolitaireQuestionWindow{
        let view = YXSSolitaireQuestionWindow()
        view.complete = complete
        view.beginAnimation()
        return view
    }

    private var complete: (( _ action: YXSQuestionType) ->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(25)
        }
        
        let lineCount = 4
        let padding: CGFloat = (SCREEN_WIDTH - 15*2 - 58*CGFloat(lineCount))/CGFloat((lineCount - 1))
        var last: UIView!
        for index in 0..<texts.count{
            let control = YXSCustomImageControl.init(imageSize: CGSize.init(width: 58, height: 58), position: .top, padding: 14.5)
            control.tag = index + controlViewOrginTag
            control.addTarget(self, action: #selector(controlClick), for: .touchUpInside)
            control.title = texts[index]
            control.locailImage = images[index]
            control.mixedTextColor  = MixedColor(normal: kTextLightBlackColor, night: UIColor.white)
            control.font = UIFont.systemFont(ofSize: 15)
            addSubview(control)
            let row = index % lineCount
            let low = index / lineCount
            control.snp.makeConstraints { (make) in
                if row == 0{
                    if low == 0{
                        make.top.equalTo(70)
                    }else{
                        make.top.equalTo(last!.snp_bottom).offset(21.5)
                    }
                    make.left.equalTo(15)
                }
                else {
                    make.top.equalTo(last!)
                    make.left.equalTo(last!.snp_right).offset(padding)
                }
                make.width.equalTo(58)
            }

            last = control
        }
        
        let line = UIView()
        line.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"))
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(last.snp_bottom).offset(30)
            make.left.right.equalTo(0)
            make.height.equalTo(4.5)
        }
        
        addSubview(yxs_closeButton)
        yxs_closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(last.snp_bottom).offset(34.5)
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
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(kBlueColor, for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        button.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.mixedTextColor = MixedColor(normal: kTextBlackColor, night: UIColor.white)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = "选择题目类型"
        return titleLabel
    }()
}
