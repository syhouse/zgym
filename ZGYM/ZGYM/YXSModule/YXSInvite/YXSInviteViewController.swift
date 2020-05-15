//
//  InviteViewController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/25.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

class YXSInviteViewController: YXSBaseViewController {

    private var gradeNum: String?
    private var gradeName: String?
    private var headmasterName: String?
    private var qrCodeUrl: String?
    private var imgQRCode: UIImageView!
    init(gradeNum: String, gradeName: String, headmasterName: String) {
        super.init()
        self.gradeNum = gradeNum
        self.gradeName = gradeName
        self.headmasterName = headmasterName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
        view.addSubview(scrollView)
        if #available(iOS 11.0, *){
            scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        imgQRCode = UIImageView()
        imgQRCode.addTaget(target: self, selctor: #selector(showBigImage))
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imgBgTop)
        contentView.addSubview(imgBgBottom)
        
        contentView.addSubview(transparentTop)
        contentView.addSubview(transparentBottom)
        
        contentView.addSubview(topPanel)
        contentView.addSubview(bottomPanel)
        
        contentView.addSubview(imgConnect1)
        contentView.addSubview(imgConnect2)
        
        contentView.addSubview(btnSave)
        contentView.addSubview(btnShare)
        
        topPanel.addSubview(dottedView)
        topPanel.addSubview(lbTitle)
        topPanel.addSubview(lbClassNumber)
        topPanel.addSubview(lbClassNumberContent)
        topPanel.addSubview(btnCopy)
        topPanel.addSubview(lbNick)
        topPanel.addSubview(lbContent)
        
        bottomPanel.addSubview(imgQRCode)
        bottomPanel.addSubview(lbQRTitle1)
        bottomPanel.addSubview(lbQRTitle2)
        
        layout()
        refreshData()
        lbTitle.text = "\(headmasterName ?? "")"+"("+"\(gradeName ?? "")"+")"
        lbClassNumberContent.text = gradeNum
        
        view.addSubview(customNav)
        customNav.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }
    }
    
    @objc func topPanelLayout() {
        dottedView.snp.makeConstraints({ (make) in
            make.top.equalTo(topPanel.snp_top).offset(15)
            make.left.equalTo(topPanel.snp_left).offset(15)
            make.right.equalTo(topPanel.snp_right).offset(-15)
            make.bottom.equalTo(topPanel.snp_bottom).offset(-15)
        })
        
        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(50)
            make.left.equalTo(48)
            make.right.equalTo(-48)
        })
        
        lbClassNumber.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle.snp_bottom).offset(16)
            make.left.equalTo(lbTitle.snp_left)
        })
        
        lbClassNumberContent.snp.makeConstraints({ (make) in
            make.centerY.equalTo(lbClassNumber.snp_centerY)
            make.left.equalTo(lbClassNumber.snp_right)
        })
        
        btnCopy.snp.makeConstraints({ (make) in
            make.centerY.equalTo(lbClassNumber.snp_centerY)
            make.left.equalTo(lbClassNumberContent.snp_right).offset(18)
            make.right.equalTo(-48)
        })
        
        
        lbNick.snp.makeConstraints({ (make) in
            make.top.equalTo(lbClassNumber.snp_bottom).offset(48)
            make.left.equalTo(48)
            make.right.equalTo(-48)
        })
        
        lbContent.snp.makeConstraints({ (make) in
            make.top.equalTo(lbNick.snp_bottom).offset(21)
            make.left.equalTo(48)
            make.right.equalTo(-48)
            make.bottom.equalTo(-57)
        })
    }
    
    
    @objc func bottomPanelLayout() {
        imgQRCode.snp.makeConstraints({ (make) in
            make.top.equalTo(17)
            make.left.equalTo(62*SCREEN_SCALE)
            make.width.height.equalTo(74*SCREEN_SCALE)
            make.bottom.equalTo(-15)
        })
        
        lbQRTitle1.snp.makeConstraints({ (make) in
            make.top.equalTo(imgQRCode.snp_top).offset(17*SCREEN_SCALE)
            make.left.equalTo(imgQRCode.snp_right).offset(23*SCREEN_SCALE)
            make.right.equalTo(-48)
        })
        
        lbQRTitle2.snp.makeConstraints({ (make) in
            make.top.equalTo(lbQRTitle1.snp_bottom).offset(17*SCREEN_SCALE)
            make.left.equalTo(lbQRTitle1.snp_left)
            make.right.equalTo(-48)
        })
    }
    
    @objc func layout() {
        scrollView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }

        contentView.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
        })
        
        imgBgTop.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(364*SCREEN_SCALE)
        })
        
        topPanel.snp.makeConstraints({ (make) in
            make.top.equalTo(imgBgTop.snp_top).offset(223*SCREEN_SCALE)
            make.left.equalTo(20)
            make.right.equalTo(-20)
//            make.height.equalTo(364*SCREEN_SCALE)
        })
        topPanelLayout()
            
        transparentTop.snp.makeConstraints({ (make) in
            make.top.equalTo(topPanel.snp_top).offset(-5)
            make.left.equalTo(topPanel.snp_left).offset(-5)
            make.right.equalTo(topPanel.snp_right).offset(5)
            make.bottom.equalTo(topPanel.snp_bottom).offset(5)
        })
        
        transparentBottom.snp.makeConstraints({ (make) in
            make.top.equalTo(bottomPanel.snp_top).offset(-5)
            make.left.equalTo(bottomPanel.snp_left).offset(-5)
            make.right.equalTo(bottomPanel.snp_right).offset(5)
            make.bottom.equalTo(bottomPanel.snp_bottom).offset(5)
        })
        
        bottomPanel.snp.makeConstraints({ (make) in
            make.top.equalTo(topPanel.snp_bottom).offset(15)
            make.left.equalTo(topPanel.snp_left)
            make.right.equalTo(topPanel.snp_right)
//            make.height.equalTo(364*SCREEN_SCALE)
        })
        bottomPanelLayout()
        
        
        imgConnect1.snp.makeConstraints({ (make) in
            make.top.equalTo(topPanel.snp_bottom).offset(-12)
            make.left.equalTo(topPanel.snp_left).offset(14)
            make.width.equalTo(16)
            make.height.equalTo(41)
        })
        
        imgConnect2.snp.makeConstraints({ (make) in
            make.top.equalTo(imgConnect1.snp_top)
            make.right.equalTo(topPanel.snp_right).offset(-14)
            make.width.equalTo(16)
            make.height.equalTo(41)
        })
        
        btnSave.snp.makeConstraints({ (make) in
            make.top.equalTo(bottomPanel.snp_bottom).offset(18)
            make.left.equalTo(bottomPanel.snp_left)
            make.right.equalTo(contentView.snp_centerX).offset(-10)
            make.height.equalTo(44*SCREEN_SCALE)
        })
        
        btnShare.snp.makeConstraints({ (make) in
            make.top.equalTo(btnSave.snp_top)
            make.left.equalTo(contentView.snp_centerX).offset(10)
            make.right.equalTo(bottomPanel.snp_right)
            make.height.equalTo(btnSave.snp_height)
        })
        
        imgBgBottom.snp.makeConstraints({ (make) in
            make.top.equalTo(btnShare.snp_bottom).offset(-12)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(83*SCREEN_SCALE)
            make.bottom.equalTo(0)
        })
    }
    
    // MARK: - Request
    @objc func refreshData() {
        let model = HMRequestShareModel(gradeNum: gradeNum ?? "", gradeName: gradeName ?? "", headmasterName: headmasterName ?? "")
        MBProgressHUD.yxs_showLoading()
        YXSEducationShareLinkRequest(model: model).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_hideHUD()

            weakSelf.qrCodeUrl = json.stringValue
            weakSelf.imgQRCode.image = weakSelf.yxs_setupQRCodeImage(weakSelf.qrCodeUrl ?? "", image: nil)

        }) { (msg, code ) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Action
    @objc func saveClick(sender: YXSButton) {
        let image = screenShortWithElement(view: contentView)
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func showBigImage(){
        YXSShowBrowserHelper.showImage(images: [self.imgQRCode.image], currentIndex: 0)
    }
    
   @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {

      var showMessage = ""
      if error != nil{
         showMessage = "保存失败"
        
      }else{
         showMessage = "保存成功"
      }
      MBProgressHUD.yxs_showMessage(message: showMessage)
   }
    
    @objc func shareClick(sender: YXSButton) {
        let model = YXSShareModel(image: screenShortWithElement(view: contentView))
        YXSShareTool.showCommonShare(shareModel: model)
    }
    
    @objc func copyClick(sender: YXSButton) {
        let pastboard = UIPasteboard.general
        pastboard.string = gradeNum
        MBProgressHUD.yxs_showMessage(message: "复制成功")
    }
    
    // MARK: - Other
    
    @objc func screenShortWithElement(view:UIView)->UIImage {
        btnSave.isHidden = true
        btnShare.isHidden = true
        UIGraphicsBeginImageContext(view.size)
        UIGraphicsBeginImageContextWithOptions(view.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        btnSave.isHidden = false
        btnShare.isHidden = false
        return image!
    }

    // MARK: - LazyLoad
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = false
        scrollView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9")
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#4E87FF")
        return view
    }()
    
    lazy var imgBgTop: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "yxs_invite_bg_top")
        return img
    }()
    
    lazy var imgBgBottom: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "yxs_invite_bg_bottom")
        return img
    }()
    
    lazy var topPanel: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.cornerRadius = 10
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var dottedView: YXSDottedView = {
        let view = YXSDottedView()
        return view
    }()
    
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.font = UIFont.systemFont(ofSize: 18)
        lb.textColor = kTextMainBodyColor
        return lb
    }()
    
    lazy var lbClassNumber: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "班级号："
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return lb
    }()
    
    lazy var lbClassNumberContent: YXSLabel = {
        let lb = YXSLabel()
        lb.font = UIFont.systemFont(ofSize: 19)
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")
        return lb
    }()
    
    lazy var lbNick: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "亲爱的家长/老师，您好！"
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    lazy var lbContent: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "    为了确保每位家长都可以及时查看老师发的消息，我们现在使用“优学业”APP作为家校沟通的工具。\n    老师发的消息不会被刷屏，及时了解孩子班级动态。"
        lb.numberOfLines = 0
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var imgConnect1: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "yxs_invite_aaa")
        return img
    }()
    
    lazy var imgConnect2: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "yxs_invite_aaa")
        return img
    }()
    
