//
//  SLVersionUpdateView.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/27.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

enum VersionUpdateButtonType: String {
    case UPDATE
    case LATER
}
class SLVersionUpdateView: SLBasePopingView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var mandatory:Bool = false
    var completionHandler:((_ clickType: VersionUpdateButtonType,_ view: SLVersionUpdateView)->())?
    
    init(mandatory:Bool, completionHandler:((_ clickType: VersionUpdateButtonType,_ view: SLVersionUpdateView)->())?) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        self.completionHandler = completionHandler
        self.mandatory = mandatory
        lbTitle.isHidden = true
            
        self.addSubview(imgBgTop)
        
        self.addSubview(bottomView)
        bottomView.addSubview(tvContent)
        bottomView.addSubview(btnUpdate)
        if !mandatory {
            bottomView.addSubview(btnLater)
        }
        
        
        imgBgTop.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.width.equalTo(260*SCREEN_SCALE)
            make.height.equalTo(180*SCREEN_SCALE)
        })
        
        bottomView.snp.makeConstraints({ (make) in
            make.top.equalTo(imgBgTop.snp_bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        })
        
        tvContent.snp.makeConstraints({ (make) in
            make.top.equalTo(bottomView.snp_top)
            make.left.equalTo(33)
            make.right.equalTo(-33)
            make.height.equalTo(SCREEN_SCALE * 92)
        })
        
        
        if !mandatory {
            btnUpdate.snp.makeConstraints({ (make) in
                make.top.equalTo(tvContent.snp_bottom).offset(30)
                make.centerX.equalTo(bottomView.snp_centerX)
                make.width.equalTo(180*SCREEN_SCALE)
                make.height.equalTo(40*SCREEN_SCALE)
            })
            
            btnLater.snp.makeConstraints({ (make) in
                make.top.equalTo(btnUpdate.snp_bottom).offset(18)
                make.centerX.equalTo(bottomView.snp_centerX)
                make.bottom.equalTo(-30)
            })
            
        } else {
            btnUpdate.snp.makeConstraints({ (make) in
                make.top.equalTo(tvContent.snp_bottom).offset(30)
                make.centerX.equalTo(bottomView.snp_centerX)
                make.width.equalTo(180*SCREEN_SCALE)
                make.height.equalTo(40*SCREEN_SCALE)
                make.bottom.equalTo(-30)
            })
        }
        
        self.snp.remakeConstraints({ (make) in
            make.centerX.equalTo(self.panelView.snp_centerX)
            make.centerY.equalTo(self.panelView.snp_centerY).offset(0)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: SLVersionUpdateModel? {
        didSet {
            let content = self.model?.content ?? ""
            if content.count > 0 {
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineSpacing = 5

                self.tvContent.attributedText = NSAttributedString(string: content, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15), NSAttributedString.Key.paragraphStyle:paragraph])
                
                var tvH = tvContent.sizeThatFits(CGSize(width: 260*SCREEN_SCALE - 66, height: CGFloat.greatestFiniteMagnitude)).height
                tvH = tvH > SCREEN_SCALE * 92 ? SCREEN_SCALE * 92 : tvH
                self.tvContent.snp.makeConstraints({ (make) in
                    make.top.equalTo(bottomView.snp_top)
                    make.left.equalTo(33)
                    make.right.equalTo(-33)
                    make.height.equalTo(tvH)
                })
            }
        }
    }
    
    // MARK: - Action
    @objc func updateClick(sender: SLButton) {
        completionHandler?(VersionUpdateButtonType.UPDATE,self)
    }
    
    @objc func laterClick(sender: SLButton) {
        completionHandler?(VersionUpdateButtonType.LATER,self)
        cancelClick()
    }
    
    // MARK: - LazyLoad
    lazy var imgBgTop: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "sl_version_update")
        return img
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = kFFFDFEColor
        return view
    }()
    
    lazy var tvContent: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.text = ""
        tv.mixedTextColor = MixedColor(normal: k575A60Color, night: k575A60Color)
        tv.backgroundColor = UIColor.clear
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    }()

    lazy var btnUpdate: SLButton = {
        let btn = SLButton()
        btn.setTitle("立即更新", for: .normal)
        btn.setTitleColor(UIColor.sl_hexToAdecimalColor(hex: "#FEFEFF"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(updateClick(sender:)), for: .touchUpInside)
        btn.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: 180*SCREEN_SCALE, height: 40*SCREEN_SCALE), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 20)
        btn.sl_shadow(frame: CGRect(x: 0, y: 0, width: 180*SCREEN_SCALE, height: 40*SCREEN_SCALE), color: UIColor.gray, cornerRadius: 20, offset: CGSize(width: 4, height: 4))
        return btn
    }()
    
    lazy var btnLater: SLButton = {
        let btn = SLButton()
        btn.setTitle("以后再说", for: .normal)
        btn.setTitleColor(UIColor.sl_hexToAdecimalColor(hex: "#898F9A"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(laterClick(sender:)), for: .touchUpInside)
        return btn
    }()
}
