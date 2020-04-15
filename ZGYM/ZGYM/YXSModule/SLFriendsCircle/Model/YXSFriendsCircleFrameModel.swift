//
//  SLFriendsCircleHeaderFrameView.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/5.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

class YXSFriendsCircleFrameModel: NSObject, NSCoding {
    var contentHeight: CGFloat!
    var contentIsShowAllHeight: CGFloat!
    
    override init() {
        super.init()
    }
    
    @objc required init(coder aDecoder: NSCoder)
    {
        
        contentHeight = aDecoder.decodeObject(forKey: "contentHeight") as? CGFloat ?? 0.0
        contentIsShowAllHeight = aDecoder.decodeObject(forKey: "contentIsShowAllHeight") as? CGFloat ?? 0.0
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if contentHeight != nil{
            aCoder.encode(contentHeight, forKey: "contentHeight")
        }
        if contentIsShowAllHeight != nil{
            aCoder.encode(contentIsShowAllHeight, forKey: "contentIsShowAllHeight")
        }
    }
}
