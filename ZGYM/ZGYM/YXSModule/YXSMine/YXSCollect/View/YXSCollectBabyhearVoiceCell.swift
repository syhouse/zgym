//
//  YXSCollectBabyhearVoiceCell.swift
//  ZGYM
//
//  Created by yihao on 2020/4/14.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import NightNight

class YXSCollectBabyhearVoiceCell: YXSBaseTableViewCell {
    var model: YXSMyCollectModel = YXSMyCollectModel.init(JSON: ["":""])!
    var currentIndex: Int = 0
    var deleteBlock:((_ model: YXSMyCollectModel,_ index: Int)->())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeImageV)
        contentView.addSubview(timeLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(18)
        }
        
        timeImageV.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp_bottom).offset(5)
            make.width.height.equalTo(11)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeImageV.snp_right).offset(5)
            make.top.equalTo(timeImageV)
            make.width.equalTo(100)
            make.height.equalTo(11)
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
        deleteBlock?(self.model,self.currentIndex)
        print("删除")
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(deleteItem(item:)) {
            return true
        }
        return false
    }

    
    
    func setModel(model:YXSMyCollectModel) {
        self.model = model
        nameLabel.isHidden = false
        timeLabel.isHidden = false
        timeImageV.isHidden = false
        nameLabel.text = model.voiceTitle
        timeLabel.text = model.voiceTimeStr
    }
    
    // MARK: -getter&setter
    lazy var nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#222222"), night: kNightBCC6D4)
        label.isHidden = true
        return label
    }()
    
    lazy var timeImageV: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage.init(named: "yxs_collect_time")
        imgV.isHidden = true
        return imgV
    }()
    
    lazy var timeLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        label.isHidden = true
        return label
    }()
}
