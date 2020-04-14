//
//  UIViewController+EmptyDataSet.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/20.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import NightNight

extension UIViewController: EmptyDataSetDelegate, EmptyDataSetSource{
    
    @objc public func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return  NightNight.theme == .night ?  UIImage.init(named: "yxs_defultImage_nodata_night") : UIImage.init(named: "yxs_defultImage_nodata")
    }
    
    @objc public func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "这里空空如也"
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: CGFloat(18)),
                          NSAttributedString.Key.foregroundColor: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")]
        return NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
    }
    
    @objc public func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -80
    }
    
    @objc public func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 28
    }
    
    @objc public func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return NightNight.theme == .night ? kNightBackgroundColor : UIColor.white
    }
    
    @objc public func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView?{
        return nil
    }
    
    
    /// - Parameter scrollView: 列表不想为空设置这个为false
    @objc public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    //empty 是否可以下拉刷新
    @objc public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    @objc public func emptyDataSetShouldBeForcedToDisplay(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    @objc public func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    @objc public func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}
