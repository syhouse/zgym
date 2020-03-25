//
//  SLHomeFriendCell.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/25.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

class SLHomeFriendCell: SLHomeBaseCell {
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
    override func sl_setCellModel(_ model: SLHomeListModel) {
        self.model = model
        redView.isHidden = true
        if let friendModel = model.friendCircleModel{
            friendsContentView.setModel(friendModel)
        }
        if SLPersonDataModel.sharePerson.personRole == .PARENT,SLLocalMessageHelper.shareHelper.sl_isLocalMessage(serviceId: model.serviceId ?? 1001, childId: model.childrenId ?? 0){
            redView.isHidden = false
        }
                
    }
    
    private func initUI(){
        contentView.addSubview(bgContainView)
        bgContainView.addSubview(friendsContentView)
        bgContainView.addSubview(redView)
    }
    
    func layout(){
        bgContainView.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0).priorityHigh()
        }
        
        friendsContentView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(-20)
        }
        
        redView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(0)
            make.size.equalTo(CGSize.init(width: 26, height: 29))
        }
    }
    
    lazy var friendsContentView: FriendsCircleContentView = {
        let friendsContentView = FriendsCircleContentView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 0))
        friendsContentView.headerBlock = {
            [weak self] (type)in
            guard let strongSelf = self else { return }
            strongSelf.headerBlock?(type)
        }
        return friendsContentView
    }()
}
