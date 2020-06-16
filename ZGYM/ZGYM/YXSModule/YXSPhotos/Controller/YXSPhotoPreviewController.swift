//
//  YXSPhotoPreviewController.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/5/28.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import YBImageBrowser
import NightNight

/// 查看图片/视频 页面
class YXSPhotoPreviewController: YXSBaseViewController, YBImageBrowserDataSource, YBImageBrowserDelegate {

    var dataSource: [YXSPhotoAlbumsDetailListModel] = [YXSPhotoAlbumsDetailListModel]()
    var albumModel: YXSPhotoAlbumsModel?
    
    var browserView: YBImageBrowser?
    var currentPage: Int?
    
    var updateAlbumModel: ((_ albumModel:  YXSPhotoAlbumsModel)->())?
    
    /// 当前是否展示工具栏
    var iscurrentShowTool: Bool = true
    
    var currentIndex: Int = 0
    
    init(dataSource: [YXSPhotoAlbumsDetailListModel], albumModel: YXSPhotoAlbumsModel) {
        super.init()
        self.dataSource = dataSource
        self.albumModel = albumModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fd_prefersNavigationBarHidden = true
        self.view.backgroundColor = UIColor.black
        
        view.addSubview(customNav)
        customNav.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(0)
        })
        
        view.addSubview(contentPanel)
        contentPanel.snp.makeConstraints({ (make) in
            make.top.equalTo(customNav.snp_bottom).offset(0)
            make.left.equalTo(0).offset(0)
            make.right.equalTo(0).offset(0)
        })
        
        let browser = YBImageBrowser()
        // 禁止旋转（但是若当前控制器能旋转，图片浏览器也会跟随，布局可能会错位，这种情况还待处理）
        browser.supportedOrientations = .portrait
        browser.dataSource = self
        browser.delegate = self
        
        browser.currentPage = currentPage ?? 0
        
        // 关闭入场和出场动效
        browser.defaultAnimatedTransition?.showType = .none
        browser.defaultAnimatedTransition?.hideType = .none
                
        // 删除工具视图（你可能需要自定义的工具视图，那请自己实现吧）
        browser.toolViewHandlers = []
        
        // 由于 self.view 的大小可能会变化，所以需要显式的赋值容器大小
        let size = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - YBIBStatusbarHeight() - 44 - 64)
        browser.show(to: contentPanel, containerSize: size)
        self.browserView = browser
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
            self.browserView?.currentPage = self.currentPage ?? 0
        }
        
        view.addSubview(footerView)
        footerView.snp.makeConstraints({ (make) in
            make.top.equalTo(contentPanel.snp_bottom)
            make.left.equalTo(0).offset(0)
            make.right.equalTo(0).offset(0)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                // Fallback on earlier versions
                make.bottom.equalTo(0).offset(0)
            }
            make.height.equalTo(64)
        })
        
        view.addSubview(commentView)
        commentView.snp.makeConstraints({ (make) in
            make.top.equalTo(view.snp_bottom)
            make.left.right.equalTo(0)
        })
    }
    
    // MARK: - Request
    @objc func albumQueryPraiseCommentCountRequest(page: Int) {
//        YXSEducationAlbumQueryPraiseCommentCountRequest(albumId: albumModel?.id ?? 0, classId: albumModel?.classId ?? 0, resourceId: model.id ?? 0)
        let model = dataSource[page]
        YXSEducationAlbumQueryPraiseCommentCountRequest(albumId: albumModel?.id ?? 0, classId: albumModel?.classId ?? 0, resourceId: model.id ?? 0).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            
            let praiseCount = json["praiseCount"].intValue
            let commentCount = json["commentCount"].intValue
            let praiseStat = json["praiseStat"].boolValue
            
            weakSelf.footerView.minePriseButton.isSelected = praiseStat
            weakSelf.footerView.commentButton.title = "评论(\(commentCount))"
            weakSelf.footerView.currentPriseButton.title = "\(praiseCount)"
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }

