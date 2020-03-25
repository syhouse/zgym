//
//  SLFriendsCommentView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/13.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit

let kYMFriendsCommentView = "SLFriendsCommentView"

class SLFriendsCommentView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(commentField)
        commentField.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var commentField: UITextField = {
        let commentField = UITextField()
        return commentField
    }()
}

extension SLFriendsCommentView: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.isHidden = true
        sl_routerEventWithName(eventName: kYMFriendsCommentView)
    }
}
