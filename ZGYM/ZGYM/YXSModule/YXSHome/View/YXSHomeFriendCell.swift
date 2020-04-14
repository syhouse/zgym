//
//  YXSHomeFriendCell.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/25.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

class YXSHomeFriendCell: YXSHomeBaseCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc override func longTap(_ longTap: UILongPressGestureRecognizer){
        
    }
    public var headerBlock: ((FriendsCircleHeaderBlockType) -> ())?
    override func yxs_setCellModel(_ model: YXSHomeListModel) {
        self.model = model
        redView.isHidden = true
        if let friendModel = model.friendCircleModel{
            yxs_friendsContentView.setModel(friendModel)
        }
        if YXSPersonDataModel.sharePerson.personRole == .PARENT,YXSLocalMessageHelper.shareHelper.yxs_isLocalMessage(serviceId: model.serviceId ?? 1001, childId: model.childrenId ?? 0){
            redView.isHidden = false
        }
                
    }
    
    private func initUI(){
        contentView.addSubview(bgContainView)
        bgContainView.addSubview(yxs_friendsContentView)
        bgContainView.addSubview(redView)
    }
    
    func layout(){
        bgContainView.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0).priorityHigh()
        }
        
        yxs_friendsContentView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(-20)
        }
        
        redView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(0)
            make.size.equalTo(CGSize.init(width: 26, height: 29))
        }
    }
    
    lazy var yxs_friendsContentView: YXSFriendsCircleContentView = {
        let yxs_friendsContentView = YXSFriendsCircleContentView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 0))
        yxs_friendsContentView.headerBlock = {
            [weak self] (type)in
            guard let strongSelf = self else { return }
            strongSelf.headerBlock?(type)
        }
        return yxs_friendsContentView
    }()
}