//    @objc func albumQueryCommentListRequest(page: Int) {
//        let model = dataSource[page]
//        YXSEducationAlbumQueryCommentListRequest(albumId: albumModel?.id ?? 0, classId: albumModel?.classId ?? 0, resourceId: model.id ?? 0).request({ (json) in
//
//        }) { (msg, code) in
//
//        }
//    }
    
    // MARK: - private
    private func reloadToolStatus(){
        if iscurrentShowTool{
            customNav.isHidden = false
            footerView.isHidden = false
        }else{
            customNav.isHidden = true
            footerView.isHidden = true
        }
    }
    
    private  func updateUI(){
        reloadToolStatus()
        customNav.title = "\(currentIndex + 1)/\(self.dataSource.count)"
        albumQueryPraiseCommentCountRequest(page: currentIndex)
//        let model = praisesModels[dataSource[currentIndex].id ?? 0]
//        if let model = model{
//            footerView.setModel(model: model)
//        }
    }
    
    // MARK: - Action
    @objc func praiseOrCancelClick(sender: UIButton) {
        let model = dataSource[browserView?.currentPage ?? 0]
        YXSEducationAlbumPraiseOrCancelRequest(albumId: albumModel?.id ?? 0, classId: albumModel?.classId ?? 0, resourceId: model.id ?? 0).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            let selected = json.boolValue
            let priseCount = weakSelf.footerView.currentPriseButton.title

            var count: Int = priseCount?.int ?? 0
            if selected {
                count += 1
            } else {
                count -= 1
            }
            weakSelf.footerView.currentPriseButton.title = "\(count)"

            sender.isSelected = selected
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    @objc func commentClick(sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.commentView.snp.remakeConstraints { (make) in
                make.left.right.bottom.equalTo(0)
            }
        }
    }
    
    @objc func moreClick(sender: UIButton) {
        let lists = [YXSCommonBottomParams.init(title: "保存到手机", event: "save"),YXSCommonBottomParams.init(title: "设置为封面", event: "setCover")]
        
        YXSCommonBottomAlerView.showIn(buttons: lists) { [weak self](model) in
            guard let weakSelf = self else {return}
            switch model.event {
            case "save":
                weakSelf.browserView?.currentData().yb_saveToPhotoAlbum?()
                
            case "setCover":
                let model = self?.dataSource[weakSelf.browserView?.currentPage ?? 0]
                MBProgressHUD.yxs_showLoading()
                YXSEducationAlbumUpdateAlbumNameOrCoverRequest(id: weakSelf.albumModel?.id ?? 0, classId: weakSelf.albumModel?.classId ?? 0, albumName: nil, coverUrl: model?.resourceUrl).request({ [weak self](json) in
                    guard let weakSelf = self else {return}
                    MBProgressHUD.yxs_showMessage(message: "修改成功")
                    weakSelf.albumModel?.coverUrl = model?.resourceUrl
                    weakSelf.updateAlbumModel?(weakSelf.albumModel!)
                    
                }) { (msg, code) in
                    MBProgressHUD.yxs_showMessage(message: msg)
                }

            default:
                break
            }
        }
    }
    
    
    // MARK: - Delegate
    func yb_numberOfCells(in imageBrowser: YBImageBrowser) -> Int {
        return dataSource.count
    }
    
    func yb_imageBrowser(_ imageBrowser: YBImageBrowser, dataForCellAt index: Int) -> YBIBDataProtocol {
        let model :YXSPhotoAlbumsDetailListModel = dataSource[index]
        if model.resourceType == 0 {
            /// 图片
            let data = YBIBImageData()
            data.imageURL = URL(string: model.resourceUrl ?? "")
            data.interactionProfile.disable = true
            data.singleTouchBlock = {[weak self](ybImgData)in
                guard let strongSelf = self else { return }
                strongSelf.iscurrentShowTool = !strongSelf.iscurrentShowTool
                strongSelf.reloadToolStatus()
            }
            return data
            
        } else {
            /// 视频
            let data = YBIBVideoData()
            data.videoURL = URL(string: model.resourceUrl ?? "")
            data.interactionProfile.disable = true
            data.shouldHideForkButton = true
            data.singleTouchBlock = {[weak self](ybImgData)in
                guard let strongSelf = self else { return }
                strongSelf.iscurrentShowTool = !strongSelf.iscurrentShowTool
                strongSelf.reloadToolStatus()
            }
            return data
        }
    }
    
    func yb_imageBrowser(_ imageBrowser: YBImageBrowser, pageChanged page: Int, data: YBIBDataProtocol) {
        currentIndex = page
        updateUI()
//        commentView.loadData(albumId: albumModel?.id ?? 0, classId: albumModel?.classId ?? 0, resourceId: dataSource[page].id ?? 0)
    }
    
    func yb_imageBrowser(_ imageBrowser: YBImageBrowser, respondsToLongPressWithData data: YBIBDataProtocol) {
        moreClick(sender: UIButton())
    }
    
    
    // MARK: - LazyLoad
    /// 装YB的容器
    lazy var contentPanel: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var customNav: YXSCustomNav = {
        let view = YXSCustomNav(YXSCustomStyle.backAndTitle)
        view.backgroundColor = UIColor.black
//        view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        view.backImageButton.setMixedImage(MixedImage(normal: "yxs_back_white", night: "yxs_back_white"), forState: .normal)
//        view.titleLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        view.titleLabel.textColor = UIColor.white
        return view
    }()
    
    lazy var footerView: YXSPhotoPreviewFooterView = {
        let view = YXSPhotoPreviewFooterView()
        view.backgroundColor = UIColor.black
//        view.minePriseButton.addTarget(self, action: #selector(pra), for: .touchUpInside)
        view.minePriseButton.addTarget(self, action: #selector(praiseOrCancelClick(sender:)), for: .touchUpInside)
        view.commentButton.addTarget(self, action: #selector(commentClick(sender:)), for: .touchUpInside)
        view.moreActionButton.addTarget(self, action: #selector(moreClick(sender:)), for: .touchUpInside)
        return view
    }()
    
    lazy var commentView: YXSPhotoPreviewCommentView = {
        let view = YXSPhotoPreviewCommentView()
        view.backgroundColor = UIColor.black
        view.isUserInteractionEnabled = true
        return view
    }()
    
//    lazy var browser: YBImageBrowser = {
//        let view = YBImageBrowser()
//        // 禁止旋转（但是若当前控制器能旋转，图片浏览器也会跟随，布局可能会错位，这种情况还待处理）
//        view.supportedOrientations = .portrait
//        view.dataSource = self
//        view.delegate = self
////        view.currentPage = 4
//        // 关闭入场和出场动效
//        view.defaultAnimatedTransition?.showType = .none
//        view.defaultAnimatedTransition?.hideType = .none
//
//        // 删除工具视图（你可能需要自定义的工具视图，那请自己实现吧）
//        view.toolViewHandlers = []
//        return view
//    }()

}

// MARK: -HMRouterEventProtocol
extension YXSPhotoPreviewController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:break
        }
    }
}
