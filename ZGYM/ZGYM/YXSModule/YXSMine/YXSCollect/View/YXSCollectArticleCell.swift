//
//  YXSCollectArticleCell.swift
//  ZGYM
//
//  Created by yihao on 2020/5/13.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight

class YXSCollectArticleCell: YXSBaseTableViewCell {
    
    var model: YXSChildContentHomeListModel = YXSChildContentHomeListModel.init(JSON: ["":""])!
    var currentIndex: Int = 0
    var deleteBlock:((_ model: YXSChildContentHomeListModel,_ lbl: YXSLabel)->())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageV)
        contentView.addSubview(subTitleLabel)
        
        iconImageV.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(15)
            make.width.height.equalTo(86)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(15)
            make.right.equalTo(iconImageV.snp_left).offset(-15)
            make.height.equalTo(60)
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom).offset(10)
            make.right.equalTo(iconImageV.snp_left).offset(-15)
            make.height.equalTo(14)
        }
        contentView.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(longGestureClick)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func longGestureClick(recognizer:UIGestureRecognizer) {
        if recognizer.state == .ended{
            return
        }else if recognizer.state == .began{
            self.becomeFirstResponder()
            let menuItem = UIMenuItem.init(title: "取消收藏", action: #selector(deleteItem(item:)))
            UIMenuController.shared.arrowDirection = .default
            UIMenuController.shared.menuItems = [menuItem]
            let point = self.contentView.bounds.origin
            let size = self.contentView.bounds.size
            
            UIMenuController.shared.setTargetRect(CGRect(x: point.x, y: 30, width: size.width, height: 30), in: self.contentView)
            UIMenuController.shared.setMenuVisible(true, animated: true)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Action
    @objc func deleteItem(item:UIMenuItem) {
        deleteBlock?(self.model,self.titleLabel)
        print("删除")
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(deleteItem(item:)) {
            return true
        }
        return false
    }
    
    func setModel(model: YXSChildContentHomeListModel) {
        self.model = model
        iconImageV.sd_setImage(with: URL(string: model.cover ?? ""), placeholderImage: UIImage.init(named: "yxs_synclass_foldercell_default"), options: .refreshCached, completed: nil)
        titleLabel.text = model.title
        if model.type ?? 1 == 1 {
            subTitleLabel.text = "育儿好文"
        } else {
            subTitleLabel.text = "优期刊第\(model.numPeriods ?? 1)期"
        }
        
    }
    
    // MARK: -getter&setter
    lazy var titleLabel: YXSLabel = {
       let label = YXSLabel()
        label.numberOfLines = 0
       label.font = UIFont.systemFont(ofSize: 16)
       label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#222222"), night: kNightBCC6D4)
       return label
   }()
   
   lazy var iconImageV: UIImageView = {
       let imgV = UIImageView()
       return imgV
   }()
   
   lazy var subTitleLabel: YXSLabel = {
       let label = YXSLabel()
       label.font = UIFont.systemFont(ofSize: 13)
       label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
       return label
   }()
}
