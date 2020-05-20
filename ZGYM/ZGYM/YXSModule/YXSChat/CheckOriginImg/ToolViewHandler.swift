//
//  ToolViewHandler.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/5/19.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import YBImageBrowser

class ToolViewHandler: YBIBToolViewHandler {

    /**
    容器视图准备好了，可进行子视图的添加和布局
    */
    override func yb_containerViewIsReadied() {
        yb_containerView?.addSubview(viewOriginButton)
        let size = yb_containerSize(yb_currentOrientation())
        viewOriginButton.center = CGPoint(x: size.width/2.0, y: size.height-80)
    }
    
    /**
     隐藏视图

     @param hide 是否隐藏
     */
    override func yb_hide(_ hide: Bool) {
//        YBIBImageData *data = self.yb_currentData();
//        if (hide || !data.extraData) {
//            self.viewOriginButton.hidden = YES;
//        } else {
//            self.viewOriginButton.hidden = NO;
//        }
        
        let data = yb_currentData() as? YBIBImageData
        if hide || data?.extraData != nil {
            viewOriginButton.isHidden = true
        } else {
            viewOriginButton.isHidden = false
        }
    }
    

    override func yb_pageChanged() {
        
        // 拿到当前的数据对象（此案例都是图片）
        let data = yb_currentData() as? YBIBImageData
        // 有原图就显示按钮
        viewOriginButton.isHidden = data?.extraData != nil
        viewOriginButton.setTitle("查看原图", for: .normal)
        updateViewOriginButtonSize()
    }

    override func yb_orientationDidChanged(with orientation: UIDeviceOrientation) {

    }
        
    // MARK: - Action
    @objc func clickViewOriginButton(button:UIButton) {
            
    }
    
    // MARK: -  private

    func updateViewOriginButtonSize() {
        let size = viewOriginButton.intrinsicContentSize
        viewOriginButton.bounds = CGRect(x: 0, y: 0, width: size.width + 15, height: size.height)
    }
    
    // MARK: - LazyLoad
    lazy var viewOriginButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.gray.withAlphaComponent(0.75)
        btn.cornerRadius = 5.0
        btn.addTarget(self, action: #selector(clickViewOriginButton(button:)), for: .touchUpInside)
        return btn
    }()
}
