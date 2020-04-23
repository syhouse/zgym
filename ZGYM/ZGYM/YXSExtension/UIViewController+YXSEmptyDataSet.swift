//
//  UIViewController+EmptyDataSet.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/20.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import NightNight

///空白视图拓展 子类重写
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
    // MARK: 按钮标题
    @objc public func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        return nil
    }
    // MARK: 按钮图片
    @objc public func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return nil
    }
    // MARK: 按钮背景图片
    @objc public func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return nil
    }
    // MARK: 按钮点击事件
    @objc public func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        
    }
    
    
    // MARK: 空白视图偏移
    @objc public func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -80
    }
    // MARK: 图片和文字/按钮 的间距
    @objc public func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 28
    }
    
    @objc public func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return NightNight.theme == .night ? kNightBackgroundColor : UIColor.white
    }
    
    // MARK: 图片and文字不满足需求 可使用自定义视图
    @objc public func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView?{
        return nil
    }
    
    // MARK: -列表不想为空设置这个为false
    /// - Parameter scrollView: 列表不想为空设置这个为false
    @objc public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    // MARK: -empty 是否可以下拉刷新 默认false
    @objc public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    // MARK: -empty 是否强制一直展示
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
