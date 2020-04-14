//
//  YXSFriendsConfigHelper.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/15.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

class YXSFriendsConfigHelper: NSObject {
    public static let helper = YXSFriendsConfigHelper()
    
    public let contentFont: UIFont = UIFont.systemFont(ofSize: 14)
    public let priseFont: UIFont = UIFont.systemFont(ofSize: 13)
    public let commentFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    
    /// 优成长内容宽度
    lazy public var contentWidth: CGFloat = SCREEN_WIDTH - 28 - contentLeftMargin
    lazy public var priseWidth: CGFloat = SCREEN_WIDTH - leftGap*3 - headerIconWidth - 40
    lazy public var headerIconWidth: CGFloat = 40
    lazy public var commentWidth: CGFloat = SCREEN_WIDTH - 20 - contentLeftMargin
    lazy public var leftGap: CGFloat = 15
    
    lazy public var contentLeftMargin: CGFloat = 68
    
    lazy public var videoSize: CGSize = CGSize.init(width: 160, height: 213)
    
    // MARK: - 高度
    lazy public var nameLabelTopPadding: CGFloat = 17
    lazy public var contentTopToNameLPadding: CGFloat = 13
    
    private override init() {
        super.init()
    }
    
    
}