//    lazy var imgQRCode: UIImageView = {
//        let img = UIImageView()
//        return img
//    }()
    
    lazy var lbQRTitle1: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "扫描或识别二维码"
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbQRTitle2: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "加入班级"
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var btnCopy: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("复制", for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        btn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setImage(UIImage(named: "yxs_invite_copy"), for: .normal)
        btn.addTarget(self, action: #selector(copyClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var bottomPanel: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.cornerRadius = 10
        view.backgroundColor = UIColor.white
        return view
    }()
    
    /// 透明边框
    lazy var transparentTop: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.cornerRadius = 10
        view.backgroundColor = UIColor.white
        view.alpha = 0.2
        return view
    }()
    
    
    
    /// 透明边框
    lazy var transparentBottom: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.cornerRadius = 10
        view.backgroundColor = UIColor.white
        view.alpha = 0.2
        return view
    }()
    
    lazy var btnSave: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("保存到手机", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F4BE63")
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(saveClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnShare: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("分享二维码", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#89DBFD")
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(shareClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var customNav: YXSCustomNav = {
        let customNav = YXSCustomNav()
        customNav.leftImage = "yxs_back_white"
        customNav.title = "邀请成员加入班级"
        
        customNav.titleLabel.textColor = UIColor.white
        customNav.hasRightButton = false
        return customNav
    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: -HMRouterEventProtocol
extension YXSInviteViewController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:break
        }
    }
}
