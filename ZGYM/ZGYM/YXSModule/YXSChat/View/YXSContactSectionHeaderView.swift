//
//  YXSContactSectionHeaderView.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/3/16.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

/// 联系人组头部
class YXSContactSectionHeaderView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor)
        
        panel.addSubview(lbTitle)
        panel.addSubview(lbGroupName)
        contentView.addSubview(panel)
        
        panel.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
    }
    
    var model: YXSContactSectionHeaderViewModel? {
        didSet {
            lbTitle.text = self.model?.titleName
            lbGroupName.text = self.model?.gourpName
            
            if (self.model?.titleName != nil) && (self.model?.gourpName == nil) {
                lbTitle.text = self.model?.titleName
                lbGroupName.text = ""
                
                lbTitle.snp.remakeConstraints({ (make) in
                    make.top.equalTo(10)
                    make.bottom.equalTo(-10)
                    make.left.equalTo(15)
                })
                
                lbGroupName.snp.remakeConstraints({ (make) in
                    make.top.equalTo(0)
                    make.left.equalTo(0)
                })
                
            } else {
                if (self.model?.titleName != nil) && (self.model?.gourpName != nil) {
                    /// 保持原样布局
                    lbTitle.text = self.model?.titleName
                    lbGroupName.text = self.model?.gourpName
                    
                    lbTitle.snp.remakeConstraints({ (make) in
                        make.top.equalTo(10)
                        make.left.equalTo(15)
                    })
                    
                    lbGroupName.snp.remakeConstraints({ (make) in
                        make.top.equalTo(lbTitle.snp_bottom).offset(5)
                        make.left.equalTo(lbTitle.snp_left)
                        make.bottom.equalTo(-10)
                    })
                    
                } else {
                    lbTitle.text = ""
                    lbGroupName.text = self.model?.gourpName
                    
                    lbTitle.snp.remakeConstraints({ (make) in
                        make.top.equalTo(0)
                        make.left.equalTo(0)
                    })
                    
                    lbGroupName.snp.remakeConstraints({ (make) in
                        make.top.equalTo(10)
                        make.bottom.equalTo(-10)
                        make.left.equalTo(15)
                    })
                }
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    lazy var panel: UIView = {
        let view = UIView()
        return view
    }()
    
    /// 教师 or 成员
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.text = ""
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNightFFFFFF)
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    /// A、B、C、D...
    lazy var lbGroupName: YXSLabel = {
        let lb = YXSLabel()
        lb.text = ""
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()

}

class YXSContactSectionHeaderViewModel: NSObject {
    var titleName: String?
    var gourpName: String?
}
