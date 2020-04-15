//
//  YXSTableView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/5.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSTableView: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
//        self.delegate = self
//        self.dataSource = self
        self.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNightForegroundColor)
//        self.backgroundColor = kTableViewBackgroundColor
        self.separatorStyle = UITableViewCell.SeparatorStyle.none;
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.alwaysBounceVertical = false
        self.alwaysBounceHorizontal = false
        
        if #available(iOS 11.0, *){
            self.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        self.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Group Style Use
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
//        view.backgroundColor = kTableViewBackgroundColor
        view.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNightForegroundColor)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
