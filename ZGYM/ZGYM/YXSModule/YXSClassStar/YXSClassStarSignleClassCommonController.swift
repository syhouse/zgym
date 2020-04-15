//
//  YXSClassStarSignleClassCommonController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/9.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import FDFullscreenPopGesture_Bell
import NightNight

class YXSClassStarSignleClassCommonController: YXSBaseTableViewController {
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        
        view.addSubview(customNav)
        customNav.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }
        customNav.addSubview(rightControl)
        
        rightControl.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(customNav.backImageButton)
            make.height.equalTo(44)
        }

        rightControl.addTarget(self, action: #selector(rightDropClick), for: .touchUpInside)
        view.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#D1E4FF")
        tableView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#D1E4FF")
    }
    
    var selectModels:[YXSSelectModel] = [YXSSelectModel.init(text: "按日", isSelect: false, paramsKey: DateType.D.rawValue),YXSSelectModel.init(text: "按周", isSelect: true, paramsKey: DateType.W.rawValue),YXSSelectModel.init(text: "按月", isSelect: false, paramsKey: DateType.M.rawValue),YXSSelectModel.init(text: "按年", isSelect: false, paramsKey: DateType.Y.rawValue)]
    var selectModel:YXSSelectModel = YXSSelectModel.init(text: "按周", isSelect: true, paramsKey: DateType.W.rawValue)
    @objc func rightDropClick(){
        YXSHomeListSelectView.showAlert(offset: CGPoint.init(x: 8, y: 58 + kSafeTopHeight), selects: selectModels) { [weak self](selectModel,selectModels) in
            guard let strongSelf = self else { return }
            strongSelf.selectModels = selectModels
            strongSelf.selectModel = selectModel
            strongSelf.rightControl.title = selectModel.text
            strongSelf.uploadData()
            strongSelf.tableView.scrollToTop()
        }
    }
    
    // MARK: -UI

    // MARK: -loadData
    
    func loadData(){
//        YXSEducationClassStarChildrenScoreDetailRequest.init(classId: classId).request({ (result) in
//        }) { (msg, code) in
//
//        }
    }
    func uploadData(){
        
    }
    
    // MARK: -action

    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate

    // MARK: - getter&stter
    
    lazy var customNav: YXSCustomNav = {
        let customNav = YXSCustomNav()
        customNav.leftImage = "yxs_back_white"
        customNav.titleLabel.textColor = UIColor.white
        customNav.hasRightButton = false
        return customNav
    }()
    

    lazy var rightControl: YXSCustomImageControl = {
        let rightControl = YXSCustomImageControl.init(imageSize: CGSize.init(width: 13.5, height: 8.5), position: YXSImagePositionType.right, padding: 7.5)
        rightControl.textColor = UIColor.white
        rightControl.locailImage = "yxs_classstar_down"
        rightControl.title = "按周"
        return rightControl
    }()
}

extension YXSClassStarSignleClassCommonController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > kSafeTopHeight + 64{
            customNav.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
            customNav.backImageButton.setMixedImage(MixedImage(normal: "back", night: "yxs_back_white"), forState: .normal)
            customNav.titleLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
            rightControl.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white)
            rightControl.mixedImage = MixedImage(normal: "yxs_classstar_down_gray", night: "yxs_classstar_down")
        }else{
            customNav.mixedBackgroundColor = MixedColor(normal: UIColor.clear, night: UIColor.clear)
            customNav.backImageButton.setMixedImage(MixedImage(normal: "yxs_back_white", night: "yxs_back_white"), forState: .normal)
            customNav.titleLabel.mixedTextColor = MixedColor(normal: UIColor.white, night: UIColor.white)
            
            rightControl.mixedTextColor = MixedColor(normal: UIColor.white, night: UIColor.white)
            rightControl.mixedImage = MixedImage(normal: "yxs_classstar_down", night: "yxs_classstar_down")
        }
    }
}

// MARK: -HMRouterEventProtocol
extension YXSClassStarSignleClassCommonController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:
            break
        }
    }
}


