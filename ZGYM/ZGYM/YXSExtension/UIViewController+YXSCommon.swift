//
//  UIViewController+Common.swift
//  EsayFreeBook
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019 mac_sy. All rights reserved.
//

import UIKit
import NightNight

extension UIViewController{
    @discardableResult func yxs_setNavBack() -> YXSButton {
        return yxs_setNavBack(mixImage: MixedImage(normal: "back", night: "yxs_back_white"))
    }
    
    
    @discardableResult func yxs_setNavBack(mixImage: MixedImage) -> YXSButton {
        navigationItem.leftBarButtonItem = nil
        let button = YXSButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        button.setTitleColor(UIColor.white, for: .normal)
        button.setMixedImage(mixImage, forState: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -35, bottom: 0, right: 0)
        let leftItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = leftItem
        button.addTarget(self, action: #selector(yxs_onBackClick), for: .touchUpInside)
        return button
    }
    
    @discardableResult func yxs_setNavBack(backImageS: String, nightImgeS: String?  = nil) -> YXSButton {
        if let nightImgeS = nightImgeS{
            yxs_setNavBack(mixImage: MixedImage(normal: backImageS, night: nightImgeS))
        }
        return yxs_setNavBack(mixImage: MixedImage(normal: backImageS, night: backImageS))
    }
    
    @discardableResult func yxs_setRightButton(title: String?, titleColor:UIColor = UIColor.black) -> YXSButton {
        navigationItem.rightBarButtonItem = nil
        let button = YXSButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        button.setTitleColor(titleColor, for: .normal)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
        let rightItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = rightItem
        return button
    }
    
    @discardableResult func yxs_setRightButton(image: String?) -> YXSButton {
        let imageStr:String = image ?? ""
        return yxs_setRightButton(mixedImage: MixedImage(normal: imageStr, night: imageStr))
    }
    
    @discardableResult func yxs_setRightButton(mixedImage: MixedImage) -> YXSButton {
        navigationItem.rightBarButtonItem = nil
        let button = YXSButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        button.setMixedImage(mixedImage, forState: .normal)
        let rightItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = rightItem
        return button
    }
    
    @discardableResult func yxs_setNavLeftTitle(title: String?) -> YXSButton {
        navigationItem.leftBarButtonItem = nil
        let button = YXSButton(frame: CGRect(x: 0, y: 0, width: 30 + (title?.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
        ]).width ?? 0.0), height: 40))
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle(title, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        let leftItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = leftItem
        button.addTarget(self, action: #selector(yxs_onBackClick), for: .touchUpInside)
        return button
    }
    
    @discardableResult func yxs_setNavImageBackWithTitle(_ title: String?, image: String = "arrow_back", textColor: UIColor = UIColor.black) -> YXSButton{
        navigationItem.leftBarButtonItem = nil
        let button = YXSButton(frame: CGRect(x: 0, y: 0, width: 60 + (title?.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
        ]).width ?? 0.0), height: 40))
        button.setTitleColor(textColor, for: .normal)
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(named: image), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        let leftItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = leftItem
        button.addTarget(self, action: #selector(yxs_onBackClick), for: .touchUpInside)
        return button
    }
    
    
    @objc func yxs_onBackClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //    @objc func pushLoginVc(sucess: (() -> ())? = nil){
    //        let vc = YXSLoginViewController()
    //        vc.loginSucess = sucess
    //        let nav = SYRootNavController(rootViewController: vc)
    //        nav.modalPresentationStyle = .fullScreen
    //        UIUtil.RootController()?.present(nav, animated: true, completion: nil)
    //    }
    
    public func yxs_showTabRoot(){
        let appdelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//        DispatchQueue.main.async {
//            appdelegate?.showTabRoot()
//        }
        appdelegate?.showTabRoot()
    }
}

// MARK: -push
extension UIViewController{
    func yxs_pushHomeDetailVC(homeModel: YXSHomeListModel){
//        if homeModel.commitState == 2 && YXSPersonDataModel.sharePerson.personRole == .PARENT{
//            let vc = YXSHomeworkCommitDetailViewController()
//            vc.homeModel = homeModel
//            navigationController?.pushViewController(vc)
//        }else{
            let vc = YXSHomeworkDetailViewController.init(model: homeModel)
            navigationController?.pushViewController(vc)
//        }
    }
}

// MARK: -Chat
extension UIViewController{
    /// 通过imId打开腾讯单聊会话
    func yxs_pushChatVC(imId: String){
        let conv = TIMManager.sharedInstance()?.getConversation(TIMConversationType.C2C, receiver: imId)
        let vc = YXSChatViewController(conversation: conv)!
        self.navigationController?.pushViewController(vc)
    }
}


extension UIViewController{
    func yxs_loadPublishClassListData(_ isFriendSelectClass: Bool,compelect:((_ classs:[YXSClassModel]) -> ())?){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let requset = YXSEducationClassOptionalGradeListRequest()
        requset.requestCollection({ (classs:[YXSClassModel]) in
            compelect?(classs)
            MBProgressHUD.hide(for: self.view, animated: true)
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast("\(msg)")
        }
    }
}
