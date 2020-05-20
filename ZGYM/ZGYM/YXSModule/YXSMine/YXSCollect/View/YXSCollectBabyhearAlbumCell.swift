//
//  YXSCollectBabyhearAlbumCell.swift
//  ZGYM
//
//  Created by yihao on 2020/4/14.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import NightNight

class YXSCollectBabyhearAlbumCell: YXSBaseTableViewCell {
    var model: YXSMyCollectModel = YXSMyCollectModel.init(JSON: ["":""])!
    var currentIndex: Int = 0
    var deleteBlock:((_ model: YXSMyCollectModel,_ index: Int)->())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        contentView.addSubview(headIcon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(countLabel)
        contentView.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(longGestureClick)))
        headIcon.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.width.height.equalTo(63)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.left.equalTo(headIcon.snp_right).offset(20)
            make.right.equalTo(-15)
            make.height.equalTo(18)
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-25)
            make.height.equalTo(18)
            make.left.equalTo(nameLabel)
            make.right.equalTo(-15)
        }
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
        headIcon.isHidden = false
        nameLabel.isHidden = false
        countLabel.isHidden = false
        headIcon.sd_setImage(with: URL(string: model.albumCover ?? ""), placeholderImage: UIImage.init(named: "yxs_collect_albumIcon"))
        nameLabel.text = model.albumTitle
        countLabel.text = "共\(model.albumNum ?? 0)首"
    }
    
    // MARK: -getter&setter
    lazy var nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#222222"), night: kNightBCC6D4)
        label.isHidden = true
        return label
    }()
    
    lazy var headIcon: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage.init(named: "yxs_collect_albumIcon")
        imgV.isHidden = true
        return imgV
    }()
    
    lazy var countLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        label.isHidden = true
        return label
    }()
}
