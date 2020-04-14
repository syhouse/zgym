//
//  YXSShareView.swift
//  HNYMEducation
//
//  Created by Liu Jie on 2019/12/17.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

enum YXSShareItemType: String {
    /// 分享到微信
    case YXSShareWechatFriend
    case YXSShareWechatMoment
    case YXSShareQQ
    case YXSShareQZone
    /// 二维码邀请
    case YXSShareQRcode
    /// 微信邀请
    case YXSShareWechatFriendInvite
}

class YXSShareView: YXSBasePopingView {

    var completionHandler:((_ item: YXSShareItem, _ type:YXSShareItemType,_ view:YXSShareView)->())?
    var itemsType: [YXSShareItemType]?
    
    @discardableResult init(items:[YXSShareItemType], completionHandler:((_ item: YXSShareItem, _ type:YXSShareItemType,_ view: YXSShareView)->())?) {
        super.init(frame: CGRect.zero)
        
        self.completionHandler = completionHandler
        self.itemsType = items
        
        self.lbTitle.isHidden = true
        self.snp.remakeConstraints({ (make) in
            make.bottom.equalTo(panelView.snp_bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
        })
        
        
        let leftRightMargin:CGFloat = 36.0
        let inner:CGFloat = 30.0
        let itemWidth = (SCREEN_WIDTH - inner*2 - leftRightMargin*2 ) / 4.0

//        var rowNumber = items.count / 4
//        rowNumber += items.count % 4 > 0 ? 1:0
        let totalInner = items.count > 1 ? (inner*CGFloat(items.count) - inner) : 0
        let disableWidth = itemWidth*CGFloat(items.count) + totalInner
        var beginX = (SCREEN_WIDTH - disableWidth)/2.0
  
        for index in 0..<items.count  {
            let type = items[index]
            let item = getItemWithType(type: type)
            item.tag = index
            self.addSubview(item)
            item.snp.makeConstraints({ (make) in
                make.top.equalTo(34)
                make.left.equalTo(beginX)
                make.width.equalTo(itemWidth)
            })
            beginX = beginX + itemWidth + inner
        }
        
        self.addSubview(btnCancel)
        btnCancel.snp.makeConstraints({ (make) in
            make.top.equalTo(142)
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(50)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getItemWithType(type:YXSShareItemType)-> YXSShareItem {
        let item = YXSShareItem()
        item.addTaget(target: self, selctor: #selector(itemClick(sender:)))
        
        switch type {
            case .YXSShareWechatFriendInvite:
                item.lbTitle.text = "微信邀请"
                item.imageView.image = UIImage(named: "yxs_share_wechat")
                
            case .YXSShareWechatFriend:
                item.lbTitle.text = "分享到微信"
                item.imageView.image = UIImage(named: "yxs_share_wechat")
            
            case .YXSShareQRcode:
                item.lbTitle.text = "二维码邀请"
                item.imageView.image = UIImage(named: "yxs_share_qrcode")
                
            case .YXSShareWechatMoment:
                item.lbTitle.text = "分享到朋友圈"
                item.imageView.image = UIImage(named: "yxs_share_moment")
                
            case .YXSShareQQ:
                item.lbTitle.text = "分享到QQ好友"
                item.imageView.image = UIImage(named: "yxs_share_qq")
                
            default:
                item.lbTitle.text = "分享到QQ空间"
                item.imageView.image = UIImage(named: "yxs_share_qzone")
        }
        return item
    }
    
    
    @objc func itemClick(sender: UITapGestureRecognizer) {
        var item: YXSShareItem = YXSShareItem()
        if sender.view is YXSShareItem {
            item = sender.view as! YXSShareItem
        }
        completionHandler?(item, itemsType?[sender.view?.tag ?? 0] ?? YXSShareItemType.YXSShareWechatFriend,self)
    }
    
//    lazy var wechatItem: YXSShareItem = {
//        let item = YXSShareItem()
//        item.lbTitle.text = "微信邀请"
//        item.imageView.image = UIImage(named: "yxs_share_wechat")
//        return item
//    }()
//
//    lazy var qrCodeItem: YXSShareItem = {
//        let item = YXSShareItem()
//        item.lbTitle.text = "二维码邀请"
//        item.imageView.image = UIImage(named: "yxs_share_qrcode")
//        return item
//    }()
    
    lazy var btnCancel: YXSButton = {
        let btn = YXSButton()
        btn.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight383E56)
        btn.setMixedTitleColor(MixedColor(normal: kNight5E88F7, night: kNightFFFFFF), forState: .normal)
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(cancelClick(sender:)), for: .touchUpInside)
        return btn
    }()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class YXSShareItem: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.addSubview(lbTitle)
        
        imageView.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.centerX.equalTo(self.snp_centerX)
            make.width.height.equalTo(53)
        })
        
        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(imageView.snp_bottom).offset(10)
            make.centerX.equalTo(snp_centerX)
            make.bottom.equalTo(0)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.numberOfLines = 1
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textAlignment = .center
        lb.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: kNightBCC6D4)
        return lb
    }()
    
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
}
