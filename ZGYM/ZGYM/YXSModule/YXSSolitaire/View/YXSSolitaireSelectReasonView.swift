//
//  YXSSolitaireSelectReasonView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/4.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
/// 我接龙的原因选项
class YXSSolitaireSelectReasonView: YXSBasePopingView, UITableViewDelegate, UITableViewDataSource {
    
    private var dataSource:[String] = [String]()
    /// 显示TableView的高
    var numberOfHeightByItemCount = 6
    var selectedIndex:Int = -1
    var completionHandler:((_ view:YXSSolitaireSelectReasonView, _ selectedIndex:Int)->())?
    
    
    @discardableResult init (items:[String], selectedIndex: Int = -1,title: String = "选择" , inTarget: UIView, completionHandler:((_ view:YXSSolitaireSelectReasonView, _ selectedIndex:Int)->())?) {
        self.dataSource = items
        self.selectedIndex = selectedIndex
        self.completionHandler = completionHandler
        
        super.init(frame: CGRect.zero)
        self.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight282C3B)
        self.lbTitle.text = title
        
        tableView.register(HMAlertSelectionCell.classForCoder(), forCellReuseIdentifier: "HMAlertSelectionCell")
        
        self.addSubview(tableView)
        self.addSubview(btnLeft)
        self.addSubview(btnRight)
        
        
        let height = (items.count>numberOfHeightByItemCount ? numberOfHeightByItemCount : items.count) * (34+10)
        tableView.snp.makeConstraints { (make) in
            make.width.equalTo(227)
            make.height.equalTo(CGFloat(height))
            make.top.equalTo(lbTitle.snp_bottom).offset(24)
            make.left.equalTo(17)
            make.right.equalTo(-17)
        }

        btnLeft.snp.makeConstraints { (make) in
            make.height.equalTo(56)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(tableView.snp_bottom).offset(21)
            make.left.equalTo(0)
        }

        btnRight.snp.makeConstraints { (make) in
            make.height.equalTo(56)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(btnLeft)
            make.right.equalTo(0)
            make.left.equalTo(btnLeft.snp_right)
            make.width.equalTo(btnLeft)
        }

        showIn(target: inTarget)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HMAlertSelectionCell = tableView.dequeueReusableCell(withIdentifier: "HMAlertSelectionCell") as! HMAlertSelectionCell
        cell.btn.setTitle(dataSource[indexPath.row], for: .normal)
        if indexPath.row == selectedIndex {
            cell.btn.isSelected = true
            cell.btn.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")
            
        } else {
            cell.btn.isSelected = false
            cell.btn.mixedBackgroundColor = MixedColor(normal: kF3F5F9Color, night: kNight383E56)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // MARK: - Action
    @objc func doneClick(sender: YXSButton) {
        if selectedIndex >= 0 {
            completionHandler?(self, selectedIndex)
        }
        else {
            MBProgressHUD.yxs_showMessage(message: "请先选择")
        }

    }
    
    // MARK: - LazyLoad
    lazy var tableView: YXSTableView = {
        let tb = YXSTableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tb.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNightForegroundColor)
        tb.delegate = self
        tb.dataSource = self
        return tb
    }()
    
    lazy var btnLeft : YXSButton = {
        let button = YXSButton.init()
        button.setMixedTitleColor(MixedColor(normal: k797B7EColor, night: kNight898F9A), forState: .normal)
        button.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight383E56)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.yxs_addLine(position: .top, color: UIColor.yxs_hexToAdecimalColor(hex: "#E3ECFF"), leftMargin: 0, rightMargin: 0, lineHeight: 1)
        button.yxs_addLine(position: .right, color: UIColor.yxs_hexToAdecimalColor(hex: "#E3ECFF"), leftMargin: 0, rightMargin: 0, lineHeight: 1)
        button.addTarget(self, action: #selector(cancelClick(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var btnRight : YXSButton = {
        let button = YXSButton.init()
        button.setMixedTitleColor(MixedColor(normal: kBlueColor, night: kNight898F9A), forState: .normal)
        button.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight383E56)
        button.setTitle("确认", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.yxs_addLine(position: .top, color: UIColor.yxs_hexToAdecimalColor(hex: "#E3ECFF"), leftMargin: 0, rightMargin: 0, lineHeight: 1)
        button.addTarget(self, action: #selector(doneClick(sender:)), for: .touchUpInside)
        return button
    }()
}


// MARK: -
class HMAlertSelectionCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight282C3B)
        contentView.addSubview(btn)
        btn.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(-10)
            make.height.equalTo(34)
        })
    }
    
    lazy var btn: YXSButton = {
        let btn = YXSButton()
        btn.isUserInteractionEnabled = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.mixedBackgroundColor = MixedColor(normal: kF3F5F9Color, night: kNight383E56)
        btn.setMixedTitleColor(MixedColor(normal: k575A60Color, night: kNightFFFFFF), forState: .normal)
        btn.setMixedTitleColor(MixedColor(normal: kNightFFFFFF, night: kNightFFFFFF), forState: .selected)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 3
        return btn
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//class HMAlertSelectionCellModel: NSObject {
//    var title:
//}
